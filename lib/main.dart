import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/constants/supabase_config.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/presentation/auth_wrapper.dart';
import 'firebase_options.dart';

/// Main entry point of Homies Buddy application
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // 2. Initialize Supabase (for PostgreSQL data storage)
  if (SupabaseConfig.isConfigured) {
    await Supabase.initialize(
      url: SupabaseConfig.url,
      anonKey: SupabaseConfig.anonKey,
    );
  } else if (kDebugMode) {
    debugPrint(
      '⚠️ Supabase not configured. Run with --dart-define SUPABASE_URL and SUPABASE_ANON_KEY.',
    );
  }

  // 3. Run app with Riverpod provider scope
  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
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

      // AuthWrapper handles routing based on auth state
      home: const AuthWrapper(),
    );
  }
}
