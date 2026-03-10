-- ════════════════════════════════════════════════════════════════════
-- HELPER: Energy Decay theo Pet Behavior Engine doc
-- E(t) = E₀ × e^(-λt) + circadian + noise
-- ════════════════════════════════════════════════════════════════════
CREATE OR REPLACE FUNCTION calculate_energy_decay(
  p_baseline_energy  FLOAT8,
  p_current_energy   FLOAT8,
  p_delta_t          FLOAT8,   -- seconds
  p_hour             INT       -- giờ thực 0-23 (UTC+7)
)
RETURNS FLOAT8 AS $$
DECLARE
  v_lambda      FLOAT8;
  v_delta_hours FLOAT8;
  v_circadian   FLOAT8;
  v_noise       FLOAT8;
  v_new_energy  FLOAT8;
BEGIN
  v_delta_hours := p_delta_t / 3600.0;

  -- λ theo personality (baseline_energy)
  v_lambda := CASE
    WHEN p_baseline_energy < 0.33  THEN 0.035   -- Lazy
    WHEN p_baseline_energy <= 0.67 THEN 0.020   -- Calm
    ELSE                                0.010   -- Hyper
  END;

  -- Circadian rhythm
  v_circadian := CASE
    WHEN p_hour BETWEEN 0  AND 5  THEN -0.28
    WHEN p_hour BETWEEN 6  AND 8  THEN  0.12
    WHEN p_hour BETWEEN 9  AND 11 THEN  0.05
    WHEN p_hour BETWEEN 12 AND 14 THEN -0.18
    WHEN p_hour BETWEEN 15 AND 17 THEN  0.10
    WHEN p_hour BETWEEN 18 AND 20 THEN  0.15
    WHEN p_hour BETWEEN 21 AND 23 THEN -0.12
    ELSE 0.0
  END;

  -- Gaussian noise (Box-Muller, std=0.05)
  v_noise := 0.05 * sqrt(-2.0 * ln(NULLIF(random(), 0)))
                  * cos(2.0 * pi() * random());

  -- Công thức chính
  v_new_energy := p_baseline_energy * exp(-v_lambda * v_delta_hours)
                  + v_circadian
                  + v_noise;

  RETURN GREATEST(0.0, LEAST(1.0, v_new_energy));
END;
$$ LANGUAGE plpgsql;


-- ════════════════════════════════════════════════════════════════════
-- HELPER: Map energy + user context → pet_mood
-- Dựa theo Behavior Weight Factors trong doc
-- ════════════════════════════════════════════════════════════════════
CREATE OR REPLACE FUNCTION resolve_pet_mood(
  p_energy          FLOAT8,
  p_baseline_energy FLOAT8,
  p_user_tone       user_tone,        -- từ note_analysis.last_user_tone
  p_trend           emotional_trend,  -- từ user_emotional_trend
  p_severity        INT,              -- từ note_analysis.level (1-5)
  p_delta_hours     FLOAT8,
  p_streak          INT
)
RETURNS pet_mood AS $$
DECLARE
  v_energy_ratio FLOAT8;
