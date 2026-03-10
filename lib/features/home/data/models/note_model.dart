import '../../domain/entities/note_entity.dart';
import 'moment_note_table.dart';

/// Note Data Model — Data Layer
///
/// Handles mapping between database format and domain entity.
/// Contains fromMap/toMap for Supabase PostgreSQL operations.
class NoteModel {
  final String id;
  final String userId;
  final String authorName;
  final String authorAvatarUrl;
  final String textContent;
  final List<String> mediaUrls;
  final DateTime createdAt;

  const NoteModel({
    required this.id,
    required this.userId,
    required this.authorName,
    required this.authorAvatarUrl,
    this.textContent = '',
    this.mediaUrls = const [],
    required this.createdAt,
  });

  /// Create from database map
  factory NoteModel.fromMap(Map<String, dynamic> map) {
    return NoteModel(
      id: map[MomentNoteTable.id] as String? ?? '',
      userId: map[MomentNoteTable.userId] as String? ?? '',
      authorName: map[MomentNoteTable.authorName] as String? ?? '',
      authorAvatarUrl: map[MomentNoteTable.authorAvatarUrl] as String? ?? '',
      textContent: map[MomentNoteTable.textContent] as String? ?? '',
      mediaUrls: _parseMediaUrls(map[MomentNoteTable.mediaUrls]),
      createdAt: _parseDateTime(map[MomentNoteTable.createdAt]),
    );
  }

  /// Convert to database map
  Map<String, dynamic> toMap() => {
        MomentNoteTable.id: id,
        MomentNoteTable.userId: userId,
        MomentNoteTable.authorName: authorName,
        MomentNoteTable.authorAvatarUrl: authorAvatarUrl,
        MomentNoteTable.textContent: textContent,
        MomentNoteTable.mediaUrls: mediaUrls,
        MomentNoteTable.createdAt: createdAt.toIso8601String(),
      };

  /// Convert to map for insert (without id, let database generate)
  Map<String, dynamic> toInsertMap() => {
        MomentNoteTable.userId: userId,
        MomentNoteTable.authorName: authorName,
        MomentNoteTable.authorAvatarUrl: authorAvatarUrl,
        MomentNoteTable.textContent: textContent,
        MomentNoteTable.mediaUrls: mediaUrls,
      };

  /// Convert to domain entity
  NoteEntity toEntity() => NoteEntity(
        id: id,
        userId: userId,
        authorName: authorName,
        authorAvatarUrl: authorAvatarUrl,
        textContent: textContent,
        mediaUrls: mediaUrls,
        createdAt: createdAt,
      );

  /// Create from domain entity
  factory NoteModel.fromEntity(NoteEntity entity) => NoteModel(
        id: entity.id,
        userId: entity.userId,
        authorName: entity.authorName,
        authorAvatarUrl: entity.authorAvatarUrl,
        textContent: entity.textContent,
        mediaUrls: entity.mediaUrls,
        createdAt: entity.createdAt,
      );

  /// Copy with new values
  NoteModel copyWith({
    String? id,
    String? userId,
    String? authorName,
    String? authorAvatarUrl,
    String? textContent,
    List<String>? mediaUrls,
    DateTime? createdAt,
  }) {
    return NoteModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      authorName: authorName ?? this.authorName,
      authorAvatarUrl: authorAvatarUrl ?? this.authorAvatarUrl,
      textContent: textContent ?? this.textContent,
      mediaUrls: mediaUrls ?? this.mediaUrls,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  // Helper: Parse media URLs from database
  static List<String> _parseMediaUrls(dynamic value) {
    if (value == null) return [];
    if (value is List) {
      return value.map((e) => e.toString()).toList();
    }
    return [];
  }

  // Helper: Parse DateTime from database
  static DateTime _parseDateTime(dynamic value) {
    if (value == null) return DateTime.now();
    if (value is DateTime) return value;
    if (value is String) return DateTime.tryParse(value) ?? DateTime.now();
    return DateTime.now();
  }
}
