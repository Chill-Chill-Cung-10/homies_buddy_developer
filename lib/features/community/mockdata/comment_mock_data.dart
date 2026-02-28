import '../../../data/models/comment_model.dart';
import '../data/models/comment_sort_option.dart';

export '../data/models/comment_sort_option.dart';

/// Mock data cho Comments - để test UI Comment Overlay
class CommentMockData {
  /// Lấy danh sách comments cho một post cụ thể
  static List<Comment> getCommentsForPost(String postId) {
    return _allComments.where((c) => c.postId == postId).toList();
  }

  /// Lấy số lượng comments cho một post cụ thể
  static int getCommentCountForPost(String postId) {
    return _allComments.where((c) => c.postId == postId).length;
  }

  /// Danh sách tất cả comments mock
  static final List<Comment> _allComments = [
    // Comments cho Post 1 (Salahhh Home post)
    Comment(
      commentId: 'c1_1',
      postId: '1',
      authorId: 'user2',
      authorName: 'Salahhh Home',
      authorAvatar: 'https://picsum.photos/150/150?random=102',
      contentText: 'Xin chào tôi cũng muốn có chú chó như thế này',
      createdAt: DateTime.now().subtract(const Duration(minutes: 18)),
      reactCount: 4950,
      isReactedByMe: true,
    ),
    Comment(
      commentId: 'c1_2',
      postId: '1',
      authorId: 'user3',
      authorName: 'Luna & Max',
      authorAvatar: 'https://picsum.photos/150/150?random=103',
      contentText: 'Wow! Amazing photo! 😍',
      createdAt: DateTime.now().subtract(const Duration(minutes: 15)),
      reactCount: 23,
      isReactedByMe: false,
    ),
    Comment(
      commentId: 'c1_3',
      postId: '1',
      authorId: 'user4',
      authorName: 'Charlie Paws',
      authorAvatar: 'https://picsum.photos/150/150?random=104',
      contentText: 'Such a cutie! What breed is this? 🐕',
      createdAt: DateTime.now().subtract(const Duration(minutes: 10)),
      reactCount: 8,
      isReactedByMe: true,
    ),
    Comment(
      commentId: 'c1_4',
      postId: '1',
      authorId: 'user5',
      authorName: 'Bella Dog',
      authorAvatar: 'https://picsum.photos/150/150?random=105',
      contentText: 'Love this! 💕',
      createdAt: DateTime.now().subtract(const Duration(minutes: 5)),
      reactCount: 2,
      isReactedByMe: false,
    ),

    // Comments cho Post 2 (Buddy the Golden post)
    Comment(
      commentId: 'c2_1',
      postId: '2',
      authorId: 'user1',
      authorName: 'Salahhh Home',
      authorAvatar: 'https://picsum.photos/150/150?random=101',
      contentText: 'Beautiful day indeed! ☀️',
      createdAt: DateTime.now().subtract(const Duration(hours: 1, minutes: 45)),
      reactCount: 45,
      isReactedByMe: true,
    ),
    Comment(
      commentId: 'c2_2',
      postId: '2',
      authorId: 'user6',
      authorName: 'Max Adventures',
      authorAvatar: 'https://picsum.photos/150/150?random=106',
      contentText: 'Which park is this? Looks amazing!',
      createdAt: DateTime.now().subtract(const Duration(hours: 1, minutes: 30)),
      reactCount: 12,
      isReactedByMe: false,
    ),
    Comment(
      commentId: 'c2_3',
      postId: '2',
      authorId: 'user7',
      authorName: 'Rocky Mountain',
      authorAvatar: 'https://picsum.photos/150/150?random=107',
      contentText: 'My dog loves this park too! We should meet up sometime 🐾',
      createdAt: DateTime.now().subtract(const Duration(minutes: 45)),
      reactCount: 18,
      isReactedByMe: true,
    ),

    // Comments cho Post 3 (Luna & Max post)
    Comment(
      commentId: 'c3_1',
      postId: '3',
      authorId: 'user2',
      authorName: 'Buddy the Golden',
      authorAvatar: 'https://picsum.photos/150/150?random=102',
      contentText: 'The best duo! 📸✨',
      createdAt: DateTime.now().subtract(const Duration(hours: 4, minutes: 30)),
      reactCount: 67,
      isReactedByMe: false,
    ),
    Comment(
      commentId: 'c3_2',
      postId: '3',
      authorId: 'user8',
      authorName: 'Daisy Flower',
      authorAvatar: 'https://picsum.photos/150/150?random=108',
      contentText: 'Where did you get this photoshoot done? Need details! 😍',
      createdAt: DateTime.now().subtract(const Duration(hours: 3)),
      reactCount: 34,
      isReactedByMe: true,
    ),
    Comment(
      commentId: 'c3_3',
      postId: '3',
      authorId: 'user9',
      authorName: 'Cooper Tail',
      authorAvatar: 'https://picsum.photos/150/150?random=109',
      contentText: 'Beautiful shot! Professional level 📷',
      createdAt: DateTime.now().subtract(const Duration(hours: 2, minutes: 15)),
      reactCount: 21,
      isReactedByMe: false,
    ),
    Comment(
      commentId: 'c3_4',
      postId: '3',
      authorId: 'user10',
      authorName: 'Milo Buddy',
      authorAvatar: 'https://picsum.photos/150/150?random=110',
      contentText: 'This is goals! 🎯',
      createdAt: DateTime.now().subtract(const Duration(hours: 1)),
      reactCount: 9,
      isReactedByMe: true,
    ),
  ];

  /// Sort options cho comments
  static List<Comment> sortComments(
    List<Comment> comments,
    CommentSortOption sortOption,
  ) {
    final sorted = List<Comment>.from(comments);

    switch (sortOption) {
      case CommentSortOption.latest:
        sorted.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
      case CommentSortOption.mostReacted:
        sorted.sort((a, b) => b.reactCount.compareTo(a.reactCount));
        break;
      case CommentSortOption.oldest:
        sorted.sort((a, b) => a.createdAt.compareTo(b.createdAt));
        break;
    }

    return sorted;
  }
}

// [Refactored] Phase 3.4 — CommentSortOption chuyển sang data/models/comment_sort_option.dart
