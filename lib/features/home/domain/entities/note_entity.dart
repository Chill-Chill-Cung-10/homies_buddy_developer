/// Note Entity — Pure Dart domain entity
///
/// Represents a personal moment/note in the Home tab.
/// No Flutter/Firebase/Supabase imports.
class NoteEntity {
  final String id;
  final String userId;
  final String authorName;
  final String authorAvatarUrl;
  final String textContent;
  final List<String> mediaUrls;
  final DateTime createdAt;

  const NoteEntity({
    required this.id,
    required this.userId,
    required this.authorName,
    required this.authorAvatarUrl,
    this.textContent = '',
    this.mediaUrls = const [],
    required this.createdAt,
  });

  /// Check if note has media
  bool get hasMedia => mediaUrls.isNotEmpty;

  /// Check if note has text
  bool get hasText => textContent.isNotEmpty;

  /// Copy with new values
  NoteEntity copyWith({
    String? id,
    String? userId,
    String? authorName,
    String? authorAvatarUrl,
    String? textContent,
    List<String>? mediaUrls,
    DateTime? createdAt,
  }) {
    return NoteEntity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      authorName: authorName ?? this.authorName,
      authorAvatarUrl: authorAvatarUrl ?? this.authorAvatarUrl,
      textContent: textContent ?? this.textContent,
      mediaUrls: mediaUrls ?? this.mediaUrls,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is NoteEntity && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
