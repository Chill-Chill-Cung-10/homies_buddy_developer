import 'package:freezed_annotation/freezed_annotation.dart';

/// Post Privacy - Chế độ riêng tư của bài post
enum PostPrivacy {
  @JsonValue('public')
  public,

  @JsonValue('friends')
  friends,

  @JsonValue('private')
  private;

  /// Chuyển từ string sang enum
  static PostPrivacy fromString(String value) {
    return PostPrivacy.values.firstWhere(
      (privacy) => privacy.name == value.toLowerCase(),
      orElse: () => PostPrivacy.public,
    );
  }

  /// Convert sang string để hiển thị
  String get displayName {
    switch (this) {
      case PostPrivacy.public:
        return 'Công khai';
      case PostPrivacy.friends:
        return 'Bạn bè';
      case PostPrivacy.private:
        return 'Riêng tư';
    }
  }

  /// Icon name để hiển thị
  String get iconName {
    switch (this) {
      case PostPrivacy.public:
        return 'public';
      case PostPrivacy.friends:
        return 'people';
      case PostPrivacy.private:
        return 'lock';
    }
  }

  /// Kiểm tra xem có phải public không
  bool get isPublic => this == PostPrivacy.public;

  /// Kiểm tra xem có phải friends không
  bool get isFriendsOnly => this == PostPrivacy.friends;

  /// Kiểm tra xem có phải private không
  bool get isPrivate => this == PostPrivacy.private;
}
