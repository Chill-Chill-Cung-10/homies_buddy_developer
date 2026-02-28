import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

/// [Refactored] Phase 2.3 — Auth-specific user model (lightweight).
/// 
/// Dùng cho authentication state (AuthState.authenticated).
/// Khác với `lib/data/models/user_model.dart` (community social profile model)
/// chứa thêm posts, followers, homies, etc.
///
/// Single source of truth cho social profile là `lib/data/models/user_model.dart`.
/// Model này chỉ chứa thông tin cốt lõi (identity, email, verification).
///
/// Sử dụng Freezed để tự động generate:
/// - copyWith method
/// - equality (==, hashCode)
/// - toString
/// - JSON serialization
@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    required String id,
    required String email,
    required String fullName,
    String? avatarUrl,
    String? phoneNumber,
    DateTime? dateOfBirth,
    @Default(false) bool isEmailVerified,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _UserModel;

  /// Tạo UserModel từ JSON (từ API response)
  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}

/// Typedef cho code clarity — sử dụng `AuthUser` thay cho `UserModel` (auth)
/// để phân biệt với community `UserModel`.
typedef AuthUser = UserModel;

/// Extension để thêm các helper methods cho auth user
extension UserModelX on UserModel {
  /// Kiểm tra xem user đã hoàn thiện profile chưa
  bool get isProfileComplete {
    return fullName.isNotEmpty && 
           phoneNumber != null && 
           dateOfBirth != null;
  }
  
  /// Lấy tên hiển thị (fullName hoặc email nếu chưa có tên)
  String get displayName {
    return fullName.isNotEmpty ? fullName : email.split('@').first;
  }
  
  /// Lấy initial của tên (để hiển thị avatar placeholder)
  String get initials {
    if (fullName.isEmpty) {
      return email.substring(0, 1).toUpperCase();
    }
    final parts = fullName.split(' ');
    if (parts.length >= 2) {
      return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
    }
    return fullName.substring(0, 1).toUpperCase();
  }
}
