import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';

/// Community Screen - Community Neighbors (Placeholder)
/// TODO: Implement community feed with cards
class CommunityScreen extends StatelessWidget {
  const CommunityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text(
          'Community Neighbors',
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
              Icons.people,
              size: 80,
              color: AppColors.primaryPink,
            ),
            const SizedBox(height: 24),
            Text(
              'Community Screen',
              style: AppTextStyles.h1,
            ),
            const SizedBox(height: 16),
            Text(
              'Community feed will be implemented here',
              style: AppTextStyles.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              '(Phase 4 - Community Screen)',
              style: AppTextStyles.caption,
            ),
          ],
        ),
      ),
    );
  }
}
