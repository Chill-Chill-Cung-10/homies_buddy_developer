import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/constants/database_tables.dart';
import '../../../../data/models/post_model.dart';
import '../../../../data/models/media_file_model.dart';
import '../../../../data/models/enums/media_type.dart';
import '../../../../data/models/enums/post_privacy.dart';
import '../models/create_post_request.dart';
import 'post_repository.dart';
import 'media_repository.dart';

/// PostRepository Implementation using Supabase
///
/// Tables used:
/// - feed_post: Main post data
/// - media_file: Post media attachments
/// - post_likes: Junction table for likes
///
/// Triggers handle count updates automatically:
/// - post_likes INSERT/DELETE → feed_post.reacts_count (trigger)
/// - feed_comment INSERT/DELETE → feed_post.comment_count (trigger)
class PostRepositoryImpl implements PostRepository {
  final SupabaseClient _supabase;
  final MediaRepository _mediaRepository;

  PostRepositoryImpl({
    SupabaseClient? supabase,
    required MediaRepository mediaRepository,
  })  : _supabase = supabase ?? Supabase.instance.client,
        _mediaRepository = mediaRepository;

  // =========================================================================
  // GET FEED
  // =========================================================================

  @override
  Future<PostFeedResult> getFeed({
    required int page,
    int limit = 10,
    String? currentUserId,
  }) async {
    try {
      final offset = page * limit;

      // Fetch limit+1 để detect hasMore mà không cần count query riêng
      final response = await _supabase
          .from(FeedPostTable.name)
          .select('*, ${MediaFileTable.name} (*)')
          .eq(FeedPostTable.privacy, 'public')
          .order(FeedPostTable.createdAt, ascending: false)
          .range(offset, offset + limit); // limit+1 rows

      final rows = response as List;

      // Detect hasMore từ row count trước khi trim
      final hasMore = rows.length == limit + 1;
      if (hasMore) rows.removeLast();

      if (rows.isEmpty) {
        return const PostFeedResult(posts: [], hasMore: false);
      }

      // Batch check is_liked_by_me — 1 query cho tất cả posts
      final likedSet = await _batchGetLikedPostIds(
        postIds: rows.map((r) => r[FeedPostTable.postId] as String).toList(),
        userId: currentUserId,
      );

      final posts = rows
          .map((row) => PostWithLikeStatus(
                post: _mapRowToPost(row),
                isLikedByMe: likedSet.contains(row[FeedPostTable.postId]),
              ))
          .toList();

      return PostFeedResult(posts: posts, hasMore: hasMore);
    } catch (e) {
      throw PostRepositoryException('Failed to fetch feed', e);
    }
  }

  // =========================================================================
  // GET POST BY ID
  // =========================================================================

  @override
  Future<PostWithLikeStatus?> getPostById(
    String postId, {
    String? currentUserId,
  }) async {
    try {
      final response = await _supabase
          .from(FeedPostTable.name)
          .select('*, ${MediaFileTable.name} (*)')
          .eq(FeedPostTable.postId, postId)
          .maybeSingle();

      if (response == null) return null;

      final post = _mapRowToPost(response);

      final isLiked = currentUserId != null
          ? await isLikedByUser(postId, currentUserId)
          : false;

      return PostWithLikeStatus(post: post, isLikedByMe: isLiked);
    } catch (e) {
      throw PostRepositoryException('Failed to get post by ID', e);
    }
  }

  // =========================================================================
  // CREATE POST
  // =========================================================================

  @override
  Future<String> createPost(CreatePostRequest request) async {
    try {
      final validationError = request.validate();
      if (validationError != null) {
        throw PostRepositoryException(validationError);
      }

      // Insert post — DB generates post_id via gen_random_uuid()
      final postResponse = await _supabase
          .from(FeedPostTable.name)
          .insert({
            FeedPostTable.authorId: request.authorId,
            FeedPostTable.authorName: request.authorName,
            FeedPostTable.authorAvatar: request.authorAvatar,
            FeedPostTable.contentText: request.contentText,
            FeedPostTable.hashtags: request.hashtags,
            FeedPostTable.mentions: request.mentions,
            FeedPostTable.privacy: request.privacy.name,
            FeedPostTable.reactsCount: 0,
            FeedPostTable.commentCount: 0,
          })
          .select(FeedPostTable.postId)
          .single();

      final postId = postResponse[FeedPostTable.postId] as String;

      // Upload media after post exists (FK constraint)
      if (request.hasMedia) {
        await _mediaRepository.uploadMedia(
          files: request.mediaFiles,
          postId: postId,
          userId: request.authorId
        );
      }

      return postId;
    } catch (e) {
      if (e is PostRepositoryException) rethrow;
      throw PostRepositoryException('Failed to create post', e);
    }
  }

  // =========================================================================
  // DELETE POST
  // =========================================================================

  @override
  Future<void> deletePost(String postId, String authorId) async {
    try {
      // Verify ownership trước khi xóa
      final post = await _supabase
          .from(FeedPostTable.name)
          .select(FeedPostTable.authorId)
          .eq(FeedPostTable.postId, postId)
          .maybeSingle();

      if (post == null) {
        throw PostRepositoryException('Post not found');
      }

      if (post[FeedPostTable.authorId] != authorId) {
        throw PostRepositoryException('Not authorized to delete this post');
      }

      // Xóa media trên Firebase Storage + media_file records
      await _mediaRepository.deletePostMedia(postId, authorId);

      // Xóa post — post_likes sẽ bị xóa theo nếu có ON DELETE CASCADE
      // Nếu chưa có cascade, xóa post_likes trước:
      await _supabase
          .from(PostLikesTable.name)
          .delete()
          .eq(PostLikesTable.postId, postId);

      await _supabase
          .from(FeedPostTable.name)
          .delete()
          .eq(FeedPostTable.postId, postId);
    } catch (e) {
      if (e is PostRepositoryException) rethrow;
      throw PostRepositoryException('Failed to delete post', e);
    }
  }

