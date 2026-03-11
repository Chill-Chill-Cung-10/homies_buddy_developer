/// [Refactored] Phase 3.2 — Extracted from social_post_card.dart
/// [Updated] — isLikeProcessing guard chống double-tap ở cả feed lẫn comment overlay
library;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_shapes.dart';
import '../../../../../core/utils/formatters.dart';
import '../../../../../data/models/post_model.dart';

class PostFooter extends StatefulWidget {
  final Post post;
  final bool isLikedByMe;

  /// Khi true, nút like bị vô hiệu hoá — tránh race condition / double-tap
  final bool isLikeProcessing;

  final VoidCallback? onLike;
  final VoidCallback? onComment;
  final bool isCommentHighlighted;

  const PostFooter({
    super.key,
    required this.post,
    this.isLikedByMe = false,
    this.isLikeProcessing = false,
    this.onLike,
    this.onComment,
    this.isCommentHighlighted = false,
  });

  @override
  State<PostFooter> createState() => _PostFooterState();
}

class _PostFooterState extends State<PostFooter>
    with SingleTickerProviderStateMixin {
  late AnimationController _heartAnimationController;
  late Animation<double> _heartScaleAnimation;

  @override
  void initState() {
    super.initState();
    _heartAnimationController = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );
    _heartScaleAnimation = Tween<double>(begin: 1.0, end: 1.35).animate(
      CurvedAnimation(
        parent: _heartAnimationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _heartAnimationController.dispose();
    super.dispose();
  }

  void _handleLike() {
    // Guard: không xử lý nếu đang pending hoặc không có callback
    if (widget.isLikeProcessing || widget.onLike == null) return;

    _heartAnimationController.forward().then((_) {
      _heartAnimationController.reverse();
    });
    widget.onLike!();
  }

  @override
  Widget build(BuildContext context) {
    final isLiked = widget.isLikedByMe;

    return Padding(
      padding: const EdgeInsets.all(AppShapes.paddingM),
      child: Row(
        children: [
          // Heart/Like Button
          GestureDetector(
            onTap: _handleLike,
            child: Row(
              children: [
                ScaleTransition(
                  scale: _heartScaleAnimation,
                  child: SvgPicture.asset(
                    isLiked
                        ? 'assets/images/icons/heart_reactions_on.svg'
                        : 'assets/images/icons/heart_reactions_off.svg',
                    width: 24,
                    height: 24,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  formatCount(widget.post.reactsCount),
                  style: TextStyle(
                    fontFamily: 'Norican',
                    fontSize: 16,
                    color: isLiked ? AppColors.errorRed : AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 24),

          // Comment Button
          GestureDetector(
            onTap: widget.isCommentHighlighted ? null : widget.onComment,
            child: Container(
              padding: widget.isCommentHighlighted
                  ? const EdgeInsets.symmetric(horizontal: 12, vertical: 6)
                  : EdgeInsets.zero,
              decoration: widget.isCommentHighlighted
                  ? BoxDecoration(
                      color: AppColors.accentOrange.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: AppColors.accentOrange.withValues(alpha: 0.5),
                        width: 1,
                      ),
                    )
                  : null,
              child: Row(
                children: [
                  SvgPicture.asset(
                    'assets/images/icons/comments.svg',
                    width: 24,
                    height: 24,
                    colorFilter: ColorFilter.mode(
                      widget.isCommentHighlighted
                          ? AppColors.accentOrange
                          : AppColors.iconColor,
                      BlendMode.srcIn,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    formatCount(widget.post.commentCount),
                    style: TextStyle(
                      fontFamily: 'Norican',
                      fontSize: 16,
                      color: widget.isCommentHighlighted
                          ? AppColors.accentOrange
                          : AppColors.textPrimary,
                      fontWeight: widget.isCommentHighlighted
                          ? FontWeight.w600
                          : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const Spacer(),
        ],
      ),
    );
  }
}