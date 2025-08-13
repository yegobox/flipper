// lib/features/auth/repositories/account_repository.dart
import 'package:supabase_flutter/supabase_flutter.dart';

class AccountRepository {
  final SupabaseClient _supabase;

  AccountRepository(this._supabase);

  Future<List<Map<String, dynamic>>> fetchAccounts() async {
    try {
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) {
        throw Exception('Unauthenticated: no current user');
      }
      
      final response = await _supabase
          .from('accounts')
          .select('id, issuer, account_name, secret')
          .eq('user_id', currentUser.id);

      return List<Map<String, dynamic>>.from(response);
    } on PostgrestException catch (e) {
      throw Exception('Failed to load accounts: ${e.message}');
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }

  Future<void> addAccount(Map<String, dynamic> account) async {
    try {
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) {
        throw Exception('Unauthenticated: no current user');
      }
      
      await _supabase.from('accounts').insert({
        ...account,
        'user_id': currentUser.id,
      }).select('');
    } on PostgrestException catch (e) {
      throw Exception('Failed to add account: ${e.message}');
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }
}
