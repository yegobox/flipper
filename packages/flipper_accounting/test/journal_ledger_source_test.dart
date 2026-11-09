import 'dart:async';
import 'dart:math';

import 'package:flipper_accounting/accounting_models.dart';
import 'package:flipper_accounting/ditto_accounting_ledger_repository.dart';
import 'package:flipper_models/perf/perf_track.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers/dql_accounting_store.dart';
import 'helpers/legacy_journal_entries.dart';

const _biz = '89ed8709-172d-4524-bab8-5f9d31f98657';
const _other = '0b9c6c8e-1111-4222-8333-944455556666';

/// A busy hotel's ledger with every shape the old code handled: ISO,
/// 1970-remapped and `d MMM y` dates, undated rows, snake-only keys, lines
/// with no business id (camel and snake entry refs), orphan lines whose
/// header sits under another business or is missing, and same-day ties.
DqlAccountingStore _seed({int entries = 3000, int orphans = 150}) {
  final store = DqlAccountingStore();
  final rnd = Random(7);
  const statuses = ['posted', 'posted', 'posted', 'pending', 'draft'];
  const months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];
  for (var i = 0; i < entries; i++) {
    final id =
        'je_${_biz}_txn$i'
        '_sale';
    final m = 1 + rnd.nextInt(11);
    final d = 1 + rnd.nextInt(28);
    final mm = m.toString().padLeft(2, '0');
    final dd = d.toString().padLeft(2, '0');
    final Object? date = switch (i % 10) {
      0 => '1970-$mm-${dd}T00:00:00.000Z',
      1 => '$d ${months[m - 1]} 2026',
      2 => null,
      _ => '2026-$mm-${dd}T00:00:00.000',
    };
    store.put('journal_entries', {
      '_id': id,
      'id': id,
      if (i % 7 != 0) 'businessId': _biz,
      'business_id': _biz,
      'entryNumber': 'JE-${i.toString().padLeft(5, '0')}',
      'memo': 'Sale · $i',
      'reference': 'R$i',
      'status': statuses[i % statuses.length],
      'source': 'POS',
      if (date != null) 'entryDate': date,
    });
    final lineCount = 2 + rnd.nextInt(3);
    for (var k = 0; k < lineCount; k++) {
      final ac = ['1010', '4010', '2100', '5010', '1200'][k];
      final noBusiness = i % 10 == 5;
      final snakeRef = noBusiness && i % 20 == 5;
      store.put('journal_lines', {
        '_id': '${id}_$ac',
        if (!snakeRef) 'journalEntryId': id,
        'journal_entry_id': id,
        'accountCode': ac,
        'debit': k == 0 ? 1000 + i : 0,
        'credit': k == 0 ? 0 : 500,
        if (!noBusiness) 'businessId': _biz,
      });
    }
  }
  for (var i = 0; i < orphans; i++) {
    final id = i.isEven
        ? 'je_${_biz}_orph$i'
              '_sale'
        : 'je_${_biz}_orph$i'
              '_pay_k$i';
    if (i % 3 == 0) {
      // Header exists, but under another business: found by id.
      store.put('journal_entries', {
        '_id': id,
        'businessId': _other,
        'entryNumber': 'JE-X$i',
        'status': 'posted',
        'entryDate': '2026-11-0${1 + i % 9}T00:00:00.000',
      });
    }
    store.put('journal_lines', {
      '_id': '${id}_1010',
      'journalEntryId': id,
      'accountCode': '1010',
      'debit': 10 + i,
      'credit': 0,
      'businessId': _biz,
    });
  }
  // Another business's ledger stays out.
  for (var i = 0; i < 50; i++) {
    final id =
        'je_${_other}_t$i'
        '_sale';
    store.put('journal_entries', {
      '_id': id,
      'businessId': _other,
      'status': 'posted',
      'entryDate': '2026-11-02T00:00:00.000',
    });
    store.put('journal_lines', {
      '_id': '${id}_1010',
      'journalEntryId': id,
      'accountCode': '1010',
      'debit': 1,
      'businessId': _other,
    });
  }
  return store;
}

List<Object?> _shape(List<JournalEntry> entries) => [
  for (final e in entries)
    [
      e.id,
      e.uuid,
      e.date,
      e.memo,
      e.ref,
      e.status.name,
      e.src,
      [for (final l in e.lines) '${l.ac}:${l.dr}:${l.cr}'],
    ],
];

