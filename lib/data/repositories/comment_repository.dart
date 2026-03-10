import 'package:cloud_firestore/cloud_firestore.dart';
import '../../data/models/comment_model.dart';
import '../../core/services/firebase_service.dart';
import '../../core/mixins/session_guard_mixin.dart';

/// Comment Repository - Quản lý comments trên posts
///
/// Handles:
/// - Create/Update/Delete comments
/// - Get comments với pagination
/// - React/Unreact comments
///
/// 🛡️ Protected with SessionGuardMixin - All operations check session validity
class CommentRepository with SessionGuardMixin {
  final FirebaseService _firebaseService = FirebaseService.instance;

  /// Get comments của một post
  ///
  /// [sortBy] - 'createdAt' (mới nhất) hoặc 'reactCount' (nhiều react nhất)
  /// Public operation - does not require auth
  Stream<List<Comment>> getComments(
    String postId, {
    String sortBy = 'createdAt',
    bool descending = true,
    DocumentSnapshot? lastDoc,
    int limit = 20,
  }) {
    return guardedStream(
      () {
        Query<Map<String, dynamic>> query = _firebaseService
            .postComments(postId)
            .orderBy(sortBy, descending: descending)
            .limit(limit);

        if (lastDoc != null) {
          query = query.startAfterDocument(lastDoc);
        }

        return query.snapshots().map((snapshot) {
          return snapshot.docs.map((doc) {
            return Comment.fromJson({
              ...doc.data(),
              'commentId': doc.id,
              'postId': postId,
              'createdAt':
                  (doc.data()['createdAt'] as Timestamp?)?.toDate() ??
                  DateTime.now(),
              'updatedAt': (doc.data()['updatedAt'] as Timestamp?)?.toDate(),
            });
          }).toList();
        });
      },
      requiresAuth: false,
      operationName: 'getComments',
    );
  }

  /// Get comment count của post
  Future<int> getCommentCount(String postId) async {
    try {
      final postDoc = await _firebaseService.postsCollection.doc(postId).get();
      return postDoc.data()?['commentCount'] as int? ?? 0;
    } catch (e) {
      return 0;
    }
  }

  /// Create new comment
  ///
  /// Cloud Function sẽ tự động:
  /// - +1 commentCount của post
  /// - Tạo notification cho post author
  Future<String> createComment(String postId, String contentText) async {
    final currentUserId = _firebaseService.currentUserId;
    if (currentUserId == null) {
      throw CommentRepositoryException('User not authenticated');
    }

    try {
      // Get author info
      final authorDoc = await _firebaseService.usersCollection
          .doc(currentUserId)
          .get();
      final authorData = authorDoc.data();

      // Create comment document
      final commentRef = _firebaseService.postComments(postId).doc();

      await commentRef.set({
        'authorId': currentUserId,
        'authorName': authorData?['fullName'] ?? 'Unknown',
        'authorAvatar': authorData?['avatarUrl'] ?? '',
        'contentText': contentText,
        'reactCount': 0,
        'createdAt': FieldValue.serverTimestamp(),
      });

      return commentRef.id;
    } catch (e) {
      throw CommentRepositoryException('Failed to create comment: $e');
    }
  }

  /// Update comment
  Future<void> updateComment(
    String postId,
    String commentId,
    String contentText,
  ) async {
    final currentUserId = _firebaseService.currentUserId;
    if (currentUserId == null) {
      throw CommentRepositoryException('User not authenticated');
    }

    try {
      // Check ownership
      final commentDoc = await _firebaseService
          .postComments(postId)
          .doc(commentId)
          .get();

      if (commentDoc.data()?['authorId'] != currentUserId) {
        throw CommentRepositoryException('Not authorized to edit this comment');
      }

      await _firebaseService.postComments(postId).doc(commentId).update({
        'contentText': contentText,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw CommentRepositoryException('Failed to update comment: $e');
    }
  }

  /// Delete comment
  ///
  /// Cloud Function sẽ tự động -1 commentCount
  Future<void> deleteComment(String postId, String commentId) async {
    final currentUserId = _firebaseService.currentUserId;
    if (currentUserId == null) {
      throw CommentRepositoryException('User not authenticated');
    }

    try {
      // Check ownership
      final commentDoc = await _firebaseService
          .postComments(postId)
          .doc(commentId)
          .get();

      if (commentDoc.data()?['authorId'] != currentUserId) {
        throw CommentRepositoryException(
          'Not authorized to delete this comment',
        );
      }

      await _firebaseService.postComments(postId).doc(commentId).delete();
    } catch (e) {
      throw CommentRepositoryException('Failed to delete comment: $e');
    }
  }

  /// Toggle react on comment
  ///
  /// NOTE: Comment reacts được lưu trong subcollection comments/{id}/reacts
  /// tương tự posts
  Future<void> toggleReact(String postId, String commentId) async {
    final currentUserId = _firebaseService.currentUserId;
    if (currentUserId == null) {
      throw CommentRepositoryException('User not authenticated');
    }

    try {
      final reactRef = _firebaseService
          .postComments(postId)
          .doc(commentId)
          .collection('reacts')
          .doc(currentUserId);

      final doc = await reactRef.get();

      if (doc.exists) {
        // Already reacted -> unreact
        await reactRef.delete();

        // -1 reactCount
        await _firebaseService.postComments(postId).doc(commentId).update({
          'reactCount': FieldValue.increment(-1),
        });
      } else {
        // Not reacted yet -> react
        await reactRef.set({'reactedAt': FieldValue.serverTimestamp()});

        // +1 reactCount
        await _firebaseService.postComments(postId).doc(commentId).update({
          'reactCount': FieldValue.increment(1),
        });
      }
    } catch (e) {
      throw CommentRepositoryException('Failed to toggle react: $e');
    }
  }

  /// Check if current user has reacted to comment
  Future<bool> hasReacted(String postId, String commentId) async {
    final currentUserId = _firebaseService.currentUserId;
    if (currentUserId == null) return false;

    try {
      final doc = await _firebaseService
          .postComments(postId)
          .doc(commentId)
          .collection('reacts')
          .doc(currentUserId)
          .get();
      return doc.exists;
    } catch (e) {
      return false;
    }
  }
}

/// Custom exception cho comment operations
class CommentRepositoryException implements Exception {
  final String message;
  CommentRepositoryException(this.message);

  @override
  String toString() => 'CommentRepositoryException: $message';
}
