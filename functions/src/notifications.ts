import * as functions from "firebase-functions/v2";
import * as admin from "firebase-admin";
import { createClient, SupabaseClient } from "@supabase/supabase-js";

// ─────────────────────────────────────────────
// TYPES
// ─────────────────────────────────────────────

type AbsenceTier = {
  hours: number;
  tier: string;
  title: string;
  body: string;
};

type PetRow = {
  energy: number | null;
  current_mood: string | null;
  streak: number | null;
  last_interacted_at: string | null;
};

type TargetUser = {
  id: string;
  fcm_token: string | null;
  timezone: string | null;
  last_notified_at: string | null;
  pet: PetRow[] | PetRow | null;
};

// ─────────────────────────────────────────────
// ENV HELPER
// ─────────────────────────────────────────────

function getEnv(name: string): string {
  const value = process.env[name];
  if (!value) {
    throw new Error(`Missing required environment variable: ${name}`);
  }
  return value;
}

// ─────────────────────────────────────────────
// LAZY SUPABASE CLIENT
// Không khởi tạo ở top-level — tránh crash khi emulator load module
// trước khi env vars được inject
// ─────────────────────────────────────────────

let _supabase: SupabaseClient | null = null;

function getSupabase(): SupabaseClient {
  if (!_supabase) {
    _supabase = createClient(
      getEnv("SUPABASE_URL"),
      getEnv("SUPABASE_SERVICE_ROLE_KEY"),
    );
  }
  return _supabase;
}

// ─────────────────────────────────────────────
// NOTIFICATION COPY
// ─────────────────────────────────────────────

const ABSENCE_TIERS: AbsenceTier[] = [
  {
    hours: 48,
    tier: "48h",
    title: "Lumni nhớ bạn lắm rồi 😔",
    body: "2 ngày rồi... Lumni đang rất cần bạn.",
  },
  {
    hours: 24,
    tier: "24h",
    title: "Lumni buồn cả ngày hôm nay 🥺",
    body: "Cả ngày không thấy bạn, Lumni đang ngồi một mình.",
  },
  {
    hours: 12,
    tier: "12h",
    title: "Lumni bắt đầu nhớ bạn 😔",
    body: "Lumni đang ngồi một mình, bạn có muốn ghé chơi không?",
  },
  {
    hours: 4,
    tier: "4h",
    title: "Lumni đang chờ bạn 🐾",
    body: "Lâu rồi không thấy bạn, Lumni muốn chào một cái!",
  },
];

const MOOD_OVERRIDE: Record<string, { title: string; body: string }> = {
  sad: {
    title: "Lumni đang buồn 🥺",
    body: "Lumni cần bạn lúc này... Ghé thăm một chút nhé!",
  },
  sleep: {
    title: "Lumni đang ngủ li bì 😴",
    body: "Lumni ngủ vì nhớ bạn quá... Gọi dậy chơi thôi!",
  },
};

// ─────────────────────────────────────────────
// HELPERS
// ─────────────────────────────────────────────

function isQuietHours(now: Date, timezone?: string | null): boolean {
  const hour = parseInt(
    new Intl.DateTimeFormat("en", {
      hour: "numeric",
      hour12: false,
      timeZone: timezone ?? "Asia/Singapore",
    }).format(now),
    10,
  );
  return hour >= 22 || hour < 8;
}

