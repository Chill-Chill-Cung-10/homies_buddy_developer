/// [Refactored] Phase 3.5 — Extracted from profile_mock_data.dart
/// Mock user data: UserModel definitions + lookup
library;

import '../../../data/models/user_model.dart';
import 'mock_user_posts.dart';

class MockUsers {
  /// Lấy UserModel theo authorId
  static UserModel getUserByAuthorId(String authorId) {
    return usersMap[authorId] ?? _defaultUser(authorId);
  }

  /// Lấy UserModel theo username (cho mention tap)
  static UserModel? getUserByUsername(String username) {
    final cleanUsername = username.startsWith('@')
        ? username.substring(1)
        : username;
    try {
      return usersMap.values.firstWhere(
        (user) => user.username.toLowerCase() == cleanUsername.toLowerCase(),
      );
    } catch (_) {
      return null;
    }
  }

  /// Default user khi không tìm thấy
  static UserModel _defaultUser(String authorId) {
    return UserModel(
      id: authorId,
      username: 'user_$authorId',
      fullName: 'Unknown User',
      avatarUrl: 'https://picsum.photos/150/150?random=999',
      coverUrl: 'https://picsum.photos/800/1200?random=999',
      location: 'Unknown',
      followerCount: 0,
      followingCount: 0,
      isFollowedByMe: false,
    );
  }

  // ---- Human Buddies ----
  static final jackUser = UserModel(
    id: 'buddy1',
    username: 'jack_roserna',
    fullName: 'Jack Roserna',
    avatarUrl: 'https://picsum.photos/150/150?random=301',
    coverUrl: 'https://picsum.photos/800/1200?random=301',
    location: 'New York, USA',
    followerCount: 3200,
    followingCount: 180,
    isFollowedByMe: true,
  );

  static final haiiaUser = UserModel(
    id: 'buddy2',
    username: 'haiia',
    fullName: 'Haiia Nguyen',
    avatarUrl: 'https://picsum.photos/150/150?random=302',
    coverUrl: 'https://picsum.photos/800/1200?random=302',
    location: 'Ho Chi Minh, Vietnam',
    followerCount: 1499,
    followingCount: 220,
    isFollowedByMe: false,
  );

  static final homiesbuddyUser = UserModel(
    id: 'user6',
    username: 'homiesbuddy',
    fullName: 'Homies Buddy Official',
    avatarUrl: 'https://picsum.photos/150/150?random=401',
    coverUrl: 'https://picsum.photos/800/1200?random=401',
    location: 'Global',
    followerCount: 25000,
    followingCount: 500,
    isFollowedByMe: true,
  );

  static final buddyUser = UserModel(
    id: 'user7',
    username: 'buddy',
    fullName: 'Buddy',
    avatarUrl: 'https://picsum.photos/150/150?random=402',
    coverUrl: 'https://picsum.photos/800/1200?random=402',
    location: 'Everywhere',
    followerCount: 8500,
    followingCount: 150,
    isFollowedByMe: false,
  );

  // ---- User Map ----
  static final Map<String, UserModel> usersMap = {
    'user1': UserModel(
      id: 'user1',
      username: 'salahhh',
      fullName: 'Salahhh Home',
      avatarUrl: 'https://picsum.photos/800/450?random=10',
      coverUrl: 'https://picsum.photos/800/1200?random=10',
      location: 'California, USA',
      humanBuddies: [jackUser, haiiaUser],
      followerCount: 1499,
      followingCount: 340,
      isFollowedByMe: false,
      posts: MockUserPosts.salahPosts,
    ),
    'user2': UserModel(
      id: 'user2',
      username: 'buddy_golden',
      fullName: 'Buddy the Golden',
      avatarUrl: 'https://picsum.photos/150/150?random=102',
      coverUrl: 'https://picsum.photos/800/1200?random=20',
      location: 'Texas, USA',
      humanBuddies: [jackUser],
      followerCount: 2100,
      followingCount: 150,
      isFollowedByMe: true,
      posts: MockUserPosts.buddyPosts,
    ),
    'user3': UserModel(
      id: 'user3',
      username: 'luna_max',
      fullName: 'Luna & Max',
      avatarUrl: 'https://picsum.photos/150/150?random=103',
      coverUrl: 'https://picsum.photos/800/1200?random=30',
      location: 'London, UK',
      humanBuddies: [haiiaUser],
      followerCount: 8700,
      followingCount: 420,
      isFollowedByMe: true,
      posts: MockUserPosts.lunaPosts,
    ),
    'user4': UserModel(
      id: 'user4',
      username: 'charlie_corgi',
      fullName: 'Charlie the Corgi',
      avatarUrl: 'https://picsum.photos/150/150?random=104',
      coverUrl: 'https://picsum.photos/800/1200?random=40',
      location: 'Sydney, Australia',
      humanBuddies: [jackUser, haiiaUser],
      followerCount: 1500,
      followingCount: 90,
      isFollowedByMe: false,
      posts: [],
    ),
    'user5': UserModel(
      id: 'user5',
      username: 'milo_cat',
      fullName: 'Milo the Cat',
      avatarUrl: 'https://picsum.photos/150/150?random=105',
      coverUrl: 'https://picsum.photos/800/1200?random=50',
      location: 'Tokyo, Japan',
      humanBuddies: [],
      followerCount: 950,
      followingCount: 60,
      isFollowedByMe: true,
      posts: [],
    ),
    // Buddy users referenced by username for mention taps
    'buddy1': jackUser,
    'buddy2': haiiaUser,
    'user6': homiesbuddyUser,
    'user7': buddyUser,
  };
}
