import 'package:freezed_annotation/freezed_annotation.dart';

part 'comment_model.freezed.dart';
part 'comment_model.g.dart';

/// Comment Model - Bình luận trong bài post
///
/// Chứa thông tin về comment bao gồm nội dung, tác giả,
/// và số lượng react. Trạng thái `isReactedByMe` là computed field
/// được query từ `COMMENT_REACTS` junction table.
@freezed
abstract class Comment with _$Comment {
  const factory Comment({
    required String commentId,
    required String postId,
    required String authorId,
    required String authorName,
    required String authorAvatar,
    required String contentText,
    required DateTime createdAt,
    DateTime? updatedAt,
    required int reactCount,
    // ❌ isReactedByMe REMOVED — computed field (query từ COMMENT_REACTS)
  }) = _Comment;

  factory Comment.fromJson(Map<String, dynamic> json) =>
      _$CommentFromJson(json);
}

/// Extension để thêm các helper methods
extension CommentX on Comment {
  /// Kiểm tra xem comment có được edit không
  bool get isEdited => updatedAt != null;

  /// Kiểm tra xem có phải comment của mình không
  bool isAuthor(String currentUserId) => authorId == currentUserId;

  /// Kiểm tra xem có thể edit không (chỉ trong 1h)
  bool canEdit(String currentUserId) {
    if (!isAuthor(currentUserId)) return false;
    final now = DateTime.now();
    final difference = now.difference(createdAt);
    return difference.inHours < 1;
  }

  /// Kiểm tra xem có thể delete không
  bool canDelete(String currentUserId) => isAuthor(currentUserId);

  /// Lấy thời gian đăng dạng "time ago"
  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(createdAt);

    if (difference.inDays > 0) {
      return '${difference.inDays} ngày trước';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} giờ trước';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} phút trước';
    } else {
      return 'Vừa xong';
    }
  }

  /// Kiểm tra xem có react không
  bool get hasReacts => reactCount > 0;

  /// Validate comment
  String? validate() {
    if (contentText.trim().isEmpty) {
      return 'Nội dung comment không được để trống';
    }
    if (contentText.length > 1000) {
      return 'Comment không được quá 1000 ký tự';
    }
    if (reactCount < 0) {
      return 'Số lượng react không hợp lệ';
    }
    return null;
  }
}
