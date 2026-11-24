import 'dart:async';

import 'package:flipper_models/DatabaseSyncInterface.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/sync/utils/combo_stock_lines.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// flutter test test/combo_stock_lines_test.dart
//
// A combo sells as ONE line at its own price (a service, no stock). Its
// components' stock moves when the sale is paid or refunded, so every stock
// path sees the combo line as its component lines.

class _MockDb extends Mock implements DatabaseSyncInterface {}

TransactionItem _line(
  String id, {
  String? productId,
  String? variantId,
  String itemTyCd = '2',
  num qty = 1,
  int? shipped,
}) => TransactionItem(
  id: id,
  name: id,
  transactionId: 't1',
  branchId: 'b1',
  productId: productId,
  variantId: variantId ?? id,
  itemTyCd: itemTyCd,
  qty: qty,
  price: 1500,
  prc: 1500,
  discount: 0,
  ttCatCd: null,
  quantityShipped: shipped,
);

Variant _variant(String id, {String? productId, String itemTyCd = '2'}) =>
    Variant(
      id: id,
      name: id,
      branchId: 'b1',
      productId: productId ?? 'p-$id',
      itemTyCd: itemTyCd,
      itemCd: 'RW2NTU$id',
      retailPrice: 500,
      supplyPrice: 300,
      taxTyCd: 'B',
    );

