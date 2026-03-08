import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_text_styles.dart';
import '../../constants/app_shapes.dart';
import '../../constants/app_spacing.dart';

/// [Refactored] Phase 1.2 — Tách từ common_widgets.dart.
///
/// Widget nút bấm tuỳ chỉnh với loading state và nhiều kiểu (primary,
/// secondary, outlined, text). Dùng chung toàn app.
class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isFullWidth;
  final ButtonType type;
  final IconData? icon;
  final double? height;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.isFullWidth = true,
    this.type = ButtonType.primary,
    this.icon,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    Widget buttonChild = isLoading
        ? const SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.textPrimary),
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 20),
                const SizedBox(width: AppSpacing.s),
              ],
              Text(
                text,
                style: type == ButtonType.primary
                    ? AppTextStyles.buttonLarge
                    : AppTextStyles.buttonMedium,
              ),
            ],
          );

    Widget button;

    switch (type) {
      case ButtonType.primary:
        button = ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.buttonPrimary,
            foregroundColor: AppColors.textPrimary,
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: AppShapes.button),
            disabledBackgroundColor: AppColors.buttonPrimary.withValues(
              alpha: 0.5,
            ),
          ),
          child: buttonChild,
        );
        break;
      case ButtonType.secondary:
        button = ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.buttonSecondary,
            foregroundColor: AppColors.textPrimary,
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: AppShapes.button),
            disabledBackgroundColor: AppColors.buttonSecondary.withValues(
              alpha: 0.5,
            ),
          ),
          child: buttonChild,
        );
        break;
      case ButtonType.outlined:
        button = OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.textPrimary,
            side: const BorderSide(color: AppColors.textSecondary),
            shape: RoundedRectangleBorder(borderRadius: AppShapes.button),
          ),
          child: buttonChild,
        );
        break;
      case ButtonType.text:
        button = TextButton(
          onPressed: isLoading ? null : onPressed,
          style: TextButton.styleFrom(foregroundColor: AppColors.primaryGreen),
          child: buttonChild,
        );
        break;
    }

    if (height != null) {
      button = SizedBox(height: height, child: button);
    }

    return isFullWidth
        ? SizedBox(width: double.infinity, child: button)
        : button;
  }
}

/// Kiểu nút bấm có sẵn cho [CustomButton].
enum ButtonType { primary, secondary, outlined, text }
