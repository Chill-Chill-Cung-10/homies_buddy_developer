import 'package:freezed_annotation/freezed_annotation.dart';

part 'comment_reacts_model.freezed.dart';
part 'comment_reacts_model.g.dart';

/// Comment Reacts Model - Junction table lưu trạng thái react của user với comment
///
/// Tương tự `POST_LIKES`, thay thế computed field `isReactedByMe` trên `FEED_COMMENT`.
/// PK: Composite key (userId, commentId) — mỗi user chỉ react một comment một lần
@freezed
abstract class CommentReact with _$CommentReact {
  const factory CommentReact({
    /// User ID người react
    required String userId,

    /// Comment ID được react
    required String commentId,

    /// Thời gian react
    required DateTime createdAt,
  }) = _CommentReact;

  factory CommentReact.fromJson(Map<String, dynamic> json) =>
      _$CommentReactFromJson(json);
}

/// Extension để thêm các helper methods
extension CommentReactX on CommentReact {
  /// Lấy thời gian react dạng "time ago"
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

  /// Composite ID để dễ so sánh
  String get compositeId => '$userId:$commentId';
}
