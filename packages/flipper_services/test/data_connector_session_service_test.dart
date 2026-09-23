import 'dart:convert';
import 'dart:io';

import 'package:flipper_services/data_connector_session_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  final now = DateTime(2026, 9, 23, 12, 0, 0);

  String at(Duration fromNow) => '${now.add(fromNow).millisecondsSinceEpoch}';

  group('token lifecycle', _lifecycleTests);

  group('access token freshness', () {
    test('a token with plenty of life left is fresh', () {
      expect(
        DataConnectorSessionService.isAccessTokenFresh(
          expiresAtEpochMs: at(const Duration(minutes: 14)),
          now: now,
        ),
        isTrue,
      );
    });

    test('a token inside the skew window is already stale', () {
      // Access tokens last 15 minutes and requests take time; treating the
      // last two minutes as dead avoids a token expiring mid-flight.
      expect(
        DataConnectorSessionService.isAccessTokenFresh(
          expiresAtEpochMs: at(const Duration(minutes: 1)),
          now: now,
        ),
        isFalse,
      );
    });

    test('an expired token is stale', () {
      expect(
        DataConnectorSessionService.isAccessTokenFresh(
          expiresAtEpochMs: at(const Duration(minutes: -1)),
          now: now,
        ),
        isFalse,
      );
    });

    test('a missing expiry is stale, not fresh', () {
      // Failing the other way would send a token we cannot reason about.
      expect(
        DataConnectorSessionService.isAccessTokenFresh(
          expiresAtEpochMs: null,
          now: now,
        ),
        isFalse,
      );
    });

    test('an unparseable expiry is stale', () {
      expect(
        DataConnectorSessionService.isAccessTokenFresh(
          expiresAtEpochMs: 'not-a-number',
          now: now,
        ),
        isFalse,
      );
    });

    test('exactly at the skew boundary is stale', () {
      expect(
        DataConnectorSessionService.isAccessTokenFresh(
          expiresAtEpochMs: at(const Duration(minutes: 2)),
          now: now,
        ),
        isFalse,
      );
    });
  });
}

/// In-memory stand-in for preferences + Firebase.
class _FakeEnv implements DataConnectorSessionEnv {
  _FakeEnv({this.proof = const {'firebaseIdToken': 'fb-token'}});

  final Map<String, String> store = {};
  final Map<String, String>? proof;

  @override
  String? read(String key) => store[key];

  @override
  Future<void> write(String key, String value) async => store[key] = value;

  @override
  String? get installId => 'install-1';

  @override
  String? get businessId => 'biz-1';

  @override
  String? get branchId => 'branch-1';

  @override
  Future<Map<String, String>?> identityProof() async => proof;
}

