import 'dart:io';

import '../models/models.dart';

/// Data contract for chat feature.
///
/// UI depends on this abstraction so screens can work with Firebase or another
/// backend implementation without changing presentation code.
abstract class ChatRepository {
  Stream<List<Conversation>> watchConversations(String currentUserId);

  Future<Conversation> getOrCreateConversation({
    required String currentUserId,
    required String otherUserId,
    required String otherUserName,
    required String otherUserAvatar,
  });

  Future<void> updateNickname({
    required String conversationId,
    required String? nickname,
  });

  Future<void> updateMutedUntil({
    required String conversationId,
    required DateTime? mutedUntil,
  });

  Future<void> markConversationAsRead({
    required String conversationId,
    required String currentUserId,
  });

  Stream<List<Message>> watchMessages(String conversationId);

  Future<void> sendTextMessage({
    required String conversationId,
    required String senderId,
    required String content,
  });

  Future<void> sendImageMessage({
    required String conversationId,
    required String senderId,
    required List<File> imageFiles,
    String caption = '',
  });

  Future<void> updateMessageStatus({
    required String conversationId,
    required String messageId,
    required MessageStatus status,
  });

  Future<void> markDelivered({
    required String conversationId,
    required String messageId,
    required String userId,
  });

  Future<void> markSeen({
    required String conversationId,
    required String messageId,
    required String userId,
  });
}
