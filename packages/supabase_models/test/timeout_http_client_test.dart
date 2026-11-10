import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:supabase_models/http/timeout_http_client.dart';

/// A server that accepts the request and never answers.
class _SilentServer extends http.BaseClient {
  bool closed = false;

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) =>
      Completer<http.StreamedResponse>().future;

  @override
  void close() => closed = true;
}

class _FastServer extends http.BaseClient {
  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async =>
      http.StreamedResponse(Stream.value('ok'.codeUnits), 200);
}

/// A request to a server that never answers used to wait forever: the MoMo
/// Pay spinner and the PIN login "Verifying…" never ended, and the offline
/// write queue stalled behind the stuck job.
void main() {
  final api =
      Uri.parse('https://example.supabase.co/rest/v1/customer_payments');
  final upload = Uri.parse(
    'https://example.supabase.co/storage/v1/object/public/logo.png',
  );

  // Short limits, so the test runs in real time.
  TimeoutHttpClient silent() => TimeoutHttpClient(
        _SilentServer(),
        timeout: const Duration(milliseconds: 50),
        uploadTimeout: const Duration(milliseconds: 400),
      );

  test('a server that never answers fails after the limit', () async {
    await expectLater(
      silent().get(api),
      throwsA(
        isA<TimeoutException>().having(
          (e) => e.message,
          'message',
          contains('example.supabase.co'),
        ),
      ),
    );
  });

  test('uploads get the longer limit', () async {
    final client = silent();
    expect(
      client.limitFor(http.Request('POST', upload)),
      const Duration(milliseconds: 400),
    );
    expect(client.limitFor(http.Request('POST', api)), client.timeout);

    final sw = Stopwatch()..start();
    await expectLater(
      client.send(http.Request('POST', upload)),
      throwsA(isA<TimeoutException>()),
    );
    expect(sw.elapsedMilliseconds, greaterThanOrEqualTo(400));
  });

  test('the defaults: one minute, five for uploads', () {
    final client = TimeoutHttpClient(_SilentServer());
    expect(client.timeout, const Duration(seconds: 60));
    expect(client.uploadTimeout, const Duration(minutes: 5));
  });

  test('an answer inside the limit passes through', () async {
    final response = await TimeoutHttpClient(_FastServer()).get(api);
    expect(response.statusCode, 200);
    expect(response.body, 'ok');
  });

  test('close closes the wrapped client', () {
    final server = _SilentServer();
    TimeoutHttpClient(server).close();
    expect(server.closed, isTrue);
  });
}
