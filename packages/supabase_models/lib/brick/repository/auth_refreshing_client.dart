import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
// ignore: depend_on_referenced_packages
import 'package:logging/logging.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Header carrying the `auth.uid()` that was signed in when a request was
/// first enqueued.
///
/// Brick's offline queue serializes a request's headers into SQLite, so this
/// rides along with the job and survives an app restart. It is stripped by
/// [AuthRefreshingClient] before the request leaves the device — Supabase
/// never sees it. This mirrors Brick's own `X-Brick-OfflineFirstPolicy`.
const String enqueuedUserHeader = 'X-Flipper-Enqueued-Uid';

/// A live access token together with the user it belongs to.
typedef QueuedAuth = ({String accessToken, String userId});

/// Supplies a non-expired access token for outgoing requests.
///
/// Exists as a seam so the queue clients can be tested without a live
/// Supabase session.
abstract class AccessTokenSource {
  /// Returns a usable token, refreshing if necessary, or `null` when there is
  /// no session to authenticate with.
  Future<QueuedAuth?> current();

  /// The signed-in user, without triggering a refresh. `null` when signed out.
  String? get currentUserId;
}

/// [AccessTokenSource] backed by the ambient `Supabase.instance` session.
class SupabaseAccessTokenSource implements AccessTokenSource {
  /// Refresh this long before the token actually expires, so a request that is
  /// in flight when the clock rolls over is not rejected.
  static const Duration _expiryLeeway = Duration(minutes: 1);

  /// After a failed refresh, don't try again for this long. The queue ticks
  /// every 5 seconds; without a cooldown a broken session would hammer
  /// `/auth/v1/token`.
  static const Duration _refreshCooldown = Duration(seconds: 30);

  final Logger _logger;

  /// Deduplicates concurrent refreshes; the queue and the UI can both trip the
  /// expiry check at the same moment.
  Future<Session?>? _inFlightRefresh;
  DateTime? _refreshFailedAt;

  SupabaseAccessTokenSource({Logger? logger})
      : _logger = logger ?? Logger('SupabaseAccessTokenSource');

  @override
  String? get currentUserId => _auth?.currentSession?.user.id;

  @override
  Future<QueuedAuth?> current() async {
    final auth = _auth;
    if (auth == null) return null;

    final session = auth.currentSession;
    if (session == null) return null;
    if (!_isExpiring(session)) return _asAuth(session);

    final failedAt = _refreshFailedAt;
    if (failedAt != null &&
        DateTime.now().difference(failedAt) < _refreshCooldown) {
      return null;
    }

    final refreshed = await (_inFlightRefresh ??= _refresh(auth));
    return refreshed == null ? null : _asAuth(refreshed);
  }

  /// `null` until `Supabase.initialize` has completed.
  GoTrueClient? get _auth {
    try {
      return Supabase.instance.client.auth;
    } catch (_) {
      return null;
    }
  }

  QueuedAuth _asAuth(Session session) =>
      (accessToken: session.accessToken, userId: session.user.id);

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
}

/// Paths whose requests are authenticated with the user's access token.
const _authenticatedPaths = ['/rest/v1', '/storage/v1', '/functions/v1'];

/// Paths that carry their own credentials and must be forwarded untouched.
/// Rewriting the header on the token endpoint would break session refresh
/// (and recurse, since refreshes are issued through the same client).
const _passthroughPaths = ['/auth/v1'];

bool _isAuthenticatedPath(String path) =>
    !_passthroughPaths.any(path.startsWith) &&
    _authenticatedPaths.any(path.startsWith);

/// Tags outgoing writes with the `auth.uid()` that owns them.
///
/// This must sit **above** Brick's offline queue: the queue serializes headers
/// when the job is written to SQLite, before [AuthRefreshingClient] ever runs,
/// so a stamp applied lower down would not be persisted with the job.
class EnqueuedUserStampClient extends http.BaseClient {
  static const _pushMethods = ['POST', 'PUT', 'PATCH', 'DELETE'];

