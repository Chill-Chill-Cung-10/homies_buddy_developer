import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';
import '../constants/app_shapes.dart';

/// App Theme Configuration - Material 3
/// Provides light theme with pastel colors matching Homies Buddy design
class AppTheme {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true, // Enable Material 3 design system
    
    // Color Scheme - Pastel theme
    colorScheme: ColorScheme.light(
      primary: AppColors.primaryPeach,
      secondary: AppColors.primaryGreen,
      tertiary: AppColors.primaryPink,
      surface: AppColors.surfaceColor,
      background: AppColors.backgroundLight,
      error: AppColors.errorRed,
      onPrimary: AppColors.textPrimary,
      onSecondary: AppColors.textPrimary,
      onSurface: AppColors.textPrimary,
      onBackground: AppColors.textPrimary,
      onError: Colors.white,
    ),
    
    // Scaffold Background
    scaffoldBackgroundColor: AppColors.backgroundLight,
    
    // Typography - Using custom text styles
    textTheme: const TextTheme(
      displayLarge: AppTextStyles.h1,
      displayMedium: AppTextStyles.h2,
      displaySmall: AppTextStyles.h3,
      bodyLarge: AppTextStyles.bodyLarge,
      bodyMedium: AppTextStyles.bodyMedium,
      bodySmall: AppTextStyles.bodySmall,
      labelLarge: AppTextStyles.buttonLarge,
      labelMedium: AppTextStyles.buttonMedium,
      titleMedium: AppTextStyles.label,
    ),
    
    // AppBar Theme
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.backgroundLight,
      foregroundColor: AppColors.textPrimary,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: AppTextStyles.h2,
      iconTheme: IconThemeData(
        color: AppColors.iconColor,
        size: 24,
      ),
    ),
    
    // Card Theme
    cardTheme: CardThemeData(
      color: AppColors.cardBackground,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: AppShapes.card,
      ),
    ),
    
    // Elevated Button Theme
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.buttonPrimary,
        foregroundColor: AppColors.textPrimary,
        elevation: 2,
        padding: const EdgeInsets.symmetric(
          horizontal: 32,
          vertical: 16,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: AppShapes.button,
        ),
        textStyle: AppTextStyles.buttonLarge,
      ),
    ),
    
    // Text Button Theme
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.textPrimary,
        textStyle: AppTextStyles.buttonMedium,
      ),
    ),
    
    // Outlined Button Theme
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.textPrimary,
        side: const BorderSide(color: AppColors.textSecondary),
        shape: RoundedRectangleBorder(
          borderRadius: AppShapes.button,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 32,
          vertical: 16,
        ),
      ),
    ),
    
    // Input Decoration Theme
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surfaceColor,
      border: OutlineInputBorder(
        borderRadius: AppShapes.button,
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: AppShapes.button,
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: AppShapes.button,
        borderSide: const BorderSide(
          color: AppColors.primaryGreen,
          width: 2,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: AppShapes.button,
        borderSide: const BorderSide(
          color: AppColors.errorRed,
          width: 2,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: AppShapes.button,
        borderSide: const BorderSide(
          color: AppColors.errorRed,
          width: 2,
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 16,
      ),
      hintStyle: AppTextStyles.bodyMedium.copyWith(
        color: AppColors.textHint,
      ),
      labelStyle: AppTextStyles.label.copyWith(
        color: AppColors.textSecondary,
      ),
    ),
    
    // Navigation Bar Theme (Material 3)
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: AppColors.navBarBackground,
      indicatorColor: AppColors.primaryGreen.withOpacity(0.3),
      height: 70,
      elevation: 8,
      labelTextStyle: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return AppTextStyles.label.copyWith(
            color: AppColors.navBarSelected,
            fontSize: 12,
          );
        }
        return AppTextStyles.label.copyWith(
          color: AppColors.navBarUnselected,
          fontSize: 12,
        );
      }),
      iconTheme: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return const IconThemeData(
            color: AppColors.navBarSelected,
            size: 28,
          );
        }
        return const IconThemeData(
          color: AppColors.navBarUnselected,
          size: 28,
        );
      }),
    ),
    
    // Icon Theme
    iconTheme: const IconThemeData(
      color: AppColors.iconColor,
      size: 24,
    ),
    
    // Floating Action Button Theme
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: AppColors.buttonPrimary,
      foregroundColor: AppColors.textPrimary,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
    
    // Divider Theme
    dividerTheme: const DividerThemeData(
      color: AppColors.textHint,
      thickness: 1,
      space: 1,
    ),
  );
}
