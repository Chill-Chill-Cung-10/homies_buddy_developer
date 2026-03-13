/// [Refactored] Phase 3.1 — Extracted from personal_profile_screen.dart
/// Profile stats row (posts, followers, following) and follow button
library;

import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_text_styles.dart';
import '../../../../../core/constants/app_shapes.dart';
import '../../../../../core/utils/formatters.dart';
import '../../../../../data/models/user_model.dart';

class ProfileStatsSection extends StatelessWidget {
  final UserModel user;
  final VoidCallback onFollowToggle;
  final VoidCallback? onChatTap;

  const ProfileStatsSection({
    super.key,
    required this.user,
    required this.onFollowToggle,
    this.onChatTap,
  });

  @override
  Widget build(BuildContext context) {
    final showChatButton = user.isFollowedByMe && onChatTap != null;

    return Column(
      children: [
        _buildProfileStats(),
        const SizedBox(height: AppShapes.paddingM),
        showChatButton ? _buildFollowAndChatRow() : _buildFollowButton(),
      ],
    );
  }

  Widget _buildProfileStats() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppShapes.paddingL),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildStatItem(formatCount(user.posts.length), 'Posts'),
          const SizedBox(width: 32),
          _buildStatItem(formatCount(user.followerCount), 'Followers'),
          const SizedBox(width: 32),
          _buildStatItem(formatCount(user.followingCount), 'Following'),
        ],
      ),
    );
  }

  Widget _buildStatItem(String count, String label) {
    return Column(
      children: [
        Text(
          count,
          style: AppTextStyles.h3.copyWith(
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildFollowButton() {
    final isFollowing = user.isFollowedByMe;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppShapes.paddingL),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: onFollowToggle,
          style: ElevatedButton.styleFrom(
            backgroundColor: isFollowing
                ? AppColors.surfaceColor
                : AppColors.accentOrange,
            foregroundColor: isFollowing ? AppColors.textPrimary : Colors.white,
            elevation: 0,
            padding: const EdgeInsets.symmetric(vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppShapes.buttonRadius),
              side: isFollowing
                  ? const BorderSide(color: AppColors.accentOrange)
                  : BorderSide.none,
            ),
          ),
          child: Text(
            isFollowing ? 'Following' : 'Follow',
            style: AppTextStyles.buttonMedium.copyWith(
              color: isFollowing ? AppColors.textPrimary : Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFollowAndChatRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppShapes.paddingL),
      child: Row(
        children: [
          Expanded(child: _buildFollowButton()),
          const SizedBox(width: AppShapes.paddingS),
          SizedBox(
            width: 48,
            height: 48,
            child: ElevatedButton(
              onPressed: onChatTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accentOrange,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppShapes.buttonRadius),
                ),
              ),
              child: const Icon(Icons.chat_bubble_rounded, size: 22),
            ),
          ),
        ],
      ),
    );
  }
}
