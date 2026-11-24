import 'package:flipper_analytics/flipper_analytics.dart';
import 'package:flutter_test/flutter_test.dart';

class _Recorder implements ProductAnalytics {
  _Recorder({this.fail = false});

  final bool fail;
  final tracked = <(String, Map<String, Object?>)>[];

  @override
  Future<void> track(
    String eventName, {
    Map<String, Object?> properties = const {},
  }) async {
    if (fail) throw StateError('offline');
    tracked.add((eventName, properties));
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  test('one feature_used event names the module and action', () async {
    final analytics = _Recorder();

    trackFeatureUsed(
      'books',
      analytics: analytics,
      properties: {'source': 'app_choice', 'module': 'ignored'},
    );
    await Future<void>.delayed(Duration.zero);

    expect(analytics.tracked.single.$1, 'feature_used');
    expect(analytics.tracked.single.$2, {
      'source': 'app_choice',
      'module': 'books',
      'action': 'open',
    });
  });

  test('a failing send never reaches the caller', () async {
    trackFeatureUsed('pos', action: 'sale', analytics: _Recorder(fail: true));
    await Future<void>.delayed(Duration.zero);
  });

  test('does nothing before analytics has started', () {
    expect(FlipperAnalytics.maybeInstance, isNull);
    trackFeatureUsed('hr');
  });
}