async function processSingleUser(
  user: TargetUser,
  now: Date,
): Promise<"sent" | "skipped" | "error"> {
  const supabase = getSupabase();

  try {
    // 1. Quiet hours check
    if (isQuietHours(now, user.timezone)) return "skipped";

    // 2. Normalize pet (join trả về array hoặc object tuỳ Supabase version)
    const pet = Array.isArray(user.pet) ? user.pet[0] : user.pet;
    if (!pet?.last_interacted_at || !user.fcm_token) return "skipped";

    // 3. Tính hours vắng mặt
    const lastSeen = new Date(pet.last_interacted_at);
    if (Number.isNaN(lastSeen.getTime())) return "skipped";
    const hoursGap = (now.getTime() - lastSeen.getTime()) / 3600_000;

    // 4. Tìm tier phù hợp
    const tier = ABSENCE_TIERS.find((t) => hoursGap >= t.hours);
    if (!tier) return "skipped";

    // 5. Quyết định copy:
    //    - Tier thấp (< 24h) + mood đặc biệt → override bằng mood copy
    //    - Tier cao (≥ 24h) → luôn dùng tier copy (urgent hơn)
    const moodOverride =
      hoursGap < 24 && pet.current_mood ?
        MOOD_OVERRIDE[pet.current_mood] ?? null :
        null;
    const copy = moodOverride ?? tier;

    // 6. Thêm streak context nếu có
    const streak = pet.streak ?? 0;
    const body =
      streak > 1 ? `${copy.body} (Streak ${streak} ngày 🔥)` : copy.body;

    // 7. Gửi qua FCM Admin SDK
    await admin.messaging().send({
      token: user.fcm_token,
      notification: { title: copy.title, body },
      data: {
        type: "pet_mood",
        tier: tier.tier,
        mood: pet.current_mood ?? "unknown",
        energy: String(pet.energy ?? 0),
      },
      android: { priority: "high" },
      apns: { payload: { aps: { "content-available": 1 } } },
    });

    // 8. Update last_notified_at — chống spam
    await supabase
      .from("user_profile")
      .update({ last_notified_at: now.toISOString() })
      .eq("id", user.id);

    // 9. Log thành công
    await supabase.from("notif_logs").insert({
      user_id: user.id,
      type: "pet_mood",
      tier: tier.tier,
      mood: pet.current_mood,
      success: true,
    });

    return "sent";
  } catch (err) {
    console.error(`[PetNotif] Failed for user ${user.id}:`, err);

    // Log thất bại — không throw để không block các user khác
    await getSupabase().from("notif_logs").insert({
      user_id: user.id,
      type: "pet_mood",
      success: false,
    });

    return "error";
  }
}

// ─────────────────────────────────────────────
// SCHEDULED FUNCTION — mỗi giờ, Singapore region
// ─────────────────────────────────────────────

export const sendPetNotifications = functions.scheduler.onSchedule(
  {
    schedule: "every 60 minutes",
    timeZone: "Asia/Singapore",
    region: "asia-southeast1",
  },
  async () => {
    const supabase = getSupabase();
    const now = new Date();
    const fourHoursAgo = new Date(
      now.getTime() - 4 * 3600_000,
    ).toISOString();

    // Query users đủ điều kiện:
    // - notif_enabled = true
    // - có fcm_token
    // - chưa được notify trong 4h gần nhất (chống spam)
    const { data: targets, error } = await supabase
      .from("user_profile")
      .select(`
        id,
        fcm_token,
        timezone,
        last_notified_at,
        pet!inner (
          energy,
          current_mood,
          streak,
          last_interacted_at
        )
      `)
      .eq("notif_enabled", true)
      .not("fcm_token", "is", null)
      .or(
        `last_notified_at.is.null,last_notified_at.lt.${fourHoursAgo}`,
      );

    if (error) {
      console.error("[PetNotif] Query error:", error);
      return;
    }

    const users = (targets ?? []) as TargetUser[];
    console.log(`[PetNotif] Processing ${users.length} users`);

    // Xử lý tuần tự để tránh rate limit FCM
    let sent = 0;
    let skipped = 0;
    let errors = 0;

    for (const user of users) {
      const result = await processSingleUser(user, now);
      if (result === "sent") sent++;
      else if (result === "skipped") skipped++;
      else errors++;
    }

    console.log(
      `[PetNotif] Done — sent: ${sent}, skipped: ${skipped}, errors: ${errors}, total: ${users.length}`,
    );
  },
);
