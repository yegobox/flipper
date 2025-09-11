import 'dart:convert';
import 'dart:io';
import 'package:flipper_web/core/secrets.dart';
import 'package:flipper_web/core/supabase_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final supabase = ref.watch(supabaseProvider);
  return AuthRepository(supabase);
});

class AuthRepository {
  final SupabaseClient _supabase;
  late final http.Client _httpClient;

  AuthRepository(this._supabase) {
    _httpClient = http.Client();
    // Bypass SSL certificate validation for IP addresses (non-web only)
    if (!kIsWeb) {
      HttpOverrides.global = _DevHttpOverrides();
    }
  }

  Future<bool> verifyPin(String pin) async {
    final response = await _httpClient.post(
      Uri.parse('${AppSecrets.apihubProd}/v2/api/login/pin'),
      body: jsonEncode({'pin': pin}),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      // The API might return more info, but for now, we just care about success.
      return true;
    } else {
      // You might want to parse the error message and throw a more specific exception
      throw Exception('Invalid PIN');
    }
  }

  Future<void> sendOtp() async {
    // This seems to be handled by verifyPin in the existing implementation.
    // If a separate call is needed, it can be added here.
    await Future.delayed(const Duration(seconds: 1));
  }

  Future<bool> verifyOtp(String pin, String otp) async {
    final response = await _httpClient.post(
      Uri.parse('${AppSecrets.apihubProd}/v2/api/login/verify-otp'),
      body: jsonEncode({'pin': pin, 'otp': otp}),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      // final responseData = jsonDecode(response.body);
      //final String token = responseData['token'];
      final email = "$pin@flipper.rw";

      // Use the token to sign in with Supabase
      await _supabase.auth.signInWithPassword(email: email, password: email);
      return true;
    } else {
      throw Exception('Invalid OTP');
    }
  }

  Future<bool> verifyTotp(String pin, String totp) async {
    final response = await _httpClient.post(
      Uri.parse('${AppSecrets.apihubProd}/v2/api/login/verify-totp'),
      body: jsonEncode({'pin': pin, 'totp': totp}),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      // final responseData = jsonDecode(response.body);
      // final String token = responseData['token'];
      final email = "$pin@flipper.rw";

      // Use the token to sign in with Supabase
      await _supabase.auth.signInWithPassword(email: email, password: email);
      return true;
    } else {
      throw Exception('Invalid TOTP');
    }
  }
}

class _DevHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
