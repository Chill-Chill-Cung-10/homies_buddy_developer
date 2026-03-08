import 'package:cloud_firestore/cloud_firestore.dart';
import '../../data/models/user_model.dart';
import '../../core/services/firebase_service.dart';

/// User Repository - Quản lý operations liên quan đến user profiles
///
/// Handles:
/// - CRUD user profiles
/// - Follow/Unfollow
/// - Get followers/following lists
/// - Search users
class UserRepository {
  final FirebaseService _firebaseService = FirebaseService.instance;

  /// Get user profile by ID
  Future<UserModel?> getUserById(String userId) async {
    try {
      final doc = await _firebaseService.usersCollection.doc(userId).get();
      if (!doc.exists) return null;

      return UserModel.fromJson({...doc.data()!, 'id': doc.id});
    } catch (e) {
      throw UserRepositoryException('Failed to get user: $e');
    }
  }

  /// Get user profile stream (realtime updates)
  Stream<UserModel?> getUserStream(String userId) {
    return _firebaseService.usersCollection.doc(userId).snapshots().map((doc) {
      if (!doc.exists) return null;
      return UserModel.fromJson({...doc.data()!, 'id': doc.id});
    });
  }

  /// Create new user profile
  ///
  /// Được gọi sau khi Firebase Auth successful
  Future<void> createUserProfile(UserModel user) async {
    try {
      // Check username uniqueness
      final isUsernameAvailable = await checkUsernameAvailable(user.username);
      if (!isUsernameAvailable) {
        throw UserRepositoryException('Username already taken');
      }

      // Create user document
      await _firebaseService.usersCollection.doc(user.id).set({
        'username': user.username,
        'fullName': user.fullName,
        'avatarUrl': user.avatarUrl,
        'coverUrl': user.coverUrl,
        'headline': user.headline,
        'bio': user.bio,
        'location': user.location,
        'followerCount': 0,
        'followingCount': 0,
        'role': user.role.name,
        'createdAt': FieldValue.serverTimestamp(),
      });

      // Reserve username
      await _firebaseService.usernamesCollection.doc(user.username).set({
        'userId': user.id,
      });
    } catch (e) {
      throw UserRepositoryException('Failed to create user: $e');
    }
  }

  /// Update user profile
  Future<void> updateUserProfile(
    String userId,
    Map<String, dynamic> updates,
  ) async {
    try {
      // If updating username, check availability
      if (updates.containsKey('username')) {
        final newUsername = updates['username'] as String;
        final currentUser = await getUserById(userId);

        if (currentUser?.username != newUsername) {
          final isAvailable = await checkUsernameAvailable(newUsername);
          if (!isAvailable) {
            throw UserRepositoryException('Username already taken');
          }

          // Release old username & reserve new one
          if (currentUser != null) {
            await _firebaseService.usernamesCollection
                .doc(currentUser.username)
                .delete();
          }
          await _firebaseService.usernamesCollection.doc(newUsername).set({
            'userId': userId,
          });
        }
      }

      await _firebaseService.usersCollection.doc(userId).update(updates);
    } catch (e) {
      throw UserRepositoryException('Failed to update user: $e');
    }
  }

  /// Check if username is available
  Future<bool> checkUsernameAvailable(String username) async {
    try {
      final doc = await _firebaseService.usernamesCollection
          .doc(username)
          .get();
      return !doc.exists;
    } catch (e) {
      throw UserRepositoryException('Failed to check username: $e');
    }
  }

  /// Follow a user
  ///
  /// Cloud Function sẽ tự động:
  /// - +1 followingCount của current user
  /// - +1 followerCount của target user
  /// - Tạo notification cho target user
  Future<void> followUser(String targetUserId) async {
    final currentUserId = _firebaseService.currentUserId;
    if (currentUserId == null) {
      throw UserRepositoryException('User not authenticated');
    }

    if (currentUserId == targetUserId) {
      throw UserRepositoryException('Cannot follow yourself');
    }

    try {
      // Add to current user's following list
      await _firebaseService.userFollowing(currentUserId).doc(targetUserId).set(
        {'followedAt': FieldValue.serverTimestamp()},
      );

      // Add to target user's followers list
      await _firebaseService.userFollowers(targetUserId).doc(currentUserId).set(
        {'followedAt': FieldValue.serverTimestamp()},
      );
    } catch (e) {
      throw UserRepositoryException('Failed to follow user: $e');
    }
  }

  /// Unfollow a user
  Future<void> unfollowUser(String targetUserId) async {
    final currentUserId = _firebaseService.currentUserId;
    if (currentUserId == null) {
      throw UserRepositoryException('User not authenticated');
    }

    try {
      // Remove from current user's following list
      await _firebaseService
          .userFollowing(currentUserId)
          .doc(targetUserId)
          .delete();

      // Remove from target user's followers list
      await _firebaseService
          .userFollowers(targetUserId)
          .doc(currentUserId)
          .delete();
    } catch (e) {
      throw UserRepositoryException('Failed to unfollow user: $e');
    }
  }

  /// Check if current user is following target user
  Future<bool> isFollowing(String targetUserId) async {
    final currentUserId = _firebaseService.currentUserId;
    if (currentUserId == null) return false;

    try {
      final doc = await _firebaseService
          .userFollowing(currentUserId)
          .doc(targetUserId)
          .get();
      return doc.exists;
    } catch (e) {
      return false;
    }
  }

  /// Get followers list
  Stream<List<UserModel>> getFollowers(String userId, {int limit = 50}) {
    return _firebaseService
        .userFollowers(userId)
        .orderBy('followedAt', descending: true)
        .limit(limit)
        .snapshots()
        .asyncMap((snapshot) async {
          final followerIds = snapshot.docs.map((doc) => doc.id).toList();

          // Fetch user profiles
          final users = <UserModel>[];
          for (final followerId in followerIds) {
            final user = await getUserById(followerId);
            if (user != null) users.add(user);
          }

          return users;
        });
  }

  /// Get following list
  Stream<List<UserModel>> getFollowing(String userId, {int limit = 50}) {
    return _firebaseService
        .userFollowing(userId)
        .orderBy('followedAt', descending: true)
        .limit(limit)
        .snapshots()
        .asyncMap((snapshot) async {
          final followingIds = snapshot.docs.map((doc) => doc.id).toList();

          // Fetch user profiles
          final users = <UserModel>[];
          for (final followingId in followingIds) {
            final user = await getUserById(followingId);
            if (user != null) users.add(user);
          }

          return users;
        });
  }

  /// Search users by username or full name
  Future<List<UserModel>> searchUsers(String query, {int limit = 20}) async {
    try {
      if (query.isEmpty) return [];

      final queryLower = query.toLowerCase();

      // Search by username (starts with)
      final usernameResults = await _firebaseService.usersCollection
          .where('username', isGreaterThanOrEqualTo: queryLower)
          .where('username', isLessThan: '${queryLower}z')
          .limit(limit)
          .get();

      // Convert to UserModel list
      final users = usernameResults.docs
          .map((doc) => UserModel.fromJson({...doc.data(), 'id': doc.id}))
          .toList();

      return users;
    } catch (e) {
      throw UserRepositoryException('Failed to search users: $e');
    }
  }

  /// Get user's homies (buddies/friends)
  ///
  /// For now, returns following list
  /// TODO: Implement proper friends/buddies system
  Stream<List<UserModel>> getHomies(String userId) {
    return getFollowing(userId);
  }
}

/// Custom exception cho user operations
class UserRepositoryException implements Exception {
  final String message;
  UserRepositoryException(this.message);

  @override
  String toString() => 'UserRepositoryException: $message';
}
