/// [Demo Launcher] — Main entry point for all demos
/// 
/// Run with: flutter run lib/example/demo_launcher.dart
library;

import 'package:flutter/material.dart';
import 'package:homies_buddy_developer/core/constants/app_colors.dart';
import 'package:homies_buddy_developer/core/constants/app_text_styles.dart';
import 'package:homies_buddy_developer/core/constants/app_spacing.dart';
import 'loading_demo_screen.dart';
import 'data_fetching_demo_screen.dart';

void main() {
  runApp(const DemoLauncherApp());
}

class DemoLauncherApp extends StatelessWidget {
  const DemoLauncherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Homies Buddy - Demo Launcher',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.light(
          primary: AppColors.primaryPeach,
          secondary: AppColors.primaryGreen,
          surface: AppColors.backgroundLight,
        ),
      ),
      home: const DemoLauncherScreen(),
    );
  }
}

class DemoLauncherScreen extends StatelessWidget {
  const DemoLauncherScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: AppColors.primaryPeach,
        elevation: 0,
        title: Text(
          'Homies Buddy Demos',
          style: AppTextStyles.h2.copyWith(color: AppColors.textPrimary),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.m),
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(AppSpacing.l),
            margin: const EdgeInsets.only(bottom: AppSpacing.l),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primaryPeach,
                  AppColors.primaryGreen.withValues(alpha: 0.3),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: AppColors.accentOrange.withValues(alpha: 0.2),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                Icon(
                  Icons.apps,
                  size: 48,
                  color: AppColors.textPrimary,
                ),
                const SizedBox(height: AppSpacing.m),
                Text(
                  'Demo Collection',
                  style: AppTextStyles.h2.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Explore all demo screens',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),

          // Loading Demos Section
          _buildSectionHeader(
            'Loading States',
            Icons.cached,
            AppColors.primaryGreen,
          ),
          _buildDemoCard(
            context,
            title: 'Loading Widgets Demo',
            description: 'All loading states: shimmer, indicators, overlays, and screens',
            icon: Icons.hourglass_empty,
            color: AppColors.primaryGreen,
            onTap: () => _navigateToDemo(context, const LoadingDemoScreen()),
          ),
          _buildDemoCard(
            context,
            title: 'Data Fetching Demo',
            description: 'Realistic example: initial load, refresh, pagination',
            icon: Icons.cloud_download,
            color: AppColors.accentOrange,
            onTap: () => _navigateToDemo(context, const DataFetchingDemoScreen()),
          ),
          const SizedBox(height: AppSpacing.xl),

          // Coming Soon Section
          _buildSectionHeader(
            'Coming Soon',
            Icons.upcoming,
            AppColors.pastelBlue,
          ),
          _buildPlaceholderCard(
            'Auth Screens Demo',
            'Login, Register, Password screens',
            Icons.lock,
          ),
          _buildPlaceholderCard(
            'Community Features Demo',
            'Posts, Comments, Reactions',
            Icons.people,
          ),
          _buildPlaceholderCard(
            'Messenger Demo',
            'Chat interface and real-time messaging',
            Icons.chat,
          ),
          _buildPlaceholderCard(
            'Profile Demo',
            'User profiles and settings',
            Icons.person,
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.m),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.s),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 20, color: color),
          ),
          const SizedBox(width: AppSpacing.m),
          Text(
            title,
            style: AppTextStyles.h3.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDemoCard(
    BuildContext context, {
    required String title,
    required String description,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.m),
      decoration: BoxDecoration(
        color: AppColors.backgroundPost,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.m),
            child: Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: color, size: 28),
                ),
                const SizedBox(width: AppSpacing.m),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: AppTextStyles.bodyLarge.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        description,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: AppColors.textHint,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPlaceholderCard(String title, String description, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.m),
      padding: const EdgeInsets.all(AppSpacing.m),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.textHint.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: AppColors.textHint.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: AppColors.textHint,
              size: 28,
            ),
          ),
          const SizedBox(width: AppSpacing.m),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textHint,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  description,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textHint,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.m,
              vertical: AppSpacing.xs,
            ),
            decoration: BoxDecoration(
              color: AppColors.pastelYellow.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              'Soon',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToDemo(BuildContext context, Widget screen) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => screen),
    );
  }
}
