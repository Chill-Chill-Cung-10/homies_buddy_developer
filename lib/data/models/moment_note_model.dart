/// Model cho một Moment Note - ghi chú cá nhân trên trang Home
///
/// Lưu trữ thông tin bài đăng bao gồm nội dung text,
/// media files (ảnh/video), thông tin tác giả và thời gian đăng
class MomentNote {
  final String id;
  final String authorName;
  final String authorAvatarUrl;
  final DateTime createdAt;
  final String textContent;
  final List<String> mediaUrls;

  const MomentNote({
    required this.id,
    required this.authorName,
    required this.authorAvatarUrl,
    required this.createdAt,
    this.textContent = '',
    this.mediaUrls = const [],
  });

  bool get hasMedia => mediaUrls.isNotEmpty;
  bool get hasText => textContent.isNotEmpty;
}
