import 'dart:math' as math;

// ============================================================
// PET BEHAVIOR ENGINE
// ============================================================
//
// Engine này điều khiển hành vi động của pet dựa trên:
// 1. Energy Decay - năng lượng giảm theo thời gian & personality
// 2. Behavior Weights - tính toán xác suất hành vi từ nhiều yếu tố
// 3. Transition & Healing - tránh lặp lại & ưu tiên comfort khi user buồn
//
// ============================================================

// ────────────────────────────────────────────────────────────
// ENUMS & CONSTANTS
// ────────────────────────────────────────────────────────────

/// Các hành vi có thể có của pet (giới hạn 8 trạng thái)
enum PetBehavior {
  sleep,      // Ngủ (năng lượng thấp)
  happy,      // Vui vẻ
  tired,      // Mệt mỏi
  idle,       // Đứng im, quan sát
  sad,        // Buồn (phản ứng với user tone)
  lookAway,   // Quay đi (bị bỏ rơi lâu)
  curious,    // Tò mò
  startled,   // Giật mình, lo lắng
}

/// Personality archetype - quyết định tốc độ suy giảm năng lượng
enum PersonalityType {
  lazy,   // λ = 0.035 - decay nhanh nhất
  calm,   // λ = 0.020 - decay trung bình
  hyper,  // λ = 0.010 - decay chậm nhất
}

/// Cảm xúc của user (từ AI phân tích note)
enum UserTone {
  verySad,
  sad,
  anxious,
  angry,
  neutral,
  happy,
  veryHappy,
}

/// Xu hướng cảm xúc của user theo thời gian
enum EmotionalTrend {
  improving,  // Đang tốt lên
  declining,  // Đang tồi đi
  volatile,   // Thất thường
  stable,     // Ổn định
}

// ────────────────────────────────────────────────────────────
// DATA MODELS
// ────────────────────────────────────────────────────────────

/// Thông tin trạng thái hiện tại của pet
class PetState {
  /// Năng lượng cơ bản (0.0 - 1.0) - đặc điểm bẩm sinh
  final double baselineEnergy;

  /// Năng lượng hiện tại (0.0 - 1.0) - thay đổi theo thời gian
  double currentEnergy;

  /// Hành vi hiện tại của pet
  PetBehavior currentBehavior;

  /// Hành vi trước đó (để tránh lặp lại)
  PetBehavior? previousBehavior;

  /// Hành vi trước nữa (để tránh lặp lại pattern)
  PetBehavior? secondPreviousBehavior;

  PetState({
    required this.baselineEnergy,
    required this.currentEnergy,
    this.currentBehavior = PetBehavior.idle,
    this.previousBehavior,
    this.secondPreviousBehavior,
  });

  /// Lấy personality type dựa trên baseline energy
  PersonalityType get personality {
    if (baselineEnergy < 0.33) return PersonalityType.lazy;
    if (baselineEnergy < 0.67) return PersonalityType.calm;
    return PersonalityType.hyper;
  }

  /// Lấy lambda decay rate theo personality
  double get decayRate {
    switch (personality) {
      case PersonalityType.lazy:
        return 0.035;
      case PersonalityType.calm:
        return 0.020;
      case PersonalityType.hyper:
        return 0.010;
    }
  }
}

/// Context từ user - thông tin về tâm trạng và tương tác
class UserContext {
  /// Cảm xúc hiện tại của user
  final UserTone currentTone;

  /// Xu hướng cảm xúc
  final EmotionalTrend emotionalTrend;

  /// Mức độ nghiêm trọng của cảm xúc (1-5)
  final int severityLevel;

  /// Số giờ kể từ lần tương tác cuối
  final double deltaTimeHours;

  /// Số ngày liên tiếp user viết note
  final int streak;

  /// Số lần user truy cập hôm nay
  final int visitsToday;

  const UserContext({
    this.currentTone = UserTone.neutral,
    this.emotionalTrend = EmotionalTrend.stable,
    this.severityLevel = 3,
    this.deltaTimeHours = 0,
    this.streak = 0,
    this.visitsToday = 1,
  });
}

/// Context về thời gian
class TimeContext {
  /// Giờ hiện tại (0-23)
  final int hour;

