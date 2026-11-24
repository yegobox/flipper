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
    return const {'app': 'test_app', 'platform': 'test'};
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
  final List<bool> enabledCalls = [];
  final List<String> identified = [];
  final List<(Object, Map<String, Object?>)> exceptions = [];
  bool failCapture = false;
  int flushCount = 0;

  @override
  Future<void> captureException(
    Object error, {
    StackTrace? stackTrace,
    Map<String, Object?> properties = const {},
  }) async {
    if (failCapture) throw StateError('sdk down');
    exceptions.add((error, properties));
  }

  @override
  Future<void> setEnabled(bool enabled) async {
    enabledCalls.add(enabled);
  }

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
  }) async {
    identified.add(userId);
  }

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

  group('local mode (disabled)', () {
    late _MemoryEventStore store;
    late _FakeTransport transport;
    late OfflineFirstAnalytics analytics;

    setUp(() async {
      store = _MemoryEventStore();
      transport = _FakeTransport();
      analytics = OfflineFirstAnalytics(
        contextProvider: _FakeContextProvider(),
        eventStore: store,
        transport: transport,
        enabled: false,
      );
      await analytics.initialize();
    });

    test('startup states the opt-out to the SDK', () {
      expect(transport.enabledCalls, [false]);
    });

    test('drops events instead of queueing them', () async {
      await analytics.track(AnalyticsEvents.loginSuccess);
      await analytics.screen('Pos');
      await analytics.identify('42');
      await analytics.group('business', 'b-1');
      await store.enqueue(
        PendingAnalyticsEvent(
          eventName: 'queued_before',
          type: PendingAnalyticsEventType.capture,
          properties: const {},
        ),
      );
      await analytics.flush();

      expect(transport.sentEvents, isEmpty);
      expect(transport.identified, isEmpty);
      expect(transport.flushCount, 0);
      expect(store.events, hasLength(1));
    });

    test('opting back in sends again', () async {
      await analytics.setEnabled(true);
      await analytics.setEnabled(true);
      await analytics.track(AnalyticsEvents.loginSuccess);

      expect(transport.enabledCalls, [false, true]);
      expect(analytics.enabled, isTrue);
      expect(transport.sentEvents.single.eventName, 'login_success');
    });
  });

  test('a signed-in till applies its enabled state at startup', () async {
    final transport = _FakeTransport();
    await OfflineFirstAnalytics(
      contextProvider: _FakeContextProvider(),
      eventStore: _MemoryEventStore(),
      transport: transport,
    ).initialize();

    expect(transport.enabledCalls, [true]);
  });

  test('flush drops an event that keeps failing', () async {
    final store = _MemoryEventStore();
    final transport = _FakeTransport(failSend: true);
    final analytics = OfflineFirstAnalytics(
      contextProvider: _FakeContextProvider(),
      eventStore: store,
      transport: transport,
    );
    await analytics.initialize();
    await store.enqueue(
      PendingAnalyticsEvent(
        eventName: 'never_accepted',
        type: PendingAnalyticsEventType.capture,
        properties: const {},
      ),
    );

    for (var i = 0; i < OfflineFirstAnalytics.maxSendAttempts; i++) {
      await analytics.flush();
    }
    expect(
      store.events.single.attemptCount,
      OfflineFirstAnalytics.maxSendAttempts,
    );

    await analytics.flush();
    expect(store.events, isEmpty);
  });

  group('captureException', () {
    test('tags the error like any event', () async {
      final transport = _FakeTransport();
      final analytics = OfflineFirstAnalytics(
        contextProvider: _FakeContextProvider(),
        eventStore: _MemoryEventStore(),
        transport: transport,
      );

      await analytics.captureException(
        StateError('boom'),
        properties: const {'error_type': 'caught'},
      );

      final (error, props) = transport.exceptions.single;
      expect(error, isA<StateError>());
      expect(props['app'], 'test_app');
      expect(props['error_type'], 'caught');
    });

    test('never throws, even when the SDK does', () async {
      final transport = _FakeTransport()..failCapture = true;
      final analytics = OfflineFirstAnalytics(
        contextProvider: _FakeContextProvider(),
        eventStore: _MemoryEventStore(),
        transport: transport,
      );

      await analytics.captureException(StateError('boom'));
    });

    test('sends nothing in local mode', () async {
      final transport = _FakeTransport();
      final analytics = OfflineFirstAnalytics(
        contextProvider: _FakeContextProvider(),
        eventStore: _MemoryEventStore(),
        transport: transport,
        enabled: false,
      );

      await analytics.captureException(StateError('boom'));

      expect(transport.exceptions, isEmpty);
    });
  });
}
