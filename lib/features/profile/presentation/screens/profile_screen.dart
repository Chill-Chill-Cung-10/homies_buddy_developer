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
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../data/models/user_model.dart';
import '../../../../data/models/pet_profile_model.dart';
import '../../../../data/models/post_model.dart';
import '../../../community/mockdata/profile_mock_data.dart';
import '../../../community/presentation/screens/personal_profile_screen.dart';
import '../../../community/presentation/widgets/comment_overlay.dart';
import '../../../community/presentation/widgets/profile/profile_buddies_section.dart';
import '../../../community/presentation/widgets/profile/profile_post_feed.dart';
import '../../../auth/presentation/screens/change_password_screen.dart';
import '../../mockdata/current_user_mock.dart';
import '../widgets/profile/user_profile_hero_header.dart';
import '../widgets/profile/user_profile_stats_section.dart';
import '../widgets/profile/profile_settings_menu.dart';

/// User Profile Screen — Tab chính hiển thị profile của user đang đăng nhập
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late UserModel _user;
  late List<dynamic> _allBuddies;

  @override
  void initState() {
    super.initState();
    _user = CurrentUserMock.currentUser;
    _allBuddies = _user.allHomies;
  }

  // ── Settings Menu Actions ──

  void _showSettingsMenu() {
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
          onTap: _handleLogout,
          iconColor: AppColors.errorRed,
          textColor: AppColors.errorRed,
        ),
      ],
    );
  }

  void _handleProfileSetting() {
    // TODO: Navigate to profile edit screen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile Setting — Coming soon')),
    );
  }

  void _handleChangePassword() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const ChangePasswordScreen(),
      ),
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

  void _handleLogout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.backgroundLight,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              // TODO: Implement actual logout logic (clear auth state, navigate to login)
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Logged out successfully')),
              );
            },
            child: Text(
              'Logout',
              style: TextStyle(color: AppColors.errorRed),
            ),
          ),
        ],
      ),
    );
  }

  // ── Navigation ──

  void _handleEditProfile() {
    // TODO: Navigate to edit profile screen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Edit Profile — Coming soon')),
    );
  }

  void _navigateToProfile(UserModel user) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PersonalProfileScreen(user: user),
      ),
    );
  }

  void _navigateToBuddyProfile(dynamic buddy) {
    if (buddy is UserModel) {
      _navigateToProfile(buddy);
    } else if (buddy is PetProfile) {
      final ownerUser =
          ProfileMockData.getUserByAuthorId(buddy.petOwner.ownerId);
      _navigateToProfile(ownerUser);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Layout 1: Hero Header với settings icon
          UserProfileHeroHeader(
            user: _user,
            onSettingsTap: _showSettingsMenu,
          ),

          // Layout 2: Detail content
          SliverToBoxAdapter(
            child: _buildDetailSection(),
          ),

          // Post feed (reuse từ community)
          ProfilePostFeed(
            posts: _user.posts,
            onLike: (index) {
              setState(() {
                final post = _user.posts[index];
                final updatedPost = post.copyWith(
                  isLikedByMe: !post.isLikedByMe,
                  reactsCount: post.isLikedByMe
                      ? post.reactsCount - 1
                      : post.reactsCount + 1,
                );
                final posts = List<Post>.from(_user.posts);
                posts[index] = updatedPost;
                _user = _user.copyWith(posts: posts);
              });
            },
            onComment: (post) {
              showCommentOverlay(context, post);
            },
          ),

          // Bottom spacing
          const SliverToBoxAdapter(
            child: SizedBox(height: 100),
          ),
        ],
      ),
    );
  }

  /// Layout 2: Detail section — stats, buddies
  Widget _buildDetailSection() {
    return Container(
      decoration: BoxDecoration(
        gradient: AppColors.cardGradient,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppSpacing.paddingL),

          // Profile stats + Edit Profile button
          UserProfileStatsSection(
            user: _user,
            onEditProfile: _handleEditProfile,
          ),

          const SizedBox(height: AppSpacing.paddingL),

          // Buddies section (reuse từ community)
          if (_allBuddies.isNotEmpty) ...[
            ProfileBuddiesSection(
              displayName: _user.displayName,
              allBuddies: _allBuddies,
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
