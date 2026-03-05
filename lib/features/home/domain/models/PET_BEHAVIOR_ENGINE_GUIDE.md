# Pet Behavior Engine - Integration Guide

## 📋 Overview

Pet Behavior Engine là một hệ thống quyết định hành vi động cho pet dựa trên:
- **Energy Decay**: Năng lượng giảm theo thời gian & personality
- **Behavior Weights**: Tính toán xác suất hành vi từ nhiều yếu tố (personality, energy, user tone, trend, time, streak, visits)
- **Anti-Repetition**: Tránh lặp lại hành vi liên tiếp
- **Healing Override**: Ưu tiên comfort khi user đang buồn

## 🎯 Limited Behaviors (8 states)

```dart
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
```

## 🧬 Personality Types (3 levels)

| Personality | Baseline Energy | Decay Rate (λ) | Characteristics |
|------------|-----------------|----------------|-----------------|
| **Lazy**   | < 0.33          | 0.035          | Decay nhanh nhất, hay ngủ |
| **Calm**   | 0.33 - 0.67     | 0.020          | Decay trung bình, ổn định |
| **Hyper**  | > 0.67          | 0.010          | Decay chậm nhất, năng động |

## 🔧 Basic Usage

### 1. Khởi tạo Pet State

```dart
import 'package:homies_buddy_developer/features/home/domain/models/pet_behavior_engine.dart';

// Tạo pet state với baseline energy
final pet = PetState(
  baselineEnergy: 0.7,  // Hyper personality
  currentEnergy: 0.7,   // Energy ban đầu
);

// Personality được tự động xác định từ baselineEnergy
print(pet.personality);  // PersonalityType.hyper
print(pet.decayRate);    // 0.010
```

### 2. Chuẩn bị Context

```dart
// User context - từ AI phân tích note
final userContext = UserContext(
  currentTone: UserTone.happy,              // Cảm xúc hiện tại
  emotionalTrend: EmotionalTrend.stable,    // Xu hướng
  severityLevel: 2,                         // 1-5
  deltaTimeHours: 2.0,                      // Giờ kể từ lần cuối
  streak: 10,                               // Số ngày liên tiếp
  visitsToday: 1,                           // Số lần truy cập hôm nay
);

// Time context - thời gian hiện tại
final timeContext = TimeContext.now();
// hoặc custom:
// final timeContext = TimeContext(hour: 14, minute: 30);
```

### 3. Quyết định Behavior

```dart
final engine = PetBehaviorEngine();

final (behavior, energy, weights) = engine.decideBehavior(
  pet: pet,
  userContext: userContext,
  timeContext: timeContext,
);

print('Behavior: ${behavior.displayName}');  // "Happy"
print('Energy: ${energy.toStringAsFixed(2)}');  // "0.68"
```

## 🔄 Integration với PetAnimationWidget

### Mapping PetBehavior → PetAnimationState

```dart
PetAnimationState mapBehaviorToAnimationState(PetBehavior behavior) {
  switch (behavior) {
    case PetBehavior.sleep:
      return PetAnimationState.sleep;
      
    case PetBehavior.happy:
      return PetAnimationState.happy;
      
    case PetBehavior.tired:
      // Không có animation "tired" → dùng idle hoặc sleep
      return PetAnimationState.idleToSleep;
      
    case PetBehavior.idle:
      return PetAnimationState.idle;
      
    case PetBehavior.sad:
      return PetAnimationState.sad;
      
    case PetBehavior.lookAway:
      return PetAnimationState.lookingOutside;
      
    case PetBehavior.curious:
      // Không có animation "curious" → dùng looking hoặc walking
      return PetAnimationState.lookingToWalkFront;
      
    case PetBehavior.startled:
      // Không có animation "startled" → dùng walking away
      return PetAnimationState.walkingAway;
  }
}
```

### Update Animation Logic

