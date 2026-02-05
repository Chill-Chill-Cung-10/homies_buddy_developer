import 'package:freezed_annotation/freezed_annotation.dart';
import 'pet_owner_model.dart';

part 'pet_profile_model.freezed.dart';
part 'pet_profile_model.g.dart';

/// Pet Profile Model - Thông tin profile của thú cưng
/// 
/// Hiển thị khi user click vào profile của pet, bao gồm
/// thông tin pet, owner, và follower count
@freezed
class PetProfile with _$PetProfile {
  const factory PetProfile({
    required String petId,
    required String petName,
    required String petAvatar,
    required PetOwner petOwner,
    required String petPitching,
    required bool isFollowedByMe,
    required int followerCount,
  }) = _PetProfile;

  factory PetProfile.fromJson(Map<String, dynamic> json) =>
      _$PetProfileFromJson(json);
}

/// Extension để thêm các helper methods
extension PetProfileX on PetProfile {
  /// Kiểm tra xem có phải pet của mình không
  bool isMyPet(String currentUserId) => petOwner.ownerId == currentUserId;

  /// Lấy display name cho pet (tên pet + emoji nếu có)
  String get displayName => petName;

  /// Kiểm tra xem có followers không
  bool get hasFollowers => followerCount > 0;

  /// Format follower count (vd: 1.2K, 1.5M)
  String get followerCountText {
    if (followerCount >= 1000000) {
      return '${(followerCount / 1000000).toStringAsFixed(1)}M';
    } else if (followerCount >= 1000) {
      return '${(followerCount / 1000).toStringAsFixed(1)}K';
    }
    return followerCount.toString();
  }

  /// Validate pet profile
  String? validate() {
    if (petName.trim().isEmpty) {
      return 'Tên pet không được để trống';
    }
    if (petName.length > 50) {
      return 'Tên pet không được quá 50 ký tự';
    }
    if (petPitching.length > 200) {
      return 'Pet pitching không được quá 200 ký tự';
    }
    if (followerCount < 0) {
      return 'Số lượng follower không hợp lệ';
    }
    return null;
  }
}
