import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/sync/utils/rra_stock_reporting.dart';
import 'package:flipper_services/constants.dart';
import 'package:flutter_test/flutter_test.dart';

TransactionItem _line({
  required String id,
  required String variantId,
  required num qty,
  String itemTyCd = '2',
}) {
  return TransactionItem(
    id: id,
    name: 'Product',
    qty: qty,
    price: 100,
    discount: 0,
    prc: 100,
    ttCatCd: 'A',
    variantId: variantId,
    itemTyCd: itemTyCd,
    itemNm: 'Product',
  );
}

void main() {
  group('decodeRraSaleStockSnapshot', () {
    test('parses JSON map with string keys', () {
      expect(
        decodeRraSaleStockSnapshot('{"sid1": 1.5}'),
        equals({'sid1': 1.5}),
      );
    });

    test('returns null on invalid input', () {
      expect(decodeRraSaleStockSnapshot(null), isNull);
      expect(decodeRraSaleStockSnapshot(''), isNull);
      expect(decodeRraSaleStockSnapshot('[]'), isNull);
    });
  });

  group('rraAllocatedQtyByTransactionItemId', () {
    test('no cap: passes through line qty', () {
      final stockId = 's1';
      final item = _line(id: 'l1', variantId: 'va', qty: 2);
      final map = {'va': Variant(name: 'V', branchId: 'b', stockId: stockId)};
      final snap = {stockId: 1.0};

      final alloc = rraAllocatedQtyByTransactionItemId(
        items: [item],
        variantsByVariantId: map,
        snapshotByStockId: snap,
        allowSellingBelowStock: false,
      );
      expect(alloc['l1'], 2);
    });

    test('sell 2 with 1 on hand: allocates 1 to RRA', () {
      final item = _line(id: 'l1', variantId: 'va', qty: 2);
      final map = {'va': Variant(name: 'V', branchId: 'b', stockId: 's1')};

      final alloc = rraAllocatedQtyByTransactionItemId(
        items: [item],
        variantsByVariantId: map,
        snapshotByStockId: {'s1': 1},
        allowSellingBelowStock: true,
      );
      expect(alloc['l1'], 1);
    });

    test('two lines same stock, 1 available: first line takes 1 second 0', () {
      final item1 = _line(id: 'l1', variantId: 'va', qty: 1);
      final item2 = _line(id: 'l2', variantId: 'vb', qty: 1);
      final map = {
        'va': Variant(name: 'A', branchId: 'b', stockId: 's1'),
        'vb': Variant(name: 'B', branchId: 'b', stockId: 's1'),
      };

      final alloc = rraAllocatedQtyByTransactionItemId(
        items: [item1, item2],
        variantsByVariantId: map,
        snapshotByStockId: {'s1': 1},
        allowSellingBelowStock: true,
      );
      expect(alloc['l1'], 1);
      expect(alloc['l2'], 0);
    });

    test('service line gets 0', () {
      final item = _line(id: 'l1', variantId: 'va', qty: 5, itemTyCd: '3');
      final map = {'va': Variant(name: 'S', branchId: 'b', stockId: 's1')};

      final alloc = rraAllocatedQtyByTransactionItemId(
        items: [item],
        variantsByVariantId: map,
        snapshotByStockId: {'s1': 10},
        allowSellingBelowStock: true,
      );
      expect(alloc['l1'], 0);
    });
  });

  group('movementItemsWithRraCapAllocation', () {
    test('drops zero-allocated lines', () {
      final item = _line(id: 'l1', variantId: 'va', qty: 2);
      final capped = movementItemsWithRraCapAllocation([item], const {'l1': 0});
      expect(capped, isEmpty);
    });
  });

  group('resolvePostSaleInvoiceNo', () {
    test('prefers invoiceNumber then receipt fallbacks', () {
      expect(
        resolvePostSaleInvoiceNo(
          invoiceNumber: 42,
          receiptNumber: 10,
        ),
        42,
      );
      expect(
        resolvePostSaleInvoiceNo(
          receiptNumber: 10,
          totalReceiptNumber: 9,
        ),
        10,
      );
      expect(resolvePostSaleInvoiceNo(), isNull);
    });
  });

  group('resolveRraStockIoSarTyCd', () {
    test('defaults NS/CS to outgoing sale', () {
      expect(
        resolveRraStockIoSarTyCd(receiptType: 'NS'),
        StockInOutType.sale,
      );
      expect(
        resolveRraStockIoSarTyCd(receiptType: 'CS'),
        StockInOutType.sale,
      );
    });

    test('uses explicit sarTyCd when provided', () {
      expect(
        resolveRraStockIoSarTyCd(sarTyCd: '06', receiptType: 'NS'),
        '06',
      );
    });

    test('NR/TR use return-in code', () {
      expect(
        resolveRraStockIoSarTyCd(receiptType: 'NR'),
        StockInOutType.returnIn,
      );
    });
  });
}
