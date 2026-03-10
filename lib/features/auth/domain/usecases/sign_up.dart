import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../entities/auth_user.dart';
import '../repositories/auth_repository.dart';

/// Sign Up UseCase
///
/// Single responsibility: validate input và gọi repository.
class SignUp {
  final AuthRepository _repository;

  const SignUp(this._repository);

  Future<Either<Failure, AuthUserEntity>> call({
    required String email,
    required String password,
    required String fullName,
    required String username,
  }) async {
    // Input validation
    final trimmedEmail = email.trim();
    final trimmedPassword = password.trim();
    final trimmedFullName = fullName.trim();
    final trimmedUsername = username.trim();

    if (trimmedEmail.isEmpty) {
      return Left(ValidationFailure('Email không được để trống'));
    }

    if (!_isValidEmail(trimmedEmail)) {
      return Left(ValidationFailure('Email không hợp lệ'));
    }

    if (trimmedFullName.isEmpty) {
      return Left(ValidationFailure('Họ tên không được để trống'));
    }

    if (trimmedUsername.isEmpty) {
      return Left(ValidationFailure('Username không được để trống'));
    }

    if (trimmedUsername.length < 3) {
      return Left(ValidationFailure('Username phải có ít nhất 3 ký tự'));
    }

    if (!_isValidUsername(trimmedUsername)) {
      return Left(ValidationFailure('Username chỉ được chứa chữ cái, số và gạch dưới'));
    }

    // Password validation
    final passwordValidation = _validatePassword(trimmedPassword);
    if (passwordValidation != null) {
      return Left(ValidationFailure(passwordValidation));
    }

    // Delegate to repository
    return _repository.signUp(
      email: trimmedEmail,
      password: trimmedPassword,
      fullName: trimmedFullName,
      username: trimmedUsername,
    );
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  bool _isValidUsername(String username) {
    return RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(username);
  }

  String? _validatePassword(String password) {
    if (password.isEmpty) {
      return 'Mật khẩu không được để trống';
    }
    if (password.length < 8) {
      return 'Mật khẩu phải có ít nhất 8 ký tự';
    }
    if (!password.contains(RegExp(r'[A-Z]'))) {
      return 'Mật khẩu phải chứa ít nhất 1 chữ hoa';
    }
    if (!password.contains(RegExp(r'[a-z]'))) {
      return 'Mật khẩu phải chứa ít nhất 1 chữ thường';
    }
    if (!password.contains(RegExp(r'[0-9]'))) {
      return 'Mật khẩu phải chứa ít nhất 1 chữ số';
    }
    return null;
  }
}
