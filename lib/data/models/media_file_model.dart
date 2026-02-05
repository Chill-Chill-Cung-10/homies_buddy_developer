import 'package:freezed_annotation/freezed_annotation.dart';
import 'enums/media_type.dart';

part 'media_file_model.freezed.dart';
part 'media_file_model.g.dart';

/// Media File Model - Thông tin về file media trong bài post
/// 
/// Bao gồm ảnh, video, hoặc album với đầy đủ metadata
/// như kích thước, aspect ratio, và duration cho video
@freezed
class MediaFile with _$MediaFile {
  const factory MediaFile({
    required String id,
    String? thumbnailUrl,
    required MediaType mediaType,
    required double mediaAspectRatio,
    required String mediaUrl,
    required int width,
    required int height,
    int? durationSeconds,
  }) = _MediaFile;

  factory MediaFile.fromJson(Map<String, dynamic> json) =>
      _$MediaFileFromJson(json);
}

/// Extension để thêm các helper methods
extension MediaFileX on MediaFile {
  /// Kiểm tra xem có phải video không
  bool get isVideo => mediaType.isVideo;

  /// Kiểm tra xem có phải image không
  bool get isImage => mediaType.isImage;

  /// Kiểm tra xem có phải album không
  bool get isAlbum => mediaType.isAlbum;

  /// Lấy aspect ratio dạng string (vd: "16:9")
  String get aspectRatioString {
    if (mediaAspectRatio >= 1.7 && mediaAspectRatio <= 1.8) {
      return '16:9';
    } else if (mediaAspectRatio >= 0.55 && mediaAspectRatio <= 0.57) {
      return '9:16';
    } else if (mediaAspectRatio >= 1.3 && mediaAspectRatio <= 1.4) {
      return '4:3';
    } else if (mediaAspectRatio >= 0.99 && mediaAspectRatio <= 1.01) {
      return '1:1';
    }
    return '${width}:${height}';
  }

  /// Lấy duration dạng string (vd: "1:23")
  String get durationString {
    if (durationSeconds == null || !isVideo) return '';
    final minutes = durationSeconds! ~/ 60;
    final seconds = durationSeconds! % 60;
    return '${minutes}:${seconds.toString().padLeft(2, '0')}';
  }

  /// Kiểm tra xem video có dài không (> 1 phút)
  bool get isLongVideo {
    return isVideo && durationSeconds != null && durationSeconds! > 60;
  }

  /// Validate media file
  String? validate() {
    if (width <= 0 || height <= 0) {
      return 'Kích thước media không hợp lệ';
    }
    if (mediaAspectRatio <= 0) {
      return 'Aspect ratio không hợp lệ';
    }
    if (isVideo && durationSeconds != null && durationSeconds! <= 0) {
      return 'Duration video không hợp lệ';
    }
    if (mediaUrl.isEmpty) {
      return 'URL media không được để trống';
    }
    return null;
  }
}