  // =========================================================================
  // TOGGLE LIKE
  // =========================================================================

  @override
  Future<bool> toggleLike(String postId, String userId) async {
    try {
      final isCurrentlyLiked = await isLikedByUser(postId, userId);

      if (isCurrentlyLiked) {
        // Unlike — trigger tự DECREMENT feed_post.reacts_count
        await _supabase
            .from(PostLikesTable.name)
            .delete()
            .eq(PostLikesTable.postId, postId)
            .eq(PostLikesTable.userId, userId);

        return false;
      } else {
        // Like — trigger tự INCREMENT feed_post.reacts_count
        await _supabase.from(PostLikesTable.name).insert({
          PostLikesTable.postId: postId,
          PostLikesTable.userId: userId,
        });

        return true;
      }
    } catch (e) {
      throw PostRepositoryException('Failed to toggle like', e);
    }
  }

  // =========================================================================
  // IS LIKED BY USER
  // =========================================================================

  @override
  Future<bool> isLikedByUser(String postId, String userId) async {
    try {
      final response = await _supabase
          .from(PostLikesTable.name)
          .select(PostLikesTable.userId)
          .eq(PostLikesTable.postId, postId)
          .eq(PostLikesTable.userId, userId)
          .maybeSingle();

      return response != null;
    } catch (e) {
      return false;
    }
  }

  // =========================================================================
  // GET USER POSTS
  // =========================================================================

  @override
  Future<PostFeedResult> getUserPosts({
    required String userId,
    required int page,
    int limit = 10,
    String? currentUserId,
  }) async {
    try {
      final offset = page * limit;

      final response = await _supabase
          .from(FeedPostTable.name)
          .select('*, ${MediaFileTable.name} (*)')
          .eq(FeedPostTable.authorId, userId)
          .order(FeedPostTable.createdAt, ascending: false)
          .range(offset, offset + limit);

      final rows = response as List;

      final hasMore = rows.length == limit + 1;
      if (hasMore) rows.removeLast();

      if (rows.isEmpty) {
        return const PostFeedResult(posts: [], hasMore: false);
      }

      // Batch check likes cho tất cả posts của user
      final likedSet = await _batchGetLikedPostIds(
        postIds: rows.map((r) => r[FeedPostTable.postId] as String).toList(),
        userId: currentUserId,
      );

      final posts = rows
          .map((row) => PostWithLikeStatus(
                post: _mapRowToPost(row),
                isLikedByMe: likedSet.contains(row[FeedPostTable.postId]),
              ))
          .toList();

      return PostFeedResult(posts: posts, hasMore: hasMore);
    } catch (e) {
      throw PostRepositoryException('Failed to get user posts', e);
    }
  }

  // =========================================================================
  // PRIVATE HELPERS
  // =========================================================================

  /// Batch check liked posts — 1 query thay vì N queries
  /// Trả về Set<postId> mà [userId] đã like
  Future<Set<String>> _batchGetLikedPostIds({
    required List<String> postIds,
    required String? userId,
  }) async {
    if (userId == null || postIds.isEmpty) return {};

    try {
      final response = await _supabase
          .from(PostLikesTable.name)
          .select(PostLikesTable.postId)
          .eq(PostLikesTable.userId, userId)
          .inFilter(PostLikesTable.postId, postIds);

      return {
        for (final r in response as List) r[PostLikesTable.postId] as String,
      };
    } catch (e) {
      return {};
    }
  }

  /// Map database row to Post model
  Post _mapRowToPost(Map<String, dynamic> row) {
    final mediaList = (row[MediaFileTable.name] as List?) ?? [];

    return Post(
      postId: row[FeedPostTable.postId] as String,
      authorId: row[FeedPostTable.authorId] as String,
      authorName: row[FeedPostTable.authorName] as String,
      authorAvatar: row[FeedPostTable.authorAvatar] as String? ?? '',
      contentText: row[FeedPostTable.contentText] as String? ?? '',
      hashtags: List<String>.from(row[FeedPostTable.hashtags] ?? []),
      mentions: List<String>.from(row[FeedPostTable.mentions] ?? []),
      mediaFiles: mediaList.map((m) => _mapMediaFile(m)).toList(),
      reactsCount: row[FeedPostTable.reactsCount] as int? ?? 0,
      commentCount: row[FeedPostTable.commentCount] as int? ?? 0,
      privacy: PostPrivacy.fromString(
          row[FeedPostTable.privacy] as String? ?? 'public'),
      createdAt: DateTime.parse(row[FeedPostTable.createdAt] as String),
      updatedAt: row[FeedPostTable.updatedAt] != null
          ? DateTime.parse(row[FeedPostTable.updatedAt] as String)
          : null,
    );
  }

  /// Map database row to MediaFile model
  MediaFile _mapMediaFile(Map<String, dynamic> row) {
    return MediaFile(
      id: row[MediaFileTable.id] as String,
      postId: row[MediaFileTable.postId] as String,
      mediaUrl: row[MediaFileTable.mediaUrl] as String,
      thumbnailUrl: row[MediaFileTable.thumbnailUrl] as String?,
      mediaType: MediaType.fromString(
          row[MediaFileTable.mediaType] as String? ?? 'image'),
      mediaAspectRatio:
          (row[MediaFileTable.mediaAspectRatio] as num?)?.toDouble() ?? 1.0,
      width: row[MediaFileTable.width] as int? ?? 0,
      height: row[MediaFileTable.height] as int? ?? 0,
      durationSeconds: row[MediaFileTable.durationSeconds] as int?,
    );
  }
}