  /// Phút hiện tại (0-59)
  final int minute;

  TimeContext({required this.hour, required this.minute});

  factory TimeContext.now() {
    final now = DateTime.now();
    return TimeContext(hour: now.hour, minute: now.minute);
  }
}

// ────────────────────────────────────────────────────────────
// ENERGY DECAY ENGINE
// ────────────────────────────────────────────────────────────

class EnergyDecayEngine {
  /// Tính toán modifier dựa trên nhịp sinh học (circadian rhythm)
  /// Mèo hoạt động mạnh vào sáng sớm và hoàng hôn
  static double getCircadianModifier(int hour) {
    // Bảng modifier theo giờ
    if (hour >= 0 && hour <= 5) return -0.28; // Ngủ sâu ban đêm
    if (hour >= 6 && hour <= 8) return 0.12;  // Thức dậy buổi sáng
    if (hour >= 9 && hour <= 11) return 0.05; // Buổi sáng bình thường
    if (hour >= 12 && hour <= 14) return -0.18; // Ngủ trưa
    if (hour >= 15 && hour <= 17) return 0.10; // Chiều tích cực
    if (hour >= 18 && hour <= 20) return 0.15; // Hoàng hôn (peak activity)
    if (hour >= 21 && hour <= 23) return -0.12; // Buổi tối
    return 0.0;
  }

  /// Tính toán năng lượng hiện tại của pet
  /// 
  /// Formula: E(t) = E₀ × e^(-λt) + circadian + noise
  /// - E₀: baseline energy
  /// - λ: decay rate (phụ thuộc personality)
  /// - t: delta time (hours)
  /// - circadian: modifier dựa theo giờ
  /// - noise: Gaussian noise tạo sự tự nhiên
  static double computeEnergy({
    required PetState pet,
    required double deltaTimeHours,
    required TimeContext timeContext,
  }) {
    // 1. Exponential decay theo thời gian
    final lambda = pet.decayRate;
    final decayed = pet.baselineEnergy * math.exp(-lambda * deltaTimeHours);

    // 2. Circadian rhythm modifier
    final circadian = getCircadianModifier(timeContext.hour);

    // 3. Gaussian noise - tạo sự bất định tự nhiên
    // Sử dụng Box-Muller transform để tạo Gaussian distribution
    final random = math.Random();
    final u1 = random.nextDouble();
    final u2 = random.nextDouble();
    final z0 = math.sqrt(-2.0 * math.log(u1)) * math.cos(2.0 * math.pi * u2);
    final noise = z0 * 0.05; // std = 0.05

    // 4. Tổng hợp và clamp về [0, 1]
    final energy = decayed + circadian + noise;
    return energy.clamp(0.0, 1.0);
  }
}

// ────────────────────────────────────────────────────────────
// BEHAVIOR WEIGHT ENGINE
// ────────────────────────────────────────────────────────────

class BehaviorWeightEngine {
  /// Khởi tạo weights mặc định cho tất cả behaviors
  static Map<PetBehavior, double> _initializeWeights() {
    return {
      for (var behavior in PetBehavior.values) behavior: 1.0,
    };
  }

  /// Factor 1: Personality - ảnh hưởng từ tính cách bẩm sinh
  static void _applyPersonalityFactor(
    Map<PetBehavior, double> weights,
    PersonalityType personality,
  ) {
    switch (personality) {
      case PersonalityType.lazy:
        weights[PetBehavior.sleep] = weights[PetBehavior.sleep]! * 3.5;
        weights[PetBehavior.tired] = weights[PetBehavior.tired]! * 2.5;
        weights[PetBehavior.happy] = weights[PetBehavior.happy]! * 0.2;
        weights[PetBehavior.curious] = weights[PetBehavior.curious]! * 0.4;
        break;

      case PersonalityType.calm:
        weights[PetBehavior.idle] = weights[PetBehavior.idle]! * 2.5;
        weights[PetBehavior.happy] = weights[PetBehavior.happy]! * 1.8;
        weights[PetBehavior.startled] = weights[PetBehavior.startled]! * 0.3;
        break;

      case PersonalityType.hyper:
        weights[PetBehavior.happy] = weights[PetBehavior.happy]! * 3.5;
        weights[PetBehavior.curious] = weights[PetBehavior.curious]! * 2.5;
        weights[PetBehavior.sleep] = weights[PetBehavior.sleep]! * 0.3;
        weights[PetBehavior.tired] = weights[PetBehavior.tired]! * 0.4;
        break;
    }
  }

