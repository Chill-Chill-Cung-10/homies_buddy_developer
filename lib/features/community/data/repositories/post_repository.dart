import '../../../../data/models/post_model.dart';
import '../models/create_post_request.dart';

/// Post Repository — Abstract interface for post operations
///
/// Provides methods for:
/// - Fetching feed with pagination
/// - Getting single post by ID
/// - Creating/deleting posts
/// - Toggling post likes
///
/// Implementation should use Supabase for data storage
/// and Firebase Storage for media files.
abstract class PostRepository {
  /// Get paginated feed posts with media
  ///
  /// Queries `feed_post` table joined with `media_file`
  /// Returns posts ordered by created_at DESC
  ///
  /// [page] - Page number (0-indexed)
  /// [limit] - Number of posts per page
  /// [currentUserId] - Current user ID to check if liked
  Future<PostFeedResult> getFeed({
    required int page,
    int limit = 10,
    String? currentUserId,
  });

  /// Get single post by ID with all media
  ///
  /// [postId] - The post ID to fetch
  /// [currentUserId] - Current user ID to check if liked
  Future<PostWithLikeStatus?> getPostById(
    String postId, {
    String? currentUserId,
  });

  /// Create a new post with optional media
  ///
  /// [request] - CreatePostRequest containing post data and media files
  /// Returns the created post ID
  Future<String> createPost(CreatePostRequest request);

  /// Delete a post and all its media
  ///
  /// [postId] - The post ID to delete
  /// [authorId] - The author ID (for verification)
  Future<void> deletePost(String postId, String authorId);

  /// Toggle like on a post (like/unlike)
  ///
  /// [postId] - The post ID to toggle like
  /// [userId] - The user ID performing the action
  /// Returns true if now liked, false if unliked
  Future<bool> toggleLike(String postId, String userId);

  /// Check if user has liked a post
  ///
  /// [postId] - The post ID to check
  /// [userId] - The user ID to check
  Future<bool> isLikedByUser(String postId, String userId);

  /// Get user's own posts
  ///
  /// [userId] - The user ID to get posts for
  /// [page] - Page number (0-indexed)
  /// [limit] - Number of posts per page
  Future<PostFeedResult> getUserPosts({
    required String userId,
    required int page,
    int limit = 10,
  });
}

/// Result of fetching feed posts
class PostFeedResult {
  final List<PostWithLikeStatus> posts;
  final bool hasMore;
  final int totalCount;

  const PostFeedResult({
    required this.posts,
    required this.hasMore,
    this.totalCount = 0,
  });
}

/// Post with computed like status
class PostWithLikeStatus {
  final Post post;
  final bool isLikedByMe;

  const PostWithLikeStatus({
    required this.post,
    required this.isLikedByMe,
  });
}

/// Exception for PostRepository errors
class PostRepositoryException implements Exception {
  final String message;
  final Object? originalError;

  PostRepositoryException(this.message, [this.originalError]);

  @override
  String toString() => 'PostRepositoryException: $message';
}
