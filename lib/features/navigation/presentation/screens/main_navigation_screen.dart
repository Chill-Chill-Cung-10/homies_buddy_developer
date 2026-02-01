import 'package:flutter/material.dart';
import '../../../home/presentation/screens/home_screen.dart';
import '../../../community/presentation/screens/community_screen.dart';
import '../../../help/presentation/screens/help_screen.dart';
import '../../../profile/presentation/screens/profile_screen.dart';
import '../../../../core/constants/app_colors.dart';

/// Main Navigation Screen with Material 3 Bottom Navigation Bar
/// 
/// Uses IndexedStack to preserve state across tab switches
/// Material 3 NavigationBar automatically handles animations and indicators
class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  // Current selected tab index
  int _currentIndex = 0;

  // List of screens for each tab
  // Using IndexedStack preserves state when switching tabs
  final List<Widget> _screens = const [
    HomeScreen(),
    CommunityScreen(),
    HelpScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // IndexedStack shows only the selected screen while preserving state of others
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      
      // Material 3 NavigationBar (replaces old BottomNavigationBar)
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        backgroundColor: AppColors.navBarBackground,
        indicatorColor: AppColors.primaryGreen.withOpacity(0.3),
        elevation: 8,
        height: 70,
        
        // Navigation destinations (tabs)
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
            tooltip: 'Home - Garden View',
          ),
          NavigationDestination(
            icon: Icon(Icons.people_outline),
            selectedIcon: Icon(Icons.people),
            label: 'Community',
            tooltip: 'Community Neighbors',
          ),
          NavigationDestination(
            icon: Icon(Icons.help_outline),
            selectedIcon: Icon(Icons.help),
            label: 'Help',
            tooltip: 'Ask For Help',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
            tooltip: 'Personal Settings',
          ),
        ],
      ),
    );
  }
}
