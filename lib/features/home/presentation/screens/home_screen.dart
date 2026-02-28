import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../widgets/calendar_item.dart';
import '../widgets/exp_item.dart';
import '../widgets/user_moments_box.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
          // ===== Background Image =====
          Positioned.fill(
            child: Image.asset(
              'assets/images/home/background/tom_home_happy.png',
              fit: BoxFit.cover,
            ),
          ),

          // ===== Pet Image =====
          Positioned(
            left: 0,
            right: 100,
            top: MediaQuery.of(context).size.height * 0.35,
            child: Center(
              child: Image.asset(
                'assets/images/home/pets/lumni_idle.png',
                width: MediaQuery.of(context).size.width * 0.5,
                fit: BoxFit.contain,
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
                  margin: EdgeInsets.only(top: 17),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.settings, color: Color(0xFFFFFFFF)),
                    onPressed: () {
                      // TODO: Navigate to settings
                    },
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
