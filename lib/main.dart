import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'features/navigation/presentation/screens/main_navigation_screen.dart';

/// Main entry point of Homies Buddy application
void main() {
  runApp(const MyApp());
}

/// Root application widget
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Homies Buddy',
      debugShowCheckedModeBanner: false,
      
      // Apply custom Material 3 theme with pastel colors
      theme: AppTheme.lightTheme,
      
      // Start with Main Navigation (Phase 2)
      // TODO: Replace with LoginScreen when implementing Phase 1 (Authentication)
      home: const MainNavigationScreen(),
    );
  }
}
