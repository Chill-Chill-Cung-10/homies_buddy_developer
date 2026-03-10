/// Profile Providers - Manages user profile state and operations
///
/// Provides:
/// - Current user profile (fetched from Supabase)
/// - Profile update operations
/// - Profile loading states
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sb;
import 'package:flutter/foundation.dart';

import '../../../../data/models/user_model.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../auth/data/models/user_model.dart' as auth;

// =============================================================================
// PROFILE STATE
// =============================================================================

/// Profile state with loading/error handling
class ProfileState {
  final UserModel? user;
  final bool isLoading;
  final String? errorMessage;

  const ProfileState({
    this.user,
    this.isLoading = false,
    this.errorMessage,
  });

  ProfileState copyWith({
    UserModel? user,
    bool? isLoading,
    String? errorMessage,
  }) {
    return ProfileState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }

  factory ProfileState.initial() => const ProfileState();
  factory ProfileState.loading() => const ProfileState(isLoading: true);
  factory ProfileState.error(String message) => ProfileState(errorMessage: message);
  factory ProfileState.loaded(UserModel user) => ProfileState(user: user);
}

// =============================================================================
// PROFILE NOTIFIER
// =============================================================================

/// Profile state notifier - manages profile data
class ProfileNotifier extends StateNotifier<ProfileState> {
  final Ref _ref;

  ProfileNotifier(this._ref) : super(ProfileState.initial()) {
    // Load profile when auth state changes
    _ref.listen(currentAuthUserProvider, (previous, current) {
      if (current != null) {
        loadProfile();
      } else {
        state = ProfileState.initial();
      }
    });

    // Initial load if already authenticated
    final authUser = _ref.read(currentAuthUserProvider);
    if (authUser != null) {
      loadProfile();
    }
  }

  /// Get Supabase client
  sb.SupabaseClient? get _supabase {
    try {
      return sb.Supabase.instance.client;
    } catch (_) {
      return null;
    }
  }

  /// Load user profile from Supabase
  Future<void> loadProfile() async {
    final authUser = _ref.read(currentAuthUserProvider);
    if (authUser == null) {
      state = ProfileState.error('Not authenticated');
      return;
    }

    state = ProfileState.loading();

    try {
      final client = _supabase;
      if (client == null) {
        // Fallback to auth user data if Supabase not configured
        state = ProfileState.loaded(_convertAuthUserToProfile(authUser));
        return;
      }

      // Fetch profile from Supabase
      final response = await client
          .from('user_profile')
          .select()
          .eq('id', authUser.id)
          .maybeSingle();

      if (response == null) {
        // Use auth user data if no profile found
        state = ProfileState.loaded(_convertAuthUserToProfile(authUser));
        return;
      }

      // Convert to UserModel
      final profile = UserModel(
        id: response['id'] as String? ?? authUser.id,
        username: response['username'] as String? ?? authUser.username,
        fullName: response['full_name'] as String? ?? authUser.fullName,
        avatarUrl: response['avatar_url'] as String? ?? authUser.avatarUrl ?? '',
        coverUrl: response['cover_url'] as String?,
        bio: response['bio'] as String?,
        location: response['location'] as String?,
        followerCount: (response['follower_count'] as num?)?.toInt() ?? 0,
        followingCount: (response['following_count'] as num?)?.toInt() ?? 0,
        createdAt: response['created_at'] != null
            ? DateTime.tryParse(response['created_at'] as String)
            : authUser.createdAt,
      );

      state = ProfileState.loaded(profile);
      debugPrint('✅ Profile loaded for user: ${profile.id}');
    } catch (e) {
      debugPrint('❌ Failed to load profile: $e');
      // Fallback to auth user data on error
      state = ProfileState.loaded(_convertAuthUserToProfile(authUser));
    }
  }

  /// Convert auth user to community profile model
  UserModel _convertAuthUserToProfile(auth.UserModel authUser) {
    return UserModel(
      id: authUser.id,
      username: authUser.username,
      fullName: authUser.fullName,
      avatarUrl: authUser.avatarUrl ?? '',
    );
  }

