import 'package:freezed_annotation/freezed_annotation.dart';

/// Emotional Trend - Xu hướng cảm xúc của user (7 ngày)
enum EmotionalTrend {
  @JsonValue('improving')
  improving, // 📈 Cảm xúc đang tốt dần

  @JsonValue('declining')
  declining, // 📉 Cảm xúc đang xấu dần

  @JsonValue('stable')
  stable, // ➡️ Ổn định

  @JsonValue('volatile')
  volatile; // 〰️ Thất thường, bất ổn

  /// Chuyển từ string sang enum
  static EmotionalTrend fromString(String value) {
    return EmotionalTrend.values.firstWhere(
      (trend) => trend.name == value.toLowerCase(),
      orElse: () => EmotionalTrend.stable,
    );
  }

  /// Tên hiển thị
  String get displayName {
    switch (this) {
      case EmotionalTrend.improving:
        return 'Cảm xúc đang tốt dần';
      case EmotionalTrend.declining:
        return 'Cảm xúc đang xấu dần';
      case EmotionalTrend.stable:
        return 'Ổn định';
      case EmotionalTrend.volatile:
        return 'Thất thường, bất ổn';
    }
  }

  /// Icon emoji
  String get emoji {
    switch (this) {
      case EmotionalTrend.improving:
        return '📈';
      case EmotionalTrend.declining:
        return '📉';
      case EmotionalTrend.stable:
        return '➡️';
      case EmotionalTrend.volatile:
        return '〰️';
    }
  }

  /// Color hint untuk UI (ví dụ: green, red, orange, gray)
  String get colorHint {
    switch (this) {
      case EmotionalTrend.improving:
        return 'green';
      case EmotionalTrend.declining:
        return 'red';
      case EmotionalTrend.stable:
        return 'blue';
      case EmotionalTrend.volatile:
        return 'orange';
    }
  }
}
