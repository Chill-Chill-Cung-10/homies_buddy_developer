/// [Refactored] Phase 1.5 — Các hàm format dùng chung, trích xuất từ nhiều file
/// để tránh trùng lặp (_formatCount x3, _limitWords, _formatTime x2).
library;

/// Format số lượng lớn thành dạng ngắn gọn (1K, 1.5M, ...).
/// Dùng cho like count, comment count, follower count, v.v.
String formatCount(int count) {
  if (count >= 1000000) {
    return '${(count / 1000000).toStringAsFixed(1)}M';
  } else if (count >= 1000) {
    return '${(count / 1000).toStringAsFixed(1)}K';
  }
  return count.toString();
}

/// Giới hạn số từ trong chuỗi, thêm "..." nếu vượt quá [maxWords].
String limitWords(String text, int maxWords) {
  final words = text.split(RegExp(r'\s+'));
  if (words.length <= maxWords) return text;
  return '${words.take(maxWords).join(' ')}...';
}

/// Format thời gian tương đối (vd: "5m ago", "2h ago", "3d ago").
/// Dùng cho conversation history, notification timestamps.
String formatRelativeTime(DateTime dateTime) {
  final now = DateTime.now();
  final diff = now.difference(dateTime);

  if (diff.inMinutes < 60) {
    return '${diff.inMinutes}m ago';
  } else if (diff.inHours < 24) {
    return '${diff.inHours}h ago';
  } else if (diff.inDays < 7) {
    return '${diff.inDays}d ago';
  } else {
    return '${dateTime.day}/${dateTime.month}';
  }
}

/// Format thời gian dạng HH:mm (vd: "09:30", "14:05").
/// Dùng cho chat bubble timestamps.
String formatTimeHHmm(DateTime time) {
  final hour = time.hour.toString().padLeft(2, '0');
  final minute = time.minute.toString().padLeft(2, '0');
  return '$hour:$minute';
}
