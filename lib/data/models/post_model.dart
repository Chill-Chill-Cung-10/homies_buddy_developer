import 'package:freezed_annotation/freezed_annotation.dart';
import 'media_file_model.dart';
import 'enums/post_privacy.dart';

part 'post_model.freezed.dart';
part 'post_model.g.dart';

/// Post Model - Bài viết trong Community
/// 
/// Chứa đầy đủ thông tin về bài post bao gồm nội dung,
/// media files, tương tác (react, comment), và thông tin tác giả
@freezed
class Post with _$Post {  
  const factory Post({
    required String authorName,
    required String authorId,
    required String authorAvatar,
    required String postId,
    required DateTime createdAt,
    DateTime? updatedAt,
    required String contentText,
    required List<String> hashtags,
    required List<String> mentions,
    required List<MediaFile> mediaFiles,
    required int reactsCount,
    required int commentCount,
    required bool isLikedByMe,
    required PostPrivacy privacy,
  }) = _Post;

  factory Post.fromJson(Map<String, dynamic> json) => _$PostFromJson(json);
}

/// Extension để thêm các helper methods
extension PostX on Post {
  /// Kiểm tra xem post có được chỉnh sửa không
  bool get isEdited => updatedAt != null;

  /// Kiểm tra xem có phải post của mình không
  bool isAuthor(String currentUserId) => authorId == currentUserId;

  /// Kiểm tra xem có thể edit không (chỉ trong 24h)
  bool canEdit(String currentUserId) {
    if (!isAuthor(currentUserId)) return false;
    final now = DateTime.now();
    final difference = now.difference(createdAt);
    return difference.inHours < 24;
  }

  /// Kiểm tra xem có thể delete không
  bool canDelete(String currentUserId) => isAuthor(currentUserId);

  /// Lấy thời gian đăng dạng "time ago" (vd: "2 giờ trước")
  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(createdAt);

    if (difference.inDays > 7) {
      return '${createdAt.day}/${createdAt.month}/${createdAt.year}';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} ngày trước';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} giờ trước';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} phút trước';
    } else {
      return 'Vừa xong';
    }
  }

  /// Kiểm tra xem có media không
  bool get hasMedia => mediaFiles.isNotEmpty;

  /// Kiểm tra xem có video không
  bool get hasVideo => mediaFiles.any((media) => media.isVideo);

  /// Kiểm tra xem có hashtags không
  bool get hasHashtags => hashtags.isNotEmpty;

  /// Kiểm tra xem có mentions không
  bool get hasMentions => mentions.isNotEmpty;

  /// Lấy số lượng media
  int get mediaCount => mediaFiles.length;

  /// Validate post
  String? validate() {
    if (contentText.isEmpty && mediaFiles.isEmpty) {
      return 'Post phải có nội dung hoặc media';
    }
    if (contentText.length > 5000) {
      return 'Nội dung không được quá 5000 ký tự';
    }
    if (mediaFiles.length > 10) {
      return 'Không được đăng quá 10 media files';
    }
    if (reactsCount < 0 || commentCount < 0) {
      return 'Số lượng react/comment không hợp lệ';
    }
    return null;
  }
}
