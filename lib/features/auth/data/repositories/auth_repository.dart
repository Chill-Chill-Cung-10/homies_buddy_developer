import 'package:firebase_auth/firebase_auth.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sb;
import 'package:flutter/foundation.dart';

import '../../../../core/services/firebase_service.dart';
import '../models/user_model.dart';

/// Auth Repository - Handles authentication operations
/// 
/// Uses Firebase Auth for authentication and Supabase for user profile storage.
/// This creates a bridge between Firebase Auth (identity) and Supabase (data).
class AuthRepository {
  final FirebaseService _firebase = FirebaseService.instance;
  
  FirebaseAuth get _auth => _firebase.auth;
  
  /// Get Supabase client (nullable if not configured)
  sb.SupabaseClient? get _supabase {
    try {
      return sb.Supabase.instance.client;
    } catch (_) {
      return null;
    }
  }

  // ===========================================================================
  // AUTH STATE
  // ===========================================================================

  /// Current Firebase user
  User? get currentUser => _auth.currentUser;

  /// Current user ID
  String? get currentUserId => currentUser?.uid;

  /// Is user authenticated
  bool get isAuthenticated => currentUser != null;

  /// Auth state changes stream
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // ===========================================================================
  // SIGN IN
  // ===========================================================================

  /// Sign in with email and password
  Future<UserModel> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = credential.user;
      if (user == null) {
        throw AuthException('Sign in failed: No user returned');
      }

      // Fetch user profile from Supabase
      final profile = await _fetchUserProfile(user.uid);
      if (profile != null) {
        return profile;
      }

