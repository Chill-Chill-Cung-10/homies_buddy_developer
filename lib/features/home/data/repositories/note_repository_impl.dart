import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/note_entity.dart';
import '../../domain/repositories/note_repository.dart';
import '../datasources/note_remote_datasource.dart';

/// Note Repository Implementation — Data Layer
///
/// Implements NoteRepository interface from domain layer.
class NoteRepositoryImpl implements NoteRepository {
  final NoteRemoteDatasource _remoteDatasource;

  /// Current user info (should be injected from auth provider)
  final String Function() _getCurrentUserName;
  final String Function() _getCurrentUserAvatar;

  NoteRepositoryImpl({
    required NoteRemoteDatasource remoteDatasource,
    required String Function() getCurrentUserName,
    required String Function() getCurrentUserAvatar,
  })  : _remoteDatasource = remoteDatasource,
        _getCurrentUserName = getCurrentUserName,
        _getCurrentUserAvatar = getCurrentUserAvatar;

  // ═══════════════════════════════════════════════════════════════════════════
  // READ OPERATIONS
  // ═══════════════════════════════════════════════════════════════════════════

  @override
  Future<Either<Failure, List<NoteEntity>>> getCurrentUserNotes() async {
    try {
      final notes = await _remoteDatasource.getCurrentUserNotes();
      return Right(notes.map((n) => n.toEntity()).toList());
    } catch (e) {
      return Left(ServerFailure('Failed to get notes: $e'));
    }
  }

  @override
  Future<Either<Failure, List<NoteEntity>>> getNotesByDate(
    DateTime date,
  ) async {
    try {
      final notes = await _remoteDatasource.getCurrentUserNotesByDate(date);
      return Right(notes.map((n) => n.toEntity()).toList());
    } catch (e) {
      return Left(ServerFailure('Failed to get notes for date: $e'));
    }
  }

  @override
  Future<Either<Failure, NoteEntity>> getNoteById(String noteId) async {
    try {
      final note = await _remoteDatasource.getNoteById(noteId);
      if (note == null) {
        return const Left(ServerFailure('Note not found'));
      }
      return Right(note.toEntity());
    } catch (e) {
      return Left(ServerFailure('Failed to get note: $e'));
    }
  }

  @override
  Future<Either<Failure, List<NoteEntity>>> getNotesByUserId(
    String userId, {
    int limit = 20,
    String? lastNoteId,
  }) async {
    try {
      final notes = await _remoteDatasource.getNotesByUserId(
        userId,
        limit: limit,
        lastNoteId: lastNoteId,
      );
      return Right(notes.map((n) => n.toEntity()).toList());
    } catch (e) {
      return Left(ServerFailure('Failed to get notes: $e'));
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // CREATE OPERATIONS
  // ═══════════════════════════════════════════════════════════════════════════

  @override
  Future<Either<Failure, NoteEntity>> createNote({
    required String textContent,
    List<String> mediaFilePaths = const [],
  }) async {
    try {
      final note = await _remoteDatasource.createNote(
        textContent: textContent,
        authorName: _getCurrentUserName(),
        authorAvatarUrl: _getCurrentUserAvatar(),
        mediaFilePaths: mediaFilePaths,
      );
      return Right(note.toEntity());
    } catch (e) {
      return Left(ServerFailure('Failed to create note: $e'));
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // UPDATE OPERATIONS
  // ═══════════════════════════════════════════════════════════════════════════

  @override
  Future<Either<Failure, NoteEntity>> updateNote({
    required String noteId,
    String? textContent,
    List<String>? mediaFilePaths,
  }) async {
    try {
      final note = await _remoteDatasource.updateNote(
        noteId: noteId,
        textContent: textContent,
        mediaFilePaths: mediaFilePaths,
      );
      return Right(note.toEntity());
    } catch (e) {
      return Left(ServerFailure('Failed to update note: $e'));
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // DELETE OPERATIONS
  // ═══════════════════════════════════════════════════════════════════════════

  @override
  Future<Either<Failure, Unit>> deleteNote(String noteId) async {
    try {
      await _remoteDatasource.deleteNote(noteId);
      return const Right(unit);
    } catch (e) {
      return Left(ServerFailure('Failed to delete note: $e'));
    }
  }
}
