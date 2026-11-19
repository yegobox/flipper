import 'package:flipper_web/modules/accounting/data/repository/ditto_accounting_repository.dart';
import 'package:flipper_web/services/ditto_mixins/accounting_mixin.dart';
import 'package:flipper_web/services/ditto_mixins/ditto_core_mixin.dart';
import 'package:flutter_test/flutter_test.dart';

// Ditto's Store is a final class; the repository takes it as `dynamic`.

class _Item {
  _Item(this.value);
  final Map<String, dynamic> value;
}

class _Result {
  _Result(this.items);
  final List<_Item> items;
}

class _Observer {
  var cancelled = false;
  Future<void> cancel() async => cancelled = true;
}

class _Store {
  final executed = <(String, Map<String, dynamic>)>[];
  var rows = <Map<String, dynamic>>[];
  void Function(dynamic)? onChange;
  _Observer? observer;

  Future<_Result> execute(
    String dql, {
    Map<String, dynamic> arguments = const {},
  }) async {
    executed.add((dql, arguments));
    return _Result([for (final r in rows) _Item(r)]);
  }

  _Observer registerObserver(
    String query, {
    Map<String, dynamic> arguments = const {},
    void Function(dynamic)? onChange,
  }) {
    this.onChange = onChange;
    return observer = _Observer();
  }
}

/// The change feed over the same fake store.
class _Service extends DittoCore with AccountingMixin {
  _Service(this.fake);
  final _Store? fake;
  @override
  dynamic get changeFeedStore => fake;
}

void main() {
  late _Store store;
  late DittoAccountingRepository repo;

  setUp(() {
    store = _Store()
      ..rows = [
        {'_id': 't1', 'subTotal': 100},
      ];
    repo = DittoAccountingRepository(_Service(store), store: () => store);
  });

  test('with no Ditto, reads return nothing', () async {
    final none = DittoAccountingRepository(_Service(null));
    expect(await none.fetchTransactions(branchId: 'b'), isEmpty);
    expect(
      await none.fetchTransactionItems(transactionIds: const ['t1']),
      isEmpty,
    );
    expect(await none.watchTransactions(branchId: 'b').toList(), isEmpty);
    expect(await repo.fetchTransactionItems(transactionIds: const []), isEmpty);
  });

  test('a period read ends at the last millisecond of its end day', () async {
    final rows = await repo.fetchTransactions(
      branchId: 'b',
      startDate: DateTime(2026, 11, 1),
      endDate: DateTime(2026, 11, 30, 9),
    );
    expect(rows.single['_id'], 't1');
    final (dql, args) = store.executed.single;
    expect(dql, contains('createdAt >= :start'));
    expect(dql, contains('createdAt <= :end'));
    expect(
      args['end'],
      DateTime(2026, 11, 30, 23, 59, 59, 999).toIso8601String(),
    );
  });

  test('items are read for every transaction id in one query', () async {
    await repo.fetchTransactionItems(transactionIds: const ['a', 'b']);
    final (dql, args) = store.executed.single;
    expect(dql, contains('transactionId IN (:id0, :id1)'));
    expect(args, {'id0': 'a', 'id1': 'b'});
  });

  test('watching reads once, then once per burst of changes', () async {
    final emitted = <List<Map<String, dynamic>>>[];
    final sub = repo
        .watchTransactions(
          branchId: 'b',
          startDate: DateTime(2026, 11, 1),
          endDate: DateTime(2026, 11, 30),
        )
        .listen(emitted.add);
    await pumpEventQueue();
    expect(emitted, hasLength(1));
    expect(store.executed.single.$1, contains('createdAt <= :end'));

    // A till completing sales: the observer only marks the rows stale.
    for (var i = 0; i < 5; i++) {
      store.onChange!(null);
    }
    await Future<void>.delayed(const Duration(milliseconds: 400));
    expect(emitted, hasLength(2));
    expect(store.executed, hasLength(2));

    await sub.cancel();
    expect(store.observer!.cancelled, isTrue);
  });

  test('watching every transaction reads with no date filter', () async {
    final sub = repo.watchTransactions(branchId: 'b').listen((_) {});
    await pumpEventQueue();
    expect(store.executed.single.$1, isNot(contains(':start')));
    expect(store.executed.single.$1, isNot(contains(':end')));
    await sub.cancel();
  });
}
