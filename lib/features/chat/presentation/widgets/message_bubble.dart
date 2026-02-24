import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../data/models/models.dart';
import 'message_status_indicator.dart';

/// Message Bubble Widget
/// 
/// Displays a chat message bubble
class MessageBubble extends StatelessWidget {
  final Message message;
  final bool isMe;

  const MessageBubble({
    super.key,
    required this.message,
    required this.isMe,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: isMe ? 48 : 0,
        right: isMe ? 0 : 48,
        bottom: 12,
      ),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: isMe
                  ? AppColors.accentOrange.withOpacity(0.15)
                  : AppColors.backgroundPost.withOpacity(0.9),
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(20),
                topRight: const Radius.circular(20),
                bottomLeft: Radius.circular(isMe ? 20 : 4),
                bottomRight: Radius.circular(isMe ? 4 : 20),
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.textSecondary.withOpacity(0.06),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              child: message.type == MessageType.text
                  ? _buildTextMessage()
                  : _buildImageMessage(),
            ),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                DateFormat('HH:mm').format(message.createdAt),
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 10,
                ),
              ),
              if (isMe) ...[
                const SizedBox(width: 4),
                MessageStatusIndicator(status: message.status),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTextMessage() {
    return Text(
      message.content,
      style: AppTextStyles.bodyMedium.copyWith(
        color: isMe
            ? AppColors.textPrimary
            : AppColors.textPrimary,
        height: 1.4,
      ),
    );
  }

  Widget _buildImageMessage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.network(
        message.content,
        width: 200,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            width: 200,
            height: 200,
            color: Colors.grey.shade200,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: 200,
            height: 200,
            color: Colors.grey.shade200,
            child: const Icon(Icons.broken_image),
          );
        },
      ),
    );
  }
}
