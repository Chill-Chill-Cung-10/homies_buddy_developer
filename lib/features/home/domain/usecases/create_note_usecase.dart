import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../entities/note_entity.dart';
import '../repositories/note_repository.dart';

/// Create Note Use Case — Domain Layer
///
/// Creates a new personal moment note with optional media files.
/// Media files are compressed and uploaded to Firebase Storage.
class CreateNoteUseCase {
  final NoteRepository _repository;

  CreateNoteUseCase(this._repository);

  /// Execute the use case
  ///
  /// [params] - CreateNoteParams containing text content and media file paths
  ///
  /// Returns: Either<Failure, NoteEntity>
  Future<Either<Failure, NoteEntity>> call(CreateNoteParams params) async {
    // Validate input 
    if (params.textContent.trim().isEmpty && params.mediaFilePaths.isEmpty) {
      return const Left(
        ValidationFailure('Note must have content or media'),
      );
    }

    return _repository.createNote(
      textContent: params.textContent.trim(),
      mediaFilePaths: params.mediaFilePaths,
    );
  }
}

/// Parameters for CreateNoteUseCase
class CreateNoteParams {
  /// Text content of the note
  final String textContent;

  /// Local file paths of media to upload (images only)
  final List<String> mediaFilePaths;

  const CreateNoteParams({
    this.textContent = '',
    this.mediaFilePaths = const [],
  });

  /// Check if params are valid
  bool get isValid => textContent.trim().isNotEmpty || mediaFilePaths.isNotEmpty;
}
