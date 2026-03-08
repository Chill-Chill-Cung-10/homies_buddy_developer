import 'package:freezed_annotation/freezed_annotation.dart';
import 'message_type.dart';
import 'message_status.dart';

part 'message_model.freezed.dart';
part 'message_model.g.dart';

/// Message Model
///
/// Represents a single message in a conversation
@freezed
abstract class Message with _$Message {
  const factory Message({
    required String id,
    required String conversationId,
    required String senderId,
    required String content,

    /// ⭐ **Thêm mới** — Danh sách URL media (thay cho single image)
    @Default([]) List<String> mediaUrls,

    required MessageType type,
    required DateTime createdAt,
    required MessageStatus status,
  }) = _Message;

  factory Message.fromJson(Map<String, dynamic> json) =>
      _$MessageFromJson(json);
}

/// Extension để thêm các helper methods
extension MessageX on Message {
  /// Kiểm tra xem có media không
  bool get hasMedia => mediaUrls.isNotEmpty;

  /// Kiểm tra xem message có đã gửi thành công không
  bool get isSent =>
      status == MessageStatus.sent ||
      status == MessageStatus.delivered ||
      status == MessageStatus.seen;

  /// Kiểm tra xem message có đang gửi không
  bool get isSending => status == MessageStatus.sending;

  /// Kiểm tra xem message có bị lỗi không
  bool get isFailed => status == MessageStatus.failed;

  /// Kiểm tra xem message có tình trạng "seen" không
  bool get isSeen => status == MessageStatus.seen;

  /// Lấy thời gian message dạng "time ago"
  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(createdAt);

    if (difference.inDays > 0) {
      return '${difference.inDays} ngày trước';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} giờ trước';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} phút trước';
    } else {
      return 'Vừa xong';
    }
  }

  /// Lấy preview message (cắt ngắn nếu quá dài)
  String get preview {
    if (content.length > 50) {
      return '${content.substring(0, 50)}...';
    }
    return content;
  }
}
