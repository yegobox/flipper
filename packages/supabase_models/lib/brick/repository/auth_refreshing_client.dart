import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
// ignore: depend_on_referenced_packages
import 'package:logging/logging.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// An [http.Client] that stamps a *current* Supabase access token onto every
/// outgoing PostgREST/Storage/Functions request.
///
/// This sits **below** Brick's offline queue. That matters: the queue
/// serializes a request's entire header map into SQLite when the request is
/// created (`RestRequestSqliteCache.toSqlite`) and replays it verbatim later,
/// so a job that waits longer than the access-token lifetime (1h by default)
/// would otherwise be sent with a dead JWT and rejected by PostgREST with a
/// 401. Because this client runs on both the first attempt and every replay,
/// the stored `Authorization` header is always overwritten with a live one.
///
/// When no usable token can be obtained, the request is **not** sent — the
/// client synthesizes a retryable [_noSessionStatus] response so the job stays
/// in the queue instead of burning an unauthenticated round trip.
class AuthRefreshingClient extends http.BaseClient {
  /// Retryable status used when there is no session to authenticate with.
  /// Must be present in the queue's `reattemptForStatusCodes` so the job is
  /// kept rather than discarded.
  static const int _noSessionStatus = 503;

  /// Refresh the token this long before it actually expires, so a request
  /// that is in flight when the clock rolls over is not rejected.
  static const Duration _expiryLeeway = Duration(minutes: 1);

  /// After a failed refresh, don't try again for this long. The queue ticks
  /// every 5 seconds; without a cooldown a broken session would hammer
  /// `/auth/v1/token`.
  static const Duration _refreshCooldown = Duration(seconds: 30);

  /// Paths that carry their own credentials and must be forwarded untouched.
  /// Rewriting the header on the token endpoint would break session refresh
  /// (and recurse, since refreshes are issued through this same client).
  static const _passthroughPaths = ['/auth/v1'];

  /// Paths whose requests are authenticated with the user's access token.
  static const _authenticatedPaths = ['/rest/v1', '/storage/v1', '/functions/v1'];

  final http.Client _inner;
  final String _anonKey;
  final Logger _logger;

  /// Deduplicates concurrent refreshes; the queue and the UI can both trip the
  /// expiry check at the same moment.
  Future<Session?>? _inFlightRefresh;
  DateTime? _refreshFailedAt;

  AuthRefreshingClient(
    this._inner, {
    required String anonKey,
    Logger? logger,
  })  : _anonKey = anonKey,
        _logger = logger ?? Logger('AuthRefreshingClient');

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    final path = request.url.path;

    if (_passthroughPaths.any(path.startsWith) ||
        !_authenticatedPaths.any(path.startsWith)) {
      return _inner.send(request);
    }

    final token = await _currentAccessToken();

    if (token == null) {
      _logger.warning(
        'No Supabase session; holding ${request.method} $path in the queue',
      );
      // Shaped like a PostgREST error so postgrest_dart raises a normal
      // PostgrestException rather than choking on an unparseable body.
      const body =
          '{"code":"no_session","message":"No active Supabase session",'
          '"details":null,"hint":null}';
      return http.StreamedResponse(
        Stream.value(utf8.encode(body)),
        _noSessionStatus,
        request: request,
        contentLength: body.length,
        headers: const {'content-type': 'application/json; charset=utf-8'},
        reasonPhrase: 'No active Supabase session',
      );
    }

    // Overwrite rather than add: a replayed request already carries a stale
    // Authorization header from whenever it was first queued.
    request.headers['Authorization'] = 'Bearer $token';
    request.headers['apikey'] = _anonKey;

    return _inner.send(request);
  }

  /// Returns a non-expired access token, refreshing if necessary, or `null`
  /// when the user has no session (signed out, or never signed in).
  Future<String?> _currentAccessToken() async {
    final GoTrueClient auth;
    try {
      auth = Supabase.instance.client.auth;
    } catch (_) {
      // Supabase.initialize hasn't completed yet.
      return null;
    }

    final session = auth.currentSession;
    if (session == null) return null;
    if (!_isExpiring(session)) return session.accessToken;

    final failedAt = _refreshFailedAt;
    if (failedAt != null &&
        DateTime.now().difference(failedAt) < _refreshCooldown) {
      return null;
    }

    final refreshed = await (_inFlightRefresh ??= _refresh(auth));
    return refreshed?.accessToken;
  }

  Future<Session?> _refresh(GoTrueClient auth) async {
    try {
      final response = await auth.refreshSession();
      _refreshFailedAt = null;
      return response.session;
    } catch (e) {
      _refreshFailedAt = DateTime.now();
      _logger.warning('Failed to refresh Supabase session: $e');
      return null;
    } finally {
      _inFlightRefresh = null;
    }
  }

  bool _isExpiring(Session session) {
    final expiresAt = session.expiresAt;
    if (expiresAt == null) return session.isExpired;

    final expiry = DateTime.fromMillisecondsSinceEpoch(expiresAt * 1000);
    return DateTime.now().add(_expiryLeeway).isAfter(expiry);
  }

  @override
  void close() {
    _inner.close();
    super.close();
  }
}
