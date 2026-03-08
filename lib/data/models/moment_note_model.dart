import 'package:freezed_annotation/freezed_annotation.dart';

part 'moment_note_model.freezed.dart';
part 'moment_note_model.g.dart';

/// Moment Note Model - Ghi chú/khoảnh khắc cá nhân trên trang Home
///
/// Lưu trữ thông tin bài đăng bao gồm nội dung text,
/// media files (ảnh/video), thông tin tác giả và thời gian đăng.
/// Liên kết với `NOTE_ANALYSIS` để store kết quả LLM analysis
@freezed
abstract class MomentNote with _$MomentNote {
  const factory MomentNote({
    required String id,

    /// ⭐ **Thêm mới** — User ID chủ sở hữu note
    required String userId,

    required String authorName,
    required String authorAvatarUrl,
    required DateTime createdAt,

    @Default('') String textContent,
    @Default([]) List<String> mediaUrls,
  }) = _MomentNote;

  factory MomentNote.fromJson(Map<String, dynamic> json) =>
      _$MomentNoteFromJson(json);
}

/// Extension để thêm các helper methods
extension MomentNoteX on MomentNote {
  /// Kiểm tra xem có media không
  bool get hasMedia => mediaUrls.isNotEmpty;

  /// Kiểm tra xem có text không
  bool get hasText => textContent.isNotEmpty;

  /// Lấy thời gian note dạng "time ago"
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

  /// Lấy preview text (cắt ngắn nếu quá dài)
  String get preview {
    if (textContent.length > 100) {
      return '${textContent.substring(0, 100)}...';
    }
    return textContent;
  }
}
