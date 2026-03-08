import 'package:freezed_annotation/freezed_annotation.dart';

/// User Tone - Tone cảm xúc của user dựa trên ghi chú
enum UserTone {
  @JsonValue('very_happy')
  veryHappy, // 😄 Rất vui

  @JsonValue('happy')
  happy, // 🙂 Vui

  @JsonValue('neutral')
  neutral, // 😐 Trung tính

  @JsonValue('sad')
  sad, // 😔 Buồn

  @JsonValue('very_sad')
  verySad, // 😢 Rất buồn

  @JsonValue('anxious')
  anxious, // 😰 Lo lắng

  @JsonValue('angry')
  angry; // 😡 Tức giận

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
      case UserTone.veryHappy:
        return 'Rất vui';
      case UserTone.happy:
        return 'Vui';
      case UserTone.neutral:
        return 'Trung tính';
      case UserTone.sad:
        return 'Buồn';
      case UserTone.verySad:
        return 'Rất buồn';
      case UserTone.anxious:
        return 'Lo lắng';
      case UserTone.angry:
        return 'Tức giận';
    }
  }

  /// Emoji icon
  String get emoji {
    switch (this) {
      case UserTone.veryHappy:
        return '😄';
      case UserTone.happy:
        return '🙂';
      case UserTone.neutral:
        return '😐';
      case UserTone.sad:
        return '😔';
      case UserTone.verySad:
        return '😢';
      case UserTone.anxious:
        return '😰';
      case UserTone.angry:
        return '😡';
    }
  }

  /// Điểm số để tính emotional trend (-3 to +3)
  int get emotionalScore {
    switch (this) {
      case UserTone.veryHappy:
        return 3;
      case UserTone.happy:
        return 2;
      case UserTone.neutral:
        return 0;
      case UserTone.sad:
        return -1;
      case UserTone.verySad:
        return -2;
      case UserTone.anxious:
        return -2;
      case UserTone.angry:
        return -3;
    }
  }
}
