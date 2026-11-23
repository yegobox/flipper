import 'dart:convert';
import 'dart:io';

import 'package:flipper_analytics/flipper_analytics.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:shared_preferences/shared_preferences.dart';

// flutter test test/posthog_transport_test.dart
//
// Windows has no PostHog SDK, so its events go over HTTP. PostHog answers
// 200 to an event without `distinct_id` and then drops it, which is how every
// Windows stall report (`ui_stall`, `ui_hang_killed`) went missing.

void main() {
  late List<Map<String, dynamic>> sent;
  late int status;

  PostHogTransport transport({Future<SharedPreferences> Function()? prefs}) =>
      PostHogTransport(
        projectToken: 'phc_test',
        host: 'https://ph.example',
        useHttp: true,
        preferences: prefs,
        httpClient: MockClient((request) async {
          expect(request.url.toString(), 'https://ph.example/capture/');
          sent.add(jsonDecode(request.body) as Map<String, dynamic>);
          return http.Response('{}', status);
        }),
      );

  PendingAnalyticsEvent event(Map<String, Object?> properties) =>
      PendingAnalyticsEvent(
        eventName: 'ui_stall',
        type: PendingAnalyticsEventType.capture,
        properties: properties,
      );

  setUp(() {
    sent = [];
    status = 200;
    SharedPreferences.setMockInitialValues({});
  });

  test('a signed-in till sends its user as distinct_id', () async {
    await transport().send(
      event({'user_id': 'u-7', 'branch_id': 'b1', 'lag_ms': 4200}),
    );

    final body = sent.single;
    expect(body['distinct_id'], 'u-7');
    expect(body['event'], 'ui_stall');
    final props = body['properties'] as Map<String, dynamic>;
    expect(props['lag_ms'], 4200);
    expect(props['device_id'], isA<String>());
    expect(props.containsKey(r'$process_person_profile'), isFalse);
  });

  test('before sign-in the install id is the distinct_id', () async {
    final t = transport();
    await t.send(event({'branch_id': 'b1'}));
    await t.send(event({'user_id': '', 'branch_id': 'b1'}));

    final first = sent[0];
    final props = first['properties'] as Map<String, dynamic>;
    expect(first['distinct_id'], isNotEmpty);
    expect(first['distinct_id'], props['device_id']);
    expect(props[r'$process_person_profile'], isFalse);
    // An empty user id is no user either.
    expect(sent[1]['distinct_id'], first['distinct_id']);
  });

  test('the install id survives a restart', () async {
    await transport().send(event({}));
    await transport().send(event({}));

    expect(sent[0]['distinct_id'], sent[1]['distinct_id']);
    final prefs = await SharedPreferences.getInstance();
    expect(
      prefs.getString(PostHogTransport.deviceIdKey),
      sent[0]['distinct_id'],
    );
  });

  test('unreadable prefs still give every event an id', () async {
    final t = transport(prefs: () async => throw StateError('NUL-filled'));
    await t.send(event({}));
    await t.send(event({}));

    expect(sent[0]['distinct_id'], isNotEmpty);
    expect(sent[1]['distinct_id'], sent[0]['distinct_id']);
  });

  test('sensitive keys are masked on the HTTP path too', () async {
    await transport().send(event({'user_id': 'u-7', 'pin': 1234}));

    final props = sent.single['properties'] as Map<String, dynamic>;
    expect(props['pin'], '[redacted]');
    expect(props['user_id'], 'u-7');
  });

  test('sensitive keys are masked at every depth', () {
    final out = PostHogTransport.redact({
      'context': {
        'branch': 'b1',
        'otp': '123456',
        'gone': null,
        'staff': [
          {'name': 'Ann', 'pin': 4321},
          null,
          'cashier',
        ],
      },
      'card_last4': '4242',
    });

    expect(out, {
      'context': {
        'branch': 'b1',
        'otp': '[redacted]',
        'staff': [
          {'name': 'Ann', 'pin': '[redacted]'},
          'cashier',
        ],
      },
      'card_last4': '[redacted]',
    });
  });

  test('events sent at once share one install id', () async {
    final t = transport();
    await Future.wait([
      t.send(event({})),
      t.send(event({})),
      t.send(event({})),
    ]);

    expect(sent.map((b) => b['distinct_id']).toSet(), hasLength(1));
    final prefs = await SharedPreferences.getInstance();
    expect(
      prefs.getString(PostHogTransport.deviceIdKey),
      sent[0]['distinct_id'],
    );
  });

  test('a rejected capture throws so the event stays queued', () async {
    status = 401;

    await expectLater(
      transport().send(event({'user_id': 'u-7'})),
      throwsA(isA<HttpException>()),
    );
  });

  test('screens go over HTTP with the same id', () async {
    await transport().screen('Books', properties: {'user_id': 'u-7'});

    expect(sent.single['event'], r'$screen');
    expect(sent.single['distinct_id'], 'u-7');
    expect(
      (sent.single['properties'] as Map<String, dynamic>)['screen_name'],
      'Books',
    );
  });

  test('the build stamps its version and commit on every event', () {
    const withRelease = CallbackAnalyticsContextProvider(
      appName: 'flipper',
      platformName: 'windows',
      buildMode: 'release',
      appVersion: '1.605.0.0',
      releaseCommit: '0a9a65f',
    );
    expect(withRelease.buildBaseProperties(), {
      'app': 'flipper',
      'platform': 'windows',
      'build_mode': 'release',
      'app_version': '1.605.0.0',
      'release_commit': '0a9a65f',
    });

    // A local build has neither; empty strings are left out.
    const local = CallbackAnalyticsContextProvider(
      appName: 'flipper',
      platformName: 'macos',
      buildMode: 'debug',
      appVersion: '',
      releaseCommit: '',
    );
    expect(local.buildBaseProperties().containsKey('app_version'), isFalse);
    expect(local.buildBaseProperties().containsKey('release_commit'), isFalse);
  });
}
