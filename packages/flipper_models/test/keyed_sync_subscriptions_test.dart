import 'dart:async';

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

  group('KeyedObserverFeed', () {
    late Map<String, Completer<void>> held;
    late List<List<String>> emitted;
    late List<Object> errors;
    late int observerCancels;
    late int streamCancels;
    late KeyedObserverFeed<String> feed;
    late StreamSubscription<List<String>> listening;

    // Rows are `id:key`; a row with no key has no colon.
    String? keyOf(String row) => row.contains(':') ? row.split(':')[1] : null;

    setUp(() {
      held = {};
      emitted = [];
      errors = [];
      observerCancels = 0;
      streamCancels = 0;
      feed = KeyedObserverFeed<String>(
        subscriptions: subscriptions,
        keyOf: keyOf,
        resolve: (row, key) async {
          if (key == 'boom') throw StateError('lookup failed');
          await held[row]?.future;
        },
        cancelSubscription: () => streamCancels++,
        onError: errors.add,
      )..cancelObserver = () => observerCancels++;
      listening = feed.stream.listen(emitted.add);
    });

    test('an older emission finishing late neither replaces the newer list '
        'nor drops its keys', () async {
      held['r1:x'] = Completer<void>();
      final older = feed.emit(() => ['r1:x']);
      await feed.emit(() => ['r3:x', 'r2:y']);
      await Future<void>.delayed(Duration.zero);
      expect(emitted, [
        ['r3:x', 'r2:y'],
      ]);

      held['r1:x']!.complete();
      await older;
      await Future<void>.delayed(Duration.zero);

      expect(emitted, hasLength(1));
      expect(subscriptions.keys, unorderedEquals(['x', 'y']));
    });

    test('a superseded emission never subscribes a key after the newer one '
        'pruned it', () async {
      held['r1:x'] = Completer<void>();
      final older = feed.emit(() => ['r1:x', 'r2:z']);
      await feed.emit(() => ['r3:x']);
      expect(subscriptions.keys, ['x']);

      held['r1:x']!.complete();
      await older;

      expect(subscriptions.keys, ['x']);
      expect(registered.where((k) => k == 'z'), hasLength(1));
      expect(cancelled, ['z']);
    });

    test('a failed lookup still prunes keys that left the result', () async {
      await feed.emit(() => ['r1:a', 'r2:b']);
      await feed.emit(() => ['r2:b', 'r3:boom']);

      expect(errors.single, isStateError);
      expect(subscriptions.keys, unorderedEquals(['b', 'boom']));
      expect(cancelled, ['a']);
      await Future<void>.delayed(Duration.zero);
      expect(emitted, hasLength(1));
    });

    test(
      'a result that cannot be read is reported and changes nothing',
      () async {
        await feed.emit(() => ['r1:a']);
        await feed.emit(() => throw const FormatException('bad row'));

        expect(errors.single, isFormatException);
        expect(subscriptions.keys, ['a']);
      },
    );

    test(
      'a newer result that cannot be read does not drop the older one',
      () async {
        held['r1:a'] = Completer<void>();
        final older = feed.emit(() => ['r1:a']);
        await feed.emit(() => throw const FormatException('bad row'));

        held['r1:a']!.complete();
        await older;
        await Future<void>.delayed(Duration.zero);

        expect(errors.single, isFormatException);
        expect(emitted, [
          ['r1:a'],
        ]);
      },
    );

    test('a failed registration goes to onError and still prunes', () async {
      final failing = KeyedSyncSubscriptions((key) {
        if (key == 'bad') throw StateError('subscribe failed');
        registered.add(key);
        return () => cancelled.add(key);
      });
      final local = KeyedObserverFeed<String>(
        subscriptions: failing,
        keyOf: keyOf,
        resolve: (_, __) async {},
        onError: errors.add,
      );
      addTearDown(local.close);

      await local.emit(() => ['r1:a']);
      // Must not escape: stock_mixin's observer callbacks drop this future.
      await local.emit(() => ['r2:bad']);

      expect(errors.single, isStateError);
      expect(cancelled, ['a']);
      expect(failing.keys, isEmpty);
    });

    test(
      'changes faster than the lookups still deliver a list per pass',
      () async {
        held['r1:x'] = Completer<void>();
        held['r2:x'] = Completer<void>();
        held['r3:x'] = Completer<void>();
        final first = feed.emit(() => ['r1:x']);
        final second = feed.emit(() => ['r2:x']);
        final third = feed.emit(() => ['r3:x']);

        // The oldest pass finishes although newer ones arrived meanwhile.
        held['r1:x']!.complete();
        await first;
        await Future<void>.delayed(Duration.zero);
        expect(emitted, [
          ['r1:x'],
        ]);

        // The newest wins over the middle one, which then never lands.
        held['r3:x']!.complete();
        await third;
        held['r2:x']!.complete();
        await second;
        await Future<void>.delayed(Duration.zero);
        expect(emitted, [
          ['r1:x'],
          ['r3:x'],
        ]);
      },
    );

    test('rows without a key are delivered without a subscription', () async {
      await feed.emit(() => ['plain']);
      await Future<void>.delayed(Duration.zero);
      expect(emitted, [
        ['plain'],
      ]);
      expect(registered, isEmpty);
    });

    test('closing the stream cancels the observer, its own subscription and '
        'every keyed one', () async {
      await feed.emit(() => ['r1:a', 'r2:b']);
      await listening.cancel();

      expect(observerCancels, 1);
      expect(streamCancels, 1);
      expect(cancelled, unorderedEquals(['a', 'b']));

      // Late observer work after close is ignored.
      await feed.emit(() => ['r3:c']);
      expect(registered, ['a', 'b']);
    });

    test('a failing observer cancel still cancels everything else', () async {
      await feed.emit(() => ['r1:a', 'r2:b']);
      feed.cancelObserver = () => throw StateError('observer gone');

      await expectLater(feed.close(), throwsStateError);

      expect(streamCancels, 1);
      expect(cancelled, unorderedEquals(['a', 'b']));
      await feed.emit(() => ['r3:c']);
      expect(registered, ['a', 'b']);
    });
  });
}
