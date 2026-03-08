/// System Notification Pop-up Widget
/// 
/// Common widget for displaying in-app system notifications such as:
/// - Account registered successfully
/// - Password changed successfully
/// - Profile updated, etc.
///
/// Usage:
/// ```dart
/// SystemNotificationPopup.show(
///   context,
///   message: 'Account registered successfully!',
///   type: NotificationType.success,
/// );
/// ```
library;

import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';
import '../constants/app_spacing.dart';

/// Notification type enum
enum NotificationType {
  success,
  error,
  warning,
  info,
}

/// Extension to get icon and color for each notification type
extension NotificationTypeExtension on NotificationType {
  IconData get icon {
    switch (this) {
      case NotificationType.success:
        return Icons.check_circle;
      case NotificationType.error:
        return Icons.error;
      case NotificationType.warning:
        return Icons.warning;
      case NotificationType.info:
        return Icons.info;
    }
  }

  Color get color {
    switch (this) {
      case NotificationType.success:
        return AppColors.successGreen;
      case NotificationType.error:
        return AppColors.errorRed;
      case NotificationType.warning:
        return AppColors.warningYellow;
      case NotificationType.info:
        return AppColors.pastelBlue;
    }
  }

  Color get backgroundColor {
    switch (this) {
      case NotificationType.success:
        return AppColors.successGreen.withOpacity(0.15);
      case NotificationType.error:
        return AppColors.errorRed.withOpacity(0.15);
      case NotificationType.warning:
        return AppColors.warningYellow.withOpacity(0.15);
      case NotificationType.info:
        return AppColors.pastelBlue.withOpacity(0.15);
    }
  }
}

/// System Notification Popup Widget
class SystemNotificationPopup extends StatefulWidget {
  final String message;
  final NotificationType type;
  final String? title;
  final Duration duration;
  final VoidCallback? onDismiss;
  final VoidCallback? onAction;
  final String? actionLabel;

  const SystemNotificationPopup({
    super.key,
    required this.message,
    this.type = NotificationType.info,
    this.title,
    this.duration = const Duration(seconds: 3),
    this.onDismiss,
    this.onAction,
    this.actionLabel,
  });

  /// Show notification popup as overlay
  static void show(
    BuildContext context, {
    required String message,
    NotificationType type = NotificationType.info,
    String? title,
    Duration duration = const Duration(seconds: 3),
    VoidCallback? onDismiss,
    VoidCallback? onAction,
    String? actionLabel,
  }) {
    final overlay = Overlay.of(context);
    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) => _SystemNotificationOverlay(
        message: message,
        type: type,
        title: title,
        duration: duration,
        onDismiss: () {
          overlayEntry.remove();
          onDismiss?.call();
        },
        onAction: onAction,
        actionLabel: actionLabel,
      ),
    );

    overlay.insert(overlayEntry);
  }

  /// Show success notification
  static void success(
    BuildContext context, {
    required String message,
    String? title,
    Duration duration = const Duration(seconds: 3),
    VoidCallback? onDismiss,
  }) {
    show(
      context,
      message: message,
      type: NotificationType.success,
      title: title ?? 'Success',
      duration: duration,
      onDismiss: onDismiss,
    );
  }

  /// Show error notification
  static void error(
    BuildContext context, {
    required String message,
    String? title,
    Duration duration = const Duration(seconds: 4),
    VoidCallback? onDismiss,
  }) {
    show(
      context,
      message: message,
      type: NotificationType.error,
      title: title ?? 'Error',
      duration: duration,
      onDismiss: onDismiss,
    );
  }

  /// Show warning notification
  static void warning(
    BuildContext context, {
    required String message,
    String? title,
    Duration duration = const Duration(seconds: 3),
    VoidCallback? onDismiss,
  }) {
    show(
      context,
      message: message,
      type: NotificationType.warning,
      title: title ?? 'Warning',
      duration: duration,
      onDismiss: onDismiss,
    );
  }

  /// Show info notification
  static void info(
    BuildContext context, {
    required String message,
    String? title,
    Duration duration = const Duration(seconds: 3),
    VoidCallback? onDismiss,
  }) {
    show(
      context,
      message: message,
      type: NotificationType.info,
      title: title ?? 'Info',
      duration: duration,
      onDismiss: onDismiss,
    );
  }

  @override
  State<SystemNotificationPopup> createState() => _SystemNotificationPopupState();
}

