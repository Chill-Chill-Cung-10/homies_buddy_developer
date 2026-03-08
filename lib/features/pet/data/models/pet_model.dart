import 'package:freezed_annotation/freezed_annotation.dart';
import 'enums/pet_mood.dart';
import 'enums/pet_avatar_type.dart';

part 'pet_model.freezed.dart';
part 'pet_model.g.dart';

/// Pet Model - Thú cưng ảo của user
///
/// Lưu trữ thông tin về pet bao gồm trạng thái năng lượng, tâm trạng,
/// và personality archetype (dựa trên baseline_energy)
@freezed
abstract class Pet with _$Pet {
  const factory Pet({
    required String id,
    required String userId,
    required String name,
    required PetAvatarType avatarType,

    /// ⚡ Năng lượng bẩm sinh — random lúc tạo, **bất biến**
    /// Xác định personality archetype:
    /// - < 0.25 → Lazy
    /// - 0.25–0.5 → Calm
    /// - 0.5–0.75 → Curious
    /// - > 0.75 → Hyper
    required double baselineEnergy,

    /// Năng lượng hiện tại (realtime, decay theo thời gian)
    required double energy,

    /// Trạng thái cảm xúc hiện tại
    required PetMood currentMood,

    /// Số ngày liên tiếp user active
    @Default(0) int streak,

    /// Lần tương tác cuối — dùng để tính `delta_t`
    required DateTime lastInteractedAt,

    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Pet;

  factory Pet.fromJson(Map<String, dynamic> json) => _$PetFromJson(json);
}

/// Extension để thêm các helper methods
extension PetX on Pet {
  /// Tính đặc điểm tính cách dựa trên baseline_energy
  String get archetype {
    if (baselineEnergy < 0.25) {
      return 'Lazy';
    } else if (baselineEnergy < 0.5) {
      return 'Calm';
    } else if (baselineEnergy < 0.75) {
      return 'Curious';
    } else {
      return 'Hyper';
    }
  }

  /// Kiểm tra xem pet có năng lượng cao không
  bool get hasHighEnergy => energy > 0.7;

  /// Kiểm tra xem pet có năng lượng thấp không
  bool get hasLowEnergy => energy < 0.3;

  /// Kiểm tra xem pet có đang ngủ không
  bool get isSleeping => currentMood == PetMood.sleep;

  /// Kiểm tra xem pet có vui tính không
  bool get isHappy =>
      currentMood == PetMood.happy ||
      currentMood == PetMood.playful ||
      currentMood == PetMood.content;

  /// Kiểm tra xem pet có đang buồn không
  bool get isSad => currentMood == PetMood.sad || currentMood == PetMood.grumpy;
}
