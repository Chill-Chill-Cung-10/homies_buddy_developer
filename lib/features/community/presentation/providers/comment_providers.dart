import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../data/models/comment_sort_option.dart';
import '../../data/repositories/comment_repository.dart';
import '../../data/repositories/comment_repository_impl.dart';

// =============================================================================
// REPOSITORY PROVIDER
// =============================================================================

final commentRepositoryProvider = Provider<CommentRepository>((ref) {
  return CommentRepositoryImpl(
    supabase: Supabase.instance.client,
  );
});

// =============================================================================
// COMMENT STATE
// =============================================================================

class CommentState {
  final List<CommentWithReactStatus> comments;
  final bool isLoading;
  final bool isSubmitting; // Loading state khi đang gửi comment
  final bool hasMore;
  final String? errorMessage;
  final CommentSortOption sortOption;

  const CommentState({
    this.comments = const [],
    this.isLoading = false,
    this.isSubmitting = false,
    this.hasMore = true,
    this.errorMessage,
    this.sortOption = CommentSortOption.latest,
  });

  CommentState copyWith({
    List<CommentWithReactStatus>? comments,
    bool? isLoading,
    bool? isSubmitting,
    bool? hasMore,
    String? errorMessage,
    bool clearError = false,
    CommentSortOption? sortOption,
  }) {
    return CommentState(
      comments: comments ?? this.comments,
      isLoading: isLoading ?? this.isLoading,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      hasMore: hasMore ?? this.hasMore,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      sortOption: sortOption ?? this.sortOption,
    );
  }
}

// =============================================================================
// COMMENT NOTIFIER
// =============================================================================

class CommentNotifier extends StateNotifier<CommentState> {
  final CommentRepository _repository;
  final String postId;
  final String? currentUserId;

  int _currentPage = 0;
  static const int _pageSize = 20;

  CommentNotifier({
    required CommentRepository repository,
    required this.postId,
    required this.currentUserId,
  })  : _repository = repository,
        super(const CommentState()) {
    loadComments();
  }

  // ---------------------------------------------------------------------------
  // LOAD COMMENTS (initial + sort change)
  // ---------------------------------------------------------------------------

  Future<void> loadComments({CommentSortOption? sort}) async {
    final sortOption = sort ?? state.sortOption;

    state = state.copyWith(
      isLoading: true,
      clearError: true,
      sortOption: sortOption,
    );

    _currentPage = 0;

    try {
      final result = await _repository.getComments(
        postId,
        sort: sortOption,
        page: 0,
        limit: _pageSize,
        currentUserId: currentUserId,
      );

      state = state.copyWith(
        comments: result.comments,
        hasMore: result.hasMore,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Không thể tải bình luận',
      );
    }
  }

  // ---------------------------------------------------------------------------
  // LOAD MORE (pagination)
  // ---------------------------------------------------------------------------

  Future<void> loadMore() async {
    if (state.isLoading || !state.hasMore) return;

    state = state.copyWith(isLoading: true);
    _currentPage++;

    try {
      final result = await _repository.getComments(
        postId,
        sort: state.sortOption,
        page: _currentPage,
        limit: _pageSize,
        currentUserId: currentUserId,
      );

      state = state.copyWith(
        comments: [...state.comments, ...result.comments],
        hasMore: result.hasMore,
        isLoading: false,
      );
    } catch (e) {
      _currentPage--; // rollback page on error
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Không thể tải thêm bình luận',
      );
    }
  }

  // ---------------------------------------------------------------------------
  // ADD COMMENT
  // ---------------------------------------------------------------------------

  Future<bool> addComment({
    required String authorId,
    required String authorName,
    required String authorAvatar,
    required String content,
  }) async {
    if (content.trim().isEmpty) return false;

    state = state.copyWith(isSubmitting: true, clearError: true);

    try {
      final newComment = await _repository.addComment(
        postId: postId,
        authorId: authorId,
        authorName: authorName,
        authorAvatar: authorAvatar,
        content: content,
      );

      // Thêm comment mới vào đầu list (latest first)
      final newEntry = CommentWithReactStatus(
        comment: newComment,
        isReactedByMe: false,
      );

      state = state.copyWith(
        comments: [newEntry, ...state.comments],
        isSubmitting: false,
      );

      return true;
    } catch (e) {
      state = state.copyWith(
        isSubmitting: false,
        errorMessage: 'Không thể gửi bình luận',
      );
      return false;
    }
  }

  // ---------------------------------------------------------------------------
  // DELETE COMMENT
  // ---------------------------------------------------------------------------

  Future<void> deleteComment(String commentId) async {
    // Optimistic update — xóa khỏi UI trước
    final previousComments = state.comments;
    state = state.copyWith(
      comments: state.comments
          .where((c) => c.comment.commentId != commentId)
          .toList(),
    );

    try {
      await _repository.deleteComment(
        commentId: commentId,
        authorId: currentUserId ?? '',
        postId: postId,
      );
    } catch (e) {
      // Rollback nếu lỗi
      state = state.copyWith(
        comments: previousComments,
        errorMessage: 'Không thể xóa bình luận',
      );
    }
  }

  // ---------------------------------------------------------------------------
  // TOGGLE REACT
  // ---------------------------------------------------------------------------

  Future<void> toggleReact(String commentId) async {
    if (currentUserId == null) return;

    // Optimistic update
    final previousComments = state.comments;
    state = state.copyWith(
      comments: state.comments.map((entry) {
        if (entry.comment.commentId != commentId) return entry;

        final wasReacted = entry.isReactedByMe;
        return CommentWithReactStatus(
          comment: entry.comment.copyWith(
            reactCount: entry.comment.reactCount + (wasReacted ? -1 : 1),
          ),
          isReactedByMe: !wasReacted,
        );
      }).toList(),
    );

    try {
      await _repository.toggleCommentReact(commentId, currentUserId!);
    } catch (e) {
      // Rollback nếu lỗi
      state = state.copyWith(comments: previousComments);
    }
  }

  // ---------------------------------------------------------------------------
  // CHANGE SORT
  // ---------------------------------------------------------------------------

  Future<void> changeSort(CommentSortOption sort) async {
    if (sort == state.sortOption) return;
    await loadComments(sort: sort);
  }
}

// =============================================================================
// PROVIDER FACTORY — dùng family vì mỗi post có comment riêng
// =============================================================================

/// Params để identify provider theo postId + userId
class CommentProviderParams {
  final String postId;
  final String? currentUserId;

  const CommentProviderParams({
    required this.postId,
    this.currentUserId,
  });

  @override
  bool operator ==(Object other) =>
      other is CommentProviderParams &&
      other.postId == postId &&
      other.currentUserId == currentUserId;

  @override
  int get hashCode => Object.hash(postId, currentUserId);
}

final commentProvider = StateNotifierProvider.family<
    CommentNotifier, CommentState, CommentProviderParams>(
  (ref, params) => CommentNotifier(
    repository: ref.watch(commentRepositoryProvider),
    postId: params.postId,
    currentUserId: params.currentUserId,
  ),
);