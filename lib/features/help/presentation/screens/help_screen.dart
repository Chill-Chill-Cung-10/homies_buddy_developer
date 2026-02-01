import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';

/// Help Screen - Ask For Help (Placeholder)
/// TODO: Implement help cards and mascot
class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // TODO: Handle back navigation if needed
          },
        ),
        title: const Text(
          'Ask For Help',
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
              Icons.help_outline,
              size: 80,
              color: AppColors.accentOrange,
            ),
            const SizedBox(height: 24),
            Text(
              'Help Screen',
              style: AppTextStyles.h1,
            ),
            const SizedBox(height: 16),
            Text(
              'Help cards and mascot will be implemented here',
              style: AppTextStyles.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              '(Phase 5 - Help Screen)',
              style: AppTextStyles.caption,
            ),
          ],
        ),
      ),
    );
  }
}
