import 'message_type.dart';
import 'message_status.dart';

/// Message Model
/// 
/// Represents a single message in a conversation
class Message {
  final String id;
  final String conversationId;
  final String senderId;
  final String content;
  final MessageType type;
  final DateTime createdAt;
  final MessageStatus status;

  const Message({
    required this.id,
    required this.conversationId,
    required this.senderId,
    required this.content,
    required this.type,
    required this.createdAt,
    required this.status,
  });

  Message copyWith({
    String? id,
    String? conversationId,
    String? senderId,
    String? content,
    MessageType? type,
    DateTime? createdAt,
    MessageStatus? status,
  }) {
    return Message(
      id: id ?? this.id,
      conversationId: conversationId ?? this.conversationId,
      senderId: senderId ?? this.senderId,
      content: content ?? this.content,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
      status: status ?? this.status,
    );
  }
}
