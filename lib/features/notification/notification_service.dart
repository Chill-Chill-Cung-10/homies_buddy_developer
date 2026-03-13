import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class NotificationService {
  final _fcm = FirebaseMessaging.instance;
  final _db = Supabase.instance.client;

  Future<void> init({
    required String userId,
    void Function(RemoteMessage message)? onTap,
  }) async {
    debugPrint('[Notif] init() called for userId: $userId'); // thêm dòng này

    final settings = await _fcm.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    debugPrint('[Notif] Permission status: ${settings.authorizationStatus}'); // thêm dòng này

    if (settings.authorizationStatus == AuthorizationStatus.denied) {
      debugPrint('[Notif] Permission denied');
      return;
    }

    final token = await _fcm.getToken();
    if (token != null) {
      debugPrint('[Notif] FCM Token: $token');
      await _syncToSupabase(userId, token);
    }

    _fcm.onTokenRefresh.listen((newToken) {
      _syncToSupabase(userId, newToken);
    });

    FirebaseMessaging.onMessage.listen((message) {
      debugPrint('[Notif] Foreground: ${message.notification?.title}');
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      onTap?.call(message);
    });

    final initialMessage = await _fcm.getInitialMessage();
    if (initialMessage != null) {
      onTap?.call(initialMessage);
    }
  }

  Future<void> _syncToSupabase(String userId, String token) async {
    try {
      final timezone = await _getTimezone();
      await _db.from('user_profile').update({
        'fcm_token': token,
        'timezone': timezone,
      }).eq('id', userId);
      debugPrint('[Notif] Synced — tz: $timezone');
    } catch (e) {
      debugPrint('[Notif] Sync failed: $e');
    }
  }

  Future<String> _getTimezone() async {
    try {
      final timezone = await FlutterTimezone.getLocalTimezone();
      return timezone.identifier;
    } catch (_) {
      return 'Asia/Ho_Chi_Minh';
    }
  }
}