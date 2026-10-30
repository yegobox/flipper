import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flipper_analytics/flipper_analytics.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _FakeContextProvider implements AnalyticsContextProvider {
  _FakeContextProvider({this.userId = 'user-1'});

  @override
  final String? userId;

  @override
  String? get branchId => 'branch-1';

  @override
  String? get businessId => 'business-1';

  @override
  Map<String, Object?> buildBaseProperties() {
    return const {'app': 'flipper', 'platform': 'windows'};
  }
}

class _RecordingClient extends MockClient {
  _RecordingClient(super.fn);

  bool closed = false;

  @override
  void close() {
    closed = true;
    super.close();
  }
}

class _Harness {
  _Harness({
    this.userId = 'user-1',
    Future<http.Response> Function(http.Request request)? respond,
  }) : _respond = respond ?? ((_) async => http.Response('', 204));

  final String? userId;
  final Future<http.Response> Function(http.Request request) _respond;
  final requests = <http.Request>[];
  final clients = <_RecordingClient>[];
  DateTime now = DateTime.utc(2026, 10, 29, 8);
  bool online = true;
  bool enabled = true;

  Ga4ActiveUserPinger build({
    Duration heartbeat = const Duration(minutes: 15),
    bool validateOnly = false,
    Future<SharedPreferences> Function()? preferences,
  }) {
    return Ga4ActiveUserPinger(
      measurementId: 'G-TEST',
      apiSecret: 'secret-1',
      contextProvider: _FakeContextProvider(userId: userId),
      createClient: () {
        final client = _RecordingClient((request) {
          requests.add(request);
          return _respond(request);
        });
        clients.add(client);
        return client;
      },
      preferences: preferences,
      clock: () => now,
      hasNetwork: () async => online,
      isEnabled: () => enabled,
      heartbeat: heartbeat,
      validateOnly: validateOnly,
    );
  }

  Future<void> advance(WidgetTester tester, Duration duration) async {
    now = now.add(duration);
    await tester.pump(duration);
  }

  Map<String, dynamic> body(int index) =>
      jsonDecode(requests[index].body) as Map<String, dynamic>;

