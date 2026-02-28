import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/spinning_nav_button.dart';
import '../widgets/calendar_item.dart';
import '../widgets/exp_item.dart';
import '../widgets/user_moments_box.dart';

/// Trạng thái cảm xúc của pet — dùng để test UI chuyển đổi
enum PetMood { happy, idle, sad }

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  PetMood _currentMood = PetMood.idle;

  // ── Mapping mood → asset paths ──
  static const Map<PetMood, String> _backgroundAssets = {
    PetMood.happy: 'assets/images/home/background/tom_home_happy.png',
    PetMood.idle: 'assets/images/home/background/tom_home_late_afternoon.png',
    PetMood.sad: 'assets/images/home/background/tom_home_sad.png',
  };

  static const Map<PetMood, String> _petAssets = {
    PetMood.happy: 'assets/images/home/pets/lumni_happy.png',
    PetMood.idle: 'assets/images/home/pets/lumni_idle.png',
    PetMood.sad: 'assets/images/home/pets/lumni_sleep.png',
  };

  void _switchMood(PetMood mood) {
    if (_currentMood == mood) return;
    setState(() => _currentMood = mood);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 0, // Ẩn appBar
      ),
      body: Stack(
        children: [
          // ===== Background Image (smooth crossfade) =====
          ...PetMood.values.map((mood) => Positioned.fill(
            child: AnimatedOpacity(
              opacity: _currentMood == mood ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 600),
              curve: Curves.easeInOut,
              child: Image.asset(
                _backgroundAssets[mood]!,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
            ),
          )),

          // ===== Pet Image (smooth crossfade) =====
          Positioned(
            left: 40,
            right: 100,
            top: MediaQuery.of(context).size.height * 0.40,
            child: Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.5,
                child: Stack(
                  alignment: Alignment.center,
                  children: PetMood.values.map((mood) => AnimatedOpacity(
                    opacity: _currentMood == mood ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 600),
                    curve: Curves.easeInOut,
                    child: Image.asset(
                      _petAssets[mood]!,
                      width: MediaQuery.of(context).size.width * 0.5,
                      fit: BoxFit.contain,
                    ),
                  )).toList(),
                ),
              ),
            ),
          ),

          // ===== Top Section: Settings & Calendar & IconButton =====
          Positioned(
            top: 16,
            left: 2,
            right: 2,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 17),
                  child: const SpinningNavButton(
                    iconColor: Colors.white,
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: CozyCalendar(),
                ),
                SizedBox(width: 8),
                Container(
                  margin: EdgeInsets.only(top: 17),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.grid_view_rounded, color: Color(0xFFFFFFFF)),
                    onPressed: () {
                      // TODO: Navigate to grid view
                    },
                  ),
                ),
              ],
            ),
          ),

          // ===== Pet Mood Selector Buttons (above ExpBar) =====
          Positioned(
            bottom: 128,
            left: 24,
            right: 24,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _MoodButton(
                  icon: Icons.sentiment_very_satisfied_rounded,
                  label: 'Happy',
                  isActive: _currentMood == PetMood.happy,
                  onTap: () => _switchMood(PetMood.happy),
                ),
                const SizedBox(width: 12),
                _MoodButton(
                  icon: Icons.sentiment_neutral_rounded,
                  label: 'Idle',
                  isActive: _currentMood == PetMood.idle,
                  onTap: () => _switchMood(PetMood.idle),
                ),
                const SizedBox(width: 12),
                _MoodButton(
                  icon: Icons.sentiment_dissatisfied_rounded,
                  label: 'Sad',
                  isActive: _currentMood == PetMood.sad,
                  onTap: () => _switchMood(PetMood.sad),
                ),
              ],
            ),
          ),

          // ===== Bottom Section: ExpBar =====
          Positioned(
            bottom: 80,
            left: 24,
            right: 24,
            child: ExpBar(current: 3),
          ),

          // ===== Bottom Section: Thoughts Share =====
          Positioned(
            bottom: 24,
            left: 24,
            right: 24,
            child: const UserMomentsBox(),
          ),
        ],
      ),
    );
  }
}

/// Button chọn mood cho pet — hiển thị icon + label, highlight khi active
class _MoodButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _MoodButton({
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
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isActive
              ? Colors.white.withOpacity(0.9)
              : Colors.white.withOpacity(0.4),
          borderRadius: BorderRadius.circular(20),
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
              size: 20,
              color: isActive ? AppColors.accentOrange : Colors.white,
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
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