```dart
class _PetAnimationWidgetState extends State<PetAnimationWidget> {
  late PetState _petState;
  late PetBehaviorEngine _behaviorEngine;
  Timer? _behaviorTimer;

  @override
  void initState() {
    super.initState();
    
    // Khởi tạo pet state
    _petState = PetState(
      baselineEnergy: 0.7,  // Load từ database
      currentEnergy: 0.7,
    );
    
    _behaviorEngine = PetBehaviorEngine();
    
    // Update behavior mỗi 30 giây
    _behaviorTimer = Timer.periodic(
      const Duration(seconds: 30),
      (_) => _updatePetBehavior(),
    );
    
    // Update lần đầu
    _updatePetBehavior();
  }

  void _updatePetBehavior() {
    // 1. Get user context từ AI hoặc database
    final userContext = _getUserContext();
    final timeContext = TimeContext.now();
    
    // 2. Quyết định behavior
    final (behavior, energy, weights) = _behaviorEngine.decideBehavior(
      pet: _petState,
      userContext: userContext,
      timeContext: timeContext,
    );
    
    // 3. Map sang animation state
    final animationState = mapBehaviorToAnimationState(behavior);
    
    // 4. Update UI
    setState(() {
      _currentState = animationState;
    });
    
    // 5. Log cho debug
    print('Behavior: ${behavior.displayName}, Energy: ${energy.toStringAsFixed(2)}');
  }

  UserContext _getUserContext() {
    // TODO: Lấy từ AI analysis hoặc database
    return UserContext(
      currentTone: UserTone.happy,
      emotionalTrend: EmotionalTrend.stable,
      severityLevel: 2,
      deltaTimeHours: 1.0,
      streak: 10,
      visitsToday: 1,
    );
  }

  @override
  void dispose() {
    _behaviorTimer?.cancel();
    super.dispose();
  }
}
```

## 📊 Behavior Weight Factors

### Factor 1: Personality

| Personality | Multipliers |
|------------|-------------|
| **Lazy**   | sleep ×3.5, tired ×2.5, happy ×0.2, curious ×0.4 |
| **Calm**   | idle ×2.5, happy ×1.8, startled ×0.3 |
| **Hyper**  | happy ×3.5, curious ×2.5, sleep ×0.3, tired ×0.4 |

### Factor 2: Energy Level

| Energy Range | Behavior Tendency |
|--------------|-------------------|
| < 0.20       | sleep ×5.0, tired ×4.0, happy ×0.05 |
| 0.20 - 0.40  | tired ×2.5, sleep ×2.0, idle ×1.5 |
| 0.40 - 0.60  | idle ×2.0, curious ×1.2 |
| 0.60 - 0.80  | curious ×2.0, happy ×1.8 |
| > 0.80       | happy ×3.0, curious ×2.0 |

### Factor 3: User Tone

| Tone | Pet Reaction |
|------|--------------|
| **Very Sad / Sad** | sad ×3.5, lookAway ×0.1 |
| **Anxious** | sad ×2.5, startled ×2.0 |
| **Angry** | lookAway ×3.0, startled ×2.5 |
| **Happy** | happy ×2.5 |
| **Very Happy** | happy ×4.0, curious ×2.0 |

### Factor 4: Emotional Trend

| Trend | Effect |
|-------|--------|
| **Improving** | curious ×2.0, happy ×1.8 |
| **Declining** | sad ×2.5 |
| **Volatile** | startled ×3.0 |
| **Stable** | idle ×2.5 |

### Factor 5: Delta Time (Hours since last visit)

| Time Range | Effect |
|------------|--------|
| > 72h (3 days) | lookAway ×4.0, sad ×3.5 |
| > 48h (2 days) | lookAway ×2.5, sad ×2.0 |
| > 24h (1 day) | lookAway ×1.5, sad ×1.3 |

### Factor 6: Streak

| Streak | Effect |
|--------|--------|
| ≥ 30 days | happy ×1.8 |
| < 3 days | idle ×1.5, lookAway ×1.3 |

### Factor 7: Visits Today

| Visits | Effect |
|--------|--------|
| ≥ 5 times | lookAway ×1.8, tired ×1.5 |
| 0 times | curious ×1.4, startled ×1.3 |

## 🛡️ Special Overrides

### Anti-Repetition Penalty

```dart
// Giảm 70% xác suất cho hành vi vừa làm
if (previousBehavior != null) {
  weights[previousBehavior] *= 0.3;
}

// Giảm 40% xác suất cho hành vi trước nữa
if (secondPreviousBehavior != null) {
  weights[secondPreviousBehavior] *= 0.6;
}
```

### Healing Override

Khi `currentTone == verySad/anxious && severityLevel >= 4`:

```dart
// Giảm mạnh hành vi tiêu cực
lookAway ×0.05
startled ×0.05

// Tăng mạnh hành vi an ủi
sad ×5.0
idle ×3.0
```

## 🧪 Testing & Debug

### Run Example

```bash
dart run lib/features/home/domain/models/pet_behavior_engine_example.dart
```

### Debug Print Weights

