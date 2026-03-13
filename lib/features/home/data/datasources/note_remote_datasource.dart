import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/services/firebase_service.dart';
import '../../../../core/services/storage_service.dart';
import '../models/moment_note_table.dart';
import '../models/note_model.dart';

/// Note Remote Datasource — Data Layer
///
/// Handles direct communication with Supabase (database) and
/// Firebase Storage (media files).
class NoteRemoteDatasource {
  final SupabaseClient _supabase;
  final FirebaseService _firebaseService;
  final StorageService _storageService;

  NoteRemoteDatasource({
    SupabaseClient? supabase,
    FirebaseService? firebaseService,
    StorageService? storageService,
  })  : _supabase = supabase ?? Supabase.instance.client,
        _firebaseService = firebaseService ?? FirebaseService.instance,
        _storageService = storageService ?? StorageService();

  /// Get current user ID from Firebase Auth
  String? get _currentUserId => _firebaseService.currentUserId;

  static const _userProfileTable = 'user_profile';

  // ═══════════════════════════════════════════════════════════════════════════
  // READ OPERATIONS
  // ═══════════════════════════════════════════════════════════════════════════

  /// Get notes for current user
  Future<List<NoteModel>> getCurrentUserNotes() async {
    final userId = _currentUserId;
    if (userId == null) throw Exception('User not authenticated');

    return getNotesByUserId(userId);
  }

  /// Get notes for current user filtered by date
  Future<List<NoteModel>> getCurrentUserNotesByDate(DateTime date) async {
    final userId = _currentUserId;
    if (userId == null) throw Exception('User not authenticated');

    final startOfDay = DateTime(date.year, date.month, date.day);
    final startOfNextDay = startOfDay.add(const Duration(days: 1));

    final response = await _supabase
        .from(MomentNoteTable.name)
        .select()
        .eq(MomentNoteTable.userId, userId)
        .gte(MomentNoteTable.createdAt, startOfDay.toIso8601String())
        .lt(MomentNoteTable.createdAt, startOfNextDay.toIso8601String())
        .order(MomentNoteTable.createdAt, ascending: false);

    return _hydrateNotesWithProfiles(response as List);
  }

  /// Get note by ID
  Future<NoteModel?> getNoteById(String noteId) async {
    final response = await _supabase
        .from(MomentNoteTable.name)
        .select()
        .eq(MomentNoteTable.id, noteId)
        .maybeSingle();

    if (response == null) return null;
    final hydratedNotes = await _hydrateNotesWithProfiles([response]);
    return hydratedNotes.isEmpty ? null : hydratedNotes.first;
  }

