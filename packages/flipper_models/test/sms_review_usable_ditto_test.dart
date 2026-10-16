import 'dart:async';

import 'package:flipper_models/sms_review/sms_review_providers.dart';
import 'package:flutter_test/flutter_test.dart';

/// Stands in for `DittoService`'s listener list: calls back at once with the
/// current instance, then on every change.
class _FakeDitto {
  String? current;
  final listeners = <void Function(String?)>[];

  void add(void Function(String?) l) {
    listeners.add(l);
    l(current);
  }

  void remove(void Function(String?) l) => listeners.remove(l);

  void set(String? instance) {
    current = instance;
    for (final l in List.of(listeners)) {
      l(instance);
    }
  }
}

void main() {
  late _FakeDitto ditto;
  late Stream<String?> stream;

  setUp(() {
    ditto = _FakeDitto();
    stream = usableInstances<String>(
      addListener: ditto.add,
      removeListener: ditto.remove,
      isUsable: (d) => !d.contains('-login-'),
    );
  });

  test('a list watched before Ditto is up gets the instance when it arrives',
      () async {
    final seen = <String?>[];
    final sub = stream.listen(seen.add);
    await pumpEventQueue();
    expect(seen, [null]);

    ditto.set('main');
    await pumpEventQueue();
    expect(seen, [null, 'main']);
    await sub.cancel();
  });

  test('the QR-login instance is not used, and repeats are dropped', () async {
    final seen = <String?>[];
    final sub = stream.listen(seen.add);
    ditto.set('pos-login-1');
    ditto.set('main');
    ditto.set('main');
    ditto.set(null);
    await pumpEventQueue();
    expect(seen, [null, 'main', null]);
    await sub.cancel();
  });

  test('an instance already up is emitted at once', () async {
    ditto.current = 'main';
    expect(await stream.first, 'main');
  });

  test('cancelling removes the listener', () async {
    final sub = stream.listen((_) {});
    await pumpEventQueue();
    expect(ditto.listeners, hasLength(1));
    await sub.cancel();
    expect(ditto.listeners, isEmpty);
  });
}
