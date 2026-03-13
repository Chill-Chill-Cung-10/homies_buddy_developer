import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/services/firebase_service.dart';
import '../../../../core/services/storage_service.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../data/datasources/note_remote_datasource.dart';
import '../../data/repositories/note_repository_impl.dart';
import '../../domain/entities/note_entity.dart';
import '../../domain/repositories/note_repository.dart';
import '../../domain/usecases/create_note_usecase.dart';
import '../../../profile/presentation/providers/profile_providers.dart';

final _logger = Logger();

// ═══════════════════════════════════════════════════════════════════════════
// DATASOURCE & REPOSITORY PROVIDERS
// ═══════════════════════════════════════════════════════════════════════════

/// Note Remote Datasource Provider
final noteRemoteDatasourceProvider = Provider<NoteRemoteDatasource>((ref) {
  return NoteRemoteDatasource(
    supabase: Supabase.instance.client,
    firebaseService: FirebaseService.instance,
    storageService: StorageService(),
  );
});

/// Note Repository Provider
final noteRepositoryProvider = Provider<NoteRepository>((ref) {
  final datasource = ref.watch(noteRemoteDatasourceProvider);
  final profile = ref.watch(currentUserProfileProvider);
  final authUser = ref.watch(currentAuthUserProvider);

  return NoteRepositoryImpl(
    remoteDatasource: datasource,
    getCurrentUserName: () =>
        ((profile?.fullName.isNotEmpty ?? false)
            ? profile!.fullName
            : profile?.username) ??
        authUser?.fullName ??
        authUser?.username ??
        'Me',
    getCurrentUserAvatar: () => profile?.avatarUrl ?? authUser?.avatarUrl ?? '',
  );
});

// ═══════════════════════════════════════════════════════════════════════════
// USECASE PROVIDERS
// ═══════════════════════════════════════════════════════════════════════════

/// Create Note UseCase Provider
final createNoteUseCaseProvider = Provider<CreateNoteUseCase>((ref) {
  final repository = ref.watch(noteRepositoryProvider);
  return CreateNoteUseCase(repository);
});

// ═══════════════════════════════════════════════════════════════════════════
// STATE
// ═══════════════════════════════════════════════════════════════════════════

/// Notes State
class NotesState {
  final List<NoteEntity> notes;
  final bool isLoading;
  final String? errorMessage;
  final bool isCreating;

  const NotesState({
    this.notes = const [],
    this.isLoading = false,
    this.errorMessage,
    this.isCreating = false,
  });

  NotesState copyWith({
    List<NoteEntity>? notes,
    bool? isLoading,
    String? errorMessage,
    bool? isCreating,
  }) =>
      NotesState(
        notes: notes ?? this.notes,
        isLoading: isLoading ?? this.isLoading,
        errorMessage: errorMessage,
        isCreating: isCreating ?? this.isCreating,
      );

  factory NotesState.initial() => const NotesState();
  factory NotesState.loading() => const NotesState(isLoading: true);
  factory NotesState.error(String msg) => NotesState(errorMessage: msg);
  factory NotesState.loaded(List<NoteEntity> notes) => NotesState(notes: notes);
}

// ═══════════════════════════════════════════════════════════════════════════
// NOTIFIER
// ═══════════════════════════════════════════════════════════════════════════

/// Notes Notifier — StateNotifier for notes management
class NotesNotifier extends StateNotifier<NotesState> {
  final NoteRepository _repository;
  final CreateNoteUseCase _createNoteUseCase;

  NotesNotifier({
    required NoteRepository repository,
    required CreateNoteUseCase createNoteUseCase,
  })  : _repository = repository,
        _createNoteUseCase = createNoteUseCase,
        super(NotesState.initial());

  /// Load current user's notes (all)
  Future<void> loadNotes() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    _logger.i('📋 Loading all notes...');

