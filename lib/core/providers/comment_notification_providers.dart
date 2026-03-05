import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/comment_model.dart';
import '../../data/models/notification_model.dart';
import '../../data/repositories/comment_repository.dart';
import '../../data/repositories/notification_repository.dart';
import 'core_providers.dart';

// =============================================================================
// COMMENT PROVIDERS
// =============================================================================

/// Get comments của một post (stream)
/// 
/// [postId] - ID của post
final commentsProvider = StreamProvider.family<List<Comment>, String>(
  (ref, postId) {
    final repository = ref.watch(commentRepositoryProvider);
    return repository.getComments(postId, limit: 50);
  },
);

/// Get comments sorted by react count (top comments)
final topCommentsProvider = StreamProvider.family<List<Comment>, String>(
  (ref, postId) {
    final repository = ref.watch(commentRepositoryProvider);
    return repository.getComments(
      postId,
      sortBy: 'reactCount',
      descending: true,
      limit: 10,
    );
  },
);

/// Get comment count của post
final commentCountProvider = FutureProvider.family<int, String>(
  (ref, postId) {
    final repository = ref.watch(commentRepositoryProvider);
    return repository.getCommentCount(postId);
  },
);

/// Check if user has reacted to a comment
final hasReactedCommentProvider = FutureProvider.family<bool, CommentReactParams>(
  (ref, params) {
    final repository = ref.watch(commentRepositoryProvider);
    return repository.hasReacted(params.postId, params.commentId);
  },
);

/// Parameters cho comment react check
class CommentReactParams {
  final String postId;
  final String commentId;

  CommentReactParams({required this.postId, required this.commentId});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CommentReactParams &&
          postId == other.postId &&
          commentId == other.commentId;

  @override
  int get hashCode => postId.hashCode ^ commentId.hashCode;
}

// =============================================================================
// COMMENT ACTIONS PROVIDER
// =============================================================================

/// Provider cho các actions liên quan đến comments
/// 
/// Usage:
/// ```dart
/// final commentActions = ref.read(commentActionsProvider);
/// await commentActions.createComment('postId', 'Nice post!');
/// ```
final commentActionsProvider = Provider<CommentActions>((ref) {
  final repository = ref.watch(commentRepositoryProvider);
  return CommentActions(repository: repository);
});

class CommentActions {
  final CommentRepository repository;

  CommentActions({required this.repository});

  /// Create new comment
  Future<String> createComment(String postId, String contentText) async {
    return await repository.createComment(postId, contentText);
  }

  /// Update comment
  Future<void> updateComment(
    String postId,
    String commentId,
    String contentText,
  ) async {
    await repository.updateComment(postId, commentId, contentText);
  }

  /// Delete comment
  Future<void> deleteComment(String postId, String commentId) async {
    await repository.deleteComment(postId, commentId);
  }

  /// Toggle react on comment
  Future<void> toggleReact(String postId, String commentId) async {
    await repository.toggleReact(postId, commentId);
  }
}

// =============================================================================
// NOTIFICATION PROVIDERS
// =============================================================================

/// Get notifications (stream)
final notificationsProvider = StreamProvider<List<NotificationModel>>((ref) {
  final repository = ref.watch(notificationRepositoryProvider);
  return repository.getNotifications(limit: 50);
});

/// Get unread notification count (stream)
final unreadNotificationCountProvider = StreamProvider<int>((ref) {
  final repository = ref.watch(notificationRepositoryProvider);
  return repository.getUnreadCount();
});

// =============================================================================
// NOTIFICATION ACTIONS PROVIDER
// =============================================================================

/// Provider cho các actions liên quan đến notifications
final notificationActionsProvider = Provider<NotificationActions>((ref) {
  final repository = ref.watch(notificationRepositoryProvider);
  return NotificationActions(repository: repository);
});

class NotificationActions {
  final NotificationRepository repository;

  NotificationActions({required this.repository});

  /// Mark notification as read
  Future<void> markAsRead(String notificationId) async {
    await repository.markAsRead(notificationId);
  }

  /// Mark all as read
  Future<void> markAllAsRead() async {
    await repository.markAllAsRead();
  }

  /// Delete notification
  Future<void> deleteNotification(String notificationId) async {
    await repository.deleteNotification(notificationId);
  }

  /// Delete all notifications
  Future<void> deleteAllNotifications() async {
    await repository.deleteAllNotifications();
  }
}
