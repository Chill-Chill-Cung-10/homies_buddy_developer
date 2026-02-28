import 'package:flutter/material.dart';
import 'app_spacing.dart';

/// [Refactored] Phase 1.3 — AppShapes chỉ chứa border radius, icon sizes,
/// card dimensions. Padding đã chuyển sang [AppSpacing].
class AppShapes {
  // ── Border Radius ──
  static const double cardRadius = 30;
  static const double buttonRadius = 18;
  static const double iconRadius = 14;
  static const double fullRadius = 999; // Pill

  static BorderRadius card = BorderRadius.circular(cardRadius);
  static BorderRadius button = BorderRadius.circular(buttonRadius);
  static BorderRadius icon = BorderRadius.circular(iconRadius);
  static BorderRadius full = BorderRadius.circular(fullRadius);

  // ── Padding (@deprecated — dùng AppSpacing.paddingXS/S/M/L/XL thay thế) ──
  @Deprecated('Dùng AppSpacing.paddingXS thay thế')
  static const double paddingXS = AppSpacing.paddingXS;
  @Deprecated('Dùng AppSpacing.paddingS thay thế')
  static const double paddingS = AppSpacing.paddingS;
  @Deprecated('Dùng AppSpacing.paddingM thay thế')
  static const double paddingM = AppSpacing.paddingM;
  @Deprecated('Dùng AppSpacing.paddingL thay thế')
  static const double paddingL = AppSpacing.paddingL;
  @Deprecated('Dùng AppSpacing.paddingXL thay thế')
  static const double paddingXL = AppSpacing.paddingXL;

  // ── Icon Sizes ──
  static const double iconS = 16.0;
  static const double iconM = 24.0;
  static const double iconL  = 32.0;
  static const double iconXL = 48.0;

  // ── Card Dimensions ──
  static const double cardElevation = 2.0;
  static const double cardHeight = 200.0;

  // ── Bottom Navigation ──
  static const double navBarHeight = 60.0;
  static const double navIconSize = 28.0;
}
