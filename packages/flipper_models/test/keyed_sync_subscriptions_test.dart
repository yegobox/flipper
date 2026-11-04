import 'package:flipper_models/sync/keyed_sync_subscriptions.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late List<String> registered;
  late List<String> cancelled;
  late KeyedSyncSubscriptions subscriptions;

  setUp(() {
    registered = [];
    cancelled = [];
    subscriptions = KeyedSyncSubscriptions((key) {
      registered.add(key);
      return () => cancelled.add(key);
    });
  });

  test('a key is registered once however often it is ensured', () {
    subscriptions
      ..ensure('branch-a')
      ..ensure('branch-a')
      ..ensure('branch-b');

    expect(registered, ['branch-a', 'branch-b']);
    expect(subscriptions.keys, unorderedEquals(['branch-a', 'branch-b']));
  });

  test('keys that leave the result are cancelled, the rest stay', () {
    subscriptions
      ..ensure('branch-a')
      ..ensure('branch-b')
      ..retainOnly({'branch-b'});

    expect(cancelled, ['branch-a']);
    expect(subscriptions.keys, ['branch-b']);

    // A key that comes back is registered again.
    subscriptions.ensure('branch-a');
    expect(registered, ['branch-a', 'branch-b', 'branch-a']);
  });

  test('cancelAll drops everything and ignores later ensures', () {
    subscriptions
      ..ensure('branch-a')
      ..ensure('branch-b')
      ..cancelAll();

    expect(cancelled, unorderedEquals(['branch-a', 'branch-b']));
    expect(subscriptions.keys, isEmpty);

    // Observer work that resumes after the stream closed must not leak one.
    subscriptions.ensure('branch-c');
    expect(registered, ['branch-a', 'branch-b']);
    expect(subscriptions.keys, isEmpty);
  });
}
