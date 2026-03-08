import 'package:flutter/material.dart';
import '../../home/presentation/screens/home_screen.dart';
import '../../community/presentation/community_screen.dart';
import '../../help/presentation/screens/ask_for_help_screen.dart';
import '../../profile/presentation/screens/profile_screen.dart';
import '../../../core/widgets/navigation_provider.dart';

/// Main Navigation Screen — no bottom bar.
///
/// Navigation is driven by [SpinningNavButton] placed inside each screen.
/// State is shared via [NavigationProvider] (InheritedWidget) so every
/// descendant can read [currentIndex] and call [onNavigate].
class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  // Screens for each tab — IndexedStack keeps them alive.
  final List<Widget> _screens = const [
    HomeScreen(),
    CommunityScreen(),
    AskForHelpScreen(),
    ProfileScreen(),
  ];

  void _onNavigate(int index) {
    if (index == _currentIndex) return;
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return NavigationProvider(
      currentIndex: _currentIndex,
      onNavigate: _onNavigate,
      child: Scaffold(
        body: IndexedStack(index: _currentIndex, children: _screens),
      ),
    );
  }
}
