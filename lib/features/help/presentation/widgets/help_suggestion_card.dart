import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../data/models/chat_message_model.dart';

/// Help Suggestion Card - displays help topic with icon and pastel background
class HelpSuggestionCard extends StatelessWidget {
  final HelpSuggestion suggestion;
  final VoidCallback? onTap;

  const HelpSuggestionCard({
    super.key,
    required this.suggestion,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cardData = _getCardVisuals(suggestion.iconType);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: cardData.backgroundColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon area
              Expanded(
                child: Center(
                  child: Text(
                    cardData.emoji,
                    style: const TextStyle(fontSize: 44),
                  ),
                ),
              ),

              const SizedBox(height: 8),

              // Title
              Text(
                suggestion.title,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.bodyLarge.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                  fontSize: 15,
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _CardVisuals _getCardVisuals(IconType type) {
    switch (type) {
      case IconType.plant:
        return _CardVisuals(
          emoji: '🌿💧',
          backgroundColor: const Color(0xFFD8EDCF),
        );
      case IconType.pet:
        return _CardVisuals(
          emoji: '🐑✨',
          backgroundColor: const Color(0xFFF5DEC4),
        );
      case IconType.health:
        return _CardVisuals(
          emoji: '🏥💚',
          backgroundColor: const Color(0xFFD4E8E0),
        );
      case IconType.training:
        return _CardVisuals(
          emoji: '🎯🐾',
          backgroundColor: const Color(0xFFE6D8F0),
        );
      case IconType.nutrition:
        return _CardVisuals(
          emoji: '🥗🍎',
          backgroundColor: const Color(0xFFFFE8D0),
        );
      case IconType.grooming:
        return _CardVisuals(
          emoji: '✂️🧴',
          backgroundColor: const Color(0xFFD8E8F0),
        );
    }
  }
}

class _CardVisuals {
  final String emoji;
  final Color backgroundColor;

  const _CardVisuals({
    required this.emoji,
    required this.backgroundColor,
  });
}
