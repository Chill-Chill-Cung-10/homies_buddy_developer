import 'package:flutter/material.dart';

/// App Colors - Pastel theme cho Homies Buddy
class AppColors {
  // Primary Colors (từ UI mockup)
  static const Color primaryBeige = Color(0xFFF5EDE4);
  static const Color primaryPeach = Color(0xFFFFD6BA);
  static const Color primaryYellow = Color(0xFFFFF8DC);
  static const Color primaryGreen = Color(0xFFB8D4A8);
  
  // Secondary Colors
  static const Color accentPink = Color(0xFFFFB6C1);
  static const Color accentBlue = Color(0xFFB3D9E8);
  static const Color accentPurple = Color(0xFFD4C4E8);
  
  // Neutral Colors
  static const Color textDark = Color(0xFF5C4A3F);
  static const Color textMedium = Color(0xFF8B7968);
  static const Color textLight = Color(0xFFB5A598);
  static const Color backgroundLight = Color(0xFFFFFAF5);
  
  // UI Elements
  static const Color cardBackground = Color(0xFFFFF8F0);
  static const Color divider = Color(0xFFE8DED0);
  static const Color white = Color(0xFFFFFFFF);
  static const Color shadow = Color(0x1EA07859);
  
  // Status Colors
  static const Color success = Color(0xFF7BC67E);
  static const Color warning = Color(0xFFFFBF69);
  static const Color error = Color(0xFFFF8585);
  static const Color info = Color(0xFF6EABDB);
  
  // Gradient Colors
  static const LinearGradient skyGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFFE8F4F8),
      Color(0xFFB8D4E8),
    ],
  );
  
  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFFFFAF5),
      Color(0xFFFFF0E5),
    ],
  );
}
