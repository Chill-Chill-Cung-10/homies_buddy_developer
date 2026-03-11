/// [Refactored] Phase 3.2 — Extracted from social_post_card.dart
/// Media carousel: single image, video thumbnail, or multi-image carousel
///
/// FIXED LAYOUT: Uses constant 4:5 aspect ratio to prevent layout jumps
/// - All images displayed with BoxFit.cover in fixed frame
/// - PageView.builder for carousel (better performance than CarouselSlider)
library;

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_shapes.dart';
import '../../../../../data/models/media_file_model.dart';

class PostMediaCarousel extends StatefulWidget {
  final List<MediaFile> mediaFiles;

  const PostMediaCarousel({super.key, required this.mediaFiles});

  @override
  State<PostMediaCarousel> createState() => _PostMediaCarouselState();
}

class _PostMediaCarouselState extends State<PostMediaCarousel> {
  int _currentMediaIndex = 0;
  late final PageController _pageController;

  /// Fixed aspect ratio 4:5 (width:height = 0.8)
  /// This ensures consistent layout regardless of original image dimensions
  static const double fixedAspectRatio = 4 / 5; // 0.8

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.mediaFiles.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppShapes.paddingS,
        vertical: AppShapes.paddingS,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Fixed aspect ratio container - prevents layout jumps
          AspectRatio(
            aspectRatio: fixedAspectRatio,
            child: widget.mediaFiles.length == 1
                ? _buildSingleMedia(widget.mediaFiles.first)
                : _buildMediaCarousel(widget.mediaFiles),
          ),
          // Page indicators (only for multiple images)
          if (widget.mediaFiles.length > 1)
            _buildCarouselIndicators(widget.mediaFiles.length),
        ],
      ),
    );
  }

  Widget _buildSingleMedia(MediaFile media) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppShapes.iconRadius),
      child: _buildMediaContent(media),
    );
  }

  Widget _buildMediaCarousel(List<MediaFile> mediaFiles) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppShapes.iconRadius),
      child: PageView.builder(
        controller: _pageController,
        itemCount: mediaFiles.length,
        onPageChanged: (index) {
          setState(() {
            _currentMediaIndex = index;
          });
        },
        itemBuilder: (context, index) {
          return _buildMediaContent(mediaFiles[index]);
        },
      ),
    );
  }

  Widget _buildMediaContent(MediaFile media) {
    if (media.isVideo) {
      return Stack(
        fit: StackFit.expand,
        children: [
          CachedNetworkImage(
            imageUrl: media.thumbnailUrl ?? media.mediaUrl,
            fit: BoxFit.cover,
            placeholder: (context, url) => Container(
              color: AppColors.surfaceColor,
              child: const Center(
                child: CircularProgressIndicator(color: AppColors.accentOrange),
              ),
            ),
            errorWidget: (context, url, error) => Container(
              color: AppColors.surfaceColor,
              child: const Icon(Icons.error),
            ),
          ),
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
          if (media.durationSeconds != null)
            Positioned(
              bottom: 8,
              right: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
      return CachedNetworkImage(
        imageUrl: media.mediaUrl,
        fit: BoxFit.cover,
        placeholder: (context, url) => Container(
          color: AppColors.surfaceColor,
          child: const Center(
            child: CircularProgressIndicator(color: AppColors.accentOrange),
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
}
