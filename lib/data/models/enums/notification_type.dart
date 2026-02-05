import 'package:freezed_annotation/freezed_annotation.dart';

/// Notification Type - Loại thông báo
enum NotificationType {
  @JsonValue('react')
  react,
  
  @JsonValue('comment')
  comment,
  
  @JsonValue('follow')
  follow,
  
  @JsonValue('mention')
  mention,
  
  @JsonValue('share')
  share;

  /// Chuyển từ string sang enum
  static NotificationType fromString(String value) {
    return NotificationType.values.firstWhere(
      (type) => type.name == value.toLowerCase(),
      orElse: () => NotificationType.react,
    );
  }

  /// Convert sang string để hiển thị
  String get displayName {
    switch (this) {
      case NotificationType.react:
        return 'đã thích bài viết của bạn';
      case NotificationType.comment:
        return 'đã bình luận bài viết của bạn';
      case NotificationType.follow:
        return 'đã theo dõi bạn';
      case NotificationType.mention:
        return 'đã nhắc đến bạn';
      case NotificationType.share:
        return 'đã chia sẻ bài viết của bạn';
    }
  }

  /// Icon name để hiển thị
  String get iconName {
    switch (this) {
      case NotificationType.react:
        return 'favorite';
      case NotificationType.comment:
        return 'comment';
      case NotificationType.follow:
        return 'person_add';
      case NotificationType.mention:
        return 'alternate_email';
      case NotificationType.share:
        return 'share';
    }
  }

  /// Màu sắc cho icon
  String get iconColor {
    switch (this) {
      case NotificationType.react:
        return '#E91E63'; // Pink
      case NotificationType.comment:
        return '#2196F3'; // Blue
      case NotificationType.follow:
        return '#4CAF50'; // Green
      case NotificationType.mention:
        return '#FF9800'; // Orange
      case NotificationType.share:
        return '#9C27B0'; // Purple
    }
  }
}
