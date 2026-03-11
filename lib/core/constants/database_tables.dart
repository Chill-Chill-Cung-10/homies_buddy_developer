/// Database Table Constants
///
/// Centralized constants for all Supabase table and column names.
/// Prevents hardcoding strings throughout the codebase.
library;

// =============================================================================
// FEED POST TABLE
// =============================================================================

/// Feed Post table constants
abstract class FeedPostTable {
  static const String name = 'feed_post';

  // Columns
  static const String postId = 'post_id';
  static const String authorId = 'author_id';
  static const String authorName = 'author_name';
  static const String authorAvatar = 'author_avatar';
  static const String contentText = 'content_text';
  static const String hashtags = 'hashtags';
  static const String mentions = 'mentions';
  static const String reactsCount = 'reacts_count';
  static const String commentCount = 'comment_count';
  static const String privacy = 'privacy';
  static const String createdAt = 'created_at';
  static const String updatedAt = 'updated_at';
}

// =============================================================================
// FEED COMMENT TABLE
// =============================================================================

/// Feed Comment table constants
abstract class FeedCommentTable {
  static const String name = 'feed_comment';

  // Columns
  static const String commentId = 'comment_id';
  static const String postId = 'post_id';
  static const String authorId = 'author_id';
  static const String authorName = 'author_name';
  static const String authorAvatar = 'author_avatar';
  static const String contentText = 'content_text';
  static const String reactCount = 'react_count';
  static const String createdAt = 'created_at';
  static const String updatedAt = 'updated_at';
}

// =============================================================================
// MEDIA FILE TABLE
// =============================================================================

/// Media File table constants
abstract class MediaFileTable {
  static const String name = 'media_file';

  // Columns
  static const String id = 'id';
  static const String postId = 'post_id';
  static const String mediaUrl = 'media_url';
  static const String thumbnailUrl = 'thumbnail_url';
  static const String mediaType = 'media_type';
  static const String mediaAspectRatio = 'media_aspect_ratio';
  static const String width = 'width';
  static const String height = 'height';
  static const String durationSeconds = 'duration_seconds';
}

// =============================================================================
// POST LIKES TABLE (Junction)
// =============================================================================

/// Post Likes junction table constants
abstract class PostLikesTable {
  static const String name = 'post_likes';

  // Columns
  static const String userId = 'user_id';
  static const String postId = 'post_id';
  static const String createdAt = 'created_at';
}

// =============================================================================
// COMMENT REACTS TABLE (Junction)
// =============================================================================

/// Comment Reacts junction table constants
abstract class CommentReactsTable {
  static const String name = 'comment_reacts';

  // Columns
  static const String userId = 'user_id';
  static const String commentId = 'comment_id';
  static const String createdAt = 'created_at';
}

// =============================================================================
// USER PROFILE TABLE
// =============================================================================

/// User Profile table constants
abstract class UserProfileTable {
  static const String name = 'user_profile';

  // Columns
  static const String id = 'id';
  static const String fullName = 'full_name';
  static const String username = 'username';
  static const String email = 'email';
  static const String avatarUrl = 'avatar_url';
  static const String coverUrl = 'cover_url';
  static const String followerCount = 'follower_count';
  static const String followingCount = 'following_count';
  static const String role = 'role';
  static const String dateOfBirth = 'date_of_birth';
  static const String isEmailVerified = 'is_email_verified';
  static const String createdAt = 'created_at';
  static const String updatedAt = 'updated_at';
}

// =============================================================================
// SUPABASE RPC FUNCTIONS
// =============================================================================

/// RPC function names for database operations
abstract class SupabaseRpc {
  // Post reactions
  static const String incrementPostReacts = 'increment_post_reacts';
  static const String decrementPostReacts = 'decrement_post_reacts';

  // Comment reactions
  static const String incrementCommentReacts = 'increment_comment_reacts';
  static const String decrementCommentReacts = 'decrement_comment_reacts';

  // Post comments
  static const String incrementCommentCount = 'increment_comment_count';
  static const String decrementCommentCount = 'decrement_comment_count';
}

// =============================================================================
// FIREBASE STORAGE PATHS
// =============================================================================

/// Firebase Storage path constants
abstract class StoragePaths {
  static const String postMedia = 'post_media';
  static const String userAvatars = 'user_avatars';
  static const String userCovers = 'user_covers';

  /// Get path for post media file
  static String postMediaPath(String postId, String fileName) =>
      '$postMedia/$postId/$fileName';
}
