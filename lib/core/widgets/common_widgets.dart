import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';
import '../constants/app_shapes.dart';
import '../constants/app_spacing.dart';

/// Custom Button Widget với loading state và nhiều kiểu
class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isFullWidth;
  final ButtonType type;
  final IconData? icon;
  final double? height;

  const CustomButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.isFullWidth = true,
    this.type = ButtonType.primary,
    this.icon,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget buttonChild = isLoading
        ? const SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                AppColors.textPrimary,
              ),
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
            shape: RoundedRectangleBorder(
              borderRadius: AppShapes.button,
            ),
            disabledBackgroundColor:
                AppColors.buttonPrimary.withOpacity(0.5),
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
            shape: RoundedRectangleBorder(
              borderRadius: AppShapes.button,
            ),
            disabledBackgroundColor:
                AppColors.buttonSecondary.withOpacity(0.5),
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
            shape: RoundedRectangleBorder(
              borderRadius: AppShapes.button,
            ),
          ),
          child: buttonChild,
        );
        break;
      case ButtonType.text:
        button = TextButton(
          onPressed: isLoading ? null : onPressed,
          style: TextButton.styleFrom(
            foregroundColor: AppColors.primaryGreen,
          ),
          child: buttonChild,
        );
        break;
    }

    if (height != null) {
      button = SizedBox(height: height, child: button);
    }

    return isFullWidth ? SizedBox(width: double.infinity, child: button) : button;
  }
}

enum ButtonType { primary, secondary, outlined, text }

/// Custom TextField Widget với validation
class CustomTextField extends StatefulWidget {
  final TextEditingController? controller;
  final String label;
  final String? hint;
  final bool obscureText;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final bool enabled;
  final TextInputAction? textInputAction;
  final int? maxLines;
  final void Function(String)? onChanged;

  const CustomTextField({
    Key? key,
    this.controller,
    required this.label,
    this.hint,
    this.obscureText = false,
    this.keyboardType,
    this.validator,
    this.prefixIcon,
    this.suffixIcon,
    this.enabled = true,
    this.textInputAction,
    this.maxLines = 1,
    this.onChanged,
  }) : super(key: key);

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: widget.obscureText,
      keyboardType: widget.keyboardType,
      validator: widget.validator,
      enabled: widget.enabled,
      textInputAction: widget.textInputAction,
      maxLines: widget.obscureText ? 1 : widget.maxLines,
      onChanged: widget.onChanged,
      decoration: InputDecoration(
        labelText: widget.label,
        hintText: widget.hint,
        prefixIcon: widget.prefixIcon != null
            ? Icon(
                widget.prefixIcon,
                color: AppColors.textSecondary,
              )
            : null,
        suffixIcon: widget.suffixIcon,
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
        disabledBorder: OutlineInputBorder(
          borderRadius: AppShapes.button,
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

/// Custom Password TextField với visibility toggle
class PasswordTextField extends StatefulWidget {
  final TextEditingController? controller;
  final String label;
  final String? hint;
  final String? Function(String?)? validator;
  final bool enabled;
  final TextInputAction? textInputAction;

  const PasswordTextField({
    Key? key,
    this.controller,
    required this.label,
    this.hint,
    this.validator,
    this.enabled = true,
    this.textInputAction,
  }) : super(key: key);

  @override
  State<PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      controller: widget.controller,
      label: widget.label,
      hint: widget.hint,
      obscureText: _obscureText,
      validator: widget.validator,
      enabled: widget.enabled,
      textInputAction: widget.textInputAction,
      prefixIcon: Icons.lock_outline,
      suffixIcon: IconButton(
        icon: Icon(
          _obscureText ? Icons.visibility_off : Icons.visibility,
          color: AppColors.textSecondary,
        ),
        onPressed: () {
          setState(() {
            _obscureText = !_obscureText;
          });
        },
      ),
    );
  }
}

/// Loading Overlay Widget
class LoadingOverlay extends StatelessWidget {
  final bool isLoading;
  final Widget child;
  final String? loadingText;

  const LoadingOverlay({
    Key? key,
    required this.isLoading,
    required this.child,
    this.loadingText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading)
          Container(
            color: Colors.black.withOpacity(0.3),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppColors.primaryGreen,
                    ),
                  ),
                  if (loadingText != null) ...[
                    const SizedBox(height: AppSpacing.m),
                    Text(
                      loadingText!,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
      ],
    );
  }
}

/// Empty State Widget
class EmptyStateWidget extends StatelessWidget {
  final String title;
  final String message;
  final IconData icon;
  final VoidCallback? onAction;
  final String? actionLabel;

  const EmptyStateWidget({
    Key? key,
    required this.title,
    required this.message,
    required this.icon,
    this.onAction,
    this.actionLabel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppShapes.paddingXL),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 80,
              color: AppColors.textHint,
            ),
            const SizedBox(height: AppSpacing.l),
            Text(
              title,
              style: AppTextStyles.h2,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.m),
            Text(
              message,
              style: AppTextStyles.bodyMedium,
              textAlign: TextAlign.center,
            ),
            if (onAction != null && actionLabel != null) ...[
              const SizedBox(height: AppSpacing.l),
              CustomButton(
                text: actionLabel!,
                onPressed: onAction,
                isFullWidth: false,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Info Card Widget
class InfoCard extends StatelessWidget {
  final String message;
  final IconData icon;
  final Color? backgroundColor;
  final Color? iconColor;

  const InfoCard({
    Key? key,
    required this.message,
    required this.icon,
    this.backgroundColor,
    this.iconColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppShapes.paddingM),
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.primaryPink.withOpacity(0.3),
        borderRadius: AppShapes.button,
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: iconColor ?? AppColors.textSecondary,
            size: 20,
          ),
          const SizedBox(width: AppSpacing.s),
          Expanded(
            child: Text(
              message,
              style: AppTextStyles.bodySmall,
            ),
          ),
        ],
      ),
    );
  }
}

/// Custom Dialog Helper
class CustomDialog {
  /// Show success dialog
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
        shape: RoundedRectangleBorder(
          borderRadius: AppShapes.button,
        ),
        title: Row(
          children: [
            const Icon(
              Icons.check_circle,
              color: AppColors.successGreen,
              size: 28,
            ),
            const SizedBox(width: AppSpacing.s),
            Text(
              title,
              style: AppTextStyles.h3,
            ),
          ],
        ),
        content: Text(
          message,
          style: AppTextStyles.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              onConfirm?.call();
            },
            child: Text(
              confirmText,
              style: AppTextStyles.buttonMedium,
            ),
          ),
        ],
      ),
    );
  }

  /// Show error dialog
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
        shape: RoundedRectangleBorder(
          borderRadius: AppShapes.button,
        ),
        title: Row(
          children: [
            const Icon(
              Icons.error,
              color: AppColors.errorRed,
              size: 28,
            ),
            const SizedBox(width: AppSpacing.s),
            Text(
              title,
              style: AppTextStyles.h3,
            ),
          ],
        ),
        content: Text(
          message,
          style: AppTextStyles.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              onConfirm?.call();
            },
            child: Text(
              confirmText,
              style: AppTextStyles.buttonMedium,
            ),
          ),
        ],
      ),
    );
  }

  /// Show confirmation dialog
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
        shape: RoundedRectangleBorder(
          borderRadius: AppShapes.button,
        ),
        title: Text(
          title,
          style: AppTextStyles.h3,
        ),
        content: Text(
          message,
          style: AppTextStyles.bodyMedium,
        ),
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
