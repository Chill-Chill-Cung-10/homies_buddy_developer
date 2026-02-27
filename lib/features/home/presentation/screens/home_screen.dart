import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../widgets/calendar_item.dart';
import '../widgets/exp_item.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
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
              'assets/images/home/background/Tom_home_happy.png',
              fit: BoxFit.cover,
            ),
          ),

          // ===== Pet Image =====
          Positioned(
            left: 0,
            right: 0,
            top: MediaQuery.of(context).size.height * 0.35,
            child: Center(
              child: Image.asset(
                'assets/images/home/pets/lumni_idle.png',
                width: MediaQuery.of(context).size.width * 0.5,
                fit: BoxFit.contain,
              ),
            ),
          ),

          // ===== Top Section: Calendar & IconButton =====
          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: CozyCalendar(),
                ),
                SizedBox(width: 8),
                Container(
                  margin: EdgeInsets.only(top: 17),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16)
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.grid_view_rounded),
                    onPressed: () {
                      // TODO: Navigate to settings
                    },
                  ),
                ),
              ],
            ),
          ),

          // ===== Bottom Section: ExpBar =====
          Positioned(
            bottom: 140,
            left: 24,
            right: 24,
            child: ExpBar(current: 3),
          ),

          // ===== Bottom Section: Thoughts Share =====
          Positioned(
            bottom: 24,
            left: 24,
            right: 24,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: Color(0xFFFFF8F0),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.brown.withOpacity(0.1),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  )
                ],
              ),
              child: Text(
                'Chìa sẽ hôm nay...',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.brown.shade700,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
