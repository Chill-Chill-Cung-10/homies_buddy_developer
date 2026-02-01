import 'package:flutter/material.dart';

/// App Colors - Pastel theme cho Homies Buddy
class AppColors {
  // // Primary Colors (từ UI mockup)
  // static const Color primaryBeige = Color(0xFFF5EDE4);
  // static const Color primaryPeach = Color(0xFFFFD6BA);
  // static const Color primaryYellow = Color(0xFFFFF8DC);
  // static const Color primaryGreen = Color(0xFFB8D4A8);
  
  // // Secondary Colors
  // static const Color accentPink = Color(0xFFFFB6C1);
  // static const Color accentBlue = Color(0xFFB3D9E8);
  // static const Color accentPurple = Color(0xFFD4C4E8);
  
  // // Neutral Colors
  // static const Color textDark = Color(0xFF5C4A3F);
  // static const Color textMedium = Color(0xFF8B7968);
  // static const Color textLight = Color(0xFFB5A598);
  // static const Color backgroundLight = Color(0xFFFFFAF5);
  
  // // UI Elements
  // static const Color cardBackground = Color(0xFFFFF8F0);
  // static const Color divider = Color(0xFFE8DED0);
  // static const Color white = Color(0xFFFFFFFF);
  // static const Color shadow = Color(0x1EA07859);
  
  // // Status Colors
  // static const Color success = Color(0xFF7BC67E);
  // static const Color warning = Color(0xFFFFBF69);
  // static const Color error = Color(0xFFFF8585);
  // static const Color info = Color(0xFF6EABDB);
  // Primary Colors (từ hình - tông màu pastel nhẹ nhàng)
  static const Color primaryPeach = Color(0xFFF5D5C8);      // Màu nền chính
  static const Color primaryGreen = Color(0xFFB5D4A8);      // Màu xanh lá nhẹ
  static const Color primaryPink = Color(0xFFFFE0E6);       // Màu hồng nhạt
  static const Color accentOrange = Color(0xFFFFB88C);      // Màu cam nhấn
  
  // Background Colors
  static const Color backgroundLight = Color(0xFFFFF8F5);
  static const Color cardBackground = Color(0xFFFFF5EE);
  static const Color surfaceColor = Color(0xFFFAF0E6);
  
  // Text Colors
  static const Color textPrimary = Color(0xFF5D4E37);       // Màu nâu cho text chính
  static const Color textSecondary = Color(0xFF8B7355);     // Màu nâu nhạt
  static const Color textHint = Color(0xFFBDA88F);
  
  // UI Element Colors
  static const Color buttonPrimary = Color(0xFFE8C4A7);
  static const Color buttonSecondary = Color(0xFFD4E5C9);
  static const Color iconColor = Color(0xFF9C8672);
  
  // Status Colors
  static const Color successGreen = Color(0xFF8BC34A);
  static const Color errorRed = Color(0xFFEF5350);
  static const Color warningYellow = Color(0xFFFFEB3B);
  
  // Navigation Bar
  static const Color navBarBackground = Color(0xFFFFF8F5);
  static const Color navBarSelected = Color(0xFF6B5D4F);
  static const Color navBarUnselected = Color(0xFFBDA88F);
  
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
// PRIMARY -> "đọc kĩ"
// SECONDARY -> "quét nhanh"
// TETIARY -> "biết là có"