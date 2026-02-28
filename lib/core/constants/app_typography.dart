import 'package:flutter/material.dart';

/// [Refactored] Phase 1.4 — Nguồn font family, font weight, letter spacing.
///
/// Được tham chiếu bởi [AppTextStyles] để đảm bảo nhất quán toàn app.
class AppTypography {
  /// Font chính cho toàn app (body, heading, button, v.v.)
  static const String primaryFont = 'Nunito';

  /// Font decorative cho reactions count
  static const String reactionsFont = 'Norican';

  // ── Font Weights ──
  static const FontWeight titleWeight = FontWeight.w700;
  static const FontWeight bodyWeight = FontWeight.w500;
  static const FontWeight captionWeight = FontWeight.w400;

  // ── Letter Spacing ──
  static const double letterSpacing = 0.3;
  static const double headingLetterSpacing = -0.5;
}
