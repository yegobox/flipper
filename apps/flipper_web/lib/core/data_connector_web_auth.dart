import 'dart:convert';

import 'package:flipper_models/data_connector_client.dart';
import 'package:flipper_models/secrets.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';

/// data-connector tokens for flipper_web.
///
/// Separate from the POS implementation because the identity is different:
/// this app signs in with Supabase, not Firebase, so it enrols with a Supabase
/// session token.
///
/// **Tokens are held in memory only.** A refresh token in `localStorage` is
/// readable by any XSS on the origin, and this is the app that renders
/// accounting data. Losing the token on reload costs one enrolment round-trip,
/// because the Supabase session itself does persist — a cheap price for
/// keeping a long-lived credential out of storage the page can read.
class DataConnectorWebAuth implements DataConnectorAuth {
  DataConnectorWebAuth({http.Client? client})
      : _client = client ?? http.Client();

  final http.Client _client;

  String? _accessToken;
  DateTime? _expiresAt;
  String? _refreshToken;
  String? _deviceId;

  /// Joins concurrent callers onto one refresh, so a page that fires several
  /// requests at once does not rotate the refresh token from under itself.
  Future<String?>? _inFlight;

  static const _skew = Duration(minutes: 2);
  static const _timeout = Duration(seconds: 20);

  bool get _tokenLooksValid {
    final token = _accessToken;
    final expiry = _expiresAt;
    if (token == null || token.isEmpty || expiry == null) return false;
    return DateTime.now().isBefore(expiry.subtract(_skew));
  }

  @override
  Future<Map<String, String>> authHeaders({required String baseUrl}) async {
    final token = await _ensure(baseUrl: baseUrl);
    if (token == null) return const {};
    return {'Authorization': 'Bearer $token'};
  }

  @override
  Future<void> invalidateAccessToken() async {
    _accessToken = null;
    _expiresAt = null;
    _inFlight = null;
  }

  Future<String?> _ensure({required String baseUrl}) async {
    if (_tokenLooksValid) return _accessToken;
    final existing = _inFlight;
    if (existing != null) return existing;

    final attempt = _refreshOrEnroll(baseUrl: baseUrl);
    _inFlight = attempt;
    try {
      return await attempt;
    } finally {
      _inFlight = null;
    }
  }

  Future<String?> _refreshOrEnroll({required String baseUrl}) async {
    final refresh = _refreshToken;
    if (refresh != null && refresh.isNotEmpty) {
      final token = await _post(
        baseUrl: baseUrl,
        path: 'auth/token',
        payload: {'refreshToken': refresh},
      );
      if (token != null) return token;
      // Dead refresh token; fall through and enrol again.
      _refreshToken = null;
    }

    final session = Supabase.instance.client.auth.currentSession;
    final supabaseToken = session?.accessToken;
    if (supabaseToken == null || supabaseToken.isEmpty) {
      // Not signed in yet. Normal during boot.
      return null;
    }

    return _post(
      baseUrl: baseUrl,
      path: 'auth/enroll',
      payload: {
        'enrollKey': AppSecrets.dataConnectorEnrollKey,
        // No stable install id in a browser, and inventing one in storage
        // would be a tracking identifier we do not need. The connector keys
        // the device row on (installId, userId), so a per-tab id simply means
        // a new device row per tab, which is revocable individually.
        'installId': _deviceId ?? 'web-${DateTime.now().millisecondsSinceEpoch}',
        'supabaseAccessToken': supabaseToken,
        'platform': 'flipper_web',
      },
    );
  }

  Future<String?> _post({
    required String baseUrl,
    required String path,
    required Map<String, dynamic> payload,
  }) async {
    final normalized = baseUrl.endsWith('/') ? baseUrl : '$baseUrl/';
    try {
      final response = await _client
          .post(
            Uri.parse('$normalized$path'),
            headers: const {'Content-Type': 'application/json'},
            body: jsonEncode(payload),
          )
          .timeout(_timeout);
      if (response.statusCode != 200) {
        debugPrint('[flipper_web] data-connector $path → ${response.statusCode}');
        return null;
      }
      final decoded = jsonDecode(response.body);
      if (decoded is! Map) return null;

      final access = decoded['accessToken'];
      if (access is! String || access.isEmpty) return null;

      final refresh = decoded['refreshToken'];
      if (refresh is String && refresh.isNotEmpty) _refreshToken = refresh;
      final deviceId = decoded['deviceId'];
      if (deviceId is String && deviceId.isNotEmpty) _deviceId = deviceId;

      final expiresIn = decoded['expiresIn'];
      final ttl = expiresIn is int ? expiresIn : 900;
      _accessToken = access;
      _expiresAt = DateTime.now().add(Duration(seconds: ttl));
      return access;
    } catch (e) {
      // Offline or connector down. Callers send the request unauthenticated,
      // which still works while the connector is in warn mode.
      debugPrint('[flipper_web] data-connector $path failed: $e');
      return null;
    }
  }
}

/// Lends `flipper_models` this app's Supabase-backed token source.
void registerDataConnectorWebAuth() {
  setDataConnectorAuth(DataConnectorWebAuth());
}