  /// Update user profile
  Future<bool> updateProfile({
    String? fullName,
    String? username,
    String? avatarUrl,
    String? coverUrl,
    String? headline,
    String? bio,
    String? location,
  }) async {
    final currentUser = state.user;
    if (currentUser == null) return false;
    final authUser = _ref.read(currentAuthUserProvider);
    if (authUser == null) return false;

    try {
      final client = _supabase;
      if (client == null) {
        state = ProfileState.error('Supabase not configured');
        return false;
      }

      // Resolve email for upsert insert path (email column is NOT NULL).
      final resolvedEmail = authUser.email.trim().isNotEmpty
          ? authUser.email.trim()
          : (client.auth.currentUser?.email?.trim() ?? '');
      if (resolvedEmail.isEmpty) {
        debugPrint('❌ Cannot upsert profile: missing email for user ${currentUser.id}');
        state = state.copyWith(errorMessage: 'Missing email. Please re-login and try again.');
        return false;
      }

      // Convert empty strings to null to avoid overwriting with empty values
      final effectiveAvatarUrl = (avatarUrl != null && avatarUrl.isNotEmpty) ? avatarUrl : null;
      final effectiveCoverUrl = (coverUrl != null && coverUrl.isNotEmpty) ? coverUrl : null;

      final updates = <String, dynamic>{
        'id': currentUser.id, // Required for upsert
        'email': resolvedEmail, // Required for insert (NOT NULL constraint)
        'full_name': ?fullName,
        'username': ?username,
        'avatar_url': ?effectiveAvatarUrl,
        'cover_url': ?effectiveCoverUrl,
        'headline': ?headline,
        'bio': ?bio,
        'location': ?location,
        'updated_at': DateTime.now().toIso8601String(),
      };

      if (updates.length <= 3) return true; // Only id, email, and updated_at, no changes

      // Debug: Log what we're sending
      debugPrint('📤 Upserting profile with: $updates');
      debugPrint('📤 User ID: ${currentUser.id}');

      // Upsert (insert if not exists, update if exists) and select to verify
      final result = await client
          .from('user_profile')
          .upsert(updates, onConflict: 'id')
          .select()
          .maybeSingle();

      debugPrint('📥 Update result: $result');

      if (result == null) {
        debugPrint('⚠️ No row returned after update - row may not exist');
      }

      // Update local state
      final updatedUser = currentUser.copyWith(
        fullName: fullName ?? currentUser.fullName,
        username: username ?? currentUser.username,
        avatarUrl: effectiveAvatarUrl ?? currentUser.avatarUrl,
        coverUrl: effectiveCoverUrl ?? currentUser.coverUrl,
        headline: headline ?? currentUser.headline,
        bio: bio ?? currentUser.bio,
        location: location ?? currentUser.location,
      );

      state = ProfileState.loaded(updatedUser);
      debugPrint('✅ Profile updated locally');
      return true;
    } catch (e) {
      debugPrint('❌ Failed to update profile: $e');
      state = state.copyWith(errorMessage: 'Failed to update profile: $e');
      return false;
    }
  }

  /// Refresh profile
  Future<void> refresh() => loadProfile();
}

// =============================================================================
// PROVIDERS
// =============================================================================

/// Profile state provider
final profileStateProvider = StateNotifierProvider<ProfileNotifier, ProfileState>((ref) {
  return ProfileNotifier(ref);
});

/// Current user profile (convenience provider)
final currentUserProfileProvider = Provider<UserModel?>((ref) {
  return ref.watch(profileStateProvider).user;
});

/// Profile loading state
final isProfileLoadingProvider = Provider<bool>((ref) {
  return ref.watch(profileStateProvider).isLoading;
});

/// Profile error message
final profileErrorProvider = Provider<String?>((ref) {
  return ref.watch(profileStateProvider).errorMessage;
});
