import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/pet_table.dart';

/// Pet Remote Datasource — Data Layer
///
/// Handles direct communication with Supabase for pet operations.
/// App dùng Firebase Auth thuần — Supabase chỉ là database, không có session.
class PetRemoteDatasource {
  final SupabaseClient _supabase;

  PetRemoteDatasource({SupabaseClient? supabase})
      : _supabase = supabase ?? Supabase.instance.client;

  /// Get user's pet by userId
  /// userId được truyền từ Firebase Auth (FirebaseService.currentUserId)
  /// KHÔNG check Supabase session vì app không dùng Supabase Auth
  Future<Map<String, dynamic>?> getUserPet(String userId) async {
    return await _supabase
        .from(PetTable.name)
        .select()
        .eq(PetTable.userId, userId)
        .maybeSingle();
  }

  /// Call update_pet_on_resume RPC
  Future<Map<String, dynamic>> updatePetOnResume({
    required String petId,
    required String userId,
  }) async {
    final response = await _supabase.rpc(
      'update_pet_on_resume',
      params: {'p_pet_id': petId, 'p_user_id': userId},
    );
    return Map<String, dynamic>.from(response as Map);
  }
}