import 'package:freezed_annotation/freezed_annotation.dart';
import 'enums/user_tone.dart';
import 'enums/emotional_trend.dart';

part 'user_emotional_trend_model.freezed.dart';
part 'user_emotional_trend_model.g.dart';

/// User Emotional Trend Model - Aggregated emotional trend 7 ngày
///
/// Được tính toán sau mỗi note mới. Pet Behavior Engine đọc bảng này
/// thay vì query lại toàn bộ lịch sử. Quan hệ **1:1** với USER_PROFILE
@freezed
abstract class UserEmotionalTrend with _$UserEmotionalTrend {
  const factory UserEmotionalTrend({
    required String id,

    /// User ID — 1 record per user (unique)
    required String userId,

    /// Xu hướng: improving, declining, stable, volatile
    required EmotionalTrend emotionalTrend,

    /// Hướng thay đổi cảm xúc (−1.0 → +1.0)
    /// -1.0 = hoàn toàn xấu đi
    /// 0.0 = ổn định
    /// +1.0 = hoàn toàn tốt dần
    required double emotionalMomentum,

    /// Danh sách tone 7 ngày gần nhất (mảng ordered by date)
    required List<UserTone> toneHistory7d,

    /// Tone xuất hiện nhiều nhất trong 7 ngày
    required UserTone dominantTone,

    required DateTime updatedAt,
  }) = _UserEmotionalTrend;

  factory UserEmotionalTrend.fromJson(Map<String, dynamic> json) =>
      _$UserEmotionalTrendFromJson(json);
}

/// Extension để thêm các helper methods
extension UserEmotionalTrendX on UserEmotionalTrend {
  /// Tính average emotional score từ 7 ngày
  double get averageEmotionalScore {
    if (toneHistory7d.isEmpty) return 0;
    final sum = toneHistory7d.fold<int>(
      0,
      (acc, tone) => acc + tone.emotionalScore,
    );
    return sum / toneHistory7d.length;
  }

  /// Kiểm tra xem cảm xúc có cần can thiệp không (declining + nhiều negative tone)
  bool get needsIntervention =>
      emotionalTrend == EmotionalTrend.declining && averageEmotionalScore < -1;

  /// Kiểm tra xem cảm xúc có rất volatile không (>= 5 tones khác nhau trong 7 ngày)
  bool get isVeryVolatile {
    final uniqueTones = toneHistory7d.toSet().length;
    return uniqueTones >= 5;
  }

  /// Đếm số lần tone tiêu cực xuất hiện trong 7 ngày
  int get negativeToneCount {
    return toneHistory7d
        .where(
          (tone) =>
              tone == UserTone.sad ||
              tone == UserTone.anxious ||
              tone == UserTone.angry,
        )
        .length;
  }

  /// Đếm số lần tone tích cực xuất hiện trong 7 ngày
  int get positiveToneCount {
    return toneHistory7d
        .where((tone) => tone == UserTone.happy)
        .length;
  }

  /// Tính phần trăm tích cực trong 7 ngày
  double get positivityPercentage {
    if (toneHistory7d.isEmpty) return 0;
    return (positiveToneCount / toneHistory7d.length) * 100;
  }

  /// Kiểm tra xem lỏi trend là improving
  bool get isImproving => emotionalTrend == EmotionalTrend.improving;

  /// Kiểm tra xem lỏi trend là declining
  bool get isDeclining => emotionalTrend == EmotionalTrend.declining;

  /// Kiểm tra xem trend là stable
  bool get isStable => emotionalTrend == EmotionalTrend.stable;

  /// Kiểm tra xem trend là volatile
  bool get isVolatile => emotionalTrend == EmotionalTrend.volatile;
}
