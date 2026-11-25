import 'dart:async';

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
  final List<String> order = [];
  int resetCount = 0;
  Completer<void>? holdIdentify;

  @override
  Future<void> captureException(
    Object error, {
    StackTrace? stackTrace,
    Map<String, Object?> properties = const {},
  }) async {
    if (failCapture) throw StateError('sdk down');
    exceptions.add((error, properties));
    order.add('exception');
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
    order.add('group:$groupType');
  }

  @override
  Future<void> identify(
    String userId, {
    Map<String, Object?> properties = const {},
  }) async {
    final hold = holdIdentify;
    if (hold != null) await hold.future;
    if (failIdentify) throw StateError('sdk down');
    identified.add(userId);
    order.add('identify');
    identifyProperties.add(properties);
  }

  @override
  Future<void> initialize() async {}

  @override
  Future<bool> isFeatureEnabled(String flagKey) async => false;

  @override
  Future<void> reloadFeatureFlags() async {}

  @override
  Future<void> reset() async {
    resetCount++;
    order.add('reset');
  }

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

  group('capture time', () {
    test('an event goes to the SDK at once, stamped by it', () async {
      final store = _MemoryEventStore();
      final transport = _FakeTransport();
      final analytics = OfflineFirstAnalytics(
        contextProvider: _FakeContextProvider(),
        eventStore: store,
        transport: transport,
      );
      await analytics.initialize();

      await analytics.track('ui_stall', properties: const {'lag_ms': 3000});

      expect(store.events, isEmpty);
      final sent = transport.sentEvents.single;
      expect(sent.eventName, 'ui_stall');
      expect(sent.properties['lag_ms'], 3000);
      expect(sent.properties, isNot(contains(AnalyticsProperties.capturedAt)));
      expect(sent.properties, isNot(contains(AnalyticsProperties.queuedMs)));
    });

    test(
      'a replayed event carries when it happened and how long it waited',
      () async {
        final happened = DateTime.utc(2026, 11, 24, 18, 40, 12, 345);
        final store = _MemoryEventStore();
        final transport = _FakeTransport();
        final analytics = OfflineFirstAnalytics(
          contextProvider: _FakeContextProvider(),
          eventStore: store,
          transport: transport,
          clock: () => happened.add(const Duration(minutes: 22)),
        );
        await analytics.initialize();
        await store.enqueue(
          PendingAnalyticsEvent(
            eventName: 'ui_stall',
            type: PendingAnalyticsEventType.capture,
            properties: const {'lag_ms': 99949},
            createdAt: happened,
          ),
        );

        await analytics.flush();

        final sent = transport.sentEvents.single;
        expect(sent.properties['lag_ms'], 99949);
        expect(
          sent.properties[AnalyticsProperties.capturedAt],
          '2026-11-24T18:40:12.345Z',
        );
        expect(sent.properties[AnalyticsProperties.queuedMs], 22 * 60 * 1000);
        expect(store.events, isEmpty);
      },
    );

    test('an event queued by a failed send keeps its own time', () async {
      final store = _MemoryEventStore();
      final transport = _FakeTransport(failSend: true);
      final analytics = OfflineFirstAnalytics(
        contextProvider: _FakeContextProvider(),
        eventStore: store,
        transport: transport,
      );
      await analytics.initialize();
      await analytics.track('offline_sale');
      final queued = store.events.single;

      transport.failSend = false;
      await analytics.flush();

      final sent = transport.sentEvents.single;
      expect(sent.id, queued.id);
      expect(
        DateTime.parse(
          sent.properties[AnalyticsProperties.capturedAt]! as String,
        ),
        queued.createdAt,
      );
      expect(sent.properties[AnalyticsProperties.queuedMs], isA<int>());
    });

    test('a device clock that went back never gives a negative wait', () async {
      final happened = DateTime.utc(2026, 11, 24, 12);
      final store = _MemoryEventStore();
      final transport = _FakeTransport();
      final analytics = OfflineFirstAnalytics(
        contextProvider: _FakeContextProvider(),
        eventStore: store,
        transport: transport,
        clock: () => happened.subtract(const Duration(hours: 1)),
      );
      await analytics.initialize();
      await store.enqueue(
        PendingAnalyticsEvent(
          eventName: r'$screen',
          type: PendingAnalyticsEventType.screen,
          properties: const {'screen_name': 'Pos'},
          createdAt: happened,
        ),
      );

      await analytics.flush();

      final sent = transport.sentEvents.single;
      expect(sent.type, PendingAnalyticsEventType.screen);
      expect(sent.properties['screen_name'], 'Pos');
      expect(sent.properties[AnalyticsProperties.queuedMs], 0);
    });

    test('a replay that fails stays queued as it was', () async {
      final happened = DateTime.utc(2026, 11, 24, 12);
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
          eventName: 'ui_stall',
          type: PendingAnalyticsEventType.capture,
          properties: const {'lag_ms': 2500},
          createdAt: happened,
        ),
      );

      await analytics.flush();

      final kept = store.events.single;
      expect(kept.attemptCount, 1);
      expect(kept.createdAt, happened);
      expect(kept.properties, {'lag_ms': 2500});
    });
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

    test(
      'an exception as the first event is identified and grouped first',
      () async {
        await start();

        await analytics.captureException(StateError('startup failed'));

        expect(transport.order, [
          'identify',
          'group:business',
          'group:branch',
          'exception',
        ]);
      },
    );

    test('a failed identify is retried on the next event, and does not skip '
        'the groups', () async {
      await start();
      transport.failIdentify = true;

      await analytics.track('first');
      expect(transport.identified, isEmpty);
      expect(transport.groups, hasLength(2));

      transport.failIdentify = false;
      await analytics.track('second');
      await analytics.track('third');

      expect(transport.identified, ['user-1']);
      expect(transport.groups, hasLength(2));
    });

    test(
      'a sync queued before reset never applies to the new session',
      () async {
        await start();
        transport.holdIdentify = Completer<void>();
        final oldEvent = analytics.track('old_session');

        await analytics.reset();
        transport.holdIdentify!.complete();
        transport.holdIdentify = null;
        await oldEvent;
        context
          ..userId = 'user-2'
          ..businessId = 'business-2'
          ..branchId = 'branch-2';
        await analytics.track('new_session');

        expect(transport.identified, ['user-2']);
        expect(transport.groups.map(_describe), [
          'business=business-2 {}',
          'branch=branch-2 {business_id: business-2}',
        ]);
      },
    );

    test('a branch that goes away is not left registered', () async {
      await start();
      await analytics.track('with_branch');

      context
        ..businessId = 'business-2'
        ..branchId = null;
      await analytics.track('no_branch_yet');

      expect(transport.resetCount, 1);
      expect(transport.order.skip(3), ['reset', 'identify', 'group:business']);
      expect(transport.identified, ['user-1', 'user-1']);
      expect(transport.sentEvents.last.properties[r'$groups'], {
        'business': 'business-2',
      });

      await analytics.track('still_no_branch');
      expect(transport.resetCount, 1);
    });

    test(
      'a failed explicit identify is synced again on the next event',
      () async {
        await start();
        transport.failIdentify = true;
        await expectLater(analytics.identify('user-1'), throwsStateError);
        await expectLater(analytics.group('business', 'business-1'), completes);

        transport.failIdentify = false;
        await analytics.track('next');

        expect(transport.identified, ['user-1']);
        // The explicit business group succeeded, so only the branch is new.
        expect(transport.groups.map(_describe).skip(1), [
          'branch=branch-1 {business_id: business-1}',
        ]);
      },
    );

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
