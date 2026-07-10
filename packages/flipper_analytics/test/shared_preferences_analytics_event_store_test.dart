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

  test('enqueue preserves events beyond peekBatch limit', () async {
    SharedPreferences.setMockInitialValues({});
    final store = SharedPreferencesAnalyticsEventStore();
    await store.initialize();

    final baseTime = DateTime.utc(2026, 1, 1);
    for (var i = 0; i < 1001; i++) {
      await store.enqueue(
        PendingAnalyticsEvent(
          eventName: 'event_$i',
          type: PendingAnalyticsEventType.capture,
          properties: const {},
          createdAt: baseTime.add(Duration(seconds: i)),
        ),
      );
    }

    final batch = await store.peekBatch(limit: 50);
    expect(batch, hasLength(50));

    final all = await store.peekBatch(limit: 2000);
    expect(all, hasLength(1001));
    expect(all.last.eventName, 'event_1000');
  });
}
