import 'dart:async';

import 'package:flipper_models/sync/ditto_observer_registry.dart';
import 'package:flipper_web/services/ditto_mixins/challenge_code_mixin.dart';
import 'package:flipper_web/services/ditto_mixins/ditto_core_mixin.dart';
import 'package:flipper_web/services/ditto_mixins/event_mixin.dart';
import 'package:flipper_web/services/ditto_mixins/feature_mixin.dart';
import 'package:flipper_web/services/ditto_mixins/plan_mixin.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

// flutter test test/services/ditto_shared_subscriptions_test.dart
//
// `Ditto` is a final class, so these mixins are driven through
// [DittoCore.dittoHandle] with the in-memory stand-ins below.

class _Subscription {
  bool cancelled = false;
  void cancel() => cancelled = true;
}

class _Sync {
  final registered = <({String dql, Map<String, dynamic>? arguments})>[];

  _Subscription registerSubscription(
    String dql, {
    Map<String, dynamic>? arguments,
  }) {
    registered.add((dql: dql, arguments: arguments));
    return _Subscription();
  }
}

class _Item {
  _Item(this.value);
  final Map<String, dynamic> value;
}

class _Result {
  _Result(this.items);
  final List<_Item> items;
}

class _Observer {
  final _changes = StreamController<_Result>.broadcast();
  bool cancelled = false;

  Stream<_Result> get changes => _changes.stream;

  void cancel() {
    cancelled = true;
    _changes.close();
  }
}

/// Answers each query with the documents whose fields equal its arguments.
class _Store {
  final docs = <String, List<Map<String, dynamic>>>{};
  final observers = <_Observer>[];
  final _live = <void Function()>[];

  /// Re-runs every observer's query, as a sync arriving would.
  void notify() {
    for (final fire in List.of(_live)) {
      fire();
    }
  }

  _Result _query(String dql, Map<String, dynamic>? arguments) {
    final collection = RegExp(r'FROM (\w+)').firstMatch(dql)!.group(1)!;
    final rows = (docs[collection] ?? const []).where(
      (doc) =>
          (arguments ?? const {}).entries.every((a) => doc[a.key] == a.value),
    );
    return _Result([for (final row in rows) _Item(row)]);
  }

  Future<_Result> execute(
    String dql, {
    Map<String, dynamic>? arguments,
  }) async => _query(dql, arguments);

  _Observer registerObserver(
    String dql, {
    Map<String, dynamic>? arguments,
    required void Function(dynamic) onChange,
  }) {
    final observer = _Observer();
    observers.add(observer);
    _live.add(() {
      if (!observer.cancelled) onChange(_query(dql, arguments));
    });
    onChange(_query(dql, arguments));
    return observer;
  }
}

class _Ditto {
  final sync = _Sync();
  final store = _Store();
}

class _Probe extends DittoCore
    with EventMixin, PlanMixin, ChallengeCodeMixin, FeatureMixin {
  _Probe(this.fake);

  final _Ditto? fake;
  bool cloud = false;
  final upserts = <String>[];

  @override
  dynamic get dittoHandle => fake;

  @override
  bool isCloudReady() => cloud;

  @override
  Future<void> executeUpsert(
    String collection,
    String docId,
    Map<String, dynamic> data,
  ) async => upserts.add('cloud:$collection/$docId');

  @override
  Future<void> executeUpsertLocal(
    String collection,
    String docId,
    Map<String, dynamic> data,
  ) async => upserts.add('local:$collection/$docId');
}

/// Use the mixins' own [EventMixin.dittoHandle] / [PlanMixin.dittoHandle].
class _EventsOnly extends DittoCore with EventMixin {}

class _PlanOnly extends DittoCore with PlanMixin {}

class _ChallengeOnly extends DittoCore with ChallengeCodeMixin {}

class _FeatureOnly extends DittoCore with FeatureMixin {}

