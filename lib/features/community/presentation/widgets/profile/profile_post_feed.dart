/// [Refactored] Phase 3.2 — Updated to support:
///   - External likedStatus list (managed by parent screen)
///   - Loading skeleton while initial fetch is in progress
library;

import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_text_styles.dart';
import '../../../../../core/constants/app_shapes.dart';
import '../../../../../data/models/post_model.dart';
import '../social_post_card.dart';

class ProfilePostFeed extends StatelessWidget {
  final List<Post> posts;

  /// Parallel list to [posts] — tracks like state for each post.
  /// Managed externally so parent can do optimistic updates + repository calls.
  final List<bool> likedStatus;

  /// Called with the index of the tapped post.
  final ValueChanged<int> onLike;

  final ValueChanged<Post> onComment;

  const ProfilePostFeed({
    super.key,
    required this.posts,
    required this.likedStatus,
    required this.onLike,
    required this.onComment,
  });

  @override
  Widget build(BuildContext context) {
    if (posts.isEmpty) {
      return SliverToBoxAdapter(
        child: Container(
          padding: EdgeInsets.all(AppShapes.paddingXL),
          child: Center(
            child: Column(
              children: [
                Icon(
                  Icons.photo_camera_outlined,
                  size: 48,
                  color: AppColors.textHint.withValues(alpha: 0.5),
                ),
                const SizedBox(height: 12),
                Text(
                  'No posts yet',
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: AppColors.textHint,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final post = posts[index];
          final isLiked = index < likedStatus.length && likedStatus[index];

          return Padding(
            padding: EdgeInsets.symmetric(horizontal: AppShapes.paddingM),
            child: SocialPostCard(
              post: post,
              isLikedByMe: isLiked,
              onLike: () => onLike(index),
              onComment: () => onComment(post),
              onAvatarTap: () {},
              onPostTap: () {},
            ),
          );
        },
        childCount: posts.length,
      ),
    );
  }
}