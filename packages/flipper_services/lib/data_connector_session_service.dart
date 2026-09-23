import 'dart:async';
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show visibleForTesting;
import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_models/secrets.dart';
import 'package:flipper_services/proxy.dart';
import 'package:http/http.dart' as http;

/// Bearer tokens for the data-connector HTTP API.
///
/// Shaped after [SupabaseSessionService]: one `ensureAccessToken()` that hands
/// back a usable token or null, and an `authHeaders()` for callers that just
/// want a header map.
///
/// Two things here are load-bearing and easy to get wrong:
///
/// **Refresh is single-flight.** Access tokens last 15 minutes and a POS
/// screen fires several requests at once, so N callers would otherwise each
/// refresh. Refresh tokens rotate, so the losers of that race would present a
/// token the server has already retired — which the server reads as theft and
/// answers by revoking the whole device. One shared future avoids that
/// entirely.
///
/// **Failure is soft.** This runs tills in real shops. Every path that cannot
/// produce a token returns null so the caller sends an unauthenticated
/// request, which still succeeds while the server is in warn mode and
/// degrades only that feature once it is enforcing. Selling does not go
/// through this service at all — it goes through Ditto — so an auth outage
/// must never stop a sale.
class DataConnectorSessionService {
  DataConnectorSessionService._();

  static const _deviceIdKey = 'dataConnectorDeviceId';
  static const _accessTokenKey = 'dataConnectorAccessToken';
  static const _accessExpiryKey = 'dataConnectorAccessExpiresAt';
  static const _refreshTokenKey = 'dataConnectorRefreshToken';

  /// Treat a token as stale this long before it actually expires, so a request
  /// in flight does not expire mid-journey. Matches `SupabaseSessionService`.
  static const _skew = Duration(minutes: 2);

  static const _timeout = Duration(seconds: 20);

  /// Joins concurrent callers onto one refresh. See the class comment.
  static Future<String?>? _inFlight;

  /// Lets tests inject a client without a DI container.
  static http.Client? testClient;

  static http.Client get _client => testClient ?? http.Client();

  /// The bits of app state this service needs.
  ///
  /// Injectable so the token lifecycle can be tested without booting the
  /// locator, and so `ProxyService` is reached for in exactly one place
  /// instead of scattered through every read and write.
  static DataConnectorSessionEnv env = const ProxyServiceSessionEnv();

  /// Forgets the cached session. Call on logout and on branch switch: the
  /// token carries branch and business claims, so a stale one would ask the
  /// server for the wrong tenant.
  ///
  /// Abandoning an in-flight attempt is safe here precisely because this also
  /// erases the refresh token: a caller that starts over goes to `_enroll`,
  /// so no refresh token is ever presented twice.
  static Future<void> reset() async {
    _inFlight = null;
    await _clearStoredCredentials();
  }

  static Future<void> _clearStoredCredentials() async {
    await env.write(_accessTokenKey, '');
    await env.write(_accessExpiryKey, '');
    await env.write(_refreshTokenKey, '');
  }

  /// Drops only the access token, keeping the refresh token.
  ///
  /// This is the 401 path: the access token was rejected, but the refresh
  /// token is probably still good, so the next call should refresh rather
  /// than re-enrol.
  ///
  /// A refresh already running makes this a no-op. Clearing the cached token
  /// under it would be pointless — the attempt is about to overwrite it — and
  /// dropping `_inFlight` would be actively harmful: the next caller would
  /// start a second refresh with the same refresh token, the server would see
  /// a retired token replayed, and it would revoke the device. That is the
  /// exact race the single-flight future exists to prevent, and a 401 on a
  /// parallel request is the ordinary way to hit it.
  static Future<void> invalidateAccessToken() async {
    if (_inFlight != null) return;
    await env.write(_accessTokenKey, '');
    await env.write(_accessExpiryKey, '');
  }

  static String? _nonEmpty(String key) {
    final v = env.read(key);
    if (v == null || v.trim().isEmpty) return null;
    return v.trim();
  }

  /// Whether a token expiring at [expiresAtEpochMs] is still usable at [now].
  ///
  /// Pure and public so the skew behaviour can be tested without a preference
  /// store, a signed-in user or a clock. An unparseable or missing expiry is
  /// treated as stale: refreshing needlessly is cheap, using a dead token is
  /// a failed request.
  @visibleForTesting
  static bool isAccessTokenFresh({
    required String? expiresAtEpochMs,
    required DateTime now,
    Duration skew = _skew,
  }) {
    if (expiresAtEpochMs == null) return false;
    final epochMs = int.tryParse(expiresAtEpochMs);
    if (epochMs == null) return false;
    final expiry = DateTime.fromMillisecondsSinceEpoch(epochMs);
    return now.isBefore(expiry.subtract(skew));
  }

