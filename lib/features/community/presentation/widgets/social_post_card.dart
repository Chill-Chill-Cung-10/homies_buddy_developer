import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_shapes.dart';
import '../../../../data/models/post_model.dart';
import 'post/post_header.dart';
import 'post/post_content.dart';
import 'post/post_media_carousel.dart';
import 'post/post_footer.dart';

/// [Refactored] Phase 3.2 — Split into PostHeader, PostContent,
/// PostMediaCarousel, PostFooter sub-widgets.
///
/// Social Post Card - Reusable widget cho community feed item
/// Hiển thị một bài post với header, content, media, và footer interactions
class SocialPostCard extends StatelessWidget {
  final Post post;
  final VoidCallback? onLike;
  final VoidCallback? onComment;
  final VoidCallback? onAvatarTap;
  final VoidCallback? onPostTap;
  /// Callback when author name is tapped
  final VoidCallback? onAuthorNameTap;
  /// Callback when a mention is tapped, receives the mention string (e.g. '@haiia')
  final ValueChanged<String>? onMentionTap;
  /// When true, the comment button is highlighted (e.g. in comment overlay mode)
  /// and its tap interaction is disabled
  final bool isCommentHighlighted;

  const SocialPostCard({
    super.key,
    required this.post,
    this.onLike,
    this.onComment,
    this.onAvatarTap,
    this.onPostTap,
    this.onAuthorNameTap,
    this.onMentionTap,
    this.isCommentHighlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppShapes.paddingM),
      decoration: BoxDecoration(
        color: AppColors.backgroundPost,
        borderRadius: AppShapes.card,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          PostHeader(
            post: post,
            onAvatarTap: onAvatarTap,
            onAuthorNameTap: onAuthorNameTap,
            onMentionTap: onMentionTap,
          ),

          // Content Text
          if (post.contentText.isNotEmpty) PostContent(contentText: post.contentText),

          // Media (Image/Video/Album)
          if (post.hasMedia) PostMediaCarousel(mediaFiles: post.mediaFiles),

          // Footer (Reactions & Comments)
          PostFooter(
            post: post,
            onLike: onLike,
            onComment: onComment,
            isCommentHighlighted: isCommentHighlighted,
          ),
        ],
      ),
    );
  }

  // [Refactored] Phase 1.5 — _formatCount chuyển sang core/utils/formatters.dart.
}
