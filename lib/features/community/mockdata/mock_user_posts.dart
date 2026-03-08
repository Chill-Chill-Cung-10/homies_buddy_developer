/// [Refactored] Phase 3.5 — Extracted from profile_mock_data.dart
/// Mock user posts data
library;

import '../../../data/models/post_model.dart';
import '../../../data/models/media_file_model.dart';
import '../../../data/models/enums/post_privacy.dart';
import '../../../data/models/enums/media_type.dart';

class MockUserPosts {
  static final List<Post> salahPosts = [
    Post(
      postId: 'p_user1_1',
      authorId: 'user1',
      authorName: 'Salahhh Home',
      authorAvatar: 'https://picsum.photos/800/450?random=10',
      createdAt: DateTime.now().subtract(const Duration(minutes: 18)),
      contentText: 'Xin chào tôi là Salahhh\n# SSG104',
      hashtags: ['SSG104'],
      mentions: ['@haiia'],
      mediaFiles: [
        MediaFile(
          id: 'pm1',
          postId: 'p_user1_1',
          mediaType: MediaType.image,
          mediaAspectRatio: 16 / 9,
          mediaUrl: 'https://picsum.photos/800/450?random=1',
          thumbnailUrl: 'https://picsum.photos/400/225?random=1',
          width: 800,
          height: 450,
        ),
      ],
      reactsCount: 2500,
      commentCount: 4,
      privacy: PostPrivacy.public,
    ),
    Post(
      postId: 'p_user1_2',
      authorId: 'user1',
      authorName: 'Salahhh Home',
      authorAvatar: 'https://picsum.photos/800/450?random=10',
      createdAt: DateTime.now().subtract(const Duration(hours: 3)),
      contentText: 'Beautiful sunset with my pets 🌅',
      hashtags: ['sunset', 'petlife'],
      mentions: [],
      mediaFiles: [
        MediaFile(
          id: 'pm2',
          postId: 'p_user1_2',
          mediaType: MediaType.image,
          mediaAspectRatio: 4 / 3,
          mediaUrl: 'https://picsum.photos/800/600?random=50',
          thumbnailUrl: 'https://picsum.photos/400/300?random=50',
          width: 800,
          height: 600,
        ),
      ],
      reactsCount: 1800,
      commentCount: 2,
      privacy: PostPrivacy.public,
    ),
  ];

  static final List<Post> buddyPosts = [
    Post(
      postId: 'p_user2_1',
      authorId: 'user2',
      authorName: 'Buddy the Golden',
      authorAvatar: 'https://picsum.photos/150/150?random=102',
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      contentText: 'Beautiful day at the park! 🌳☀️',
      hashtags: ['parklife', 'doglife'],
      mentions: ['@homiesbuddy', '@buddy'],
      mediaFiles: [
        MediaFile(
          id: 'pm3',
          postId: 'p_user2_1',
          mediaType: MediaType.image,
          mediaAspectRatio: 4 / 3,
          mediaUrl: 'https://picsum.photos/800/600?random=2',
          thumbnailUrl: 'https://picsum.photos/400/300?random=2',
          width: 800,
          height: 600,
        ),
      ],
      reactsCount: 1230,
      commentCount: 3,
      privacy: PostPrivacy.public,
    ),
  ];

  static final List<Post> lunaPosts = [
    Post(
      postId: 'p_user3_1',
      authorId: 'user3',
      authorName: 'Luna & Max',
      authorAvatar: 'https://picsum.photos/150/150?random=103',
      createdAt: DateTime.now().subtract(const Duration(hours: 5)),
      contentText: 'Our first photoshoot together! 📸',
      hashtags: ['petphotography', 'bestfriends'],
      mentions: [],
      mediaFiles: [
        MediaFile(
          id: 'pm4',
          postId: 'p_user3_1',
          mediaType: MediaType.image,
          mediaAspectRatio: 1.0,
          mediaUrl: 'https://picsum.photos/800/800?random=3',
          thumbnailUrl: 'https://picsum.photos/400/400?random=3',
          width: 800,
          height: 800,
        ),
      ],
      reactsCount: 3450,
      commentCount: 4,
      privacy: PostPrivacy.friends,
    ),
  ];
}
