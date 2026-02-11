import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../data/models/chat_message_model.dart';

/// Chat bubble widget for user and bot messages
class ChatBubble extends StatelessWidget {
  final ChatMessage message;

  const ChatBubble({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: message.isUser ? _buildUserBubble() : _buildBotBubble(),
    );
  }

  Widget _buildUserBubble() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        const SizedBox(width: 48), // Left margin for alignment
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Attached images
              if (message.imageUrls.isNotEmpty) _buildImageAttachments(),

              // Text bubble
              if (message.text.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.accentOrange.withValues(alpha: 0.2),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(4),
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                  ),
                  child: Text(
                    message.text,
                    style: AppTextStyles.bodyLarge.copyWith(
                      color: AppColors.textPrimary,
                      height: 1.4,
                    ),
                  ),
                ),

              // Timestamp
              Padding(
                padding: const EdgeInsets.only(top: 4, right: 4),
                child: Text(
                  _formatTime(message.timestamp),
                  style: AppTextStyles.caption.copyWith(fontSize: 10),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBotBubble() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Bot avatar
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.surfaceColor,
            border: Border.all(
              color: AppColors.primaryPeach,
              width: 1.5,
            ),
          ),
          child: const Center(
            child: Text('🌱', style: TextStyle(fontSize: 16)),
          ),
        ),
        const SizedBox(width: 8),

        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
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
                child: Text(
                  message.text,
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: AppColors.textPrimary,
                    height: 1.4,
                  ),
                ),
              ),

              // Timestamp
              Padding(
                padding: const EdgeInsets.only(top: 4, left: 4),
                child: Text(
                  _formatTime(message.timestamp),
                  style: AppTextStyles.caption.copyWith(fontSize: 10),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(width: 48), // Right margin for alignment
      ],
    );
  }

  Widget _buildImageAttachments() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Wrap(
        alignment: WrapAlignment.end,
        spacing: 6,
        runSpacing: 6,
        children: message.imageUrls.map((url) {
          return Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: AppColors.surfaceColor,
              border: Border.all(
                color: AppColors.primaryPeach,
                width: 1,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(11),
              child: const Center(
                child: Icon(
                  Icons.image,
                  color: AppColors.textHint,
                  size: 32,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  String _formatTime(DateTime time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}
