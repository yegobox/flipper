import 'dart:async';

import 'package:flipper_analytics/flipper_analytics.dart';
import 'package:flipper_analytics/src/web/posthog_js_host.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:posthog_flutter/posthog_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

// flutter test test/posthog_transport_test.dart
//
// Every platform goes through the PostHog SDK, Windows and Linux included
// (posthog_flutter 5.55+). Windows used to post raw HTTP without a
// `distinct_id`, and PostHog silently dropped every one of those events.

class _MockPosthog extends Mock implements Posthog {}

void main() {
  late _MockPosthog posthog;

  setUpAll(() {
    registerFallbackValue(PostHogConfig('phc_fallback'));
  });

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    posthog = _MockPosthog();
    when(() => posthog.setup(any())).thenAnswer((_) async {});
    when(() => posthog.register(any(), any())).thenAnswer((_) async {});
    when(
      () => posthog.capture(
        eventName: any(named: 'eventName'),
        properties: any(named: 'properties'),
      ),
    ).thenAnswer((_) async {});
    when(
      () => posthog.screen(
        screenName: any(named: 'screenName'),
        properties: any(named: 'properties'),
      ),
    ).thenAnswer((_) async {});
    when(() => posthog.optIn()).thenAnswer((_) async {});
    when(() => posthog.optOut()).thenAnswer((_) async {});
    when(() => posthog.reset()).thenAnswer((_) async {});
    when(() => posthog.isOptOut()).thenAnswer((_) async => false);
    when(
      () => posthog.captureException(
        error: any(named: 'error'),
        stackTrace: any(named: 'stackTrace'),
        properties: any(named: 'properties'),
      ),
    ).thenAnswer((_) async {});
  });

  PostHogTransport transport({bool startOptedOut = false}) => PostHogTransport(
    projectToken: 'phc_test',
    host: 'https://ph.example',
    startOptedOut: startOptedOut,
    posthog: posthog,
  );

  PendingAnalyticsEvent event(
    Map<String, Object?> properties, {
    PendingAnalyticsEventType type = PendingAnalyticsEventType.capture,
  }) => PendingAnalyticsEvent(
    eventName: 'ui_stall',
    type: type,
    properties: properties,
  );

  group('config', () {
    test('records replay and leaves push to Flipper\'s own FCM', () {
      final config = transport().buildConfig();

      expect(config.host, 'https://ph.example');
      expect(config.optOut, isFalse);
      expect(config.sessionReplay, isTrue);
      expect(config.sessionReplayConfig.maskAllTexts, isTrue);
      expect(config.sessionReplayConfig.maskAllImages, isTrue);
      expect(config.capturePushNotificationSubscriptions, isFalse);
      expect(config.capturePushNotificationOpened, isFalse);
    });

    test('records NDK crashes, but leaves Dart errors to the app handler', () {
      final errors = transport().buildConfig().errorTrackingConfig;

      expect(errors.captureNativeCrashes, isTrue);
      expect(errors.captureFlutterErrors, isFalse);
      expect(errors.capturePlatformDispatcherErrors, isFalse);
      expect(errors.captureIsolateErrors, isFalse);
    });

    test('a local-mode till starts opted out, with no replay', () {
      final config = transport(startOptedOut: true).buildConfig();

      expect(config.optOut, isTrue);
      expect(config.sessionReplay, isFalse);
    });
  });

  group('initialize', () {
    test('sets the SDK up once and tags events with this install', () async {
      final t = transport();
      await t.initialize();
      await t.initialize();

      verify(() => posthog.setup(any())).called(1);
      final id = verify(
        () => posthog.register('device_id', captureAny()),
      ).captured.single;
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString(PostHogTransport.deviceIdKey), id);
    });

    test('keeps the install id a till already has', () async {
      SharedPreferences.setMockInitialValues({
        PostHogTransport.deviceIdKey: 'till-7',
      });

      await transport().initialize();

      verify(() => posthog.register('device_id', 'till-7')).called(1);
    });

    test('unreadable prefs still tag events', () async {
      final t = PostHogTransport(
        projectToken: 'phc_test',
        host: 'https://ph.example',
        posthog: posthog,
        preferences: () async => throw StateError('NUL-filled prefs'),
      );

      await t.initialize();

      verify(() => posthog.register('device_id', any())).called(1);
    });
  });

  group('send', () {
    test('captures an event without its null properties', () async {
      await transport().send(event({'lag_ms': 4200, 'screen': null}));

      verify(
        () => posthog.capture(
          eventName: 'ui_stall',
          properties: {'lag_ms': 4200},
        ),
      ).called(1);
    });

    test('hands the event\'s groups to the SDK untouched', () async {
      const groups = {'business': 'business-1', 'branch': 'branch-1'};
      await transport().send(event({r'$groups': groups, 'lag_ms': 4200}));

      verify(
        () => posthog.capture(
          eventName: 'ui_stall',
          properties: {r'$groups': groups, 'lag_ms': 4200},
        ),
      ).called(1);
      expect(PostHogTransport.redact({r'$groups': groups}), {
        r'$groups': groups,
      });
    });

    test('a queued screen view goes out as a screen', () async {
      await transport().send(
        event({
          'screen_name': 'Pos',
          'app': 'flipper',
        }, type: PendingAnalyticsEventType.screen),
      );

      verify(
        () => posthog.screen(
          screenName: 'Pos',
          properties: {'screen_name': 'Pos', 'app': 'flipper'},
        ),
      ).called(1);
    });
  });

  group('setEnabled', () {
    test('opts out only when not already out', () async {
      final t = transport();

      await t.setEnabled(false);
      verify(() => posthog.optOut()).called(1);

      when(() => posthog.isOptOut()).thenAnswer((_) async => true);
      await t.setEnabled(false);
      verifyNever(() => posthog.optOut());
    });

    test('opts back in after local mode, and only then', () async {
      final t = transport();

      await t.setEnabled(true);
      verifyNever(() => posthog.optIn());

      when(() => posthog.isOptOut()).thenAnswer((_) async => true);
      await t.setEnabled(true);
      verify(() => posthog.optIn()).called(1);
    });
  });

  test('reset keeps tagging events with this install', () async {
    final t = transport();
    await t.initialize();
    clearInteractions(posthog);

    await t.reset();

    verify(() => posthog.reset()).called(1);
    verify(() => posthog.register('device_id', any())).called(1);
  });

  group('redact', () {
    test('masks secrets by whole word', () {
      for (final key in [
        'pin',
        'user_pin',
        'pinCode',
        'otp',
        'otp_code',
        'password',
        'newPassword',
        'tin',
        'tin_number',
        'card_number',
        'cardNumber',
        'cvv',
        'client-secret',
      ]) {
        expect(PostHogTransport.isSensitiveKey(key), isTrue, reason: key);
      }
    });

    test('leaves words that only contain a secret word alone', () {
      for (final key in [
        'pin_user_id',
        'pinUserId',
        'card_id',
        'printer',
        'setting',
        'discard',
        'continent',
        'shipping',
        'business_id',
        'lag_ms',
        r'$groups',
        '',
      ]) {
        expect(PostHogTransport.isSensitiveKey(key), isFalse, reason: key);
      }
    });

    test('replaces only the sensitive values', () {
      expect(
        PostHogTransport.redact({'pin': '1234', 'printer': 'P70E', 'n': 2}),
        {'pin': '[redacted]', 'printer': 'P70E', 'n': 2},
      );
    });
  });

  group('web', () {
    test('posthog-js does the setup; the install is still tagged', () async {
      final t = PostHogTransport(
        projectToken: 'phc_test',
        host: 'https://ph.example',
        posthog: posthog,
        isWeb: true,
        loadWeb: () async => true,
        webReady: () => true,
      );

      await t.initialize();
      expect(await t.ready, isTrue);
      await t.send(event({'n': 1}));

      verifyNever(() => posthog.setup(any()));
      verify(() => posthog.register('device_id', any())).called(1);
      verify(
        () => posthog.capture(eventName: 'ui_stall', properties: {'n': 1}),
      ).called(1);
    });

    group('before posthog-js has loaded', () {
      late Completer<bool> load;
      late bool loaded;
      late List<String> calls;
      late PostHogTransport t;

      setUp(() {
        load = Completer<bool>();
        loaded = false;
        calls = [];
        when(() => posthog.register(any(), any())).thenAnswer((_) async {
          calls.add('register');
        });
        when(
          () => posthog.identify(
            userId: any(named: 'userId'),
            userProperties: any(named: 'userProperties'),
          ),
        ).thenAnswer((_) async => calls.add('identify'));
        when(
          () => posthog.group(
            groupType: any(named: 'groupType'),
            groupKey: any(named: 'groupKey'),
            groupProperties: any(named: 'groupProperties'),
          ),
        ).thenAnswer((_) async => calls.add('group'));
        when(() => posthog.isOptOut()).thenAnswer((_) async => true);
        when(() => posthog.optIn()).thenAnswer((_) async => calls.add('optIn'));
        t = PostHogTransport(
          projectToken: 'phc_test',
          host: 'https://ph.example',
          posthog: posthog,
          isWeb: true,
          loadWeb: () => load.future,
          webReady: () => loaded,
        );
      });

      test('startup and login return at once instead of waiting', () async {
        await t.initialize();
        await t.setEnabled(true);
        await t.identify('42');
        await t.group('business', 'b-1');

        expect(calls, isEmpty);
      });

      test('queued calls run in order once it loads, install first', () async {
        await t.setEnabled(true);
        await t.identify('42');
        await t.group('business', 'b-1');

        loaded = true;
        load.complete(true);
        await pumpEventQueue();

        expect(calls, ['register', 'optIn', 'identify', 'group']);
      });

      test('a failed load keeps the queued calls for the next load', () async {
        final loads = [Completer<bool>(), Completer<bool>()];
        var attempt = 0;
        final retrying = PostHogTransport(
          projectToken: 'phc_test',
          host: 'https://ph.example',
          posthog: posthog,
          isWeb: true,
          loadWeb: () => loads[attempt++].future,
          webReady: () => loaded,
        );

        await retrying.identify('42');
        loads[0].complete(false);
        await pumpEventQueue();
        expect(calls, isEmpty);

        await retrying.group('business', 'b-1');
        loaded = true;
        loads[1].complete(true);
        await pumpEventQueue();

        expect(calls, ['register', 'identify', 'group']);
      });

      test('only the newest calls wait when nothing ever loads', () async {
        final never = PostHogTransport(
          projectToken: 'phc_test',
          host: 'https://ph.example',
          posthog: posthog,
          isWeb: true,
          loadWeb: () async => false,
          webReady: () => loaded,
        );
        for (var i = 0; i < PostHogTransport.maxQueuedWebCalls + 5; i++) {
          await never.identify('$i');
        }
        await pumpEventQueue();

        loaded = true;
        await never.identify('last');
        await pumpEventQueue();

        expect(
          calls.where((c) => c == 'identify'),
          hasLength(PostHogTransport.maxQueuedWebCalls),
        );
      });

      test('sends wait in the offline queue until it loads', () async {
        await expectLater(t.send(event({'n': 1})), throwsStateError);
      });
    });

    test('the bundle comes from the assets host', () {
      expect(
        assetsHostFor('https://us.i.posthog.com'),
        'https://us-assets.i.posthog.com/static/array.full.js',
      );
      expect(
        assetsHostFor('https://eu.i.posthog.com/'),
        'https://eu-assets.i.posthog.com/static/array.full.js',
      );
      expect(
        assetsHostFor('https://ph.yegobox.com'),
        'https://ph.yegobox.com/static/array.full.js',
      );
    });
  });

  test('captureException hands the error to PostHog', () async {
    final error = StateError('boom');
    final stack = StackTrace.current;

    await transport().captureException(
      error,
      stackTrace: stack,
      properties: {'error_type': 'caught', 'empty': null},
    );

    verify(
      () => posthog.captureException(
        error: error,
        stackTrace: stack,
        properties: {'error_type': 'caught'},
      ),
    ).called(1);
  });

  test('sensitive keys are masked at every depth', () {
    final out = PostHogTransport.redact({
      'context': {
        'branch': 'b1',
        'otp': '123456',
        'gone': null,
        'staff': [
          {'name': 'Ann', 'pin': 4321, 'pin_user_id': 7},
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
          {'name': 'Ann', 'pin': '[redacted]', 'pin_user_id': 7},
          'cashier',
        ],
      },
      'card_last4': '[redacted]',
    });
  });

  test(
    'concurrent tagging shares one install id, even without prefs',
    () async {
      final t = PostHogTransport(
        projectToken: 'phc_test',
        host: 'https://ph.example',
        posthog: posthog,
        preferences: () async => throw StateError('NUL-filled prefs'),
      );

      await Future.wait([t.initialize(), t.reset(), t.reset()]);

      final ids = verify(
        () => posthog.register('device_id', captureAny()),
      ).captured.toSet();
      expect(ids, hasLength(1));
    },
  );

  group('exception text', () {
    test('emails and long numbers are scrubbed, the rest kept', () {
      expect(
        PostHogTransport.scrubText(
          'duplicate key: Key (email)=(ann.b+1@shop.rw) for 0788 123 456, '
          'order 42, card 4242424242424242',
        ),
        'duplicate key: Key (email)=([email]) for [number], '
        'order 42, card [number]',
      );
    });

    test('each exception message in an event is scrubbed', () {
      final out = PostHogTransport.scrubExceptions({
        r'$exception_list': [
          {'type': 'PostgrestException', 'value': 'call +250788123456'},
          {'type': 'StateError', 'value': 'boom'},
          'not a map',
        ],
        'error_type': 'caught',
      });

      expect(out[r'$exception_list'], [
        {'type': 'PostgrestException', 'value': 'call [number]'},
        {'type': 'StateError', 'value': 'boom'},
        'not a map',
      ]);
      expect(out['error_type'], 'caught');
    });

    test('events without exceptions pass through', () {
      expect(PostHogTransport.scrubExceptions({'n': 1}), {'n': 1});
    });

    test('on web the message is scrubbed before posthog-js sees it', () async {
      final t = PostHogTransport(
        projectToken: 'phc_test',
        host: 'https://ph.example',
        posthog: posthog,
        isWeb: true,
        loadWeb: () async => true,
        webReady: () => true,
      );

      await t.captureException(StateError('mail ann@shop.rw'));

      final sent = verify(
        () => posthog.captureException(
          error: captureAny(named: 'error'),
          stackTrace: any(named: 'stackTrace'),
          properties: any(named: 'properties'),
        ),
      ).captured.single;
      expect(sent, isA<ScrubbedError>());
      expect(sent.toString(), 'Bad state: mail [email]');
    });
  });

  test('web loads nothing without a real project token', () async {
    var loads = 0;
    final t = PostHogTransport(
      projectToken: 'ci-fixture-postHogProjectToken',
      host: 'https://ph.example',
      posthog: posthog,
      isWeb: true,
      loadWeb: () async {
        loads++;
        return true;
      },
      webReady: () => false,
    );

    expect(t.hasProjectToken, isFalse);
    expect(await t.ready, isFalse);
    await t.identify('42');
    await pumpEventQueue();

    expect(loads, 0);
    verifyNever(() => posthog.register(any(), any()));
  });
}
