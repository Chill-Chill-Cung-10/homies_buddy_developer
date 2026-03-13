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

  // ── Guards ────────────────────────────────────────────────────────────────
  // Chống gọi RPC đồng thời hoặc quá gần nhau
  bool _isRunning = false;
  DateTime? _lastRanAt;

  // Tối thiểu 1 phút giữa 2 lần gọi RPC
  // Điều chỉnh nếu cần: Duration(minutes: 5) cho app ít update hơn
  static const _cooldown = Duration(seconds: 5);

  PetResumeNotifier(this._datasource, this._firebaseService)
      : super(PetResumeState.initial());

  /// Called on app resume (cold start + background return)
  Future<void> onAppResume() async {
    final userId = _firebaseService.currentUserId;
    if (userId == null) {
      _logger.w('🐾 Skip RPC: user not authenticated');
      return;
    }

    // ── [Guard 1] Đang chạy rồi → skip ───────────────────────────────────
    if (_isRunning) {
      _logger.w('🐾 Skip RPC: already running');
      return;
    }

    // ── [Guard 2] Cooldown chưa hết → skip ───────────────────────────────
    if (_lastRanAt != null &&
        DateTime.now().difference(_lastRanAt!) < _cooldown) {
      final secondsAgo = DateTime.now().difference(_lastRanAt!).inSeconds;
      _logger.w('🐾 Skip RPC: cooldown active (${secondsAgo}s ago)');
      return;
    }

    // ── Bắt đầu chạy ─────────────────────────────────────────────────────
    _isRunning = true;
    _lastRanAt = DateTime.now();
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
    } finally {
      // ── Luôn reset _isRunning dù thành công hay lỗi ───────────────────
      _isRunning = false;
    }
  }

  /// Reset cooldown — dùng khi muốn force update (ví dụ: sau khi submit note)
  void resetCooldown() {
    _lastRanAt = null;
    _logger.i('🐾 Cooldown reset');
  }

  void clearError() {
    state = state.copyWith(errorMessage: null);
  }

  /// Log all RPC state results + lý do mood được chọn
  void _logRpcResult(Map<String, dynamic> result) {
    final energy     = (result['energy']         as num?)?.toDouble() ?? 0.0;
    final mood       = result['current_mood']    as String? ?? '?';
    final tone       = result['user_tone']       as String? ?? '?';
    final trend      = result['emotional_trend'] as String? ?? '?';
    final severity   = result['severity']        as int?    ?? 0;
    final deltaHours = (result['delta_hours']    as num?)?.toDouble() ?? 0.0;
    final timeOfDay  = result['time_of_day']     as int?    ?? 0;

    // ── Energy level label ────────────────────────────────────────────────
    final energyLabel = energy < 0.20
        ? '🔴 CRITICAL  (<0.20 → sleep forced)'
        : energy < 0.40
            ? '🟠 LOW       (<0.40 → idle/sleep random)'
            : energy < 0.60
                ? '🟡 MEDIUM    (<0.60)'
                : '🟢 HIGH      (≥0.60)';

    // ── Lý do mood được chọn theo priority chain ──────────────────────────
    final moodReason = _inferMoodReason(
      tone: tone, severity: severity, deltaHours: deltaHours,
      energy: energy, trend: trend, mood: mood,
    );

    _logger.i('╔══════════ 🐾 PET RESUME RESULT ══════════╗');
    _logger.i('║  ENERGY');
    _logger.i('║    value:          ${energy.toStringAsFixed(3)}');
    _logger.i('║    level:          $energyLabel');
    _logger.i('║    delta_hours:    ${deltaHours}h since last interaction');
    _logger.i('║    time_of_day:    ${timeOfDay}h (VN)');
    _logger.i('║');
    _logger.i('║  MOOD');
    _logger.i('║    current_mood:   $mood');
    _logger.i('║    reason:         $moodReason');
    _logger.i('║');
    _logger.i('║  USER CONTEXT');
    _logger.i('║    user_tone:      $tone  (severity: $severity/5)');
    _logger.i('║    trend:          $trend');
    _logger.i('║');
    _logger.i('║  SESSION');
    _logger.i('║    streak:         ${result['streak']} days');
    _logger.i('║    visit_today:    ${result['visit_count_today']}');
    _logger.i('║    streak_changed: ${result['streak_changed']}');
    _logger.i('║    is_first_today: ${result['is_first_today']}');
    _logger.i('╚═══════════════════════════════════════════╝');
  }

  /// Suy luận lý do mood theo priority chain của resolve_pet_mood()
  String _inferMoodReason({
    required String tone,
    required int severity,
    required double deltaHours,
    required double energy,
    required String trend,
    required String mood,
  }) {
    const negTones = ['sad', 'very_sad', 'anxious'];
    if (negTones.contains(tone) && severity >= 4) {
      return '⚠️  [1] tone=$tone severity=$severity≥4 → healing override';
    }
    if (negTones.contains(tone)) {
      return '😢 [2] tone=$tone → forced sad';
    }
    if (tone == 'angry') {
      return '😤 [3] tone=angry → forced idle';
    }
    if (deltaHours > 48) {
      return '👀 [4] abandoned ${deltaHours.toStringAsFixed(1)}h >48h → looking_outside';
    }
    if (energy < 0.20) {
      return '😴 [5] energy=${energy.toStringAsFixed(3)} <0.20 → sleep';
    }
    if (energy < 0.40) {
      return '😑 [6] energy=${energy.toStringAsFixed(3)} <0.40 → idle/sleep (random)';
    }
    if (trend == 'declining') {
      return '📉 [7] trend=declining → sad';
    }
    if ((tone == 'happy' || tone == 'very_happy') && energy >= 0.60) {
      return '😊 [8] tone=$tone energy≥0.60 → happy/happy_smiling (random)';
    }
    return '😐 [9] neutral fallback trend=$trend → $mood';
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