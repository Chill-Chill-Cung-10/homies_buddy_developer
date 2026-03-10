import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/spinning_nav_button.dart';
import '../providers/home_providers.dart';
import '../widgets/calendar_item.dart';
import '../widgets/user_moments_box.dart';
import '../widgets/pet_animation_widget.dart';
import '../widgets/background_animation_widget.dart';

enum PetMood { happy, idle, sad }

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final PetMood _currentMood = PetMood.happy;

  // Map mood → PetState
  static const Map<PetMood, PetState> _moodToState = {
    PetMood.happy: PetState.happy,
    PetMood.idle: PetState.idle,
    PetMood.sad: PetState.sad,
  };

  /// Auto-detect current time of day based on actual time
  BackgroundTime get _currentTimeOfDay {
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 8) return BackgroundTime.earlyMorning;
    if (hour >= 8 && hour < 12) return BackgroundTime.morning;
    if (hour >= 12 && hour < 18) return BackgroundTime.afternoon;
    return BackgroundTime.night;
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
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
          // ── Background crossfade ──
          Positioned.fill(
            child: ImageBackgroundWidget(timeOfDay: _currentTimeOfDay),
          ),

          // ── Pet Animation (thay Image.asset bằng PetAnimationWidget) ──
          Positioned(
            left: 0,
            right: 0,
            top: screenSize.height * 0.6,
            child: Align(
              alignment: const Alignment(0.54, 0), // Dịch sang phải một chút
              child: PetAnimationWidget(
                // Đổi animation theo mood hiện tại
                animation: PetAnimation.state(_moodToState[_currentMood]!),
                width: screenSize.width * 0.5,
                height: screenSize.width * 0.5,
              ),
            ),
          ),

          // ── Barrier khi calendar expanded - đặt trước calendar để catch tap events ──
          if (isCalendarExpanded)
            Positioned.fill(
              child: GestureDetector(
                onTap: () {
                  // Đóng calendar khi tap ra ngoài
                  ref.read(calendarExpandedProvider.notifier).state = false;
                },
                child: Container(
                  color: Colors.transparent,
                ),
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

          // ── Thoughts Share ──
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
