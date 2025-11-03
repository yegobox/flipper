import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flipper_web/core/utils/http_overrides.dart';
import 'package:flipper_web/core/secrets.dart';
import 'package:flipper_web/core/supabase_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flipper_web/repositories/user_repository.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final supabase = ref.watch(supabaseProvider);
  final userRepository = ref.watch(userRepositoryProvider);
  return AuthRepository(supabase, userRepository);
});

class AuthRepository {
  final SupabaseClient _supabase;
  final UserRepository _userRepository;
  late final http.Client _httpClient;

  AuthRepository(this._supabase, this._userRepository) {
    // Ensure HTTP overrides (e.g. badCertificateCallback) are installed
    // before creating the `http.Client` so its underlying HttpClient
    // picks up the overrides on non-web platforms.
    initializeCriticalDependencies();
    _httpClient = http.Client();
  }

  Future<bool> verifyPin(String pin) async {
    final url = Uri.parse(
      '${kDebugMode ? AppSecrets.apihubDevDomain : AppSecrets.apihubProdDomain}/v2/api/login/pin',
    );
    
    try {
      final response = await _httpClient.post(
        url,
        body: jsonEncode({'pin': pin}),
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'Basic ${base64Encode(utf8.encode('${AppSecrets.publicUsername}:${AppSecrets.publicPassword}'))}',
        },
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        return true;
      } else if (response.statusCode == 404) {
        throw Exception('Pin not found');
      } else if (response.statusCode == 403) {
        throw Exception('Access denied - check authentication');
      } else {
        throw Exception('Invalid PIN (${response.statusCode})');
      }
    } on SocketException catch (e) {
      debugPrint('Socket error: $e');
      throw Exception('Network connection failed. Check your internet connection.');
    } on TimeoutException catch (e) {
      debugPrint('Timeout error: $e');
      throw Exception('Request timed out. Please try again.');
    } catch (e) {
      debugPrint('Unexpected error: $e');
      rethrow;
    }
  }

  Future<void> sendOtp() async {
    // This seems to be handled by verifyPin in the existing implementation.
    // If a separate call is needed, it can be added here.
    await Future.delayed(const Duration(seconds: 1));
  }

  Future<bool> verifyOtp(String pin, String otp) async {
    final response = await _httpClient.post(
      Uri.parse(
        '${kDebugMode ? AppSecrets.apihubDevDomain : AppSecrets.apihubProdDomain}/v2/api/login/verify-otp',
      ),
      body: jsonEncode({'pin': pin, 'otp': otp}),
      headers: {
        'Content-Type': 'application/json',
        'Authorization':
            'Basic ${base64Encode(utf8.encode('${AppSecrets.publicUsername}:${AppSecrets.publicPassword}'))}',
      },
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      final refreshToken = responseData['refreshToken'] as String;

      // Use the token from the API response to authenticate with Supabase
      await _supabase.auth.setSession(refreshToken);

      // After successful authentication, fetch and save the user profile
      await _fetchAndSaveUserProfile();
      return true;
    } else if (response.statusCode == 404) {
      throw Exception('OTP not found');
    } else {
      throw Exception('Invalid OTP');
    }
  }

  Future<bool> verifyTotp(String pin, String totp) async {
    final response = await _httpClient.post(
      Uri.parse(
        '${kDebugMode ? AppSecrets.apihubDevDomain : AppSecrets.apihubProdDomain}/v2/api/login/verify-totp',
      ),
      body: jsonEncode({'pin': pin, 'totp': totp}),
      headers: {
        'Content-Type': 'application/json',
        'Authorization':
            'Basic ${base64Encode(utf8.encode('${AppSecrets.publicUsername}:${AppSecrets.publicPassword}'))}',
      },
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      final refreshToken = responseData['refreshToken'] as String;

      // Use the token from the API response to authenticate with Supabase
      await _supabase.auth.setSession(refreshToken);

      // After successful authentication, fetch and save the user profile
      await _fetchAndSaveUserProfile();

      return true;
    } else if (response.statusCode == 404) {
      throw Exception('TOTP not found');
    } else {
      throw Exception('Invalid TOTP');
    }
  }

  /// Fetches the user profile from the API and saves it to Ditto
  /// Called automatically after successful authentication
  Future<void> _fetchAndSaveUserProfile() async {
    try {
      // Get the current session token
      final session = _supabase.auth.currentSession;
      if (session == null) {
        throw Exception('No active session found');
      }

      // Use the session token to fetch and save the user profile
      await _userRepository.fetchAndSaveUserProfile(session);

      debugPrint('User profile fetched and saved successfully');
    } catch (e) {
      debugPrint('Error fetching user profile: $e');
      // We don't re-throw the exception here to avoid failing the login process
      // if the profile fetch fails. The user can still use the app.
    }
  }
}
