/// Community Providers — Riverpod state management for Community feed
///
/// Manages:
/// - Posts list with pagination
/// - User's latest post section
/// - Post creation/deletion
/// - Feed refresh
library;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../data/models/post_model.dart';
import '../../data/repositories/post_repository.dart';
import '../../data/repositories/post_repository_impl.dart';
import '../../data/repositories/comment_repository.dart';
import '../../data/repositories/comment_repository_impl.dart';
import '../../data/repositories/media_repository.dart';
import '../../data/repositories/media_repository_impl.dart';

// =============================================================================
// REPOSITORY PROVIDERS
// =============================================================================

/// Media Repository Provider
final mediaRepositoryProvider = Provider<MediaRepository>((ref) {
  return MediaRepositoryImpl();
});

/// Post Repository Provider
final postRepositoryProvider = Provider<PostRepository>((ref) {
  final mediaRepository = ref.watch(mediaRepositoryProvider);
  return PostRepositoryImpl(mediaRepository: mediaRepository);
});

/// Comment Repository Provider
final commentRepositoryProvider = Provider<CommentRepository>((ref) {
  return CommentRepositoryImpl();
});

// =============================================================================
// STATE CLASSES
// =============================================================================

/// Community Feed State
class CommunityFeedState {
  final List<Post> posts;
  final Set<String> likedPostIds;
  final bool isLoading;
  final bool hasMore;
  final int currentPage;
  final String? errorMessage;

  const CommunityFeedState({
    required this.posts,
    required this.likedPostIds,
    required this.isLoading,
    required this.hasMore,
    required this.currentPage,
    this.errorMessage,
  });

  CommunityFeedState copyWith({
    List<Post>? posts,
    Set<String>? likedPostIds,
    bool? isLoading,
    bool? hasMore,
    int? currentPage,
    String? errorMessage,
  }) {
    return CommunityFeedState(
      posts: posts ?? this.posts,
      likedPostIds: likedPostIds ?? this.likedPostIds,
      isLoading: isLoading ?? this.isLoading,
      hasMore: hasMore ?? this.hasMore,
      currentPage: currentPage ?? this.currentPage,
      errorMessage: errorMessage,
    );
  }

  factory CommunityFeedState.initial() => const CommunityFeedState(
    posts: [],
    likedPostIds: {},
    isLoading: true,
    hasMore: true,
    currentPage: 0,
  );
}

// =============================================================================
// NOTIFIERS
// =============================================================================

/// Community Feed Notifier — Manages posts list and pagination
class CommunityFeedNotifier extends StateNotifier<CommunityFeedState> {
  final PostRepository _postRepository;
  static const int postsPerPage = 10;

  CommunityFeedNotifier(this._postRepository) : super(CommunityFeedState.initial()) {
    _loadInitialPosts();
  }

  // ── Helpers ──────────────────────────────────────────────────────────────

  /// Lấy userId của user hiện tại từ FirebaseAuth
  String? get _currentUserId => FirebaseAuth.instance.currentUser?.uid;

  /// Update 1 post tại index trong list
  void _updatePostAt(int index, Post post) {
    final updated = [...state.posts];
    updated[index] = post;
    state = state.copyWith(posts: updated);
  }

  // ── Load / Refresh ────────────────────────────────────────────────────────

  /// Load trang đầu tiên
  Future<void> _loadInitialPosts() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final result = await _postRepository.getFeed(
        page: 0,
        limit: postsPerPage,
        currentUserId: _currentUserId, // ✅ FIX: batch-check isLikedByMe đúng
      );

      // isLikedByMe là computed field chỉ giữ ở Flutter state
      final posts = result.posts.map((p) => p.post).toList();
      final likedPostIds = result.posts
          .where((p) => p.isLikedByMe)
          .map((p) => p.post.postId)
          .toSet();

      state = state.copyWith(
        posts: posts,
        likedPostIds: likedPostIds,
        currentPage: 1,
        hasMore: result.hasMore,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to load posts: $e',
      );
    }
  }

  /// Load thêm posts (pagination)
  Future<void> loadMorePosts() async {
    if (state.isLoading || !state.hasMore) return;

    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final result = await _postRepository.getFeed(
        page: state.currentPage,
        limit: postsPerPage,
        currentUserId: _currentUserId, // ✅ FIX: batch-check isLikedByMe đúng
      );

      final morePosts = result.posts.map((p) => p.post).toList();
      final likedInPage = result.posts
          .where((p) => p.isLikedByMe)
          .map((p) => p.post.postId)
          .toSet();

      state = state.copyWith(
        posts: [...state.posts, ...morePosts],
        likedPostIds: {...state.likedPostIds, ...likedInPage},
        currentPage: state.currentPage + 1,
        hasMore: result.hasMore,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to load more posts: $e',
      );
    }
  }

  /// Refresh toàn bộ feed
  Future<void> refreshPosts() async {
    state = CommunityFeedState.initial();
    await _loadInitialPosts();
  }

  // ── Delete ────────────────────────────────────────────────────────────────

  /// Xóa post theo postId và authorId — optimistic remove + rollback
  Future<void> deletePost(String postId, String authorId) async {
    final index = state.posts.indexWhere((p) => p.postId == postId);
    if (index == -1) return;

    final post = state.posts[index];

    // Optimistic: xóa khỏi list ngay
    final updated = [...state.posts]..removeAt(index);
    state = state.copyWith(posts: updated);

    try {
      await _postRepository.deletePost(postId, authorId);
    } catch (e) {
      // Rollback: chèn lại đúng vị trí cũ
      final restored = [...state.posts]..insert(index, post);
      state = state.copyWith(
        posts: restored,
        errorMessage: 'Failed to delete post: $e',
      );
    }
  }

  // ── Like ──────────────────────────────────────────────────────────────────

  /// Toggle like theo postId — optimistic flip + rollback
  ///
  /// KHÔNG nhận userId từ bên ngoài — tự lấy từ FirebaseAuth để tránh truyền sai.
  Future<void> toggleLike(String postId) async {
    final userId = _currentUserId;
    if (userId == null) return;

    final index = state.posts.indexWhere((p) => p.postId == postId);
    if (index == -1) return;

    final post = state.posts[index];
    final wasLiked = state.likedPostIds.contains(post.postId);
    final previousLikedIds = state.likedPostIds;
    final nextLikedIds = {...state.likedPostIds};
    if (wasLiked) {
      nextLikedIds.remove(post.postId);
    } else {
      nextLikedIds.add(post.postId);
    }

    // Optimistic update ngay lập tức
    _updatePostAt(
      index,
      post.copyWith(
        reactsCount: wasLiked
            ? (post.reactsCount - 1).clamp(0, double.maxFinite).toInt()
            : post.reactsCount + 1,
      ),
    );
    state = state.copyWith(likedPostIds: nextLikedIds);

    try {
      await _postRepository.toggleLike(postId, userId);
    } catch (e) {
      // Rollback về trạng thái cũ
      _updatePostAt(index, post);
      state = state.copyWith(
        likedPostIds: previousLikedIds,
        errorMessage: 'Failed to toggle like: $e',
      );
    }
  }
}

