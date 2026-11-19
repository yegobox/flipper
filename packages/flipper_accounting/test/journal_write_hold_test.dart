import 'dart:async';

import 'package:flipper_accounting/accounting_models.dart';
import 'package:flipper_accounting/ditto_accounting_ledger_repository.dart';
import 'package:flipper_models/perf/perf_track.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers/dql_accounting_store.dart';

const _biz = '89ed8709-172d-4524-bab8-5f9d31f98657';

/// A store whose writes are slow, like a busy till's Ditto: each one lands,
/// fires the change feed, and takes [writeDelay].
class _SlowWriteStore extends DqlAccountingStore {
  _SlowWriteStore({required this.writeDelay});

  final Duration writeDelay;
  int writes = 0;

  /// Runs before each write lands; may block it.
  Future<void> Function()? beforeWrite;

  Future<void> _write(String collection, Map<String, dynamic> row) async {
    writes++;
    await beforeWrite?.call();
    await Future<void>.delayed(writeDelay);
    put(collection, row);
    notifyChange(collection);
  }

  @override
  Future<void> upsertJournalEntryHeader(
    String businessId,
    Map<String, dynamic> header,
    String docId,
  ) => _write('journal_entries', {...header, '_id': docId, 'id': docId});

  @override
  Future<void> upsertJournalLine(
    String businessId,
    String journalEntryId,
    JournalLine line, {
    String? id,
  }) => _write('journal_lines', {
    '_id': id ?? '${journalEntryId}_${line.ac}',
    'journalEntryId': journalEntryId,
    'businessId': businessId,
    'accountCode': line.ac,
    'debit': line.dr,
    'credit': line.cr,
  });

  @override
  Future<void> executeUpdate(
    String collection,
    String docId,
    Map<String, dynamic> data,
  ) async {
    writes++;
    await Future<void>.delayed(writeDelay);
    notifyChange(collection);
  }
}

JournalEntry _entry() => JournalEntry(
  id: 'JE-HOLD',
  date: '19 Nov 2026',
  memo: 'Six-line manual entry',
  ref: 'JE-HOLD',
  status: JournalStatus.posted,
  src: 'Manual',
  lines: [
    for (final ac in ['1010', '1020', '1030']) JournalLine(ac: ac, dr: 100),
    for (final ac in ['4010', '4020', '4030']) JournalLine(ac: ac, cr: 100),
  ],
);

