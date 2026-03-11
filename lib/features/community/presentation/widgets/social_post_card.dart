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
/// [Updated] — thêm isLikeProcessing để truyền xuống PostFooter,
/// chặn double-tap ở cả feed lẫn comment overlay.
class SocialPostCard extends StatelessWidget {
  final Post post;

  /// Trạng thái like của current user — render đúng màu icon tim
  final bool isLikedByMe;

  /// Khi true, nút like bị vô hiệu hoá — tránh race condition / double-tap
  final bool isLikeProcessing;

  final VoidCallback? onLike;
  final VoidCallback? onComment;
  final VoidCallback? onAvatarTap;
  final VoidCallback? onPostTap;
  final VoidCallback? onAuthorNameTap;
  final ValueChanged<String>? onMentionTap;
  final VoidCallback? onDelete;

  /// When true, comment button is highlighted and tap is disabled (in overlay mode)
  final bool isCommentHighlighted;

  const SocialPostCard({
    super.key,
    required this.post,
    this.isLikedByMe = false,
    this.isLikeProcessing = false,
    this.onLike,
    this.onComment,
    this.onAvatarTap,
    this.onPostTap,
    this.onAuthorNameTap,
    this.onMentionTap,
    this.onDelete,
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
          PostHeader(
            post: post,
            onAvatarTap: onAvatarTap,
            onAuthorNameTap: onAuthorNameTap,
            onMentionTap: onMentionTap,
            onDelete: onDelete,
          ),
          if (post.contentText.isNotEmpty)
            PostContent(contentText: post.contentText),
          if (post.hasMedia) PostMediaCarousel(mediaFiles: post.mediaFiles),
          PostFooter(
            post: post,
            isLikedByMe: isLikedByMe,
            isLikeProcessing: isLikeProcessing,
            onLike: onLike,
            onComment: onComment,
            isCommentHighlighted: isCommentHighlighted,
          ),
        ],
      ),
    );
  }
}