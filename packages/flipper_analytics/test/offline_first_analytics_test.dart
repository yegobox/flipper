import 'package:flipper_analytics/flipper_analytics.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeContextProvider implements AnalyticsContextProvider {
  @override
  String? get branchId => 'branch-1';

  @override
  String? get businessId => 'business-1';

  @override
  String? get userId => 'user-1';

  @override
  Map<String, Object?> buildBaseProperties() {
    return const {
      'app': 'test_app',
      'platform': 'test',
    };
  }
}

class _MemoryEventStore implements AnalyticsEventStore {
  final List<PendingAnalyticsEvent> events = [];

  @override
  Future<void> deleteByIds(List<String> ids) async {
    events.removeWhere((event) => ids.contains(event.id));
  }

  @override
  Future<void> enqueue(PendingAnalyticsEvent event) async {
    events.add(event);
  }

  @override
  Future<void> incrementAttempts(String id) async {
    final index = events.indexWhere((event) => event.id == id);
    if (index == -1) return;
    events[index] = events[index].copyWith(
      attemptCount: events[index].attemptCount + 1,
    );
  }

  @override
  Future<void> initialize() async {}

  @override
  Future<List<PendingAnalyticsEvent>> peekBatch({int limit = 50}) async {
    return events.take(limit).toList(growable: false);
  }
}

class _FakeTransport implements AnalyticsTransport {
  _FakeTransport({this.failSend = false});

  bool failSend;
  final List<PendingAnalyticsEvent> sentEvents = [];
  int flushCount = 0;

  @override
  Future<void> flush() async {
    flushCount++;
  }

  @override
  Future<dynamic> getFeatureFlag(String flagKey) async => null;

  @override
  Future<void> group(
    String groupType,
    String groupKey, {
    Map<String, Object?> properties = const {},
  }) async {}

  @override
  Future<void> identify(
    String userId, {
    Map<String, Object?> properties = const {},
  }) async {}

  @override
  Future<void> initialize() async {}

  @override
  Future<bool> isFeatureEnabled(String flagKey) async => false;

  @override
  Future<void> reloadFeatureFlags() async {}

  @override
  Future<void> reset() async {}

  @override
  Future<void> screen(
    String screenName, {
    Map<String, Object?> properties = const {},
  }) async {}

  @override
  Future<void> send(PendingAnalyticsEvent event) async {
    if (failSend) {
      throw Exception('network down');
    }
    sentEvents.add(event);
  }
}

void main() {
  test('queues event when transport send fails', () async {
    final store = _MemoryEventStore();
    final transport = _FakeTransport(failSend: true);
    final analytics = OfflineFirstAnalytics(
      contextProvider: _FakeContextProvider(),
      eventStore: store,
      transport: transport,
    );

    await analytics.initialize();
    await analytics.track(
      AnalyticsEvents.loginSuccess,
      properties: const {'source': 'test'},
    );

    expect(transport.sentEvents, isEmpty);
    expect(store.events, hasLength(1));
    expect(store.events.single.properties['app'], 'test_app');
    expect(store.events.single.properties['source'], 'test');
  });

  test('flush sends pending events and deletes them on success', () async {
    final store = _MemoryEventStore();
    final transport = _FakeTransport();
    final analytics = OfflineFirstAnalytics(
      contextProvider: _FakeContextProvider(),
      eventStore: store,
      transport: transport,
    );

    await analytics.initialize();
    await store.enqueue(
      PendingAnalyticsEvent(
        eventName: AnalyticsEvents.quickSellCompleted,
        type: PendingAnalyticsEventType.capture,
        properties: const {'source': 'queued'},
      ),
    );

    await analytics.flush();

    expect(transport.sentEvents, hasLength(1));
    expect(store.events, isEmpty);
    expect(transport.flushCount, 1);
  });
}