    try {
      final result = await _repository.getCurrentUserNotes();
      if (!mounted) return;
      result.fold(
        (failure) {
          _logger.e('❌ Failed to load notes: ${failure.message}');
          state = state.copyWith(
            isLoading: false,
            errorMessage: failure.message,
          );
        },
        (notes) {
          _logger.i('✅ Loaded ${notes.length} notes');
          state = state.copyWith(isLoading: false, notes: notes);
        },
      );
    } catch (e) {
      _logger.e('❌ Unexpected error loading notes: $e');
      if (mounted) {
        state = state.copyWith(isLoading: false, errorMessage: 'Unexpected error: $e');
      }
    }
  }

  /// Load notes for a specific date (lazy loading per day)
  Future<void> loadNotesByDate(DateTime date) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    _logger.i('📋 Loading notes for: ${date.toIso8601String()}');

    try {
      final result = await _repository.getNotesByDate(date);
      if (!mounted) return;
      result.fold(
        (failure) {
          _logger.e('❌ Failed to load notes by date: ${failure.message}');
          state = state.copyWith(
            isLoading: false,
            errorMessage: failure.message,
          );
        },
        (notes) {
          _logger.i('✅ Loaded ${notes.length} notes for ${date.toIso8601String()}');
          state = state.copyWith(isLoading: false, notes: notes);
        },
      );
    } catch (e) {
      _logger.e('❌ Unexpected error loading notes by date: $e');
      if (mounted) {
        state = state.copyWith(isLoading: false, errorMessage: 'Unexpected error: $e');
      }
    }
  }

  /// Create a new note
  Future<bool> createNote({
    required String textContent,
    List<String> mediaFilePaths = const [],
    DateTime? refreshDate,
    Duration lazyLoadDelay = const Duration(seconds: 3),
  }) async {
    state = state.copyWith(isCreating: true, errorMessage: null);
    _logger.i(
      'Creating note - text: ${textContent.length} chars, '
      'media: ${mediaFilePaths.length} files',
    );

    final params = CreateNoteParams(
      textContent: textContent,
      mediaFilePaths: mediaFilePaths,
    );

    try {
      final result = await _createNoteUseCase(params);
      if (!mounted) return false;

      return result.fold(
        (failure) {
          _logger.e('Failed to create note: ${failure.message}');
          state = state.copyWith(
            isCreating: false,
            errorMessage: failure.message,
          );
          return false;
        },
        (note) async {
          _logger.i('Note created: ${note.id}');
          if (lazyLoadDelay > Duration.zero) {
            _logger.i(
              'Delaying note refresh for ${lazyLoadDelay.inMilliseconds}ms',
            );
          }
          return _finishCreateNote(
            note: note,
            refreshDate: refreshDate,
            lazyLoadDelay: lazyLoadDelay,
          );
        },
      );
    } catch (e) {
      _logger.e('Unexpected error creating note: $e');
      if (mounted) {
        state = state.copyWith(
          isCreating: false,
          errorMessage: 'Unexpected error: $e',
        );
      }
      return false;
    }
  }

  Future<bool> _finishCreateNote({
    required NoteEntity note,
    DateTime? refreshDate,
    required Duration lazyLoadDelay,
  }) async {
    if (lazyLoadDelay > Duration.zero) {
      await Future.delayed(lazyLoadDelay);
    }

    if (!mounted) return false;

    if (refreshDate != null) {
      final refreshResult = await _repository.getNotesByDate(refreshDate);
      if (!mounted) return false;

      return refreshResult.fold(
        (failure) {
          _logger.e(
            'Failed to refresh notes after create: ${failure.message}',
          );
          state = state.copyWith(
            isCreating: false,
            errorMessage: failure.message,
          );
          return false;
        },
        (notes) {
          _logger.i(
            'Refreshed ${notes.length} notes after delayed create',
          );
          state = state.copyWith(
            isCreating: false,
            errorMessage: null,
            notes: notes,
          );
          return true;
        },
      );
    }

    state = state.copyWith(
      isCreating: false,
      notes: [note, ...state.notes],
      errorMessage: null,
    );
    return true;
  }

  /// Update a note
  Future<bool> updateNote({
    required String noteId,
    String? textContent,
    List<String>? mediaFilePaths,
  }) async {
    _logger.i('📝 Updating note: $noteId');

    try {
      final result = await _repository.updateNote(
        noteId: noteId,
        textContent: textContent,
        mediaFilePaths: mediaFilePaths,
      );
      if (!mounted) return false;

      return result.fold(
        (failure) {
          _logger.e('❌ Failed to update note: ${failure.message}');
          state = state.copyWith(errorMessage: failure.message);
          return false;
        },
        (updatedNote) {
          _logger.i('✅ Note updated: $noteId');
          state = state.copyWith(
            notes: state.notes
                .map<NoteEntity>((n) => n.id == noteId ? updatedNote : n)
                .toList(),
          );
          return true;
        },
      );
    } catch (e) {
      _logger.e('❌ Unexpected error updating note: $e');
      if (mounted) {
        state = state.copyWith(errorMessage: 'Unexpected error: $e');
      }
      return false;
    }
  }

  /// Delete a note
  Future<bool> deleteNote(String noteId) async {
    _logger.i('🗑️ Deleting note: $noteId');

    try {
      final result = await _repository.deleteNote(noteId);
      if (!mounted) return false;

      return result.fold(
        (failure) {
          _logger.e('❌ Failed to delete note: ${failure.message}');
          state = state.copyWith(errorMessage: failure.message);
          return false;
        },
        (_) {
          _logger.i('✅ Note deleted: $noteId');
          state = state.copyWith(
            notes: state.notes.where((n) => n.id != noteId).toList(),
          );
          return true;
        },
      );
    } catch (e) {
      _logger.e('❌ Unexpected error deleting note: $e');
      if (mounted) {
        state = state.copyWith(errorMessage: 'Unexpected error: $e');
      }
      return false;
    }
  }

  /// Clear error message
  void clearError() {
    state = state.copyWith(errorMessage: null);
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// STATE NOTIFIER PROVIDER
// ═══════════════════════════════════════════════════════════════════════════

/// Notes Provider — StateNotifierProvider
final notesProvider = StateNotifierProvider<NotesNotifier, NotesState>((ref) {
  final repository = ref.watch(noteRepositoryProvider);
  final createNoteUseCase = ref.watch(createNoteUseCaseProvider);

  return NotesNotifier(
    repository: repository,
    createNoteUseCase: createNoteUseCase,
  );
});
