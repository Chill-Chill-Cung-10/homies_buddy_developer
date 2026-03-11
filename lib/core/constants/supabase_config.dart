import 'package:flutter_dotenv/flutter_dotenv.dart';

class SupabaseConfig {
  static String get url => dotenv.env['SUPABASE_URL'] ?? '';
  static String get anonKey => dotenv.env['SUPABASE_ANON_KEY'] ?? '';

  static void validate() {
    assert(url.isNotEmpty, 'Thiếu SUPABASE_URL');
    assert(anonKey.isNotEmpty, 'Thiếu SUPABASE_ANON_KEY');
  }
}
