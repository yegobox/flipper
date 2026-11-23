import 'package:flipper_dashboard/utils/combo_sale_lines.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flutter_test/flutter_test.dart';

// flutter test test/utils/combo_sale_lines_test.dart --dart-define=FLUTTER_TEST_ENV=true
//
// A combo used to put 1 of each component on the cart whatever it needed, and
// to report the combo's own stock (a service: 0) as each component's
// remaining stock to RRA.

Variant _variant(String id, {String? stockId}) =>
    Variant(id: id, name: id, branchId: 'b1', stockId: stockId);

void main() {
  final variants = {
    'soda': _variant('soda', stockId: 'soda-s'),
    'bread': _variant('bread', stockId: 'bread-s'),
    'napkin': _variant('napkin'),
  };
  final stocks = {
    'soda-s': Stock(id: 'soda-s', branchId: 'b1', currentStock: 40),
    'bread-s': Stock(id: 'bread-s', branchId: 'b1', currentStock: 12),
  };

  test('each component at the combo\'s amount, with its own stock', () {
    final lines = planComboSaleLines(
      [
        Composite(productId: 'combo', variantId: 'soda', qty: 2),
        Composite(productId: 'combo', variantId: 'bread', qty: 1),
      ],
      variantsById: variants,
      stocksById: stocks,
    );
    expect(lines.map((l) => (l.variant.id, l.qty, l.currentStock)), [
      ('soda', 2.0, 40.0),
      ('bread', 1.0, 12.0),
    ]);
  });

  test('an unset or zero amount counts as one', () {
    final lines = planComboSaleLines(
      [
        Composite(productId: 'combo', variantId: 'soda'),
        Composite(productId: 'combo', variantId: 'bread', qty: 0),
      ],
      variantsById: variants,
      stocksById: stocks,
    );
    expect(lines.map((l) => l.qty), [1.0, 1.0]);
  });

  test('a deleted component is left out; no stock reads as zero', () {
    final lines = planComboSaleLines(
      [
        Composite(productId: 'combo', variantId: 'gone', qty: 1),
        Composite(productId: 'combo', variantId: 'napkin', qty: 3),
      ],
      variantsById: variants,
      stocksById: stocks,
    );
    expect(lines.single.variant.id, 'napkin');
    expect(lines.single.currentStock, 0);
  });
}
