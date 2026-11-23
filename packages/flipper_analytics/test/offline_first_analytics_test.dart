import 'package:flipper_analytics/flipper_analytics.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeContextProvider implements AnalyticsContextProvider {
  _FakeContextProvider({
    this.userId = 'user-1',
    this.businessId = 'business-1',
    this.branchId = 'branch-1',
  });

  @override
  String? branchId;

  @override
  String? businessId;

  @override
  String? userId;

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
  final List<Map<String, Object?>> identifyProperties = [];
  final List<(String, String, Map<String, Object?>)> groups = [];
  bool failIdentify = false;
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
  }) async {
    groups.add((groupType, groupKey, properties));
  }

  @override
  Future<void> identify(
    String userId, {
    Map<String, Object?> properties = const {},
  }) async {
    if (failIdentify) throw StateError('sdk down');
    identified.add(userId);
    identifyProperties.add(properties);
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

String _describe((String, String, Map<String, Object?>) call) =>
    '${call.$1}=${call.$2} ${call.$3}';

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

  group(r'$groups', () {
    late _MemoryEventStore store;
    late _FakeTransport transport;
    late _FakeContextProvider context;
    late OfflineFirstAnalytics analytics;

    Future<void> start({
      String? userId = 'user-1',
      String? businessId = 'business-1',
      String? branchId = 'branch-1',
    }) async {
      store = _MemoryEventStore();
      transport = _FakeTransport();
      context = _FakeContextProvider(
        userId: userId,
        businessId: businessId,
        branchId: branchId,
      );
      analytics = OfflineFirstAnalytics(
        contextProvider: context,
        eventStore: store,
        transport: transport,
      );
      await analytics.initialize();
    }

    test('every event carries its business and branch', () async {
      await start();

      await analytics.track(AnalyticsEvents.productActive);
      await analytics.screen('Pos');
      await analytics.captureException(StateError('boom'));

      const expected = {'business': 'business-1', 'branch': 'branch-1'};
      expect(transport.sentEvents, hasLength(2));
      for (final event in transport.sentEvents) {
        expect(event.properties[r'$groups'], expected);
      }
      expect(transport.exceptions.single.$2[r'$groups'], expected);
    });

    test('a restored session is identified and grouped once, before its '
        'first event', () async {
      await start();

      await analytics.track(AnalyticsEvents.productActive);
      await analytics.track('ui_stall');
      await analytics.flush();

      expect(transport.identified, ['user-1']);
      // No person properties, so the SDK skips a repeat identify.
      expect(transport.identifyProperties.single, isEmpty);
      expect(transport.groups.map(_describe), [
        'business=business-1 {}',
        'branch=branch-1 {business_id: business-1}',
      ]);
    });

    test('no business or branch, no groups', () async {
      await start(userId: null, businessId: null, branchId: '  ');

      await analytics.track(AnalyticsEvents.productActive);

      expect(
        transport.sentEvents.single.properties.containsKey(r'$groups'),
        isFalse,
      );
      expect(transport.groups, isEmpty);
      expect(transport.identified, isEmpty);
    });

    test('a business switch regroups the next events', () async {
      await start();
      await analytics.track('before_switch');

      context
        ..businessId = 'business-2'
        ..branchId = 'branch-9';
      await analytics.track('after_switch');

      expect(transport.sentEvents.first.properties[r'$groups'], {
        'business': 'business-1',
        'branch': 'branch-1',
      });
      expect(transport.sentEvents.last.properties[r'$groups'], {
        'business': 'business-2',
        'branch': 'branch-9',
      });
      expect(transport.groups.skip(2).map(_describe), [
        'business=business-2 {}',
        'branch=branch-9 {business_id: business-2}',
      ]);
      expect(transport.identified, ['user-1']);
    });

    test('a queued event keeps the groups of when it happened', () async {
      await start();
      transport.failSend = true;
      await analytics.track('offline_sale');
      expect(store.events, hasLength(1));

      context.businessId = 'business-2';
      transport.failSend = false;
      await analytics.flush();

      expect(transport.sentEvents.single.eventName, 'offline_sale');
      expect(transport.sentEvents.single.properties[r'$groups'], {
        'business': 'business-1',
        'branch': 'branch-1',
      });
      // The SDK itself moves on to the business the till is on now.
      expect(transport.groups.last.$2, 'business-2');
    });

    test('a queued event survives the store round trip with its groups', () {
      final event = PendingAnalyticsEvent(
        eventName: 'offline_sale',
        type: PendingAnalyticsEventType.capture,
        properties: const {
          r'$groups': {'business': 'business-1', 'branch': 'branch-1'},
        },
      );

      final fromDb = PendingAnalyticsEvent.fromDbMap(event.toDbMap());
      final fromJson = PendingAnalyticsEvent.fromJson(event.toJson());

      for (final restored in [fromDb, fromJson]) {
        expect(restored.properties[r'$groups'], {
          'business': 'business-1',
          'branch': 'branch-1',
        });
      }
    });

    test('sign-in grouping is not repeated, and reset starts over', () async {
      await start();
      await identifySession(
        analytics,
        source: 'login_choices',
        userId: 'user-1',
        businessId: 'business-1',
        branchId: 'branch-1',
      );
      await analytics.track(AnalyticsEvents.loginSuccess);

      expect(transport.identified, ['user-1']);
      expect(transport.groups, hasLength(2));
      // Person and group properties never get a `$groups` of their own.
      expect(
        transport.identifyProperties.single.containsKey(r'$groups'),
        isFalse,
      );
      expect(transport.groups.first.$3.containsKey(r'$groups'), isFalse);

      await analytics.reset();
      await analytics.track(AnalyticsEvents.productActive);

      expect(transport.identified, ['user-1', 'user-1']);
      expect(transport.groups, hasLength(4));
    });

    test('a failing SDK call still sends the event', () async {
      await start();
      transport.failIdentify = true;

      await analytics.track(AnalyticsEvents.productActive);

      expect(transport.sentEvents.single.eventName, 'product_active');
    });

    test('local mode groups nothing', () async {
      store = _MemoryEventStore();
      transport = _FakeTransport();
      analytics = OfflineFirstAnalytics(
        contextProvider: _FakeContextProvider(),
        eventStore: store,
        transport: transport,
        enabled: false,
      );

      await analytics.track(AnalyticsEvents.productActive);
      await analytics.flush();

      expect(transport.groups, isEmpty);
      expect(transport.identified, isEmpty);
    });
  });
}
