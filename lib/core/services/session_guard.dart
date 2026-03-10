/// Session Guard Service - Kiểm tra và bảo vệ session cho mọi request
///
/// Service này đảm bảo rằng user session vẫn còn valid trước khi thực hiện
/// bất kỳ request nào. Nếu session expired hoặc invalid, sẽ throw exception.
///
/// Sử dụng:
/// ```dart
/// await SessionGuard.instance.checkSession();
/// ```
library;

import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'session_service.dart';
import 'firebase_service.dart';
import '../errors/failures.dart';

/// Session validation result
enum SessionStatus {
  valid,
  expired,
  invalid,
  noSession,
}

/// Session Guard Service - Singleton
class SessionGuard {
  static SessionGuard? _instance;
  
  /// Singleton instance
  static SessionGuard get instance {
    _instance ??= SessionGuard._();
    return _instance!;
  }

  SessionGuard._();

  final SessionService _sessionService = SessionService.instance;
  final FirebaseService _firebase = FirebaseService.instance;

  /// Check if session is valid and user is authenticated
  /// 
  /// Throws [AuthFailure] if:
  /// - No session found
  /// - Session expired
  /// - Firebase auth invalid
  /// - Token verification failed
  Future<void> checkSession() async {
    try {
      // 1. Check Firebase Auth state
      final firebaseUser = _firebase.currentUser;
      if (firebaseUser == null) {
        debugPrint('🚫 SessionGuard: No Firebase user authenticated');
        throw AuthFailure.unauthenticated();
      }

      // 2. Check stored session
      final session = await _sessionService.getSession();
      if (session == null) {
        debugPrint('🚫 SessionGuard: No session found in storage');
        throw AuthFailure.unauthenticated();
      }

      // 3. Verify user ID matches
      if (session.userId != firebaseUser.uid) {
        debugPrint('🚫 SessionGuard: User ID mismatch');
        await _sessionService.clearSession();
        throw AuthFailure.unauthenticated();
      }

      // 4. Check token expiration
      if (session.isExpired) {
        debugPrint('⚠️ SessionGuard: Session expired, attempting refresh...');
        await _refreshToken(firebaseUser);
        return;
      }

      // 5. Verify Firebase token is still valid
      try {
        final idToken = await firebaseUser.getIdToken();
        if (idToken == null) {
          debugPrint('🚫 SessionGuard: Failed to get ID token');
          throw AuthFailure.unauthenticated();
        }

        // Update token if it changed
        if (idToken != session.accessToken) {
          debugPrint('🔄 SessionGuard: Token refreshed by Firebase');
          await _sessionService.updateAccessToken(idToken);
        }

        debugPrint('✅ SessionGuard: Session valid for ${session.userId}');
      } catch (e) {
        debugPrint('🚫 SessionGuard: Token verification failed - $e');
        throw AuthFailure.unauthenticated();
      }

    } catch (e) {
      if (e is AuthFailure) {
        rethrow;
      }
      debugPrint('❌ SessionGuard: Unexpected error - $e');
      throw AuthFailure.unknown(message: 'Session check failed: $e');
    }
  }

  /// Validate session status without throwing
  Future<SessionStatus> validateSession() async {
    try {
      await checkSession();
      return SessionStatus.valid;
    } on AuthFailure catch (e) {
      if (e.code == 'unauthenticated' || e.code == 'not-authenticated') {
        return SessionStatus.noSession;
      }
      if (e.code == 'session-expired') {
        return SessionStatus.expired;
      }
      return SessionStatus.invalid;
    } catch (_) {
      return SessionStatus.invalid;
    }
  }

  /// Refresh Firebase token
  Future<void> _refreshToken(User firebaseUser) async {
    try {
      // Force refresh token from Firebase
      final newToken = await firebaseUser.getIdToken(true);
      if (newToken == null) {
        throw AuthFailure.sessionExpired();
      }

      // Calculate new expiration (Firebase tokens typically expire in 1 hour)
      final expiresAt = DateTime.now().add(const Duration(hours: 1));

      // Update session with new token
      await _sessionService.updateAccessToken(
        newToken,
        newExpiresAt: expiresAt,
      );

      debugPrint('✅ SessionGuard: Token refreshed successfully');
    } catch (e) {
      debugPrint('❌ SessionGuard: Token refresh failed - $e');
      await _sessionService.clearSession();
      throw AuthFailure.sessionExpired();
    }
  }

  /// Check if user is authenticated (quick check without validation)
  Future<bool> isAuthenticated() async {
    final firebaseUser = _firebase.currentUser;
    if (firebaseUser == null) return false;

    final session = await _sessionService.getSession();
    return session != null && session.userId == firebaseUser.uid;
  }

  /// Force logout and clear session
  Future<void> forceLogout() async {
    debugPrint('🚪 SessionGuard: Forcing logout');
    await _sessionService.clearSession();
    await _firebase.auth.signOut();
  }

  /// For testing
  @visibleForTesting
  static void reset() {
    _instance = null;
  }
}