```dart
final (behavior, energy, weights) = engine.decideBehavior(...);

print('\n📊 Behavior Weights:');
final sortedWeights = weights.entries.toList()
  ..sort((a, b) => b.value.compareTo(a.value));

for (final entry in sortedWeights) {
  final total = weights.values.reduce((a, b) => a + b);
  final percentage = (entry.value / total * 100);
  print('${entry.key.displayName}: ${percentage.toStringAsFixed(1)}%');
}
```

## 📈 Energy Decay Formula

```
E(t) = E₀ × e^(-λt) + circadian + noise

Where:
- E₀: baseline energy (0.0 - 1.0)
- λ: decay rate (lazy=0.035, calm=0.020, hyper=0.010)
- t: delta time in hours
- circadian: modifier dựa theo giờ (-0.28 to +0.15)
- noise: Gaussian noise (mean=0, std=0.05)
```

### Circadian Rhythm Table

| Time Range | Modifier | Meaning |
|------------|----------|---------|
| 00:00 - 05:00 | -0.28 | Ngủ sâu ban đêm |
| 06:00 - 08:00 | +0.12 | Thức dậy buổi sáng |
| 09:00 - 11:00 | +0.05 | Buổi sáng bình thường |
| 12:00 - 14:00 | -0.18 | Ngủ trưa |
| 15:00 - 17:00 | +0.10 | Chiều tích cực |
| 18:00 - 20:00 | +0.15 | Hoàng hôn (peak activity) |
| 21:00 - 23:00 | -0.12 | Buổi tối |

## 💾 Data Persistence

### Save Pet State

```dart
class PetStateRepository {
  Future<void> savePetState(PetState pet) async {
    // Save to Firestore
    await FirebaseFirestore.instance
        .collection('pets')
        .doc(userId)
        .set({
      'baseline_energy': pet.baselineEnergy,
      'current_energy': pet.currentEnergy,
      'current_behavior': pet.currentBehavior.name,
      'previous_behavior': pet.previousBehavior?.name,
      'second_previous_behavior': pet.secondPreviousBehavior?.name,
      'last_updated': FieldValue.serverTimestamp(),
    });
  }

  Future<PetState> loadPetState() async {
    final doc = await FirebaseFirestore.instance
        .collection('pets')
        .doc(userId)
        .get();
    
    if (!doc.exists) {
      // Khởi tạo pet mới với baseline ngẫu nhiên
      return PetState(
        baselineEnergy: 0.5 + Random().nextDouble() * 0.3, // 0.5-0.8
        currentEnergy: 0.7,
      );
    }
    
    final data = doc.data()!;
    return PetState(
      baselineEnergy: data['baseline_energy'] ?? 0.7,
      currentEnergy: data['current_energy'] ?? 0.7,
      currentBehavior: _parseBehavior(data['current_behavior']),
      previousBehavior: _parseBehavior(data['previous_behavior']),
      secondPreviousBehavior: _parseBehavior(data['second_previous_behavior']),
    );
  }

  PetBehavior? _parseBehavior(String? name) {
    if (name == null) return null;
    return PetBehavior.values.firstWhere(
      (b) => b.name == name,
      orElse: () => PetBehavior.idle,
    );
  }
}
```

## 🎨 UI Integration Checklist

- [ ] Khởi tạo `PetState` khi load home screen
- [ ] Load `baselineEnergy` từ Firestore (hoặc random nếu user mới)
- [ ] Tạo `UserContext` từ AI analysis result
- [ ] Call `decideBehavior()` mỗi 30-60 giây
- [ ] Map `PetBehavior` → `PetAnimationState`
- [ ] Update animation state với `setState()`
- [ ] Save `PetState` vào Firestore khi behavior thay đổi
- [ ] Handle edge cases (no internet, first time user, etc.)

## 📝 Notes

1. **Baseline Energy không thay đổi** - đây là đặc điểm bẩm sinh của pet
2. **Current Energy thay đổi theo thời gian** - dựa trên công thức decay
3. **Behavior được random weighted** - không deterministic, tạo sự tự nhiên
4. **Anti-repetition quan trọng** - tránh pet lặp lại hành vi liên tiếp
5. **Healing override ưu tiên cao nhất** - khi user buồn, pet phải comfort

## 🚀 Next Steps

1. Test engine với các scenario khác nhau
2. Tạo thêm animations cho các behaviors còn thiếu
3. Integrate với AI emotion analysis
4. Add analytics để track behavior distribution
5. Fine-tune weights dựa trên user feedback
