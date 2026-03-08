import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/spinning_nav_button.dart';
import '../widgets/calendar_item.dart';
import '../widgets/user_moments_box.dart';
import '../widgets/pet_animation_widget.dart';
import '../widgets/background_animation_widget.dart';

enum PetMood { happy, idle, sad }

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PetMood _currentMood = PetMood.happy;
  BackgroundTime _currentTimeOfDay = BackgroundTime.morning;

  // Map mood → PetState
  static const Map<PetMood, PetState> _moodToState = {
    PetMood.happy: PetState.happy,
    PetMood.idle: PetState.idle,
    PetMood.sad: PetState.sad,
  };

  void _switchTimeOfDay(BackgroundTime time) {
    if (_currentTimeOfDay == time) return;
    setState(() => _currentTimeOfDay = time);
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

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

          // ── Time of Day Selector ──
          Positioned(
            top: 120,
            left: 24,
            right: 24,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _TimeButton(
                    icon: Icons.brightness_2,
                    label: 'Dawn',
                    isActive: _currentTimeOfDay == BackgroundTime.earlyMorning,
                    onTap: () => _switchTimeOfDay(BackgroundTime.earlyMorning),
                  ),
                  const SizedBox(width: 8),
                  _TimeButton(
                    icon: Icons.wb_sunny_outlined,
                    label: 'Morning',
                    isActive: _currentTimeOfDay == BackgroundTime.morning,
                    onTap: () => _switchTimeOfDay(BackgroundTime.morning),
                  ),
                  const SizedBox(width: 8),
                  _TimeButton(
                    icon: Icons.wb_sunny,
                    label: 'Afternoon',
                    isActive: _currentTimeOfDay == BackgroundTime.afternoon,
                    onTap: () => _switchTimeOfDay(BackgroundTime.afternoon),
                  ),
                  const SizedBox(width: 8),
                  _TimeButton(
                    icon: Icons.nightlight_round,
                    label: 'Night',
                    isActive: _currentTimeOfDay == BackgroundTime.night,
                    onTap: () => _switchTimeOfDay(BackgroundTime.night),
                  ),
                ],
              ),
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

class _TimeButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _TimeButton({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: isActive
              ? Colors.white.withOpacity(0.9)
              : Colors.white.withOpacity(0.3),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isActive
                ? AppColors.accentOrange
                : Colors.white.withOpacity(0.5),
            width: isActive ? 2 : 1,
          ),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: AppColors.accentOrange.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : [],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: isActive ? AppColors.accentOrange : Colors.white,
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                color: isActive ? AppColors.textPrimary : Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
