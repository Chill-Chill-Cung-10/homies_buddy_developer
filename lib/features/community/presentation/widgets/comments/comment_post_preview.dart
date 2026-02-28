/// [Refactored] Phase 3.3 — Extracted from comment_overlay.dart
/// Post preview section — wraps SocialPostCard with comment-highlighted mode
library;
import 'package:flutter/material.dart';
import '../../../../../core/constants/app_shapes.dart';
import '../../../../../data/models/post_model.dart';
import '../social_post_card.dart';

class CommentPostPreview extends StatelessWidget {
  final Post post;
  final VoidCallback? onLike;
  final VoidCallback? onAvatarTap;

  const CommentPostPreview({
    super.key,
    required this.post,
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
        isCommentHighlighted: true,
        onLike: onLike,
        onComment: null, // Disabled in comment overlay
        onAvatarTap: onAvatarTap,
        onPostTap: null, // Disabled in overlay
      ),
    );
  }
}
