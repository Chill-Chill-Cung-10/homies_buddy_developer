/// Hero header cho User Profile Screen (tab chính)
/// Giống ProfileHeroHeader nhưng dùng SpinningNavButton thay vì nút back,
/// và có icon settings ở góc trên bên phải.
library;
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_text_styles.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/utils/formatters.dart';
import '../../../../../core/widgets/spinning_nav_button.dart';
import '../../../../../data/models/user_model.dart';

class UserProfileHeroHeader extends StatelessWidget {
  final UserModel user;
  final VoidCallback onSettingsTap;

  const UserProfileHeroHeader({
    super.key,
    required this.user,
    required this.onSettingsTap,
  });

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
      leading: const Padding(
        padding: EdgeInsets.all(4),
        child: SpinningNavButton(iconColor: Colors.white),
      ),
      actions: [
        _buildSettingsButton(),
      ],
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.parallax,
        stretchModes: const [
          StretchMode.zoomBackground,
          StretchMode.fadeTitle,
        ],
        background: Stack(
          fit: StackFit.expand,
          children: [
            _buildCoverImage(),
            _buildGradientOverlay(),
            _buildHeroContent(),
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

  Widget _buildSettingsButton() {
    return Container(
      margin: const EdgeInsets.all(4),
      child: IconButton(
        icon: const Icon(Icons.settings_outlined, color: Colors.white, size: 24),
        onPressed: onSettingsTap,
      ),
    );
  }

  Widget _buildCoverImage() {
    return CachedNetworkImage(
      imageUrl: user.coverUrl ?? user.avatarUrl,
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

  Widget _buildHeroContent() {
    return Positioned(
      bottom: 40,
      left: AppSpacing.paddingM,
      right: AppSpacing.paddingM,
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
                  child: CachedNetworkImage(
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
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.s),
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
          const SizedBox(height: 20),
          if (user.hasFeaturedHeader)
            Text(
              limitWords(user.headline!, 10),
              style: const TextStyle(
                fontSize: 42,
                fontWeight: FontWeight.w900,
                color: Colors.white,
                height: 1.0,
                letterSpacing: -1,
              ),
            ),
          if (user.hasFeaturedHeader) const SizedBox(height: AppSpacing.s),
          if (user.bio != null && user.bio!.isNotEmpty)
            Text(
              limitWords(user.bio!, 40),
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
}
