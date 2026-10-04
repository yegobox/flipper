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
  late List<(String, String)> subscriptions; // (ditto, businessId)
  late Map<String, StreamController<List<String>?>> docs;
  late BusinessFeaturesLoader<_FakeDitto> loader;

  setUp(() {
    host = _FakeDittoHost();
    businessId = 'biz-1';
    features = ['stale'];
    subscriptions = [];
    docs = {};
    loader = BusinessFeaturesLoader<_FakeDitto>(
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
      onFeatures: (f) => features = f,
      isUsableDitto: (d) => !d.name.contains('-login-'),
    );
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

  test('stream error clears features and the next load retries', () async {
    host.set(_FakeDitto('main'));
    loader.load();
    docs['main/biz-1']!.addError(StateError('boom'));
    await pumpEventQueue();
    expect(features, isEmpty);

    loader.load();
    expect(subscriptions, [('main', 'biz-1'), ('main', 'biz-1')]);
  });

  test('missing doc yields no features', () async {
    host.set(_FakeDitto('main'));
    loader.load();
    docs['main/biz-1']!.add(null);
    await pumpEventQueue();
    expect(features, isEmpty);
  });
}
