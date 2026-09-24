import 'dart:async';
import 'dart:convert';

import 'package:flipper_models/data_connector_client.dart';
import 'package:flipper_payments/flipper_payments.dart'
    show PaymentsHttpClient, setDefaultPaymentsHttpClient;
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
  /// [identityChanges] and [currentIdentityToken] default to Supabase. They
  /// are injectable for the same reason `DataConnectorSessionEnv` is on the
  /// native side: `Supabase.instance` throws unless the whole app has booted,
  /// so without a seam the token lifecycle cannot be tested at all — which is
  /// how the sign-out leak got this far.
  DataConnectorWebAuth({
    http.Client? client,
    Stream<String?>? identityChanges,
    String? Function()? currentIdentityToken,
  }) : _client = client ?? http.Client(),
       _currentIdentityToken = currentIdentityToken ?? _supabaseAccessToken {
    _subscription = (identityChanges ?? _supabaseUserIdChanges()).listen(
      _onIdentityChanged,
    );
  }

  static String? _supabaseAccessToken() =>
      Supabase.instance.client.auth.currentSession?.accessToken;

  static Stream<String?> _supabaseUserIdChanges() => Supabase
      .instance
      .client
      .auth
      .onAuthStateChange
      .map((state) => state.session?.user.id);

  final http.Client _client;
  final String? Function() _currentIdentityToken;
  late final StreamSubscription<String?> _subscription;

  String? _accessToken;
  DateTime? _expiresAt;
  String? _refreshToken;

  /// The Supabase user these credentials belong to.
  ///
  /// Signing out does not tear down the page, so without this the next user
  /// to sign in on the same tab would inherit the previous user's connector
  /// tokens — and because refresh tokens rotate, they would not even lapse
  /// on their own.
  String? _userId;

  /// Bumped whenever the identity changes. A refresh that started under an
  /// older generation must not write its result back over the new session.
  int _generation = 0;

  /// Joins concurrent callers onto one refresh, so a page that fires several
  /// requests at once does not rotate the refresh token from under itself.
  Future<String?>? _inFlight;

  /// Stable for the life of the tab.
  ///
  /// Not the server-assigned device id: the connector keys its device row on
  /// (installId, userId), so echoing the device id back would change the key
  /// and open a fresh row on every re-enrolment. Not persisted either — a
  /// browser-side install id would be a tracking identifier we do not need,
  /// and one row per tab is revocable individually.
  late final String _installId = 'web-${DateTime.now().millisecondsSinceEpoch}';

  static const _skew = Duration(minutes: 2);
  static const _timeout = Duration(seconds: 20);

  void _onIdentityChanged(String? userId) {
    // Keep the credentials only for a token refresh on the *same* signed-in
    // user. Deliberately not a plain `userId == _userId`: `_userId` is null
    // until the first event arrives, so a sign-out emitted before we ever saw
    // a sign-in would compare equal to null and skip the teardown — leaving
    // the previous user's tokens live for whoever signs in next.
    final sameUserStillSignedIn = userId != null && userId == _userId;
    _userId = userId;
    if (sameUserStillSignedIn) return;
    _forget();
  }

  /// Whether any credential is currently held. Lets a test assert that a
  /// sign-out actually emptied the cache, which is the whole point of this
  /// class's teardown.
  @visibleForTesting
  bool get debugHasCachedToken => _accessToken != null || _refreshToken != null;

  /// Drops every credential and orphans any refresh already running.
  void _forget() {
    _generation++;
    _accessToken = null;
    _expiresAt = null;
    _refreshToken = null;
    _inFlight = null;
  }

  void dispose() {
    _subscription.cancel();
    _client.close();
  }

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

  /// Drops the cached access token so the next call fetches a new one.
  ///
  /// A refresh already running makes this a no-op: clearing `_inFlight` under
  /// it would let the next caller start a second refresh with the same
  /// refresh token, and the server reads a replayed rotated token as theft
  /// and revokes the device.
  @override
  Future<void> invalidateAccessToken() async {
    if (_inFlight != null) return;
    _accessToken = null;
    _expiresAt = null;
  }

  Future<String?> _ensure({required String baseUrl}) async {
    if (_tokenLooksValid) return _accessToken;
    final existing = _inFlight;
    if (existing != null) return existing;

    final generation = _generation;
    final attempt = _refreshOrEnroll(baseUrl: baseUrl, generation: generation);
    _inFlight = attempt;
    try {
      return await attempt;
    } finally {
      // Only retract our own attempt; a sign-out part-way through has already
      // cleared it, and clobbering that would resurrect a dead session.
      if (identical(_inFlight, attempt)) _inFlight = null;
    }
  }

  Future<String?> _refreshOrEnroll({
    required String baseUrl,
    required int generation,
  }) async {
    final refresh = _refreshToken;
    if (refresh != null && refresh.isNotEmpty) {
      final token = await _post(
        baseUrl: baseUrl,
        path: 'auth/token',
        payload: {'refreshToken': refresh},
        generation: generation,
      );
      if (token != null) return token;
      if (generation != _generation) return null;
      // Dead refresh token; fall through and enrol again.
      _refreshToken = null;
    }

    final supabaseToken = _currentIdentityToken();
    if (supabaseToken == null || supabaseToken.isEmpty) {
      // Normal during boot, but indistinguishable from a real problem
      // without a line in the log: a silent null here looks exactly like a
      // rejected enrolment, and that ambiguity cost real debugging time.
      debugPrint(
        '[data-connector]: no Supabase session, skipping enrolment '
        '(requests will go out unauthenticated)',
      );
      return null;
    }

    debugPrint('[data-connector]: enrolling…');

    return _post(
      baseUrl: baseUrl,
      path: 'auth/enroll',
      payload: {
        'enrollKey': AppSecrets.dataConnectorEnrollKey,
        'installId': _installId,
        'supabaseAccessToken': supabaseToken,
        'platform': 'flipper_web',
      },
      generation: generation,
    );
  }

  Future<String?> _post({
    required String baseUrl,
    required String path,
    required Map<String, dynamic> payload,
    required int generation,
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
        debugPrint('[data-connector] $path → ${response.statusCode}');
        return null;
      }
      final decoded = jsonDecode(response.body);
      if (decoded is! Map) return null;

      final access = decoded['accessToken'];
      if (access is String && access.isNotEmpty) {
        debugPrint('[data-connector] $path → ok');
      }
      if (access is! String || access.isEmpty) return null;

      // The user signed out (or changed) while this was in flight. Writing
      // these back would hand the new session the old user's credentials,
      // which is the leak `_forget` exists to close.
      if (generation != _generation) return null;

      final refresh = decoded['refreshToken'];
      if (refresh is String && refresh.isNotEmpty) _refreshToken = refresh;
      final expiresIn = decoded['expiresIn'];
      final ttl = expiresIn is int ? expiresIn : 900;
      _accessToken = access;
      _expiresAt = DateTime.now().add(Duration(seconds: ttl));
      return access;
    } catch (e) {
      // Offline or connector down. Callers send the request unauthenticated,
      // which still works while the connector is in warn mode.
      debugPrint('[data-connector] $path failed: $e');
      return null;
    }
  }
}

