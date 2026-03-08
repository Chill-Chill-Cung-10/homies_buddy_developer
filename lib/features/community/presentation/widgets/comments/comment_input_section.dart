/// [Refactored] Phase 3.3 — Extracted from comment_overlay.dart
/// Comment input field with send button + sort dropdown filter
library;

import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_text_styles.dart';
import '../../../../../core/constants/app_shapes.dart';
import '../../../mockdata/comment_mock_data.dart';

class CommentInputSection extends StatelessWidget {
  final TextEditingController commentController;
  final FocusNode commentFocusNode;
  final CommentSortOption selectedSortOption;
  final ValueChanged<CommentSortOption?> onSortChanged;
  final VoidCallback onSendComment;

  const CommentInputSection({
    super.key,
    required this.commentController,
    required this.commentFocusNode,
    required this.selectedSortOption,
    required this.onSortChanged,
    required this.onSendComment,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppShapes.paddingM),
      child: Column(
        children: [
          // Comment Input Field
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppShapes.paddingM,
              vertical: AppShapes.paddingS,
            ),
            decoration: BoxDecoration(
              color: AppColors.surfaceColor,
              borderRadius: BorderRadius.circular(AppShapes.buttonRadius),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: commentController,
                    focusNode: commentFocusNode,
                    decoration: const InputDecoration(
                      hintText: 'Your Comment...',
                      hintStyle: TextStyle(
                        color: AppColors.textHint,
                        fontSize: 14,
                      ),
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textPrimary,
                    ),
                    maxLines: null,
                    textInputAction: TextInputAction.send,
                    onSubmitted: (_) => onSendComment(),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(
                    Icons.send,
                    color: AppColors.accentOrange,
                    size: 24,
                  ),
                  onPressed: onSendComment,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Filter Dropdown
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                child: DropdownButton<CommentSortOption>(
                  value: selectedSortOption,
                  onChanged: onSortChanged,
                  underline: const SizedBox.shrink(),
                  borderRadius: BorderRadius.circular(AppShapes.buttonRadius),
                  isDense: true,
                  icon: const Icon(
                    Icons.arrow_drop_down,
                    color: AppColors.iconColor,
                  ),
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                  items: CommentSortOption.values.map((option) {
                    return DropdownMenuItem(
                      value: option,
                      child: Text(option.displayName),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
