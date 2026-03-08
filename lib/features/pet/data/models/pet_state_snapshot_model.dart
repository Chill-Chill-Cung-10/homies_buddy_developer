import 'package:freezed_annotation/freezed_annotation.dart';
import 'enums/pet_mood.dart';

part 'pet_state_snapshot_model.freezed.dart';
part 'pet_state_snapshot_model.g.dart';

/// Pet State Snapshot Model - Log trạng thái pet theo từng session
///
/// Append-only log để tính `visit_count_today`, `emotion_recent_avg`,
/// và debug behavior engine. Dùng để phân tích hành vi pet qua thời gian
@freezed
abstract class PetStateSnapshot with _$PetStateSnapshot {
  const factory PetStateSnapshot({
    required String id,
    required String petId,
    required String userId,

    /// Số giờ kể từ lần tương tác trước
    required double deltaT,

    /// Số lần mở app trong ngày
    required int visitCountToday,

    /// Số lần tương tác với pet trong ngày
    required int interactionCountToday,

    /// Giá trị energy tại thời điểm snapshot
    required double energyAtSnapshot,

    /// Trạng thái mood tại thời điểm snapshot
    required PetMood moodAtSnapshot,

    /// Giờ trong ngày (0–23) — dùng cho circadian modifier
    required int timeOfDay,

    required DateTime recordedAt,
  }) = _PetStateSnapshot;

  factory PetStateSnapshot.fromJson(Map<String, dynamic> json) =>
      _$PetStateSnapshotFromJson(json);
}

/// Extension để thêm các helper methods
extension PetStateSnapshotX on PetStateSnapshot {
  /// Kiểm tra xem snapshot này có trong giờ đêm khuya không (22:00 - 06:00)
  bool get isNightTime => timeOfDay >= 22 || timeOfDay < 6;

  /// Kiểm tra xem user có hoạt động tích cực không (nhiều lần tương tác)
  bool get isActiveDay => interactionCountToday >= 5;

  /// Kiểm tra xem user có bỏ bê pet không (không tương tác cả ngày)
  bool get isNeglectedDay => interactionCountToday == 0 && visitCountToday > 0;

  /// Kiểm tra xem pet có được yêu cầu chú ý không
  bool get needsAttention =>
      moodAtSnapshot == PetMood.sad ||
      moodAtSnapshot == PetMood.clingy ||
      moodAtSnapshot == PetMood.grumpy;
}
