import 'package:flipper_dashboard/utils/stock_validator.dart';
import 'package:flutter_test/flutter_test.dart';

/// Pure aggregation logic mirrored from [validateStockQuantity] for unit tests
/// without Capella I/O.
List<String> outOfStockItemIdsForSharedStock({
  required Map<String, double> requestedByStockId,
  required Map<String, double> onHandByStockId,
  required Map<String, List<String>> itemIdsByStockId,
}) {
  final out = <String>[];
  final seen = <String>{};
  for (final entry in requestedByStockId.entries) {
    final onHand = onHandByStockId[entry.key];
    if (onHand == null) continue;
    if (onHand + 0.0001 >= entry.value) continue;
    for (final id in itemIdsByStockId[entry.key] ?? const <String>[]) {
      if (seen.add(id)) out.add(id);
    }
  }
  return out;
}

void main() {
  test(
    'validateStockQuantity returns empty when allowSellingBelowStock is true',
    () async {
      final out =
          await validateStockQuantity([], allowSellingBelowStock: true);
      expect(out, isEmpty);
    },
  );

  test('shared stockId: combined qty oversell flags every line', () {
    final ids = outOfStockItemIdsForSharedStock(
      requestedByStockId: {'s1': 12},
      onHandByStockId: {'s1': 10},
      itemIdsByStockId: {
        's1': ['a', 'b'],
      },
    );
    expect(ids, ['a', 'b']);
  });

  test('shared stockId: combined qty within on-hand flags none', () {
    final ids = outOfStockItemIdsForSharedStock(
      requestedByStockId: {'s1': 8},
      onHandByStockId: {'s1': 10},
      itemIdsByStockId: {
        's1': ['a', 'b'],
      },
    );
    expect(ids, isEmpty);
  });
}
