import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/constants/database_tables.dart';
import '../../../../data/models/comment_model.dart';
import '../models/comment_sort_option.dart';
import 'comment_repository.dart';

/// Comment Repository Implementation using Supabase
///
/// Tables used:
/// - feed_comment: Comment data storage
/// - comment_reacts: Junction table for user reactions
///
/// Triggers handle count updates automatically:
/// - comment_reacts INSERT/DELETE → feed_comment.react_count (trigger)
/// - feed_comment INSERT/DELETE → feed_post.comment_count (trigger)
class CommentRepositoryImpl implements CommentRepository {
  final SupabaseClient _supabase;

  CommentRepositoryImpl({SupabaseClient? supabase})
      : _supabase = supabase ?? Supabase.instance.client;

  // =========================================================================
  // GET COMMENTS
  // =========================================================================

  @override
  Future<CommentListResult> getComments(
    String postId, {
    CommentSortOption sort = CommentSortOption.latest,
    int page = 0,
    int limit = 20,
    String? currentUserId,
  }) async {
    try {
      final offset = page * limit;

      final String sortColumn;
      final bool ascending;
      switch (sort) {
        case CommentSortOption.latest:
          sortColumn = FeedCommentTable.createdAt;
          ascending = false;
        case CommentSortOption.oldest:
          sortColumn = FeedCommentTable.createdAt;
          ascending = true;
        case CommentSortOption.mostReacted:
          sortColumn = FeedCommentTable.reactCount;
          ascending = false;
      }

      // Fetch limit+1 để detect hasMore
      final response = await _supabase
          .from(FeedCommentTable.name)
          .select()
          .eq(FeedCommentTable.postId, postId)
          .order(sortColumn, ascending: ascending)
          .range(offset, offset + limit); // limit+1 rows

      final rows = response as List;

      final hasMore = rows.length == limit + 1;
      if (hasMore) rows.removeLast();

      if (rows.isEmpty) {
        return const CommentListResult(comments: [], hasMore: false);
      }

      // Batch check is_reacted_by_me — 1 query cho tất cả comments
      final reactedSet = await _batchGetReactedCommentIds(
        commentIds:
            rows.map((r) => r[FeedCommentTable.commentId] as String).toList(),
        userId: currentUserId,
      );

      final comments = rows
          .map((row) => CommentWithReactStatus(
                comment: _mapRowToComment(row),
                isReactedByMe:
                    reactedSet.contains(row[FeedCommentTable.commentId]),
              ))
          .toList();

      return CommentListResult(comments: comments, hasMore: hasMore);
    } catch (e) {
      throw CommentRepositoryException('Failed to fetch comments', e);
    }
  }

  // =========================================================================
  // ADD COMMENT
  // =========================================================================

  @override
  Future<Comment> addComment({
    required String postId,
    required String authorId,
    required String authorName,
    required String authorAvatar,
    required String content,
  }) async {
    try {
      if (content.trim().isEmpty) {
        throw CommentRepositoryException('Comment content cannot be empty');
      }

      if (content.length > 2000) {
        throw CommentRepositoryException(
            'Comment too long (max 2000 characters)');
      }

      // Insert comment — trigger tự INCREMENT feed_post.comment_count
      final response = await _supabase
          .from(FeedCommentTable.name)
          .insert({
            FeedCommentTable.postId: postId,
            FeedCommentTable.authorId: authorId,
            FeedCommentTable.authorName: authorName,
            FeedCommentTable.authorAvatar: authorAvatar,
            FeedCommentTable.contentText: content.trim(),
            FeedCommentTable.reactCount: 0,
          })
          .select()
          .single();

      // Không cần gọi RPC — trigger đã tự tăng comment_count

      return _mapRowToComment(response);
    } catch (e) {
      if (e is CommentRepositoryException) rethrow;
      throw CommentRepositoryException('Failed to add comment', e);
    }
  }

  // =========================================================================
  // DELETE COMMENT
  // =========================================================================

