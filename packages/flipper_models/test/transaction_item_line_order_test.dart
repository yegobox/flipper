import 'package:flipper_models/helpers/transaction_item_line_order.dart';
import 'package:supabase_models/brick/models/transactionItem.model.dart';
import 'package:flutter_test/flutter_test.dart';

TransactionItem _line({
  required String id,
  required String name,
  required DateTime createdAt,
  DateTime? updatedAt,
  DateTime? lastTouched,
  int? itemSeq,
}) {
  return TransactionItem(
    id: id,
    name: name,
    price: 100,
    qty: 1,
    discount: 0,
    prc: 100,
    ttCatCd: 'A',
    createdAt: createdAt,
    updatedAt: updatedAt ?? createdAt,
    lastTouched: lastTouched,
    itemSeq: itemSeq,
  );
}

void main() {
  group('sortTransactionItemLinesNewestFirst', () {
    test('orders by updatedAt DESC like QuickSellingView', () {
      final ordered = sortTransactionItemLinesNewestFirst([
        _line(
          id: 'a',
          name: 'FABLE009',
          createdAt: DateTime(2026, 7, 13, 18, 1),
          updatedAt: DateTime(2026, 7, 13, 18, 1),
          itemSeq: 99,
        ),
        _line(
          id: 'b',
          name: 'FABLE',
          createdAt: DateTime(2026, 7, 13, 18, 2),
          updatedAt: DateTime(2026, 7, 13, 18, 2),
          itemSeq: 1,
        ),
        _line(
          id: 'c',
          name: 'PAIN COUPE',
          createdAt: DateTime(2026, 7, 13, 18, 3),
          updatedAt: DateTime(2026, 7, 13, 18, 3),
          itemSeq: 2,
        ),
      ]);
      expect(ordered.map((i) => i.name).toList(), [
        'PAIN COUPE',
        'FABLE',
        'FABLE009',
      ]);
    });

    test('uses createdAt DESC when touch times tie (not itemSeq)', () {
      final touch = DateTime(2026, 7, 13, 18, 5);
      final ordered = sortTransactionItemLinesNewestFirst([
        _line(
          id: 'a',
          name: 'OLD',
          createdAt: DateTime(2026, 7, 13, 10),
          updatedAt: touch,
          itemSeq: 99,
        ),
        _line(
          id: 'b',
          name: 'NEW',
          createdAt: DateTime(2026, 7, 13, 18),
          updatedAt: touch,
          itemSeq: 1,
        ),
      ]);
      expect(ordered.map((i) => i.name).toList(), ['NEW', 'OLD']);
    });

    test('re-tap bumps line to top via updatedAt', () {
      final ordered = sortTransactionItemLinesNewestFirst([
        _line(
          id: 'first',
          name: 'FABLE009',
          createdAt: DateTime(2026, 7, 13, 10),
          updatedAt: DateTime(2026, 7, 13, 18, 30),
        ),
        _line(
          id: 'last',
          name: 'PAIN COUPE',
          createdAt: DateTime(2026, 7, 13, 18),
          updatedAt: DateTime(2026, 7, 13, 18),
        ),
      ]);
      expect(ordered.map((i) => i.name).toList(), [
        'FABLE009',
        'PAIN COUPE',
      ]);
    });

    test('ignores itemSeq when updatedAt already preserves cart order', () {
      final ordered = sortTransactionItemLinesNewestFirst([
        _line(
          id: 'a',
          name: 'FABLE009',
          createdAt: DateTime(2026, 7, 13, 18, 1),
          updatedAt: DateTime(2026, 7, 13, 18, 1),
          itemSeq: 1,
        ),
        _line(
          id: 'b',
          name: 'FABLE',
          createdAt: DateTime(2026, 7, 13, 18, 2),
          updatedAt: DateTime(2026, 7, 13, 18, 2),
          itemSeq: 2,
        ),
        _line(
          id: 'c',
          name: 'PAIN COUPE',
          createdAt: DateTime(2026, 7, 13, 18, 3),
          updatedAt: DateTime(2026, 7, 13, 18, 3),
          itemSeq: 99,
        ),
      ]);
      expect(ordered.map((i) => i.name).toList(), [
        'PAIN COUPE',
        'FABLE',
        'FABLE009',
      ]);
    });
  });
}
