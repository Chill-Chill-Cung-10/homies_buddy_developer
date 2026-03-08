/// User Profile Screen (Tab 4) — Màn hình profile của user hiện tại
///
/// Layout giống PersonalProfileScreen nhưng:
///   - Dùng SpinningNavButton thay vì nút back (vì là tab chính)
///   - Có icon settings ở góc trên bên phải
///   - Không có nút Follow (profile của chính mình) → thay bằng Edit Profile
///   - Settings menu: Profile Setting, Change Password, Logout
///
/// Sub-widgets:
///   widgets/profile/user_profile_hero_header.dart
///   widgets/profile/user_profile_stats_section.dart
///   widgets/profile/profile_settings_menu.dart
///   (Reuse) community/widgets/profile/profile_buddies_section.dart
///   (Reuse) community/widgets/profile/profile_post_feed.dart
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../data/models/user_model.dart';
import '../../../community/presentation/screens/personal_profile_screen.dart';
import '../../../community/presentation/widgets/comment_overlay.dart';
import '../../../community/presentation/widgets/profile/profile_buddies_section.dart';
import '../../../community/presentation/widgets/profile/profile_post_feed.dart';
import '../../../auth/presentation/screens/change_password_screen.dart';
import '../providers/profile_providers.dart';
import '../widgets/profile/user_profile_hero_header.dart';
import '../widgets/profile/user_profile_stats_section.dart';
import '../widgets/profile/profile_settings_menu.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import 'profile_edit_screen.dart';

/// User Profile Screen — Tab chính hiển thị profile của user đang đăng nhập
class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {

  @override
  void initState() {
    super.initState();
    // Profile will be loaded automatically by the provider
  }

  // ── Settings Menu Actions ──

  void _showSettingsMenu() {
    // CRITICAL: Store ref and context BEFORE opening menu
    final authActions = ref.read(authActionsProvider);
    final navigator = Navigator.of(context);
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    
    showProfileSettingsMenu(
      context,
      menuItems: [
        ProfileMenuItem(
          icon: Icons.person_outline,
          label: 'Profile Setting',
          onTap: _handleProfileSetting,
        ),
        ProfileMenuItem(
          icon: Icons.lock_outline,
          label: 'Change Password',
          onTap: _handleChangePassword,
        ),
        ProfileMenuItem(
          icon: Icons.notifications_outlined,
          label: 'Notifications',
          onTap: _handleNotifications,
        ),
        ProfileMenuItem(
          icon: Icons.help_outline,
          label: 'Help & Support',
          onTap: _handleHelpSupport,
        ),
        ProfileMenuItem(
          icon: Icons.logout,
          label: 'Logout',
          onTap: () => _handleLogoutWithStoredRef(
            authActions,
            navigator,
            scaffoldMessenger,
          ),
          iconColor: AppColors.errorRed,
          textColor: AppColors.errorRed,
        ),
      ],
    );
  }

  void _handleProfileSetting() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const ProfileEditScreen()),
    );
  }

  void _handleChangePassword() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const ChangePasswordScreen()),
    );
  }

  void _handleNotifications() {
    // TODO: Navigate to notification settings
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Notification Settings — Coming soon')),
    );
  }

  void _handleHelpSupport() {
    // TODO: Navigate to help & support
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Help & Support — Coming soon')),
    );
  }

  void _handleLogoutWithStoredRef(
    AuthActions authActions,
    NavigatorState navigator,
    ScaffoldMessengerState scaffoldMessenger,
  ) {
    showDialog(
      context: navigator.context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.backgroundLight,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(dialogContext).pop();
              
              try {
                await authActions.signOut();
                scaffoldMessenger.showSnackBar(
                  const SnackBar(
                    content: Text('Logged out successfully'),
                    backgroundColor: AppColors.successGreen,
                  ),
                );
              } catch (e) {
                scaffoldMessenger.showSnackBar(
                  SnackBar(
                    content: Text('Logout failed: $e'),
                    backgroundColor: AppColors.errorRed,
                  ),
                );
              }
            },
            child: Text('Logout', style: TextStyle(color: AppColors.errorRed)),
          ),
        ],
      ),
    );
  }

  // ── Navigation ──

  void _handleEditProfile() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const ProfileEditScreen()),
    );
  }

  void _navigateToProfile(UserModel user) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PersonalProfileScreen(user: user),
      ),
    );
  }

  void _navigateToBuddyProfile(UserModel buddy) {
    _navigateToProfile(buddy);
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileStateProvider);
    final user = profileState.user;
    final isLoading = profileState.isLoading;
    
    // Show loading state
    if (isLoading) {
      return Scaffold(
        backgroundColor: AppColors.backgroundLight,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: AppColors.primaryPeach),
              const SizedBox(height: 16),
              Text(
                'Loading profile...',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      );
    }
    
    // Show error/empty state
    if (user == null) {
      return Scaffold(
        backgroundColor: AppColors.backgroundLight,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.person_off_outlined,
                size: 64,
                color: AppColors.textSecondary,
              ),
              const SizedBox(height: 16),
              Text(
                'Unable to load profile',
                style: AppTextStyles.h3.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                profileState.errorMessage ?? 'Please try again',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  ref.read(profileStateProvider.notifier).refresh();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryPeach,
                ),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    final allBuddies = user.allHomies;

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () => ref.read(profileStateProvider.notifier).refresh(),
        child: CustomScrollView(
          slivers: [
            // Layout 1: Hero Header với settings icon
            UserProfileHeroHeader(user: user, onSettingsTap: _showSettingsMenu),

            // Layout 2: Detail content
            SliverToBoxAdapter(child: _buildDetailSection(user, allBuddies)),

            // Post feed (reuse từ community)
            ProfilePostFeed(
              posts: user.posts,
              onLike: (index) {
                // TODO: Implement like via API
              },
              onComment: (post) {
                showCommentOverlay(context, post);
              },
            ),

            // Bottom spacing
            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ),
      ),
    );
  }

  /// Layout 2: Detail section — stats, buddies
  Widget _buildDetailSection(UserModel user, List<UserModel> allBuddies) {
    return Container(
      decoration: BoxDecoration(gradient: AppColors.cardGradient),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppSpacing.paddingL),

          // Profile stats + Edit Profile button
          UserProfileStatsSection(
            user: user,
            onEditProfile: _handleEditProfile,
          ),

          const SizedBox(height: AppSpacing.paddingL),

          // Buddies section (reuse từ community)
          if (allBuddies.isNotEmpty) ...[
            ProfileBuddiesSection(
              displayName: user.displayName,
              allBuddies: allBuddies,
              onBuddyTap: _navigateToBuddyProfile,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.paddingM),
              child: Divider(height: 1, color: AppColors.surfaceColor),
            ),
            const SizedBox(height: AppSpacing.paddingM),
          ],
        ],
      ),
    );
  }
}
