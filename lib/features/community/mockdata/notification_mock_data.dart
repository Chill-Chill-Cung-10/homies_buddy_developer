import '../../../data/models/notification_model.dart';
import '../../../data/models/enums/notification_type.dart';

/// Mock data cho Notifications - để test UI Notification Screen
class NotificationMockData {
  /// Lấy danh sách notifications cho user hiện tại
  static List<NotificationModel> getAllNotifications() {
    return _allNotifications;
  }

  /// Lấy danh sách notifications chưa đọc
  static List<NotificationModel> getUnreadNotifications() {
    return _allNotifications.where((n) => !n.isRead).toList();
  }

  /// Lấy số lượng notifications chưa đọc
  static int getUnreadCount() {
    return _allNotifications.where((n) => !n.isRead).length;
  }

  /// Đánh dấu notification đã đọc
  static void markAsRead(String notificationId) {
    final index = _allNotifications.indexWhere((n) => n.notificationId == notificationId);
    if (index != -1) {
      _allNotifications[index] = _allNotifications[index].copyWith(isRead: true);
    }
  }

  /// Danh sách tất cả notifications mock
  static final List<NotificationModel> _allNotifications = [
    // Unread notifications (gần đây)
    NotificationModel(
      notificationId: 'n1',
      actorId: 'user2',
      actorName: 'Buddy the Golden',
      actorAvatar: 'https://i.pravatar.cc/150?img=2',
      type: NotificationType.react,
      createdAt: DateTime.now().subtract(const Duration(minutes: 5)),
      isRead: false,
      postId: '1',
      deepLink: '/community/post/1',
      contentPreview: 'Xin chào tôi là Salahhh # SSG104',
    ),
    NotificationModel(
      notificationId: 'n2',
      actorId: 'user3',
      actorName: 'Luna & Max',
      actorAvatar: 'https://i.pravatar.cc/150?img=3',
      type: NotificationType.comment,
      createdAt: DateTime.now().subtract(const Duration(minutes: 15)),
      isRead: false,
      postId: '1',
      commentId: 'c1_2',
      deepLink: '/community/post/1/comment/c1_2',
      contentPreview: 'Wow! Amazing photo! 😍',
    ),
    NotificationModel(
      notificationId: 'n3',
      actorId: 'user4',
      actorName: 'Charlie Paws',
      actorAvatar: 'https://i.pravatar.cc/150?img=4',
      type: NotificationType.follow,
      createdAt: DateTime.now().subtract(const Duration(minutes: 30)),
      isRead: false,
      postId: '',
      deepLink: '/profile/user4',
    ),
    NotificationModel(
      notificationId: 'n4',
      actorId: 'user5',
      actorName: 'Bella Dog',
      actorAvatar: 'https://i.pravatar.cc/150?img=5',
      type: NotificationType.react,
      createdAt: DateTime.now().subtract(const Duration(hours: 1)),
      isRead: false,
      postId: '2',
      deepLink: '/community/post/2',
      contentPreview: 'Beautiful day at the park! 🌳☀️',
    ),

    // Read notifications (đã đọc)
    NotificationModel(
      notificationId: 'n5',
      actorId: 'user6',
      actorName: 'Max Adventures',
      actorAvatar: 'https://i.pravatar.cc/150?img=6',
      type: NotificationType.comment,
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      isRead: true,
      postId: '2',
      commentId: 'c2_2',
      deepLink: '/community/post/2/comment/c2_2',
      contentPreview: 'Which park is this? Looks amazing!',
    ),
    NotificationModel(
      notificationId: 'n6',
      actorId: 'user7',
      actorName: 'Rocky Mountain',
      actorAvatar: 'https://i.pravatar.cc/150?img=7',
      type: NotificationType.mention,
      createdAt: DateTime.now().subtract(const Duration(hours: 3)),
      isRead: true,
      postId: '3',
      commentId: 'c3_3',
      deepLink: '/community/post/3/comment/c3_3',
      contentPreview: '@you My dog loves this park too! We should meet up sometime 🐾',
    ),
    NotificationModel(
      notificationId: 'n7',
      actorId: 'user8',
      actorName: 'Daisy Flower',
      actorAvatar: 'https://i.pravatar.cc/150?img=8',
      type: NotificationType.react,
      createdAt: DateTime.now().subtract(const Duration(hours: 5)),
      isRead: true,
      postId: '3',
      deepLink: '/community/post/3',
      contentPreview: 'Our first photoshoot together! 📸',
    ),
    NotificationModel(
      notificationId: 'n8',
      actorId: 'user9',
      actorName: 'Cooper Tail',
      actorAvatar: 'https://i.pravatar.cc/150?img=9',
      type: NotificationType.comment,
      createdAt: DateTime.now().subtract(const Duration(hours: 8)),
      isRead: true,
      postId: '3',
      commentId: 'c3_3',
      deepLink: '/community/post/3/comment/c3_3',
      contentPreview: 'Beautiful shot! Professional level 📷',
    ),
    NotificationModel(
      notificationId: 'n9',
      actorId: 'user10',
      actorName: 'Milo Buddy',
      actorAvatar: 'https://i.pravatar.cc/150?img=10',
      type: NotificationType.follow,
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      isRead: true,
      postId: '',
      deepLink: '/profile/user10',
    ),
    NotificationModel(
      notificationId: 'n10',
      actorId: 'user11',
      actorName: 'Oscar the Cat',
      actorAvatar: 'https://i.pravatar.cc/150?img=11',
      type: NotificationType.react,
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      isRead: true,
      postId: '1',
      deepLink: '/community/post/1',
      contentPreview: 'Xin chào tôi là Salahhh # SSG104',
    ),
    NotificationModel(
      notificationId: 'n11',
      actorId: 'user12',
      actorName: 'Zoe Paws',
      actorAvatar: 'https://i.pravatar.cc/150?img=12',
      type: NotificationType.share,
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
      isRead: true,
      postId: '2',
      deepLink: '/community/post/2',
      contentPreview: 'Beautiful day at the park! 🌳☀️',
    ),
    NotificationModel(
      notificationId: 'n12',
      actorId: 'user13',
      actorName: 'Jack Russell',
      actorAvatar: 'https://i.pravatar.cc/150?img=13',
      type: NotificationType.comment,
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
      isRead: true,
      postId: '1',
      commentId: 'c1_1',
      deepLink: '/community/post/1/comment/c1_1',
      contentPreview: 'Xin chào tôi cũng muốn có chú chó như thế này',
    ),
    NotificationModel(
      notificationId: 'n13',
      actorId: 'user14',
      actorName: 'Lily Flower',
      actorAvatar: 'https://i.pravatar.cc/150?img=14',
      type: NotificationType.react,
      createdAt: DateTime.now().subtract(const Duration(days: 10)),
      isRead: true,
      postId: '3',
      deepLink: '/community/post/3',
      contentPreview: 'Our first photoshoot together! 📸',
    ),
  ];
}
