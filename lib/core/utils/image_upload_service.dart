/// Image Upload Service — Common pipeline for avatar and cover images
///
/// Pipeline:
/// 1. Check format (.jpg/.png/.webp/.jpeg)
/// 2. Check size (< 10MB)
/// 3. Crop to square for avatar (optional)
/// 4. Compress for best performance
/// 5. Upload to Firebase Storage
/// 6. Return download URL → Update Supabase
library;
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;

import '../services/firebase_service.dart';

/// Image upload type
enum ImageUploadType {
  /// Avatar - will be cropped to square
  avatar,
  /// Cover - full image, no cropping
  cover,
}

/// Image upload result
class ImageUploadResult {
  final String downloadUrl;
  final String? errorMessage;
  final bool isSuccess;

  const ImageUploadResult.success(this.downloadUrl)
      : errorMessage = null,
        isSuccess = true;

  const ImageUploadResult.error(this.errorMessage)
      : downloadUrl = '',
        isSuccess = false;
}

/// Image validation result
class ImageValidationResult {
  final bool isValid;
  final String? errorMessage;
  final XFile? file;

  const ImageValidationResult.valid(this.file)
      : isValid = true,
        errorMessage = null;

  const ImageValidationResult.invalid(this.errorMessage)
      : isValid = false,
        file = null;
}

/// Image Upload Service for avatar and cover images
class ImageUploadService {
  static final ImageUploadService _instance = ImageUploadService._();
  static ImageUploadService get instance => _instance;
  ImageUploadService._();

  final FirebaseService _firebase = FirebaseService.instance;
  final ImagePicker _picker = ImagePicker();

  // Configuration
  static const int maxFileSizeBytes = 10 * 1024 * 1024; // 10MB
  static const List<String> allowedExtensions = ['.jpg', '.jpeg', '.png', '.webp'];

  // Avatar compression settings
  static const int avatarMaxWidth = 512;
  static const int avatarQuality = 85;

  // Cover compression settings
  static const int coverMaxWidth = 1920;
  static const int coverQuality = 90;

