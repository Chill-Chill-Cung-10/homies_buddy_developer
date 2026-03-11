import 'dart:io';
import 'dart:ui' as ui;

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path/path.dart' as path;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/constants/database_tables.dart';
import '../../../../core/services/firebase_service.dart';
import '../../../../data/models/media_file_model.dart';
import '../../../../data/models/enums/media_type.dart';
import 'media_repository.dart';

/// MediaRepository Implementation
///
/// Uses:
/// - Firebase Storage for file storage
/// - Supabase media_file table for records
/// - Flutter's image codec for metadata extraction
class MediaRepositoryImpl implements MediaRepository {
  final SupabaseClient _supabase;
  final FirebaseService _firebaseService;
  final Uuid _uuid = const Uuid();

  MediaRepositoryImpl({
    SupabaseClient? supabase,
    FirebaseService? firebaseService,
  })  : _supabase = supabase ?? Supabase.instance.client,
        _firebaseService = firebaseService ?? FirebaseService.instance;

  // =========================================================================
  // UPLOAD MEDIA
  // =========================================================================

  @override
  Future<List<MediaFile>> uploadMedia({
    required List<File> files,
    required String postId,
    required String userId,
  }) async {
    final uploadedMedia = <MediaFile>[];

    for (int i = 0; i < files.length; i++) {
      final file = files[i];
      final ext = path.extension(file.path).toLowerCase();
      final isVideo = ['.mp4', '.mov', '.avi', '.webm'].contains(ext);
      final mediaId = _uuid.v4();

      try {
        // Extract metadata for images
        MediaMetadata metadata = MediaMetadata.defaultValue;
        if (!isVideo) {
          metadata = await extractMetadata(file);
        }

        // Upload to Firebase Storage
        final uploadResult = await _uploadToStorage(
          file: file,
          postId: postId,
          mediaId: mediaId,
          isVideo: isVideo,
          userId: userId,
        );

        // Insert record into media_file table
        final mediaFile = await _insertMediaRecord(
          mediaId: mediaId,
          postId: postId,
          mediaUrl: uploadResult.mediaUrl,
          thumbnailUrl: uploadResult.thumbnailUrl,
          mediaType: isVideo ? MediaType.video : MediaType.image,
          metadata: metadata,
          durationSeconds: isVideo ? uploadResult.durationSeconds : null,
        );

        uploadedMedia.add(mediaFile);
      } catch (e) {
        // Clean up any uploaded files on failure
        await _deleteFromStorage(userId, postId, mediaId);
        throw MediaRepositoryException('Failed to upload media $i', e);
      }
    }

    return uploadedMedia;
  }

  // =========================================================================
  // DELETE MEDIA
  // =========================================================================

  @override
  Future<void> deleteMedia(String mediaId) async {
    try {
      // Get media record first
      final response = await _supabase
          .from(MediaFileTable.name)
          .select('${MediaFileTable.postId}, ${MediaFileTable.mediaUrl}, ${MediaFileTable.thumbnailUrl}')
          .eq(MediaFileTable.id, mediaId)
          .maybeSingle();

      if (response == null) {
        throw MediaRepositoryException('Media not found');
      }

      final mediaUrl = response[MediaFileTable.mediaUrl] as String?;
      final thumbnailUrl = response[MediaFileTable.thumbnailUrl] as String?;

      // Delete from Firebase Storage
      if (mediaUrl != null) {
        await _deleteFileByUrl(mediaUrl);
      }
      if (thumbnailUrl != null) {
        await _deleteFileByUrl(thumbnailUrl);
      }

      // Delete from database
      await _supabase
          .from(MediaFileTable.name)
          .delete()
          .eq(MediaFileTable.id, mediaId);
    } catch (e) {
      if (e is MediaRepositoryException) rethrow;
      throw MediaRepositoryException('Failed to delete media', e);
    }
  }

  // =========================================================================
  // DELETE POST MEDIA
  // =========================================================================

  @override
  Future<void> deletePostMedia(String postId, String userId) async {
    try {
      // Get all media records for the post
      final response = await _supabase
          .from(MediaFileTable.name)
          .select()
          .eq(MediaFileTable.postId, postId);

      // Delete all files from storage
      for (final row in response as List) {
        final mediaUrl = row[MediaFileTable.mediaUrl] as String?;
        final thumbnailUrl = row[MediaFileTable.thumbnailUrl] as String?;

        if (mediaUrl != null) {
          await _deleteFileByUrl(mediaUrl);
        }
        if (thumbnailUrl != null) {
          await _deleteFileByUrl(thumbnailUrl);
        }
      }

      // Also delete the entire folder in storage
      try {
        final ref = _firebaseService.postMediaRef(userId, postId);
        final listResult = await ref.listAll();
        for (final item in listResult.items) {
          await item.delete();
        }
      } catch (e) {
        // Ignore - folder might not exist or already empty
      }

      // Delete all records from database
      await _supabase
          .from(MediaFileTable.name)
          .delete()
          .eq(MediaFileTable.postId, postId);
    } catch (e) {
      if (e is MediaRepositoryException) rethrow;
      throw MediaRepositoryException('Failed to delete post media', e);
    }
  }

  // =========================================================================
  // GET POST MEDIA
  // =========================================================================

  @override
  Future<List<MediaFile>> getPostMedia(String postId) async {
    try {
      final response = await _supabase
          .from(MediaFileTable.name)
          .select()
          .eq(MediaFileTable.postId, postId);

      return (response as List).map((row) => _mapRowToMediaFile(row)).toList();
    } catch (e) {
      throw MediaRepositoryException('Failed to get post media', e);
    }
  }

