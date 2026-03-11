import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/constants/app_shapes.dart';
import '../../../../data/models/post_model.dart';
import '../../../../data/models/comment_model.dart';
import '../../data/models/comment_sort_option.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import 'comments/comment_item.dart';
import 'comments/comment_input_section.dart';
import 'comments/comment_post_preview.dart';
import '../providers/comment_providers.dart';
import '../providers/community_providers.dart';

/// Comment Overlay - Instagram-style comment bottom sheet
/// Kết nối với CommentRepository qua Riverpod providers
class CommentOverlay extends ConsumerStatefulWidget {
  final Post post;

  /// Trạng thái like ban đầu — truyền từ feed để render đúng ngay khi mở overlay
  final bool isLikedByMe;

  final String? highlightCommentId;

  const CommentOverlay({
    super.key,
    required this.post,
    required this.isLikedByMe,
    this.highlightCommentId,
  });

  @override
  ConsumerState<CommentOverlay> createState() => _CommentOverlayState();
}

class _CommentOverlayState extends ConsumerState<CommentOverlay> {
  final TextEditingController _commentController = TextEditingController();
  final FocusNode _commentFocusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();
  final Map<String, GlobalKey> _commentKeys = {};

  late Post _post;

  /// Optimistic like state — phản ánh UI ngay lập tức
  late bool _isLikedByMe;

  /// Guard chống double-tap: true trong khi đang chờ Supabase phản hồi
  bool _isLikeProcessing = false;

  String? _currentHighlightedCommentId;
  double _highlightOpacity = 0.2;
  EdgeInsets _highlightPadding = const EdgeInsets.symmetric(
    horizontal: 8,
    vertical: 4,
  );
  Timer? _highlightTimer;

  // Provider params — computed once
  late CommentProviderParams _providerParams;

  @override
  void initState() {
    super.initState();
    _post = widget.post;
    _isLikedByMe = widget.isLikedByMe;
    _currentHighlightedCommentId = widget.highlightCommentId;

    final currentUserId = ref.read(currentAuthUserProvider)?.id;
    _providerParams = CommentProviderParams(
      postId: widget.post.postId,
      currentUserId: currentUserId,
    );

    if (widget.highlightCommentId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToHighlightedComment();
      });