BEGIN
  v_energy_ratio := p_energy / NULLIF(p_baseline_energy, 0);

  -- ── Healing Override: ưu tiên cao nhất ──────────────────────────
  -- Khi user rất buồn/lo lắng & severity cao → pet comfort
  IF p_user_tone IN ('very_sad', 'anxious') AND p_severity >= 4 THEN
    RETURN 'sad';  -- pet buồn cùng để an ủi
  END IF;

  -- ── User tone reactions ──────────────────────────────────────────
  IF p_user_tone IN ('very_sad', 'sad') THEN
    RETURN 'sad';
  END IF;

  IF p_user_tone = 'angry' THEN
    RETURN 'idle';  -- pet né tránh, đứng im
  END IF;

  -- ── Bị bỏ rơi lâu ───────────────────────────────────────────────
  IF p_delta_hours > 48 THEN
    RETURN 'sad';   -- lookAway → map sang sad vì pet_mood không có lookAway
  END IF;

  -- ── Energy-based mood ────────────────────────────────────────────
  IF p_energy < 0.20 THEN
    RETURN 'sleep';
  END IF;

  IF p_energy < 0.40 THEN
    RETURN 'tired';
  END IF;

  -- ── Trend-based ──────────────────────────────────────────────────
  IF p_trend = 'declining' THEN
    RETURN 'sad';
  END IF;

  -- ── Happy conditions ─────────────────────────────────────────────
  IF p_user_tone IN ('happy', 'very_happy')
     AND p_energy >= 0.60
     AND p_streak >= 3 THEN
    RETURN 'happy';
  END IF;

  -- ── Default: idle ────────────────────────────────────────────────
  RETURN 'idle';
END;
$$ LANGUAGE plpgsql IMMUTABLE;


-- ════════════════════════════════════════════════════════════════════
-- MAIN RPC: update_pet_on_resume
-- Gọi mỗi khi app resume — atomic, security definer
-- ════════════════════════════════════════════════════════════════════
CREATE OR REPLACE FUNCTION update_pet_on_resume(
  p_pet_id  TEXT,
  p_user_id TEXT
)
RETURNS JSONB AS $$
DECLARE
  v_pet              pet%ROWTYPE;
  v_trend_row        user_emotional_trend%ROWTYPE;
  v_analysis_row     note_analysis%ROWTYPE;

  v_now              TIMESTAMPTZ := NOW();
  v_now_vn           TIMESTAMPTZ;
  v_hour_vn          INT;
  v_today_vn         DATE;
  v_last_date_vn     DATE;

  v_delta_t          FLOAT8;
  v_delta_hours      FLOAT8;
  v_days_diff        INT;

  v_new_energy       FLOAT8;
  v_new_mood         pet_mood;
  v_new_streak       INT;
  v_new_visit_count  INT;

  v_user_tone        user_tone;
  v_trend            emotional_trend;
  v_severity         INT;

  v_streak_changed   BOOLEAN := FALSE;
  v_is_first_today   BOOLEAN := FALSE;
