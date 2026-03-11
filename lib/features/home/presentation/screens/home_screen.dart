import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

  // ── Apply mood lên FSM — an toàn với null check ──
  void _applyMood(PetState mood, {bool withTransition = false}) {
    final fsm = _petKey.currentState?.fsm;
    if (fsm == null) {
      // Widget chưa ready → lưu lại để apply sau qua onReady callback
      _pendingMood = mood;
      debugPrint('[Pet] FSM not ready, pending mood=$mood');
      return;
    }
    if (withTransition) {
      fsm.transitionTo(mood);
    } else {
      fsm.forceState(mood);
      fsm.startAutoBehavior();
    }
    _pendingMood = null;
    debugPrint('[Pet] mood applied=$mood transition=$withTransition');
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
  Future<void> _showCurrentMood() async {
    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) return;

      final petRow = await Supabase.instance.client
          .from('pet')
          .select('id, current_mood')
          .eq('user_id', user.id)
          .single();

      if (!mounted) return;

      _petId = petRow['id'] as String;
      final mood = petRow['current_mood'] as String? ?? 'idle';

      // Yield 1 frame để đảm bảo StatefulPetWidget đã được insert vào tree
      await Future.delayed(Duration.zero);

      if (!mounted) return;

      _applyMood(_mapMood(mood));

    } catch (e) {
      debugPrint('[Pet] showCurrentMood error: $e');
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
            final newMood = payload.newRecord['current_mood'] as String?;
            if (newMood == null) return;
            debugPrint('[Pet] realtime update → mood=$newMood');
            _applyMood(_mapMood(newMood), withTransition: true);
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

    final newMood = next.rpcResult!['current_mood'] as String?;
    if (newMood == null) return;

    debugPrint('[Pet] provider update → mood=$newMood');
    _applyMood(_mapMood(newMood), withTransition: true);
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
            top: screenSize.height * 0.6,
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
                  child: const SpinningNavButton(iconColor: Colors.white),
                ),
                const SizedBox(width: 8),
                const Expanded(child: CozyCalendar()),
                const SizedBox(width: 8),
                Container(
                  margin: const EdgeInsets.only(top: 17),
                  child: IconButton(
                    icon: const Icon(
                      Icons.grid_view_rounded,
                      color: Colors.white,
                    ),
                    onPressed: () {},
                  ),
                ),
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