/// Lends `flipper_models` this app's Supabase-backed token source, and puts
/// the payment rails on it too.
///
/// `MomoClient`, `DodoClient` and `CustomPaymentClient` are built on
/// `defaultPaymentsHttpClient`, which is a bare client unless the host swaps
/// one in — so Books' MoMo and card rails sent no device token and got 401 once
/// the connector enforced auth. The mobile app does the same swap in
/// `registerFlipperPaymentsHost`.
void registerDataConnectorWebAuth() {
  setDataConnectorAuth(DataConnectorWebAuth());
  setDefaultPaymentsHttpClient(DataConnectorAuthedPaymentsClient());
}

/// A [PaymentsHttpClient] that sends the data-connector device token.
///
/// Delegates to [DataConnectorClient] per request, keyed on the request's own
/// origin: the payments base URL can be overridden at runtime
/// (`PAYMENTS_BASE_URL`), so the token must follow the host actually called.
/// A caller that sets its own `Authorization` (the custom-payment staff token)
/// keeps it, and a 401 refreshes once and retries — both inherited from
/// [DataConnectorClient].
class DataConnectorAuthedPaymentsClient implements PaymentsHttpClient {
  DataConnectorAuthedPaymentsClient([http.Client? inner])
    : _inner = inner ?? http.Client();

  final http.Client _inner;

  http.Client _for(Uri url) => DataConnectorClient(
    baseUrl: '${url.scheme}://${url.authority}',
    inner: _inner,
  );

  @override
  Future<http.Response> get(Uri url, {Map<String, String>? headers}) =>
      _for(url).get(url, headers: headers);

  @override
  Future<http.Response> post(
    Uri url, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
  }) => _for(url).post(url, headers: headers, body: body, encoding: encoding);
}
