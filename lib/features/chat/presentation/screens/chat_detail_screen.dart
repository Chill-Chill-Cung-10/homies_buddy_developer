import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../data/models/models.dart';
import '../../data/repositories/chat_repository.dart';
import '../widgets/widgets.dart';
import 'chat_detail_setting_screen.dart';

/// Chat Detail Screen — Firebase-backed
///
/// - Streams messages real-time từ Firestore
/// - Send text + image qua [ChatRepository]
/// - Tự động mark seen khi mở screen
class ChatDetailScreen extends StatefulWidget {
  final Conversation conversation;
  final ChatRepository repository;
  final String currentUserId;

  const ChatDetailScreen({
    super.key,
    required this.conversation,
    required this.repository,
    required this.currentUserId,
  });

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  late Conversation _conversation;
  final ScrollController _scrollController = ScrollController();
  final _picker = ImagePicker();

  // Upload progress: null = không upload, 0.0–1.0 = đang upload
  double? _uploadProgress;

  @override
  void initState() {
    super.initState();
    _conversation = widget.conversation;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _navigateToSettings() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ChatDetailSettingScreen(
          conversation: _conversation,
          repository: widget.repository,
          onConversationUpdated: (updated) {
            setState(() => _conversation = updated);
            // Persist nickname/mute to Firestore
            widget.repository.updateNickname(
              conversationId: updated.id,
              nickname: updated.nickname,
            );
            if (updated.mutedUntil != _conversation.mutedUntil) {
              widget.repository.updateMutedUntil(
                conversationId: updated.id,
                mutedUntil: updated.mutedUntil,
              );
            }
          },
        ),
      ),
    );
  }

  // ── Send text ──────────────────────────────────────────────────────────

  Future<void> _sendMessage(String content) async {
    if (content.trim().isEmpty) return;
    await widget.repository.sendTextMessage(
      conversationId: _conversation.id,
      senderId: widget.currentUserId,
      content: content,
    );
    _scrollToBottom();
  }

  // ── Send images ────────────────────────────────────────────────────────

  Future<void> _pickAndSendImages() async {
    final picked = await _picker.pickMultiImage(imageQuality: 80);
    if (picked.isEmpty) return;

    final files = picked.map((xf) => File(xf.path)).toList();

    setState(() => _uploadProgress = 0.0);

    try {
      // Fake progress vì Firebase Storage putFile không expose granular progress
      // trong MVE — dùng simple indeterminate. Bạn có thể subscribe uploadTask
      // để có real progress sau.
      await widget.repository.sendImageMessage(
        conversationId: _conversation.id,
        senderId: widget.currentUserId,
        imageFiles: files,
      );
      _scrollToBottom();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Upload thất bại: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _uploadProgress = null);
    }
  }

  // ── Mark seen for latest message ───────────────────────────────────────

  void _markSeenIfNeeded(List<Message> messages) {
    final lastOthers = messages.lastWhereOrNull(
      (m) =>
          m.senderId != widget.currentUserId &&
          m.status != MessageStatus.seen,
    );
    if (lastOthers == null) return;
    widget.repository.markSeen(
      conversationId: _conversation.id,
      messageId: lastOthers.id,
      userId: widget.currentUserId,
    );
  }

  // ── Build ──────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.backgroundPost.withOpacity(0.95),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios,
              color: AppColors.textPrimary, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: GestureDetector(
          onTap: _navigateToSettings,
          child: Row(
            children: [
              ClipOval(
                child: SizedBox(
                  width: 36,
                  height: 36,
                  child: _conversation.participantAvatar.startsWith('http')
                      ? Image.network(_conversation.participantAvatar,
                          fit: BoxFit.cover)
                      : Image.asset(_conversation.participantAvatar,
                          fit: BoxFit.cover),
                ),
              ),
              const SizedBox(width: 10),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _conversation.displayName,
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      'active now',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.accentOrange,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert, color: AppColors.iconColor),
            onPressed: _navigateToSettings,
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(gradient: AppColors.cardGradient),
        child: Column(
          children: [
            // ── Upload progress bar ──────────────────────────────
            if (_uploadProgress != null)
              LinearProgressIndicator(
                value: null, // indeterminate
                color: AppColors.accentOrange,
                backgroundColor: AppColors.accentOrange.withOpacity(0.2),
              ),

            // ── Messages stream ──────────────────────────────────
            Expanded(
              child: StreamBuilder<List<Message>>(
                stream: widget.repository
                    .watchMessages(_conversation.id),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Text('Lỗi: ${snapshot.error}',
                          style: AppTextStyles.bodyMedium),
                    );
                  }

                  final messages = snapshot.data ?? [];

                  // Mark seen sau khi build
                  if (messages.isNotEmpty) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      _markSeenIfNeeded(messages);
                    });
                    _scrollToBottom();
                  }

                  if (messages.isEmpty) {
                    return Center(
                      child: Text(
                        'No messages yet\nStart the conversation!',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.bodyMedium
                            .copyWith(color: AppColors.textSecondary),
                      ),
                    );
                  }

                  return ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 16),
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message = messages[index];
                      final isMe =
                          message.senderId == widget.currentUserId;
                      return MessageBubble(message: message, isMe: isMe);
                    },
                  );
                },
              ),
            ),

            // ── Input field ──────────────────────────────────────
            ChatInputField(
              onSendMessage: _sendMessage,
              onAttachMedia: _pickAndSendImages,
            ),
          ],
        ),
      ),
    );
  }
}

// Dart extension helper (có thể bỏ nếu dùng collection package)
extension _IterableX<T> on Iterable<T> {
  T? lastWhereOrNull(bool Function(T) test) {
    T? result;
    for (final e in this) {
      if (test(e)) result = e;
    }
    return result;
  }
}
