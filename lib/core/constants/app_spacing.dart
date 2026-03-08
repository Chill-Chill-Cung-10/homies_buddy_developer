/// [Refactored] Phase 1.3 — Nguồn duy nhất cho spacing & padding.
///
/// Spacing ngữ nghĩa (xxs → xl) dùng cho khoảng cách giữa các phần tử.
/// Padding (paddingXS → paddingXL) di chuyển từ AppShapes để tách biệt
/// concern: spacing/padding ở đây, border radius/dimensions ở AppShapes.
class AppSpacing {
  // ── Spacing (khoảng cách giữa các phần tử) ──
  static const double xxs = 4;
  static const double xs = 8;
  static const double s = 12;
  static const double m = 16;
  static const double l = 24;
  static const double xl = 32;

  // ── Padding (di chuyển từ AppShapes — Phase 1.3) ──
  static const double paddingXS = 4.0;
  static const double paddingS = 8.0;
  static const double paddingM = 16.0;
  static const double paddingL = 24.0;
  static const double paddingXL = 32.0;
}
