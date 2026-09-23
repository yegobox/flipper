import 'dart:convert';

import 'package:flipper_models/data_connector_client.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:test/test.dart';

/// Records what it was asked and replies with a scripted queue of statuses.
class _FakeAuth implements DataConnectorAuth {
  _FakeAuth(this._tokens);

  final List<String?> _tokens;
  int headerCalls = 0;
  int invalidations = 0;

  @override
  Future<Map<String, String>> authHeaders({required String baseUrl}) async {
    final index = headerCalls < _tokens.length ? headerCalls : _tokens.length - 1;
    headerCalls++;
    final token = _tokens[index];
    if (token == null) return const {};
    return {'Authorization': 'Bearer $token'};
  }

  @override
  Future<void> invalidateAccessToken() async => invalidations++;
}

void main() {
  setUp(() => setDataConnectorAuth(null));
  tearDown(() => setDataConnectorAuth(null));

  group('DataConnectorClient', () {
    test('attaches the bearer token', () async {
      final seen = <String?>[];
      final inner = MockClient((req) async {
        seen.add(req.headers['Authorization']);
        return http.Response('{}', 200);
      });

      final client = DataConnectorClient(
        baseUrl: 'https://example.invalid/',
        inner: inner,
        auth: _FakeAuth(['tok-1']),
      );
      await client.get(Uri.parse('https://example.invalid/transactions'));

      expect(seen.single, 'Bearer tok-1');
    });

    test('sends the request unauthenticated when there is no token', () async {
      // The warn-mode rollout depends on this: a device that cannot enrol yet
      // must still be able to call the API.
      final seen = <String?>[];
      final inner = MockClient((req) async {
        seen.add(req.headers['Authorization']);
        return http.Response('{}', 200);
      });

      final client = DataConnectorClient(
        baseUrl: 'https://example.invalid/',
        inner: inner,
        auth: _FakeAuth([null]),
      );
      final res =
          await client.get(Uri.parse('https://example.invalid/transactions'));

      expect(res.statusCode, 200);
      expect(seen.single, isNull);
    });

    test('refreshes once and retries on 401', () async {
      final tokens = <String?>[];
      var calls = 0;
      final inner = MockClient((req) async {
        calls++;
        tokens.add(req.headers['Authorization']);
        if (calls == 1) return http.Response('{"error":"nope"}', 401);
        return http.Response('{"ok":true}', 200);
      });

      final auth = _FakeAuth(['stale', 'fresh']);
      final client = DataConnectorClient(
        baseUrl: 'https://example.invalid/',
        inner: inner,
        auth: auth,
      );
      final res =
          await client.get(Uri.parse('https://example.invalid/transactions'));

      expect(res.statusCode, 200);
      expect(calls, 2, reason: 'exactly one retry');
      expect(tokens, ['Bearer stale', 'Bearer fresh']);
      expect(auth.invalidations, 1);
    });

    test('does not retry more than once', () async {
      var calls = 0;
      final inner = MockClient((req) async {
        calls++;
        return http.Response('{"error":"nope"}', 401);
      });

      final client = DataConnectorClient(
        baseUrl: 'https://example.invalid/',
        inner: inner,
        auth: _FakeAuth(['a', 'b', 'c']),
      );
      final res =
          await client.get(Uri.parse('https://example.invalid/transactions'));

      expect(res.statusCode, 401);
      expect(calls, 2, reason: 'a second 401 must not loop');
    });

    test('does not retry a 403', () async {
      // 403 is a tenant or scope problem. Refreshing cannot fix it, and
      // retrying a write would repeat its side effects for nothing.
      var calls = 0;
      final inner = MockClient((req) async {
        calls++;
        return http.Response('{"error":"wrong tenant"}', 403);
      });

      final client = DataConnectorClient(
        baseUrl: 'https://example.invalid/',
        inner: inner,
        auth: _FakeAuth(['a', 'b']),
      );
      final res =
          await client.get(Uri.parse('https://example.invalid/transactions'));

      expect(res.statusCode, 403);
      expect(calls, 1);
    });

    test('replays a POST body exactly on retry', () async {
      final bodies = <String>[];
      var calls = 0;
      final inner = MockClient((req) async {
        calls++;
        bodies.add(req.body);
        if (calls == 1) return http.Response('{}', 401);
        return http.Response('{"ok":true}', 200);
      });

      final client = DataConnectorClient(
        baseUrl: 'https://example.invalid/',
        inner: inner,
        auth: _FakeAuth(['stale', 'fresh']),
      );
      final payload = jsonEncode({'items': [1, 2, 3]});
      final res = await client.post(
        Uri.parse('https://example.invalid/rra/products/bulk-add'),
        headers: const {'Content-Type': 'application/json'},
        body: payload,
      );

      expect(res.statusCode, 200);
      // A truncated or empty replay on bulk-add would be worse than the 401.
      expect(bodies, [payload, payload]);
    });

    test('passes through untouched when no auth is registered', () async {
      final seen = <String?>[];
      final inner = MockClient((req) async {
        seen.add(req.headers['Authorization']);
        return http.Response('{}', 200);
      });

      final client = DataConnectorClient(
        baseUrl: 'https://example.invalid/',
        inner: inner,
      );
      await client.get(Uri.parse('https://example.invalid/transactions'));

      expect(seen.single, isNull);
    });

    test('uses the globally registered auth when none is injected', () async {
      setDataConnectorAuth(_FakeAuth(['global-tok']));
      final seen = <String?>[];
      final inner = MockClient((req) async {
        seen.add(req.headers['Authorization']);
        return http.Response('{}', 200);
      });

      final client = DataConnectorClient(
        baseUrl: 'https://example.invalid/',
        inner: inner,
      );
      await client.get(Uri.parse('https://example.invalid/transactions'));

      expect(seen.single, 'Bearer global-tok');
    });
  });

  group('dataConnectorJsonHeaders', () {
    test('always sets the content type', () async {
      final headers =
          await dataConnectorJsonHeaders(baseUrl: 'https://example.invalid/');
      expect(headers['Content-Type'], 'application/json');
    });

    test('adds the bearer when auth is registered', () async {
      setDataConnectorAuth(_FakeAuth(['sse-tok']));
      final headers =
          await dataConnectorJsonHeaders(baseUrl: 'https://example.invalid/');
      expect(headers['Authorization'], 'Bearer sse-tok');
    });
  });
}