      // If no profile exists, create from Firebase user
      return _createUserModelFromFirebase(user);
    } on FirebaseAuthException catch (e) {
      throw AuthException(_mapFirebaseAuthError(e));
    } catch (e) {
      throw AuthException('Sign in failed: $e');
    }
  }

  // ===========================================================================
  // SIGN UP
  // ===========================================================================

  /// Create new account with email and password
  Future<UserModel> signUpWithEmail({
    required String email,
    required String password,
    required String fullName,
    required String username,
    String? phoneNumber,
    DateTime? dateOfBirth,
  }) async {
    try {
      // 1. Create Firebase Auth account
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = credential.user;
      if (user == null) {
        throw AuthException('Sign up failed: No user returned');
      }

      // 2. Update display name in Firebase
      await user.updateDisplayName(fullName);

      // 3. Send email verification
      if (!user.emailVerified) {
        await user.sendEmailVerification();
      }

      // 4. Create user profile in Supabase
      final userModel = UserModel(
        id: user.uid,
        email: email,
        fullName: fullName,
        username: username,
        phoneNumber: phoneNumber,
        dateOfBirth: dateOfBirth,
        isEmailVerified: user.emailVerified,
        createdAt: DateTime.now(),
      );

      await _createUserProfile(userModel);

      return userModel;
    } on FirebaseAuthException catch (e) {
      throw AuthException(_mapFirebaseAuthError(e));
    } catch (e) {
      throw AuthException('Sign up failed: $e');
    }
  }

  // ===========================================================================
  // SIGN OUT
  // ===========================================================================

  /// Sign out current user
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw AuthException('Sign out failed: $e');
    }
  }

  // ===========================================================================
  // PASSWORD RESET
  // ===========================================================================

  /// Send password reset email
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw AuthException(_mapFirebaseAuthError(e));
    } catch (e) {
      throw AuthException('Password reset failed: $e');
    }
  }

  /// Change password for current user
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      final user = currentUser;
      if (user == null || user.email == null) {
        throw AuthException('No authenticated user');
      }

      // Re-authenticate user
      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: currentPassword,
      );
      await user.reauthenticateWithCredential(credential);

      // Update password
      await user.updatePassword(newPassword);
    } on FirebaseAuthException catch (e) {
      throw AuthException(_mapFirebaseAuthError(e));
    } catch (e) {
      throw AuthException('Change password failed: $e');
    }
  }

  // ===========================================================================
  // EMAIL VERIFICATION
  // ===========================================================================

  /// Resend email verification
  Future<void> resendEmailVerification() async {
    try {
      final user = currentUser;
      if (user == null) {
        throw AuthException('No authenticated user');
      }
      await user.sendEmailVerification();
    } catch (e) {
      throw AuthException('Failed to send verification email: $e');
    }
  }

  /// Reload user to check email verification status
  Future<bool> checkEmailVerified() async {
    try {
      final user = currentUser;
      if (user == null) return false;

      await user.reload();
      return _auth.currentUser?.emailVerified ?? false;
    } catch (e) {
      return false;
    }
  }

  // ===========================================================================
  // USER PROFILE (Supabase)
  // ===========================================================================

  /// Fetch user profile from Supabase
  Future<UserModel?> _fetchUserProfile(String userId) async {
    final client = _supabase;
    if (client == null) return null;

    try {
      final response = await client
          .from('user_profile')
          .select()
          .eq('id', userId)
          .maybeSingle();

      if (response == null) return null;

      final firebaseUser = currentUser;
      return UserModel(
        id: response['id'] as String? ?? userId,
        email: response['email'] as String? ?? firebaseUser?.email ?? '',
        fullName:
            response['full_name'] as String? ?? firebaseUser?.displayName ?? '',
        username: response['username'] as String? ?? '',
        avatarUrl: response['avatar_url'] as String?,
        phoneNumber: firebaseUser?.phoneNumber,
        dateOfBirth: null,
        isEmailVerified: firebaseUser?.emailVerified ?? false,
        createdAt: response['created_at'] == null
            ? firebaseUser?.metadata.creationTime
            : DateTime.tryParse(response['created_at'] as String),
        updatedAt: response['updated_at'] == null
            ? null
            : DateTime.tryParse(response['updated_at'] as String),
      );
    } catch (e) {
      debugPrint('Failed to fetch user profile: $e');
      return null;
    }
  }

  /// Create user profile in Supabase
  Future<void> _createUserProfile(UserModel user) async {
    final client = _supabase;
    if (client == null) {
      debugPrint('⚠️ Supabase not configured, skipping profile creation');
      throw AuthException(
        'Supabase is not configured. Please run with SUPABASE_URL and SUPABASE_ANON_KEY.',
      );
    }

    try {
      final profilePayload = {
        'id': user.id,
        'email': user.email,
        'full_name': user.fullName,
        'avatar_url': user.avatarUrl ?? '',
      };

      debugPrint('Supabase sync start -> user_profile: $profilePayload');
      await client
          .from('user_profile')
          .upsert(profilePayload, onConflict: 'id');

      debugPrint('✅ Supabase sync success for userId=${user.id}');
    } catch (e) {
      debugPrint('❌ Failed to create user profile in Supabase: $e');
      throw AuthException(
        'Account created on Firebase but failed to sync Supabase profile: $e',
      );
    }
  }

  /// Update user profile in Supabase
  Future<void> updateUserProfile(UserModel user) async {
    final client = _supabase;
    if (client == null) return;

    try {
      final payload = {
        'email': user.email,
        'full_name': user.fullName,
        'avatar_url': user.avatarUrl ?? '',
      };

      await client
          .from('user_profile')
          .update(payload)
          .eq('id', user.id);
    } catch (e) {
      throw AuthException('Failed to update profile: $e');
    }
  }

  /// Get current user profile
  Future<UserModel?> getCurrentUserProfile() async {
    final userId = currentUserId;
    if (userId == null) return null;

    final profile = await _fetchUserProfile(userId);
    if (profile != null) return profile;

    // Fallback to Firebase user data
    final user = currentUser;
    if (user == null) return null;

    return _createUserModelFromFirebase(user);
  }

  // ===========================================================================
  // HELPERS
  // ===========================================================================

  /// Create UserModel from Firebase User
  UserModel _createUserModelFromFirebase(User user) {
    return UserModel(
      id: user.uid,
      email: user.email ?? '',
      fullName: user.displayName ?? '',
      username: user.email?.split('@').first ?? '',
      avatarUrl: user.photoURL,
      phoneNumber: user.phoneNumber,
      isEmailVerified: user.emailVerified,
      createdAt: user.metadata.creationTime,
    );
  }

  /// Map Firebase Auth errors to user-friendly messages
  String _mapFirebaseAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No account found with this email';
      case 'wrong-password':
        return 'Incorrect password';
      case 'invalid-email':
        return 'Invalid email address';
      case 'user-disabled':
        return 'This account has been disabled';
      case 'email-already-in-use':
        return 'An account already exists with this email';
      case 'weak-password':
        return 'Password is too weak';
      case 'operation-not-allowed':
        return 'This operation is not allowed';
      case 'too-many-requests':
        return 'Too many requests. Please try again later';
      case 'invalid-credential':
        return 'Invalid email or password';
      default:
        return e.message ?? 'Authentication error occurred';
    }
  }
}

/// Custom exception for auth operations
class AuthException implements Exception {
  final String message;
  
  AuthException(this.message);
  
  @override
  String toString() => message;
}
