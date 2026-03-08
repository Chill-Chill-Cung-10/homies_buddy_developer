import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/user_model.dart';
import '../../data/repositories/user_repository.dart';
import 'core_providers.dart';

// =============================================================================
// USER PROFILE PROVIDERS
// =============================================================================

/// Get current user profile (stream)
final currentUserProfileProvider = StreamProvider<UserModel?>((ref) {
  final userId = ref.watch(currentUserIdProvider);
  if (userId == null) return Stream.value(null);

  final repository = ref.watch(userRepositoryProvider);
  return repository.getUserStream(userId);
});

/// Get user profile by ID (stream)
final userProfileProvider = StreamProvider.family<UserModel?, String>((
  ref,
  userId,
) {
  final repository = ref.watch(userRepositoryProvider);
  return repository.getUserStream(userId);
});

/// Get user profile by ID (future - one-time fetch)
final userProfileFutureProvider = FutureProvider.family<UserModel?, String>((
  ref,
  userId,
) {
  final repository = ref.watch(userRepositoryProvider);
  return repository.getUserById(userId);
});

/// Check if username is available
final usernameAvailableProvider = FutureProvider.family<bool, String>((
  ref,
  username,
) {
  final repository = ref.watch(userRepositoryProvider);
  return repository.checkUsernameAvailable(username);
});

/// Check if following a user
final isFollowingProvider = FutureProvider.family<bool, String>((ref, userId) {
  final repository = ref.watch(userRepositoryProvider);
  return repository.isFollowing(userId);
});

/// Get followers of a user (stream)
final followersProvider = StreamProvider.family<List<UserModel>, String>((
  ref,
  userId,
) {
  final repository = ref.watch(userRepositoryProvider);
  return repository.getFollowers(userId);
});

/// Get following list of a user (stream)
final followingProvider = StreamProvider.family<List<UserModel>, String>((
  ref,
  userId,
) {
  final repository = ref.watch(userRepositoryProvider);
  return repository.getFollowing(userId);
});

/// Get homies/buddies of a user (stream)
final homiesProvider = StreamProvider.family<List<UserModel>, String>((
  ref,
  userId,
) {
  final repository = ref.watch(userRepositoryProvider);
  return repository.getHomies(userId);
});

/// Search users
final userSearchProvider = FutureProvider.family<List<UserModel>, String>((
  ref,
  query,
) {
  final repository = ref.watch(userRepositoryProvider);
  return repository.searchUsers(query);
});

// =============================================================================
// USER ACTIONS PROVIDER
// =============================================================================

/// Provider cho các actions liên quan đến user
///
/// Usage:
/// ```dart
/// final userActions = ref.read(userActionsProvider);
/// await userActions.followUser('userId123');
/// ```
final userActionsProvider = Provider<UserActions>((ref) {
  final repository = ref.watch(userRepositoryProvider);
  return UserActions(repository: repository);
});

class UserActions {
  final UserRepository repository;

  UserActions({required this.repository});

  /// Follow a user
  Future<void> followUser(String userId) async {
    await repository.followUser(userId);
  }

  /// Unfollow a user
  Future<void> unfollowUser(String userId) async {
    await repository.unfollowUser(userId);
  }

  /// Update user profile
  Future<void> updateProfile(
    String userId,
    Map<String, dynamic> updates,
  ) async {
    await repository.updateUserProfile(userId, updates);
  }

  /// Create user profile (first time)
  Future<void> createProfile(UserModel user) async {
    await repository.createUserProfile(user);
  }
}
