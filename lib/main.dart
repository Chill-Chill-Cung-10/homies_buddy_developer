import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/constants/supabase_config.dart';
import 'core/theme/app_theme.dart';
import 'core/widgets/system_notification_popup.dart';
import 'features/auth/presentation/auth_wrapper.dart';
import 'features/auth/presentation/providers/auth_providers.dart';
import 'features/feedback/data/feedback_providers.dart';
import 'features/notification/app_lifecycle_observer.dart';
import 'features/notification/notification_service.dart';
import 'features/pet/presentation/providers/pet_providers.dart';
import 'firebase_options.dart';

/// Background message handler — phải là top-level function
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint('[FCM] Background message: ${message.messageId}');
}

/// Main entry point of Homies Buddy application
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // 2. Register background message handler
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await dotenv.load(fileName: '.env');
  SupabaseConfig.validate();
  await Supabase.initialize(
    url: SupabaseConfig.url,
    anonKey: SupabaseConfig.anonKey,
  );
  final sharedPreferences = await SharedPreferences.getInstance();

  // 3. Run app with Riverpod provider scope
  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(sharedPreferences),
      ],
      child: const MyApp(),
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
  final _notificationService = NotificationService();

  // Double-init guard — tránh race condition khi isAuthenticatedProvider
  // fire nhiều lần trước khi await trong _initNotifications hoàn thành
  bool _notifInitialized = false;
  bool _notifInitializing = false;

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

    final userId = ref.read(currentAuthUserProvider)?.id;
    if (userId != null) AppLifecycleObserver(userId).onResume();
  }

  /// Gọi một lần duy nhất sau khi user authenticated.
  ///
  /// Dùng 2 flag để handle race condition:
  /// - [_notifInitializing] : lock ngay trước await, chặn gọi đồng thời
  /// - [_notifInitialized]  : set sau khi hoàn thành, chặn mọi lần sau
  Future<void> _initNotifications(String userId) async {
    if (_notifInitialized || _notifInitializing) return;
    _notifInitializing = true; // lock TRƯỚC bất kỳ await nào

    try {
      await _notificationService.init(
        userId: userId,
        onTap: (message) {
          final type = message.data['type'];
          if (type == 'pet_mood') {
            // Navigate về home — pet đang cần chăm sóc
            _navigatorKey.currentState?.popUntil((route) => route.isFirst);
          }
        },
      );
      _notifInitialized = true;
    } catch (e) {
      debugPrint('[Main] Notification init failed: $e');
      // Reset để có thể retry lần sau
      _notifInitializing = false;
      return;
    }

    _notifInitializing = false;
  }

  @override
  Widget build(BuildContext context) {
    // Listen for pet resume errors
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

    // Trigger RPC + init notifications khi auth hoàn tất
    ref.listen<bool>(isAuthenticatedProvider, (prev, next) {
      debugPrint('[Auth] isAuthenticated: $prev → $next');
      if (next && prev != true) {
        ref.read(petResumeProvider.notifier).onAppResume();

        final userId = ref.read(currentAuthUserProvider)?.id;
        if (userId != null) _initNotifications(userId);
      }
    });

    return MaterialApp(
      navigatorKey: _navigatorKey,
      title: 'Homies Buddy',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const AuthWrapper(),
    );
  }
}