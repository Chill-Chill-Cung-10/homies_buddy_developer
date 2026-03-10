import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../entities/note_entity.dart';

/// Abstract Note Repository — Domain Layer Interface
abstract class NoteRepository {
  // ═══════════════════════════════════════════════════════════════════════════
  // READ OPERATIONS
  // ═══════════════════════════════════════════════════════════════════════════

  /// Get notes for current user
  Future<Either<Failure, List<NoteEntity>>> getCurrentUserNotes();

  /// Get notes for a specific date (lazy loading per day)
  Future<Either<Failure, List<NoteEntity>>> getNotesByDate(DateTime date);

  /// Get note by ID
  Future<Either<Failure, NoteEntity>> getNoteById(String noteId);

  /// Get notes by user ID with pagination
  Future<Either<Failure, List<NoteEntity>>> getNotesByUserId(
    String userId, {
    int limit = 20,
    String? lastNoteId,
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // CREATE OPERATIONS
  // ═══════════════════════════════════════════════════════════════════════════

  /// Create a new note
  ///
  /// [textContent] - Text content of the note
  /// [mediaFilePaths] - Local file paths of media to upload
  ///
  /// Returns: Created NoteEntity with uploaded media URLs
  Future<Either<Failure, NoteEntity>> createNote({
    required String textContent,
    List<String> mediaFilePaths = const [],
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // UPDATE OPERATIONS
  // ═══════════════════════════════════════════════════════════════════════════

  /// Update a note
  Future<Either<Failure, NoteEntity>> updateNote({
    required String noteId,
    String? textContent,
    List<String>? mediaFilePaths,
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // DELETE OPERATIONS
  // ═══════════════════════════════════════════════════════════════════════════

  /// Delete a note
  Future<Either<Failure, Unit>> deleteNote(String noteId);
}
