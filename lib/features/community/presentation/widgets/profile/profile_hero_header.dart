/// [Refactored] Phase 3.1 — Extracted from personal_profile_screen.dart
/// Hero header with fullscreen cover image, gradient overlays, and user info
library;

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_text_styles.dart';
import '../../../../../core/constants/app_shapes.dart';
import '../../../../../data/models/user_model.dart';

class ProfileHeroHeader extends StatelessWidget {
  final UserModel user;

  const ProfileHeroHeader({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return SliverAppBar(
      expandedHeight: screenHeight * 0.92,
      pinned: true,
      stretch: true,
      backgroundColor: AppColors.primaryPeach,
      foregroundColor: AppColors.textPrimary,
      iconTheme: const IconThemeData(color: Colors.white),
      leading: _buildBackButton(context),
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.parallax,
        stretchModes: const [StretchMode.zoomBackground, StretchMode.fadeTitle],
        background: Stack(
          fit: StackFit.expand,
          children: [
            _buildCoverImage(),
            _buildGradientOverlay(),
            _buildHeroContent(context),
            _buildScrollIndicator(),
          ],
        ),
      ),
      title: Text(
        user.displayName,
        style: AppTextStyles.h3.copyWith(
          color: AppColors.textBlackContrast,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(4),
      child: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white, size: 24),
        onPressed: () => Navigator.of(context).pop(),
      ),
    );
  }

  Widget _buildCoverImage() {
    final coverUrl = user.coverUrl;
    final avatarUrl = user.avatarUrl;
    final imageUrl = (coverUrl != null && coverUrl.isNotEmpty) 
        ? coverUrl 
        : (avatarUrl.isNotEmpty ? avatarUrl : null);
    
    if (imageUrl == null) {
      return Container(
        color: AppColors.surfaceColor,
        child: const Icon(Icons.image, size: 48, color: AppColors.textHint),
      );
    }
    
    return CachedNetworkImage(
      imageUrl: imageUrl,
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
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.accentOrange, width: 2),
                ),
                child: ClipOval(
                  child: user.avatarUrl.isNotEmpty
                      ? CachedNetworkImage(
                          imageUrl: user.avatarUrl,
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
                        )
                      : Container(
                          width: 48,
                          height: 48,
                          color: AppColors.surfaceColor,
                          child: const Icon(Icons.person, size: 24, color: AppColors.textHint),
                        ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  '@${user.username}',
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    fontSize: 17,
                  ),
                ),
              ),
            ],
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
}
