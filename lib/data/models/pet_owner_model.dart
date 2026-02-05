import 'package:freezed_annotation/freezed_annotation.dart';

part 'pet_owner_model.freezed.dart';
part 'pet_owner_model.g.dart';

/// Pet Owner Model - Thông tin chủ nhân của thú cưng
/// 
/// Sub-model của PetProfile, chứa thông tin cơ bản về owner
@freezed
class PetOwner with _$PetOwner {
  const factory PetOwner({
    required String ownerId,
    required String ownerName,
    required String ownerAvatar,
  }) = _PetOwner;

  factory PetOwner.fromJson(Map<String, dynamic> json) =>
      _$PetOwnerFromJson(json);
}

/// Extension để thêm các helper methods
extension PetOwnerX on PetOwner {
  /// Kiểm tra xem có phải owner hiện tại không
  bool isCurrentUser(String currentUserId) => ownerId == currentUserId;

  /// Validate pet owner
  String? validate() {
    if (ownerName.trim().isEmpty) {
      return 'Tên owner không được để trống';
    }
    if (ownerId.trim().isEmpty) {
      return 'Owner ID không hợp lệ';
    }
    return null;
  }
}