BEGIN

  -- ── [1] Security: lấy pet của đúng user ─────────────────────────
  SELECT * INTO v_pet
  FROM pet
  WHERE id = p_pet_id AND user_id = p_user_id;

  IF NOT FOUND THEN
    RAISE EXCEPTION 'Pet not found or unauthorized: pet_id=%, user_id=%',
      p_pet_id, p_user_id;
  END IF;

  -- ── [2] Timezone & thời gian ─────────────────────────────────────
  v_now_vn       := v_now AT TIME ZONE 'Asia/Ho_Chi_Minh';
  v_hour_vn      := EXTRACT(HOUR FROM v_now_vn)::INT;
  v_today_vn     := DATE(v_now_vn);
  v_last_date_vn := DATE(v_pet.last_interacted_at AT TIME ZONE 'Asia/Ho_Chi_Minh');

  v_delta_t      := EXTRACT(EPOCH FROM (v_now - v_pet.last_interacted_at));
  v_delta_hours  := v_delta_t / 3600.0;
  v_days_diff    := (v_today_vn - v_last_date_vn)::INT;

  -- ── [3] Streak logic ─────────────────────────────────────────────
  CASE v_days_diff
    WHEN 0 THEN
      v_new_streak     := v_pet.streak;
      v_is_first_today := FALSE;
    WHEN 1 THEN
      v_new_streak     := v_pet.streak + 1;
      v_streak_changed := TRUE;
      v_is_first_today := TRUE;
    ELSE
      v_new_streak     := 1;   -- reset
      v_streak_changed := TRUE;
      v_is_first_today := TRUE;
  END CASE;

  -- ── [4] Visit count ──────────────────────────────────────────────
  IF v_days_diff >= 1 THEN
    -- Ngày mới → reset về 1
    v_new_visit_count := 1;
  ELSE
    -- Cùng ngày → lấy snapshot gần nhất + 1
    SELECT COALESCE(visit_count_today, 0) + 1
    INTO   v_new_visit_count
    FROM   pet_state_snapshot
    WHERE  pet_id = p_pet_id
    ORDER  BY recorded_at DESC
    LIMIT  1;

    -- Nếu chưa có snapshot nào hôm nay
    v_new_visit_count := COALESCE(v_new_visit_count, 1);
  END IF;

  -- ── [5] Lấy user context từ DB ───────────────────────────────────
  -- Emotional trend
  SELECT * INTO v_trend_row
  FROM   user_emotional_trend
  WHERE  user_id = p_user_id;

  v_trend := COALESCE(v_trend_row.emotional_trend, 'stable'::emotional_trend);

  -- Note analysis gần nhất (tone + severity)
  SELECT na.* INTO v_analysis_row
  FROM   note_analysis    na
  JOIN   moment_note      mn ON mn.id = na.note_id
  WHERE  na.user_id = p_user_id
  ORDER  BY na.analyzed_at DESC
  LIMIT  1;

  v_user_tone := COALESCE(v_analysis_row.current_tone_predict, 'neutral'::user_tone);
  v_severity  := COALESCE(v_analysis_row.level, 1);

  -- ── [6] Energy decay ─────────────────────────────────────────────
  v_new_energy := calculate_energy_decay(
    p_baseline_energy := v_pet.baseline_energy,
    p_current_energy  := v_pet.energy,
    p_delta_t         := v_delta_t,
    p_hour            := v_hour_vn
  );

  -- ── [7] Resolve mood ─────────────────────────────────────────────
  v_new_mood := resolve_pet_mood(
    p_energy          := v_new_energy,
    p_baseline_energy := v_pet.baseline_energy,
    p_user_tone       := v_user_tone,
    p_trend           := v_trend,
    p_severity        := v_severity,
    p_delta_hours     := v_delta_hours,
    p_streak          := v_new_streak
  );

  -- ── [8] Update bảng pet ──────────────────────────────────────────
  UPDATE pet SET
    energy             = v_new_energy,
    current_mood       = v_new_mood,
    streak             = v_new_streak,
    last_interacted_at = v_now,
    updated_at         = v_now
  WHERE id = p_pet_id;

  -- ── [9] Insert snapshot ──────────────────────────────────────────
  INSERT INTO pet_state_snapshot (
    id,
    pet_id,
    user_id,
    delta_t,
    visit_count_today,
    interaction_count_today,
    energy_at_snapshot,
    mood_at_snapshot,
    time_of_day,           -- CHECK (0-23) → dùng giờ thực
    recorded_at
  ) VALUES (
    (gen_random_uuid())::text,
    p_pet_id,
    p_user_id,
    v_delta_t,
    v_new_visit_count,
    0,                     -- update riêng khi user tương tác
    v_new_energy,
    v_new_mood,
    v_hour_vn,             -- 0-23, khớp constraint schema
    v_now
  );

  -- ── [10] Trả về Flutter ──────────────────────────────────────────
  RETURN jsonb_build_object(
    -- Pet state
    'energy',             v_new_energy,
    'current_mood',       v_new_mood,
    'streak',             v_new_streak,
    -- Session info
    'visit_count_today',  v_new_visit_count,
    'delta_hours',        ROUND(v_delta_hours::NUMERIC, 2),
    'time_of_day',        v_hour_vn,
    -- Flags cho UI
    'streak_changed',     v_streak_changed,
    'is_first_today',     v_is_first_today,
    -- Context đã dùng (debug)
    'user_tone',          v_user_tone,
    'emotional_trend',    v_trend,
    'severity',           v_severity
  );

END;
$$ LANGUAGE plpgsql SECURITY DEFINER;