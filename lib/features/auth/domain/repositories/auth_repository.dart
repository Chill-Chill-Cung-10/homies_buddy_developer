import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../entities/auth_user.dart';

/// Abstract Auth Repository — Domain Layer Interface
///
/// Không import Firebase/Supabase. Implementation nằm ở data layer.
/// Tất cả methods trả về Either<Failure, T> để handle errors một cách rõ ràng.
abstract class AuthRepository {
  // ═══════════════════════════════════════════════════════════════════════════
  // AUTH STATE
  // ═══════════════════════════════════════════════════════════════════════════

  /// Current authenticated user (null if not logged in)
  AuthUserEntity? get currentUser;

  /// Is user authenticated
  bool get isAuthenticated;

  /// Auth state changes stream
  Stream<AuthUserEntity?> get authStateChanges;

  // ═══════════════════════════════════════════════════════════════════════════
  // SIGN IN
  // ═══════════════════════════════════════════════════════════════════════════

  /// Sign in with email and password
  Future<Either<Failure, AuthUserEntity>> signInWithEmail({
    required String email,
    required String password,
  });

  /// Sign in with Google
  Future<Either<Failure, AuthUserEntity>> signInWithGoogle();

  // ═══════════════════════════════════════════════════════════════════════════
  // SIGN UP
  // ═══════════════════════════════════════════════════════════════════════════

  /// Register new user with email and password
  Future<Either<Failure, AuthUserEntity>> signUp({
    required String email,
    required String password,
    required String fullName,
    required String username,
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // SIGN OUT
  // ═══════════════════════════════════════════════════════════════════════════

  /// Sign out current user
  Future<Either<Failure, Unit>> signOut();

  // ═══════════════════════════════════════════════════════════════════════════
  // PASSWORD
  // ═══════════════════════════════════════════════════════════════════════════

  /// Send password reset email
  Future<Either<Failure, Unit>> sendPasswordResetEmail(String email);

  /// Change password for current user
  Future<Either<Failure, Unit>> changePassword({
    required String currentPassword,
    required String newPassword,
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // EMAIL VERIFICATION
  // ═══════════════════════════════════════════════════════════════════════════

  /// Send email verification
  Future<Either<Failure, Unit>> sendEmailVerification();

  /// Reload user data (to check email verification status)
  Future<Either<Failure, AuthUserEntity>> reloadUser();
}
