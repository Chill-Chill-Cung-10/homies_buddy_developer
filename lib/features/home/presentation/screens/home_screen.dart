import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/spinning_nav_button.dart';
import '../providers/home_providers.dart';
import '../../../pet/presentation/providers/pet_providers.dart';
import '../widgets/calendar_item.dart';
import '../widgets/user_moments_box.dart';
import '../widgets/pet_animation_widget.dart';
import '../widgets/background_animation_widget.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final _petKey = GlobalKey<StatefulPetWidgetState>();
  String? _petId;

  // ── Realtime channel ──
  RealtimeChannel? _petChannel;

  // ── Lưu mood pending nếu widget chưa ready khi forceState được gọi ──
  PetState? _pendingMood;

  // ── Mapping DB mood string → PetState ──
  static PetState _mapMood(String mood) => switch (mood) {
        'happy'           => PetState.happy,
        'happy_smiling'   => PetState.happyVsSmilling,
        'sad'             => PetState.sad,
        'sleep'           => PetState.sleep,
        'looking_outside' => PetState.lookingOutside,
        _                 => PetState.idle,
      };

  // ── Background theo giờ ──
  BackgroundTime get _currentTimeOfDay {
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 8) return BackgroundTime.earlyMorning;
    if (hour >= 8 && hour < 12) return BackgroundTime.morning;
    if (hour >= 12 && hour < 18) return BackgroundTime.afternoon;
    return BackgroundTime.night;
  }

  // ── Apply mood lên FSM — delegate hoàn toàn cho FSM xử lý ──
  void _applyMood(
    PetState mood, {
    double energy = 1.0,
    bool withTransition = false,
  }) {
    final fsm = _petKey.currentState?.fsm;
    if (fsm == null) {
      _pendingMood = mood;
      debugPrint('[Pet] ⏳ FSM not ready → pending mood=$mood');
      return;
    }

    debugPrint('╔══ 🎬 FSM APPLY MOOD ══════════════════╗');
    debugPrint('║  dbMood:        ${fsm.dbMood}');
    debugPrint('║  current:       ${fsm.currentState} (inTransition=${fsm.isInTransition})');
    debugPrint('║  target mood:   $mood');
    debugPrint('║  energy:        ${energy.toStringAsFixed(3)}');
    debugPrint('║  withTransition:$withTransition');

    fsm.setMoodFromDB(mood, energy: energy, withTransition: withTransition);
    _pendingMood = null;

    debugPrint('║  after:         ${fsm.currentState} (inTransition=${fsm.isInTransition})');
    debugPrint('╚═══════════════════════════════════════╝');
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _initPet());
  }

  @override
  void dispose() {
    _petChannel?.unsubscribe();
    super.dispose();
  }

  Future<void> _initPet() async {
    await _showCurrentMood();
    _subscribePetChanges();
  }

  // ── Đọc current_mood từ DB → hiện ngay ──
  // Dùng Firebase Auth (không phải Supabase Auth)
  Future<void> _showCurrentMood() async {
    try {
      final firebaseUser = FirebaseAuth.instance.currentUser;
      final supaUser = Supabase.instance.client.auth.currentUser;
      debugPrint('[Pet] DEBUG supaUser=${supaUser?.id} firebaseUser=${firebaseUser?.uid}');
      if (firebaseUser == null) {
        debugPrint('[Pet] ❌ _showCurrentMood: Firebase user is null → skip');
        return;
      }

      debugPrint('[Pet] 🔍 querying pet for uid=${firebaseUser.uid}');

      final petRow = await Supabase.instance.client
          .from('pet')
          .select('id, current_mood, energy, baseline_energy')
          .eq('user_id', firebaseUser.uid)
          .maybeSingle();

      if (!mounted) return;

      if (petRow == null) {
        debugPrint('[Pet] ❌ no pet row found for uid=${firebaseUser.uid}');
        await Future.delayed(Duration.zero);
        if (mounted) _applyMood(PetState.idle);
        return;
      }

      _petId = petRow['id'] as String;
      final mood     = petRow['current_mood']     as String? ?? 'idle';
      final energy   = (petRow['energy']          as num?)?.toDouble() ?? 0.0;
      final baseline = (petRow['baseline_energy'] as num?)?.toDouble() ?? 0.5;

      debugPrint('╔══ 🐾 INITIAL PET STATE ══════════════╗');
      debugPrint('║  pet_id:       $_petId');
      debugPrint('║  current_mood: $mood → ${_mapMood(mood)}');
      debugPrint('║  energy:       ${energy.toStringAsFixed(3)}');
      debugPrint('║  baseline:     ${baseline.toStringAsFixed(3)}');
      debugPrint('╚══════════════════════════════════════╝');

      await Future.delayed(Duration.zero);
      if (!mounted) return;

      _applyMood(_mapMood(mood), energy: energy);

    } catch (e) {
      debugPrint('[Pet] ❌ _showCurrentMood error: $e');
      await Future.delayed(Duration.zero);
      if (mounted) _applyMood(PetState.idle);
    }
  }

  // ── Lắng nghe thay đổi mood realtime từ DB ──
  // Trigger khi analyzeNote (Firebase Function) update pet table
  void _subscribePetChanges() {
    if (_petId == null) return;

    _petChannel = Supabase.instance.client
        .channel('pet:$_petId')
        .onPostgresChanges(
          event: PostgresChangeEvent.update,
          schema: 'public',
          table: 'pet',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'id',
            value: _petId!,
          ),
          callback: (payload) {
            if (!mounted) return;
            final rec      = payload.newRecord;
            final newMood  = rec['current_mood'] as String?;
            if (newMood == null) return;
            final energy   = (rec['energy']          as num?)?.toDouble() ?? 0.0;
            final baseline = (rec['baseline_energy'] as num?)?.toDouble() ?? 0.5;
            final mapped   = _mapMood(newMood);
            final fsm      = _petKey.currentState?.fsm;
            final curState = fsm?.currentState?.toString() ?? 'unknown';

            debugPrint('╔══ 🔴 REALTIME UPDATE (analyzeNote) ══════════╗');
            debugPrint('║  MOOD');
            debugPrint('║    db_mood:     $newMood → $mapped');
            debugPrint('║    fsm_before:  $curState');
            debugPrint('║  ENERGY');
            debugPrint('║    energy:      ${energy.toStringAsFixed(3)}');
            debugPrint('║    baseline:    ${baseline.toStringAsFixed(3)}');
            debugPrint('║  ACTION: transitionTo($mapped)');
            debugPrint('╚═══════════════════════════════════════════════╝');

            _applyMood(mapped, energy: energy, withTransition: true);

            // Log FSM state sau khi apply (next frame)
            WidgetsBinding.instance.addPostFrameCallback((_) {
              final fsmAfter = _petKey.currentState?.fsm;
              debugPrint('[Pet] FSM after transition: ${fsmAfter?.currentState} '
                  'isTransition=\${fsmAfter?.isInTransition}');
            });
          },
        )
        .subscribe((status, [_]) {
          debugPrint('[Pet] realtime status=$status');
        });
  }

  // ── Nhận mood update từ petResumeProvider (RPC result) ──
  // Tách ra method riêng để không tạo closure mới mỗi lần build()
  void _onResumeProviderUpdate(PetResumeState? prev, PetResumeState next) {
    if (next.rpcResult == null) return;
    if (next.rpcResult == prev?.rpcResult) return;

    final newMood  = next.rpcResult!['current_mood'] as String?;
    if (newMood == null) return;

    final energy = (next.rpcResult!['energy'] as num?)?.toDouble() ?? 1.0;

    debugPrint('╔══ 🟢 RESUME PROVIDER UPDATE ══╗');
    debugPrint('║  source:    petResumeProvider (RPC result)');
    debugPrint('║  new_mood:  $newMood → ${_mapMood(newMood)}');
    debugPrint('║  energy:    ${energy.toStringAsFixed(3)}');
    debugPrint('╚═══════════════════════════════╝');
    _applyMood(_mapMood(newMood), energy: energy, withTransition: true);
  }

  @override
  Widget build(BuildContext context) {
    final screenSize         = MediaQuery.of(context).size;
    final isCalendarExpanded = ref.watch(calendarExpandedProvider);

    // ref.listen trong ConsumerStatefulWidget.build() là đúng theo Riverpod docs
    // Riverpod đảm bảo callback chỉ fire khi state thực sự thay đổi,
    // không bị duplicate dù build() chạy lại nhiều lần
    ref.listen<PetResumeState>(petResumeProvider, _onResumeProviderUpdate);

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 0,
      ),
      body: Stack(
        children: [
          // ── Background ──
          Positioned.fill(
            child: ImageBackgroundWidget(timeOfDay: _currentTimeOfDay),
          ),

          // ── Pet ──
          Positioned(
            left: 0,
            right: 0,
            top: screenSize.height * 0.63,
            child: Align(
              alignment: const Alignment(0.54, 0),
              child: StatefulPetWidget(
                key: _petKey,
                width: screenSize.width * 0.5,
                height: screenSize.width * 0.5,
                autoPlay: false,  // ← FSM tự quản lý qua startAutoBehavior()
                initialState: PetState.idle,
                onReady: () {
                  // Callback khi StatefulPetWidget đã mount xong
                  // Apply pending mood nếu query DB xong trước khi widget ready
                  if (_pendingMood != null) {
                    debugPrint('[Pet] applying pending mood=$_pendingMood');
                    _applyMood(_pendingMood!);
                  }
                },
              ),
            ),
          ),

          // ── Barrier khi calendar expanded ──
          if (isCalendarExpanded)
            Positioned.fill(
              child: GestureDetector(
                onTap: () =>
                    ref.read(calendarExpandedProvider.notifier).state = false,
                child: Container(color: Colors.transparent),
              ),
            ),

          // ── Top: Settings & Calendar ──
          Positioned(
            top: 16,
            left: 2,
            right: 2,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 17),
                  child: const SpinningNavButton(iconColor: Colors.black),
                ),
                const SizedBox(width: 8),
                const Expanded(child: CozyCalendar()),
                const SizedBox(width: 8),
                // Container(
                //   margin: const EdgeInsets.only(top: 17),
                //   child: IconButton(
                //     icon: const Icon(
                //       Icons.grid_view_rounded,
                //       color: Colors.white,
                //     ),
                //     onPressed: () {},
                //   ),
                // ),
              ],
            ),
          ),

          // ── Bottom: User Moments ──
          const Positioned(
            bottom: 18,
            left: 24,
            right: 24,
            child: UserMomentsBox(),
          ),
        ],
      ),
    );
  }
}