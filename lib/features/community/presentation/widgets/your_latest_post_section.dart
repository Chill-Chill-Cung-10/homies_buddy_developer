/// Your Latest Post Section — Displays the user's most recent post at the top of the feed
///
/// Features:
/// - Shows user's latest post in a separate section
/// - Delete functionality via three dots menu
/// - Integrates with existing SocialPostCard widget
library;

import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../data/models/post_model.dart';
import 'social_post_card.dart';

/// Widget that displays the user's latest post in a highlighted section
class YourLatestPostSection extends StatelessWidget {
  const YourLatestPostSection({
    super.key,
    required this.post,
    this.isLikedByMe = false,
    required this.onLike,
    required this.onComment,
    required this.onAvatarTap,
    required this.onAuthorNameTap,
    required this.onMentionTap,
    required this.onPostTap,
    this.onDelete,
  });

  /// The user's latest post to display
  final Post post;

  /// Whether the current user has liked this post
  final bool isLikedByMe;

  /// Called when the like button is pressed
  final VoidCallback onLike;

  /// Called when the comment button is pressed
  final VoidCallback onComment;

  /// Called when the author's avatar is tapped
  final VoidCallback onAvatarTap;

  /// Called when the author's name is tapped
  final VoidCallback onAuthorNameTap;

  /// Called when a mention is tapped
  final void Function(String mention) onMentionTap;

  /// Called when the post is tapped
  final VoidCallback onPostTap;

  /// Called when delete is pressed from the three dots menu
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header - Simple style like "Bài viết khác"
        Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.m),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  height: 1,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        AppColors.borderLight.withOpacity(0.5),
                        AppColors.borderLight,
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.m),
                child: Text(
                  'Bài viết mới của bạn',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary.withOpacity(0.7),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  height: 1,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.borderLight,
                        AppColors.borderLight.withOpacity(0.5),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        // Post Card 
        SocialPostCard(
          post: post,
          isLikedByMe: isLikedByMe,
          onLike: onLike,
          onComment: onComment,
          onAvatarTap: onAvatarTap,
          onAuthorNameTap: onAuthorNameTap,
          onMentionTap: onMentionTap,
          onPostTap: onPostTap,
          onDelete: onDelete,
        ),

        // Divider
        Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.m),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  height: 1,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        AppColors.borderLight.withOpacity(0.5),
                        AppColors.borderLight,
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.m),
                child: Text(
                  'Bài viết khác',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary.withOpacity(0.7),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  height: 1,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.borderLight,
                        AppColors.borderLight.withOpacity(0.5),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
