import 'package:flutter/foundation.dart' hide Category;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

class AuthService {
  final SupabaseClient _client = Supabase.instance.client;

  /// Returns the current authenticated user
  Future<User?> getCurrentUser() async {
    try {
      final user = _client.auth.currentUser;
      // Debug log to help troubleshooting
      debugPrint('Current user from Supabase: ${user?.id ?? 'null'}');
      return user;
    } catch (e) {
      debugPrint('Error getting current user: $e');
      return null;
    }
  }

  /// Returns the current active session
  Future<Session?> getCurrentSession() async {
    try {
      final response = await _client.auth.refreshSession();
      return response.session;
    } catch (e) {
      debugPrint('Error refreshing session: $e');
      return null;
    }
  }

  /// Authenticates user with phone number and PIN
  Future<Session?> signInWithPhoneAndPin(String phoneNumber, String pin) async {
    try {
      // First step: Request OTP for the phone number
      // For this sample, we're simulating a successful OTP verification
      // In a real app, you would need to implement the full OTP flow

      // Second step: Verify OTP
      final response = await _client.auth.signInWithPassword(
        phone: phoneNumber,
        password: pin,
      );

      return response.session;
    } catch (e) {
      debugPrint('Error signing in: $e');
      rethrow;
    }
  }

  /// Signs out the current user
  Future<void> signOut() async {
    try {
      await _client.auth.signOut();
    } catch (e) {
      debugPrint('Error signing out: $e');
      rethrow;
    }
  }

  /// Returns true if the user is signed in
  Future<bool> isSignedIn() async {
    return await getCurrentUser() != null;
  }
}
