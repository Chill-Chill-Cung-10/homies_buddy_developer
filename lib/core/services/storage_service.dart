import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path/path.dart' as path;
import 'firebase_service.dart';

/// Storage Service - Handle upload/download media files
///
/// Hỗ trợ upload avatar, cover, post media với auto-compress
/// và generate thumbnails cho images.
class StorageService {
  final FirebaseService _firebaseService = FirebaseService.instance;
  /// Upload media cho note — path: notes/{userId}/{noteId}_media_{i}.jpg
Future<List<String>> uploadNoteMedia({
  required String userId,
  required String noteId,
  required List<XFile> files,
}) async {
  final urls = <String>[];

  for (int i = 0; i < files.length; i++) {
    final file = files[i];
    final ext = path.extension(file.path).toLowerCase();
    final isVideo = ['.mp4', '.mov', '.avi'].contains(ext);

    try {
      // Path đúng: notes/{userId}/{noteId}_media_{i}.jpg
      final filename = '${noteId}_media_$i${isVideo ? ext : '.jpg'}';
      final ref = _firebaseService.storage
          .ref()
          .child('notes/$userId/$filename');  // ← path khớp rules

      if (isVideo) {
        final uploadTask = ref.putFile(
          File(file.path),
          SettableMetadata(contentType: 'video/mp4'),
        );
        final snapshot = await uploadTask;
        urls.add(await snapshot.ref.getDownloadURL());
      } else {
        final compressed = await _compressImage(file, maxWidth: 1920);
        final uploadTask = ref.putFile(
          compressed,
          SettableMetadata(contentType: 'image/jpeg'),
        );
        final snapshot = await uploadTask;
        urls.add(await snapshot.ref.getDownloadURL());
      }
    } catch (e) {
      throw StorageException('Failed to upload media $i: $e');
    }
  }

  return urls;
}
  /// Upload avatar của user
  ///
  /// Tự động compress xuống max 512x512, quality 85%
  /// Returns: Download URL của avatar
  Future<String> uploadAvatar(XFile image, String userId) async {
    try {
      // Compress image trước khi upload
      final compressedImage = await _compressImage(image, maxWidth: 512);

      final ref = _firebaseService.avatarRef(userId).child('avatar.jpg');
      final uploadTask = ref.putFile(
        compressedImage,
        SettableMetadata(contentType: 'image/jpeg'),
      );

      final snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      throw StorageException('Failed to upload avatar: $e');
    }
  }

  /// Upload cover photo của user
  ///
  /// Compress xuống max 1920x1080, quality 90%
  /// Returns: Download URL của cover
  Future<String> uploadCover(XFile image, String userId) async {
    try {
      final compressedImage = await _compressImage(image, maxWidth: 1920);

      final ref = _firebaseService.coverRef(userId).child('cover.jpg');
      final uploadTask = ref.putFile(
        compressedImage,
        SettableMetadata(contentType: 'image/jpeg'),
      );

      final snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      throw StorageException('Failed to upload cover: $e');
    }
  }

  /// Upload media cho post (ảnh hoặc video)
  ///
  /// [postId] - ID của post
  /// [files] - List XFile (từ image_picker)
  /// [generateThumbnails] - Tự động tạo thumbnail cho video (default: true)
  ///
  /// Returns: List of download URLs (bao gồm cả thumbnails nếu có)
  Future<List<MediaUploadResult>> uploadPostMedia(
    String userId,  // ← userId trước
    String postId,
    List<XFile> files, {
    bool generateThumbnails = true,
  }) async {
    final results = <MediaUploadResult>[];

    for (int i = 0; i < files.length; i++) {
      final file = files[i];
      final ext = path.extension(file.path).toLowerCase();
      final isVideo = ['.mp4', '.mov', '.avi'].contains(ext);

      try {
        if (isVideo) {
          // Upload video (no compression)
          final videoUrl = await _uploadFile(
            file,
            userId,
            postId,
            'media_$i$ext',
            'video/mp4',
          );

          // TODO: Generate thumbnail from video (cần thêm video_thumbnail package)
          // For now, return null for thumbnailUrl
          results.add(
            MediaUploadResult(
              mediaUrl: videoUrl,
              thumbnailUrl: null,
              isVideo: true,
            ),
          );
        } else {
          // Upload image with compression
          final compressedImage = await _compressImage(file, maxWidth: 1920);
          final imageUrl = await _uploadCompressed(
            compressedImage,
            userId,
            postId,
            'media_$i.jpg',
            'image/jpeg',
          );

          // Generate thumbnail
          String? thumbnailUrl;
          if (generateThumbnails) {
            final thumbnail = await _compressImage(file, maxWidth: 400);
            thumbnailUrl = await _uploadCompressed(
              thumbnail,
              userId,
              postId,
              'media_${i}_thumb.jpg',
              'image/jpeg',
            );
          }

          results.add(
            MediaUploadResult(
              mediaUrl: imageUrl,
              thumbnailUrl: thumbnailUrl,
              isVideo: false,
            ),
          );
        }
      } catch (e) {
        throw StorageException('Failed to upload media $i: $e');
      }
    }

    return results;
  }

  /// Private helper - Upload file trực tiếp
  Future<String> _uploadFile(
    XFile file,
    String userId,
    String postId,
    String filename,
    String contentType,
  ) async {
    final ref = _firebaseService.postMediaRef(userId, postId).child(filename);
    final uploadTask = ref.putFile(
      File(file.path),
      SettableMetadata(contentType: contentType),
    );
    final snapshot = await uploadTask;
    return await snapshot.ref.getDownloadURL();
  }

  /// Private helper - Upload compressed file
  Future<String> _uploadCompressed(
    File file,
    String userId,
    String postId,
    String filename,
    String contentType,
  ) async {
    final ref = _firebaseService.postMediaRef(userId, postId).child(filename);
    final uploadTask = ref.putFile(
      file,
      SettableMetadata(contentType: contentType),
    );
    final snapshot = await uploadTask;
    return await snapshot.ref.getDownloadURL();
  }

  /// Private helper - Compress image
  Future<File> _compressImage(
    XFile image, {
    int maxWidth = 1920,
    int quality = 85,
  }) async {
    final targetPath = image.path.replaceAll(
      path.extension(image.path),
      '_compressed.jpg',
    );

    final result = await FlutterImageCompress.compressAndGetFile(
      image.path,
      targetPath,
      quality: quality,
      minWidth: maxWidth,
      format: CompressFormat.jpeg,
    );

    if (result == null) {
      throw StorageException('Failed to compress image');
    }

    return File(result.path);
  }

  /// Delete media file
  Future<void> deleteFile(String downloadUrl) async {
    try {
      final ref = _firebaseService.storage.refFromURL(downloadUrl);
      await ref.delete();
    } catch (e) {
      // Ignore deletion errors (file might not exist)
    }
  }

  /// Delete all media của một post
  Future<void> deletePostMedia(String userId, String postId) async {
    try {
      final ref = _firebaseService.postMediaRef(userId, postId);
      final listResult = await ref.listAll();

      // Delete all files in the folder
      for (final item in listResult.items) {
        await item.delete();
      }
    } catch (e) {
      // Ignore deletion errors
    }
  }
}

/// Result của upload media
class MediaUploadResult {
  final String mediaUrl;
  final String? thumbnailUrl;
  final bool isVideo;

  MediaUploadResult({
    required this.mediaUrl,
    required this.thumbnailUrl,
    required this.isVideo,
  });
}

/// Custom exception cho storage errors
class StorageException implements Exception {
  final String message;
  StorageException(this.message);

  @override
  String toString() => 'StorageException: $message';
}