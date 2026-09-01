import 'dart:convert';

import 'package:http/http.dart' as http;

/// The HTTP surface the payment rails need, and nothing more.
///
/// The rails used to be typed against `flipper_models`' `HttpClientInterface`,
/// which drags in Brick's `Repository`, Firebase auth and `ProxyService` — the
/// reason none of this code could be reached from `flipper_web` or
/// `flipper_hr`. Two methods is all a collection actually uses, so the host app
/// adapts whatever client it already has instead of this package inheriting the
/// app's world.
///
/// `HttpClientInterface` satisfies this shape structurally (it declares the same
/// `get`/`post`), so the adapter in `flipper_services` is a thin forward.
abstract interface class PaymentsHttpClient {
  Future<http.Response> get(Uri url, {Map<String, String>? headers});

  Future<http.Response> post(
    Uri url, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
  });
}

/// The default: a plain `package:http` client.
///
/// Used by any app that has no client of its own to lend — `flipper_hr` and
/// `flipper_web` both start here.
class HttpPaymentsClient implements PaymentsHttpClient {
  HttpPaymentsClient([http.Client? client]) : _client = client ?? http.Client();

  final http.Client _client;

  @override
  Future<http.Response> get(Uri url, {Map<String, String>? headers}) =>
      _client.get(url, headers: headers);

  @override
  Future<http.Response> post(
    Uri url, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
  }) =>
      _client.post(url, headers: headers, body: body, encoding: encoding);

  void close() => _client.close();
}

PaymentsHttpClient? _default;

/// Lend this package the host's HTTP client.
///
/// Most entry points take a client explicitly, because a caller that already
/// has one should pass it. This exists for the few that cannot — the cached
/// `dodoRailHealth()` probe is asked "can we sell cards?" from deep inside a
/// build method, with nothing to thread a client through. `flipper_services`
/// registers its `ProxyService.http` adapter here at boot; anything that does
/// not register gets a plain `package:http` client, which is the right answer
/// for `flipper_hr` and `flipper_web`.
void setDefaultPaymentsHttpClient(PaymentsHttpClient? client) =>
    _default = client;

PaymentsHttpClient get defaultPaymentsHttpClient =>
    _default ??= HttpPaymentsClient();
