import 'package:flipper_models/sync/utils/engagement_store.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/fake_ditto.dart';

// flutter test test/engagement_store_subscription_test.dart
void main() {
  late FakeDitto ditto;
  late EngagementStore store;

  setUp(() {
    ditto = FakeDitto();
    store = EngagementStore(ditto);
  });

  test('each watched document is subscribed once, as prepared', () async {
    // Today's goal re-listens on every rebuild; each listen used to be able
    // to add a subscription.
    for (var rebuild = 0; rebuild < 3; rebuild++) {
      final sub = store.state('b1').listen((_) {});
      await sub.cancel();
    }
    final settings = store.settings('b1').listen((_) {});

    expect(ditto.sync.registered.map((r) => r.dql), [
      'SELECT * FROM engagement_state WHERE _id = :id',
      'SELECT * FROM engagement_settings WHERE _id = :id',
    ]);
    expect(ditto.sync.registered.first.arguments, {'id': 'b1'});
    await settings.cancel();
    expect(ditto.store.liveObserverCount, 0);
  });

  test('today rides on the POS subscription and adds none', () async {
    final sub = store.today('b1', DateTime(2026, 11, 10)).listen((_) {});
    await sub.cancel();

    expect(ditto.sync.registered, isEmpty);
  });
}
