import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/constants/app_shapes.dart';
import '../../../../core/utils/formatters.dart';
import '../../data/models/help_chat_model.dart';

/// Conversation History Sidebar - slides in from the right as a Drawer,
/// showing past conversations and a "New Chat" button.
class ConversationHistorySidebar extends StatelessWidget {
  final List<HelpConversationHistory> conversations;
  final ValueChanged<HelpConversationHistory> onConversationTap;
  final VoidCallback onNewChatTap;

  const ConversationHistorySidebar({
    super.key,
    required this.conversations,
    required this.onConversationTap,
    required this.onNewChatTap,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.78,
      backgroundColor: Colors.transparent,
      child: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.backgroundGradient,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            bottomLeft: Radius.circular(24),
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(context),
              const Divider(
                height: 1,
                color: Color(0xFFE0D5C8),
                indent: 16,
                endIndent: 16,
              ),
              Expanded(child: _buildConversationList()),
              _buildNewChatButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppShapes.paddingM,
        vertical: AppShapes.paddingM,
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primaryPeach.withValues(alpha: 0.5),
            ),
            child: const Center(
              child: Icon(
                Icons.history,
                size: 20,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Text('History', style: AppTextStyles.h2.copyWith(fontSize: 20)),
          const Spacer(),
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: const Icon(
              Icons.close,
              color: AppColors.textSecondary,
              size: 22,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConversationList() {
    if (conversations.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('💬', style: TextStyle(fontSize: 40)),
            const SizedBox(height: 12),
            Text(
              'No conversations yet',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Start chatting to see history',
              style: AppTextStyles.caption.copyWith(color: AppColors.textHint),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(
        horizontal: AppShapes.paddingS,
        vertical: AppShapes.paddingS,
      ),
      itemCount: conversations.length,
      separatorBuilder: (_, __) => const SizedBox(height: 4),
      itemBuilder: (context, index) {
        final conversation = conversations[index];
        return _ConversationTile(
          conversation: conversation,
          onTap: () => onConversationTap(conversation),
        );
      },
    );
  }

  Widget _buildNewChatButton() {
    return Padding(
      padding: const EdgeInsets.all(AppShapes.paddingM),
      child: SizedBox(
        width: double.infinity,
        height: 48,
        child: ElevatedButton.icon(
          onPressed: onNewChatTap,
          icon: const Icon(Icons.add_circle_outline, size: 20),
          label: Text(
            'New Chat',
            style: AppTextStyles.bodyLarge.copyWith(
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.accentOrange,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            elevation: 2,
            shadowColor: AppColors.accentOrange.withValues(alpha: 0.3),
          ),
        ),
      ),
    );
  }
}

class _ConversationTile extends StatelessWidget {
  final HelpConversationHistory conversation;
  final VoidCallback onTap;

  const _ConversationTile({required this.conversation, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.45),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              // Icon
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primaryPeach.withValues(alpha: 0.4),
                ),
                child: const Center(
                  child: Text('🌱', style: TextStyle(fontSize: 18)),
                ),
              ),
              const SizedBox(width: 12),

              // Title + preview
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      conversation.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.bodyLarge.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      conversation.preview,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              // Time
              Text(
                formatRelativeTime(conversation.lastMessageAt),
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textHint,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // [Refactored] Phase 1.5 — _formatTime chuyển sang core/utils/formatters.dart
  // (formatRelativeTime).
}
