import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/constants/app_shapes.dart';
import '../../../../data/models/user_model.dart';
import '../../../../data/models/pet_profile_model.dart';
import '../../../../data/models/post_model.dart';
import '../../mockdata/profile_mock_data.dart';
import '../widgets/social_post_card.dart';
import '../widgets/comment_overlay.dart';

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
  late List<dynamic> _allBuddies;

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

  void _navigateToBuddyProfile(dynamic buddy) {
    if (buddy is UserModel) {
      _navigateToProfile(buddy);
    } else if (buddy is PetProfile) {
      // For pet profiles, navigate to the pet owner's profile
      final ownerUser = ProfileMockData.getUserByAuthorId(buddy.petOwner.ownerId);
      _navigateToProfile(ownerUser);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Layout 1: Hero Header
          _buildHeroHeader(context),

          // Layout 2: Detail content
          SliverToBoxAdapter(
            child: _buildDetailSection(),
          ),

          // Post feed
          _buildPostFeed(),

          // Bottom spacing  
          const SliverToBoxAdapter(
            child: SizedBox(height: 100),
          ),
        ],
      ),
    );
  }

  /// Layout 1: Hero Header - Fullscreen cover with user info
  Widget _buildHeroHeader(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return SliverAppBar(
      expandedHeight: screenHeight * 0.92,
      pinned: true,
      stretch: true,
      backgroundColor: AppColors.primaryPeach,
      foregroundColor: AppColors.textPrimary,
      iconTheme: const IconThemeData(color: Colors.white),
      leading: _buildBackButton(),
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.parallax,
        stretchModes: const [
          StretchMode.zoomBackground,
          StretchMode.fadeTitle,
        ],
        background: Stack(
          fit: StackFit.expand,
          children: [
            // Cover Image
            _buildCoverImage(),

            // Gradient overlay at bottom
            _buildGradientOverlay(),

            // User info content at bottom
            _buildHeroContent(context),

            // Scroll indicator
            _buildScrollIndicator(),
          ],
        ),
      ),
      // Collapsed title
      title: Text(
        _user.displayName,
        style: AppTextStyles.h3.copyWith(
          color: AppColors.textBlackContrast,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _buildBackButton() {
    return Container(
      margin: const EdgeInsets.all(4),
      child: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white, size: 24),
        onPressed: () => Navigator.of(context).pop(),
      ),
    );
  }

  Widget _buildCoverImage() {
    return CachedNetworkImage(
      imageUrl: _user.coverUrl ?? _user.avatarUrl,
      fit: BoxFit.cover,
      placeholder: (context, url) => Container(
        color: AppColors.surfaceColor,
        child: const Center(
          child: CircularProgressIndicator(color: AppColors.accentOrange),
        ),
      ),
      errorWidget: (context, url, error) => Container(
        color: AppColors.surfaceColor,
        child: const Icon(Icons.broken_image, size: 48),
      ),
    );
  }

  Widget _buildGradientOverlay() {
    return Stack(
      children: [
        // Top gradient overlay (from top down)
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: 150,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.5),
                  Colors.black.withValues(alpha: 0.2),
                  Colors.transparent,
                ],
                stops: const [0.0, 0.6, 1.0],
              ),
            ),
          ),
        ),
        // Bottom gradient overlay
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          height: 350,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.3),
                  Colors.black.withValues(alpha: 0.7),
                ],
                stops: const [0.0, 0.4, 1.0],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeroContent(BuildContext context) {
    return Positioned(
      bottom: 40,
      left: AppShapes.paddingM,
      right: AppShapes.paddingM,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Avatar row: avatar + name column + follow button
          Row(
            children: [
              // Avatar
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.accentOrange, width: 2),
                ),
                child: ClipOval(
                  child: CachedNetworkImage(
                    imageUrl: _user.avatarUrl,
                    width: 48,
                    height: 48,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      width: 48,
                      height: 48,
                      color: AppColors.surfaceColor,
                    ),
                    errorWidget: (context, url, error) => Container(
                      width: 48,
                      height: 48,
                      color: AppColors.surfaceColor,
                      child: const Icon(Icons.person, size: 24),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // Username with @ symbol
              Expanded(
                child: Text(
                  '@${_user.username}',
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    fontSize: 17,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Headline (title quote) - large text, limit 10 words
          if (_user.hasFeaturedHeader)
            Text(
              _limitWords(_user.headline!, 10),
              style: const TextStyle(
                fontSize: 42,
                fontWeight: FontWeight.w900,
                color: Colors.white,
                height: 1.0,
                letterSpacing: -1,
              ),
            ),

          if (_user.hasFeaturedHeader) const SizedBox(height: 12),

          // Bio (subtitle quote) - limit 40 words
          if (_user.bio != null && _user.bio!.isNotEmpty)
            Text(
              _limitWords(_user.bio!, 40),
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Colors.white.withValues(alpha: 0.9),
                height: 1.4,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildScrollIndicator() {
    return Positioned(
      bottom: 12,
      left: 0,
      right: 0,
      child: Center(
        child: Icon(
          Icons.keyboard_double_arrow_up,
          color: Colors.white.withValues(alpha: 0.7),
          size: 28,
        ),
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

          // Profile stats row
          _buildProfileStats(),

          const SizedBox(height: AppShapes.paddingM),

          // Follow button
          _buildFollowButton(),

          const SizedBox(height: AppShapes.paddingL),

          // Buddies section
          if (_allBuddies.isNotEmpty) ...[
            _buildBuddiesSection(),
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

  Widget _buildProfileStats() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppShapes.paddingL),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildStatItem(_formatCount(_user.posts.length), 'Posts'),
          const SizedBox(width: 32),
          _buildStatItem(_formatCount(_user.followerCount), 'Followers'),
          const SizedBox(width: 32),
          _buildStatItem(_formatCount(_user.followingCount), 'Following'),
        ],
      ),
    );
  }

  Widget _buildStatItem(String count, String label) {
    return Column(
      children: [
        Text(
          count,
          style: AppTextStyles.h3.copyWith(
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildFollowButton() {
    final isFollowing = _user.isFollowedByMe;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppShapes.paddingL),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: _toggleFollow,
          style: ElevatedButton.styleFrom(
            backgroundColor:
                isFollowing ? AppColors.surfaceColor : AppColors.accentOrange,
            foregroundColor:
                isFollowing ? AppColors.textPrimary : Colors.white,
            elevation: 0,
            padding: const EdgeInsets.symmetric(vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppShapes.buttonRadius),
              side: isFollowing
                  ? const BorderSide(color: AppColors.accentOrange)
                  : BorderSide.none,
            ),
          ),
          child: Text(
            isFollowing ? 'Following' : 'Follow',
            style: AppTextStyles.buttonMedium.copyWith(
              color: isFollowing ? AppColors.textPrimary : Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  /// Buddies horizontal list
  Widget _buildBuddiesSection() {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppShapes.paddingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppShapes.paddingM),
            child: Text(
              "${_user.displayName}'s Homies:",
              style: AppTextStyles.bodyLarge.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: AppShapes.paddingM),
              itemCount: _allBuddies.length,
              itemBuilder: (context, index) {
                final buddy = _allBuddies[index];
                return _buildBuddyItem(buddy);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBuddyItem(dynamic buddy) {
    String name;
    String avatarUrl;

    if (buddy is UserModel) {
      name = buddy.fullName;
      avatarUrl = buddy.avatarUrl;
    } else if (buddy is PetProfile) {
      name = buddy.petName;
      avatarUrl = buddy.petAvatar;
    } else {
      return const SizedBox.shrink();
    }

    return GestureDetector(
      onTap: () => _navigateToBuddyProfile(buddy),
      child: Container(
        width: 80,
        margin: const EdgeInsets.only(right: 12),
        child: Column(
          children: [
            // Avatar
            ClipOval(
              child: CachedNetworkImage(
                imageUrl: avatarUrl,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  width: 60,
                  height: 60,
                  color: AppColors.surfaceColor,
                  child: const Icon(Icons.person, color: AppColors.textHint),
                ),
                errorWidget: (context, url, error) => Container(
                  width: 60,
                  height: 60,
                  color: AppColors.surfaceColor,
                  child: const Icon(Icons.person, color: AppColors.textHint),
                ),
              ),
            ),
            const SizedBox(height: 6),
            // Name
            Text(
              name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: AppTextStyles.bodySmall.copyWith(
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Post feed using SocialPostCard
  Widget _buildPostFeed() {
    if (_user.posts.isEmpty) {
      return SliverToBoxAdapter(
        child: Container(
          padding: EdgeInsets.all(AppShapes.paddingXL),
          child: Center(
            child: Column(
              children: [
                Icon(
                  Icons.photo_camera_outlined,
                  size: 48,
                  color: AppColors.textHint.withValues(alpha: 0.5),
                ),
                const SizedBox(height: 12),
                Text(
                  'No posts yet',
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: AppColors.textHint,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final post = _user.posts[index];
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: AppShapes.paddingM),
            child: SocialPostCard(
              post: post,
              onLike: () {
                setState(() {
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
              onComment: () {
                showCommentOverlay(context, post);
              },
              onAvatarTap: () {
                // Already on this user's profile, no action needed
              },
              onPostTap: () {
                // TODO: Navigate to post detail
              },
            ),
          );
        },
        childCount: _user.posts.length,
      ),
    );
  }

  /// Limit text to N words
  String _limitWords(String text, int maxWords) {
    final words = text.split(RegExp(r'\s+'));
    if (words.length <= maxWords) return text;
    return '${words.take(maxWords).join(' ')}...';
  }

  /// Format count for display
  String _formatCount(int count) {
    if (count >= 1000000) {
      return '${(count / 1000000).toStringAsFixed(1)}M';
    } else if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}K';
    }
    return count.toString();
  }
}
