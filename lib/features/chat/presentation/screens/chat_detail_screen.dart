import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../data/models/models.dart';
import '../../mockdata/chat_mock_data.dart';
import '../widgets/widgets.dart';
import 'chat_detail_setting_screen.dart';

/// Chat Detail Screen
/// 
/// Displays conversation messages in a warm, cozy interface
class ChatDetailScreen extends StatefulWidget {
  final Conversation conversation;

  const ChatDetailScreen({
    super.key,
    required this.conversation,
  });

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  late List<Message> _messages;
  late Conversation _conversation;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _conversation = widget.conversation;
    _messages = ChatMockData.getMessagesForConversation(widget.conversation.id);
    
    // Scroll to bottom after frame is rendered
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _navigateToSettings() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ChatDetailSettingScreen(
          conversation: _conversation,
          onConversationUpdated: (updated) {
            setState(() {
              _conversation = updated;
            });
          },
        ),
      ),
    );
  }

  void _sendMessage(String content) {
    if (content.trim().isEmpty) return;

    final newMessage = Message(
      id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
      conversationId: widget.conversation.id,
      senderId: ChatMockData.currentUserId,
      content: content,
      type: MessageType.text,
      createdAt: DateTime.now(),
      status: MessageStatus.sending,
    );

    setState(() {
      _messages.add(newMessage);
    });

    // Simulate sending (mark as sent then delivered)
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          final index = _messages.indexWhere((m) => m.id == newMessage.id);
          if (index != -1) {
            _messages[index] = newMessage.copyWith(status: MessageStatus.sent);
          }
        });
      }
    });

    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          final index = _messages.indexWhere((m) => m.id == newMessage.id);
          if (index != -1) {
            _messages[index] = newMessage.copyWith(status: MessageStatus.delivered);
          }
        });
      }
    });

    // Scroll to bottom
    Future.delayed(const Duration(milliseconds: 100), () {
      _scrollToBottom();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.backgroundPost.withOpacity(0.95),
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: AppColors.textPrimary,
            size: 20,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: GestureDetector(
          onTap: _navigateToSettings,
          child: Row(
            children: [
              // Avatar
              ClipOval(
                child: SizedBox(
                  width: 36,
                  height: 36,
                  child: _conversation.participantAvatar.startsWith('http')
                      ? Image.network(
                          _conversation.participantAvatar,
                          fit: BoxFit.cover,
                        )
                      : Image.asset(
                          _conversation.participantAvatar,
                          fit: BoxFit.cover,
                        ),
                ),
              ),
              const SizedBox(width: 10),
              // Name and status
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
            icon: Icon(
              Icons.more_vert,
              color: AppColors.iconColor,
            ),
            onPressed: _navigateToSettings,
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: AppColors.cardGradient,
        ),
        child: Column(
          children: [
            // Messages List
            Expanded(
              child: _messages.isEmpty
                  ? Center(
                      child: Text(
                        'No messages yet\nStart the conversation!',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    )
                  : ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                      itemCount: _messages.length,
                      itemBuilder: (context, index) {
                        final message = _messages[index];
                        final isMe = message.senderId == ChatMockData.currentUserId;
                        
                        return MessageBubble(
                          message: message,
                          isMe: isMe,
                        );
                      },
                    ),
            ),

            // Input Field
            ChatInputField(
              onSendMessage: _sendMessage,
              onAttachMedia: () {
                // TODO: Implement media attachment
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Media attachment coming soon!'),
                    duration: Duration(seconds: 1),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
