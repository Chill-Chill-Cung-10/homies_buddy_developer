import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/services/session_service.dart';
import '../../data/models/auth_state.dart';
import '../../data/models/user_model.dart';
import '../../data/repositories/auth_repository.dart';

// Export AuthState and extension for consumers
export '../../data/models/auth_state.dart';

// =============================================================================
// REPOSITORY PROVIDER
// =============================================================================

/// Auth Repository provider
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository();
});

// =============================================================================
// AUTH STATE PROVIDERS
// =============================================================================

/// Stream of Firebase Auth state changes
final authStateChangesProvider = StreamProvider<User?>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return repository.authStateChanges;
});

/// Main auth state provider - manages authentication lifecycle
final authStateProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return AuthNotifier(repository);
});

/// Current authenticated user
final currentAuthUserProvider = Provider<UserModel?>((ref) {
  final authState = ref.watch(authStateProvider);
  return authState.user;
});

/// Check if user is authenticated
final isAuthenticatedProvider = Provider<bool>((ref) {
  final authState = ref.watch(authStateProvider);
  return authState.isAuthenticated;
});

// =============================================================================
// AUTH NOTIFIER
// =============================================================================

/// Auth State Notifier - manages auth operations and state
class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _repository;
  final SessionService _sessionService = SessionService.instance;
  StreamSubscription<User?>? _authSubscription;

  AuthNotifier(this._repository) : super(const AuthState.initial()) {
    _init();
  }

  /// Initialize auth state listener
  void _init() {
    _authSubscription = _repository.authStateChanges.listen(
      _onAuthStateChanged,
      onError: (error) {
        state = AuthState.error(message: 'Auth error: $error');
      },
    );
  }

  /// Handle Firebase auth state changes
  Future<void> _onAuthStateChanged(User? firebaseUser) async {
    if (firebaseUser == null) {
      // Clear session when user is not authenticated
      await _sessionService.clearSession();
      state = const AuthState.unauthenticated();
      return;
    }

    // Fetch full user profile
    try {
      final userProfile = await _repository.getCurrentUserProfile();
      if (userProfile != null) {
        final accessToken = await firebaseUser.getIdToken() ?? '';
        final refreshToken = firebaseUser.refreshToken ?? '';
        
        // Save session to secure storage
        await _sessionService.saveSession(
          userId: userProfile.id,
          accessToken: accessToken,
          refreshToken: refreshToken,
        );
        
        state = AuthState.authenticated(
          user: userProfile,
          accessToken: accessToken,
          refreshToken: refreshToken,
        );
      } else {
        state = const AuthState.unauthenticated();
      }
    } catch (e) {
      state = AuthState.error(message: 'Failed to load user profile: $e');
    }
  }

  // ===========================================================================
  // AUTH ACTIONS
  // ===========================================================================

  /// Sign in with email and password
  Future<void> signInWithEmail({
    required String email,
    required String password,
  }) async {
    state = const AuthState.loading();

    try {
      final user = await _repository.signInWithEmail(
        email: email,
        password: password,
      );

      final token = await _repository.currentUser?.getIdToken() ?? '';
      state = AuthState.authenticated(
        user: user,
        accessToken: token,
        refreshToken: _repository.currentUser?.refreshToken ?? '',
      );
    } on AuthException catch (e) {
      state = AuthState.error(message: e.message);
    } catch (e) {
      state = AuthState.error(message: 'Sign in failed: $e');
    }
  }

  /// Sign up with email and password
  Future<void> signUpWithEmail({
    required String email,
    required String password,
    required String fullName,
    required String username,
    String? phoneNumber,
    DateTime? dateOfBirth,
  }) async {
    state = const AuthState.loading();

    try {
      final user = await _repository.signUpWithEmail(
        email: email,
        password: password,
        fullName: fullName,
        username: username,
        phoneNumber: phoneNumber,
        dateOfBirth: dateOfBirth,
      );

      final token = await _repository.currentUser?.getIdToken() ?? '';
      state = AuthState.authenticated(
        user: user,
        accessToken: token,
        refreshToken: _repository.currentUser?.refreshToken ?? '',
      );
    } on AuthException catch (e) {
      state = AuthState.error(message: e.message);
    } catch (e) {
      state = AuthState.error(message: 'Sign up failed: $e');
    }
  }

  /// Sign out
  Future<void> signOut() async {
    try {
      // Clear session from secure storage
      await _sessionService.clearSession();
      await _repository.signOut();
      state = const AuthState.unauthenticated();
    } catch (e) {
      state = AuthState.error(message: 'Sign out failed: $e');
    }
  }

  /// Send password reset email
  Future<bool> sendPasswordResetEmail(String email) async {
    try {
      await _repository.sendPasswordResetEmail(email);
      return true;
    } on AuthException {
      return false;
    }
  }

  /// Change password
  Future<bool> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      await _repository.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
      );
      return true;
    } on AuthException {
      return false;
    }
  }

  /// Resend email verification
  Future<bool> resendEmailVerification() async {
    try {
      await _repository.resendEmailVerification();
      return true;
    } catch (_) {
      return false;
    }
  }

  /// Check email verification status
  Future<bool> checkEmailVerified() async {
    final verified = await _repository.checkEmailVerified();
    if (verified && state.user != null) {
      // Update state with verified status
      final updatedUser = state.user!.copyWith(isEmailVerified: true);
      state = AuthState.authenticated(
        user: updatedUser,
        accessToken: state.accessToken ?? '',
        refreshToken: '',
      );
    }
    return verified;
  }

  /// Reset to initial state (for error recovery)
  void resetState() {
    state = const AuthState.initial();
    _init();
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }
}

// =============================================================================
// ACTION PROVIDERS (convenience)
// =============================================================================

/// Convenience provider for auth actions
final authActionsProvider = Provider<AuthActions>((ref) {
  final notifier = ref.watch(authStateProvider.notifier);
  return AuthActions(notifier);
});

/// Auth actions wrapper for easier usage in UI
class AuthActions {
  final AuthNotifier _notifier;

  AuthActions(this._notifier);

  Future<void> signIn({
    required String email,
    required String password,
  }) =>
      _notifier.signInWithEmail(email: email, password: password);

  Future<void> signUp({
    required String email,
    required String password,
    required String fullName,
    required String username,
    String? phoneNumber,
    DateTime? dateOfBirth,
  }) =>
      _notifier.signUpWithEmail(
        email: email,
        password: password,
        fullName: fullName,
        username: username,
        phoneNumber: phoneNumber,
        dateOfBirth: dateOfBirth,
      );

  Future<void> signOut() => _notifier.signOut();

  Future<bool> sendPasswordReset(String email) =>
      _notifier.sendPasswordResetEmail(email);

  Future<bool> changePassword({
    required String currentPassword,
    required String newPassword,
  }) =>
      _notifier.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
      );

  Future<bool> resendVerificationEmail() => _notifier.resendEmailVerification();

  Future<bool> checkEmailVerified() => _notifier.checkEmailVerified();
}