class _SystemNotificationPopupState extends State<SystemNotificationPopup>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: _buildNotificationCard(),
      ),
    );
  }

  Widget _buildNotificationCard() {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppSpacing.paddingM,
        vertical: AppSpacing.paddingS,
      ),
      padding: const EdgeInsets.all(AppSpacing.paddingM),
      decoration: BoxDecoration(
        color: widget.type.backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: widget.type.color.withOpacity(0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Icon
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: widget.type.color.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              widget.type.icon,
              color: widget.type.color,
              size: 24,
            ),
          ),
          const SizedBox(width: AppSpacing.m),

          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (widget.title != null) ...[
                  Text(
                    widget.title!,
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                ],
                Text(
                  widget.message,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          // Action button (optional)
          if (widget.onAction != null && widget.actionLabel != null) ...[
            const SizedBox(width: AppSpacing.s),
            TextButton(
              onPressed: widget.onAction,
              style: TextButton.styleFrom(
                foregroundColor: widget.type.color,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              ),
              child: Text(
                widget.actionLabel!,
                style: AppTextStyles.bodySmall.copyWith(
                  fontWeight: FontWeight.w600,
                  color: widget.type.color,
                ),
              ),
            ),
          ],

          // Close button
          if (widget.onDismiss != null) ...[
            const SizedBox(width: AppSpacing.xs),
            GestureDetector(
              onTap: widget.onDismiss,
              child: Icon(
                Icons.close,
                size: 18,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Overlay wrapper for system notification
class _SystemNotificationOverlay extends StatefulWidget {
  final String message;
  final NotificationType type;
  final String? title;
  final Duration duration;
  final VoidCallback onDismiss;
  final VoidCallback? onAction;
  final String? actionLabel;

  const _SystemNotificationOverlay({
    required this.message,
    required this.type,
    required this.duration,
    required this.onDismiss,
    this.title,
    this.onAction,
    this.actionLabel,
  });

  @override
  State<_SystemNotificationOverlay> createState() => _SystemNotificationOverlayState();
}

class _SystemNotificationOverlayState extends State<_SystemNotificationOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));

    _controller.forward();

    // Auto dismiss after duration
    Future.delayed(widget.duration, _dismiss);
  }

  void _dismiss() {
    if (!mounted) return;
    _controller.reverse().then((_) {
      if (mounted) widget.onDismiss();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    
    return Positioned(
      top: mediaQuery.padding.top + 10,
      left: 0,
      right: 0,
      child: Material(
        color: Colors.transparent,
        child: GestureDetector(
          onVerticalDragUpdate: (details) {
            if (details.delta.dy < -5) {
              _dismiss();
            }
          },
          child: SlideTransition(
            position: _slideAnimation,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: _buildNotificationCard(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationCard() {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppSpacing.paddingM,
        vertical: AppSpacing.paddingS,
      ),
      padding: const EdgeInsets.all(AppSpacing.paddingM),
      decoration: BoxDecoration(
        color: AppColors.backgroundLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: widget.type.color.withOpacity(0.3),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          // Icon
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: widget.type.backgroundColor,
              shape: BoxShape.circle,
            ),
            child: Icon(
              widget.type.icon,
              color: widget.type.color,
              size: 24,
            ),
          ),
          const SizedBox(width: AppSpacing.m),

          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (widget.title != null) ...[
                  Text(
                    widget.title!,
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                ],
                Text(
                  widget.message,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          // Action button (optional)
          if (widget.onAction != null && widget.actionLabel != null) ...[
            const SizedBox(width: AppSpacing.s),
            TextButton(
              onPressed: widget.onAction,
              style: TextButton.styleFrom(
                foregroundColor: widget.type.color,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              ),
              child: Text(
                widget.actionLabel!,
                style: AppTextStyles.bodySmall.copyWith(
                  fontWeight: FontWeight.w600,
                  color: widget.type.color,
                ),
              ),
            ),
          ],

          // Close button
          const SizedBox(width: AppSpacing.xs),
          GestureDetector(
            onTap: _dismiss,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: AppColors.surfaceColor,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.close,
                size: 16,
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
