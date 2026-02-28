/// [Refactored] Phase 3.3 — Extracted from comment_overlay.dart
/// Single comment item: avatar, bubble, react button, time + highlight animation
library;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_text_styles.dart';
import '../../../../../core/constants/app_shapes.dart';
import '../../../../../core/utils/formatters.dart';
import '../../../../../data/models/comment_model.dart';

class CommentItem extends StatelessWidget {
  final Comment comment;
  final bool isHighlighted;
  final double highlightOpacity;
  final EdgeInsets highlightPadding;
  final GlobalKey? commentKey;
  final ValueChanged<Comment>? onReact;

  const CommentItem({
    super.key,
    required this.comment,
    this.isHighlighted = false,
    this.highlightOpacity = 0.2,
    this.highlightPadding = const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    this.commentKey,
    this.onReact,
  });

  @override
  Widget build(BuildContext context) {
    final commentWidget = Container(
      margin: const EdgeInsets.only(bottom: AppShapes.paddingM),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Commenter Avatar
          ClipOval(
            child: CachedNetworkImage(
              imageUrl: comment.authorAvatar,
              width: 36,
              height: 36,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                width: 36,
                height: 36,
                color: AppColors.surfaceColor,
                child: const Icon(
                  Icons.person,
                  size: 18,
                  color: AppColors.textHint,
                ),
              ),
              errorWidget: (context, url, error) => Container(
                width: 36,
                height: 36,
                color: AppColors.surfaceColor,
                child: const Icon(
                  Icons.person,
                  size: AppShapes.iconS,
                  color: AppColors.textHint,
                ),
              ),
            ),
          ),

          const SizedBox(width: 12),

          // Comment Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Comment Bubble
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppShapes.paddingM,
                    vertical: AppShapes.paddingS + 2,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceColor,
                    borderRadius: BorderRadius.circular(AppShapes.buttonRadius),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Commenter Name
                      Text(
                        comment.authorName,
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),

                      // Comment Text
                      Text(
                        comment.contentText,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 6),

                // Comment Meta (Like count + Time)
                Row(
                  children: [
                    Flexible(
                      child: GestureDetector(
                        onTap: () => onReact?.call(comment),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SvgPicture.asset(
                              comment.isReactedByMe
                                  ? 'assets/images/icons/heart_reactions_on.svg'
                                  : 'assets/images/icons/heart_reactions_off.svg',
                              width: 14,
                              height: 14,
                              colorFilter: ColorFilter.mode(
                                comment.isReactedByMe
                                    ? AppColors.errorRed
                                    : AppColors.iconColor,
                                BlendMode.srcIn,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                comment.reactCount > 0
                                    ? 'Thích ${formatCount(comment.reactCount)}'
                                    : 'Thích',
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: comment.isReactedByMe
                                      ? AppColors.errorRed
                                      : AppColors.textHint,
                                  fontWeight: comment.isReactedByMe
                                      ? FontWeight.w600
                                      : FontWeight.normal,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(width: 16),

                    // Time
                    Flexible(
                      child: Text(
                        comment.timeAgo,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textHint,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );

    // Wrap with highlight container if this comment is highlighted
    if (isHighlighted) {
      return AnimatedContainer(
        key: commentKey,
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: Colors.yellow.withValues(alpha: highlightOpacity),
          borderRadius: BorderRadius.circular(AppShapes.buttonRadius),
        ),
        padding: highlightPadding,
        child: commentWidget,
      );
    }

    return commentWidget;
  }
}