      _highlightTimer = Timer(const Duration(milliseconds: 2000), () {
        if (mounted) {
          setState(() {
            _highlightOpacity = 0.0;
            _highlightPadding = EdgeInsets.zero;
          });

          Future.delayed(const Duration(milliseconds: 800), () {
            if (mounted) {
              setState(() {
                _currentHighlightedCommentId = null;
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

    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _commentController.dispose();
    _commentFocusNode.dispose();
    _scrollController.dispose();
    _highlightTimer?.cancel();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.85) {
      ref.read(commentProvider(_providerParams).notifier).loadMore();
    }
  }

  void _scrollToHighlightedComment() {
    if (widget.highlightCommentId == null) return;
    final key = _commentKeys[widget.highlightCommentId];
    if (key?.currentContext != null) {
      Scrollable.ensureVisible(
        key!.currentContext!,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        alignment: 0.3,
      );
    }
  }

  /// Optimistic like toggle:
  /// 1. Guard _isLikeProcessing chặn double-tap
  /// 2. Cập nhật UI ngay (optimistic)
  /// 3. Gọi repository qua communityFeedProvider để đồng bộ với feed
  /// 4. Rollback nếu Supabase trả về lỗi
  Future<void> _handleToggleLike() async {
    if (_isLikeProcessing) return;

    final user = ref.read(currentAuthUserProvider);
    if (user == null) return;

    final wasLiked = _isLikedByMe;
    setState(() {
      _isLikeProcessing = true;
      _isLikedByMe = !wasLiked;
      _post = _post.copyWith(
        reactsCount: _isLikedByMe
            ? _post.reactsCount + 1
            : (_post.reactsCount - 1).clamp(0, double.maxFinite).toInt(),
      );
    });

    try {
      await ref.read(communityFeedProvider.notifier).toggleLike(_post.postId);
    } catch (_) {
      // Rollback nếu lỗi
      if (mounted) {
        setState(() {
          _isLikedByMe = wasLiked;
          _post = _post.copyWith(
            reactsCount: wasLiked
                ? _post.reactsCount + 1
                : (_post.reactsCount - 1).clamp(0, double.maxFinite).toInt(),
          );
        });
      }
    } finally {
      if (mounted) {
        setState(() => _isLikeProcessing = false);
      }
    }
  }

  Future<void> _handleSendComment() async {
    final content = _commentController.text.trim();
    if (content.isEmpty) return;

    final user = ref.read(currentAuthUserProvider);
    if (user == null) return;

    _commentController.clear();
    _commentFocusNode.unfocus();

    final success = await ref
        .read(commentProvider(_providerParams).notifier)
        .addComment(
          authorId: user.id,
          authorName: user.fullName,
          authorAvatar: user.avatarUrl ?? '',
          content: content,
        );

    if (!success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Không thể gửi bình luận'),
          backgroundColor: AppColors.errorRed,
        ),
      );
    }
  }

  void _handleSortChanged(CommentSortOption? newOption) {
    if (newOption == null) return;
    ref.read(commentProvider(_providerParams).notifier).changeSort(newOption);
  }

  void _handleToggleReact(Comment comment) {
    ref
        .read(commentProvider(_providerParams).notifier)
        .toggleReact(comment.commentId);
  }

  void _handleDeleteComment(String commentId) {
    ref
        .read(commentProvider(_providerParams).notifier)
        .deleteComment(commentId);
  }

  @override
  Widget build(BuildContext context) {
    final commentState = ref.watch(commentProvider(_providerParams));
    final currentUserId = ref.watch(currentAuthUserProvider)?.id;

    ref.listen<CommentState>(commentProvider(_providerParams), (prev, next) {
      if (next.errorMessage != null &&
          next.errorMessage != prev?.errorMessage) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.errorMessage!),
            backgroundColor: AppColors.errorRed,
          ),
        );
      }
    });

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
          _buildDragHandle(),
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildPostPreview(),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppShapes.paddingM,
                    ),
                    child: const Divider(height: 1, color: AppColors.textHint),
                  ),
                  _buildCommentInputSection(commentState),
                  _buildCommentsList(commentState, currentUserId),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

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

  Widget _buildPostPreview() {
    return CommentPostPreview(
      post: _post,
      isLikedByMe: _isLikedByMe,
      isLikeProcessing: _isLikeProcessing,
      onLike: _handleToggleLike,
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

  Widget _buildCommentInputSection(CommentState commentState) {
    return CommentInputSection(
      commentController: _commentController,
      commentFocusNode: _commentFocusNode,
      selectedSortOption: commentState.sortOption,
      onSortChanged: _handleSortChanged,
      onSendComment: _handleSendComment,
      isSubmitting: commentState.isSubmitting,
    );
  }

  Widget _buildCommentsList(CommentState commentState, String? currentUserId) {
    if (commentState.isLoading && commentState.comments.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(AppShapes.paddingXL),
        child: Center(
          child: CircularProgressIndicator(color: AppColors.accentOrange),
        ),
      );
    }

    if (commentState.comments.isEmpty) {
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

    return Column(
      children: [
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(
            horizontal: AppShapes.paddingM,
            vertical: AppShapes.paddingS,
          ),
          itemCount: commentState.comments.length,
          itemBuilder: (context, index) {
            final entry = commentState.comments[index];
            final comment = entry.comment;
            final isHighlighted =
                _currentHighlightedCommentId == comment.commentId;

            if (isHighlighted &&
                !_commentKeys.containsKey(comment.commentId)) {
              _commentKeys[comment.commentId] = GlobalKey();
            }

            return CommentItem(
              comment: comment,
              isReactedByMe: entry.isReactedByMe,
              isHighlighted: isHighlighted,
              highlightOpacity: _highlightOpacity,
              highlightPadding: _highlightPadding,
              commentKey: _commentKeys[comment.commentId],
              onReact: _handleToggleReact,
              onDelete: comment.authorId == currentUserId
                  ? () => _handleDeleteComment(comment.commentId)
                  : null,
            );
          },
        ),

        if (commentState.isLoading && commentState.comments.isNotEmpty)
          const Padding(
            padding: EdgeInsets.all(16),
            child: Center(
              child: CircularProgressIndicator(color: AppColors.accentOrange),
            ),
          ),

        if (!commentState.hasMore && commentState.comments.isNotEmpty)
          Padding(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: Text(
                'Đã xem hết bình luận',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textHint,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

/// Helper function để show comment overlay
///
/// [isLikedByMe] bắt buộc — lấy từ feedState.likedPostIds.contains(post.postId)
void showCommentOverlay(
  BuildContext context,
  Post post, {
  required bool isLikedByMe,
  String? highlightCommentId,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => CommentOverlay(
      post: post,
      isLikedByMe: isLikedByMe,
      highlightCommentId: highlightCommentId,
    ),
  );
}