import 'dart:convert';

import 'package:flipper_models/helperModels/talker.dart';
import 'package:http/http.dart' as http;

/// Produces `Authorization` headers for data-connector calls.
///
/// Declared here rather than imported from `flipper_services` so the clients
/// in this package can be constructed in a test without dragging in
/// `ProxyService`, Firebase and the preference store. `flipper_services`
/// registers the real implementation at boot.
abstract interface class DataConnectorAuth {
  /// Headers to merge into the request. Empty when no token is available —
  /// callers must still send the request, because the server is in warn mode
  /// during rollout and an unauthenticated call still succeeds.
  Future<Map<String, String>> authHeaders({required String baseUrl});

  /// Drop the cached access token so the next call fetches a new one.
  Future<void> invalidateAccessToken();
}

DataConnectorAuth? _auth;

/// Lend the models layer the host's auth implementation.
///
/// Unregistered means "send requests unauthenticated", which is what
/// `flipper_hr` and the tests want, and what every caller did before this
/// existed.
void setDataConnectorAuth(DataConnectorAuth? auth) => _auth = auth;

DataConnectorAuth? get dataConnectorAuth => _auth;

/// An `http.Client` that authenticates data-connector requests.
///
/// Wrapping the client rather than editing each call site means the nine or so
/// clients in this package get the header by construction — and, more to the
/// point, a client added later gets it too.
///
/// On a 401 it refreshes once and retries. Retrying is safe for reads; for
/// writes see [_isRetryable] — a 401 is returned before the handler runs, so
/// the request had no effect, but that is only true of the first attempt.
class DataConnectorClient extends http.BaseClient {
  DataConnectorClient({
    required String baseUrl,
    http.Client? inner,
    DataConnectorAuth? auth,
  }) : _baseUrl = baseUrl,
       _inner = inner ?? http.Client(),
       // Only close what we opened. Callers that resolve a base URL per
       // request wrap one long-lived inner client repeatedly; closing it
       // from a throwaway wrapper would break every later call.
       _ownsInner = inner == null,
       _auth = auth;

  final String _baseUrl;
  final http.Client _inner;
  final bool _ownsInner;
  final DataConnectorAuth? _auth;

  DataConnectorAuth? get _resolvedAuth => _auth ?? dataConnectorAuth;

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    final auth = _resolvedAuth;
    if (auth == null) return _inner.send(request);

    final headers = await auth.authHeaders(baseUrl: _baseUrl);
    if (headers.isEmpty) return _inner.send(request);

    final first = await _inner.send(_copyWith(request, headers));
    if (first.statusCode != 401) return first;

    // A 401 means the access token is stale or was rejected. 403 is a tenant
    // or scope problem, which retrying cannot fix, so it is deliberately not
    // handled here.
    if (!_isRetryable(request)) {
      talker.warning(
        'data-connector: 401 on ${request.method} ${request.url.path}; '
        'not retrying a request whose body may already have been consumed',
      );
      return first;
    }

    // Drain the rejected response so the connection is released before the
    // retry reuses the pool.
    await first.stream.drain<void>();

    await auth.invalidateAccessToken();
    final refreshed = await auth.authHeaders(baseUrl: _baseUrl);
    if (refreshed.isEmpty) return _inner.send(_copyWith(request, const {}));

    talker.info('data-connector: retrying ${request.method} after refresh');
    return _inner.send(_copyWith(request, refreshed));
  }

  /// Whether this request can be replayed.
  ///
  /// `http.Request` holds its body in memory, so re-sending is exact. A
  /// streamed or multipart body has already been consumed by the first
  /// attempt and cannot be replayed — retrying one would send an empty or
  /// truncated body, which on `/rra/products/bulk-add` would be worse than
  /// the 401.
  static bool _isRetryable(http.BaseRequest request) => request is http.Request;

  http.BaseRequest _copyWith(
    http.BaseRequest original,
    Map<String, String> extraHeaders,
  ) {
    if (original is! http.Request) {
      // Nothing to copy safely; pass the original through with headers added.
      original.headers.addAll(extraHeaders);
      return original;
    }
    final copy = http.Request(original.method, original.url)
      ..followRedirects = original.followRedirects
      ..maxRedirects = original.maxRedirects
      ..persistentConnection = original.persistentConnection
      ..headers.addAll(original.headers)
      ..headers.addAll(extraHeaders);
    // Assign bytes, not `body`: setting `body` re-encodes using the request's
    // current encoding and would corrupt a payload whose charset differs.
    copy.bodyBytes = original.bodyBytes;
    return copy;
  }

  @override
  void close() {
    if (_ownsInner) _inner.close();
    super.close();
  }
}

/// Convenience for the handful of call sites that build headers themselves
/// rather than going through a client (the SSE stream, for one).
Future<Map<String, String>> dataConnectorJsonHeaders({
  required String baseUrl,
  Map<String, String> extra = const {},
}) async {
  final headers = <String, String>{
    'Content-Type': 'application/json',
    ...extra,
  };
  final auth = dataConnectorAuth;
  if (auth == null) return headers;
  headers.addAll(await auth.authHeaders(baseUrl: baseUrl));
  return headers;
}

/// Decodes a JSON object body, or null when the payload is not an object.
Map<String, dynamic>? decodeJsonObject(String body) {
  try {
    final decoded = jsonDecode(body);
    return decoded is Map<String, dynamic> ? decoded : null;
  } catch (_) {
    return null;
  }
}
