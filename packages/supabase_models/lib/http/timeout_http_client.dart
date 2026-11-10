import 'dart:async';

import 'package:http/http.dart' as http;

/// Gives up on a request whose server has not answered within a time limit.
///
/// `http.Client` has no time limit of its own. A connection that opens but
/// never gets an answer (a captive portal, a half-open socket after the
/// network changed, a server that is stuck) leaves the caller waiting
/// forever. The till then sits on a spinner, such as Pay → MoMo or PIN login,
/// and the serial offline write queue waits behind the stuck request.
///
/// The limit covers the time until the response headers arrive. Reading the
/// body afterwards is not limited, so a large download that has started is
/// never cut off.
class TimeoutHttpClient extends http.BaseClient {
  TimeoutHttpClient(
    this._inner, {
    this.timeout = defaultTimeout,
    this.uploadTimeout = defaultUploadTimeout,
  });

  /// Long enough for every JSON call the app makes. Each one is answered in
  /// seconds, or not at all.
  static const Duration defaultTimeout = Duration(seconds: 60);

  /// File uploads (Supabase Storage) send their whole body before the server
  /// answers, which takes minutes on a slow mobile link.
  static const Duration defaultUploadTimeout = Duration(minutes: 5);

  final http.Client _inner;
  final Duration timeout;
  final Duration uploadTimeout;

  Duration limitFor(http.BaseRequest request) =>
      request.url.path.contains('/storage/v1/') ? uploadTimeout : timeout;

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    final limit = limitFor(request);
    final pending = _inner.send(request);
    return pending.timeout(
      limit,
      onTimeout: () {
        // The timeout does not cancel the request. If the answer still
        // arrives, read and drop it so its connection is released.
        unawaited(
          pending
              .then((response) => response.stream.drain<void>())
              .catchError((Object _) {}),
        );
        throw TimeoutException(
          'No response from ${request.url.host} after ${limit.inSeconds}s',
          limit,
        );
      },
    );
  }

  @override
  void close() => _inner.close();
}
