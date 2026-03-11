/// [Refactored] Phase 3.3 — Extracted from comment_overlay.dart
/// [Updated] — isLikedByMe + isLikeProcessing để truyền đúng trạng thái xuống SocialPostCard
library;

import 'package:flutter/material.dart';
import '../../../../../core/constants/app_shapes.dart';
import '../../../../../data/models/post_model.dart';
import '../social_post_card.dart';

class CommentPostPreview extends StatelessWidget {
  final Post post;

  /// Trạng thái like của current user — để PostFooter render đúng màu icon tim
  final bool isLikedByMe;

  /// Khi true, nút like bị vô hiệu hoá để tránh double-tap
  final bool isLikeProcessing;

  final VoidCallback? onLike;
  final VoidCallback? onAvatarTap;

  const CommentPostPreview({
    super.key,
    required this.post,
    required this.isLikedByMe,
    this.isLikeProcessing = false,
    this.onLike,
    this.onAvatarTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppShapes.paddingM,
        vertical: AppShapes.paddingS,
      ),
      child: SocialPostCard(
        post: post,
        isLikedByMe: isLikedByMe,
        isLikeProcessing: isLikeProcessing,
        isCommentHighlighted: true,
        onLike: isLikeProcessing ? null : onLike,
        onComment: null, // Disabled in comment overlay
        onAvatarTap: onAvatarTap,
        onPostTap: null, // Disabled in overlay
      ),
    );
  }
}