void _lifecycleTests() {
  late _FakeEnv env;

  setUp(() {
    env = _FakeEnv();
    DataConnectorSessionService.env = env;
  });

  tearDown(() async {
    DataConnectorSessionService.testClient = null;
    DataConnectorSessionService.env = const ProxyServiceSessionEnv();
  });

  String tokenResponse(String access, String refresh) => jsonEncode({
    'deviceId': 'dev-1',
    'accessToken': access,
    'refreshToken': refresh,
    'expiresIn': 900,
  });

  test('enrols on first use and stores both tokens', () async {
    final paths = <String>[];
    DataConnectorSessionService.testClient = MockClient((req) async {
      paths.add(req.url.path);
      return http.Response(tokenResponse('acc-1', 'ref-1'), 200);
    });

    final token = await DataConnectorSessionService.ensureAccessToken(
      baseUrl: 'https://c.invalid/',
    );

    expect(token, 'acc-1');
    expect(paths, ['/auth/enroll']);
    expect(env.store['dataConnectorRefreshToken'], 'ref-1');
    expect(env.store['dataConnectorDeviceId'], 'dev-1');
  });

  test('a cached, still-fresh token is reused without a call', () async {
    var calls = 0;
    DataConnectorSessionService.testClient = MockClient((req) async {
      calls++;
      return http.Response(tokenResponse('acc-1', 'ref-1'), 200);
    });

    await DataConnectorSessionService.ensureAccessToken(
      baseUrl: 'https://c.invalid/',
    );
    await DataConnectorSessionService.ensureAccessToken(
      baseUrl: 'https://c.invalid/',
    );

    expect(calls, 1);
  });

  test('concurrent callers trigger exactly one enrolment', () async {
    // The load-bearing one. Refresh tokens rotate, so parallel refreshes
    // would make the losers present a retired token — which the server reads
    // as theft and answers by revoking the device.
    var calls = 0;
    DataConnectorSessionService.testClient = MockClient((req) async {
      calls++;
      await Future<void>.delayed(const Duration(milliseconds: 20));
      return http.Response(tokenResponse('acc-1', 'ref-1'), 200);
    });

    final results = await Future.wait(
      List.generate(
        10,
        (_) => DataConnectorSessionService.ensureAccessToken(
          baseUrl: 'https://c.invalid/',
        ),
      ),
    );

    expect(calls, 1);
    expect(results.every((t) => t == 'acc-1'), isTrue);
  });

  test('refreshes with the stored token rather than re-enrolling', () async {
    final paths = <String>[];
    env.store['dataConnectorRefreshToken'] = 'ref-old';
    DataConnectorSessionService.testClient = MockClient((req) async {
      paths.add(req.url.path);
      return http.Response(tokenResponse('acc-2', 'ref-new'), 200);
    });

    final token = await DataConnectorSessionService.ensureAccessToken(
      baseUrl: 'https://c.invalid/',
    );

    expect(token, 'acc-2');
    expect(paths, ['/auth/token']);
    // The rotated token must be persisted, or the device is stranded.
    expect(env.store['dataConnectorRefreshToken'], 'ref-new');
  });

  test('a rejected refresh falls back to re-enrolment', () async {
    final paths = <String>[];
    env.store['dataConnectorRefreshToken'] = 'ref-dead';
    DataConnectorSessionService.testClient = MockClient((req) async {
      paths.add(req.url.path);
      if (req.url.path == '/auth/token') {
        return http.Response('{"error":"reused"}', 401);
      }
      return http.Response(tokenResponse('acc-3', 'ref-3'), 200);
    });

    final token = await DataConnectorSessionService.ensureAccessToken(
      baseUrl: 'https://c.invalid/',
    );

    // Recovery, not logout: a dead refresh token must not sign the user out.
    expect(token, 'acc-3');
    expect(paths, ['/auth/token', '/auth/enroll']);
  });

  test('returns null when nobody is signed in', () async {
    DataConnectorSessionService.env = _FakeEnv(proof: null);
    DataConnectorSessionService.testClient = MockClient((req) async {
      fail('must not call the connector without an identity');
    });

    expect(
      await DataConnectorSessionService.ensureAccessToken(
        baseUrl: 'https://c.invalid/',
      ),
      isNull,
    );
  });

  test('a 401 during a refresh does not start a second refresh', () async {
    // The revocation race. A parallel request 401s while a refresh is in
    // flight; if `invalidateAccessToken` drops the shared future, the next
    // caller refreshes again with the same rotating token, the server sees a
    // retired token replayed, and it revokes the whole device.
    final bodies = <String>[];
    env.store['dataConnectorRefreshToken'] = 'ref-old';
    DataConnectorSessionService.testClient = MockClient((req) async {
      bodies.add(req.body);
      await Future<void>.delayed(const Duration(milliseconds: 20));
      return http.Response(tokenResponse('acc-2', 'ref-new'), 200);
    });

    final first = DataConnectorSessionService.ensureAccessToken(
      baseUrl: 'https://c.invalid/',
    );
    // Let the refresh get in flight, then simulate the 401 handler.
    await Future<void>.delayed(const Duration(milliseconds: 5));
    await DataConnectorSessionService.invalidateAccessToken();
    final second = DataConnectorSessionService.ensureAccessToken(
      baseUrl: 'https://c.invalid/',
    );

    expect(await first, 'acc-2');
    expect(await second, 'acc-2');
    expect(bodies.length, 1, reason: 'ref-old must be presented exactly once');
    expect(jsonDecode(bodies.single)['refreshToken'], 'ref-old');
  });

  test('a network error during refresh keeps the refresh token', () async {
    // Offline is not a rejection. Discarding the token here would force a
    // re-enrolment, which needs a live Firebase user the device may not have.
    env.store['dataConnectorRefreshToken'] = 'ref-keep';
    DataConnectorSessionService.testClient = MockClient((req) async {
      throw const SocketException('offline');
    });

    final token = await DataConnectorSessionService.ensureAccessToken(
      baseUrl: 'https://c.invalid/',
    );

    expect(token, isNull);
    expect(env.store['dataConnectorRefreshToken'], 'ref-keep');
  });

  test('a network error during refresh does not try to enrol', () async {
    env.store['dataConnectorRefreshToken'] = 'ref-keep';
    final paths = <String>[];
    DataConnectorSessionService.testClient = MockClient((req) async {
      paths.add(req.url.path);
      throw const SocketException('offline');
    });

    await DataConnectorSessionService.ensureAccessToken(
      baseUrl: 'https://c.invalid/',
    );

    expect(paths, ['/auth/token']);
  });

  test('reset clears every credential, for a branch switch', () async {
    // The token carries branch and business claims, so one minted for the
    // old branch would ask the server for the wrong tenant.
    DataConnectorSessionService.testClient = MockClient(
      (req) async => http.Response(tokenResponse('acc-1', 'ref-1'), 200),
    );
    await DataConnectorSessionService.ensureAccessToken(
      baseUrl: 'https://c.invalid/',
    );
    expect(env.store['dataConnectorRefreshToken'], 'ref-1');

    await DataConnectorSessionService.reset();

    expect(env.store['dataConnectorAccessToken'], isEmpty);
    expect(env.store['dataConnectorAccessExpiresAt'], isEmpty);
    expect(env.store['dataConnectorRefreshToken'], isEmpty);
    // The install id survives: it identifies the device, not the session.
    expect(env.store['dataConnectorDeviceId'], 'dev-1');
  });

  test('a network failure yields null instead of throwing', () async {
    // POS must keep working when the connector is unreachable.
    DataConnectorSessionService.testClient = MockClient((req) async {
      throw const SocketException('offline');
    });

    expect(
      await DataConnectorSessionService.ensureAccessToken(
        baseUrl: 'https://c.invalid/',
      ),
      isNull,
    );
  });

  test(
    'authHeaders is empty rather than absent when unauthenticated',
    () async {
      DataConnectorSessionService.env = _FakeEnv(proof: null);
      final headers = await DataConnectorSessionService.authHeaders(
        baseUrl: 'https://c.invalid/',
      );
      expect(headers, isEmpty);
    },
  );
}
