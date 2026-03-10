import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/spinning_nav_button.dart';
import '../providers/home_providers.dart';
import '../widgets/calendar_item.dart';
import '../widgets/user_moments_box.dart';
import '../widgets/pet_animation_widget.dart';
import '../widgets/background_animation_widget.dart';

// Ngưỡng thời gian: nếu last_interacted_at > 10 phút → Flutter tự update
// Nếu < 10 phút → Cloud Function vừa update rồi, không gọi lại
const _kUpdateThresholdMinutes = 10;

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final _petKey = GlobalKey<StatefulPetWidgetState>();
  String? _petId;

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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _initPet());
  }

  Future<void> _initPet() async {
    await _showCurrentMood();   // Bước 1: hiện mood cũ ngay
    await _maybeUpdate();       // Bước 2: update nếu cần
  }

  // ── Bước 1: Đọc current_mood + last_interacted_at từ DB → hiện ngay ──
  Future<void> _showCurrentMood() async {
    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) return;

      final petRow = await Supabase.instance.client
          .from('pet')
          .select('id, current_mood, last_interacted_at')
          .eq('user_id', user.id)
          .single();

      if (!mounted) return;

      _petId = petRow['id'] as String;
      final mood = petRow['current_mood'] as String;

      // Hiện mood ngay — không animation, không đợi
      _petKey.currentState?.fsm.stopAutoBehavior();
      _petKey.currentState?.fsm.forceState(_mapMood(mood));

      debugPrint('[Pet] current mood=$mood');

    } catch (e) {
      debugPrint('[Pet] showCurrentMood error: $e');
      _petKey.currentState?.fsm.forceState(PetState.idle);
    }
  }

  // ── Bước 2: Chỉ update nếu Cloud Function chưa update gần đây ──
  Future<void> _maybeUpdate() async {
    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null || _petId == null) return;

      final petRow = await Supabase.instance.client
          .from('pet')
          .select('last_interacted_at')
          .eq('id', _petId!)
          .single();

      final lastInteracted = DateTime.tryParse(
        petRow['last_interacted_at'] as String? ?? '',
      );

      // Cloud Function set last_interacted_at = NOW() sau mỗi lần analyze
      // Nếu < 10 phút → Cloud Function vừa update → không gọi lại
      if (lastInteracted != null) {
        final minutesSince = DateTime.now()
            .difference(lastInteracted.toLocal())
            .inMinutes;

        if (minutesSince < _kUpdateThresholdMinutes) {
          debugPrint('[Pet] recently updated ($minutesSince min ago), skip');
          return;
        }
      }

      // > 10 phút hoặc chưa có data → Flutter tự update
      debugPrint('[Pet] updating in background...');
      await _updateInBackground();

    } catch (e) {
      debugPrint('[Pet] maybeUpdate error: $e');
    }
  }

  // ── Update mood ngầm, transition nếu mood thay đổi ──
  Future<void> _updateInBackground() async {
    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null || _petId == null) return;

      final result = await Supabase.instance.client.rpc(
        'update_pet_on_resume',
        params: {
          'p_pet_id':  _petId!,
          'p_user_id': user.id,
        },
      );

      if (!mounted) return;

      final newMood     = result['current_mood'] as String;
      final newPetState = _mapMood(newMood);

      // Nếu mood khác → transition có animation
      // Nếu mood giống → FSM tự bỏ qua (same state check)
      _petKey.currentState?.fsm.transitionTo(newPetState);

      debugPrint('[Pet] updated mood=$newMood energy=${result['energy']} '
          'streak=${result['streak']} tone=${result['user_tone']}');

    } catch (e) {
      debugPrint('[Pet] updateInBackground error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize         = MediaQuery.of(context).size;
    final isCalendarExpanded = ref.watch(calendarExpandedProvider);

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
                autoPlay: false,
                initialState: PetState.idle,
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