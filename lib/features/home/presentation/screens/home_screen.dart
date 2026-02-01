import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';

/// Home Screen - Garden View (Placeholder)
/// TODO: Implement full garden view with interactive elements
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text(
          'Home - Garden View',
          style: AppTextStyles.h2,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // TODO: Navigate to settings
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.park,
              size: 80,
              color: AppColors.primaryGreen,
            ),
            const SizedBox(height: 24),
            Text(
              'Home Screen',
              style: AppTextStyles.h1,
            ),
            const SizedBox(height: 16),
            Text(
              'Garden view will be implemented here',
              style: AppTextStyles.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              '(Phase 3 - Home Screen)',
              style: AppTextStyles.caption,
            ),
          ],
        ),
      ),
    );
  }
}