  @override
  Future<void> deleteComment({
    required String commentId,
    required String authorId,
    required String postId,
  }) async {
    try {
      // Verify ownership
      final comment = await _supabase
          .from(FeedCommentTable.name)
          .select(FeedCommentTable.authorId)
          .eq(FeedCommentTable.commentId, commentId)
          .maybeSingle();

      if (comment == null) {
        throw CommentRepositoryException('Comment not found');
      }

      if (comment[FeedCommentTable.authorId] != authorId) {
        throw CommentRepositoryException(
            'Not authorized to delete this comment');
      }

      // Xóa reactions trước (phòng khi chưa có ON DELETE CASCADE)
      await _supabase
          .from(CommentReactsTable.name)
          .delete()
          .eq(CommentReactsTable.commentId, commentId);

      // Xóa comment — trigger tự DECREMENT feed_post.comment_count
      await _supabase
          .from(FeedCommentTable.name)
          .delete()
          .eq(FeedCommentTable.commentId, commentId);

      // Không cần gọi RPC — trigger đã tự giảm comment_count
    } catch (e) {
      if (e is CommentRepositoryException) rethrow;
      throw CommentRepositoryException('Failed to delete comment', e);
    }
  }

  // =========================================================================
  // TOGGLE COMMENT REACT
  // =========================================================================

  @override
  Future<bool> toggleCommentReact(String commentId, String userId) async {
    try {
      final isCurrentlyReacted = await isReactedByUser(commentId, userId);

      if (isCurrentlyReacted) {
        // Unreact — trigger tự DECREMENT feed_comment.react_count
        await _supabase
            .from(CommentReactsTable.name)
            .delete()
            .eq(CommentReactsTable.commentId, commentId)
            .eq(CommentReactsTable.userId, userId);

        return false;
      } else {
        // React — trigger tự INCREMENT feed_comment.react_count
        await _supabase.from(CommentReactsTable.name).insert({
          CommentReactsTable.commentId: commentId,
          CommentReactsTable.userId: userId,
        });

        return true;
      }
    } catch (e) {
      throw CommentRepositoryException('Failed to toggle reaction', e);
    }
  }

  // =========================================================================
  // IS REACTED BY USER
  // =========================================================================

  @override
  Future<bool> isReactedByUser(String commentId, String userId) async {
    try {
      final response = await _supabase
          .from(CommentReactsTable.name)
          .select(CommentReactsTable.userId)
          .eq(CommentReactsTable.commentId, commentId)
          .eq(CommentReactsTable.userId, userId)
          .maybeSingle();

      return response != null;
    } catch (e) {
      return false;
    }
  }

  // =========================================================================
  // GET COMMENT COUNT
  // =========================================================================

  @override
  Future<int> getCommentCount(String postId) async {
    try {
      final response = await _supabase
          .from(FeedPostTable.name)
          .select(FeedPostTable.commentCount)
          .eq(FeedPostTable.postId, postId)
          .maybeSingle();

      return response?[FeedPostTable.commentCount] as int? ?? 0;
    } catch (e) {
      return 0;
    }
  }

  // =========================================================================
  // PRIVATE HELPERS
  // =========================================================================

  /// Batch check reacted comments — 1 query thay vì N queries
  /// Trả về Set<commentId> mà [userId] đã react
  Future<Set<String>> _batchGetReactedCommentIds({
    required List<String> commentIds,
    required String? userId,
  }) async {
    if (userId == null || commentIds.isEmpty) return {};

    try {
      final response = await _supabase
          .from(CommentReactsTable.name)
          .select(CommentReactsTable.commentId)
          .eq(CommentReactsTable.userId, userId)
          .inFilter(CommentReactsTable.commentId, commentIds);

      return {
        for (final r in response as List)
          r[CommentReactsTable.commentId] as String,
      };
    } catch (e) {
      return {};
    }
  }

  /// Map database row to Comment model
  Comment _mapRowToComment(Map<String, dynamic> row) {
    return Comment(
      commentId: row[FeedCommentTable.commentId] as String,
      postId: row[FeedCommentTable.postId] as String,
      authorId: row[FeedCommentTable.authorId] as String,
      authorName: row[FeedCommentTable.authorName] as String,
      authorAvatar: row[FeedCommentTable.authorAvatar] as String? ?? '',
      contentText: row[FeedCommentTable.contentText] as String,
      reactCount: row[FeedCommentTable.reactCount] as int? ?? 0,
      createdAt: DateTime.parse(row[FeedCommentTable.createdAt] as String),
      updatedAt: row[FeedCommentTable.updatedAt] != null
          ? DateTime.parse(row[FeedCommentTable.updatedAt] as String)
          : null,
    );
  }
}