  /// Pick image from gallery
  Future<ImageValidationResult> pickImageFromGallery() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 2048,
        maxHeight: 2048,
      );

      if (pickedFile == null) {
        return const ImageValidationResult.invalid('No image selected');
      }

      return _validateImage(pickedFile);
    } catch (e) {
      debugPrint('Error picking image: $e');
      return ImageValidationResult.invalid('Failed to pick image: $e');
    }
  }

  /// Pick image from camera
  Future<ImageValidationResult> pickImageFromCamera() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 2048,
        maxHeight: 2048,
      );

      if (pickedFile == null) {
        return const ImageValidationResult.invalid('No image captured');
      }

      return _validateImage(pickedFile);
    } catch (e) {
      debugPrint('Error capturing image: $e');
      return ImageValidationResult.invalid('Failed to capture image: $e');
    }
  }

  /// Validate image format and size
  ImageValidationResult _validateImage(XFile file) {
    // Check extension
    final ext = path.extension(file.path).toLowerCase();
    if (!allowedExtensions.contains(ext)) {
      return ImageValidationResult.invalid(
        'Invalid format. Allowed: ${allowedExtensions.join(", ")}',
      );
    }

    // Check file size will be done async
    return ImageValidationResult.valid(file);
  }

  /// Check file size asynchronously
  Future<ImageValidationResult> validateFileSize(XFile file) async {
    try {
      final bytes = await file.length();
      if (bytes > maxFileSizeBytes) {
        final sizeMB = (bytes / (1024 * 1024)).toStringAsFixed(2);
        return ImageValidationResult.invalid(
          'File too large ($sizeMB MB). Maximum: 10MB',
        );
      }
      return ImageValidationResult.valid(file);
    } catch (e) {
      return ImageValidationResult.invalid('Failed to check file size: $e');
    }
  }

  /// Upload avatar image
  ///
  /// Compresses to 512x512, quality 85%
  Future<ImageUploadResult> uploadAvatar(XFile image, String userId) async {
    try {
      // Validate file size
      final sizeValidation = await validateFileSize(image);
      if (!sizeValidation.isValid) {
        return ImageUploadResult.error(sizeValidation.errorMessage!);
      }

      // Compress image
      final compressedFile = await _compressImage(
        image,
        maxWidth: avatarMaxWidth,
        quality: avatarQuality,
      );

      // Upload to Firebase Storage
      final ref = _firebase.avatarRef(userId).child('avatar_${DateTime.now().millisecondsSinceEpoch}.jpg');
      final uploadTask = ref.putFile(
        compressedFile,
        SettableMetadata(contentType: 'image/jpeg'),
      );

      final snapshot = await uploadTask;
      final downloadUrl = await snapshot.ref.getDownloadURL();

      debugPrint('✅ Avatar uploaded: $downloadUrl');
      return ImageUploadResult.success(downloadUrl);
    } catch (e) {
      debugPrint('❌ Failed to upload avatar: $e');
      return ImageUploadResult.error('Failed to upload avatar: $e');
    }
  }

  /// Upload cover image
  ///
  /// Compresses to 1920px width, quality 90%
  Future<ImageUploadResult> uploadCover(XFile image, String userId) async {
    try {
      // Validate file size
      final sizeValidation = await validateFileSize(image);
      if (!sizeValidation.isValid) {
        return ImageUploadResult.error(sizeValidation.errorMessage!);
      }

      // Compress image
      final compressedFile = await _compressImage(
        image,
        maxWidth: coverMaxWidth,
        quality: coverQuality,
      );

      // Upload to Firebase Storage
      final ref = _firebase.coverRef(userId).child('cover_${DateTime.now().millisecondsSinceEpoch}.jpg');
      final uploadTask = ref.putFile(
        compressedFile,
        SettableMetadata(contentType: 'image/jpeg'),
      );

      final snapshot = await uploadTask;
      final downloadUrl = await snapshot.ref.getDownloadURL();

      debugPrint('✅ Cover uploaded: $downloadUrl');
      return ImageUploadResult.success(downloadUrl);
    } catch (e) {
      debugPrint('❌ Failed to upload cover: $e');
      return ImageUploadResult.error('Failed to upload cover: $e');
    }
  }

  /// Full upload pipeline
  ///
  /// 1. Pick image (gallery or camera)
  /// 2. Validate format & size
  /// 3. Compress
  /// 4. Upload to Firebase Storage
  /// 5. Return download URL
  Future<ImageUploadResult> uploadImage({
    required ImageUploadType type,
    required String userId,
    bool useCamera = false,
  }) async {
    // Step 1: Pick image
    final pickResult = useCamera
        ? await pickImageFromCamera()
        : await pickImageFromGallery();

    if (!pickResult.isValid || pickResult.file == null) {
      return ImageUploadResult.error(pickResult.errorMessage ?? 'Failed to pick image');
    }

    // Step 2: Validate file size
    final sizeValidation = await validateFileSize(pickResult.file!);
    if (!sizeValidation.isValid) {
      return ImageUploadResult.error(sizeValidation.errorMessage!);
    }

    // Step 3-5: Compress and upload based on type
    switch (type) {
      case ImageUploadType.avatar:
        return uploadAvatar(pickResult.file!, userId);
      case ImageUploadType.cover:
        return uploadCover(pickResult.file!, userId);
    }
  }

  /// Compress image helper
  Future<File> _compressImage(
    XFile image, {
    required int maxWidth,
    required int quality,
  }) async {
    final targetPath = image.path.replaceAll(
      path.extension(image.path),
      '_compressed_${DateTime.now().millisecondsSinceEpoch}.jpg',
    );

    final result = await FlutterImageCompress.compressAndGetFile(
      image.path,
      targetPath,
      quality: quality,
      minWidth: maxWidth,
      format: CompressFormat.jpeg,
    );

    if (result == null) {
      throw Exception('Failed to compress image');
    }

    return File(result.path);
  }

  /// Delete old image from Firebase Storage
  Future<void> deleteOldImage(String? downloadUrl) async {
    if (downloadUrl == null || downloadUrl.isEmpty) return;

    try {
      final ref = _firebase.storage.refFromURL(downloadUrl);
      await ref.delete();
      debugPrint('✅ Old image deleted: $downloadUrl');
    } catch (e) {
      // Ignore deletion errors (file might not exist)
      debugPrint('⚠️ Failed to delete old image: $e');
    }
  }
}
