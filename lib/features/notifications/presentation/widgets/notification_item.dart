/// [Refactored] Phase 3.6 — Moved from features/community/presentation/widgets/
library;

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/constants/app_shapes.dart';
import '../../../../data/models/notification_model.dart';

/// Notification Item Widget - Single notification list item
///
/// Hiển thị một notification item với avatar, message, timestamp, và unread indicator
class NotificationItem extends StatelessWidget {
  final NotificationModel notification;
  final VoidCallback onTap;

  const NotificationItem({
    super.key,
    required this.notification,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: notification.isRead
          ? Colors.transparent
          : AppColors.primaryPink.withValues(alpha: 0.15), // Unread highlight
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppShapes.paddingM,
            vertical: AppShapes.paddingM,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Actor Avatar
              CircleAvatar(
                radius: 24,
                backgroundImage: notification.actorAvatar.isNotEmpty
                    ? CachedNetworkImageProvider(
                        notification.actorAvatar,
                      )
                    : null,
                backgroundColor: AppColors.surfaceColor,
                child: notification.actorAvatar.isEmpty
                    ? const Icon(Icons.person, size: 24, color: AppColors.textHint)
                    : null,
              ),

              const SizedBox(width: 12),

              // Notification Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Notification Message
                    Row(
                      children: [
                        Expanded(
                          child: RichText(
                            text: TextSpan(
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.textPrimary,
                              ),
                              children: [
                                // Actor Name (bold)
                                TextSpan(
                                  text: notification.actorName,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                // Action text
                                TextSpan(
                                  text: ' ${notification.type.displayName}',
                                ), 
                              ],
                            ),
                          ),
                        ),

                        // Unread indicator dot
                        if (!notification.isRead) ...[
                          const SizedBox(width: 8),
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: AppColors.accentOrange,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ],
                      ],
                    ),

                    // Content Preview (if exists)
                    if (notification.hasContentPreview) ...[
                      const SizedBox(height: 4),
                      Text(
                        notification.contentPreview!,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textHint,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],

                    // Timestamp
                    const SizedBox(height: 4),
                    Text(
                      notification.timeAgo,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textHint,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
