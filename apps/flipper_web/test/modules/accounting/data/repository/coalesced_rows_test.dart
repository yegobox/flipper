import 'dart:async';

import 'package:flipper_models/perf/perf_track.dart';
import 'package:flipper_web/modules/accounting/data/repository/coalesced_rows.dart';
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
