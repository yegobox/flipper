import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_models/secrets.dart';
import 'package:flipper_services/proxy.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Supabase Auth for Flipper POS users.
///
/// Login key may be a phone or an email (same as POST `/v2/api/user`):
/// - phone → `{digits}@flipper.rw` / password = that email
/// - email (contains `@`) → used as-is / password = that email
class SupabaseSessionService {
  SupabaseSessionService._();

  /// Matches `POST /auth/v1/token?grant_type=password` credentials used in ops/tests.
  ///
  /// [phone] may already be an email / `@flipper.rw` key (contains `@`); those
  /// are returned trimmed, matching how `/v2/api/user` treats `phoneNumber`.
  static String emailFromPhone(String phone) {
    final trimmed = phone.trim();
    if (trimmed.contains('@')) {
      return trimmed;
    }
    final digits = trimmed.replaceAll(RegExp(r'\D'), '');
    if (digits.isEmpty) {
      throw ArgumentError('phone has no digits: $phone');
    }
    return '$digits@flipper.rw';
  }

  static String? _phoneFromBox() {
    final phone = ProxyService.box.getUserPhone();
    if (phone == null || phone.trim().isEmpty) return null;
    return phone.trim();
  }

  static bool _sessionLooksValid(Session? session) {
    if (session == null) return false;
    final expiresAt = session.expiresAt;
    if (expiresAt == null) return true;
    final expiry = DateTime.fromMillisecondsSinceEpoch(expiresAt * 1000);
    return DateTime.now().isBefore(expiry.subtract(const Duration(minutes: 2)));
  }

  /// Returns a user access token suitable for `verify_jwt` edge functions.
  static Future<String?> ensureAccessToken() async {
    final client = Supabase.instance.client;

    var session = client.auth.currentSession;
    if (_sessionLooksValid(session)) {
      return session!.accessToken;
    }

    try {
      final refreshed = await client.auth.refreshSession();
      session = refreshed.session;
      if (_sessionLooksValid(session)) {
        talker.debug('supabase session: refreshed');
        return session!.accessToken;
      }
    } catch (e) {
      talker.debug('supabase session: refresh failed: $e');
    }

    final phone = _phoneFromBox();
    if (phone == null) {
      talker.warning('supabase session: no userPhone in box — cannot sign in');
      return null;
    }

    final email = emailFromPhone(phone);
    try {
      final response = await client.auth.signInWithPassword(
        email: email,
        password: email,
      );
      session = response.session;
      if (_sessionLooksValid(session)) {
        talker.info('supabase session: signed in as $email');
        return session!.accessToken;
      }
    } on AuthException catch (e) {
      talker.debug('supabase session: signIn failed ($email): ${e.message}');
      try {
        await client.auth.signUp(email: email, password: email);
        final response = await client.auth.signInWithPassword(
          email: email,
          password: email,
        );
        session = response.session;
        if (_sessionLooksValid(session)) {
          talker.info('supabase session: signed up and signed in as $email');
          return session!.accessToken;
        }
      } on AuthException catch (signUpError) {
        talker.warning(
          'supabase session: signUp/signIn failed for $email: ${signUpError.message}',
        );
      }
    } catch (e, s) {
      talker.warning('supabase session: unexpected error: $e\n$s');
    }

    return client.auth.currentSession?.accessToken;
  }

  /// Same as [ensureAccessToken] but throws if no token (for callers that require auth).
  static Future<String> requireAccessToken() async {
    final token = await ensureAccessToken();
    if (token == null || token.isEmpty) {
      final phone = _phoneFromBox();
      final expected = phone == null || phone.isEmpty
          ? 'phone or email login key'
          : emailFromPhone(phone);
      throw StateError(
        'No Supabase session. Expected $expected — sign in to the app first.',
      );
    }
    return token;
  }

  /// Headers for edge functions with `verify_jwt = true`.
  static Future<Map<String, String>> edgeFunctionAuthHeaders() async {
    final token = await ensureAccessToken();
    if (token == null || token.isEmpty) {
      throw StateError('Supabase access token unavailable');
    }
    return {
      'apikey': AppSecrets.supabaseAnonKey,
      'Authorization': 'Bearer $token',
    };
  }
}
