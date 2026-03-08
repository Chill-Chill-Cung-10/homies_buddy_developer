/// Session Service - Manages user session with secure storage
///
/// Provides secure storage for:
/// - Access token (Firebase ID token)
/// - Refresh token
/// - User ID
/// - Session metadata
///
/// Uses flutter_secure_storage for encrypted storage on device.
library;

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/foundation.dart';

/// Session data model
class UserSession {
  final String userId;
  final String accessToken;
  final String refreshToken;
  final DateTime createdAt;
  final DateTime? expiresAt;

  const UserSession({
    required this.userId,
    required this.accessToken,
    required this.refreshToken,
    required this.createdAt,
    this.expiresAt,
  });

  bool get isExpired {
    if (expiresAt == null) return false;
    return DateTime.now().isAfter(expiresAt!);
  }

  Map<String, String> toStorageMap() {
    return {
      'userId': userId,
      'accessToken': accessToken,
      'refreshToken': refreshToken,
      'createdAt': createdAt.toIso8601String(),
      if (expiresAt != null) 'expiresAt': expiresAt!.toIso8601String(),
    };
  }

  factory UserSession.fromStorageMap(Map<String, String?> map) {
    return UserSession(
      userId: map['userId'] ?? '',
      accessToken: map['accessToken'] ?? '',
      refreshToken: map['refreshToken'] ?? '',
      createdAt: DateTime.tryParse(map['createdAt'] ?? '') ?? DateTime.now(),
      expiresAt: map['expiresAt'] != null 
          ? DateTime.tryParse(map['expiresAt']!)
          : null,
    );
  }
}

/// Session Service singleton for managing user sessions
class SessionService {
  static SessionService? _instance;
  
  /// Singleton instance
  static SessionService get instance {
    _instance ??= SessionService._();
    return _instance!;
  }

  SessionService._();

  /// For testing purposes
  @visibleForTesting
  static void reset() {
    _instance = null;
  }

  // Storage configuration for Android and iOS
  static const _androidOptions = AndroidOptions(
    encryptedSharedPreferences: true,
  );
  
  static const _iosOptions = IOSOptions(
    accessibility: KeychainAccessibility.first_unlock_this_device,
  );

  final FlutterSecureStorage _storage = const FlutterSecureStorage(
    aOptions: _androidOptions,
    iOptions: _iosOptions,
  );

  // Storage keys
  static const String _userIdKey = 'session_user_id';
  static const String _accessTokenKey = 'session_access_token';
  static const String _refreshTokenKey = 'session_refresh_token';
  static const String _createdAtKey = 'session_created_at';
  static const String _expiresAtKey = 'session_expires_at';

  /// Save user session
  Future<void> saveSession({
    required String userId,
    required String accessToken,
    required String refreshToken,
    DateTime? expiresAt,
  }) async {
    try {
      final now = DateTime.now();
      
      await Future.wait([
        _storage.write(key: _userIdKey, value: userId),
        _storage.write(key: _accessTokenKey, value: accessToken),
        _storage.write(key: _refreshTokenKey, value: refreshToken),
        _storage.write(key: _createdAtKey, value: now.toIso8601String()),
        if (expiresAt != null)
          _storage.write(key: _expiresAtKey, value: expiresAt.toIso8601String()),
      ]);
      
      debugPrint('✅ Session saved for user: $userId');
    } catch (e) {
      debugPrint('❌ Failed to save session: $e');
      rethrow;
    }
  }

  /// Get current session
  Future<UserSession?> getSession() async {
    try {
      final results = await Future.wait([
        _storage.read(key: _userIdKey),
        _storage.read(key: _accessTokenKey),
        _storage.read(key: _refreshTokenKey),
        _storage.read(key: _createdAtKey),
        _storage.read(key: _expiresAtKey),
      ]);

      final userId = results[0];
      final accessToken = results[1];
      final refreshToken = results[2];
      final createdAt = results[3];
      final expiresAt = results[4];

      if (userId == null || accessToken == null) {
        debugPrint('📭 No active session found');
        return null;
      }

      final session = UserSession(
        userId: userId,
        accessToken: accessToken,
        refreshToken: refreshToken ?? '',
        createdAt: DateTime.tryParse(createdAt ?? '') ?? DateTime.now(),
        expiresAt: expiresAt != null ? DateTime.tryParse(expiresAt) : null,
      );

      debugPrint('📬 Session loaded for user: $userId');
      return session;
    } catch (e) {
      debugPrint('❌ Failed to get session: $e');
      return null;
    }
  }

  /// Update access token (for token refresh)
  Future<void> updateAccessToken(String accessToken, {DateTime? newExpiresAt}) async {
    try {
      await _storage.write(key: _accessTokenKey, value: accessToken);
      if (newExpiresAt != null) {
        await _storage.write(key: _expiresAtKey, value: newExpiresAt.toIso8601String());
      }
      debugPrint('✅ Access token updated');
    } catch (e) {
      debugPrint('❌ Failed to update access token: $e');
      rethrow;
    }
  }

  /// Clear session (logout)
  Future<void> clearSession() async {
    try {
      await Future.wait([
        _storage.delete(key: _userIdKey),
        _storage.delete(key: _accessTokenKey),
        _storage.delete(key: _refreshTokenKey),
        _storage.delete(key: _createdAtKey),
        _storage.delete(key: _expiresAtKey),
      ]);
      debugPrint('✅ Session cleared');
    } catch (e) {
      debugPrint('❌ Failed to clear session: $e');
      rethrow;
    }
  }

  /// Check if session exists
  Future<bool> hasActiveSession() async {
    final session = await getSession();
    return session != null && !session.isExpired;
  }

  /// Get user ID from session
  Future<String?> getUserId() async {
    return _storage.read(key: _userIdKey);
  }

  /// Get access token from session
  Future<String?> getAccessToken() async {
    return _storage.read(key: _accessTokenKey);
  }
}
