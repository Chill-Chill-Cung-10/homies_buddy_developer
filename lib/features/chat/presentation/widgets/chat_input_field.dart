import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';

/// Chat Input Field Widget
/// 
/// Message input area with send button
class ChatInputField extends StatefulWidget {
  final Function(String) onSendMessage;
  final VoidCallback? onAttachMedia;

  const ChatInputField({
    super.key,
    required this.onSendMessage,
    this.onAttachMedia,
  });

  @override
  State<ChatInputField> createState() => _ChatInputFieldState();
}

class _ChatInputFieldState extends State<ChatInputField> {
  final TextEditingController _controller = TextEditingController();
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {
        _hasText = _controller.text.trim().isNotEmpty;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isNotEmpty) {
      widget.onSendMessage(text);
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.backgroundPost.withOpacity(0.9),
        boxShadow: [
          BoxShadow(
            color: AppColors.textSecondary.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            // Attach media button
            if (widget.onAttachMedia != null)
              IconButton(
                icon: Icon(
                  Icons.add_circle_outline,
                  color: AppColors.accentOrange,
                ),
                onPressed: widget.onAttachMedia,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            const SizedBox(width: 8),
            
            // Text input field
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.cardBackground,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: TextField(
                  controller: _controller,
                  style: AppTextStyles.bodyMedium,
                  decoration: InputDecoration(
                    hintText: 'Send a message...',
                    hintStyle: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                  maxLines: null,
                  textCapitalization: TextCapitalization.sentences,
                  onSubmitted: (_) => _sendMessage(),
                ),
              ),
            ),
            const SizedBox(width: 8),
            
            // Send button
            GestureDetector(
              onTap: _hasText ? _sendMessage : null,
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: _hasText
                      ? AppColors.accentOrange
                      : AppColors.accentOrange.withOpacity(0.3),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.send_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
