import 'package:flipper_analytics/flipper_analytics.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('shared preferences store persists and reloads events', () async {
    SharedPreferences.setMockInitialValues({});
    final store = SharedPreferencesAnalyticsEventStore();
    await store.initialize();

    final event = PendingAnalyticsEvent(
      eventName: AnalyticsEvents.loginSuccess,
      type: PendingAnalyticsEventType.capture,
      properties: const {'source': 'test'},
    );

    await store.enqueue(event);
    final reloaded = await store.peekBatch(limit: 10);

    expect(reloaded, hasLength(1));
    expect(reloaded.single.eventName, AnalyticsEvents.loginSuccess);
    expect(reloaded.single.properties['source'], 'test');
  });
}