  /// Factor 2: Energy Level - năng lượng quyết định khả năng hoạt động
  static void _applyEnergyFactor(
    Map<PetBehavior, double> weights,
    double energy,
  ) {
    if (energy < 0.20) {
      // Rất thấp - chủ yếu ngủ
      weights[PetBehavior.sleep] = weights[PetBehavior.sleep]! * 5.0;
      weights[PetBehavior.tired] = weights[PetBehavior.tired]! * 4.0;
      weights[PetBehavior.happy] = weights[PetBehavior.happy]! * 0.05;
    } else if (energy < 0.40) {
      // Thấp - mệt mỏi
      weights[PetBehavior.tired] = weights[PetBehavior.tired]! * 2.5;
      weights[PetBehavior.sleep] = weights[PetBehavior.sleep]! * 2.0;
      weights[PetBehavior.idle] = weights[PetBehavior.idle]! * 1.5;
    } else if (energy < 0.60) {
      // Trung bình - bình thường
      weights[PetBehavior.idle] = weights[PetBehavior.idle]! * 2.0;
      weights[PetBehavior.curious] = weights[PetBehavior.curious]! * 1.2;
    } else if (energy < 0.80) {
      // Cao - năng động
      weights[PetBehavior.curious] = weights[PetBehavior.curious]! * 2.0;
      weights[PetBehavior.happy] = weights[PetBehavior.happy]! * 1.8;
    } else {
      // Rất cao - rất năng động
      weights[PetBehavior.happy] = weights[PetBehavior.happy]! * 3.0;
      weights[PetBehavior.curious] = weights[PetBehavior.curious]! * 2.0;
    }
  }

  /// Factor 3: User Tone - phản ứng với cảm xúc của user
  static void _applyUserToneFactor(
    Map<PetBehavior, double> weights,
    UserTone tone,
  ) {
    switch (tone) {
      case UserTone.verySad:
      case UserTone.sad:
        weights[PetBehavior.sad] = weights[PetBehavior.sad]! * 3.5;
        weights[PetBehavior.lookAway] = weights[PetBehavior.lookAway]! * 0.1;
        // Pet KHÔNG quay đi khi user buồn
        break;

      case UserTone.anxious:
        weights[PetBehavior.sad] = weights[PetBehavior.sad]! * 2.5;
        weights[PetBehavior.startled] = weights[PetBehavior.startled]! * 2.0;
        break;

      case UserTone.angry:
        weights[PetBehavior.lookAway] = weights[PetBehavior.lookAway]! * 3.0;
        weights[PetBehavior.startled] = weights[PetBehavior.startled]! * 2.5;
        break;

      case UserTone.happy:
        weights[PetBehavior.happy] = weights[PetBehavior.happy]! * 2.5;
        break;

      case UserTone.veryHappy:
        weights[PetBehavior.happy] = weights[PetBehavior.happy]! * 4.0;
        weights[PetBehavior.curious] = weights[PetBehavior.curious]! * 2.0;
        break;

      case UserTone.neutral:
        // Không thay đổi weights
        break;
    }
  }

  /// Factor 4: Emotional Trend - xu hướng cảm xúc
  static void _applyEmotionalTrendFactor(
    Map<PetBehavior, double> weights,
    EmotionalTrend trend,
  ) {
    switch (trend) {
      case EmotionalTrend.improving:
        weights[PetBehavior.curious] = weights[PetBehavior.curious]! * 2.0;
        weights[PetBehavior.happy] = weights[PetBehavior.happy]! * 1.8;
        break;

      case EmotionalTrend.declining:
        weights[PetBehavior.sad] = weights[PetBehavior.sad]! * 2.5;
        break;

      case EmotionalTrend.volatile:
        weights[PetBehavior.startled] = weights[PetBehavior.startled]! * 3.0;
        break;

      case EmotionalTrend.stable:
        weights[PetBehavior.idle] = weights[PetBehavior.idle]! * 2.5;
        break;
    }
  }