  /// Get notes by user ID with pagination
  Future<List<NoteModel>> getNotesByUserId(
    String userId, {
    int limit = 20,
    String? lastNoteId,
  }) async {
    var query = _supabase
        .from(MomentNoteTable.name)
        .select()
        .eq(MomentNoteTable.userId, userId)
        .order(MomentNoteTable.createdAt, ascending: false)
        .limit(limit);

    // Handle pagination with cursor
    if (lastNoteId != null) {
      final lastNote = await getNoteById(lastNoteId);
      if (lastNote != null) {
        query = _supabase
            .from(MomentNoteTable.name)
            .select()
            .eq(MomentNoteTable.userId, userId)
            .lt(MomentNoteTable.createdAt, lastNote.createdAt.toIso8601String())
            .order(MomentNoteTable.createdAt, ascending: false)
            .limit(limit);
      }
    }

    final response = await query;
    return _hydrateNotesWithProfiles(response as List);
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // CREATE OPERATIONS
  // ═══════════════════════════════════════════════════════════════════════════

  /// Create a new note with media upload
  Future<NoteModel> createNote({
    required String textContent,
    required String authorName,
    required String authorAvatarUrl,
    List<String> mediaFilePaths = const [],
  }) async {
    final userId = _currentUserId;
    if (userId == null) throw Exception('User not authenticated');

    // Generate note ID for storage path
    final noteId = DateTime.now().millisecondsSinceEpoch.toString();

    // Upload media files if any (images only)
    List<String> mediaUrls = [];
    if (mediaFilePaths.isNotEmpty) {
      mediaUrls = await _uploadMediaFiles(noteId, mediaFilePaths);
    }

    final profile = await _getUserProfile(userId);
    final resolvedAuthorName = _resolveAuthorName(
      profile: profile,
      fallbackAuthorName: authorName,
    );
    final resolvedAuthorAvatarUrl = _resolveAuthorAvatarUrl(
      profile: profile,
      fallbackAuthorAvatarUrl: authorAvatarUrl,
    );

    // Create note model
    final noteModel = NoteModel(
      id: '', // Will be assigned by database
      userId: userId,
      authorName: resolvedAuthorName,
      authorAvatarUrl: resolvedAuthorAvatarUrl,
      textContent: textContent,
      mediaUrls: mediaUrls,
      createdAt: DateTime.now(),
    );

    // Insert to database
    final response = await _supabase
        .from(MomentNoteTable.name)
        .insert(noteModel.toInsertMap())
        .select()
        .single();

    final hydratedNotes = await _hydrateNotesWithProfiles([response]);
    return hydratedNotes.first;
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // UPDATE OPERATIONS
  // ═══════════════════════════════════════════════════════════════════════════

  /// Update a note
  Future<NoteModel> updateNote({
    required String noteId,
    String? textContent,
    List<String>? mediaFilePaths,
  }) async {
    final existingNote = await getNoteById(noteId);
    if (existingNote == null) throw Exception('Note not found');

    // Upload new media if provided
    List<String>? mediaUrls;
    if (mediaFilePaths != null && mediaFilePaths.isNotEmpty) {
      // Delete old media first
      await _deleteMediaFiles(existingNote.mediaUrls);
      // Upload new media
      mediaUrls = await _uploadMediaFiles(noteId, mediaFilePaths);
    }

    // Build update map
    final updateMap = <String, dynamic>{};
    if (textContent != null) updateMap[MomentNoteTable.textContent] = textContent;
    if (mediaUrls != null) updateMap[MomentNoteTable.mediaUrls] = mediaUrls;

    if (updateMap.isEmpty) return existingNote;

    final response = await _supabase
        .from(MomentNoteTable.name)
        .update(updateMap)
        .eq(MomentNoteTable.id, noteId)
        .select()
        .single();

    final hydratedNotes = await _hydrateNotesWithProfiles([response]);
    return hydratedNotes.first;
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // DELETE OPERATIONS
  // ═══════════════════════════════════════════════════════════════════════════

  /// Delete a note
  Future<void> deleteNote(String noteId) async {
    final existingNote = await getNoteById(noteId);
    if (existingNote != null) {
      // Delete media files from storage
      await _deleteMediaFiles(existingNote.mediaUrls);
    }

    await _supabase
        .from(MomentNoteTable.name)
        .delete()
        .eq(MomentNoteTable.id, noteId);
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // PRIVATE HELPERS
  // ═══════════════════════════════════════════════════════════════════════════

  /// Upload media files to Firebase Storage
  Future<List<String>> _uploadMediaFiles(
    String noteId,
    List<String> filePaths,
  ) async {
    final userId = _currentUserId!;
    final xFiles = filePaths.map((path) => XFile(path)).toList();
    
    return await _storageService.uploadNoteMedia(
      userId: userId,
      noteId: noteId,
      files: xFiles,
    );
  }

  /// Delete media files from Firebase Storage
  Future<void> _deleteMediaFiles(List<String> mediaUrls) async {
    for (final url in mediaUrls) {
      await _storageService.deleteFile(url);
    }
  }

  Future<List<NoteModel>> _hydrateNotesWithProfiles(List rawNotes) async {
    final notes = rawNotes
        .whereType<Map>()
        .map((note) => NoteModel.fromMap(Map<String, dynamic>.from(note)))
        .toList();

    if (notes.isEmpty) return notes;

    final userIds = notes.map((note) => note.userId).toSet().toList();
    final profiles = await _getProfilesByUserIds(userIds);

    return notes.map((note) {
      final profile = profiles[note.userId];
      if (profile == null) return note;

      return note.copyWith(
        authorName: _resolveAuthorName(
          profile: profile,
          fallbackAuthorName: note.authorName,
        ),
        authorAvatarUrl: _resolveAuthorAvatarUrl(
          profile: profile,
          fallbackAuthorAvatarUrl: note.authorAvatarUrl,
        ),
      );
    }).toList();
  }

  Future<Map<String, dynamic>?> _getUserProfile(String userId) async {
    try {
      final response = await _supabase
          .from(_userProfileTable)
          .select('id, full_name, username, avatar_url')
          .eq('id', userId)
          .maybeSingle();

      return response == null ? null : Map<String, dynamic>.from(response);
    } catch (_) {
      return null;
    }
  }

  Future<Map<String, Map<String, dynamic>>> _getProfilesByUserIds(
    List<String> userIds,
  ) async {
    if (userIds.isEmpty) return const {};

    try {
      final response = await _supabase
          .from(_userProfileTable)
          .select('id, full_name, username, avatar_url')
          .inFilter('id', userIds);

      final profileMap = <String, Map<String, dynamic>>{};
      for (final rawProfile in response as List) {
        if (rawProfile is! Map) continue;
        final profile = Map<String, dynamic>.from(rawProfile);
        final id = profile['id'] as String?;
        if (id == null || id.isEmpty) continue;
        profileMap[id] = profile;
      }
      return profileMap;
    } catch (_) {
      return const {};
    }
  }

  String _resolveAuthorName({
    required Map<String, dynamic>? profile,
    required String fallbackAuthorName,
  }) {
    final fullName = (profile?['full_name'] as String?)?.trim();
    if (fullName != null && fullName.isNotEmpty) {
      return fullName;
    }

    final username = (profile?['username'] as String?)?.trim();
    if (username != null && username.isNotEmpty) {
      return username;
    }

    return fallbackAuthorName;
  }

  String _resolveAuthorAvatarUrl({
    required Map<String, dynamic>? profile,
    required String fallbackAuthorAvatarUrl,
  }) {
    final avatarUrl = (profile?['avatar_url'] as String?)?.trim();
    if (avatarUrl != null && avatarUrl.isNotEmpty) {
      return avatarUrl;
    }

    return fallbackAuthorAvatarUrl;
  }
}
