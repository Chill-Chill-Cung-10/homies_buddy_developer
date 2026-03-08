/// Password Validator — Shared password validation logic
///
/// Ensures consistent password rules across registration and password change.
/// Requirements:
/// - At least 8 characters
/// - One uppercase letter (A-Z)
/// - One lowercase letter (a-z)
/// - One number (0-9)
/// - One special character (!@#$%^&*(),.?":{}|<>)
class PasswordValidator {
  PasswordValidator._();

  /// Minimum password length
  static const int minLength = 8;

  /// Check if password has minimum length
  static bool hasMinLength(String password) => password.length >= minLength;

  /// Check if password has uppercase letter
  static bool hasUppercase(String password) =>
      password.contains(RegExp(r'[A-Z]'));

  /// Check if password has lowercase letter
  static bool hasLowercase(String password) =>
      password.contains(RegExp(r'[a-z]'));

  /// Check if password has number
  static bool hasNumber(String password) => password.contains(RegExp(r'[0-9]'));

  /// Check if password has special character
  static bool hasSpecialChar(String password) =>
      password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));

  /// Validate all password requirements
  static PasswordValidationResult validate(String password) {
    return PasswordValidationResult(
      hasMinLength: hasMinLength(password),
      hasUppercase: hasUppercase(password),
      hasLowercase: hasLowercase(password),
      hasNumber: hasNumber(password),
      hasSpecialChar: hasSpecialChar(password),
    );
  }

  /// Check if password meets all requirements
  static bool isValid(String password) {
    final result = validate(password);
    return result.isValid;
  }

  /// Get error message for invalid password
  static String? getErrorMessage(String password) {
    if (password.isEmpty) {
      return 'Please enter a password';
    }
    if (!isValid(password)) {
      return 'Password does not meet requirements';
    }
    return null;
  }

  /// List of all requirements for UI display
  static List<PasswordRequirement> get requirements => [
        PasswordRequirement(
          label: 'At least 8 characters',
          check: hasMinLength,
        ),
        PasswordRequirement(
          label: 'One uppercase letter (A-Z)',
          check: hasUppercase,
        ),
        PasswordRequirement(
          label: 'One lowercase letter (a-z)',
          check: hasLowercase,
        ),
        PasswordRequirement(
          label: 'One number (0-9)',
          check: hasNumber,
        ),
        PasswordRequirement(
          label: 'One special character (!@#\$%^&*)',
          check: hasSpecialChar,
        ),
      ];
}

/// Password validation result
class PasswordValidationResult {
  final bool hasMinLength;
  final bool hasUppercase;
  final bool hasLowercase;
  final bool hasNumber;
  final bool hasSpecialChar;

  const PasswordValidationResult({
    required this.hasMinLength,
    required this.hasUppercase,
    required this.hasLowercase,
    required this.hasNumber,
    required this.hasSpecialChar,
  });

  /// Check if all requirements are met
  bool get isValid =>
      hasMinLength &&
      hasUppercase &&
      hasLowercase &&
      hasNumber &&
      hasSpecialChar;

  /// Count of requirements met
  int get metCount {
    int count = 0;
    if (hasMinLength) count++;
    if (hasUppercase) count++;
    if (hasLowercase) count++;
    if (hasNumber) count++;
    if (hasSpecialChar) count++;
    return count;
  }

  /// Total number of requirements
  int get totalCount => 5;
}

/// Password requirement model for UI
class PasswordRequirement {
  final String label;
  final bool Function(String password) check;

  const PasswordRequirement({
    required this.label,
    required this.check,
  });

  bool isMet(String password) => check(password);
}
