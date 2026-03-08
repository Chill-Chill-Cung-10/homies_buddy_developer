import 'package:freezed_annotation/freezed_annotation.dart';

part 'post_likes_model.freezed.dart';
part 'post_likes_model.g.dart';

/// Post Likes Model - Junction table lưu trạng thái like của user với bài post
///
/// Thay thế cho computed field `isLikedByMe` trên `FEED_POST`.
/// PK: Composite key (userId, postId) — mỗi user chỉ like một post một lần
@freezed
abstract class PostLike with _$PostLike {
  const factory PostLike({
    /// User ID người like
    required String userId,

    /// Post ID được like
    required String postId,

    /// Thời gian like
    required DateTime createdAt,
  }) = _PostLike;

  factory PostLike.fromJson(Map<String, dynamic> json) =>
      _$PostLikeFromJson(json);
}

/// Extension để thêm các helper methods
extension PostLikeX on PostLike {
  /// Lấy thời gian like dạng "time ago"
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
  String get compositeId => '$userId:$postId';
}
