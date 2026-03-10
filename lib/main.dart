import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/constants/supabase_config.dart';
import 'core/theme/app_theme.dart';
import 'core/widgets/system_notification_popup.dart';
import 'features/auth/presentation/auth_wrapper.dart';
import 'features/auth/presentation/providers/auth_providers.dart';
import 'features/pet/presentation/providers/pet_providers.dart';
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

/// Root application widget — observes lifecycle for pet RPC
class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> with WidgetsBindingObserver {
  final _navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _handleResume();
    }
  }

  void _handleResume() {
    final isAuthenticated = ref.read(isAuthenticatedProvider);
    if (!isAuthenticated) return;
    ref.read(petResumeProvider.notifier).onAppResume();
  }

  @override
  Widget build(BuildContext context) {
    // Listen for pet resume errors and show notification
    ref.listen<PetResumeState>(petResumeProvider, (prev, next) {
      if (next.errorMessage != null && next.errorMessage != prev?.errorMessage) {
        final ctx = _navigatorKey.currentContext;
        if (ctx != null) {
          SystemNotificationPopup.show(
            ctx,
            message: next.errorMessage!,
            type: NotificationType.error,
          );
        }
      }
    });

    // Trigger RPC on cold start when auth completes
    ref.listen<bool>(isAuthenticatedProvider, (prev, next) {
      if (next && prev != true) {
        ref.read(petResumeProvider.notifier).onAppResume();
      }
    });

    return MaterialApp(
      navigatorKey: _navigatorKey,
      title: 'Homies Buddy',
      debugShowCheckedModeBanner: false,

      // Apply custom Material 3 theme with pastel colors
      theme: AppTheme.lightTheme,

      // AuthWrapper handles routing based on auth state
      home: const AuthWrapper(),
    );
  }
}