  // =========================================================================
  // EXTRACT METADATA
  // =========================================================================

  @override
  Future<MediaMetadata> extractMetadata(File file) async {
    try {
      final bytes = await file.readAsBytes();

      // Decode image using Flutter's image codec
      final codec = await ui.instantiateImageCodec(bytes);
      final frame = await codec.getNextFrame();
      final image = frame.image;

      final width = image.width;
      final height = image.height;

      image.dispose();
      codec.dispose();

      return MediaMetadata.fromDimensions(width, height);
    } catch (e) {
      // Log error but return default
      debugPrint('Failed to extract metadata: $e');
    }

    return MediaMetadata.defaultValue;
  }

  // =========================================================================
  // PRIVATE HELPERS
  // =========================================================================

  /// Upload file to Firebase Storage
  Future<_StorageUploadResult> _uploadToStorage({
    required File file,
    required String postId,
    required String mediaId,
    required bool isVideo,
    required String userId,
  }) async {
    final ext = path.extension(file.path).toLowerCase();

    if (isVideo) {
      // Upload video directly (no compression)
      final filename = '$mediaId$ext';
      final ref = _firebaseService.postMediaRef(userId, postId).child(filename);

      final uploadTask = ref.putFile(
        file,
        SettableMetadata(contentType: 'video/mp4'),
      );
      final snapshot = await uploadTask;
      final mediaUrl = await snapshot.ref.getDownloadURL();

      // TODO: Extract video duration and generate thumbnail
      // For now, return without thumbnail
      return _StorageUploadResult(
        mediaUrl: mediaUrl,
        thumbnailUrl: null,
        durationSeconds: null,
      );
    } else {
      // Compress and upload image
      final compressedFile = await _compressImage(
        file,
        maxWidth: 720,
        quality: 70,
      );
      final filename = '$mediaId.jpg';
      final ref = _firebaseService.postMediaRef(userId, postId).child(filename);

      final uploadTask = ref.putFile(
        compressedFile,
        SettableMetadata(contentType: 'image/jpeg'),
      );
      final snapshot = await uploadTask;
      final mediaUrl = await snapshot.ref.getDownloadURL();

      // Generate and upload thumbnail
      String? thumbnailUrl;
      try {
        final thumbnailFile = await _compressImage(
          file,
          maxWidth: 180,
          quality: 60,
        );
        final thumbFilename = '${mediaId}_thumb.jpg';
        final thumbRef =
            _firebaseService.postMediaRef(userId,postId).child(thumbFilename);

        final thumbUploadTask = thumbRef.putFile(
          thumbnailFile,
          SettableMetadata(contentType: 'image/jpeg'),
        );
        final thumbSnapshot = await thumbUploadTask;
        thumbnailUrl = await thumbSnapshot.ref.getDownloadURL();
      } catch (e) {
        // Thumbnail generation failed, continue without it
      }

      return _StorageUploadResult(
        mediaUrl: mediaUrl,
        thumbnailUrl: thumbnailUrl,
      );
    }
  }

  /// Compress image file
  Future<File> _compressImage(
    File file, {
    int maxWidth = 720,
    int quality = 70,
  }) async {
    final targetPath = file.path.replaceAll(
      path.extension(file.path),
      '_compressed.jpg',
    );

    final result = await FlutterImageCompress.compressAndGetFile(
      file.path,
      targetPath,
      quality: quality,
      minWidth: maxWidth,
      format: CompressFormat.jpeg,
    );

    if (result == null) {
      throw MediaRepositoryException('Failed to compress image');
    }

    return File(result.path);
  }

  /// Insert media record into database
  Future<MediaFile> _insertMediaRecord({
    required String mediaId,
    required String postId,
    required String mediaUrl,
    String? thumbnailUrl,
    required MediaType mediaType,
    required MediaMetadata metadata,
    int? durationSeconds,
  }) async {
    final response = await _supabase
        .from(MediaFileTable.name)
        .insert({
          MediaFileTable.id: mediaId,
          MediaFileTable.postId: postId,
          MediaFileTable.mediaUrl: mediaUrl,
          MediaFileTable.thumbnailUrl: thumbnailUrl,
          MediaFileTable.mediaType: mediaType.name,
          MediaFileTable.mediaAspectRatio: metadata.aspectRatio,
          MediaFileTable.width: metadata.width,
          MediaFileTable.height: metadata.height,
          MediaFileTable.durationSeconds: durationSeconds,
        })
        .select()
        .single();

    return _mapRowToMediaFile(response);
  }

  /// Delete file from Firebase Storage by URL
  Future<void> _deleteFileByUrl(String url) async {
    try {
      final ref = _firebaseService.storage.refFromURL(url);
      await ref.delete();
    } catch (e) {
      // Ignore deletion errors - file might not exist
    }
  }

  /// Delete file from Firebase Storage by path
  Future<void> _deleteFromStorage(String userId, String postId, String mediaId) async {
    try {
      final ref = _firebaseService.postMediaRef(userId, postId);
      final listResult = await ref.listAll();
      for (final item in listResult.items) {
        if (item.name.startsWith(mediaId)) {
          await item.delete();
        }
      }
    } catch (e) {
      // Ignore - cleanup effort only
    }
  }

  /// Map database row to MediaFile model
  MediaFile _mapRowToMediaFile(Map<String, dynamic> row) {
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

/// Internal result class for storage upload
class _StorageUploadResult {
  final String mediaUrl;
  final String? thumbnailUrl;
  final int? durationSeconds;

  _StorageUploadResult({
    required this.mediaUrl,
    this.thumbnailUrl,
    this.durationSeconds,
  });
}