void main() {
  late DebugPrintCallback previousDebugPrint;

  setUp(() {
    previousDebugPrint = debugPrint;
    debugPrint = (message, {wrapWidth}) {};
  });

  tearDown(() => debugPrint = previousDebugPrint);

  test("each mixin's handle is the Ditto instance, null until one is set", () {
    expect(_EventsOnly().dittoHandle, isNull);
    expect(_PlanOnly().dittoHandle, isNull);
    expect(_ChallengeOnly().dittoHandle, isNull);
    expect(_FeatureOnly().dittoHandle, isNull);
  });

  group('events', () {
    test('saving events registers each subscription once', () async {
      final ditto = _Ditto();
      final probe = _Probe(ditto);

      // A QR login publishes several events on one channel; each save used to
      // register the broad and the channel subscription again.
      for (var i = 0; i < 3; i++) {
        await probe.saveEvent({'channel': 'login-1', 'type': 'x'}, 'e$i');
      }
      probe.cloud = true;
      await probe.saveEvent({'channel': 'login-1'}, 'e3');

      expect(ditto.sync.registered.map((r) => r.dql).toList(), [
        'SELECT * FROM events WHERE channel = :channel',
        'SELECT * FROM events',
      ]);
      expect(ditto.sync.registered.first.arguments, {'channel': 'login-1'});
      expect(probe.upserts, [
        'local:events/e0',
        'local:events/e1',
        'local:events/e2',
        'cloud:events/e3',
      ]);
    });

    test('no Ditto: nothing saved or registered', () async {
      final probe = _Probe(null);

      await probe.saveEvent({'channel': 'login-1'}, 'e0');
      await probe.ensureBroadEventsCloudSubscription();
      await probe.ensureEventsChannelSubscription('login-1');

      expect(probe.upserts, isEmpty);
    });

    test('an empty channel registers nothing', () async {
      final ditto = _Ditto();

      await _Probe(ditto).ensureEventsChannelSubscription('');

      expect(ditto.sync.registered, isEmpty);
    });
  });

  group('payment plan', () {
    test('reads the plan and its addons, subscribing to each once', () async {
      final ditto = _Ditto();
      ditto.store.docs['plans'] = [
        {
          '_id': 'plan-a',
          'businessId': 'biz-plan-a',
          'selectedPlan': 'Mobile',
          'totalPrice': 5000,
        },
      ];
      ditto.store.docs['addons'] = [
        {'_id': 'addon-1', 'planId': 'plan-a', 'addonName': 'Tax'},
        // No id: nothing to match on, so each is its own addon.
        {'planId': 'plan-a', 'addonName': 'Note A'},
        {'planId': 'plan-a', 'addonName': 'Note B'},
      ];
      final probe = _Probe(ditto);

      final plan = await probe.getPaymentPlanFromDitto('biz-plan-a');
      final again = await probe.getPaymentPlanFromDitto('biz-plan-a');

      expect(plan?.id, 'plan-a');
      expect(plan?.selectedPlan, 'Mobile');
      // The catch-up observer and the read both return what is in the store;
      // a document with an id is listed once.
      final names = plan?.addons?.map((a) => a.addonName).toList();
      expect(names?.where((n) => n == 'Tax'), hasLength(1));
      expect(names, containsAll(['Note A', 'Note B']));
      expect(again?.id, 'plan-a');
      expect(again?.addons?.map((a) => a.addonName), [
        'Tax',
        'Note A',
        'Note B',
      ]);
      expect(ditto.sync.registered.map((r) => r.dql).toList(), [
        'SELECT * FROM plans WHERE businessId = :businessId',
        'SELECT * FROM addons WHERE planId = :planId',
      ]);
      // The catch-up observers are opened only the first time, and closed.
      expect(ditto.store.observers, hasLength(2));
      expect(ditto.store.observers.every((o) => o.cancelled), isTrue);
    });

    test('no plan for the business: null', () async {
      final ditto = _Ditto();

      expect(await _Probe(ditto).getPaymentPlanFromDitto('biz-none'), isNull);
      expect(ditto.sync.registered, hasLength(1));
    });

    test('no Ditto: null, nothing registered', () async {
      expect(await _Probe(null).getPaymentPlanFromDitto('biz-x'), isNull);
    });
  });

  group('challenge codes', () {
    test('streams the business codes and closes its observer', () async {
      final ditto = _Ditto();
      ditto.store.docs['challengeCodes'] = [
        {'_id': 'c1', 'businessId': 'biz-1', 'code': 'A'},
        {'_id': 'c2', 'businessId': 'biz-2', 'code': 'B'},
      ];

      final stream = _Probe(
        ditto,
      ).observeChallengeCodes(businessId: 'biz-1', onlyValid: false);
      // A broadcast stream: rows reach whoever listens when Ditto reports.
      final next = stream.first;
      ditto.store.notify();
      final first = await next;

      expect(first.map((c) => c['code']), ['A']);
      await pumpEventQueue();
      expect(ditto.store.observers.single.cancelled, isTrue);
      expect(dittoObserverStats.liveFor('challengeCodes'), 0);
    });

    test('no Ditto: one empty list, no observer', () async {
      expect(await _Probe(null).observeChallengeCodes().toList(), [isEmpty]);
    });
  });

  group('business features', () {
    test('streams the feature row, subscribing once', () async {
      final ditto = _Ditto();
      ditto.store.docs['business_features'] = [
        {
          '_id': 'f1',
          'businessId': 'biz-1',
          'features': ['hr'],
        },
      ];

      final feature = await _Probe(
        ditto,
      ).businessFeatureStream(businessId: 'biz-1').first;

      expect(feature?.features, ['hr']);
      expect(ditto.sync.registered, hasLength(1));
      expect(ditto.sync.registered.single.dql, contains('business_features'));
      await pumpEventQueue();
      expect(ditto.store.observers.single.cancelled, isTrue);
    });

    test('no row for the business: null', () async {
      final ditto = _Ditto();

      expect(
        await _Probe(ditto).businessFeatureStream(businessId: 'biz-x').first,
        isNull,
      );
    });

    test('no Ditto: null, nothing registered', () async {
      expect(
        await _Probe(null).businessFeatureStream(businessId: 'biz-x').toList(),
        [isNull],
      );
    });
  });
}
