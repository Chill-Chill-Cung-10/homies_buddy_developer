/// Failure — Base class for all failures in Clean Architecture
///
/// Tất cả errors trong app được wrap thành Failure để:
/// 1. Tránh throw exceptions (crash-prone)
/// 2. Force handle errors explicitly với Either<Failure, T>
/// 3. Dễ test và maintain
///
/// Usage:
/// ```dart
/// Future<Either<Failure, User>> getUser(String id) async {
///   try {
///     final user = await api.getUser(id);
///     return Right(user);
///   } on SocketException {
///     return Left(NetworkFailure('No internet connection'));
///   } catch (e) {
///     return Left(ServerFailure(e.toString()));
///   }
/// }
/// ```
abstract class Failure {
  final String message;
  final String? code;
  final dynamic originalError;

  const Failure(this.message, {this.code, this.originalError});

  @override
  String toString() => 'Failure: $message${code != null ? ' (code: $code)' : ''}';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Failure && other.message == message && other.code == code;
  }

  @override
  int get hashCode => message.hashCode ^ code.hashCode;
}

// ═══════════════════════════════════════════════════════════════════════════
// VALIDATION FAILURES
// ═══════════════════════════════════════════════════════════════════════════

/// Validation failure — input không hợp lệ
class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}

// ═══════════════════════════════════════════════════════════════════════════
// NETWORK FAILURES
// ═══════════════════════════════════════════════════════════════════════════

/// Network failure — không có internet, timeout, etc.
class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'Network error occurred']);
}

/// Server failure — API trả về error
class ServerFailure extends Failure {
  final int? statusCode;

  const ServerFailure(super.message, {this.statusCode, super.code});
}

// ═══════════════════════════════════════════════════════════════════════════
// AUTH FAILURES
// ═══════════════════════════════════════════════════════════════════════════

/// Auth failure — authentication errors
class AuthFailure extends Failure {
  const AuthFailure(super.message, {super.code});

  // Factory constructors for common auth errors
  factory AuthFailure.invalidCredentials() =>
      const AuthFailure('Email hoặc mật khẩu không đúng', code: 'invalid-credentials');

  factory AuthFailure.userNotFound() =>
      const AuthFailure('Tài khoản không tồn tại', code: 'user-not-found');

  factory AuthFailure.emailAlreadyInUse() =>
      const AuthFailure('Email đã được sử dụng', code: 'email-already-in-use');

  factory AuthFailure.weakPassword() =>
      const AuthFailure('Mật khẩu quá yếu', code: 'weak-password');

  factory AuthFailure.userDisabled() =>
      const AuthFailure('Tài khoản đã bị vô hiệu hóa', code: 'user-disabled');

  factory AuthFailure.tooManyRequests() =>
      const AuthFailure('Quá nhiều yêu cầu, vui lòng thử lại sau', code: 'too-many-requests');

  factory AuthFailure.operationNotAllowed() =>
      const AuthFailure('Thao tác không được phép', code: 'operation-not-allowed');

  factory AuthFailure.unauthorized() =>
      const AuthFailure('Bạn cần đăng nhập để thực hiện thao tác này', code: 'unauthorized');

  factory AuthFailure.unauthenticated() =>
      const AuthFailure('Phiên đăng nhập không hợp lệ', code: 'unauthenticated');

  factory AuthFailure.sessionExpired() =>
      const AuthFailure('Phiên đăng nhập đã hết hạn', code: 'session-expired');

  factory AuthFailure.unknown({String? message}) =>
      AuthFailure(message ?? 'Lỗi không xác định', code: 'unknown');
}

// ═══════════════════════════════════════════════════════════════════════════
// DATABASE FAILURES
// ═══════════════════════════════════════════════════════════════════════════

/// Database failure — lỗi khi đọc/ghi database
class DatabaseFailure extends Failure {
  const DatabaseFailure(super.message, {super.code});
}

/// Cache failure — lỗi khi đọc/ghi cache
class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Cache error occurred']);
}

// ═══════════════════════════════════════════════════════════════════════════
// STORAGE FAILURES
// ═══════════════════════════════════════════════════════════════════════════

/// Storage failure — lỗi khi upload/download file
class StorageFailure extends Failure {
  const StorageFailure(super.message, {super.code});
}

// ═══════════════════════════════════════════════════════════════════════════
// GENERIC FAILURES
// ═══════════════════════════════════════════════════════════════════════════

/// Unknown failure — lỗi không xác định
class UnknownFailure extends Failure {
  const UnknownFailure([super.message = 'Đã xảy ra lỗi không xác định']);
}

/// Not found failure — resource không tìm thấy
class NotFoundFailure extends Failure {
  const NotFoundFailure([super.message = 'Không tìm thấy dữ liệu']);
}

/// Permission failure — không có quyền truy cập
class PermissionFailure extends Failure {
  const PermissionFailure([super.message = 'Không có quyền thực hiện thao tác này']);
}
