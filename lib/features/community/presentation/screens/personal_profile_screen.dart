/// [Refactored] Phase 3.1 — Split into profile sub-widgets:
///   widgets/profile/profile_hero_header.dart
///   widgets/profile/profile_stats_section.dart
///   widgets/profile/profile_buddies_section.dart
///   widgets/profile/profile_post_feed.dart
library;
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_shapes.dart';
import '../../../../data/models/user_model.dart';
import '../../../../data/models/post_model.dart';
import '../widgets/comment_overlay.dart';
import '../widgets/profile/profile_hero_header.dart';
import '../widgets/profile/profile_stats_section.dart';
import '../widgets/profile/profile_buddies_section.dart';
import '../widgets/profile/profile_post_feed.dart';

/// Personal Profile Screen
///
/// Layout 1: Hero Screen - Fullscreen cover image with user info overlay
/// Layout 2: Detailed view - Shows buddies list and user posts (revealed on scroll)
class PersonalProfileScreen extends StatefulWidget {
  final UserModel user;

  const PersonalProfileScreen({
    super.key,
    required this.user,
  });

  @override
  State<PersonalProfileScreen> createState() => _PersonalProfileScreenState();
}

class _PersonalProfileScreenState extends State<PersonalProfileScreen> {
  late UserModel _user;
  late List<UserModel> _allBuddies;

  @override
  void initState() {
    super.initState();
    _user = widget.user;
    _allBuddies = _user.allHomies;
  }

  void _toggleFollow() {
    setState(() {
      final wasFollowing = _user.isFollowedByMe;
      _user = _user.copyWith(
        isFollowedByMe: !_user.isFollowedByMe,
        followerCount: wasFollowing
            ? _user.followerCount - 1
            : _user.followerCount + 1,
      );
    });
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
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Layout 1: Hero Header
          ProfileHeroHeader(user: _user),

          // Layout 2: Detail content
          SliverToBoxAdapter(
            child: _buildDetailSection(),
          ),

          // Post feed
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

  /// Layout 2: Detail section with header, buddies, and posts
  Widget _buildDetailSection() {
    return Container(
      decoration: BoxDecoration(
        gradient: AppColors.cardGradient,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppShapes.paddingL),

          // Profile stats + follow button
          ProfileStatsSection(
            user: _user,
            onFollowToggle: _toggleFollow,
          ),

          const SizedBox(height: AppShapes.paddingL),

          // Buddies section
          if (_allBuddies.isNotEmpty) ...[
            ProfileBuddiesSection(
              displayName: _user.displayName,
              allBuddies: _allBuddies,
              onBuddyTap: _navigateToBuddyProfile,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: AppShapes.paddingM),
              child: Divider(height: 1, color: AppColors.surfaceColor),
            ),
            const SizedBox(height: AppShapes.paddingM),
          ],
        ],
      ),
    );
  }

  // [Refactored] Phase 1.5 — _limitWords & _formatCount chuyển sang
  // core/utils/formatters.dart (limitWords, formatCount).
}
