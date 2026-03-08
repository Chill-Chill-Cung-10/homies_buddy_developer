import '../../../data/models/post_model.dart';
import '../../../data/models/media_file_model.dart';
import '../../../data/models/enums/post_privacy.dart';
import '../../../data/models/enums/media_type.dart';
import 'comment_mock_data.dart';

/// Mock data cho Community Posts - để test UI
class CommunityMockData {
  /// Lấy danh sách posts với comment count tự động đồng bộ
  static List<Post> get mockPosts => _mockPosts.map((post) {
    return post.copyWith(
      commentCount: CommentMockData.getCommentCountForPost(post.postId),
    );
  }).toList();

  /// Danh sách posts gốc (không tự động đồng bộ comment count)
  static final List<Post> _mockPosts = [
    Post(
      postId: '1',
      authorId: 'user1',
      authorName: 'Salahhh Home',
      authorAvatar: 'https://picsum.photos/800/450?random=10',
      createdAt: DateTime.now().subtract(const Duration(minutes: 18)),
      contentText: 'Xin chào tôi là Salahhh\n# SSG104',
      hashtags: ['SSG104'],
      mentions: ['@haiia'],
      mediaFiles: [
        MediaFile(
          id: 'media1',
          postId: '1',
          mediaType: MediaType.image,
          mediaAspectRatio: 16 / 9,
          mediaUrl: 'https://picsum.photos/800/450?random=1',
          thumbnailUrl: 'https://picsum.photos/400/225?random=1',
          width: 800,
          height: 450,
        ),
      ],
      reactsCount: 2500,
      commentCount: 4, // Auto-synced with CommentMockData
      privacy: PostPrivacy.public,
    ),
    Post(
      postId: '2',
      authorId: 'user2',
      authorName: 'Buddy the Golden',
      authorAvatar: 'https://picsum.photos/150/150?random=102',
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      contentText: 'Beautiful day at the park! 🌳☀️',
      hashtags: ['parklife', 'doglife'],
      mentions: ['@homiesbuddy', '@buddy'],
      mediaFiles: [
        MediaFile(
          id: 'media2',
          postId: '2',
          mediaType: MediaType.image,
          mediaAspectRatio: 4 / 3,
          mediaUrl: 'https://picsum.photos/800/600?random=2',
          thumbnailUrl: 'https://picsum.photos/400/300?random=2',
          width: 800,
          height: 600,
        ),
      ],
      reactsCount: 1230,
      commentCount: 3, // Auto-synced with CommentMockData
      privacy: PostPrivacy.public,
    ),
    Post(
      postId: '3',
      authorId: 'user3',
      authorName: 'Luna & Max',
      authorAvatar: 'https://picsum.photos/150/150?random=103',
      createdAt: DateTime.now().subtract(const Duration(hours: 5)),
      contentText: 'Our first photoshoot together! 📸',
      hashtags: ['petphotography', 'bestfriends'],
      mentions: [],
      mediaFiles: [
        MediaFile(
          id: 'media3_1',
          postId: '3',
          mediaType: MediaType.image,
          mediaAspectRatio: 1.0,
          mediaUrl: 'https://picsum.photos/800/800?random=3',
          thumbnailUrl: 'https://picsum.photos/400/400?random=3',
          width: 800,
          height: 800,
        ),
        MediaFile(
          id: 'media3_2',
          postId: '3',
          mediaType: MediaType.image,
          mediaAspectRatio: 1.0,
          mediaUrl: 'https://picsum.photos/800/800?random=4',
          thumbnailUrl: 'https://picsum.photos/400/400?random=4',
          width: 800,
          height: 800,
        ),
        MediaFile(
          id: 'media3_3',
          postId: '3',
          mediaType: MediaType.image,
          mediaAspectRatio: 1.0,
          mediaUrl: 'https://picsum.photos/800/800?random=5',
          thumbnailUrl: 'https://picsum.photos/400/400?random=5',
          width: 800,
          height: 800,
        ),
      ],
      reactsCount: 3450,
      commentCount: 4, // Auto-synced with CommentMockData
      privacy: PostPrivacy.friends,
    ),
    Post(
      postId: '4',
      authorId: 'user4',
      authorName: 'Charlie the Corgi',
      authorAvatar: 'https://picsum.photos/150/150?random=104',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      contentText: 'Training session! Watch my new tricks 🎾',
      hashtags: ['dogtraining', 'corgilove'],
      mentions: [],
      mediaFiles: [
        MediaFile(
          id: 'media4',
          postId: '4',
          mediaType: MediaType.video,
          mediaAspectRatio: 9 / 16,
          mediaUrl:
              'https://sample-videos.com/video123/mp4/720/big_buck_bunny_720p_1mb.mp4',
          thumbnailUrl: 'https://picsum.photos/720/1280?random=6',
          width: 720,
          height: 1280,
          durationSeconds: 125,
        ),
      ],
      reactsCount: 567,
      commentCount: 0, // Auto-synced with CommentMockData
      privacy: PostPrivacy.public,
    ),
    Post(
      postId: '5',
      authorId: 'user5',
      authorName: 'Milo the Cat',
      authorAvatar: 'https://picsum.photos/150/150?random=105',
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      contentText: 'Lazy Sunday vibes 😴💤',
      hashtags: ['catsofinstagram', 'lazyday'],
      mentions: [],
      mediaFiles: [
        MediaFile(
          id: 'media5',
          postId: '5',
          mediaType: MediaType.image,
          mediaAspectRatio: 3 / 4,
          mediaUrl: 'https://picsum.photos/600/800?random=7',
          thumbnailUrl: 'https://picsum.photos/300/400?random=7',
          width: 600,
          height: 800,
        ),
      ],
      reactsCount: 892,
      commentCount: 0, // Auto-synced with CommentMockData
      privacy: PostPrivacy.public,
    ),
  ];
}
