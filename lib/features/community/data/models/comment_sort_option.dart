/// [Refactored] Phase 3.4 — Moved from mockdata/comment_mock_data.dart
/// CommentSortOption is a domain concept, not mock data.
enum CommentSortOption {
  latest('Latest comments'),
  mostReacted('Most reacted'),
  oldest('Oldest comments');

  final String displayName;
  const CommentSortOption(this.displayName);
}
