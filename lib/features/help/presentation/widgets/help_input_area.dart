import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/constants/app_shapes.dart';

/// Help Input Area - Text input with media attachment
/// [Refactored] Phase 4 — Trích xuất từ ask_for_help_screen.dart
class HelpInputArea extends StatelessWidget {
  final TextEditingController inputController;
  final FocusNode inputFocusNode;
  final List<String> attachedImages;
  final VoidCallback onSend;
  final VoidCallback onMediaTap;
  final ValueChanged<int> onRemoveImage;

  const HelpInputArea({
    super.key,
    required this.inputController,
    required this.inputFocusNode,
    required this.attachedImages,
    required this.onSend,
    required this.onMediaTap,
    required this.onRemoveImage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: AppShapes.paddingM,
        right: AppShapes.paddingM,
        bottom: AppShapes.paddingS,
        top: AppShapes.paddingS,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Attached images preview
          if (attachedImages.isNotEmpty)
            _AttachedImagesPreview(
              attachedImages: attachedImages,
              onRemoveImage: onRemoveImage,
            ),

          // Input row
          Row(
            children: [
              // Plus button for media
              GestureDetector(
                onTap: onMediaTap,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceColor,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.add,
                    color: AppColors.textPrimary,
                    size: 22,
                  ),
                ),
              ),
              const SizedBox(width: 8),

              // Text input
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.7),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: AppColors.primaryPeach.withValues(alpha: 0.5),
                    ),
                  ),
                  child: TextField(
                    controller: inputController,
                    focusNode: inputFocusNode,
                    decoration: InputDecoration(
                      hintText: 'Type your message...',
                      hintStyle: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textHint,
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                    ),
                    style: AppTextStyles.bodyLarge,
                    textInputAction: TextInputAction.send,
                    onSubmitted: (_) => onSend(),
                  ),
                ),
              ),
              const SizedBox(width: 8),

              // Send button
              GestureDetector(
                onTap: onSend,
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.accentOrange,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.accentOrange.withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.send_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Attached Images Preview - Horizontal list of attached images
class _AttachedImagesPreview extends StatelessWidget {
  final List<String> attachedImages;
  final ValueChanged<int> onRemoveImage;

  const _AttachedImagesPreview({
    required this.attachedImages,
    required this.onRemoveImage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      margin: const EdgeInsets.only(bottom: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: attachedImages.length,
        itemBuilder: (context, index) {
          return Container(
            width: 60,
            height: 60,
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: AppColors.surfaceColor,
              border: Border.all(color: AppColors.primaryPeach),
            ),
            child: Stack(
              children: [
                Center(
                  child: Icon(Icons.image, color: AppColors.textHint, size: 28),
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: () => onRemoveImage(index),
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: AppColors.errorRed,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.close,
                        size: 12,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
