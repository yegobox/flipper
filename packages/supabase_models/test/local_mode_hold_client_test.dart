import 'package:flipper_web/core/local_mode/local_mode.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:supabase_models/brick/repository/local_mode_hold_client.dart';

void main() {
  late List<http.BaseRequest> sent;
  late bool local;
  late LocalModeHoldClient client;

  setUp(() {
    sent = [];
    local = true;
    client = LocalModeHoldClient(
      MockClient((request) async {
        sent.add(request);
        return http.Response('[]', 200);
      }),
      isLocal: () => local,
    );
  });

  Future<int> call(String method, String path) async {
    final request =
        http.Request(method, Uri.parse('https://x.supabase.co$path'));
    final response = await client.send(request);
    return response.statusCode;
  }

  test('holds every PostgREST write with a retryable 503', () async {
    for (final method in ['POST', 'PUT', 'PATCH', 'DELETE']) {
      expect(await call(method, '/rest/v1/access'), 503, reason: method);
    }
    expect(await call('POST', '/rest/v1/rpc/deduct_credits'), 503);
    expect(sent, isEmpty);
  });

  test('reads and auth still reach the server', () async {
    expect(await call('GET', '/rest/v1/businesses'), 200);
    expect(await call('POST', '/auth/v1/token'), 200);
    expect(sent, hasLength(2));
  });

  test('allowCloud lets the sync_mode record through', () async {
    final status = await LocalMode.allowCloud(
      () => call('PATCH', '/rest/v1/businesses'),
    );
    expect(status, 200);
    expect(sent, hasLength(1));
  });

  test('sends everything once local mode is off', () async {
    local = false;
    expect(await call('POST', '/rest/v1/access'), 200);
    expect(sent, hasLength(1));
  });
}
