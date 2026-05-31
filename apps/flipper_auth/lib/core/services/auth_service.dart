// lib/core/services/auth_service.dart
import 'dart:convert';

import 'package:flipper_models/secrets.dart';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient _supabase;
  final http.Client _httpClient;

  AuthService(this._supabase, {http.Client? httpClient})
      : _httpClient = httpClient ?? http.Client();

  Stream<AuthState> get authStateChanges => _supabase.auth.onAuthStateChange;

  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    return await _supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  Future<AuthResponse> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    final response = await _supabase.auth.signUp(
      email: email,
      password: password,
      data: {'full_name': name.trim()},
    );

    await _provisionUserProfile(email: email.trim(), name: name.trim());

    return response;
  }

  /// Creates or updates `public.users` via flipper-turbo so `/v2/api/user` returns name.
  Future<void> _provisionUserProfile({
    required String email,
    required String name,
  }) async {
    final response = await _httpClient.post(
      Uri.parse('${AppSecrets.apihubProd}/v2/api/user'),
      headers: const {'Content-Type': 'application/json'},
      body: jsonEncode({
        'phoneNumber': email,
        'name': name,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Failed to create user profile (${response.statusCode}): ${response.body}',
      );
    }
  }

  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }

  User? get currentUser => _supabase.auth.currentUser;
}
