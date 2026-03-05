/// [Refactored] Phase 3.1 — Extracted from personal_profile_screen.dart
/// Horizontal scrollable list of buddies (humans only)
library;
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_text_styles.dart';
import '../../../../../core/constants/app_shapes.dart';
import '../../../../../data/models/user_model.dart';

class ProfileBuddiesSection extends StatelessWidget {
  final String displayName;
  final List<UserModel> allBuddies;
  final ValueChanged<UserModel> onBuddyTap;

  const ProfileBuddiesSection({
    super.key,
    required this.displayName,
    required this.allBuddies,
    required this.onBuddyTap,
  });

  @override
  Widget build(BuildContext context) {
    if (allBuddies.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(bottom: AppShapes.paddingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppShapes.paddingM),
            child: Text(
              "$displayName's Homies:",
              style: AppTextStyles.bodyLarge.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: AppShapes.paddingM),
              itemCount: allBuddies.length,
              itemBuilder: (context, index) {
                final buddy = allBuddies[index];
                return _buildBuddyItem(buddy);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBuddyItem(dynamic buddy) {
    final user = buddy as UserModel;
    final name = user.fullName;
    final avatarUrl = user.avatarUrl;

    return GestureDetector(
      onTap: () => onBuddyTap(user),
      child: Container(
        width: 80,
        margin: const EdgeInsets.only(right: 12),
        child: Column(
          children: [
            ClipOval(
              child: CachedNetworkImage(
                imageUrl: avatarUrl,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  width: 60,
                  height: 60,
                  color: AppColors.surfaceColor,
                  child: const Icon(Icons.person, color: AppColors.textHint),
                ),
                errorWidget: (context, url, error) => Container(
                  width: 60,
                  height: 60,
                  color: AppColors.surfaceColor,
                  child: const Icon(Icons.person, color: AppColors.textHint),
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: AppTextStyles.bodySmall.copyWith(
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
