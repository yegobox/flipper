import 'package:flipper_analytics/flipper_analytics.dart';
import 'package:flutter_test/flutter_test.dart';

class _Recorder implements ProductAnalytics {
  _Recorder({this.fail = false});

  final bool fail;
  final captured = <(Object, StackTrace?, Map<String, Object?>)>[];

  @override
  Future<void> captureException(
    Object error, {
    StackTrace? stackTrace,
    Map<String, Object?> properties = const {},
  }) async {
    if (fail) throw StateError('sdk down');
    captured.add((error, stackTrace, properties));
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  test('sends the error with where it was caught', () async {
    final analytics = _Recorder();
    final stack = StackTrace.current;

    reportException(
      FormatException('bad prefs'),
      stack,
      type: 'flutter_error',
      properties: {'library': 'widgets'},
      analytics: analytics,
    );
    await Future<void>.delayed(Duration.zero);

    final (error, trace, props) = analytics.captured.single;
    expect(error, isA<FormatException>());
    expect(trace, stack);
    expect(props, {'library': 'widgets', 'error_type': 'flutter_error'});
  });

  test('no type, no error_type', () async {
    final analytics = _Recorder();

    reportException(StateError('x'), null, analytics: analytics);
    await Future<void>.delayed(Duration.zero);

    expect(analytics.captured.single.$3, isEmpty);
  });

  test('a failing SDK never reaches the error handler', () async {
    reportException(StateError('x'), null, analytics: _Recorder(fail: true));
    await Future<void>.delayed(Duration.zero);
  });

  group('before analytics has started', () {
    setUp(debugClearEarlyExceptions);
    tearDown(debugClearEarlyExceptions);

    test('reports are held, then sent once it starts', () async {
      expect(FlipperAnalytics.maybeInstance, isNull);
      reportException(StateError('db'), null, type: 'init_step_failed');
      expect(earlyExceptionCount, 1);

      final analytics = _Recorder();
      flushEarlyExceptions(analytics);
      await Future<void>.delayed(Duration.zero);

      expect(earlyExceptionCount, 0);
      final (error, _, props) = analytics.captured.single;
      expect(error, isA<StateError>());
      expect(props, {
        'error_type': 'init_step_failed',
        'reported_before_analytics': true,
      });
    });

    test('only the first few are held', () {
      for (var i = 0; i < maxEarlyExceptions + 5; i++) {
        reportException(StateError('$i'), null);
      }
      expect(earlyExceptionCount, maxEarlyExceptions);
    });
  });
}
