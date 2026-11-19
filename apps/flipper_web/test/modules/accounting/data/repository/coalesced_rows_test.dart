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
}
