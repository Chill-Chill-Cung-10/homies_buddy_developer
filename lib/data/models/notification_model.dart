import 'package:freezed_annotation/freezed_annotation.dart';
import 'enums/notification_type.dart';

part 'notification_model.freezed.dart';
part 'notification_model.g.dart';

/// Notification Model - Thông báo về các hoạt động
///
/// Thông báo khi có người react, comment, follow, mention, hoặc share
/// bài viết của user
@freezed
abstract class NotificationModel with _$NotificationModel {
  const factory NotificationModel({
    /// User ID người **GỬI** / thực hiện action
    required String actorId,

    /// ⭐ **Thêm mới** — User ID người **NHẬN** notification
    required String recipientId,

    required String actorName,
    required String actorAvatar,
    required String notificationId,
    required NotificationType type,
    required DateTime createdAt,
    required bool isRead,
    required String postId,
    String? commentId,
    required String deepLink,
    String? contentPreview,
  }) = _NotificationModel;

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationModelFromJson(json);
}

/// Extension để thêm các helper methods
extension NotificationModelX on NotificationModel {
  /// Lấy message đầy đủ để hiển thị
  String get message {
    final action = type.displayName;
    return '$actorName $action';
  }

  /// Lấy thời gian dạng "time ago"
  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(createdAt);

    if (difference.inDays > 7) {
      return '${createdAt.day}/${createdAt.month}/${createdAt.year}';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} ngày trước';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} giờ trước';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} phút trước';
    } else {
      return 'Vừa xong';
    }
  }

  /// Kiểm tra xem có phải notification về comment không
  bool get isCommentNotification => type == NotificationType.comment;

  /// Kiểm tra xem có phải notification về react không
  bool get isReactNotification => type == NotificationType.react;

  /// Kiểm tra xem có phải notification về follow không
  bool get isFollowNotification => type == NotificationType.follow;

  /// Kiểm tra xem có preview content không
  bool get hasContentPreview =>
      contentPreview != null && contentPreview!.isNotEmpty;

  /// Lấy icon name để hiển thị
  String get iconName => type.iconName;

  /// Lấy icon color để hiển thị
  String get iconColor => type.iconColor;
}
