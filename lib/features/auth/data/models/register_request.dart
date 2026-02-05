import 'package:freezed_annotation/freezed_annotation.dart';

part 'register_request.freezed.dart';
part 'register_request.g.dart';

/// Register Request Model - Dữ liệu gửi lên server khi đăng ký
@freezed
class RegisterRequest with _$RegisterRequest {
  const factory RegisterRequest({
    required String email,
    required String password,
    required String confirmPassword,
    required String fullName,
    String? phoneNumber,
    @Default(false) bool acceptTerms,
  }) = _RegisterRequest;

  factory RegisterRequest.fromJson(Map<String, dynamic> json) =>
      _$RegisterRequestFromJson(json);
}

/// Extension để validate
extension RegisterRequestX on RegisterRequest {
  /// Validate email
  String? validateEmail() {
    if (email.isEmpty) {
      return 'Email không được để trống';
    }
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    if (!emailRegex.hasMatch(email)) {
      return 'Email không hợp lệ';
    }
    return null;
  }

  /// Validate full name
  String? validateFullName() {
    if (fullName.isEmpty) {
      return 'Họ tên không được để trống';
    }
    if (fullName.length < 2) {
      return 'Họ tên phải có ít nhất 2 ký tự';
    }
    return null;
  }

  /// Validate password
  String? validatePassword() {
    if (password.isEmpty) {
      return 'Mật khẩu không được để trống';
    }
    if (password.length < 8) {
      return 'Mật khẩu phải có ít nhất 8 ký tự';
    }
    // Check có chữ hoa
    if (!password.contains(RegExp(r'[A-Z]'))) {
      return 'Mật khẩu phải có ít nhất 1 chữ hoa';
    }
    // Check có số
    if (!password.contains(RegExp(r'[0-9]'))) {
      return 'Mật khẩu phải có ít nhất 1 chữ số';
    }
    return null;
  }

  /// Validate confirm password
  String? validateConfirmPassword() {
    if (confirmPassword.isEmpty) {
      return 'Vui lòng xác nhận mật khẩu';
    }
    if (confirmPassword != password) {
      return 'Mật khẩu xác nhận không khớp';
    }
    return null;
  }

  /// Validate phone number (optional)
  String? validatePhoneNumber() {
    if (phoneNumber == null || phoneNumber!.isEmpty) {
      return null; // Optional field
    }
    final phoneRegex = RegExp(r'^(\+84|0)[0-9]{9}$');
    if (!phoneRegex.hasMatch(phoneNumber!)) {
      return 'Số điện thoại không hợp lệ';
    }
    return null;
  }

  /// Validate terms acceptance
  String? validateTerms() {
    if (!acceptTerms) {
      return 'Bạn phải đồng ý với điều khoản sử dụng';
    }
    return null;
  }

  /// Kiểm tra toàn bộ request có hợp lệ không
  bool get isValid {
    return validateEmail() == null &&
        validateFullName() == null &&
        validatePassword() == null &&
        validateConfirmPassword() == null &&
        validatePhoneNumber() == null &&
        validateTerms() == null;
  }

  /// Lấy danh sách requirements cho password
  List<PasswordRequirement> get passwordRequirements {
    return [
      PasswordRequirement(
        label: 'Ít nhất 8 ký tự',
        isMet: password.length >= 8,
      ),
      PasswordRequirement(
        label: 'Có chữ hoa',
        isMet: password.contains(RegExp(r'[A-Z]')),
      ),
      PasswordRequirement(
        label: 'Có chữ số',
        isMet: password.contains(RegExp(r'[0-9]')),
      ),
      PasswordRequirement(
        label: 'Mật khẩu khớp',
        isMet: password.isNotEmpty && password == confirmPassword,
      ),
    ];
  }
}

/// Password Requirement - Để hiển thị trong UI
class PasswordRequirement {
  final String label;
  final bool isMet;

  PasswordRequirement({
    required this.label,
    required this.isMet,
  });
}
