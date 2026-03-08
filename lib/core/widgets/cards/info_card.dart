import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_text_styles.dart';
import '../../constants/app_spacing.dart';

/// [Refactored] Phase 1.2 — Tách từ common_widgets.dart.
///
/// Card thông tin nhỏ gọn: icon + message trên nền màu nhẹ.
/// Dùng cho tip, warning, info banner, v.v.
class InfoCard extends StatelessWidget {
  final String message;
  final IconData icon;
  final Color? backgroundColor;
  final Color? iconColor;

  const InfoCard({
    super.key,
    required this.message,
    required this.icon,
    this.backgroundColor,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.paddingM),
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.primaryPink.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Icon(icon, color: iconColor ?? AppColors.textSecondary, size: 20),
          const SizedBox(width: AppSpacing.s),
          Expanded(child: Text(message, style: AppTextStyles.bodySmall)),
        ],
      ),
    );
  }
}
