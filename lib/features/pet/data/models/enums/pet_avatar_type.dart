import 'package:freezed_annotation/freezed_annotation.dart';

/// Pet Avatar Type - Loại skin/giống mèo cho pet
enum PetAvatarType {
  @JsonValue('cat_a')
  catA, // Lazy archetype skin

  @JsonValue('cat_b')
  catB, // Calm archetype skin

  @JsonValue('cat_c')
  catC; // Hyper archetype skin

  /// Chuyển từ string sang enum
  static PetAvatarType fromString(String value) {
    return PetAvatarType.values.firstWhere(
      (type) =>
          type.name == value.toLowerCase().replaceAll('_', '') ||
          type.name == value.replaceAll('_', ''),
      orElse: () => PetAvatarType.catA,
    );
  }

  /// Tên hiển thị
  String get displayName {
    switch (this) {
      case PetAvatarType.catA:
        return 'Lazy Cat';
      case PetAvatarType.catB:
        return 'Calm Cat';
      case PetAvatarType.catC:
        return 'Hyper Cat';
    }
  }

  /// Mô tả personality archetype
  String get archetypeDescription {
    switch (this) {
      case PetAvatarType.catA:
        return 'Mèo lười biếng (baseline_energy < 0.25)';
      case PetAvatarType.catB:
        return 'Mèo bình tĩnh (0.25–0.5)';
      case PetAvatarType.catC:
        return 'Mèo hiếu động (baseline_energy > 0.75)';
    }
  }
}
