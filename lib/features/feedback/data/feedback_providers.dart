import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FeedbackRepository {
  final SupabaseClient _supabase;

  FeedbackRepository(this._supabase);

  Future<void> submitFeedback({
    required String userId,
    required int moodIndex,
    required String moodLabel,
  }) async {
    await Future.wait([
      _supabase.from('user_feedback').insert({
        'user_id': userId,
        'mood_index': moodIndex,
        'mood_label': moodLabel,
      }),
      _supabase
          .from('user_profile')
          .update({'feedback_shown': true}).eq('id', userId),
    ]);
  }

  Future<void> skipFeedback({required String userId}) async {
    await _supabase
        .from('user_profile')
        .update({'feedback_shown': true}).eq('id', userId);
  }

  Future<bool> isFeedbackShown({required String userId}) async {
    final res = await _supabase
        .from('user_profile')
        .select('feedback_shown')
        .eq('id', userId)
        .single();
    return res['feedback_shown'] as bool? ?? false;
  }
}

final feedbackRepositoryProvider = Provider<FeedbackRepository>((ref) {
  return FeedbackRepository(Supabase.instance.client);
});

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError(
    'sharedPreferencesProvider must be overridden at app startup',
  );
});

class FeedbackState {
  final bool feedbackShown;
  final int noteCount;

  const FeedbackState({
    this.feedbackShown = false,
    this.noteCount = 0,
  });

  FeedbackState copyWith({bool? feedbackShown, int? noteCount}) {
    return FeedbackState(
      feedbackShown: feedbackShown ?? this.feedbackShown,
      noteCount: noteCount ?? this.noteCount,
    );
  }
}

class FeedbackNotifier extends StateNotifier<FeedbackState> {
  final FeedbackRepository _repo;
  final SharedPreferences _prefs;

  FeedbackNotifier(this._repo, this._prefs) : super(const FeedbackState());

  static const _noteCountKey = 'note_count';

  Future<void> init({required String userId}) async {
    final noteCount = _prefs.getInt(_noteCountKey) ?? 0;
    final feedbackShown = await _repo.isFeedbackShown(userId: userId);

    state = state.copyWith(
      noteCount: noteCount,
      feedbackShown: feedbackShown,
    );
  }

  bool onNoteCreated() {
    final newCount = state.noteCount + 1;
    _prefs.setInt(_noteCountKey, newCount);
    state = state.copyWith(noteCount: newCount);
    return newCount == 3 && !state.feedbackShown;
  }

  Future<void> submitFeedback({
    required String userId,
    required int moodIndex,
    required String moodLabel,
  }) async {
    await _repo.submitFeedback(
      userId: userId,
      moodIndex: moodIndex,
      moodLabel: moodLabel,
    );
    state = state.copyWith(feedbackShown: true);
  }

  Future<void> skipFeedback({required String userId}) async {
    await _repo.skipFeedback(userId: userId);
    state = state.copyWith(feedbackShown: true);
  }
}

final feedbackProvider =
    StateNotifierProvider<FeedbackNotifier, FeedbackState>((ref) {
  final repository = ref.watch(feedbackRepositoryProvider);
  final prefs = ref.watch(sharedPreferencesProvider);
  return FeedbackNotifier(repository, prefs);
});
