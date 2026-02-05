import 'package:freezed_annotation/freezed_annotation.dart';

part 'change_password_request.freezed.dart';
part 'change_password_request.g.dart';

/// Change Password Request Model - Đổi mật khẩu
@freezed
class ChangePasswordRequest with _$ChangePasswordRequest {
  const factory ChangePasswordRequest({
    required String currentPassword,
    required String newPassword,
    required String confirmNewPassword,
  }) = _ChangePasswordRequest;

  factory ChangePasswordRequest.fromJson(Map<String, dynamic> json) =>
      _$ChangePasswordRequestFromJson(json);
}

/// Extension để validate
extension ChangePasswordRequestX on ChangePasswordRequest {
  /// Validate current password
  String? validateCurrentPassword() {
    if (currentPassword.isEmpty) {
      return 'Vui lòng nhập mật khẩu hiện tại';
    }
    return null;
  }

  /// Validate new password
  String? validateNewPassword() {
    if (newPassword.isEmpty) {
      return 'Mật khẩu mới không được để trống';
    }
    if (newPassword.length < 8) {
      return 'Mật khẩu phải có ít nhất 8 ký tự';
    }
    if (!newPassword.contains(RegExp(r'[A-Z]'))) {
      return 'Mật khẩu phải có ít nhất 1 chữ hoa';
    }
    if (!newPassword.contains(RegExp(r'[0-9]'))) {
      return 'Mật khẩu phải có ít nhất 1 chữ số';
    }
    if (newPassword == currentPassword) {
      return 'Mật khẩu mới phải khác mật khẩu hiện tại';
    }
    return null;
  }

  /// Validate confirm new password
  String? validateConfirmNewPassword() {
    if (confirmNewPassword.isEmpty) {
      return 'Vui lòng xác nhận mật khẩu mới';
    }
    if (confirmNewPassword != newPassword) {
      return 'Mật khẩu xác nhận không khớp';
    }
    return null;
  }

  bool get isValid {
    return validateCurrentPassword() == null &&
        validateNewPassword() == null &&
        validateConfirmNewPassword() == null;
  }

  /// Lấy danh sách requirements cho new password
  List<PasswordRequirement> get passwordRequirements {
    return [
      PasswordRequirement(
        label: 'Ít nhất 8 ký tự',
        isMet: newPassword.length >= 8,
      ),
      PasswordRequirement(
        label: 'Có chữ hoa',
        isMet: newPassword.contains(RegExp(r'[A-Z]')),
      ),
      PasswordRequirement(
        label: 'Có chữ số',
        isMet: newPassword.contains(RegExp(r'[0-9]')),
      ),
      PasswordRequirement(
        label: 'Khác mật khẩu cũ',
        isMet: newPassword.isNotEmpty && newPassword != currentPassword,
      ),
    ];
  }
}

class PasswordRequirement {
  final String label;
  final bool isMet;

  PasswordRequirement({
    required this.label,
    required this.isMet,
  });
}