  static bool _accessTokenLooksValid() {
    if (_nonEmpty(_accessTokenKey) == null) return false;
    return isAccessTokenFresh(
      expiresAtEpochMs: _nonEmpty(_accessExpiryKey),
      now: DateTime.now(),
    );
  }

  /// A usable access token, or null when one cannot be obtained.
  ///
  /// [baseUrl] is the resolved data-connector base (per-branch, from
  /// `Ebm.dataConnectorUrl`), so this follows the same host the request will.
  static Future<String?> ensureAccessToken({required String baseUrl}) async {
    if (_accessTokenLooksValid()) {
      return _nonEmpty(_accessTokenKey);
    }
    // Join an in-progress refresh rather than starting a second one.
    final existing = _inFlight;
    if (existing != null) return existing;

    final attempt = _refreshOrEnroll(baseUrl: baseUrl);
    _inFlight = attempt;
    try {
      return await attempt;
    } finally {
      // Only retract our own attempt. A `reset()` part-way through this one
      // has already installed null (or a newer attempt), and clearing
      // unconditionally would retract that instead.
      if (identical(_inFlight, attempt)) _inFlight = null;
    }
  }

  /// `Authorization` header, or an empty map when unauthenticated.
  ///
  /// Empty rather than throwing: callers merge this into their headers and
  /// must keep working during the warn-mode rollout.
  static Future<Map<String, String>> authHeaders({
    required String baseUrl,
  }) async {
    final token = await ensureAccessToken(baseUrl: baseUrl);
    if (token == null) return const {};
    return {'Authorization': 'Bearer $token'};
  }

  static Future<String?> _refreshOrEnroll({required String baseUrl}) async {
    final refreshToken = _nonEmpty(_refreshTokenKey);
    if (refreshToken != null) {
      final result = await _refresh(
        baseUrl: baseUrl,
        refreshToken: refreshToken,
      );
      if (result.token != null) return result.token;
      if (!result.rejected) {
        // We never reached the server, so we know nothing about the token.
        // Keeping it is the whole point: re-enrolling needs a signed-in
        // Firebase user, which an offline device may not be able to prove,
        // so discarding a good token over a dropped connection could strand
        // the device until the next login.
        return null;
      }
      // The refresh token is dead — expired, revoked, or retired by a
      // rotation this device lost. Re-enrolling is the recovery path; logging
      // the user out over it would be wildly disproportionate.
      talker.warning('data-connector: refresh failed, re-enrolling');
      await _clearStoredCredentials();
    }
    return _enroll(baseUrl: baseUrl);
  }

  static Uri _endpoint(String baseUrl, String path) {
    final normalized = baseUrl.endsWith('/') ? baseUrl : '$baseUrl/';
    return Uri.parse('$normalized$path');
  }

  static Future<_RefreshResult> _refresh({
    required String baseUrl,
    required String refreshToken,
  }) async {
    try {
      final response = await _client
          .post(
            _endpoint(baseUrl, 'auth/token'),
            headers: const {'Content-Type': 'application/json'},
            body: jsonEncode({'refreshToken': refreshToken}),
          )
          .timeout(_timeout);
      if (response.statusCode != 200) {
        talker.warning(
          'data-connector: refresh rejected (${response.statusCode})',
        );
        return const _RefreshResult.rejected();
      }
      final token = await _persist(response.body);
      // A 200 we cannot parse is still the server refusing to renew us, so
      // treat it as a rejection rather than retrying against a token the
      // server has already rotated away.
      if (token == null) return const _RefreshResult.rejected();
      return _RefreshResult.renewed(token);
    } catch (e) {
      // Offline, DNS failure, connector down. Not an auth problem; do not
      // discard the refresh token over it.
      talker.warning('data-connector: refresh errored: $e');
      return const _RefreshResult.unreachable();
    }
  }

  static Future<String?> _enroll({required String baseUrl}) async {
    final identity = await env.identityProof();
    if (identity == null) {
      // Not signed in yet, or Firebase has no current user. Normal during
      // boot; the next call will try again.
      return null;
    }

    final installId = _installId();
    if (installId == null) {
      talker.warning('data-connector: no install id, cannot enrol');
      return null;
    }

    try {
      final response = await _client
          .post(
            _endpoint(baseUrl, 'auth/enroll'),
            headers: const {'Content-Type': 'application/json'},
            body: jsonEncode({
              'enrollKey': AppSecrets.dataConnectorEnrollKey,
              'installId': installId,
              ...identity,
              'businessId': env.businessId,
              'branchId': env.branchId,
              'platform': _platformLabel(),
            }),
          )
          .timeout(_timeout);
      if (response.statusCode != 200) {
        talker.warning(
          'data-connector: enrolment rejected (${response.statusCode})',
        );
        return null;
      }
      final token = await _persist(response.body);
      if (token != null) talker.info('data-connector: device enrolled');
      return token;
    } catch (e) {
      talker.warning('data-connector: enrolment errored: $e');
      return null;
    }
  }

