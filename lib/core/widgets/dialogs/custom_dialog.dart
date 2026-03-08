import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_text_styles.dart';
import '../../constants/app_shapes.dart';
import '../../constants/app_spacing.dart';

/// [Refactored] Phase 1.2 — Tách từ common_widgets.dart.
///
/// Helper class cho các dialog thông dụng: success, error, confirmation.
/// Gọi bằng static methods, ví dụ:
/// ```dart
/// CustomDialog.showSuccess(context, title: '...', message: '...');
/// ```
class CustomDialog {
  /// Hiển thị dialog thành công với icon check xanh.
  static void showSuccess(
    BuildContext context, {
    required String title,
    required String message,
    VoidCallback? onConfirm,
    String confirmText = 'OK',
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.cardBackground,
        shape: RoundedRectangleBorder(borderRadius: AppShapes.button),
        title: Row(
          children: [
            const Icon(
              Icons.check_circle,
              color: AppColors.successGreen,
              size: 28,
            ),
            const SizedBox(width: AppSpacing.s),
            Text(title, style: AppTextStyles.h3),
          ],
        ),
        content: Text(message, style: AppTextStyles.bodyMedium),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              onConfirm?.call();
            },
            child: Text(confirmText, style: AppTextStyles.buttonMedium),
          ),
        ],
      ),
    );
  }

  /// Hiển thị dialog lỗi với icon error đỏ.
  static void showError(
    BuildContext context, {
    required String title,
    required String message,
    VoidCallback? onConfirm,
    String confirmText = 'OK',
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.cardBackground,
        shape: RoundedRectangleBorder(borderRadius: AppShapes.button),
        title: Row(
          children: [
            const Icon(Icons.error, color: AppColors.errorRed, size: 28),
            const SizedBox(width: AppSpacing.s),
            Text(title, style: AppTextStyles.h3),
          ],
        ),
        content: Text(message, style: AppTextStyles.bodyMedium),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              onConfirm?.call();
            },
            child: Text(confirmText, style: AppTextStyles.buttonMedium),
          ),
        ],
      ),
    );
  }

  /// Hiển thị dialog xác nhận với 2 nút Confirm / Cancel.
  static void showConfirmation(
    BuildContext context, {
    required String title,
    required String message,
    required VoidCallback onConfirm,
    VoidCallback? onCancel,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.cardBackground,
        shape: RoundedRectangleBorder(borderRadius: AppShapes.button),
        title: Text(title, style: AppTextStyles.h3),
        content: Text(message, style: AppTextStyles.bodyMedium),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              onCancel?.call();
            },
            child: Text(
              cancelText,
              style: AppTextStyles.buttonMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              onConfirm();
            },
            child: Text(
              confirmText,
              style: AppTextStyles.buttonMedium.copyWith(
                color: AppColors.primaryGreen,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