void main() {
  late Duration holdLimit;

  setUp(() => holdLimit = DittoAccountingLedgerRepository.writeHoldLimit);
  tearDown(() {
    DittoAccountingLedgerRepository.writeHoldLimit = holdLimit;
    PerfTrack.track = PerfTrack.untracked;
  });

  Future<(StreamSubscription<List<JournalEntry>>, List<List<JournalEntry>>)>
  watch(DittoAccountingLedgerRepository repo) async {
    final emitted = <List<JournalEntry>>[];
    final sub = repo.watchJournalEntries(businessId: _biz).listen(emitted.add);
    await pumpEventQueue();
    return (sub, emitted);
  }

  test('a slow save is read once, after its last write', () async {
    final store = _SlowWriteStore(
      writeDelay: const Duration(milliseconds: 100),
    );
    final repo = DittoAccountingLedgerRepository(store);
    final (sub, emitted) = await watch(repo);
    final before = store.queriesOf('journal_entries', 'businessId');

    // 1 header + 6 lines at 100 ms each: well past the 250 ms window, which
    // used to read the whole journal mid-save.
    final id = await repo.createJournalEntry(businessId: _biz, entry: _entry());
    await repo.postJournalEntry(businessId: _biz, entryId: id);
    await Future<void>.delayed(const Duration(milliseconds: 400));

    expect(store.writes, 8);
    expect(store.queriesOf('journal_entries', 'businessId') - before, 1);
    expect(emitted.last.single.lines, hasLength(6));
    await sub.cancel();
  });

  test(
    'a poster with its own repository holds the screens\' source too',
    () async {
      final store = _SlowWriteStore(
        writeDelay: const Duration(milliseconds: 100),
      );
      final screens = DittoAccountingLedgerRepository(store);
      final (sub, _) = await watch(screens);
      final before = store.queriesOf('journal_entries', 'businessId');

      // Bill payments and purchase posters build their own repository.
      final poster = DittoAccountingLedgerRepository(store);
      await poster.batchWrites(
        businessId: _biz,
        writes: () async {
          final id = await poster.createJournalEntry(
            businessId: _biz,
            entry: _entry(),
          );
          await poster.postJournalEntry(businessId: _biz, entryId: id);
        },
      );
      await Future<void>.delayed(const Duration(milliseconds: 400));

      expect(store.queriesOf('journal_entries', 'businessId') - before, 1);
      await sub.cancel();
    },
  );

  test(
    'a write that never finishes releases the ledger after the limit',
    () async {
      DittoAccountingLedgerRepository.writeHoldLimit = const Duration(
        milliseconds: 300,
      );
      final store = _SlowWriteStore(writeDelay: Duration.zero);
      final repo = DittoAccountingLedgerRepository(store);
      final (sub, _) = await watch(repo);
      final before = store.queriesOf('journal_entries', 'businessId');

      final stuck = Completer<void>();
      unawaited(
        repo.batchWrites(
          businessId: _biz,
          writes: () async {
            store.notifyChange('journal_entries');
            await stuck.future;
          },
        ),
      );
      await Future<void>.delayed(const Duration(milliseconds: 200));
      expect(store.queriesOf('journal_entries', 'businessId') - before, 0);

      await Future<void>.delayed(const Duration(milliseconds: 500));
      expect(store.queriesOf('journal_entries', 'businessId') - before, 1);

      // The late release of the timed-out hold ends nothing newer.
      final next = Completer<void>();
      unawaited(repo.batchWrites(businessId: _biz, writes: () => next.future));
      stuck.complete();
      await pumpEventQueue();
      store.notifyChange('journal_entries');
      await Future<void>.delayed(const Duration(milliseconds: 100));
      expect(store.queriesOf('journal_entries', 'businessId') - before, 1);
      next.complete();
      await Future<void>.delayed(const Duration(milliseconds: 400));
      expect(store.queriesOf('journal_entries', 'businessId') - before, 2);
      await sub.cancel();
    },
  );

  test('a failed save still releases the ledger', () async {
    final store = _SlowWriteStore(writeDelay: Duration.zero);
    final repo = DittoAccountingLedgerRepository(store);
    final (sub, _) = await watch(repo);
    final before = store.queriesOf('journal_entries', 'businessId');

    await expectLater(
      repo.batchWrites<void>(
        businessId: _biz,
        writes: () async {
          store.notifyChange('journal_entries');
          throw StateError('write failed');
        },
      ),
      throwsStateError,
    );
    await Future<void>.delayed(const Duration(milliseconds: 400));

    expect(store.queriesOf('journal_entries', 'businessId') - before, 1);
    await sub.cancel();
  });

  test('saves are named in the perf trail', () async {
    final labels = <String>[];
    PerfTrack.track = <T>(String label, Future<T> Function() body) {
      labels.add(label);
      return body();
    };
    final store = _SlowWriteStore(writeDelay: Duration.zero);
    final repo = DittoAccountingLedgerRepository(store);

    await repo.batchWrites(
      businessId: _biz,
      perfLabel: 'books.pay_bill',
      writes: () => repo.createJournalEntry(businessId: _biz, entry: _entry()),
    );

    expect(labels, ['books.pay_bill', 'books.write_entry']);
  });

  test('stock value reads variants in one query per chunk', () async {
    final store = DqlAccountingStore();
    for (var i = 0; i < 1500; i++) {
      store.put('stocks', {
        '_id': 's$i',
        'branchId': 'b1',
        'variantId': 'v$i',
        'currentStock': 2,
      });
      store.put('variants', {'_id': 'v$i', 'id': 'v$i', 'supplyPrice': 10});
    }
    // A stock row whose variant is gone counts nothing.
    store.put('stocks', {
      '_id': 'gone',
      'branchId': 'b1',
      'variantId': 'missing',
      'currentStock': 5,
    });
    final repo = DittoAccountingLedgerRepository(store);

    final total = await repo.fetchInventoryValue(branchId: 'b1');

    expect(total, 1500 * 2 * 10);
    expect(
      store.queries.where((q) => q.contains('FROM variants')),
      hasLength(2),
    );
  });
}
