// =============================================================================
// NOTE ANALYSIS FUNCTION
// =============================================================================

import { createClient } from "@supabase/supabase-js";
import { onRequest } from "firebase-functions/v2/https";

export const analyzeNote = onRequest(
  {
    region: "asia-southeast1",
    secrets: [
      "SUPABASE_URL",
      "SUPABASE_SERVICE_KEY",
      "OPENAI_API_KEY",
      "CLOUD_FUNCTION_SECRET",
    ],
  },
  async (req, res) => {
    // [1] Verify secret
    const authHeader = req.headers.authorization;
    const secret = process.env.CLOUD_FUNCTION_SECRET;
    if (authHeader !== `Bearer ${secret}`) {
      res.status(401).json({ error: "Unauthorized" });
      return;
    }

    const { note_id, user_id, text_content } = req.body;
    if (!note_id || !user_id || !text_content) {
      res.status(400).json({ error: "Missing required fields" });
      return;
    }

    const supabase = createClient(
      process.env.SUPABASE_URL ?? "",
      process.env.SUPABASE_SERVICE_KEY ?? ""
    );

    try {
      // [2] Lấy tone gần nhất
      const { data: lastAnalysis } = await supabase
        .from("note_analysis")
        .select("current_tone_predict")
        .eq("user_id", user_id)
        .order("analyzed_at", { ascending: false })
        .order("id", { ascending: false })
        .limit(1)
        .maybeSingle();

      const lastTone = lastAnalysis?.current_tone_predict ?? "neutral";
      // [3] Gọi OpenAI
      const openAiResult = await analyzeToneWithOpenAI({
        text: text_content,
        last_tone: lastTone,
      });
      // [4] INSERT vào note_analysis
      const { error: insertError } = await supabase
        .from("note_analysis")
        .insert({
          note_id: note_id,
          user_id: user_id,
          last_user_tone: lastTone,
          current_tone_predict: openAiResult.tone,
          tone_repeat: openAiResult.tone === lastTone,
          level: openAiResult.level,
          raw_llm_response: JSON.stringify(openAiResult.raw),
        });

      if (insertError) throw insertError;

      // [5] UPDATE user_emotional_trend
      await updateEmotionalTrend(supabase, user_id, openAiResult.tone);

      // [6] Lấy pet_id của user
      const { data: petRow, error: petError } = await supabase
        .from("pet")
        .select("id")
        .eq("user_id", user_id)
        .single();

      if (petError || !petRow) {
        // Pet chưa tồn tại — không phải lỗi critical, bỏ qua
        console.warn(`⚠️ Pet not found for user ${user_id}`);
      } else {
        // [7] Update pet mood dựa trên analysis mới
        // last_interacted_at sẽ được set = NOW() trong update_pet_on_resume
        // Flutter sẽ dùng giá trị này để biết Cloud Function vừa update
        const { error: rpcError } = await supabase.rpc("update_pet_on_resume", {
          p_pet_id: petRow.id,
          p_user_id: user_id,
        });

        if (rpcError) {
          console.error("❌ update_pet_on_resume error:", rpcError);
        } else {
          console.log(`🐾 Pet mood updated for user ${user_id}`);
        }
      }

      console.log(`✅ note ${note_id}: tone=${openAiResult.tone}, level=${openAiResult.level}`);
      res.status(200).json({ success: true });
    } catch (err) {
      console.error("❌ analyzeNote error:", err);
      res.status(500).json({ error: String(err) });
    }
  }
);

async function analyzeToneWithOpenAI(input: {
  text: string;
  last_tone: string;
}): Promise<{ tone: string; level: number; raw: object }> {
  const response = await fetch("https://api.openai.com/v1/chat/completions", {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
      "Authorization": `Bearer ${process.env.OPENAI_API_KEY}`,
    },
    body: JSON.stringify({
      model: "gpt-4o-mini",
      response_format: { type: "json_object" },
      messages: [
        {
          role: "system",
          content: `Bạn là AI chuyên phân tích cảm xúc trong văn bản tiếng Việt và tiếng Anh.
Trả về JSON với format (không thêm text nào khác):  
{
  "tone": "<one of: happy| neutral|  sad| anxious| angry>",
  "level": <integer 1-5>
}`,
        },
        {
          role: "user",
          content: `Tone trước: ${input.last_tone}\nText: "${input.text}"`,
        },
      ],
    }),
  });

  if (!response.ok) {
    throw new Error(`OpenAI error: ${response.status}`);
  }

  const result = await response.json();
  const content = result.choices?.[0]?.message?.content;
  if (!content) throw new Error("OpenAI empty response");

  const parsed = JSON.parse(content);
  const validTones = ["happy", "neutral", "sad", "anxious", "angry"];
  const tone = validTones.includes(parsed.tone) ? parsed.tone : "neutral";
  const level = Math.min(5, Math.max(1, parseInt(parsed.level) || 1));

  return { tone, level, raw: result };
}

async function updateEmotionalTrend(
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  supabase: any,
  userId: string,
  newTone: string
): Promise<void> {
  const { data: existing } = await supabase
    .from("user_emotional_trend")
    .select("tone_history_7d")
    .eq("user_id", userId)
    .maybeSingle();

  const history: string[] = existing?.tone_history_7d ?? [];
  const updated = [...history, newTone].slice(-7);

  await supabase
    .from("user_emotional_trend")
    .upsert(
      {
        user_id: userId,
        tone_history_7d: updated,
        dominant_tone: getDominantTone(updated),
        emotional_trend: calculateTrend(updated),
        emotional_momentum: calculateMomentum(updated),
        updated_at: new Date().toISOString(),
      },
      { onConflict: "user_id" }
    );
}

function getDominantTone(history: string[]): string {
  if (history.length === 0) return "neutral";
  const count = history.reduce((acc, tone) => {
    acc[tone] = (acc[tone] ?? 0) + 1;
    return acc;
  }, {} as Record<string, number>);
  return Object.entries(count).sort((a, b) => b[1] - a[1])[0][0];
}

function calculateTrend(history: string[]): string {
  const positives = ["happy"];
  const negatives = ["sad", "anxious", "angry"];
  if (history.length < 2) return "stable";
  const recent = history.slice(-3);
  const posCount = recent.filter((t) => positives.includes(t)).length;
  const negCount = recent.filter((t) => negatives.includes(t)).length;
  if (posCount >= 2) return "improving";
  if (negCount >= 2) return "declining";
  if (new Set(recent).size === recent.length) return "volatile";
  return "stable";
}

function calculateMomentum(history: string[]): number {
  const positives = ["happy"];
  const negatives = ["sad", "anxious", "angry"];
  if (history.length === 0) return 0;
  const score = history.reduce((acc, tone) => {
    if (positives.includes(tone)) return acc + 1;
    if (negatives.includes(tone)) return acc - 1;
    return acc;
  }, 0);
  return Math.max(-1, Math.min(1, score / history.length));
}