  /// Factor 5: Delta Time - thời gian kể từ lần tương tác cuối
  static void _applyDeltaTimeFactor(
    Map<PetBehavior, double> weights,
    double deltaTimeHours,
  ) {
    if (deltaTimeHours > 72) {
      // > 3 ngày - rất bị bỏ rơi
      weights[PetBehavior.lookAway] = weights[PetBehavior.lookAway]! * 4.0;
      weights[PetBehavior.sad] = weights[PetBehavior.sad]! * 3.5;
    } else if (deltaTimeHours > 48) {
      // > 2 ngày - bị bỏ rơi
      weights[PetBehavior.lookAway] = weights[PetBehavior.lookAway]! * 2.5;
      weights[PetBehavior.sad] = weights[PetBehavior.sad]! * 2.0;
    } else if (deltaTimeHours > 24) {
      // > 1 ngày - hơi buồn
      weights[PetBehavior.lookAway] = weights[PetBehavior.lookAway]! * 1.5;
      weights[PetBehavior.sad] = weights[PetBehavior.sad]! * 1.3;
    }
  }

  /// Factor 6: Streak - số ngày liên tiếp viết note
  static void _applyStreakFactor(
    Map<PetBehavior, double> weights,
    int streak,
  ) {
    if (streak >= 30) {
      // Rất thân thiết
      weights[PetBehavior.happy] = weights[PetBehavior.happy]! * 1.8;
    } else if (streak < 3) {
      // Chưa quen
      weights[PetBehavior.idle] = weights[PetBehavior.idle]! * 1.5;
      weights[PetBehavior.lookAway] = weights[PetBehavior.lookAway]! * 1.3;
    }
  }

  /// Factor 7: Visits Today - số lần truy cập hôm nay
  static void _applyVisitsFactor(
    Map<PetBehavior, double> weights,
    int visits,
  ) {
    if (visits >= 5) {
      // Quá nhiều lần - hơi mệt mỏi
      weights[PetBehavior.lookAway] = weights[PetBehavior.lookAway]! * 1.8;
      weights[PetBehavior.tired] = weights[PetBehavior.tired]! * 1.5;
    } else if (visits == 0) {
      // Lần đầu hôm nay - tò mò
      weights[PetBehavior.curious] = weights[PetBehavior.curious]! * 1.4;
      weights[PetBehavior.startled] = weights[PetBehavior.startled]! * 1.3;
    }
  }

  /// Tính toán tất cả behavior weights
  static Map<PetBehavior, double> computeBehaviorWeights({
    required PetState pet,
    required UserContext userContext,
  }) {
    final weights = _initializeWeights();

    // Apply các factors theo thứ tự
    _applyPersonalityFactor(weights, pet.personality);
    _applyEnergyFactor(weights, pet.currentEnergy);
    _applyUserToneFactor(weights, userContext.currentTone);
    _applyEmotionalTrendFactor(weights, userContext.emotionalTrend);
    _applyDeltaTimeFactor(weights, userContext.deltaTimeHours);
    _applyStreakFactor(weights, userContext.streak);
    _applyVisitsFactor(weights, userContext.visitsToday);

    return weights;
  }
}

// ────────────────────────────────────────────────────────────
// TRANSITION & HEALING OVERRIDE
// ────────────────────────────────────────────────────────────

class BehaviorModifierEngine {
  /// Anti-repetition: Giảm xác suất lặp lại hành vi gần đây
  static void applyTransitionPenalty(
    Map<PetBehavior, double> weights,
    PetState pet,
  ) {
    // Giảm 70% xác suất cho hành vi hiện tại
    if (pet.previousBehavior != null) {
      final prev = pet.previousBehavior!;
      if (weights.containsKey(prev)) {
        weights[prev] = weights[prev]! * 0.3;
      }
    }

    // Giảm 40% xác suất cho hành vi trước nữa
    if (pet.secondPreviousBehavior != null) {
      final prev2 = pet.secondPreviousBehavior!;
      if (weights.containsKey(prev2)) {
        weights[prev2] = weights[prev2]! * 0.6;
      }
    }
  }

