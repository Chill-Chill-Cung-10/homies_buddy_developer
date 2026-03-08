/// [Refactored] Phase 3.2 — Extracted from social_post_card.dart
/// Post content: text description with hashtag/mention rendering
library;

import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_text_styles.dart';
import '../../../../../core/constants/app_shapes.dart';

class PostContent extends StatelessWidget {
  final String contentText;

  const PostContent({super.key, required this.contentText});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppShapes.paddingM,
        vertical: AppShapes.paddingXS,
      ),
      child: Text(
        contentText,
        style: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.textPrimary,
          height: 1.3,
        ),
      ),
    );
  }
}
