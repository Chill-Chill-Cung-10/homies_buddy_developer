/// [Refactored] Phase 3.2 — Extracted from social_post_card.dart
/// Post header: avatar, author name (with mentions), time, privacy icon, more options
library;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_text_styles.dart';
import '../../../../../core/constants/app_shapes.dart';
import '../../../../../data/models/post_model.dart';

class PostHeader extends StatelessWidget {
  final Post post;
  final VoidCallback? onAvatarTap;
  final VoidCallback? onAuthorNameTap;
  final ValueChanged<String>? onMentionTap;
  final VoidCallback? onDelete;

  const PostHeader({
    super.key,
    required this.post,
    this.onAvatarTap,
    this.onAuthorNameTap,
    this.onMentionTap,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppShapes.paddingM),
      child: Row(
        children: [
          // Avatar
          GestureDetector(
            onTap: onAvatarTap,
            child: ClipOval(
              child: _isValidHttpUrl(post.authorAvatar)
                  ? CachedNetworkImage(
                      imageUrl: post.authorAvatar.trim(),
                      width: 40,
                      height: 40,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        width: 40,
                        height: 40,
                        color: AppColors.surfaceColor,
                        child: const Icon(
                          Icons.person,
                          size: 20,
                          color: AppColors.textHint,
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        width: 40,
                        height: 40,
                        color: AppColors.surfaceColor,
                        child: const Icon(
                          Icons.person,
                          size: 20,
                          color: AppColors.textHint,
                        ),
                      ),
                    )
                  : Container(
                      width: 40,
                      height: 40,
                      color: AppColors.surfaceColor,
                      child: const Icon(
                        Icons.person,
                        size: 20,
                        color: AppColors.textHint,
                      ),
                    ),
            ),
          ),
          const SizedBox(width: 12),

          // Author Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildAuthorNameWithMentions(),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Text(
                      post.timeAgo,
                      style: AppTextStyles.bodySmall.copyWith(
                        fontSize: 11,
                        color: AppColors.textHint,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      _getPrivacyIcon(),
                      size: 11,
                      color: AppColors.textHint,
                    ),
                  ],
                ),
              ],
            ),
          ),

          // More Options
          PopupMenuButton<String>(
            icon: SvgPicture.asset(
              'assets/images/icons/three_dots.svg',
              width: 20,
              height: 20,
              colorFilter: const ColorFilter.mode(
                AppColors.iconColor,
                BlendMode.srcIn,
              ),
            ),
            onSelected: (value) {
              if (value == 'delete' && onDelete != null) {
                onDelete!();
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem<String>(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(
                      Icons.delete_outline,
                      color: AppColors.errorRed,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Xóa bài viết',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.errorRed,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAuthorNameWithMentions() {
    if (post.hasMentions) {
      return Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: post.authorName,
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () => onAuthorNameTap?.call(),
            ),
            TextSpan(
              text: ' cùng với ',
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.textBlack,
              ),
            ),
            ...post.mentions.asMap().entries.expand((entry) {
              final index = entry.key;
              final mention = entry.value;
              return [
                if (index > 0)
                  TextSpan(
                    text: ', ',
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                TextSpan(
                  text: mention,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.accentOrange,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () => onMentionTap?.call(mention),
                ),
              ];
            }),
          ],
        ),
      );
    }

    return GestureDetector(
      onTap: onAuthorNameTap,
      child: Text(
        post.authorName,
        style: AppTextStyles.bodyLarge.copyWith(
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }

  IconData _getPrivacyIcon() {
    switch (post.privacy.name) {
      case 'public':
        return Icons.public;
      case 'friends':
        return Icons.people;
      case 'private':
        return Icons.lock;
      default:
        return Icons.public;
    }
  }

  bool _isValidHttpUrl(String? url) {
    if (url == null) return false;
    final trimmed = url.trim();
    if (trimmed.isEmpty) return false;
    final uri = Uri.tryParse(trimmed);
    return uri != null && uri.hasScheme && uri.host.isNotEmpty;
  }
}
