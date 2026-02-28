import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/widgets/spinning_nav_button.dart';

/// Placeholder Profile Screen (Tab 4)
///
/// Will be replaced with a full profile implementation later.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        child: Column(
          children: [
            // ─── Top bar with SpinningNavButton ───
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
              child: Row(
                children: [
                  const SpinningNavButton(
                    iconColor: AppColors.textPrimary,
                  ),
                  const SizedBox(width: 12),
                  Text('My Profile', style: AppTextStyles.h2),
                  const Spacer(),
                ],
              ),
            ),

            // ─── Content ───
            Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: AppColors.primaryPeach.withOpacity(0.5),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.person,
                        size: 56,
                        color: AppColors.iconColor,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Profile Coming Soon',
                      style: AppTextStyles.h2.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Your personal settings will be here.',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
