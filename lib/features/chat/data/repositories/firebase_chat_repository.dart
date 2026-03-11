import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

import '../models/models.dart';
import 'chat_repository.dart';

/// Firebase implementation of [ChatRepository]
///
/// Firestore structure:
///   conversations/{convId}                    ← Conversation doc
///   conversations/{convId}/messages/{msgId}   ← Message doc
///   conversations/{convId}/messages/{msgId}/receipts/{userId}  ← Receipt doc
class FirebaseChatRepository implements ChatRepository {
  FirebaseChatRepository({
    FirebaseFirestore? firestore,
    FirebaseStorage? storage,
  })  : _db = firestore ?? FirebaseFirestore.instance,
        _storage = storage ?? FirebaseStorage.instance;

  final FirebaseFirestore _db;
  final FirebaseStorage _storage;
  final _uuid = const Uuid();

  // ── Collection refs ────────────────────────────────────────────────────

  CollectionReference<Map<String, dynamic>> get _conversations =>
      _db.collection('conversations');

  CollectionReference<Map<String, dynamic>> _messages(String convId) =>
      _conversations.doc(convId).collection('messages');

  CollectionReference<Map<String, dynamic>> _receipts(
          String convId, String msgId) =>
      _messages(convId).doc(msgId).collection('receipts');

  // ── Conversations ──────────────────────────────────────────────────────

  @override
  Stream<List<Conversation>> watchConversations(String currentUserId) {
    return _conversations
        .where('participantIds', arrayContains: currentUserId)
        .orderBy('lastUpdated', descending: true)
        .snapshots()
        .map((snap) => snap.docs
            .map((doc) => Conversation.fromJson({...doc.data(), 'id': doc.id}))
            .toList());
  }

  @override
  Future<Conversation> getOrCreateConversation({
    required String currentUserId,
    required String otherUserId,
    required String otherUserName,
    required String otherUserAvatar,
  }) async {
    // Query for existing conversation between these two users
    final existing = await _conversations
        .where('participantIds', arrayContains: currentUserId)
        .get();

    QueryDocumentSnapshot<Map<String, dynamic>>? existingDoc;
    for (final doc in existing.docs) {
      final ids = List<String>.from(doc.data()['participantIds'] ?? []);
      if (ids.contains(otherUserId)) {
        existingDoc = doc;
        break;
      }
    }

    if (existingDoc != null) {
      return Conversation.fromJson({...existingDoc.data(), 'id': existingDoc.id});
    }

    // Create new conversation
    final convId = _uuid.v4();
    final now = DateTime.now();
    final conv = Conversation(
      id: convId,
      participantIds: [currentUserId, otherUserId],
      participantName: otherUserName,
      participantAvatar: otherUserAvatar,
      lastMessage: '',
      lastUpdated: now,
      unreadCount: 0,
    );

    await _conversations.doc(convId).set({
      ...conv.toJson(),
      'id': convId,
      'lastUpdated': FieldValue.serverTimestamp(),
    });

    return conv;
  }

  @override
  Future<void> updateNickname({
    required String conversationId,
    required String? nickname,
  }) async {
    await _conversations.doc(conversationId).update({'nickname': nickname});
  }

  @override
  Future<void> updateMutedUntil({
    required String conversationId,
    required DateTime? mutedUntil,
  }) async {
    await _conversations.doc(conversationId).update({
      'mutedUntil': mutedUntil?.toIso8601String(),
    });
  }

  @override
  Future<void> markConversationAsRead({
    required String conversationId,
    required String currentUserId,
  }) async {
    await _conversations.doc(conversationId).update({'unreadCount': 0});
  }

  // ── Messages ───────────────────────────────────────────────────────────

  @override
  Stream<List<Message>> watchMessages(String conversationId) {
    return _messages(conversationId)
        .orderBy('createdAt', descending: false)
        .snapshots()
        .map((snap) => snap.docs
            .map((doc) => Message.fromJson({...doc.data(), 'id': doc.id}))
            .toList());
  }

  @override
  Future<void> sendTextMessage({
    required String conversationId,
    required String senderId,
    required String content,
  }) async {
    final msgId = _uuid.v4();
    final now = FieldValue.serverTimestamp();

    final msgData = {
      'id': msgId,
      'conversationId': conversationId,
      'senderId': senderId,
      'content': content,
      'mediaUrls': <String>[],
      'type': 'text',
      'createdAt': now,
      'status': 'sent', // Server receives it → immediately 'sent'
    };

    // Batch: write message + update conversation preview
    final batch = _db.batch();

    batch.set(_messages(conversationId).doc(msgId), msgData);

    batch.update(_conversations.doc(conversationId), {
      'lastMessage': content,
      'lastUpdated': now,
      'unreadCount': FieldValue.increment(1),
    });

    await batch.commit();
  }

  @override
  Future<void> sendImageMessage({
    required String conversationId,
    required String senderId,
    required List<File> imageFiles,
    String caption = '',
  }) async {
    // 1. Upload all images to Firebase Storage concurrently
    final uploadFutures = imageFiles.asMap().entries.map((entry) async {
      final index = entry.key;
      final file = entry.value;
      final ext = file.path.split('.').last;
      final path =
          'chat/$conversationId/${_uuid.v4()}_$index.$ext';
      final ref = _storage.ref().child(path);
      final task = await ref.putFile(file);
      return await task.ref.getDownloadURL();
    });

    final mediaUrls = await Future.wait(uploadFutures);

    // 2. Save message doc with URLs
    final msgId = _uuid.v4();
    final now = FieldValue.serverTimestamp();
    final preview =
        caption.isNotEmpty ? caption : '📷 ${mediaUrls.length} ảnh';

    final batch = _db.batch();

    batch.set(_messages(conversationId).doc(msgId), {
      'id': msgId,
      'conversationId': conversationId,
      'senderId': senderId,
      'content': caption,
      'mediaUrls': mediaUrls,
      'type': 'image',
      'createdAt': now,
      'status': 'sent',
    });

    batch.update(_conversations.doc(conversationId), {
      'lastMessage': preview,
      'lastUpdated': now,
      'unreadCount': FieldValue.increment(1),
    });

    await batch.commit();
  }

  @override
  Future<void> updateMessageStatus({
    required String conversationId,
    required String messageId,
    required MessageStatus status,
  }) async {
    await _messages(conversationId)
        .doc(messageId)
        .update({'status': status.name});
  }

  // ── Receipts ───────────────────────────────────────────────────────────

  @override
  Future<void> markDelivered({
    required String conversationId,
    required String messageId,
    required String userId,
  }) async {
    await _receipts(conversationId, messageId).doc(userId).set(
      {'deliveredAt': FieldValue.serverTimestamp(), 'userId': userId},
      SetOptions(merge: true),
    );
    await updateMessageStatus(
      conversationId: conversationId,
      messageId: messageId,
      status: MessageStatus.delivered,
    );
  }

  @override
  Future<void> markSeen({
    required String conversationId,
    required String messageId,
    required String userId,
  }) async {
    await _receipts(conversationId, messageId).doc(userId).set(
      {'seenAt': FieldValue.serverTimestamp(), 'userId': userId},
      SetOptions(merge: true),
    );
    await updateMessageStatus(
      conversationId: conversationId,
      messageId: messageId,
      status: MessageStatus.seen,
    );
  }
}
