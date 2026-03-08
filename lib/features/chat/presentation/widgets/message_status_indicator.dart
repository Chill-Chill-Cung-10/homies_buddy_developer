import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../data/models/models.dart';

/// Message Status Indicator Widget
///
/// Shows the delivery/read status of a message
class MessageStatusIndicator extends StatelessWidget {
  final MessageStatus status;

  const MessageStatusIndicator({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    switch (status) {
      case MessageStatus.sending:
        return SizedBox(
          width: 10,
          height: 10,
          child: CircularProgressIndicator(
            strokeWidth: 1.5,
            valueColor: AlwaysStoppedAnimation<Color>(
              AppColors.textSecondary.withOpacity(0.5),
            ),
          ),
        );

      case MessageStatus.sent:
        return Icon(
          Icons.check,
          size: 14,
          color: AppColors.textSecondary.withOpacity(0.7),
        );

      case MessageStatus.delivered:
        return Icon(
          Icons.done_all,
          size: 14,
          color: AppColors.textSecondary.withOpacity(0.7),
        );

      case MessageStatus.seen:
        return Icon(Icons.done_all, size: 14, color: AppColors.accentOrange);

      case MessageStatus.failed:
        return Icon(Icons.error_outline, size: 14, color: Colors.red.shade400);
    }
  }
}
