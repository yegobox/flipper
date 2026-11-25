import 'dart:async';

import 'package:flipper_models/perf/perf_track.dart';
import 'package:flipper_web/modules/accounting/data/repository/coalesced_rows.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  tearDown(() => PerfTrack.track = PerfTrack.untracked);

  late StreamController<void> feed;
  late int reads;
  late int feedListens;
  Completer<void>? gate;

  setUp(() {
    feed = StreamController<void>.broadcast();
    reads = 0;
    feedListens = 0;
    gate = null;
  });

  Stream<List<Map<String, dynamic>>> rows() => coalescedRows(
    perfLabel: 'books.transactions_refresh',
    read: () async {
      reads++;
      await gate?.future;
      return [
        {'id': 'r$reads'},
      ];
    },
    changes: () {
      feedListens++;
      return feed.stream;
    },
  );

  test('reads once on listen, and once per burst of changes', () async {
    final emitted = <List<Map<String, dynamic>>>[];
    final sub = rows().listen(emitted.add);
    await pumpEventQueue();
    expect(reads, 1);

    // A till completing sales: twenty changes inside one window.
    for (var i = 0; i < 20; i++) {
      feed.add(null);
    }
    await Future<void>.delayed(const Duration(milliseconds: 400));

    expect(reads, 2);
    expect(emitted, hasLength(2));
    await sub.cancel();
  });

  test('changes during a read trigger exactly one more', () async {
    gate = Completer<void>();
    final sub = rows().listen((_) {});
    await pumpEventQueue();
    for (var i = 0; i < 5; i++) {
      feed.add(null);
    }
    gate!.complete();
    gate = null;
    await Future<void>.delayed(const Duration(milliseconds: 400));

    expect(reads, 2);
    await sub.cancel();
  });

  test(
    'nothing is read or watched before a listener, or after it leaves',
    () async {
      final stream = rows();
      await pumpEventQueue();
      expect(reads, 0);
      expect(feedListens, 0);

      final sub = stream.listen((_) {});
      await pumpEventQueue();
      feed.add(null);
      await sub.cancel();
      await Future<void>.delayed(const Duration(milliseconds: 400));

      expect(reads, 1);
      expect(feed.hasListener, isFalse);
    },
  );

  test(
    'a failed read reaches the listener and the next change recovers',
    () async {
      var fail = true;
      final errors = <Object>[];
      final emitted = <List<Map<String, dynamic>>>[];
      final sub = coalescedRows(
        perfLabel: 'books.transactions_refresh',
        read: () async {
          reads++;
          if (fail) throw StateError('ditto busy');
          return const [];
        },
        changes: () => feed.stream,
      ).listen(emitted.add, onError: errors.add);
      await pumpEventQueue();
      expect(errors, hasLength(1));

      fail = false;
      feed.add(null);
      await Future<void>.delayed(const Duration(milliseconds: 400));

      expect(emitted, hasLength(1));
      await sub.cancel();
    },
  );

  test('each read is named in the perf trail', () async {
    final labels = <String>[];
    PerfTrack.track = <T>(String label, Future<T> Function() body) {
      labels.add(label);
      return body();
    };
    final sub = rows().listen((_) {});
    await pumpEventQueue();

    expect(labels, ['books.transactions_refresh']);
    await sub.cancel();
  });

  // Books' stream providers are not auto-dispose: leaving Books pauses them
  // (Riverpod 3) rather than cancelling. A paused listener must stop the
  // observer and the reads, or every sale re-reads the branch's sales on the
  // UI isolate off-screen and the paused stream buffers each result.
  group('a paused listener', () {
    test('stops watching and reading until it resumes', () async {
      final emitted = <List<Map<String, dynamic>>>[];
      final sub = rows().listen(emitted.add);
      await pumpEventQueue();
      expect(reads, 1);
      expect(feedListens, 1);

      sub.pause();
      await pumpEventQueue();
      expect(feed.hasListener, isFalse);
      for (var i = 0; i < 20; i++) {
        feed.add(null);
      }
      await Future<void>.delayed(const Duration(milliseconds: 400));
      expect(reads, 1);

      sub.resume();
      await pumpEventQueue();
      // Watching again, with one read for what it did not watch.
      expect(feedListens, 2);
      expect(feed.hasListener, isTrue);
      expect(reads, 2);
      expect(emitted.map((r) => r.single['id']), ['r1', 'r2']);

      feed.add(null);
      await Future<void>.delayed(const Duration(milliseconds: 400));
      expect(reads, 3);
      await sub.cancel();
    });

    test('drops a read that finishes while paused', () async {
      gate = Completer<void>();
      final emitted = <List<Map<String, dynamic>>>[];
      final sub = rows().listen(emitted.add);
      await pumpEventQueue();
      sub.pause();
      gate!.complete();
      gate = null;
      await pumpEventQueue();

      sub.resume();
      await pumpEventQueue();
      // Only the read after resuming: the paused one was not kept.
      expect(reads, 2);
      expect(emitted.map((r) => r.single['id']), ['r2']);
      await sub.cancel();
    });

    test('resumed during a read gets that read and one more', () async {
      gate = Completer<void>();
      final emitted = <List<Map<String, dynamic>>>[];
      final sub = rows().listen(emitted.add);
      await pumpEventQueue();
      sub.pause();
      sub.resume();
      gate!.complete();
      gate = null;
      await Future<void>.delayed(const Duration(milliseconds: 400));

      expect(reads, 2);
      expect(emitted, hasLength(2));
      await sub.cancel();
    });

    test('does not retry a failed feed until it resumes', () async {
      final feeds = <StreamController<void>>[];
      final sub = coalescedRows(
        perfLabel: 'books.transactions_refresh',
        read: () async {
          reads++;
          return const [];
        },
        changes: () {
          final c = StreamController<void>();
          if (feeds.isEmpty) c.addError(StateError('registerObserver failed'));
          feeds.add(c);
          return c.stream;
        },
        retryBase: const Duration(milliseconds: 20),
      ).listen((_) {});
      await pumpEventQueue();
      expect(feeds, hasLength(1));

      sub.pause();
      await Future<void>.delayed(const Duration(milliseconds: 80));
      expect(feeds, hasLength(1));

      sub.resume();
      await pumpEventQueue();
      expect(feeds, hasLength(2));
      expect(reads, 2);
      await sub.cancel();
    });

    test(
      'is what Riverpod makes of a kept-alive provider nobody watches',
      () async {
        final provider = StreamProvider<List<Map<String, dynamic>>>(
          (ref) => rows(),
        );
        final container = ProviderContainer();
        addTearDown(container.dispose);

        final books = container.listen(provider, (_, _) {});
        await pumpEventQueue();
        expect(reads, 1);

        // The cashier leaves Books for the POS and sells.
        books.close();
        await pumpEventQueue();
        for (var i = 0; i < 20; i++) {
          feed.add(null);
          await Future<void>.delayed(const Duration(milliseconds: 30));
        }
        await Future<void>.delayed(const Duration(milliseconds: 400));
        expect(reads, 1);
        expect(feed.hasListener, isFalse);

        // Back in Books: fresh rows.
        final again = container.listen(provider, (_, _) {});
        await pumpEventQueue();
        expect(reads, 2);
        expect(container.read(provider).value?.single['id'], 'r2');
        again.close();
      },
    );
  });

  group('a change feed that fails', () {
    /// A feed whose first [failures] subscriptions fail as a failed observer
    /// registration does: one error, then nothing.
    ({Stream<void> Function() changes, List<StreamController<void>> feeds})
    flaky(int failures) {
      final feeds = <StreamController<void>>[];
      return (
        feeds: feeds,
        changes: () {
          final c = StreamController<void>();
          feeds.add(c);
          if (feeds.length <= failures) {
            c.addError(StateError('registerObserver failed'));
          }
          return c.stream;
        },
      );
    }

    test('is subscribed to again, then read for what it missed', () async {
      final f = flaky(1);
      final sub = coalescedRows(
        perfLabel: 'books.transactions_refresh',
        read: () async {
          reads++;
          return const [];
        },
        changes: f.changes,
        coalesce: const Duration(milliseconds: 10),
        retryBase: const Duration(milliseconds: 20),
      ).listen((_) {});
      await pumpEventQueue();
      expect(reads, 1);
      expect(f.feeds, hasLength(1));

      await Future<void>.delayed(const Duration(milliseconds: 80));
      // A new subscription, and one catch-up read.
      expect(f.feeds, hasLength(2));
      expect(reads, 2);

      // The new feed works.
      f.feeds.last.add(null);
      await Future<void>.delayed(const Duration(milliseconds: 40));
      expect(reads, 3);
      await sub.cancel();
    });

    testWidgets('backs off while it keeps failing, capped, and resets once '
        'it works', (tester) async {
      final f = flaky(4);
      final sub = coalescedRows(
        perfLabel: 'books.transactions_refresh',
        read: () async => const [],
        changes: f.changes,
        retryBase: const Duration(seconds: 1),
        retryMax: const Duration(seconds: 3),
      ).listen((_) {});
      await tester.pump();
      expect(f.feeds, hasLength(1));

      // 1 s, then 2 s, then capped at 3 s.
      await tester.pump(const Duration(milliseconds: 999));
      expect(f.feeds, hasLength(1));
      await tester.pump(const Duration(milliseconds: 1));
      expect(f.feeds, hasLength(2));
      await tester.pump(const Duration(seconds: 2));
      expect(f.feeds, hasLength(3));
      await tester.pump(const Duration(seconds: 3));
      expect(f.feeds, hasLength(4));
      await tester.pump(const Duration(seconds: 3));
      expect(f.feeds, hasLength(5));

      // Working again: the next failure starts from 1 s.
      f.feeds.last.add(null);
      await tester.pump();
      f.feeds.last.addError(StateError('again'));
      await tester.pump(const Duration(seconds: 1));
      expect(f.feeds, hasLength(6));

      unawaited(sub.cancel());
      await tester.pump(const Duration(seconds: 1));
    });

    testWidgets('is not retried once the listener leaves', (tester) async {
      final f = flaky(5);
      final sub = coalescedRows(
        perfLabel: 'books.transactions_refresh',
        read: () async => const [],
        changes: f.changes,
        retryBase: const Duration(seconds: 1),
      ).listen((_) {});
      await tester.pump();
      unawaited(sub.cancel());
      await tester.pump(const Duration(seconds: 10));
      expect(f.feeds, hasLength(1));
    });
  });
}
