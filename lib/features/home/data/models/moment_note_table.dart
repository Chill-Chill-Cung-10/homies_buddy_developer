/// Database constants for moment_note table
///
/// Supabase PostgreSQL table schema constants
abstract class MomentNoteTable {
  static const String name = 'moment_note';

  // Column names
  static const String id = 'id';
  static const String userId = 'user_id';
  static const String authorName = 'author_name';
  static const String authorAvatarUrl = 'author_avatar_url';
  static const String textContent = 'text_content';
  static const String mediaUrls = 'media_urls';
  static const String createdAt = 'created_at';
}
