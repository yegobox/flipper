import 'package:flipper_models/models/user_mfa_secret.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserMfaSecretRepository {
  final SupabaseClient _supabase;

  UserMfaSecretRepository(this._supabase);

  Future<UserMfaSecret?> getSecretByUserId(String userId) async {
    try {
      final response = await _supabase
          .from('user_mfa_secrets')
          .select()
          .eq('user_id', userId)
          .limit(1)
          .single();

      return UserMfaSecretMapper.fromMap(response);
    } on PostgrestException catch (e) {
      if (e.code == 'PGRST116') {
        // No rows found
        return null;
      }
      throw Exception('Failed to fetch MFA secret: ${e.message}');
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }

  Future<void> addSecret(UserMfaSecret secret) async {
    try {
      await _supabase.from('user_mfa_secrets').insert(secret.toMap());
    } on PostgrestException catch (e) {
      throw Exception('Failed to add MFA secret: ${e.message}');
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }

  Future<void> updateSecret(UserMfaSecret secret) async {
    try {
      await _supabase
          .from('user_mfa_secrets')
          .update(secret.toMap())
          .eq('id', secret.id!);
    } on PostgrestException catch (e) {
      throw Exception('Failed to update MFA secret: ${e.message}');
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }

  Future<void> deleteSecret(String secretId) async {
    try {
      await _supabase.from('user_mfa_secrets').delete().eq('id', secretId);
    } on PostgrestException catch (e) {
      throw Exception('Failed to delete MFA secret: ${e.message}');
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }
}
