import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import 'bouncing_dots.dart';

/// Help Typing Indicator - Shows when bot is typing
/// [Refactored] Phase 4 — Trích xuất từ ask_for_help_screen.dart
class HelpTypingIndicator extends StatelessWidget {
  const HelpTypingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.85),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(4),
                topRight: Radius.circular(20),
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: const BouncingDots(),
          ),
        ],
      ),
    );
  }
}
