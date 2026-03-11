import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/pet_table.dart';

/// Pet Remote Datasource — Data Layer
///
/// Handles direct communication with Supabase for pet operations.
class PetRemoteDatasource {
  final SupabaseClient _supabase;

  PetRemoteDatasource({SupabaseClient? supabase})
      : _supabase = supabase ?? Supabase.instance.client;

  /// Get user's pet by userId
  Future<Map<String, dynamic>?> getUserPet(String userId) async {
    final session = _supabase.auth.currentSession;
    if (session == null) {
      return null; // caller sẽ handle
    }
    
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