final _ranges = <String, (DateTime?, DateTime?)>{
  'period (Nov)': (DateTime(2026, 11, 1), DateTime(2026, 11, 30)),
  'through period end': (null, DateTime(2026, 11, 30)),
  'quarter': (DateTime(2026, 1, 1), DateTime(2026, 3, 31)),
  'unbounded': (null, null),
};

void main() {
  tearDown(() => PerfTrack.track = PerfTrack.untracked);

  group('watchJournalEntries', () {
    test('returns exactly what the old implementation returned', () async {
      final store = _seed();
      final repo = DittoAccountingLedgerRepository(store);
      for (final MapEntry(key: name, value: (start, end)) in _ranges.entries) {
        final expected = await legacyJournalEntries(
          store,
          businessId: _biz,
          startDate: start,
          endDate: end,
        );
        final actual = await repo
            .watchJournalEntries(
              businessId: _biz,
              startDate: start,
              endDate: end,
            )
            .first;
        expect(expected, isNotEmpty, reason: name);
        expect(_shape(actual), _shape(expected), reason: name);
      }
    });

    test(
      'a refresh runs a fixed number of queries, whatever the size',
      () async {
        Future<int> queriesFor(int entries, int orphans) async {
          final store = _seed(entries: entries, orphans: orphans);
          final repo = DittoAccountingLedgerRepository(store);
          store.queries.clear();
          await repo.watchJournalEntries(businessId: _biz).first;
          return store.queries.length;
        }

        final small = await queriesFor(300, 15);
        final large = await queriesFor(3000, 150);
        // Headers, lines, orphan headers, camel and snake line lookups.
        expect(large, 5);
        expect(small, large);

        // The old code ran one query per orphan and per header without lines.
        final legacyStore = _seed(entries: 3000, orphans: 150);
        legacyStore.queries.clear();
        await legacyJournalEntries(legacyStore, businessId: _biz);
        expect(legacyStore.queries.length, greaterThan(400));
      },
    );

    test('the period and through-end streams share one source', () async {
      final store = _seed(entries: 200, orphans: 10);
      final repo = DittoAccountingLedgerRepository(store);
      final period = repo
          .watchJournalEntries(
            businessId: _biz,
            startDate: DateTime(2026, 11, 1),
            endDate: DateTime(2026, 11, 30),
          )
          .listen((_) {});
      final throughEnd = repo
          .watchJournalEntries(
            businessId: _biz,
            endDate: DateTime(2026, 11, 30),
          )
          .listen((_) {});
      await pumpEventQueue();

      expect(repo.ledgerSourceCount, 1);
      // One change feed per collection, not per caller.
      expect(store.activeChangeFeeds, 2);
      expect(store.queriesOf('journal_entries', 'businessId'), 1);

      await period.cancel();
      expect(repo.ledgerSourceCount, 1);
      await throughEnd.cancel();
      expect(repo.ledgerSourceCount, 0);
      expect(store.activeChangeFeeds, 0);
    });

    test('a burst of changes is read once', () async {
      final store = _seed(entries: 200, orphans: 10);
      final repo = DittoAccountingLedgerRepository(store);
      final emitted = <List<JournalEntry>>[];
      final sub = repo
          .watchJournalEntries(businessId: _biz)
          .listen(emitted.add);
      await pumpEventQueue();
      expect(emitted, hasLength(1));
      final before = store.queriesOf('journal_entries', 'businessId');

      store.put('journal_entries', {
        '_id': 'je_${_biz}_late_sale',
        'businessId': _biz,
        'entryNumber': 'JE-LATE',
        'status': 'posted',
        'entryDate': '2026-11-09T00:00:00.000',
      });
      for (var i = 0; i < 50; i++) {
        store.notifyChange(i.isEven ? 'journal_entries' : 'journal_lines');
      }
      await Future<void>.delayed(const Duration(milliseconds: 400));

      expect(store.queriesOf('journal_entries', 'businessId') - before, 1);
      expect(emitted, hasLength(2));
      expect(emitted.first.map((e) => e.id), isNot(contains('JE-LATE')));
      expect(emitted.last.map((e) => e.id), contains('JE-LATE'));
      await sub.cancel();
    });

    test('changes during a refresh trigger exactly one more', () async {
      final store = _seed(entries: 50, orphans: 0);
      final gate = Completer<void>();
      store.beforeQuery = (q) async {
        if (q.contains('FROM journal_lines WHERE businessId'))
          await gate.future;
      };
      final repo = DittoAccountingLedgerRepository(store);
      final emitted = <List<JournalEntry>>[];
      final sub = repo
          .watchJournalEntries(businessId: _biz)
          .listen(emitted.add);
      await pumpEventQueue();
      for (var i = 0; i < 10; i++) {
        store.notifyChange('journal_entries');
      }
      store.beforeQuery = null;
      gate.complete();
      await Future<void>.delayed(const Duration(milliseconds: 400));

      expect(store.queriesOf('journal_entries', 'businessId'), 2);
      expect(emitted, hasLength(2));
      await sub.cancel();
    });

    test(
      'a late listener gets the current ledger without a new read',
      () async {
        final store = _seed(entries: 100, orphans: 5);
        final repo = DittoAccountingLedgerRepository(store);
        final first = repo.watchJournalEntries(businessId: _biz).listen((_) {});
        await pumpEventQueue();
        final reads = store.queriesOf('journal_entries', 'businessId');

        final late = await repo
            .watchJournalEntries(
              businessId: _biz,
              startDate: DateTime(2026, 11, 1),
              endDate: DateTime(2026, 11, 30),
            )
            .first;
        expect(store.queriesOf('journal_entries', 'businessId'), reads);
        final expected = await legacyJournalEntries(
          store,
          businessId: _biz,
          startDate: DateTime(2026, 11, 1),
          endDate: DateTime(2026, 11, 30),
        );
        expect(_shape(late), _shape(expected));
        await first.cancel();
      },
    );

    test(
      'a failed read surfaces as an error and the next change recovers',
      () async {
        final store = _seed(entries: 20, orphans: 0);
        var fail = true;
        store.beforeQuery = (q) async {
          if (fail && q.contains('FROM journal_entries WHERE businessId')) {
            throw StateError('ditto closed');
          }
        };
        final repo = DittoAccountingLedgerRepository(store);
        final errors = <Object>[];
        final emitted = <List<JournalEntry>>[];
        final sub = repo
            .watchJournalEntries(businessId: _biz)
            .listen(emitted.add, onError: errors.add);
        await pumpEventQueue();
        expect(errors, hasLength(1));
        expect(emitted, isEmpty);

        fail = false;
        store.notifyChange('journal_entries');
        await Future<void>.delayed(const Duration(milliseconds: 400));
        expect(emitted, hasLength(1));
        expect(emitted.single, hasLength(20));
        await sub.cancel();
      },
    );

    test('a change feed error is logged, not fatal', () async {
      final store = _seed(entries: 5, orphans: 0);
      final repo = DittoAccountingLedgerRepository(store);
      final emitted = <List<JournalEntry>>[];
      final sub = repo
          .watchJournalEntries(businessId: _biz)
          .listen(emitted.add);
      await pumpEventQueue();
      store.failChangeFeeds(StateError('observer gone'));
      await pumpEventQueue();
      expect(emitted, hasLength(1));
      await sub.cancel();
    });

    test('every refresh is reported to the perf trail', () async {
      final labels = <String>[];
      PerfTrack.track = <T>(String label, Future<T> Function() body) {
        labels.add(label);
        return body();
      };
      final store = _seed(entries: 10, orphans: 0);
      final repo = DittoAccountingLedgerRepository(store);
      await repo.watchJournalEntries(businessId: _biz).first;
      expect(labels, ['books.ledger_refresh']);
    });

    test('cancelling mid-refresh drops the result quietly', () async {
      final store = _seed(entries: 10, orphans: 0);
      final gate = Completer<void>();
      store.beforeQuery = (q) async {
        if (q.contains('FROM journal_lines WHERE businessId'))
          await gate.future;
      };
      final repo = DittoAccountingLedgerRepository(store);
      final sub = repo.watchJournalEntries(businessId: _biz).listen((_) {});
      await pumpEventQueue();
      store.notifyChange('journal_entries');
      await sub.cancel();
      expect(repo.ledgerSourceCount, 0);
      gate.complete();
      await Future<void>.delayed(const Duration(milliseconds: 400));
      expect(store.queriesOf('journal_entries', 'businessId'), 1);
    });
  });
}
