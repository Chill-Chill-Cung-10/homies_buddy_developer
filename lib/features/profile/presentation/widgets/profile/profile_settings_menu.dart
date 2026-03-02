/// Settings bottom sheet cho Profile Screen
/// Hiển thị các tùy chọn: Profile Setting, Change Password, Logout
library;
import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_text_styles.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/constants/app_shapes.dart';

/// Data class cho mỗi menu item
class ProfileMenuItem {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? iconColor;
  final Color? textColor;

  const ProfileMenuItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.iconColor,
    this.textColor,
  });
}

/// Settings bottom sheet — hiển thị danh sách tùy chọn profile
class ProfileSettingsMenu extends StatelessWidget {
  final List<ProfileMenuItem> menuItems;

  const ProfileSettingsMenu({
    super.key,
    required this.menuItems,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        top: AppSpacing.paddingS,
        bottom: AppSpacing.paddingL,
      ),
      decoration: const BoxDecoration(
        color: AppColors.backgroundLight,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppShapes.cardRadius),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: AppSpacing.paddingM),
            decoration: BoxDecoration(
              color: AppColors.textHint.withValues(alpha: 0.3),
              borderRadius: AppShapes.full,
            ),
          ),

          // Title
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.paddingM,
            ),
            child: Text(
              'Settings',
              style: AppTextStyles.h3.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),

          const SizedBox(height: AppSpacing.paddingM),

          // Menu items
          ...menuItems.map((item) => _buildMenuItem(context, item)),
        ],
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, ProfileMenuItem item) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pop();
        item.onTap();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.paddingL,
          vertical: AppSpacing.s,
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: (item.iconColor ?? AppColors.accentOrange)
                    .withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(AppShapes.iconRadius),
              ),
              child: Icon(
                item.icon,
                color: item.iconColor ?? AppColors.accentOrange,
                size: AppShapes.iconM,
              ),
            ),
            const SizedBox(width: AppSpacing.m),
            Expanded(
              child: Text(
                item.label,
                style: AppTextStyles.bodyLarge.copyWith(
                  fontWeight: FontWeight.w500,
                  color: item.textColor ?? AppColors.textPrimary,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: AppColors.textHint,
              size: AppShapes.iconM,
            ),
          ],
        ),
      ),
    );
  }
}

/// Helper function để show settings bottom sheet
void showProfileSettingsMenu(
  BuildContext context, {
  required List<ProfileMenuItem> menuItems,
}) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (context) => ProfileSettingsMenu(menuItems: menuItems),
  );
}