  /// Stable per-install id.
  ///
  /// Always `thisDeviceId`, never the server-assigned device id: the
  /// connector keys its device row on (installId, userId), so sending the
  /// device id back after the first enrolment would change the key and
  /// create a second row every time.
  static String? _installId() {
    final existing = env.installId;
    if (existing != null && existing.trim().isNotEmpty) return existing.trim();
    return null;
  }

  static String _platformLabel() => env.read('defaultApp') ?? 'flipper';

  /// Stores a token response and returns the access token.
  ///
  /// The refresh token is written BEFORE this returns. The server has already
  /// retired the previous one, so losing the new one to a crash here would
  /// strand the device — recoverable only by re-enrolment.
  static Future<String?> _persist(String responseBody) async {
    try {
      final decoded = jsonDecode(responseBody);
      if (decoded is! Map) return null;

      final access = decoded['accessToken'];
      final refresh = decoded['refreshToken'];
      final expiresIn = decoded['expiresIn'];
      if (access is! String || access.isEmpty) return null;

      if (refresh is String && refresh.isNotEmpty) {
        await env.write(_refreshTokenKey, refresh);
      }
      final deviceId = decoded['deviceId'];
      if (deviceId is String && deviceId.isNotEmpty) {
        await env.write(_deviceIdKey, deviceId);
      }

      final ttlSeconds = expiresIn is int
          ? expiresIn
          : int.tryParse('${expiresIn ?? ''}') ?? 900;
      final expiresAt = DateTime.now()
          .add(Duration(seconds: ttlSeconds))
          .millisecondsSinceEpoch;

      await env.write(_accessTokenKey, access);
      await env.write(_accessExpiryKey, '$expiresAt');
      return access;
    } catch (e) {
      talker.warning('data-connector: could not parse token response: $e');
      return null;
    }
  }
}

/// The app state [DataConnectorSessionService] depends on.
///
/// Exists so the service can be driven in a test without a service locator,
/// a preference file or a signed-in Firebase user.
abstract interface class DataConnectorSessionEnv {
  String? read(String key);

  Future<void> write(String key, String value);

  /// Stable id for this install, surviving logout.
  String? get installId;

  String? get businessId;

  String? get branchId;

  /// Proof of identity for enrolment, or null when nobody is signed in.
  Future<Map<String, String>?> identityProof();
}

/// The production implementation: preferences via the service locator's
/// preference box, identity via Firebase.
class ProxyServiceSessionEnv implements DataConnectorSessionEnv {
  const ProxyServiceSessionEnv();

  @override
  String? read(String key) => ProxyService.box.readString(key: key);

  @override
  Future<void> write(String key, String value) =>
      ProxyService.box.writeString(key: key, value: value);

  /// Reuses `thisDeviceId`, which is deliberately excluded from the session
  /// keys cleared at logout, so re-enrolling reuses one device row rather
  /// than creating one per login.
  @override
  String? get installId => ProxyService.box.getThisDeviceId();

  @override
  String? get businessId => ProxyService.box.getBusinessId()?.toString();

  @override
  String? get branchId => ProxyService.box.getBranchId()?.toString();

  @override
  Future<Map<String, String>?> identityProof() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return null;
      final idToken = await user.getIdToken();
      if (idToken == null || idToken.isEmpty) return null;
      return {'firebaseIdToken': idToken};
    } catch (e) {
      talker.warning('data-connector: could not read Firebase ID token: $e');
      return null;
    }
  }
}

/// The outcome of one refresh attempt.
///
/// A bare `String?` conflated two cases that call for opposite responses: the
/// server saying "this token is dead" (re-enrol) and the network saying
/// nothing at all (keep the token and try later). Collapsing them meant every
/// offline blip burned the refresh token.
class _RefreshResult {
  const _RefreshResult.renewed(String this.token) : rejected = false;

  /// The server answered, and the answer was no.
  const _RefreshResult.rejected() : token = null, rejected = true;

  /// We never got an answer. Says nothing about the token's validity.
  const _RefreshResult.unreachable() : token = null, rejected = false;

  final String? token;
  final bool rejected;
}
