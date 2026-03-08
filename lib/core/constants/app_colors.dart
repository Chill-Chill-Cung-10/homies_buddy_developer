import 'package:flutter/material.dart';

/// AppColors — Nguồn duy nhất cho toàn bộ màu sắc trong app Homies Buddy.
///
/// Đã hợp nhất từ `core/theme/app_colors.dart` (pastel/beige)
/// và `core/constants/app_colors.dart` (primary/status/gradient).
/// [Refactored] Phase 1.1 — Merge AppColors thành 1 file duy nhất.
class AppColors {
  // ──────────────────────────────────────────────
  // Primary Colors (tông màu pastel nhẹ nhàng)
  // ──────────────────────────────────────────────
  static const Color primaryPeach = Color(0xFFF5D5C8);
  static const Color primaryGreen = Color(0xFFB5D4A8);
  static const Color primaryPink = Color(0xFFFFE0E6);
  static const Color accentOrange = Color(0xFFFFB88C);

  // ──────────────────────────────────────────────
  // Pastel Palette (merged từ theme/app_colors.dart)
  // ──────────────────────────────────────────────
  /// Pastel hồng cam — `secondary` trong theme cũ
  static const Color pastelPink = Color(0xFFF7B7A3);

  /// Pastel xanh dương nhẹ
  static const Color pastelBlue = Color(0xFF9FD3F2);

  /// Pastel xanh lá — trùng primaryGreen, giữ alias cho readability
  static const Color pastelGreen = Color(0xFF9ED6A0);

  /// Pastel nâu ấm
  static const Color pastelBrown = Color(0xFFC9A27E);

  /// Pastel vàng
  static const Color pastelYellow = Color(0xFFFFE29A);

  // ──────────────────────────────────────────────
  // Background Colors
  // ──────────────────────────────────────────────
  static const Color backgroundLight = Color(0xFFFFF8F5);
  static const Color backgroundPost = Color(0xFFFFFFFF);
  static const Color backgroundPeach = Color(0xFFF5D5C8);

  /// Background beige ấm (từ theme cũ `background`)
  static const Color backgroundBeige = Color(0xFFFFF3E8);
  static const Color cardBackground = Color(0xFFFFF5EE);
  static const Color surfaceColor = Color(0xFFFAF0E6);

  // ──────────────────────────────────────────────
  // Text Colors
  // ──────────────────────────────────────────────
  static const Color textPrimary = Color(0xFF5D4E37);
  static const Color textSecondary = Color(0xFF8B7355);
  static const Color textHint = Color(0xFFBDA88F);

  /// Placeholder text (nhạt hơn textHint)
  static const Color textPlaceholder = Color(0xFFC8B2A3);
  static const Color textBlackContrast = Color(0xFFFFFFFF);
  static const Color textBlack = Color(0xFF000000);

  // ──────────────────────────────────────────────
  // UI Element Colors
  // ──────────────────────────────────────────────
  static const Color buttonPrimary = Color(0xFFE8C4A7);
  static const Color buttonSecondary = Color(0xFFD4E5C9);
  static const Color iconColor = Color(0xFF9C8672);

  /// Border nhẹ cho card / input (từ theme cũ `border`)
  static const Color borderLight = Color(0xFFF0D9C5);

  // ──────────────────────────────────────────────
  // Status Colors
  // ──────────────────────────────────────────────
  static const Color successGreen = Color(0xFF8BC34A);
  static const Color errorRed = Color(0xFFEF5350);
  static const Color warningYellow = Color(0xFFFFEB3B);

  // ──────────────────────────────────────────────
  // Navigation Bar
  // ──────────────────────────────────────────────
  static const Color navBarBackground = Color(0xFFFFF8F5);
  static const Color navBarSelected = Color(0xFF6B5D4F);
  static const Color navBarUnselected = Color(0xFFBDA88F);

  // ──────────────────────────────────────────────
  // Gradient Colors
  // ──────────────────────────────────────────────
  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [Color(0xFFFFD9CC), Color(0xFFF6E4C9)],
    stops: [0.0, 0.73],
  );

  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFFFAF5), Color(0xFFFFF0E5)],
  );

  /// Gradient cream ấm (từ theme cũ `gradientCream → gradientPeach`)
  static const LinearGradient warmCreamGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFFFFF3E8), // gradientCream
      Color(0xFFFFD8C2), // gradientPeach
    ],
  );

  /// Gradient beige nhẹ (từ theme cũ `gradientWarmBeige → gradientLightApricot`)
  static const LinearGradient warmBeigeGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFFF3E3CF), // gradientWarmBeige
      Color(0xFFFFE6D2), // gradientLightApricot
    ],
  );
}
