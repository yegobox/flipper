import 'package:flipper_analytics/flipper_analytics.dart';
import 'package:flipper_services/GlobalLogError.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

// flutter test test/global_error_handler_posthog_test.dart
//
// Errors reach PostHog error tracking from behind the repeat filter, so a
// latched per-frame assertion is sent a few times, not once per frame.

class _Recorder implements ProductAnalytics {
  final captured = <(Object, Map<String, Object?>)>[];

  @override
  Future<void> captureException(
    Object error, {
    StackTrace? stackTrace,
    Map<String, Object?> properties = const {},
  }) async {
    captured.add((error, properties));
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  late _Recorder posthog;

  setUp(() {
    GlobalErrorHandler.resetReportTallies();
    posthog = _Recorder();
    GlobalErrorHandler.analyticsOverride = posthog;
  });

  tearDown(() => GlobalErrorHandler.analyticsOverride = null);

  Future<void> settle() => Future<void>.delayed(Duration.zero);

  test('a caught error goes out with its type and tags, not extra', () async {
    await GlobalErrorHandler.logError(
      StateError('sync failed'),
      stackTrace: StackTrace.current,
      type: 'caught',
      tags: {'feature': 'sync'},
      extra: {'phone': '0788000000'},
    );
    await settle();

    final (error, props) = posthog.captured.single;
    expect(error, isA<StateError>());
    expect(props, {'feature': 'sync', 'error_type': 'caught'});
  });

  test('an error repeating in a loop is sent only a few times', () async {
    final stack = StackTrace.fromString('#0 loop\n#1 tick');
    for (var i = 0; i < 10; i++) {
      await GlobalErrorHandler.logError(StateError('same'), stackTrace: stack);
    }
    await settle();

    expect(posthog.captured, hasLength(3));
    expect(posthog.captured.first.$2['error_type'], 'manual');
  });

  test('framework and platform errors go through the same filter', () async {
    final flutterOnError = FlutterError.onError;
    final platformOnError = PlatformDispatcher.instance.onError;
    addTearDown(() {
      FlutterError.onError = flutterOnError;
      PlatformDispatcher.instance.onError = platformOnError;
    });
    GlobalErrorHandler.initialize();

    final details = FlutterErrorDetails(
      exception: AssertionError('!_debugDuringDeviceUpdate'),
      stack: StackTrace.fromString(
        '#0      MouseTracker._deviceUpdatePhase '
        '(package:flutter/src/rendering/mouse_tracker.dart:240:5)',
      ),
      library: 'gestures library',
    );
    for (var i = 0; i < 5; i++) {
      FlutterError.onError!(details);
    }
    final handled = PlatformDispatcher.instance.onError!(
      const FormatException('bad json'),
      StackTrace.fromString('#0 decode'),
    );
    await settle();

    expect(handled, isTrue);
    expect(posthog.captured, hasLength(4));
    expect(posthog.captured.first.$2, {
      'library': 'gestures library',
      'error_type': 'flutter_error',
    });
    expect(posthog.captured.last.$1, isA<FormatException>());
    expect(posthog.captured.last.$2, {'error_type': 'platform_error'});
  });
}
