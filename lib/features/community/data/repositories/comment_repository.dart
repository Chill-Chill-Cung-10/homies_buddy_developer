import '../../../../data/models/comment_model.dart';
import '../models/comment_sort_option.dart';

/// Comment Repository — Abstract interface for comment operations
///
/// Provides methods for:
/// - Fetching comments with sorting
/// - Adding/deleting comments
/// - Toggling comment reactions
///
/// Implementation uses Supabase tables:
/// - feed_comment: Comment data
/// - comment_reacts: Junction table for reactions
abstract class CommentRepository {
  /// Get comments for a post with sorting options
  ///
  /// [postId] - The post ID to get comments for
  /// [sort] - Sorting option (latest, oldest, mostReacted)
  /// [page] - Page number (0-indexed)
  /// [limit] - Number of comments per page
  /// [currentUserId] - Current user ID to check if reacted
  Future<CommentListResult> getComments(
    String postId, {
    CommentSortOption sort = CommentSortOption.latest,
    int page = 0,
    int limit = 20,
    String? currentUserId,
  });

  /// Add a new comment to a post
  ///
  /// [postId] - The post ID to comment on
  /// [authorId] - The user ID of the commenter
  /// [authorName] - Display name of the commenter
  /// [authorAvatar] - Avatar URL of the commenter
  /// [content] - The comment text
  Future<Comment> addComment({
    required String postId,
    required String authorId,
    required String authorName,
    required String authorAvatar,
    required String content,
  });

  /// Delete a comment
  ///
  /// [commentId] - The comment ID to delete
  /// [authorId] - The author ID (for verification)
  /// [postId] - The post ID (for updating comment count)
  Future<void> deleteComment({
    required String commentId,
    required String authorId,
    required String postId,
  });

  /// Toggle reaction on a comment (react/unreact)
  ///
  /// [commentId] - The comment ID to toggle reaction
  /// [userId] - The user ID performing the action
  /// Returns true if now reacted, false if unreacted
  Future<bool> toggleCommentReact(String commentId, String userId);

  /// Check if user has reacted to a comment
  ///
  /// [commentId] - The comment ID to check
  /// [userId] - The user ID to check
  Future<bool> isReactedByUser(String commentId, String userId);

  /// Get comment count for a post
  ///
  /// [postId] - The post ID
  Future<int> getCommentCount(String postId);
}

/// Result of fetching comments
class CommentListResult {
  final List<CommentWithReactStatus> comments;
  final bool hasMore;
  final int totalCount;

  const CommentListResult({
    required this.comments,
    required this.hasMore,
    this.totalCount = 0,
  });
}

/// Comment with computed react status
class CommentWithReactStatus {
  final Comment comment;
  final bool isReactedByMe;

  const CommentWithReactStatus({
    required this.comment,
    required this.isReactedByMe,
  });
}

/// Exception for CommentRepository errors
class CommentRepositoryException implements Exception {
  final String message;
  final Object? originalError;

  CommentRepositoryException(this.message, [this.originalError]);

  @override
  String toString() => 'CommentRepositoryException: $message';
}
