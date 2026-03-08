import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../constants/app_colors.dart';
import 'loading_indicators.dart';

/// Optimized image widget với progressive loading
///
/// Features:
/// - Load thumbnail trước, sau đó load full image
/// - Cache images
/// - Downsample large images để tiết kiệm memory
/// - Placeholder với shimmer effect
/// - Error handling
///
/// Usage:
/// ```dart
/// OptimizedImage(
///   imageUrl: 'https://example.com/image.jpg',
///   thumbnailUrl: 'https://example.com/thumbnail.jpg',
///   width: 400,
///   height: 300,
/// )
/// ```
class OptimizedImage extends StatelessWidget {
  final String imageUrl;
  final String? thumbnailUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final bool useMemCacheWidth;
  final int? memCacheWidth;
  final int? memCacheHeight;

  const OptimizedImage({
    super.key,
    required this.imageUrl,
    this.thumbnailUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.useMemCacheWidth = true,
    this.memCacheWidth,
    this.memCacheHeight,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.zero,
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        width: width,
        height: height,
        fit: fit,

        // Progressive loading: show thumbnail while loading full image
        placeholder: thumbnailUrl != null
            ? (context, url) => CachedNetworkImage(
                imageUrl: thumbnailUrl!,
                width: width,
                height: height,
                fit: fit,
                memCacheWidth: useMemCacheWidth ? (memCacheWidth ?? 400) : null,
                memCacheHeight: useMemCacheWidth ? memCacheHeight : null,
              )
            : (context, url) => ShimmerPlaceholder(
                width: width,
                height: height,
                borderRadius: borderRadius,
              ),

        // Downsample large images để tiết kiệm memory
        memCacheWidth: useMemCacheWidth ? (memCacheWidth ?? 800) : null,
        memCacheHeight: useMemCacheWidth ? memCacheHeight : null,

        // Smooth fade in
        fadeInDuration: const Duration(milliseconds: 300),
        fadeOutDuration: const Duration(milliseconds: 100),

        // Error widget
        errorWidget: (context, url, error) => Container(
          width: width,
          height: height,
          color: AppColors.surfaceColor,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.broken_image_outlined,
                size: 48,
                color: AppColors.textSecondary.withOpacity(0.5),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Failed to load image',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary.withOpacity(0.7),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Avatar widget tối ưu với size variants
class OptimizedAvatar extends StatelessWidget {
  final String imageUrl;
  final double size;
  final bool showBorder;
  final Color? borderColor;

  const OptimizedAvatar({
    super.key,
    required this.imageUrl,
    this.size = 40,
    this.showBorder = false,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: showBorder
            ? Border.all(color: borderColor ?? AppColors.accentOrange, width: 2)
            : null,
      ),
      child: ClipOval(
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          width: size,
          height: size,
          fit: BoxFit.cover,

          // Avatar thường nhỏ, downsample về 150x150
          memCacheWidth: 150,
          memCacheHeight: 150,

          placeholder: (context, url) => Container(
            color: AppColors.surfaceColor,
            child: Icon(
              Icons.person,
              size: size * 0.6,
              color: AppColors.textSecondary.withOpacity(0.5),
            ),
          ),

          errorWidget: (context, url, error) => Container(
            color: AppColors.surfaceColor,
            child: Icon(
              Icons.person,
              size: size * 0.6,
              color: AppColors.textSecondary.withOpacity(0.5),
            ),
          ),
        ),
      ),
    );
  }
}

/// Post image với aspect ratio tự động
class OptimizedPostImage extends StatelessWidget {
  final String imageUrl;
  final String? thumbnailUrl;
  final double aspectRatio;
  final VoidCallback? onTap;

  const OptimizedPostImage({
    super.key,
    required this.imageUrl,
    this.thumbnailUrl,
    this.aspectRatio = 16 / 9,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AspectRatio(
        aspectRatio: aspectRatio,
        child: OptimizedImage(
          imageUrl: imageUrl,
          thumbnailUrl: thumbnailUrl,
          borderRadius: BorderRadius.circular(8),
          memCacheWidth: 800, // Post images: 800px
        ),
      ),
    );
  }
}

/// Cover photo tối ưu với progressive loading
class OptimizedCoverPhoto extends StatelessWidget {
  final String imageUrl;
  final String? thumbnailUrl;
  final double height;

  const OptimizedCoverPhoto({
    super.key,
    required this.imageUrl,
    this.thumbnailUrl,
    this.height = 200,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: height,
      child: OptimizedImage(
        imageUrl: imageUrl,
        thumbnailUrl: thumbnailUrl,
        fit: BoxFit.cover,
        memCacheWidth: 1200, // Cover photos: larger cache
      ),
    );
  }
}

/// Helper function để preload images
///
/// Usage:
/// ```dart
/// void _preloadNextImages() {
///   for (int i = currentIndex + 1; i < currentIndex + 3 && i < posts.length; i++) {
///     preloadImage(context, posts[i].imageUrl);
///   }
/// }
/// ```
void preloadImage(BuildContext context, String imageUrl) {
  if (imageUrl.isEmpty) return;
  precacheImage(CachedNetworkImageProvider(imageUrl), context);
}

/// Preload multiple images
void preloadImages(BuildContext context, List<String> imageUrls) {
  for (final url in imageUrls) {
    if (url.isNotEmpty) {
      preloadImage(context, url);
    }
  }
}

/// Image size constants cho consistency
class ImageSizes {
  static const int thumbnail = 150;
  static const int avatar = 150;
  static const int small = 400;
  static const int medium = 800;
  static const int large = 1200;
  static const int fullscreen = 2048;
}

/// Helper để generate thumbnail URLs (nếu server hỗ trợ)
///
/// Example: Cloudinary, Imgix, Firebase Storage với resize
String? getThumbnailUrl(String originalUrl, {int size = ImageSizes.small}) {
  // TODO: Implement theo backend service
  // Example với Cloudinary:
  // return originalUrl.replaceFirst('/upload/', '/upload/w_$size,c_scale/');

  // Example với Firebase Storage:
  // return '${originalUrl}_${size}x$size';

  // Nếu không có thumbnail service, return null
  return null;
}
