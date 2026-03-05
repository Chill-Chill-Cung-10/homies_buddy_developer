import 'package:cloud_firestore/cloud_firestore.dart';
import '../../data/models/notification_model.dart';
import '../../core/services/firebase_service.dart';

/// Notification Repository - Quản lý notifications
/// 
/// Handles:
/// - Get user notifications
/// - Mark as read/unread
/// - Delete notifications
/// - Get unread count
class NotificationRepository {
  final FirebaseService _firebaseService = FirebaseService.instance;

  /// Get notifications của current user
  /// 
  /// Realtime stream với pagination
  Stream<List<NotificationModel>> getNotifications({
    DocumentSnapshot? lastDoc,
    int limit = 20,
  }) {
    final currentUserId = _firebaseService.currentUserId;
    if (currentUserId == null) {
      return Stream.value([]);
    }

    Query<Map<String, dynamic>> query = _firebaseService
        .userNotifications(currentUserId)
        .orderBy('createdAt', descending: true)
        .limit(limit);

    if (lastDoc != null) {
      query = query.startAfterDocument(lastDoc);
    }

    return query.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return NotificationModel.fromJson({
          ...doc.data(),
          'notificationId': doc.id,
          'createdAt': (doc.data()['createdAt'] as Timestamp?)?.toDate() ??
              DateTime.now(),
        });
      }).toList();
    });
  }

  /// Get unread notification count
  Stream<int> getUnreadCount() {
    final currentUserId = _firebaseService.currentUserId;
    if (currentUserId == null) {
      return Stream.value(0);
    }

    return _firebaseService
        .userNotifications(currentUserId)
        .where('isRead', isEqualTo: false)
        .snapshots()
        .map((snapshot) => snapshot.size);
  }

  /// Mark notification as read
  Future<void> markAsRead(String notificationId) async {
    final currentUserId = _firebaseService.currentUserId;
    if (currentUserId == null) {
      throw NotificationRepositoryException('User not authenticated');
    }

    try {
      await _firebaseService
          .userNotifications(currentUserId)
          .doc(notificationId)
          .update({'isRead': true});
    } catch (e) {
      throw NotificationRepositoryException('Failed to mark as read: $e');
    }
  }

  /// Mark all notifications as read
  Future<void> markAllAsRead() async {
    final currentUserId = _firebaseService.currentUserId;
    if (currentUserId == null) {
      throw NotificationRepositoryException('User not authenticated');
    }

    try {
      final unreadDocs = await _firebaseService
          .userNotifications(currentUserId)
          .where('isRead', isEqualTo: false)
          .get();

      // Batch update
      final batch = _firebaseService.batch();
      for (final doc in unreadDocs.docs) {
        batch.update(doc.reference, {'isRead': true});
      }
      await batch.commit();
    } catch (e) {
      throw NotificationRepositoryException('Failed to mark all as read: $e');
    }
  }

  /// Delete notification
  Future<void> deleteNotification(String notificationId) async {
    final currentUserId = _firebaseService.currentUserId;
    if (currentUserId == null) {
      throw NotificationRepositoryException('User not authenticated');
    }

    try {
      await _firebaseService
          .userNotifications(currentUserId)
          .doc(notificationId)
          .delete();
    } catch (e) {
      throw NotificationRepositoryException('Failed to delete notification: $e');
    }
  }

  /// Delete all notifications
  Future<void> deleteAllNotifications() async {
    final currentUserId = _firebaseService.currentUserId;
    if (currentUserId == null) {
      throw NotificationRepositoryException('User not authenticated');
    }

    try {
      final allDocs = await _firebaseService
          .userNotifications(currentUserId)
          .get();

      // Batch delete
      final batch = _firebaseService.batch();
      for (final doc in allDocs.docs) {
        batch.delete(doc.reference);
      }
      await batch.commit();
    } catch (e) {
      throw NotificationRepositoryException('Failed to delete all notifications: $e');
    }
  }
}

/// Custom exception cho notification operations
class NotificationRepositoryException implements Exception {
  final String message;
  NotificationRepositoryException(this.message);

  @override
  String toString() => 'NotificationRepositoryException: $message';
}
