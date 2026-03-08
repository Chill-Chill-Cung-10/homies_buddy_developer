import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_follows_model.freezed.dart';
part 'user_follows_model.g.dart';

/// User Follows Model - Junction table lưu quan hệ follow giữa users
///
/// Thay thế cho computed field `isFollowedByMe` trên `USER_PROFILE`.
/// PK: Composite key (followerId, followingId) — mỗi cặp follow là duy nhất
@freezed
abstract class UserFollow with _$UserFollow {
  const factory UserFollow({
    /// User ID người follow
    required String followerId,

    /// User ID người được follow
    required String followingId,

    /// Thời gian follow
    required DateTime createdAt,
  }) = _UserFollow;

  factory UserFollow.fromJson(Map<String, dynamic> json) =>
      _$UserFollowFromJson(json);
}

/// Extension để thêm các helper methods
extension UserFollowX on UserFollow {
  /// Lấy thời gian follow dạng "time ago"
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
  String get compositeId => '$followerId:$followingId';

  /// Kiểm tra xem có phải mutual follow không (cần check cả chiều ngược)
  /// Lưu ý: Function này chỉ trả về true nếu coi self là một follow
  /// Cần check trong repository nếu có reverse follow
  bool get isMutualPotential => followerId.compareTo(followingId) < 0;
}
