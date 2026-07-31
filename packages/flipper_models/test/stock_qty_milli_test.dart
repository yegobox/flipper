import 'package:flipper_models/sync/utils/stock_qty_milli.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('stock_qty_milli', () {
    test('2.5 kg → 2500 milli and back', () {
      expect(toMilli(2.5), 2500);
      expect(fromMilli(2500), 2.5);
    });

    test('0.01 and whole units round-trip', () {
      expect(toMilli(0.01), 10);
      expect(fromMilli(10), 0.01);
      expect(toMilli(10), 10000);
      expect(fromMilli(10000), 10.0);
    });

    test('parseStockMilli handles int, num, string, nested map', () {
      expect(parseStockMilli(2500), 2500);
      expect(parseStockMilli(2500.4), 2500);
      expect(parseStockMilli('2500'), 2500);
      expect(parseStockMilli({'value': 2500}), 2500);
      expect(parseStockMilli(null), isNull);
    });

    test('prep: seed when milli missing', () {
      expect(
        stockMilliPrepAction(milli: null, registerQty: 11),
        StockMilliPrepAction.seed,
      );
    });

    test('prep: reconcile when old till moved register', () {
      expect(
        stockMilliPrepAction(milli: 11000, registerQty: 10),
        StockMilliPrepAction.reconcileFromRegister,
      );
    });

    test('prep: none when aligned', () {
      expect(
        stockMilliPrepAction(milli: 11000, registerQty: 11),
        StockMilliPrepAction.none,
      );
    });

    test('clampDeductMilli never exceeds on-hand', () {
      expect(
        clampDeductMilli(availableMilli: 500, deductMilli: 800),
        500,
      );
      expect(
        clampDeductMilli(availableMilli: 500, deductMilli: 200),
        200,
      );
      expect(
        clampDeductMilli(availableMilli: 0, deductMilli: 100),
        0,
      );
    });

    test('DQL builders declare COUNTER field', () {
      expect(
        stockSelectWithMilliDql(whereClause: '_id = :id'),
        contains('COLLECTION stocks (currentStockMilli COUNTER)'),
      );
      expect(stockRestartMilliDql(), contains('RESTART WITH :milli'));
      expect(stockIncrementMilliDql(), contains('INCREMENT BY :delta'));
      expect(stockDualWriteRegistersDql(), contains('currentStock = :currentStock'));
      expect(stockIncrementMilliDql(), isNot(contains('currentStock -')));
    });

    test('seedStockMilliIfAbsent seeds only when field missing', () async {
      final calls = <String>[];
      final store = _FakeStore(
        onExecute: (query, args) async {
          calls.add(query.contains('SELECT') ? 'select' : 'restart');
          if (query.contains('SELECT')) {
            return _FakeResult([
              {
                '_id': 's1',
                'currentStock': 11.0,
                // no currentStockMilli
              },
            ]);
          }
          return _FakeResult([]);
        },
      );
      await seedStockMilliIfAbsentOnStore(store, stockId: 's1', qty: 11);
      expect(calls, ['select', 'restart']);

      calls.clear();
      final storePresent = _FakeStore(
        onExecute: (query, args) async {
          calls.add(query.contains('SELECT') ? 'select' : 'restart');
          return _FakeResult([
            {
              '_id': 's1',
              'currentStock': 11.0,
              'currentStockMilli': 11000,
            },
          ]);
        },
      );
      await seedStockMilliIfAbsentOnStore(storePresent, stockId: 's1', qty: 11);
      expect(calls, ['select']);
    });
  });
}

class _FakeResult {
  _FakeResult(this._docs);
  final List<Map<String, dynamic>> _docs;
  List<_FakeItem> get items =>
      _docs.map((d) => _FakeItem(d)).toList(growable: false);
}

class _FakeItem {
  _FakeItem(this.value);
  final Map<String, dynamic> value;
}

class _FakeStore {
  _FakeStore({required this.onExecute});
  final Future<_FakeResult> Function(String query, Map<String, dynamic>? args)
      onExecute;

  Future<_FakeResult> execute(
    String query, {
    Map<String, dynamic>? arguments,
  }) =>
      onExecute(query, arguments);
}