  Map<String, dynamic> params(int index) =>
      (body(index)['events'] as List).single['params'] as Map<String, dynamic>;
}

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('cold start sends one app_active the stream counts as active', (
    tester,
  ) async {
    final harness = _Harness();
    final pinger = harness.build()..attach();
    await tester.pump();

    expect(harness.requests, hasLength(1));
    final request = harness.requests.single;
    expect(request.method, 'POST');
    expect(request.url.host, 'www.google-analytics.com');
    expect(request.url.path, '/mp/collect');
    expect(request.url.queryParameters, {
      'measurement_id': 'G-TEST',
      'api_secret': 'secret-1',
    });

    final body = harness.body(0);
    expect(body['client_id'], isA<String>());
    expect(body['user_id'], 'user-1');
    final event = (body['events'] as List).single as Map<String, dynamic>;
    expect(event['name'], Ga4ActiveUserPinger.eventName);
    final params = harness.params(0);
    expect(params['session_id'], isNotEmpty);
    expect(params['engagement_time_msec'], greaterThan(0));
    expect(params['platform'], 'windows');
    expect(params['business_id'], 'business-1');
    expect(params['branch_id'], 'branch-1');

    await pinger.detach();
  });

  testWidgets('attach returns before any I/O completes', (tester) async {
    final harness = _Harness();
    final pinger = harness.build()..attach();

    expect(harness.requests, isEmpty);
    await tester.pump();
    expect(harness.requests, hasLength(1));

    await pinger.detach();
  });

  testWidgets('client_id is stable across instances', (tester) async {
    final harness = _Harness();
    final first = harness.build()..attach();
    await tester.pump();
    await first.detach();

    final second = harness.build()..attach();
    await tester.pump();
    await second.detach();

    expect(harness.requests, hasLength(2));
    expect(harness.body(1)['client_id'], harness.body(0)['client_id']);
    final prefs = await SharedPreferences.getInstance();
    expect(
      prefs.getString(Ga4ActiveUserPinger.clientIdKey),
      harness.body(0)['client_id'],
    );
  });

  testWidgets('heartbeats while in the foreground with elapsed engagement', (
    tester,
  ) async {
    final harness = _Harness();
    final pinger = harness.build()..attach();
    await tester.pump();

    await harness.advance(tester, const Duration(minutes: 15));
    await harness.advance(tester, const Duration(minutes: 15));

    expect(harness.requests, hasLength(3));
    expect(harness.params(1)['engagement_time_msec'], 15 * 60 * 1000);
    expect(harness.params(2)['session_id'], harness.params(0)['session_id']);

    await pinger.detach();
  });

  testWidgets('an unfocused window keeps counting, a hidden one stops', (
    tester,
  ) async {
    final harness = _Harness();
    final pinger = harness.build()..attach();
    await tester.pump();

    pinger.didChangeAppLifecycleState(AppLifecycleState.inactive);
    await harness.advance(tester, const Duration(minutes: 15));
    expect(harness.requests, hasLength(2));

    pinger.didChangeAppLifecycleState(AppLifecycleState.hidden);
    pinger.didChangeAppLifecycleState(AppLifecycleState.paused);
    await harness.advance(tester, const Duration(hours: 2));
    expect(harness.requests, hasLength(2));

    await pinger.detach();
  });

  testWidgets('resume after 30 min starts a new session, sooner keeps it', (
    tester,
  ) async {
    final harness = _Harness();
    final pinger = harness.build()..attach();
    await tester.pump();
    final firstSession = harness.params(0)['session_id'];

    pinger.didChangeAppLifecycleState(AppLifecycleState.paused);
    await harness.advance(tester, const Duration(minutes: 10));
    pinger.didChangeAppLifecycleState(AppLifecycleState.resumed);
    await tester.pump();
    expect(harness.requests, hasLength(2));
    expect(harness.params(1)['session_id'], firstSession);

    pinger.didChangeAppLifecycleState(AppLifecycleState.paused);
    await harness.advance(tester, const Duration(minutes: 31));
    pinger.didChangeAppLifecycleState(AppLifecycleState.resumed);
    await tester.pump();
    expect(harness.requests, hasLength(3));
    expect(harness.params(2)['session_id'], isNot(firstSession));

    await pinger.detach();
  });

  testWidgets('user_id is left out when nobody is signed in', (tester) async {
    final harness = _Harness(userId: null);
    final pinger = harness.build()..attach();
    await tester.pump();

    expect(harness.body(0).containsKey('user_id'), isFalse);

    await pinger.detach();
  });

  testWidgets('offline skips the send and the next heartbeat catches up', (
    tester,
  ) async {
    final harness = _Harness()..online = false;
    final pinger = harness.build()..attach();
    await tester.pump();
    await harness.advance(tester, const Duration(minutes: 15));
    expect(harness.requests, isEmpty);

    harness.online = true;
    await harness.advance(tester, const Duration(minutes: 15));
    expect(harness.requests, hasLength(1));

    await pinger.detach();
  });

  testWidgets('server errors and socket failures never throw', (tester) async {
    var calls = 0;
    final harness = _Harness(
      respond: (_) async {
        calls++;
        if (calls == 1) return http.Response('boom', 500);
        if (calls == 2) throw const SocketException('no route to host');
        return http.Response('', 204);
      },
    );
    final pinger = harness.build()..attach();
    await tester.pump();
    await harness.advance(tester, const Duration(minutes: 15));
    await harness.advance(tester, const Duration(minutes: 15));

    expect(harness.requests, hasLength(3));
    expect(tester.takeException(), isNull);

    await pinger.detach();
  });

  testWidgets('a hanging server never stacks requests', (tester) async {
    final hang = Completer<http.Response>();
    var calls = 0;
    final harness = _Harness(
      respond: (_) {
        calls++;
        return calls == 1 ? hang.future : Future.value(http.Response('', 204));
      },
    );
    final pinger = harness.build(heartbeat: const Duration(seconds: 1))
      ..attach();
    await tester.pump();

    for (var i = 0; i < 5; i++) {
      await harness.advance(tester, const Duration(seconds: 1));
    }
    expect(harness.requests, hasLength(1));

    // Past the request timeout the slot frees up for the next heartbeat.
    await harness.advance(tester, Ga4ActiveUserPinger.requestTimeout);
    await harness.advance(tester, const Duration(seconds: 1));
    expect(harness.requests.length, greaterThan(1));
    // The timed-out request was aborted with its client, not left pending;
    // later pings go out on a fresh one.
    expect(harness.clients.first.closed, isTrue);
    expect(harness.clients.length, greaterThan(1));
    expect(harness.clients.last.closed, isFalse);

    await pinger.detach();
    hang.complete(http.Response('', 204));
  });

  testWidgets('disabled sends nothing and writes no client id', (tester) async {
    final harness = _Harness()..enabled = false;
    final pinger = harness.build()..attach();
    await tester.pump();
    await harness.advance(tester, const Duration(hours: 1));

    expect(harness.requests, isEmpty);
    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getString(Ga4ActiveUserPinger.clientIdKey), isNull);

    await pinger.detach();
  });

  testWidgets('detach stops every later send', (tester) async {
    final harness = _Harness();
    final pinger = harness.build()..attach();
    await tester.pump();
    await pinger.detach();

    pinger.didChangeAppLifecycleState(AppLifecycleState.resumed);
    await harness.advance(tester, const Duration(hours: 1));
    expect(harness.requests, hasLength(1));
  });

  testWidgets('detach while the client id loads sends nothing', (tester) async {
    final prefsLoaded = Completer<SharedPreferences>();
    final harness = _Harness();
    final pinger = harness.build(preferences: () => prefsLoaded.future)
      ..attach();
    await tester.pump();

    await pinger.detach();
    prefsLoaded.complete(await SharedPreferences.getInstance());
    await tester.pump();

    expect(harness.requests, isEmpty);
  });

  testWidgets('detach closes the client it created; attach makes a new one', (
    tester,
  ) async {
    final harness = _Harness();
    final pinger = harness.build()..attach();
    await tester.pump();
    expect(harness.clients, hasLength(1));
    expect(harness.clients.single.closed, isFalse);

    await pinger.detach();
    expect(harness.clients.single.closed, isTrue);

    pinger.attach();
    await tester.pump();
    expect(harness.clients, hasLength(2));
    expect(harness.clients.last.closed, isFalse);
    expect(harness.requests, hasLength(2));

    await pinger.detach();
  });

  testWidgets('validateOnly posts to the debug endpoint', (tester) async {
    final harness = _Harness(
      respond: (_) async => http.Response('{"validationMessages":[]}', 200),
    );
    final pinger = harness.build(validateOnly: true)..attach();
    await tester.pump();

    expect(harness.requests.single.url.path, '/debug/mp/collect');

    await pinger.detach();
  });
}