  /// Healing Override: Khi user rất tổn thương, pet KHÔNG được phản ứng tiêu cực
  static void applyHealingOverride(
    Map<PetBehavior, double> weights,
    UserContext userContext,
  ) {
    // Chỉ áp dụng khi user rất buồn hoặc lo lắng VÀ severity cao
    final isVeryDistressed = (userContext.currentTone == UserTone.verySad ||
            userContext.currentTone == UserTone.anxious) &&
        userContext.severityLevel >= 4;

    if (isVeryDistressed) {
      // Giảm mạnh các hành vi tiêu cực
      weights[PetBehavior.lookAway] = weights[PetBehavior.lookAway]! * 0.05;
      weights[PetBehavior.startled] = weights[PetBehavior.startled]! * 0.05;

      // Tăng mạnh các hành vi an ủi
      weights[PetBehavior.sad] = weights[PetBehavior.sad]! * 5.0;
      weights[PetBehavior.idle] = weights[PetBehavior.idle]! * 3.0;
    }
  }
}

// ────────────────────────────────────────────────────────────
// BEHAVIOR DECISION ENGINE (Main Pipeline)
// ────────────────────────────────────────────────────────────

class PetBehaviorEngine {
  final math.Random _random = math.Random();

  /// Chọn behavior dựa trên weighted random
  PetBehavior _chooseBehavior(Map<PetBehavior, double> weights) {
    final total = weights.values.reduce((a, b) => a + b);
    var randomValue = _random.nextDouble() * total;

    for (final entry in weights.entries) {
      randomValue -= entry.value;
      if (randomValue <= 0) {
        return entry.key;
      }
    }

    // Fallback
    return PetBehavior.idle;
  }

  /// Main pipeline: Quyết định hành vi tiếp theo của pet
  /// 
  /// Returns: (behavior, energy, weights) để debug/logging
  (PetBehavior, double, Map<PetBehavior, double>) decideBehavior({
    required PetState pet,
    required UserContext userContext,
    required TimeContext timeContext,
  }) {
    // Step 1: Tính toán năng lượng hiện tại
    final energy = EnergyDecayEngine.computeEnergy(
      pet: pet,
      deltaTimeHours: userContext.deltaTimeHours,
      timeContext: timeContext,
    );
    pet.currentEnergy = energy;

    // Step 2: Tính toán behavior weights
    var weights = BehaviorWeightEngine.computeBehaviorWeights(
      pet: pet,
      userContext: userContext,
    );

    // Step 3: Apply transition penalty (tránh lặp lại)
    BehaviorModifierEngine.applyTransitionPenalty(weights, pet);

    // Step 4: Apply healing override (ưu tiên comfort khi user buồn)
    BehaviorModifierEngine.applyHealingOverride(weights, userContext);

    // Step 5: Chọn behavior cuối cùng
    final selectedBehavior = _chooseBehavior(weights);

    // Step 6: Update pet state
    pet.secondPreviousBehavior = pet.previousBehavior;
    pet.previousBehavior = pet.currentBehavior;
    pet.currentBehavior = selectedBehavior;

    return (selectedBehavior, energy, weights);
  }
}

// ────────────────────────────────────────────────────────────
// HELPER EXTENSIONS
// ────────────────────────────────────────────────────────────

extension PetBehaviorExtension on PetBehavior {
  /// Chuyển đổi sang string dễ đọc
  String get displayName {
    switch (this) {
      case PetBehavior.sleep:
        return 'Sleeping';
      case PetBehavior.happy:
        return 'Happy';
      case PetBehavior.tired:
        return 'Tired';
      case PetBehavior.idle:
        return 'Idle';
      case PetBehavior.sad:
        return 'Sad';
      case PetBehavior.lookAway:
        return 'Look Away';
      case PetBehavior.curious:
        return 'Curious';
      case PetBehavior.startled:
        return 'Startled';
    }
  }

  /// Emoji tương ứng với behavior
  String get emoji {
    switch (this) {
      case PetBehavior.sleep:
        return '😴';
      case PetBehavior.happy:
        return '😊';
      case PetBehavior.tired:
        return '😪';
      case PetBehavior.idle:
        return '🙂';
      case PetBehavior.sad:
        return '😢';
      case PetBehavior.lookAway:
        return '😔';
      case PetBehavior.curious:
        return '🤔';
      case PetBehavior.startled:
        return '😨';
    }
  }
}
