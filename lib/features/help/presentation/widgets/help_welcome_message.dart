import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../widgets/typing_animation_text.dart';
import '../../mockdata/help_mock_data.dart';

/// Help Welcome Message - Mascot with typing animation
/// [Refactored] Phase 4 — Trích xuất từ ask_for_help_screen.dart
class HelpWelcomeMessage extends StatelessWidget {
  final VoidCallback onAnimationComplete;

  const HelpWelcomeMessage({
    super.key,
    required this.onAnimationComplete,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Small mascot icon
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.surfaceColor,
            border: Border.all(color: AppColors.primaryPeach, width: 1.5),
          ),
          child: const Center(
            child: Text('🌱', style: TextStyle(fontSize: 16)),
          ),
        ),
        const SizedBox(width: 8),

        // Message bubble with typing animation
        Flexible(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.85),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(4),
                topRight: Radius.circular(20),
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TypingAnimationText(
              text: HelpMockData.welcomeMessage,
              style: AppTextStyles.bodyLarge.copyWith(
                color: AppColors.textPrimary,
                height: 1.4,
              ),
              onComplete: onAnimationComplete,
            ),
          ),
        ),
      ],
    );
  }
}
