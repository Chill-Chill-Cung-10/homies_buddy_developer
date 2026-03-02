/// Stats section cho User Profile Screen (tab chính)
/// Hiển thị posts, followers, following count + nút Edit Profile
library;
import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_text_styles.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/constants/app_shapes.dart';
import '../../../../../core/utils/formatters.dart';
import '../../../../../data/models/user_model.dart';

class UserProfileStatsSection extends StatelessWidget {
  final UserModel user;
  final VoidCallback onEditProfile;

  const UserProfileStatsSection({
    super.key,
    required this.user,
    required this.onEditProfile,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildProfileStats(),
        const SizedBox(height: AppSpacing.paddingM),
        _buildEditProfileButton(),
      ],
    );
  }

  Widget _buildProfileStats() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.paddingL),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildStatItem(formatCount(user.posts.length), 'Posts'),
          const SizedBox(width: AppSpacing.xl),
          _buildStatItem(formatCount(user.followerCount), 'Followers'),
          const SizedBox(width: AppSpacing.xl),
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

  Widget _buildEditProfileButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.paddingL),
      child: SizedBox(
        width: double.infinity,
        child: OutlinedButton(
          onPressed: onEditProfile,
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.textPrimary,
            side: const BorderSide(color: AppColors.accentOrange),
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.s),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppShapes.buttonRadius),
            ),
          ),
          child: Text(
            'Edit Profile',
            style: AppTextStyles.buttonMedium.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