  final http.Client _inner;
  final AccessTokenSource _tokenSource;

  EnqueuedUserStampClient(
    this._inner, {
    AccessTokenSource? tokenSource,
  }) : _tokenSource = tokenSource ?? SupabaseAccessTokenSource();

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    if (_pushMethods.contains(request.method) &&
        _isAuthenticatedPath(request.url.path)) {
      final uid = _tokenSource.currentUserId;
      if (uid != null) request.headers[enqueuedUserHeader] = uid;
    }

    return _inner.send(request);
  }

  @override
  void close() {
    _inner.close();
    super.close();
  }
}

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
/// Two cases are not sent at all:
///
/// * No session — synthesizes a retryable [_noSessionStatus] so the job stays
///   queued rather than burning an unauthenticated round trip.
/// * The job was enqueued by a *different* user (see [enqueuedUserHeader]) —
///   synthesizes [_wrongUserStatus], which is outside the queue's reattempt
///   list, so the job is dropped. Without this, a write parked by user A would
///   be committed under user B's identity after a handover on a shared device,
///   which no RLS policy can catch because the credentials really are B's.
class AuthRefreshingClient extends http.BaseClient {
  /// Retryable status used when there is no session to authenticate with.
  /// Must be present in the queue's `reattemptForStatusCodes`.
  static const int _noSessionStatus = 503;

  /// Terminal status used when a job belongs to a different user. Must be
  /// absent from `reattemptForStatusCodes` so the job is discarded.
  static const int _wrongUserStatus = 403;

  final http.Client _inner;
  final String _anonKey;
  final AccessTokenSource _tokenSource;
  final Logger _logger;

  AuthRefreshingClient(
    this._inner, {
    required String anonKey,
    AccessTokenSource? tokenSource,
    Logger? logger,
  })  : _anonKey = anonKey,
        _logger = logger ?? Logger('AuthRefreshingClient'),
        _tokenSource = tokenSource ?? SupabaseAccessTokenSource();

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    final path = request.url.path;
    if (!_isAuthenticatedPath(path)) return _inner.send(request);

    final auth = await _tokenSource.current();

    if (auth == null) {
      _logger.warning(
        'No Supabase session; holding ${request.method} $path in the queue',
      );
      return _refuse(
        request,
        status: _noSessionStatus,
        code: 'no_session',
        message: 'No active Supabase session',
      );
    }

    // Strip before forwarding — this header is for us, not for Supabase.
    final enqueuedBy = request.headers.remove(enqueuedUserHeader);

    // Absent on jobs queued before uid tagging existed; those are sent as-is
    // rather than discarded.
    if (enqueuedBy != null && enqueuedBy != auth.userId) {
      _logger.warning(
        'Dropping ${request.method} $path: queued by $enqueuedBy but the '
        'active session is ${auth.userId}',
      );
      return _refuse(
        request,
        status: _wrongUserStatus,
        code: 'enqueued_by_other_user',
        message: 'Queued request belongs to a different user',
      );
    }

    // Overwrite rather than add: a replayed request already carries a stale
    // Authorization header from whenever it was first queued.
    request.headers['Authorization'] = 'Bearer ${auth.accessToken}';
    request.headers['apikey'] = _anonKey;

    return _inner.send(request);
  }

  /// Builds a locally-synthesized response shaped like a PostgREST error, so
  /// postgrest_dart raises a normal PostgrestException rather than choking on
  /// an unparseable body.
  http.StreamedResponse _refuse(
    http.BaseRequest request, {
    required int status,
    required String code,
    required String message,
  }) {
    final body = jsonEncode({
      'code': code,
      'message': message,
      'details': null,
      'hint': null,
    });

    return http.StreamedResponse(
      Stream.value(utf8.encode(body)),
      status,
      request: request,
      contentLength: body.length,
      headers: const {'content-type': 'application/json; charset=utf-8'},
      reasonPhrase: message,
    );
  }

  @override
  void close() {
    _inner.close();
    super.close();
  }
}
