import 'dart:async';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/constants/app_shapes.dart';
import '../../../../data/models/post_model.dart';
import '../../../../data/models/comment_model.dart';
import '../../mockdata/comment_mock_data.dart';
import 'comments/comment_item.dart';
import 'comments/comment_input_section.dart';
import 'comments/comment_post_preview.dart';

/// [Refactored] Phase 3.3 — Split into CommentItem, CommentInputSection,
/// CommentPostPreview sub-widgets.
///
/// Comment Overlay - Instagram-style comment bottom sheet
/// Hiển thị comment overlay với post preview, comment input, filter, và comment list
class CommentOverlay extends StatefulWidget {
  final Post post;
  final String? highlightCommentId;

  const CommentOverlay({
    super.key,
    required this.post,
    this.highlightCommentId,
  });

  @override
  State<CommentOverlay> createState() => _CommentOverlayState();
}

class _CommentOverlayState extends State<CommentOverlay> {
  final TextEditingController _commentController = TextEditingController();
  final FocusNode _commentFocusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();
  final Map<String, GlobalKey> _commentKeys = {};

  late List<Comment> _comments;
  late Post _post; // Local post state for managing reactions
  CommentSortOption _selectedSortOption = CommentSortOption.latest;
  String? _currentHighlightedCommentId;
  double _highlightOpacity = 0.2; // Opacity for smooth fade-out
  EdgeInsets _highlightPadding = const EdgeInsets.symmetric(
    horizontal: 8,
    vertical: 4,
  ); // Padding for smooth size transition
  Timer? _highlightTimer;

  @override
  void initState() {
    super.initState();
    _currentHighlightedCommentId = widget.highlightCommentId;
    _post = widget.post; // Initialize local post state
    _loadComments();

    // Scroll to highlighted comment after build
    if (widget.highlightCommentId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToHighlightedComment();
      });

      // Start fade-out timer (2.5 seconds hold, then 800ms fade)
      _highlightTimer = Timer(const Duration(milliseconds: 2000), () {
        if (mounted) {
          // Animate both opacity and padding to 0 smoothly
          setState(() {
            _highlightOpacity = 0.0;
            _highlightPadding = EdgeInsets.zero; // Remove padding smoothly
          });

          // After fade-out animation completes, remove highlight
          Future.delayed(const Duration(milliseconds: 800), () {
            if (mounted) {
              setState(() {
                _currentHighlightedCommentId = null;
                // Reset for next time
                _highlightOpacity = 0.2;
                _highlightPadding = const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                );
              });
            }
          });
        }
      });
    }
  }

  void _loadComments() {
    final comments = CommentMockData.getCommentsForPost(widget.post.postId);
    setState(() {
      _comments = CommentMockData.sortComments(comments, _selectedSortOption);
    });
  }

  @override
  void dispose() {
    _commentController.dispose();
    _commentFocusNode.dispose();
    _scrollController.dispose();
    _highlightTimer?.cancel();
    super.dispose();
  }

  void _scrollToHighlightedComment() {
    if (widget.highlightCommentId == null) return;

    final key = _commentKeys[widget.highlightCommentId];
    if (key?.currentContext != null) {
      Scrollable.ensureVisible(
        key!.currentContext!,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        alignment: 0.3, // Position comment at 30% from top
      );
    }
  }

  void _handleSortChanged(CommentSortOption? newOption) {
    if (newOption != null) {
      setState(() {
        _selectedSortOption = newOption;
        _loadComments();
      });
    }
  }

  void _handleSendComment() {
    if (_commentController.text.trim().isEmpty) return;

    // TODO: Implement send comment logic
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Comment sent: ${_commentController.text}'),
        duration: const Duration(seconds: 1),
        backgroundColor: AppColors.accentOrange,
      ),
    );

    _commentController.clear();
    _commentFocusNode.unfocus();
  }

  void _handleCommentReact(Comment comment) {
    // isReactedByMe is now computed from COMMENT_REACTS junction table
    // Update logic will be handled via repository/state management
    setState(() {
      final index = _comments.indexWhere(
        (c) => c.commentId == comment.commentId,
      );
      if (index != -1) {
        _comments[index] = comment.copyWith(
          reactCount:
              comment.reactCount + 1, // Placeholder - will be updated via state
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: const BoxDecoration(
        color: AppColors.backgroundPost,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppShapes.cardRadius),
        ),
      ),
      child: Column(
        children: [
          // Drag Handle
          _buildDragHandle(),

          // Scrollable content (Post Preview + Comments)
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Post Preview using SocialPostCard
                  _buildPostPreview(),

                  // Divider
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppShapes.paddingM,
                    ),
                    child: const Divider(height: 1, color: AppColors.textHint),
                  ),

                  // Comment Input & Filter Section
                  _buildCommentInputSection(),

                  // Comments List
                  _buildCommentsList(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Drag handle at top
  Widget _buildDragHandle() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      width: 40,
      height: 4,
      decoration: BoxDecoration(
        color: AppColors.textHint.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  /// Post Preview Section - Reusing CommentPostPreview
  Widget _buildPostPreview() {
    return CommentPostPreview(
      post: _post,
      onLike: () {
        // isLikedByMe is now computed from POST_LIKES junction table
        // Update logic will be handled via repository/state management
        setState(() {
          _post = _post.copyWith(
            reactsCount:
                _post.reactsCount +
                1, // Placeholder - will be updated via state
          );
        });
      },
      onAvatarTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Profile: ${_post.authorName}'),
            duration: const Duration(seconds: 1),
          ),
        );
      },
    );
  }

  /// Comment Input & Filter Section
  Widget _buildCommentInputSection() {
    return CommentInputSection(
      commentController: _commentController,
      commentFocusNode: _commentFocusNode,
      selectedSortOption: _selectedSortOption,
      onSortChanged: _handleSortChanged,
      onSendComment: _handleSendComment,
    );
  }

  /// Comments List
  Widget _buildCommentsList() {
    if (_comments.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(AppShapes.paddingXL),
        child: Center(
          child: Column(
            children: [
              Icon(
                Icons.comment_outlined,
                size: 48,
                color: AppColors.textHint.withValues(alpha: 0.5),
              ),
              const SizedBox(height: 8),
              Text(
                'No comments yet',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textHint,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Be the first to comment!',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textHint,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(
        horizontal: AppShapes.paddingM,
        vertical: AppShapes.paddingS,
      ),
      itemCount: _comments.length,
      itemBuilder: (context, index) {
        final comment = _comments[index];
        final isHighlighted = _currentHighlightedCommentId == comment.commentId;

        // Create GlobalKey for this comment if it's highlighted
        if (isHighlighted && !_commentKeys.containsKey(comment.commentId)) {
          _commentKeys[comment.commentId] = GlobalKey();
        }

        return CommentItem(
          comment: comment,
          isHighlighted: isHighlighted,
          highlightOpacity: _highlightOpacity,
          highlightPadding: _highlightPadding,
          commentKey: _commentKeys[comment.commentId],
          onReact: _handleCommentReact,
        );
      },
    );
  }

  // [Refactored] Phase 1.5 — _formatCount chuyển sang core/utils/formatters.dart.
}

/// Helper function to show comment overlay
void showCommentOverlay(
  BuildContext context,
  Post post, {
  String? highlightCommentId,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) =>
        CommentOverlay(post: post, highlightCommentId: highlightCommentId),
  );
}
