import 'package:freezed_annotation/freezed_annotation.dart';

/// Media Type - Loại media trong bài post
enum MediaType {
  @JsonValue('image')
  image,

  @JsonValue('video')
  video,

  @JsonValue('album')
  album;

  /// Chuyển từ string sang enum
  static MediaType fromString(String value) {
    return MediaType.values.firstWhere(
      (type) => type.name == value.toLowerCase(),
      orElse: () => MediaType.image,
    );
  }

  /// Convert sang string để hiển thị
  String get displayName {
    switch (this) {
      case MediaType.image:
        return 'Hình ảnh';
      case MediaType.video:
        return 'Video';
      case MediaType.album:
        return 'Album';
    }
  }

  /// Kiểm tra xem có phải video không
  bool get isVideo => this == MediaType.video;

  /// Kiểm tra xem có phải image không
  bool get isImage => this == MediaType.image;

  /// Kiểm tra xem có phải album không
  bool get isAlbum => this == MediaType.album;
}
