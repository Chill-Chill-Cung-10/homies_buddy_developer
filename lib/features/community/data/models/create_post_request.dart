import 'dart:io';

import '../../../../data/models/enums/post_privacy.dart';

/// Create Post Request — Data class for creating a new post
///
/// Contains all necessary data for creating a post including:
/// - Author information
/// - Content text
/// - Hashtags and mentions
/// - Media files to upload
/// - Privacy settings
class CreatePostRequest {
  final String authorId;
  final String authorName;
  final String authorAvatar;
  final String contentText;
  final List<String> hashtags;
  final List<String> mentions;
  final List<File> mediaFiles;
  final PostPrivacy privacy;

  const CreatePostRequest({
    required this.authorId,
    required this.authorName,
    required this.authorAvatar,
    required this.contentText,
    this.hashtags = const [],
    this.mentions = const [],
    this.mediaFiles = const [],
    this.privacy = PostPrivacy.public,
  });

  /// Check if post has any media
  bool get hasMedia => mediaFiles.isNotEmpty;

  /// Check if post has content (text or media)
  bool get hasContent => contentText.trim().isNotEmpty || hasMedia;

  /// Get media count
  int get mediaCount => mediaFiles.length;

  /// Validate the request
  ///
  /// Returns null if valid, error message if invalid
  String? validate() {
    if (authorId.isEmpty) {
      return 'Author ID is required';
    }

    if (authorName.isEmpty) {
      return 'Author name is required';
    }

    if (!hasContent) {
      return 'Post must have content or media';
    }

    if (mediaFiles.length > 10) {
      return 'Maximum 10 media files allowed';
    }

    // Validate text length
    if (contentText.length > 5000) {
      return 'Content text too long (max 5000 characters)';
    }

    // Validate hashtags count
    if (hashtags.length > 30) {
      return 'Maximum 30 hashtags allowed';
    }

    // Validate mentions count
    if (mentions.length > 20) {
      return 'Maximum 20 mentions allowed';
    }

    return null;
  }

  /// Create a copy with modified fields
  CreatePostRequest copyWith({
    String? authorId,
    String? authorName,
    String? authorAvatar,
    String? contentText,
    List<String>? hashtags,
    List<String>? mentions,
    List<File>? mediaFiles,
    PostPrivacy? privacy,
  }) {
    return CreatePostRequest(
      authorId: authorId ?? this.authorId,
      authorName: authorName ?? this.authorName,
      authorAvatar: authorAvatar ?? this.authorAvatar,
      contentText: contentText ?? this.contentText,
      hashtags: hashtags ?? this.hashtags,
      mentions: mentions ?? this.mentions,
      mediaFiles: mediaFiles ?? this.mediaFiles,
      privacy: privacy ?? this.privacy,
    );
  }

  /// Convert to map for database (without media files)
  ///
  /// Media files are handled separately by MediaRepository
  Map<String, dynamic> toPostMap() {
    return {
      'author_id': authorId,
      'author_name': authorName,
      'author_avatar': authorAvatar,
      'content_text': contentText,
      'hashtags': hashtags,
      'mentions': mentions,
      'privacy': privacy.name,
      'reacts_count': 0,
      'comment_count': 0,
    };
  }

  @override
  String toString() {
    return 'CreatePostRequest('
        'authorId: $authorId, '
        'contentText: ${contentText.length > 50 ? '${contentText.substring(0, 50)}...' : contentText}, '
        'mediaCount: $mediaCount, '
        'privacy: ${privacy.name}'
        ')';
  }
}

/// Extension for extracting hashtags and mentions from text
extension PostTextParser on String {
  /// Extract hashtags from text (e.g., #flutter #dart)
  List<String> extractHashtags() {
    final regex = RegExp(r'#(\w+)');
    return regex.allMatches(this).map((m) => m.group(1)!).toList();
  }

  /// Extract mentions from text (e.g., @username)
  List<String> extractMentions() {
    final regex = RegExp(r'@(\w+)');
    return regex.allMatches(this).map((m) => m.group(1)!).toList();
  }
}
