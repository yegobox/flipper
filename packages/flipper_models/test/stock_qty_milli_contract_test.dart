import 'package:flipper_models/sync/utils/stock_qty_milli.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_models/brick/models/all_models.dart';

/// Stock quantity lives in two places: the `currentStock` register and the
/// `currentStockMilli` Ditto COUNTER. Readers prefer the COUNTER, so a write
/// that updates only the register is silently ignored — no error, just a stale
/// quantity. These pin the rules that keep the two in step.
void main() {
  group('milli scaling', () {
    test('round-trips fractional POS quantities', () {
      for (final qty in [0.0, 1.0, 2.5, 0.125, 999.999]) {
        expect(fromMilli(toMilli(qty)), closeTo(qty, 1e-9), reason: 'qty=$qty');
      }
    });

    test('rounds to three decimal places', () {
      expect(toMilli(2.5), 2500);
      expect(toMilli(0.0005), 1); // rounds up, not truncated to 0
    });
  });

  group('prep action decides seed vs reconcile', () {
    test('absent counter must be seeded', () {
      expect(
        stockMilliPrepAction(milli: null, registerQty: 5),
        StockMilliPrepAction.seed,
      );
    });

    test('counter matching the register needs nothing', () {
      expect(
        stockMilliPrepAction(milli: toMilli(5), registerQty: 5),
        StockMilliPrepAction.none,
      );
    });

    test('diverged counter reconciles from the register — register wins', () {
      // This is the case a document upsert creates: the register was
      // overwritten while the COUNTER kept its old value.
      expect(
        stockMilliPrepAction(milli: toMilli(2), registerQty: 9),
        StockMilliPrepAction.reconcileFromRegister,
      );
      expect(stockMilliAfterPrep(milli: toMilli(2), registerQty: 9), toMilli(9));
    });
  });

  group('counter parsing tolerates SDK shapes', () {
    test('reads plain ints, nums and strings', () {
      expect(parseStockMilli(2500), 2500);
      expect(parseStockMilli(2500.4), 2500);
      expect(parseStockMilli('2500'), 2500);
    });

    test('reads counters surfaced as a wrapper map', () {
      expect(parseStockMilli({'value': 2500}), 2500);
      expect(parseStockMilli({'counter': 2500}), 2500);
    });

    test('absent counter is null, not zero — zero would look like empty stock', () {
      expect(parseStockMilli(null), isNull);
      expect(parseStockMilli({}), isNull);
    });
  });

  group('deduct clamping', () {
    test('never takes on-hand below zero', () {
      expect(clampDeductMilli(availableMilli: 1000, deductMilli: 2500), 1000);
      expect(clampDeductMilli(availableMilli: 0, deductMilli: 500), 0);
      expect(clampDeductMilli(availableMilli: -5, deductMilli: 500), 0);
    });

    test('ignores non-positive deducts', () {
      expect(clampDeductMilli(availableMilli: 1000, deductMilli: 0), 0);
      expect(clampDeductMilli(availableMilli: 1000, deductMilli: -10), 0);
    });
  });

  group('the COUNTER field must never ride in an untyped document map', () {
    // Putting `currentStockMilli` in an `INSERT ... DOCUMENTS` map creates a
    // register with that name instead of a COUNTER, permanently breaking
    // INCREMENT for that document.
    test('Stock.toJson does not carry it', () {
      final doc = Stock(id: 's1', branchId: 'b1', currentStock: 5).toJson();
      expect(doc.containsKey(stockCurrentStockMilliField), isFalse);
      expect(doc['currentStock'], 5);
    });

    test('Variant.toFlipperJson does not carry it', () {
      final doc = Variant(id: 'v1', name: 'Sugar', branchId: 'b1')
          .toFlipperJson();
      expect(doc.containsKey(stockCurrentStockMilliField), isFalse);
    });
  });

  group('DQL declares the COUNTER', () {
    // STRICT_MODE rejects counter operations unless the statement declares
    // `COLLECTION stocks (currentStockMilli COUNTER)`.
    test('reads declare it', () {
      expect(
        stockSelectWithMilliDql(whereClause: '_id = :id'),
        contains('COLLECTION stocks ($stockCurrentStockMilliField COUNTER)'),
      );
    });

    test('restart and increment declare it', () {
      for (final dql in [stockRestartMilliDql(), stockIncrementMilliDql()]) {
        expect(
          dql,
          contains('COLLECTION stocks ($stockCurrentStockMilliField COUNTER)'),
        );
      }
    });

    test('the register dual-write does NOT declare it', () {
      // It only touches plain fields; declaring the counter there would be wrong.
      expect(
        stockDualWriteRegistersDql(),
        isNot(contains(stockCurrentStockMilliField)),
      );
      expect(stockDualWriteRegistersDql(), contains('currentStock'));
      expect(stockDualWriteRegistersDql(), contains('rsdQty'));
    });

    test('stock statements match on either _id or id', () {
      for (final dql in [stockRestartMilliDql(), stockIncrementMilliDql(),
                         stockDualWriteRegistersDql()]) {
        expect(dql, contains('_id = :stockId OR id = :stockId'));
      }
    });
  });
}
