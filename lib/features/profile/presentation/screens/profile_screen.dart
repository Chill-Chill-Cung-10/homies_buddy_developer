import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';

/// Profile/Settings Screen - Personal Settings (Placeholder)
/// TODO: Implement profile header and settings list
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text(
          'Personal Settings',
          style: AppTextStyles.h2,
        ),
        backgroundColor: AppColors.backgroundLight,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.person,
              size: 80,
              color: AppColors.buttonPrimary,
            ),
            const SizedBox(height: 24),
            Text(
              'Profile Screen',
              style: AppTextStyles.h1,
            ),
            const SizedBox(height: 16),
            Text(
              'Profile and settings will be implemented here',
              style: AppTextStyles.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              '(Phase 6 - Profile/Settings Screen)',
              style: AppTextStyles.caption,
            ),
          ],
        ),
      ),
    );
  }
}
