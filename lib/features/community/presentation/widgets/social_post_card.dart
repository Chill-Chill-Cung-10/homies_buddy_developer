import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/constants/app_shapes.dart';
import '../../../../data/models/post_model.dart';
import '../../../../data/models/media_file_model.dart';

/// Social Post Card - Reusable widget cho community feed item
/// 
/// Hiển thị một bài post với header, content, media, và footer interactions
class SocialPostCard extends StatefulWidget {
  final Post post;
  final VoidCallback? onLike;
  final VoidCallback? onComment;
  final VoidCallback? onAvatarTap;
  final VoidCallback? onPostTap;

  const SocialPostCard({
    super.key,
    required this.post,
    this.onLike,
    this.onComment,
    this.onAvatarTap,
    this.onPostTap,
  });

  @override
  State<SocialPostCard> createState() => _SocialPostCardState();
}

class _SocialPostCardState extends State<SocialPostCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _heartAnimationController;
  late Animation<double> _heartScaleAnimation;
  int _currentMediaIndex = 0;

  @override
  void initState() {
    super.initState();
    _heartAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _heartScaleAnimation = Tween<double>(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(
        parent: _heartAnimationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _heartAnimationController.dispose();
    super.dispose();
  }

  void _handleLike() {
    if (widget.post.isLikedByMe) {
      _heartAnimationController.reverse();
    } else {
      _heartAnimationController.forward().then((_) {
        _heartAnimationController.reverse();
      });
    }
    widget.onLike?.call();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppShapes.paddingM),
      decoration: BoxDecoration(
        color: AppColors.backgroundPost,
        borderRadius: AppShapes.card,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          _buildHeader(),

          // Content Text
          if (widget.post.contentText.isNotEmpty) _buildContent(),

          // Media (Image/Video/Album)
          if (widget.post.hasMedia) _buildMedia(),

          // Footer (Reactions & Comments)
          _buildFooter(),
        ],
      ),
    );
  }

  /// Header: Avatar, Author Name, Time
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(AppShapes.paddingM),
      child: Row(
        children: [
          // Avatar
          GestureDetector(
            onTap: widget.onAvatarTap,
            child: ClipOval(
              child: CachedNetworkImage(
                imageUrl: widget.post.authorAvatar,
                width: 40,
                height: 40,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  width: 40,
                  height: 40,
                  color: AppColors.surfaceColor,
                  child: const Icon(
                    Icons.person,
                    size: 20,
                    color: AppColors.textHint,
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  width: 40,
                  height: 40,
                  color: AppColors.surfaceColor,
                  child: const Icon(
                    Icons.person,
                    size: 20,
                    color: AppColors.textHint,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Author Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Author Name with mentions
                _buildAuthorNameWithMentions(),
                const SizedBox(height: 2),

                // Time and Privacy Icon
                Row(
                  children: [
                    Text(
                      widget.post.timeAgo,
                      style: AppTextStyles.bodySmall.copyWith(
                        fontSize: 11,
                        color: AppColors.textHint,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      _getPrivacyIcon(),
                      size: 11,
                      color: AppColors.textHint,
                    ),
                  ],
                ),
              ],
            ),
          ),

          // More Options Button
          IconButton(
            icon: SvgPicture.asset(
              'assets/images/icons/three_dots.svg',
              width: 20,
              height: 20,
              colorFilter: const ColorFilter.mode(
                AppColors.iconColor,
                BlendMode.srcIn,
              ),
            ),
            onPressed: () {
              // TODO: Show more options
            },
          ),
        ],
      ),
    );
  }

  /// Build Author Name with mentions if available
  Widget _buildAuthorNameWithMentions() {
    if (widget.post.hasMentions) {
      final mentionsText = widget.post.mentions.join(', ');
      return Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: widget.post.authorName,
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            TextSpan(
              text: ' cùng với ',
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.textBlack,
              ),
            ),
            TextSpan(
              text: mentionsText,
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      );
    }
    
    return Text(
      widget.post.authorName,
      style: AppTextStyles.bodyLarge.copyWith(
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
    );
  }

  /// Content: Text description
  Widget _buildContent() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppShapes.paddingM,
        vertical: AppShapes.paddingXS,
      ),
      child: Text(
        widget.post.contentText,
        style: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.textPrimary,
          height: 1.3,
        ),
      ),
    );
  }

  /// Media: Image/Video/Album carousel
  Widget _buildMedia() {
    final mediaFiles = widget.post.mediaFiles;

    if (mediaFiles.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppShapes.paddingS,
        vertical: AppShapes.paddingS,
      ),
      child: mediaFiles.length == 1
          ? _buildSingleMedia(mediaFiles.first)
          : _buildMediaCarousel(mediaFiles),
    );
  }

  Widget _buildSingleMedia(MediaFile media) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: AppShapes.paddingS),
      child: AspectRatio(
        aspectRatio: media.mediaAspectRatio,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppShapes.iconRadius),
          child: _buildMediaContent(media),
        ),
      ),
    );
  }

  Widget _buildMediaCarousel(List<MediaFile> mediaFiles) {
    return Column(
      children: [
        CarouselSlider(
          options: CarouselOptions(
            aspectRatio: mediaFiles[_currentMediaIndex].mediaAspectRatio,
            viewportFraction: 1.0,
            enableInfiniteScroll: false,
            onPageChanged: (index, reason) {
              setState(() {
                _currentMediaIndex = index;
              });
            },
          ),
          items: mediaFiles.map((media) {
            return Builder(
              builder: (BuildContext context) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(AppShapes.iconRadius),
                  child: _buildMediaContent(media),
                );
              },
            );
          }).toList(),
        ),

        // Carousel Indicators
        if (mediaFiles.length > 1) _buildCarouselIndicators(mediaFiles.length),
      ],
    );
  }

  Widget _buildMediaContent(MediaFile media) {
    if (media.isVideo) {
      // Video thumbnail with play button
      return Stack(
        fit: StackFit.expand,
        children: [
          CachedNetworkImage(
            imageUrl: media.thumbnailUrl ?? media.mediaUrl,
            fit: BoxFit.cover,
            placeholder: (context, url) => Container(
              color: AppColors.surfaceColor,
              child: const Center(
                child: CircularProgressIndicator(
                  color: AppColors.accentOrange,
                ),
              ),
            ),
            errorWidget: (context, url, error) => Container(
              color: AppColors.surfaceColor,
              child: const Icon(Icons.error),
            ),
          ),
          // Play button overlay
          Center(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.6),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.play_arrow,
                color: Colors.white,
                size: 32,
              ),
            ),
          ),
          // Duration badge
          if (media.durationSeconds != null)
            Positioned(
              bottom: 8,
              right: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.7),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  media.durationString,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
        ],
      );
    } else {
      // Image
      return CachedNetworkImage(
        imageUrl: media.mediaUrl,
        fit: BoxFit.cover,
        placeholder: (context, url) => Container(
          color: AppColors.surfaceColor,
          child: const Center(
            child: CircularProgressIndicator(
              color: AppColors.accentOrange,
            ),
          ),
        ),
        errorWidget: (context, url, error) => Container(
          color: AppColors.surfaceColor,
          child: const Icon(Icons.error),
        ),
      );
    }
  }

  Widget _buildCarouselIndicators(int count) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppShapes.paddingS),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(count, (index) {
          return Container(
            width: 6,
            height: 6,
            margin: const EdgeInsets.symmetric(horizontal: 3),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _currentMediaIndex == index
                  ? AppColors.accentOrange
                  : AppColors.textHint.withValues(alpha: 0.3),
            ),
          );
        }),
      ),
    );
  }

  /// Footer: Reactions & Comments
  Widget _buildFooter() {
    return Padding(
      padding: const EdgeInsets.all(AppShapes.paddingM),
      child: Row(
        children: [
          // Heart/Like Button with Animation
          GestureDetector(
            onTap: _handleLike,
            child: Row(
              children: [
                ScaleTransition(
                  scale: _heartScaleAnimation,
                  child: SvgPicture.asset(
                    widget.post.isLikedByMe
                        ? 'assets/images/icons/heart_reactions_on.svg'
                        : 'assets/images/icons/heart_reactions_off.svg',
                    width: 24,
                    height: 24,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  _formatCount(widget.post.reactsCount),
                  style: const TextStyle(
                    fontFamily: 'Norican',
                    fontSize: 16,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 24),

          // Comment Button
          GestureDetector(
            onTap: widget.onComment,
            child: Row(
              children: [
                SvgPicture.asset(
                  'assets/images/icons/comments.svg',
                  width: 24,
                  height: 24,
                  colorFilter: const ColorFilter.mode(
                    AppColors.iconColor,
                    BlendMode.srcIn,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  _formatCount(widget.post.commentCount),
                  style: const TextStyle(
                    fontFamily: 'Norican',
                    fontSize: 16,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),

          const Spacer(),
        ],
      ),
    );
  }

  IconData _getPrivacyIcon() {
    switch (widget.post.privacy.name) {
      case 'public':
        return Icons.public;
      case 'friends':
        return Icons.people;
      case 'private':
        return Icons.lock;
      default:
        return Icons.public;
    }
  }

  String _formatCount(int count) {
    if (count >= 1000000) {
      return '${(count / 1000000).toStringAsFixed(1)}M';
    } else if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}K';
    }
    return count.toString();
  }
}