/// User's Latest Post State
class UserLatestPostState {
  final Post? post;
  final bool isVisible;
  final bool isLikedByMe;

  const UserLatestPostState({
    this.post,
    required this.isVisible,
    required this.isLikedByMe,
  });

  UserLatestPostState copyWith({
    Post? post,
    bool? isVisible,
    bool? isLikedByMe,
  }) {
    return UserLatestPostState(
      post: post ?? this.post,
      isVisible: isVisible ?? this.isVisible,
      isLikedByMe: isLikedByMe ?? this.isLikedByMe,
    );
  }

  factory UserLatestPostState.initial() => const UserLatestPostState(
    post: null,
    isVisible: false,
    isLikedByMe: false,
  );
}

/// User's Latest Post Notifier
class UserLatestPostNotifier extends StateNotifier<UserLatestPostState> {
  final PostRepository _postRepository;

  UserLatestPostNotifier(this._postRepository) : super(UserLatestPostState.initial());

  String? get _currentUserId => FirebaseAuth.instance.currentUser?.uid;

  /// Set latest post khi user vừa tạo post mới
  void setLatestPost(Post post) {
    state = UserLatestPostState(post: post, isVisible: true, isLikedByMe: false);
  }

  /// Xóa latest post
  Future<void> deleteLatestPost(String authorId) async {
    if (state.post == null) return;

    final postId = state.post!.postId;
    state = UserLatestPostState.initial(); // optimistic clear

    try {
      await _postRepository.deletePost(postId, authorId);
    } catch (_) {
      // Đã clear rồi — không rollback để tránh hiện post đã xóa
    }
  }

  /// Ẩn section latest post (không xóa post)
  void hideLatestPostSection() {
    if (state.post != null) {
      state = state.copyWith(isVisible: false);
    }
  }

  /// Toggle like trên latest post — optimistic + rollback
  ///
  /// KHÔNG nhận userId từ bên ngoài — tự lấy từ FirebaseAuth.
  Future<void> toggleLike() async {
    if (state.post == null) return;

    final userId = _currentUserId;
    if (userId == null) return;

    final post = state.post!;
    final wasLiked = state.isLikedByMe;

    // Optimistic update
    state = state.copyWith(
      post: post.copyWith(
        reactsCount: wasLiked
            ? (post.reactsCount - 1).clamp(0, double.maxFinite).toInt()
            : post.reactsCount + 1,
      ),
      isLikedByMe: !wasLiked,
    );

    try {
      await _postRepository.toggleLike(post.postId, userId);
    } catch (e) {
      // Rollback
      state = state.copyWith(post: post, isLikedByMe: wasLiked);
    }
  }
}

// =============================================================================
// PROVIDERS
// =============================================================================

/// Community Feed Provider
final communityFeedProvider =
    StateNotifierProvider<CommunityFeedNotifier, CommunityFeedState>((ref) {
  final postRepository = ref.watch(postRepositoryProvider);
  return CommunityFeedNotifier(postRepository);
});

/// User's Latest Post Provider
final userLatestPostProvider =
    StateNotifierProvider<UserLatestPostNotifier, UserLatestPostState>((ref) {
  final postRepository = ref.watch(postRepositoryProvider);
  return UserLatestPostNotifier(postRepository);
});

// =============================================================================
// UTILITY PROVIDERS
// =============================================================================

/// Should show latest post section
final shouldShowLatestPostProvider = Provider<bool>((ref) {
  final latestPost = ref.watch(userLatestPostProvider);
  return latestPost.post != null && latestPost.isVisible;
});

/// Get posts count
final postsCountProvider = Provider<int>((ref) {
  final feed = ref.watch(communityFeedProvider);
  return feed.posts.length;
});

/// Check if there are any posts
final hasPostsProvider = Provider<bool>((ref) {
  final feed = ref.watch(communityFeedProvider);
  return feed.posts.isNotEmpty;
});

/// Computed like status cho từng post (tầng Flutter UI)
final isPostLikedProvider = Provider.family<bool, String>((ref, postId) {
  final feed = ref.watch(communityFeedProvider);
  return feed.likedPostIds.contains(postId);
});