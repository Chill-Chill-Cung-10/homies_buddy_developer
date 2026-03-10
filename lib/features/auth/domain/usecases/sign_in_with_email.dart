import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../entities/auth_user.dart';
import '../repositories/auth_repository.dart';

/// Sign In With Email UseCase
///
/// Single responsibility: validate input và gọi repository.
/// Trả về Either<Failure, AuthUserEntity> để presentation layer handle.
class SignInWithEmail {
  final AuthRepository _repository;

  const SignInWithEmail(this._repository);

  Future<Either<Failure, AuthUserEntity>> call({
    required String email,
    required String password,
  }) async {
    // Input validation
    final trimmedEmail = email.trim();
    final trimmedPassword = password.trim();

    if (trimmedEmail.isEmpty) {
      return Left(ValidationFailure('Email không được để trống'));
    }

    if (!_isValidEmail(trimmedEmail)) {
      return Left(ValidationFailure('Email không hợp lệ'));
    }

    if (trimmedPassword.isEmpty) {
      return Left(ValidationFailure('Mật khẩu không được để trống'));
    }

    if (trimmedPassword.length < 6) {
      return Left(ValidationFailure('Mật khẩu phải có ít nhất 6 ký tự'));
    }

    // Delegate to repository
    return _repository.signInWithEmail(
      email: trimmedEmail,
      password: trimmedPassword,
    );
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }
}
