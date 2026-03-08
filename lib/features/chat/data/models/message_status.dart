/// Message Status Enum
///
/// Represents the delivery and read status of a message
enum MessageStatus {
  sending, // Message is being sent
  sent, // Message sent to server
  delivered, // Message delivered to recipient
  seen, // Message seen by recipient
  failed, // Message failed to send
}

extension MessageStatusExtension on MessageStatus {
  String get displayName {
    switch (this) {
      case MessageStatus.sending:
        return 'Sending';
      case MessageStatus.sent:
        return 'Sent';
      case MessageStatus.delivered:
        return 'Delivered';
      case MessageStatus.seen:
        return 'Seen';
      case MessageStatus.failed:
        return 'Failed';
    }
  }
}
