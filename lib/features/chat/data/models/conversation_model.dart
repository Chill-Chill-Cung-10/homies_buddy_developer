import 'package:freezed_annotation/freezed_annotation.dart';

part 'conversation_model.freezed.dart';
part 'conversation_model.g.dart';

/// Conversation Model
///
/// Represents a conversation between users/homes
@freezed
abstract class Conversation with _$Conversation {
  const factory Conversation({
    required String id,
    required List<String> participantIds,
    required String participantName, // Home name
    required String participantAvatar, // Home avatar
    required String lastMessage,
    required DateTime lastUpdated,
    required int unreadCount,
    String? nickname, // Custom nickname set by current user
    DateTime? mutedUntil, // Null = not muted, DateTime.max = muted forever
  }) = _Conversation;

  factory Conversation.fromJson(Map<String, dynamic> json) =>
      _$ConversationFromJson(json);
}

/// Extension để thêm các helper methods
extension ConversationX on Conversation {
  /// Display name: nickname if set, otherwise participantName
  String get displayName =>
      nickname?.isNotEmpty == true ? nickname! : participantName;

  /// Whether this conversation is currently muted
  bool get isMuted {
    if (mutedUntil == null) return false;
    return mutedUntil!.isAfter(DateTime.now());
  }

  /// Kiểm tra xem có tin nhắn chưa đọc không
  bool get hasUnread => unreadCount > 0;

  /// Lấy thời gian last updated dạng "time ago"
  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(lastUpdated);

    if (difference.inDays > 0) {
      return '${difference.inDays} ngày';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} giờ';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} phút';
    } else {
      return 'Vừa xong';
    }
  }

  /// Lấy preview last message (cắt ngắn)
  String get lastMessagePreview {
    if (lastMessage.length > 50) {
      return '${lastMessage.substring(0, 50)}...';
    }
    return lastMessage;
  }
}
