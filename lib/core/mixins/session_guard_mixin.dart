/// Session Guard Mixin - Bảo vệ repository methods với session checking
///
/// Mixin này cung cấp các methods helper để wrap operations với
/// automatic session validation. Sử dụng trong các Repository classes.
///
/// Usage:
/// ```dart
/// class UserRepository with SessionGuardMixin {
///   Future<UserModel?> getUserById(String userId) async {
///     return guardedRequest(() async {
///       // Your repository logic here
///       final doc = await firestore.collection('users').doc(userId).get();
///       return UserModel.fromJson(doc.data());
///     });
///   }
/// }
/// ```
library;

import 'package:flutter/foundation.dart';
import '../services/session_guard.dart';
import '../errors/failures.dart';

// Export SessionStatus for consumers
export '../services/session_guard.dart' show SessionStatus;

/// Mixin để add session protection vào repository classes
mixin SessionGuardMixin {
  final SessionGuard _sessionGuard = SessionGuard.instance;

  /// Execute a request with automatic session checking
  /// 
  /// Checks session before executing the operation.
  /// If session is invalid, throws [AuthFailure].
  /// 
  /// Parameters:
  /// - [operation]: The async operation to execute
  /// - [requiresAuth]: Whether this operation requires authentication (default: true)
  /// - [operationName]: Name for logging (optional)
  Future<T> guardedRequest<T>(
    Future<T> Function() operation, {
    bool requiresAuth = true,
    String? operationName,
  }) async {
    final opName = operationName ?? 'Request';
    
    try {
      // Check session if authentication is required
      if (requiresAuth) {
        await _sessionGuard.checkSession();
        debugPrint('🛡️ SessionGuard: $opName - Session valid, proceeding');
      }

      // Execute the actual operation
      return await operation();
      
    } on AuthFailure {
      debugPrint('🚫 SessionGuard: $opName - Auth failed');
      rethrow;
    } catch (e) {
      debugPrint('❌ SessionGuard: $opName - Operation failed: $e');
      rethrow;
    }
  }

  /// Execute a stream operation with automatic session checking
  /// 
  /// Checks session before starting the stream.
  /// If session is invalid, emits error.
  Stream<T> guardedStream<T>(
    Stream<T> Function() streamOperation, {
    bool requiresAuth = true,
    String? operationName,
  }) async* {
    final opName = operationName ?? 'Stream';
    
    try {
      // Check session if authentication is required
      if (requiresAuth) {
        await _sessionGuard.checkSession();
        debugPrint('🛡️ SessionGuard: $opName - Session valid, starting stream');
      }

      // Yield values from the stream
      await for (final value in streamOperation()) {
        yield value;
      }
      
    } on AuthFailure catch (e) {
      debugPrint('🚫 SessionGuard: $opName - Auth failed');
      throw e;
    } catch (e) {
      debugPrint('❌ SessionGuard: $opName - Stream failed: $e');
      rethrow;
    }
  }

  /// Execute batch operations with session checking
  /// 
  /// Useful for operations that involve multiple requests
  Future<List<T>> guardedBatch<T>(
    List<Future<T> Function()> operations, {
    bool requiresAuth = true,
    String? operationName,
  }) async {
    final opName = operationName ?? 'Batch';
    
    try {
      // Check session once for all operations
      if (requiresAuth) {
        await _sessionGuard.checkSession();
        debugPrint(
          '🛡️ SessionGuard: $opName - Session valid, executing ${operations.length} operations',
        );
      }

      // Execute all operations
      final results = await Future.wait(
        operations.map((op) => op()),
      );

      return results;
      
    } on AuthFailure {
      debugPrint('🚫 SessionGuard: $opName - Auth failed');
      rethrow;
    } catch (e) {
      debugPrint('❌ SessionGuard: $opName - Batch failed: $e');
      rethrow;
    }
  }

  /// Check if user is authenticated (without throwing)
  Future<bool> isUserAuthenticated() async {
    return await _sessionGuard.isAuthenticated();
  }

  /// Validate current session status
  Future<SessionStatus> checkSessionStatus() async {
    return await _sessionGuard.validateSession();
  }
}
