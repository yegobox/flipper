import 'dart:async';

import 'package:flipper_models/sync/ditto_observer_registry.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_models/brick/models/counter.model.dart';
import 'package:supabase_models/sync/ditto_sync_adapter.dart';
import 'package:supabase_models/sync/ditto_sync_coordinator.dart';

// flutter test test/ditto_sync_coordinator_observer_test.dart
//
// The coordinator's per-adapter live observers are long-lived and watch busy
// collections, so they go through registerTrackedObserver: counted per call
// site, slow callbacks named, and the unread `changes` stream drained.

class _FakeObserver {
  final results = StreamController<dynamic>();
  Stream<dynamic> get changes => results.stream;
  bool cancelled = false;
  void cancel() => cancelled = true;
}

class _FakeStore {
  final registered = <(String, Map<String, dynamic>)>[];
  final observer = _FakeObserver();

  _FakeObserver registerObserver(
    String query, {
    Map<String, dynamic> arguments = const {},
    void Function(dynamic)? onChange,
  }) {
    registered.add((query, arguments));
    return observer;
  }

  Future<dynamic> execute(
    String query, {
    Map<String, dynamic> arguments = const {},
  }) async =>
      throw StateError('no local data in this test');
}

class _FakeSync {
  dynamic registerSubscription(
    String query, {
    Map<String, dynamic> arguments = const {},
  }) =>
      throw StateError('no sync in this test');
}

class _FakeDitto {
  final store = _FakeStore();
  final sync = _FakeSync();
}

class _CounterAdapter extends DittoSyncAdapter<Counter> {
  @override
  String get collectionName => 'counters';

  @override
  Future<DittoSyncQuery?> buildObserverQuery() async => const DittoSyncQuery(
        query: 'SELECT * FROM counters WHERE branchId = :branchId',
        arguments: {'branchId': 'branch-1'},
      );

  @override
  Future<Map<String, dynamic>> toDittoDocument(Counter model) async => {};

  @override
  Future<Counter?> fromDittoDocument(Map<String, dynamic> document) async =>
      null;

  @override
  Future<String?> documentIdForModel(Counter model) async => null;
}

void main() {
  test(
      'an adapter\'s live observer is registered through the tracked '
      'registry and drained', () async {
    final coordinator = DittoSyncCoordinator.instance;
    final ditto = _FakeDitto();
    addTearDown(() async {
      coordinator.debugDittoOverride = null;
      await coordinator.unregisterAdapter<Counter>();
    });

    await coordinator.registerAdapter<Counter>(_CounterAdapter());
    final before = dittoObserverStats.summary();
    coordinator.debugDittoOverride = ditto;

    await coordinator.debugStartObserverFor(Counter);

    final (query, arguments) = ditto.store.registered.single;
    expect(query, 'SELECT * FROM counters WHERE branchId = :branchId');
    expect(arguments, {'branchId': 'branch-1'});
    // Tracked: its results stream is drained, and it is counted per site.
    expect(ditto.store.observer.results.hasListener, isTrue);
    expect(dittoObserverStats.summary(), isNot(before));
    expect(dittoObserverStats.summary(), contains('counters'));
  });

  test('without Ditto no observer is started', () async {
    final coordinator = DittoSyncCoordinator.instance;
    addTearDown(() => coordinator.unregisterAdapter<Counter>());
    coordinator.debugDittoOverride = null;

    await coordinator.registerAdapter<Counter>(_CounterAdapter());
    await coordinator.debugStartObserverFor(Counter);

    expect(coordinator.ditto, isNull);
  });
}
