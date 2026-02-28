import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_typography.dart';

/// [Refactored] Phase 1.4 — Tất cả TextStyle dùng [AppTypography] cho
/// fontFamily, fontWeight, letterSpacing thay vì hardcode.
class AppTextStyles {
  // ── Heading Styles ──
  static const TextStyle h1 = TextStyle(
    fontFamily: AppTypography.primaryFont,
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    letterSpacing: AppTypography.headingLetterSpacing,
  );

  static const TextStyle h2 = TextStyle(
    fontFamily: AppTypography.primaryFont,
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static const TextStyle h3 = TextStyle(
    fontFamily: AppTypography.primaryFont,
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  // ── Body Styles ──
  static const TextStyle bodyLarge = TextStyle(
    fontFamily: AppTypography.primaryFont,
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontFamily: AppTypography.primaryFont,
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
  );

  static const TextStyle bodySmall = TextStyle(
    fontFamily: AppTypography.primaryFont,
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
  );

  // ── Button Styles ──
  static const TextStyle buttonLarge = TextStyle(
    fontFamily: AppTypography.primaryFont,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.backgroundLight,
  );

  static const TextStyle buttonMedium = TextStyle(
    fontFamily: AppTypography.primaryFont,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  // ── Caption & Labels ──
  static const TextStyle caption = TextStyle(
    fontFamily: AppTypography.primaryFont,
    fontSize: 12,
    color: AppColors.textHint,
  );

  static const TextStyle label = TextStyle(
    fontFamily: AppTypography.primaryFont,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
  );
}