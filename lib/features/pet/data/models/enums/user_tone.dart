import 'package:freezed_annotation/freezed_annotation.dart';

/// User Tone - Tone cảm xúc của user dựa trên ghi chú
enum UserTone {
  @JsonValue('happy')
  happy,

  @JsonValue('neutral')
  neutral,

  @JsonValue('sad')
  sad,

  @JsonValue('anxious')
  anxious,

  @JsonValue('angry')
  angry;

  /// Chuyển từ string sang enum
  static UserTone fromString(String value) {
    return UserTone.values.firstWhere(
      (tone) =>
          tone.name == value.toLowerCase().replaceAll('_', '') ||
          tone.name.replaceAll('_', '') == value.replaceAll('_', ''),
      orElse: () => UserTone.neutral,
    );
  }

  /// Tên hiển thị
  String get displayName {
    switch (this) {
      case UserTone.happy:
        return 'Vui';
      case UserTone.neutral:
        return 'Trung tính';
      case UserTone.sad:
        return 'Buồn';
      case UserTone.anxious:
        return 'Lo lắng';
      case UserTone.angry:
        return 'Tức giận';
    }
  }

  /// Emoji icon
  String get emoji {
    switch (this) {
      case UserTone.happy:
        return '🙂';
      case UserTone.neutral:
        return '😐';
      case UserTone.sad:
        return '😔';
      case UserTone.anxious:
        return '😰';
      case UserTone.angry:
        return '😡';
    }
  }

  /// Điểm số để tính emotional trend (-3 to +3)
  int get emotionalScore {
  switch (this) {
    case UserTone.happy:
      return 2;
    case UserTone.neutral:
      return 0;
    case UserTone.sad:
      return -1;
    case UserTone.anxious:
      return -2;
    case UserTone.angry:
      return -3;
  }
}
}
