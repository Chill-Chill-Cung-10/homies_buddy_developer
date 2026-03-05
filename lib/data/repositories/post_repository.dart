import 'package:cloud_firestore/cloud_firestore.dart';
import '../../data/models/post_model.dart';
import '../../data/models/media_file_model.dart';
import '../../data/models/enums/post_privacy.dart';
import '../../core/services/firebase_service.dart';

/// Post Repository - Quản lý operations liên quan đến posts
/// 
/// Handles:
/// - Create/Update/Delete posts
/// - Get feed with pagination
/// - Get user's posts
/// - React/Unreact posts
/// - Hashtag & mention queries
class PostRepository {
  final FirebaseService _firebaseService = FirebaseService.instance;

  /// Get community feed (public posts)
  /// 
  /// [lastDoc] - Document cuối cùng để cursor-based pagination
  /// [limit] - Số lượng posts mỗi page
  Stream<List<Post>> getFeed({
    DocumentSnapshot? lastDoc,
    int limit = 10,
  }) {
    Query<Map<String, dynamic>> query = _firebaseService.postsCollection
        .where('privacy', isEqualTo: 'public')
        .orderBy('createdAt', descending: true)
        .limit(limit);

    if (lastDoc != null) {
      query = query.startAfterDocument(lastDoc);
    }

    return query.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Post.fromJson({
          ...doc.data(),
          'postId': doc.id,
          // Convert Timestamp to DateTime
          'createdAt': (doc.data()['createdAt'] as Timestamp?)?.toDate() ??
              DateTime.now(),
          'updatedAt': (doc.data()['updatedAt'] as Timestamp?)?.toDate(),
        });
      }).toList();
    });
  }

  /// Get posts của một user cụ thể
  Stream<List<Post>> getUserPosts(
    String userId, {
    DocumentSnapshot? lastDoc,
    int limit = 10,
  }) {
    Query<Map<String, dynamic>> query = _firebaseService.postsCollection
        .where('authorId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .limit(limit);

    if (lastDoc != null) {
      query = query.startAfterDocument(lastDoc);
    }

    return query.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Post.fromJson({
          ...doc.data(),
          'postId': doc.id,
          'createdAt': (doc.data()['createdAt'] as Timestamp?)?.toDate() ??
              DateTime.now(),
          'updatedAt': (doc.data()['updatedAt'] as Timestamp?)?.toDate(),
        });
      }).toList();
    });
  }

  /// Get single post by ID
  Future<Post?> getPostById(String postId) async {
    try {
      final doc = await _firebaseService.postsCollection.doc(postId).get();
      if (!doc.exists) return null;

      return Post.fromJson({
        ...doc.data()!,
        'postId': doc.id,
        'createdAt': (doc.data()!['createdAt'] as Timestamp?)?.toDate() ??
            DateTime.now(),
        'updatedAt': (doc.data()!['updatedAt'] as Timestamp?)?.toDate(),
      });
    } catch (e) {
      throw PostRepositoryException('Failed to get post: $e');
    }
  }

  /// Get post stream (realtime)
  Stream<Post?> getPostStream(String postId) {
    return _firebaseService.postsCollection.doc(postId).snapshots().map((doc) {
      if (!doc.exists) return null;

      return Post.fromJson({
        ...doc.data()!,
        'postId': doc.id,
        'createdAt': (doc.data()!['createdAt'] as Timestamp?)?.toDate() ??
            DateTime.now(),
        'updatedAt': (doc.data()!['updatedAt'] as Timestamp?)?.toDate(),
      });
    });
  }

  /// Create new post
  /// 
  /// [mediaFiles] đã được upload lên Storage trước đó
  Future<String> createPost({
    required String contentText,
    required List<MediaFile> mediaFiles,
    required List<String> hashtags,
    required List<String> mentions,
    PostPrivacy privacy = PostPrivacy.public,
  }) async {
    final currentUserId = _firebaseService.currentUserId;
    if (currentUserId == null) {
      throw PostRepositoryException('User not authenticated');
    }

    try {
      // Get author info
      final authorDoc =
          await _firebaseService.usersCollection.doc(currentUserId).get();
      final authorData = authorDoc.data();

      // Create post document
      final postRef = _firebaseService.postsCollection.doc();
      
      await postRef.set({
        'authorId': currentUserId,
        'authorName': authorData?['fullName'] ?? 'Unknown',
        'authorAvatar': authorData?['avatarUrl'] ?? '',
        'contentText': contentText,
        'hashtags': hashtags,
        'mentions': mentions,
        'mediaFiles': mediaFiles.map((m) => {
              'id': m.id,
              'mediaUrl': m.mediaUrl,
              'thumbnailUrl': m.thumbnailUrl,
              'mediaType': m.mediaType.name,
              'mediaAspectRatio': m.mediaAspectRatio,
              'width': m.width,
              'height': m.height,
              'durationSeconds': m.durationSeconds,
            }).toList(),
        'reactsCount': 0,
        'commentCount': 0,
        'privacy': privacy.name,
        'createdAt': FieldValue.serverTimestamp(),
      });

      return postRef.id;
    } catch (e) {
      throw PostRepositoryException('Failed to create post: $e');
    }
  }

  /// Update post
  Future<void> updatePost(
    String postId, {
    String? contentText,
    List<String>? hashtags,
    PostPrivacy? privacy,
  }) async {
    final currentUserId = _firebaseService.currentUserId;
    if (currentUserId == null) {
      throw PostRepositoryException('User not authenticated');
    }

    try {
      // Check ownership
      final post = await getPostById(postId);
      if (post?.authorId != currentUserId) {
        throw PostRepositoryException('Not authorized to edit this post');
      }

      final updates = <String, dynamic>{
        'updatedAt': FieldValue.serverTimestamp(),
      };

      if (contentText != null) updates['contentText'] = contentText;
      if (hashtags != null) updates['hashtags'] = hashtags;
      if (privacy != null) updates['privacy'] = privacy.name;

      await _firebaseService.postsCollection.doc(postId).update(updates);
    } catch (e) {
      throw PostRepositoryException('Failed to update post: $e');
    }
  }

  /// Delete post
  Future<void> deletePost(String postId) async {
    final currentUserId = _firebaseService.currentUserId;
    if (currentUserId == null) {
      throw PostRepositoryException('User not authenticated');
    }

    try {
      // Check ownership
      final post = await getPostById(postId);
      if (post?.authorId != currentUserId) {
        throw PostRepositoryException('Not authorized to delete this post');
      }

      // Delete post document
      // Cloud Function will handle deleting comments and reacts
      await _firebaseService.postsCollection.doc(postId).delete();
    } catch (e) {
      throw PostRepositoryException('Failed to delete post: $e');
    }
  }

  /// Toggle react on post (like/unlike)
  /// 
  /// Optimistic update - Cloud Function will update reactsCount
  Future<void> toggleReact(String postId) async {
    final currentUserId = _firebaseService.currentUserId;
    if (currentUserId == null) {
      throw PostRepositoryException('User not authenticated');
    }

    try {
      final reactRef = _firebaseService
          .postReacts(postId)
          .doc(currentUserId);

      final doc = await reactRef.get();
      
      if (doc.exists) {
        // Already reacted -> unreact
        await reactRef.delete();
      } else {
        // Not reacted yet -> react
        await reactRef.set({
          'reactedAt': FieldValue.serverTimestamp(),
        });
      }
    } catch (e) {
      throw PostRepositoryException('Failed to toggle react: $e');
    }
  }

  /// Check if current user has reacted to post
  Future<bool> hasReacted(String postId) async {
    final currentUserId = _firebaseService.currentUserId;
    if (currentUserId == null) return false;

    try {
      final doc = await _firebaseService
          .postReacts(postId)
          .doc(currentUserId)
          .get();
      return doc.exists;
    } catch (e) {
      return false;
    }
  }

  /// Get posts by hashtag
  Stream<List<Post>> getPostsByHashtag(
    String hashtag, {
    DocumentSnapshot? lastDoc,
    int limit = 20,
  }) {
    Query<Map<String, dynamic>> query = _firebaseService.postsCollection
        .where('hashtags', arrayContains: hashtag)
        .where('privacy', isEqualTo: 'public')
        .orderBy('createdAt', descending: true)
        .limit(limit);

    if (lastDoc != null) {
      query = query.startAfterDocument(lastDoc);
    }

    return query.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Post.fromJson({
          ...doc.data(),
          'postId': doc.id,
          'createdAt': (doc.data()['createdAt'] as Timestamp?)?.toDate() ??
              DateTime.now(),
          'updatedAt': (doc.data()['updatedAt'] as Timestamp?)?.toDate(),
        });
      }).toList();
    });
  }

  /// Get posts mentioning a user
  Stream<List<Post>> getPostsByMention(
    String username, {
    DocumentSnapshot? lastDoc,
    int limit = 20,
  }) {
    Query<Map<String, dynamic>> query = _firebaseService.postsCollection
        .where('mentions', arrayContains: '@$username')
        .where('privacy', isEqualTo: 'public')
        .orderBy('createdAt', descending: true)
        .limit(limit);

    if (lastDoc != null) {
      query = query.startAfterDocument(lastDoc);
    }

    return query.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Post.fromJson({
          ...doc.data(),
          'postId': doc.id,
          'createdAt': (doc.data()['createdAt'] as Timestamp?)?.toDate() ??
              DateTime.now(),
          'updatedAt': (doc.data()['updatedAt'] as Timestamp?)?.toDate(),
        });
      }).toList();
    });
  }
}

/// Custom exception cho post operations
class PostRepositoryException implements Exception {
  final String message;
  PostRepositoryException(this.message);

  @override
  String toString() => 'PostRepositoryException: $message';
}
