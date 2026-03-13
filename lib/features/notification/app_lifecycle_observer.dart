import 'package:supabase_flutter/supabase_flutter.dart';

class AppLifecycleObserver {
  final String userId;
  final _db = Supabase.instance.client;

  AppLifecycleObserver(this.userId);

  Future<void> onResume() async {
    await _db.from('pet').update({
      'last_interacted_at': DateTime.now().toUtc().toIso8601String(),
    }).eq('user_id', userId);
  }
}