import 'dart:io';

import '../../../../data/models/media_file_model.dart';

/// Media Repository — Abstract interface for media operations
///
/// Handles:
/// - Uploading media files to Firebase Storage
/// - Deleting media files from Storage and database
/// - Extracting media metadata (dimensions, aspect ratio)
///
/// Implementation uses:
/// - Firebase Storage for file storage
/// - Supabase for media_file table records
abstract class MediaRepository {
  /// Upload media files for a post
  ///
  /// Uploads files to Firebase Storage and creates records in media_file table.
  /// Automatically extracts width, height, and aspect ratio for images.
  ///
  /// [files] - List of files to upload (images/videos)
  /// [postId] - The post ID these media belong to
  ///
  /// Returns list of created MediaFile records
  Future<List<MediaFile>> uploadMedia({
    required List<File> files,
    required String postId, required String userId,
  });

  /// Delete a single media file
  ///
  /// Deletes file from Firebase Storage and removes record from database.
  ///
  /// [mediaId] - The media file ID to delete
  Future<void> deleteMedia(String mediaId);

  /// Delete all media for a post
  ///
  /// Deletes all files from Firebase Storage and removes all records.
  ///
  /// [postId] - The post ID to delete media for
  /// [userId] - The owner of the post (required for correct Storage path)
  Future<void> deletePostMedia(String postId, String userId);

  /// Get all media files for a post
  ///
  /// [postId] - The post ID to get media for
  Future<List<MediaFile>> getPostMedia(String postId);

  /// Get media metadata (dimensions) from a file
  ///
  /// [file] - The file to extract metadata from
  /// Returns map with 'width', 'height', 'aspectRatio'
  Future<MediaMetadata> extractMetadata(File file);
}

/// Media metadata extracted from file
class MediaMetadata {
  final int width;
  final int height;
  final double aspectRatio;

  const MediaMetadata({
    required this.width,
    required this.height,
    required this.aspectRatio,
  });

  factory MediaMetadata.fromDimensions(int width, int height) {
    return MediaMetadata(
      width: width,
      height: height,
      aspectRatio: width / height,
    );
  }

  /// Default metadata for when extraction fails
  static const MediaMetadata defaultValue = MediaMetadata(
    width: 1080,
    height: 1080,
    aspectRatio: 1.0,
  );
}

/// Exception for MediaRepository errors
class MediaRepositoryException implements Exception {
  final String message;
  final Object? originalError;

  MediaRepositoryException(this.message, [this.originalError]);

  @override
  String toString() => 'MediaRepositoryException: $message';
}