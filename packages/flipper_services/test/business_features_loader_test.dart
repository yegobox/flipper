import 'dart:async';

import 'package:flipper_services/business_features_loader.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeDitto {
  _FakeDitto(this.name);
  final String name;
}

/// Mirrors DittoService: listeners fire on add with the current instance and
/// on every instance change; dispose() drops them all.
class _FakeDittoHost {
  _FakeDitto? current;
  final listeners = <void Function(_FakeDitto?)>[];

  void add(void Function(_FakeDitto?) l) {
    listeners.add(l);
    l(current);
  }

  void remove(void Function(_FakeDitto?) l) => listeners.remove(l);

  void set(_FakeDitto? ditto) {
    current = ditto;
    for (final l in List.of(listeners)) {
      l(ditto);
    }
  }

  void dispose() => listeners.clear();
}

void main() {
  late _FakeDittoHost host;
  late String? businessId;
  late List<String> features;
  late List<List<String>> emitted; // every onFeatures call, in order
  late List<(String, String)> subscriptions; // (ditto, businessId)
  late Map<String, StreamController<List<String>?>> docs;
  late BusinessFeaturesLoader<_FakeDitto> loader;

  BusinessFeaturesLoader<_FakeDitto> build(List<Duration> retryDelays) =>
      BusinessFeaturesLoader<_FakeDitto>(
        addDittoListener: host.add,
        removeDittoListener: host.remove,
        currentDitto: () => host.current,
        businessId: () => businessId,
        featureStream: (id) {
          subscriptions.add((host.current!.name, id));
          final c = StreamController<List<String>?>();
          docs['${host.current!.name}/$id'] = c;
          return c.stream;
        },
        onFeatures: (f) {
          features = f;
          emitted.add(f);
        },
        isUsableDitto: (d) => !d.name.contains('-login-'),
        retryDelays: retryDelays,
      );

  setUp(() {
    host = _FakeDittoHost();
    businessId = 'biz-1';
    features = ['stale'];
    emitted = [];
    subscriptions = [];
    docs = {};
    loader = build(const [Duration.zero, Duration.zero]);
  });

  test('load before Ditto is ready subscribes once Ditto arrives', () async {
    loader.load();
    expect(subscriptions, isEmpty);
    expect(features, isEmpty);

    host.set(_FakeDitto('main'));
    expect(subscriptions, [('main', 'biz-1')]);

    docs['main/biz-1']!.add(['POS', 'INVENTORY', 'ORDERING']);
    await pumpEventQueue();
    expect(features, ['POS', 'INVENTORY', 'ORDERING']);
  });

  test('repeated load on the same instance and business is a no-op', () {
    host.set(_FakeDitto('main'));
    loader.load();
    loader.load();
    loader.load();
    expect(subscriptions, [('main', 'biz-1')]);
    expect(host.listeners, hasLength(1));
  });

  test('login instance is skipped, real instance replaces it', () {
    host.set(_FakeDitto('device-login-123'));
    loader.load();
    expect(subscriptions, isEmpty);

    host.set(_FakeDitto('main'));
    expect(subscriptions, [('main', 'biz-1')]);
  });

  test('a new Ditto instance moves the subscription', () async {
    host.set(_FakeDitto('a'));
    loader.load();
    host.set(_FakeDitto('b'));
    expect(subscriptions, [('a', 'biz-1'), ('b', 'biz-1')]);
    expect(docs['a/biz-1']!.hasListener, isFalse);
  });

  test('switching business resubscribes', () {
    host.set(_FakeDitto('main'));
    loader.load();
    businessId = 'biz-2';
    loader.load();
    expect(subscriptions, [('main', 'biz-1'), ('main', 'biz-2')]);
  });

  test('Ditto torn down clears features', () async {
    host.set(_FakeDitto('main'));
    loader.load();
    docs['main/biz-1']!.add(['INVENTORY']);
    await pumpEventQueue();
    expect(features, ['INVENTORY']);

    host.set(null);
    expect(features, isEmpty);
  });

  test('load after dispose re-registers the listener', () {
    loader.load();
    host.dispose();
    loader.load();
    host.set(_FakeDitto('main'));
    expect(subscriptions, [('main', 'biz-1')]);
  });

  test('switching business clears the old capabilities immediately', () async {
    host.set(_FakeDitto('main'));
    loader.load();
    docs['main/biz-1']!.add(['INVENTORY', 'ORDERING']);
    await pumpEventQueue();
    expect(features, ['INVENTORY', 'ORDERING']);

    businessId = 'biz-2';
    loader.load();
    expect(features, isEmpty, reason: 'biz-1 apps must not linger');
    expect(docs['main/biz-1']!.hasListener, isFalse);

    docs['main/biz-2']!.add(['POS']);
    await pumpEventQueue();
    expect(features, ['POS']);
  });

  test('null business cancels the subscription and clears', () async {
    host.set(_FakeDitto('main'));
    loader.load();
    docs['main/biz-1']!.add(['INVENTORY']);
    await pumpEventQueue();

    businessId = null;
    loader.load();
    expect(features, isEmpty);
    expect(docs['main/biz-1']!.hasListener, isFalse);
  });

  test(
    'instance swap for the same business keeps features (no flicker)',
    () async {
      host.set(_FakeDitto('a'));
      loader.load();
      docs['a/biz-1']!.add(['INVENTORY']);
      await pumpEventQueue();
      emitted.clear();

      host.set(_FakeDitto('b'));
      expect(subscriptions, [('a', 'biz-1'), ('b', 'biz-1')]);
      expect(emitted, isEmpty, reason: 'same business: nothing cleared');
      expect(features, ['INVENTORY']);
    },
  );

  test('stream error clears features and retries on its own', () async {
    host.set(_FakeDitto('main'));
    loader.load();
    docs['main/biz-1']!.add(['INVENTORY']);
    await pumpEventQueue();

    docs['main/biz-1']!.addError(StateError('boom'));
    await pumpEventQueue();
    expect(subscriptions, [('main', 'biz-1'), ('main', 'biz-1')]);

    docs['main/biz-1']!.add(['INVENTORY']);
    await pumpEventQueue();
    expect(features, ['INVENTORY']);
  });

  test('stream closing on its own (registration failure) retries', () async {
    host.set(_FakeDitto('main'));
    loader.load();
    docs['main/biz-1']!
      ..add(null)
      ..close();
    await pumpEventQueue();
    expect(subscriptions, hasLength(2));
    expect(features, isEmpty);
  });

  test('retries are bounded', () async {
    host.set(_FakeDitto('main'));
    loader.load();
    for (var i = 0; i < 5; i++) {
      final doc = docs['main/biz-1']!;
      if (doc.hasListener) await doc.close();
      await pumpEventQueue();
    }
    // 1 initial + 2 retries (two configured delays), then it gives up.
    expect(subscriptions, hasLength(3));
  });

  test('data resets the retry budget', () async {
    host.set(_FakeDitto('main'));
    loader.load();
    for (var i = 0; i < 4; i++) {
      docs['main/biz-1']!.add(['INVENTORY']);
      await pumpEventQueue();
      await docs['main/biz-1']!.close();
      await pumpEventQueue();
    }
    // Every failure followed a successful emission, so none hit the cap.
    expect(subscriptions, hasLength(5));
  });

  test('a pending retry is cancelled when Ditto goes away', () async {
    loader = build(const [Duration(milliseconds: 20)]);
    host.set(_FakeDitto('main'));
    loader.load();
    docs['main/biz-1']!.addError(StateError('boom'));
    await pumpEventQueue();

    host.set(null); // logout / teardown while the retry is pending
    // A Ditto comes back without notifying (e.g. before listeners re-attach):
    // a leaked retry timer would subscribe on it behind our back.
    host.current = _FakeDitto('main');
    await Future<void>.delayed(const Duration(milliseconds: 60));
    expect(subscriptions, [('main', 'biz-1')]);
    expect(features, isEmpty);
  });

  test('a pending retry is dropped for a business switch', () async {
    loader = build(const [Duration(milliseconds: 20)]);
    host.set(_FakeDitto('main'));
    loader.load();
    docs['main/biz-1']!.addError(StateError('boom'));
    await pumpEventQueue();

    businessId = 'biz-2';
    loader.load();
    await Future<void>.delayed(const Duration(milliseconds: 60));
    expect(subscriptions, [('main', 'biz-1'), ('main', 'biz-2')]);
    expect(docs['main/biz-2']!.hasListener, isTrue);
  });

  test('missing doc yields no features', () async {
    host.set(_FakeDitto('main'));
    loader.load();
    docs['main/biz-1']!.add(null);
    await pumpEventQueue();
    expect(features, isEmpty);
  });
}
