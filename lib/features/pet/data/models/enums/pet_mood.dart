import 'package:freezed_annotation/freezed_annotation.dart';

/// Pet Mood - Trạng thái cảm xúc của pet
enum PetMood {
  @JsonValue('idle')
  idle, // 😶 Thụ động, nghỉ ngơi

  @JsonValue('sleep')
  sleep, // 😴 Ngủ

  @JsonValue('tired')
  tired, // 🥱 Mệt mỏi

  @JsonValue('sad')
  sad, // 😢 Buồn

  @JsonValue('grumpy')
  grumpy, // 😾 Cáu kỉnh

  @JsonValue('look_away')
  lookAway, // 😒 Lờ đi

  @JsonValue('happy')
  happy, // 😸 Vui vẻ

  @JsonValue('playful')
  playful, // 🐾 Tinh nghịch

  @JsonValue('curious')
  curious, // 🧐 Tò mò

  @JsonValue('clingy')
  clingy, // 🫂 Bám víu (khi user buồn)

  @JsonValue('content')
  content, // 😌 Hài lòng

  @JsonValue('startled')
  startled; // 🙀 Giật mình

  /// Chuyển từ string sang enum
  static PetMood fromString(String value) {
    return PetMood.values.firstWhere(
      (mood) =>
          mood.name == value.toLowerCase() ||
          mood.name == value.replaceAll('_', '').toLowerCase(),
      orElse: () => PetMood.idle,
    );
  }

  /// Tên hiển thị
  String get displayName {
    switch (this) {
      case PetMood.idle:
        return 'Thụ động';
      case PetMood.sleep:
        return 'Ngủ';
      case PetMood.tired:
        return 'Mệt mỏi';
      case PetMood.sad:
        return 'Buồn';
      case PetMood.grumpy:
        return 'Cáu kỉnh';
      case PetMood.lookAway:
        return 'Lờ đi';
      case PetMood.happy:
        return 'Vui vẻ';
      case PetMood.playful:
        return 'Tinh nghịch';
      case PetMood.curious:
        return 'Tò mò';
      case PetMood.clingy:
        return 'Bám víu';
      case PetMood.content:
        return 'Hài lòng';
      case PetMood.startled:
        return 'Giật mình';
    }
  }

  /// Emoji icon
  String get emoji {
    switch (this) {
      case PetMood.idle:
        return '😶';
      case PetMood.sleep:
        return '😴';
      case PetMood.tired:
        return '🥱';
      case PetMood.sad:
        return '😢';
      case PetMood.grumpy:
        return '😾';
      case PetMood.lookAway:
        return '😒';
      case PetMood.happy:
        return '😸';
      case PetMood.playful:
        return '🐾';
      case PetMood.curious:
        return '🧐';
      case PetMood.clingy:
        return '🫂';
      case PetMood.content:
        return '😌';
      case PetMood.startled:
        return '🙀';
    }
  }
}
