import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/constants/app_shapes.dart';
import '../../../../data/models/post_model.dart';
import '../../../../data/models/comment_model.dart';
import '../../mockdata/comment_mock_data.dart';
import 'social_post_card.dart';

/// Comment Overlay - Instagram-style comment bottom sheet
/// 
/// Hiển thị comment overlay với post preview, comment input, filter, và comment list
class CommentOverlay extends StatefulWidget {
  final Post post;

  const CommentOverlay({
    super.key,
    required this.post,
  });

  @override
  State<CommentOverlay> createState() => _CommentOverlayState();
}

class _CommentOverlayState extends State<CommentOverlay> {
  final TextEditingController _commentController = TextEditingController();
  final FocusNode _commentFocusNode = FocusNode();
  late List<Comment> _comments;
  CommentSortOption _selectedSortOption = CommentSortOption.latest;
  
  @override
  void initState() {
    super.initState();
    _loadComments();
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
    super.dispose();
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
    setState(() {
      final index = _comments.indexWhere((c) => c.commentId == comment.commentId);
      if (index != -1) {
        _comments[index] = comment.copyWith(
          isReactedByMe: !comment.isReactedByMe,
          reactCount: comment.isReactedByMe
              ? comment.reactCount - 1
              : comment.reactCount + 1,
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Post Preview using SocialPostCard
                  _buildPostPreview(),
                  
                  // Divider
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppShapes.paddingM),
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

  /// Post Preview Section - Reusing SocialPostCard for consistency
  Widget _buildPostPreview() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppShapes.paddingM, vertical: AppShapes.paddingS),
      child: SocialPostCard(
        post: widget.post,
        // Disable interactions in preview to avoid conflicts
        onLike: null,
        onComment: null,
        onAvatarTap: null,
        onPostTap: null,
      ),
    );
  }

  /// Comment Input & Filter Section
  Widget _buildCommentInputSection() {
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
                    controller: _commentController,
                    focusNode: _commentFocusNode,
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
                    onSubmitted: (_) => _handleSendComment(),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(
                    Icons.send,
                    color: AppColors.accentOrange,
                    size: 24,
                  ),
                  onPressed: _handleSendComment,
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
                // decoration: BoxDecoration(
                //   border: Border.all(color: AppColors.textHint.withValues(alpha: 0.3)),
                //   borderRadius: BorderRadius.circular(AppShapes.iconRadius),
                // ),
                child: DropdownButton<CommentSortOption>(
                  value: _selectedSortOption,
                  onChanged: _handleSortChanged,
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
        return _buildCommentItem(comment);
      },
    );
  }

  /// Single Comment Item
  Widget _buildCommentItem(Comment comment) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppShapes.paddingM),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Commenter Avatar
          ClipOval(
            child: CachedNetworkImage(
              imageUrl: comment.authorAvatar,
              width: 36,
              height: 36,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                width: 36,
                height: 36,
                color: AppColors.surfaceColor,
                child: const Icon(
                  Icons.person,
                  size: 18,
                  color: AppColors.textHint,
                ),
              ),
              errorWidget: (context, url, error) => Container(
                width: 36,
                height: 36,
                color: AppColors.surfaceColor,
                child: const Icon(
                  Icons.person,
                  size: 18,
                  color: AppColors.textHint,
                ),
              ),
            ),
          ),
          
          const SizedBox(width: 12),
          
          // Comment Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Comment Bubble
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppShapes.paddingM,
                    vertical: AppShapes.paddingS + 2,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceColor,
                    borderRadius: BorderRadius.circular(AppShapes.buttonRadius),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Commenter Name
                      Text(
                        comment.authorName,
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      
                      // Comment Text
                      Text(
                        comment.contentText,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 6),
                
                // Comment Meta (Like count + Time)
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => _handleCommentReact(comment),
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            comment.isReactedByMe
                                ? 'assets/images/icons/heart_reactions_on.svg'
                                : 'assets/images/icons/heart_reactions_off.svg',
                            width: 14,
                            height: 14,
                            colorFilter: ColorFilter.mode(
                              comment.isReactedByMe
                                  ? AppColors.errorRed
                                  : AppColors.iconColor,
                              BlendMode.srcIn,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            comment.reactCount > 0
                                ? 'Thích ${_formatCount(comment.reactCount)}'
                                : 'Thích',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: comment.isReactedByMe
                                  ? AppColors.errorRed
                                  : AppColors.textHint,
                              fontWeight: comment.isReactedByMe
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(width: 16),
                    
                    // Time
                    Text(
                      comment.timeAgo,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textHint,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatCount(int count) {
    if (count >= 1000000) {
      return '${(count / 1000000).toStringAsFixed(1)}M';
    } else if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}K';
    }
    return count.toString();
  }
}

/// Helper function to show comment overlay
void showCommentOverlay(BuildContext context, Post post) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => CommentOverlay(post: post),
  );
}
