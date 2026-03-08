import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../data/models/models.dart';

/// Conversation Card Widget
///
/// Displays a conversation item in the chat list
class ConversationCard extends StatelessWidget {
  final Conversation conversation;
  final VoidCallback onTap;

  const ConversationCard({
    super.key,
    required this.conversation,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: conversation.hasUnread
            ? AppColors.backgroundPost.withOpacity(0.95)
            : AppColors.backgroundPost.withOpacity(0.7),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.textSecondary.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Avatar
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: conversation.hasUnread
                          ? AppColors.accentOrange
                          : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  child: ClipOval(
                    child: conversation.participantAvatar.startsWith('http')
                        ? Image.network(
                            conversation.participantAvatar,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => _avatarFallback(),
                          )
                        : Image.asset(
                            conversation.participantAvatar,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => _avatarFallback(),
                          ),
                  ),
                ),
                const SizedBox(width: 14),

                // Name and message preview
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        conversation.displayName,
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontWeight: conversation.hasUnread
                              ? FontWeight.w600
                              : FontWeight.w500,
                          color: AppColors.textPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        conversation.lastMessage,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: conversation.hasUnread
                              ? AppColors.textPrimary.withOpacity(0.8)
                              : AppColors.textSecondary,
                          fontWeight: conversation.hasUnread
                              ? FontWeight.w500
                              : FontWeight.w400,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),

                // Time and unread badge
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      timeago.format(
                        conversation.lastUpdated,
                        locale: 'en_short',
                      ),
                      style: AppTextStyles.caption.copyWith(
                        color: conversation.hasUnread
                            ? AppColors.accentOrange
                            : AppColors.textSecondary,
                        fontWeight: conversation.hasUnread
                            ? FontWeight.w600
                            : FontWeight.w400,
                      ),
                    ),
                    if (conversation.hasUnread) ...[
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.accentOrange,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${conversation.unreadCount}',
                          style: AppTextStyles.caption.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 11,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _avatarFallback() {
    return Container(
      color: AppColors.backgroundPost,
      child: Icon(Icons.person, color: AppColors.textSecondary, size: 28),
    );
  }
}
