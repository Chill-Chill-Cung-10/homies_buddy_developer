import 'dart:async';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/services/firebase_service.dart';
import '../../data/datasources/pet_remote_datasource.dart';
import '../../data/models/pet_table.dart';

final _logger = Logger();

// ═══════════════════════════════════════════════════════════════════════════
// DATASOURCE PROVIDER
// ═══════════════════════════════════════════════════════════════════════════

final petRemoteDatasourceProvider = Provider<PetRemoteDatasource>((ref) {
  return PetRemoteDatasource(supabase: Supabase.instance.client);
});

// ═══════════════════════════════════════════════════════════════════════════
// STATE
// ═══════════════════════════════════════════════════════════════════════════

class PetResumeState {
  final bool isLoading;
  final String? errorMessage;
  final Map<String, dynamic>? rpcResult;

  const PetResumeState({
    this.isLoading = false,
    this.errorMessage,
    this.rpcResult,
  });

  PetResumeState copyWith({
    bool? isLoading,
    String? errorMessage,
    Map<String, dynamic>? rpcResult,
  }) =>
      PetResumeState(
        isLoading: isLoading ?? this.isLoading,
        errorMessage: errorMessage,
        rpcResult: rpcResult ?? this.rpcResult,
      );

  factory PetResumeState.initial() => const PetResumeState();
}

// ═══════════════════════════════════════════════════════════════════════════
// NOTIFIER
// ═══════════════════════════════════════════════════════════════════════════

class PetResumeNotifier extends StateNotifier<PetResumeState> {
  final PetRemoteDatasource _datasource;
  final FirebaseService _firebaseService;

  PetResumeNotifier(this._datasource, this._firebaseService)
      : super(PetResumeState.initial());

  /// Called on app resume (cold start + background return)
  Future<void> onAppResume() async {
    final userId = _firebaseService.currentUserId;
    if (userId == null) {
      _logger.w('🐾 Skip RPC: user not authenticated');
      return;
    }

    state = state.copyWith(isLoading: true, errorMessage: null);
    _logger.i('🐾 Starting update_pet_on_resume for user: $userId');

    try {
      final petData = await _datasource.getUserPet(userId);
      if (petData == null) {
        _logger.w('🐾 No pet found for user: $userId');
        state = state.copyWith(isLoading: false);
        return;
      }

      final petId = petData[PetTable.id] as String;
      _logger.i('🐾 Found pet: $petId — calling RPC...');

      final result = await _datasource.updatePetOnResume(
        petId: petId,
        userId: userId,
      );

      _logRpcResult(result);
      state = state.copyWith(isLoading: false, rpcResult: result);
    } on SocketException {
      _logger.e('🐾 No internet connection');
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'No internet connection. Pet state could not be updated.',
      );
    } on TimeoutException {
      _logger.e('🐾 Connection timed out');
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Connection timed out. Please check your network.',
      );
    } catch (e) {
      _logger.e('🐾 RPC update_pet_on_resume failed', error: e);
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to update pet state. Please try again.',
      );
    }
  }

  /// Task 6: Log all RPC state results
  void _logRpcResult(Map<String, dynamic> result) {
    _logger.i('═══ 🐾 RPC update_pet_on_resume RESULT ═══');
    _logger.i('  energy:            ${result['energy']}');
    _logger.i('  current_mood:      ${result['current_mood']}');
    _logger.i('  streak:            ${result['streak']}');
    _logger.i('  visit_count_today: ${result['visit_count_today']}');
    _logger.i('  delta_hours:       ${result['delta_hours']}');
    _logger.i('  time_of_day:       ${result['time_of_day']}');
    _logger.i('  streak_changed:    ${result['streak_changed']}');
    _logger.i('  is_first_today:    ${result['is_first_today']}');
    _logger.i('  user_tone:         ${result['user_tone']}');
    _logger.i('  emotional_trend:   ${result['emotional_trend']}');
    _logger.i('  severity:          ${result['severity']}');
    _logger.i('═════════════════════════════════════════════');
  }

  void clearError() {
    state = state.copyWith(errorMessage: null);
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// STATE NOTIFIER PROVIDER
// ═══════════════════════════════════════════════════════════════════════════

final petResumeProvider =
    StateNotifierProvider<PetResumeNotifier, PetResumeState>((ref) {
  final datasource = ref.watch(petRemoteDatasourceProvider);
  return PetResumeNotifier(datasource, FirebaseService.instance);
});
