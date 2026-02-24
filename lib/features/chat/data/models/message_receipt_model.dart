/// Message Receipt Model
/// 
/// Tracks when a message was delivered and seen by a user
class MessageReceipt {
  final String messageId;
  final String userId;
  final DateTime? deliveredAt;
  final DateTime? seenAt;

  const MessageReceipt({
    required this.messageId,
    required this.userId,
    this.deliveredAt,
    this.seenAt,
  });

  MessageReceipt copyWith({
    String? messageId,
    String? userId,
    DateTime? deliveredAt,
    DateTime? seenAt,
  }) {
    return MessageReceipt(
      messageId: messageId ?? this.messageId,
      userId: userId ?? this.userId,
      deliveredAt: deliveredAt ?? this.deliveredAt,
      seenAt: seenAt ?? this.seenAt,
    );
  }
}