void main() {
  final soda = _variant('soda');
  final bread = _variant('bread');
  final components = [
    Composite(productId: 'combo', variantId: 'soda', qty: 2),
    Composite(productId: 'combo', variantId: 'bread'),
  ];

  group('expandComboLines', () {
    test('a combo line becomes its components; others stay as they are', () {
      final combo = _line('c1', productId: 'combo', itemTyCd: '3', qty: 3);
      final plain = _line('tea', productId: 'p-tea');
      final out = expandComboLines(
        [plain, combo],
        productIdOf: (l) => l.productId,
        componentsByProductId: {'combo': components},
        variantsById: {'soda': soda, 'bread': bread},
      );
      expect(out.map((l) => (l.variantId, l.qty)), [
        ('tea', 1),
        ('soda', 6.0),
        ('bread', 3.0),
      ]);
      final sodaLine = out[1];
      expect(sodaLine.id, comboComponentLineId('c1', 'soda'));
      expect(comboLineIdOf(sodaLine.id), 'c1');
      expect(comboLineIdOf('tea'), isNull);
      expect(sodaLine.itemTyCd, '2');
      expect(sodaLine.itemCd, 'RW2NTUsoda');
      expect(sodaLine.prc, 500);
      expect(sodaLine.supplyPrice, 300);
      expect(sodaLine.transactionId, 't1');
    });

    test('a component line carries its tax, as a goods sale line does', () {
      // The saveStockItems envelope sums each line's taxAmt; without it a
      // taxable component added no VAT to the stock-out report.
      final out = expandComboLines(
        [_line('c1', productId: 'combo', itemTyCd: '3', qty: 3)],
        productIdOf: (l) => l.productId,
        componentsByProductId: {'combo': components},
        variantsById: {
          'soda': soda,
          'bread': _variant('bread')
            ..taxTyCd = 'D'
            ..taxPercentage = 0,
        },
      );
      // 6 sodas x 500, tax-inclusive B at 18%: 3000 * 18 / 118.
      expect(out[0].taxAmt, 457.63);
      expect(out[1].taxAmt, 0);
    });

    test('a component counts as deducted exactly when its combo line does', () {
      List<int?> shipped(TransactionItem combo) => expandComboLines(
        [combo],
        productIdOf: (l) => l.productId,
        componentsByProductId: {'combo': components},
        variantsById: {'soda': soda, 'bread': bread},
      ).map((l) => l.quantityShipped).toList();

      expect(shipped(_line('c1', productId: 'combo', itemTyCd: '3', qty: 2)), [
        0,
        0,
      ]);
      expect(
        shipped(
          _line('c1', productId: 'combo', itemTyCd: '3', qty: 2, shipped: 2),
        ),
        [4, 2],
      );
    });

    test('a goods line of a combo product is not expanded (made ahead)', () {
      final made = _line('c1', productId: 'combo', itemTyCd: '2');
      final out = expandComboLines(
        [made],
        productIdOf: (l) => l.productId,
        componentsByProductId: {'combo': components},
        variantsById: {'soda': soda, 'bread': bread},
      );
      expect(out.single.id, 'c1');
    });

    test('a component whose variant is gone is left out', () {
      final out = expandComboLines(
        [_line('c1', productId: 'combo', itemTyCd: '3')],
        productIdOf: (l) => l.productId,
        componentsByProductId: {'combo': components},
        variantsById: {'bread': bread},
      );
      expect(out.single.variantId, 'bread');
    });
  });

  test('saleLinesToMarkShipped marks a combo line once, real lines as is', () {
    final combo = _line('c1', productId: 'combo', itemTyCd: '3');
    final tea = _line('tea');
    final marked = saleLinesToMarkShipped(
      [
        tea,
        _line(comboComponentLineId('c1', 'soda')),
        _line(comboComponentLineId('c1', 'bread')),
        _line(comboComponentLineId('gone', 'soda')),
      ],
      {'c1': combo, 'tea': tea},
    );
    expect(marked.map((l) => l.id), ['tea', 'c1']);
  });

  group('expandComboLinesForStock', () {
    late _MockDb db;

    setUp(() {
      db = _MockDb();
      when(
        () => db.getProduct(id: 'combo', branchId: 'b1', businessId: 'biz1'),
      ).thenAnswer(
        (_) async => Product(
          id: 'combo',
          name: 'Breakfast',
          color: '#000',
          businessId: 'biz1',
          branchId: 'b1',
          isComposite: true,
        ),
      );
      when(
        () => db.getProduct(id: 'delivery', branchId: 'b1', businessId: 'biz1'),
      ).thenAnswer(
        (_) async => Product(
          id: 'delivery',
          name: 'Delivery',
          color: '#000',
          businessId: 'biz1',
          branchId: 'b1',
        ),
      );
      when(
        () => db.composites(productId: 'combo', localOnly: true),
      ).thenAnswer((_) async => components);
      when(
        () => db.batchGetVariantsByIds(any()),
      ).thenAnswer((_) async => {'soda': soda, 'bread': bread});
    });

    test(
      'expands a combo; a plain service is never looked up for parts',
      () async {
        final out = await expandComboLinesForStock(
          [
            _line('c1', productId: 'combo', itemTyCd: '3'),
            _line('fee', productId: 'delivery', itemTyCd: '3'),
          ],
          capella: db,
          businessId: 'biz1',
          branchId: 'b1',
        );
        expect(out.map((l) => l.variantId), ['soda', 'bread', 'fee']);
        verifyNever(() => db.composites(productId: 'delivery'));
        // On the Pay path: never a network read for the components.
        verify(
          () => db.composites(productId: 'combo', localOnly: true),
        ).called(1);
      },
    );

    test('a sale with no service lines reads nothing', () async {
      final lines = [_line('tea')];
      final out = await expandComboLinesForStock(
        lines,
        capella: db,
        businessId: 'biz1',
        branchId: 'b1',
      );
      expect(out, same(lines));
      verifyZeroInteractions(db);
    });

    test('a line without a product id finds it through its variant', () async {
      when(() => db.batchGetVariantsByIds(['combo-v'])).thenAnswer(
        (_) async => {
          'combo-v': _variant('combo-v', productId: 'combo', itemTyCd: '3'),
        },
      );
      final out = await expandComboLinesForStock(
        [_line('c1', variantId: 'combo-v', itemTyCd: '3')],
        capella: db,
        businessId: 'biz1',
        branchId: 'b1',
      );
      expect(out.map((l) => l.variantId), ['soda', 'bread']);
    });

    test('a local hit never reads the server', () async {
      await expandComboLinesForStock(
        [_line('c1', productId: 'combo', itemTyCd: '3')],
        capella: db,
        businessId: 'biz1',
        branchId: 'b1',
      );
      verifyNever(() => db.composites(productId: 'combo', localOnly: false));
    });

    test(
      'a combo with no local rows fetches them from the server once',
      () async {
        // A combo made before #587 on a fresh till: no rows here yet.
        when(
          () => db.composites(productId: 'combo', localOnly: true),
        ).thenAnswer((_) async => <Composite>[]);
        when(
          () => db.composites(productId: 'combo', localOnly: false),
        ).thenAnswer((_) async => components);
        final out = await expandComboLinesForStock(
          [_line('c1', productId: 'combo', itemTyCd: '3')],
          capella: db,
          businessId: 'biz1',
          branchId: 'b1',
        );
        expect(out.map((l) => l.variantId), ['soda', 'bread']);
        verify(
          () => db.composites(productId: 'combo', localOnly: false),
        ).called(1);
      },
    );

    test('a server fetch that hangs is cut off; the sale goes on', () async {
      when(
        () => db.composites(productId: 'combo', localOnly: true),
      ).thenAnswer((_) async => <Composite>[]);
      when(
        () => db.composites(productId: 'combo', localOnly: false),
      ).thenAnswer((_) => Completer<List<Composite>>().future);
      final lines = [_line('c1', productId: 'combo', itemTyCd: '3')];
      final out = await expandComboLinesForStock(
        lines,
        capella: db,
        businessId: 'biz1',
        branchId: 'b1',
        remoteTimeout: const Duration(milliseconds: 10),
      );
      // Nothing to expand: the combo line passes through unchanged.
      expect(out, same(lines));
    });

    test('a server fetch that fails leaves the combo line as is', () async {
      when(
        () => db.composites(productId: 'combo', localOnly: true),
      ).thenAnswer((_) async => <Composite>[]);
      when(
        () => db.composites(productId: 'combo', localOnly: false),
      ).thenThrow(Exception('offline'));
      final lines = [_line('c1', productId: 'combo', itemTyCd: '3')];
      final out = await expandComboLinesForStock(
        lines,
        capella: db,
        businessId: 'biz1',
        branchId: 'b1',
      );
      expect(out, same(lines));
    });

    test('the server bound defaults to 5 seconds', () {
      expect(comboComponentsRemoteTimeout, const Duration(seconds: 5));
    });
  });
}
