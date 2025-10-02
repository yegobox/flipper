import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_models/brick/models/stock_recount_item.model.dart';

void main() {
  group('StockRecountItem Model Tests', () {
    late StockRecountItem item;

    setUp(() {
      item = StockRecountItem(
        recountId: 'recount123',
        variantId: 'variant456',
        stockId: 'stock789',
        productName: 'Coca Cola 500ml',
        previousQuantity: 50.0,
        countedQuantity: 75.0,
      );
    });

    test('should create a StockRecountItem with calculated difference', () {
      expect(item.id, isNotNull);
      expect(item.id.length, equals(36)); // UUID v4 format
      expect(item.recountId, equals('recount123'));
      expect(item.variantId, equals('variant456'));
      expect(item.stockId, equals('stock789'));
      expect(item.productName, equals('Coca Cola 500ml'));
      expect(item.previousQuantity, equals(50.0));
      expect(item.countedQuantity, equals(75.0));
      expect(item.difference, equals(25.0));
      expect(item.createdAt, isA<DateTime>());
      expect(item.notes, isNull);
    });

    test('should create with custom id', () {
      final customItem = StockRecountItem(
        id: 'custom-item-123',
        recountId: 'recount123',
        variantId: 'variant456',
        stockId: 'stock789',
        productName: 'Test Product',
      );
      expect(customItem.id, equals('custom-item-123'));
    });

    test('should automatically calculate positive difference', () {
      final positiveItem = StockRecountItem(
        recountId: 'recount123',
        variantId: 'variant456',
        stockId: 'stock789',
        productName: 'Product A',
        previousQuantity: 100.0,
        countedQuantity: 120.0,
      );

      expect(positiveItem.difference, equals(20.0));
    });
    test('should automatically calculate negative difference', () {
      final negativeItem = StockRecountItem(
        recountId: 'recount123',
        variantId: 'variant456',
        stockId: 'stock789',
        productName: 'Product B',
        previousQuantity: 100.0,
        countedQuantity: 80.0,
      );

      expect(negativeItem.difference, equals(-20.0));
    });

    test('should detect unchanged quantity', () {
      final unchangedItem = StockRecountItem(
        recountId: 'recount123',
        variantId: 'variant456',
        stockId: 'stock789',
        productName: 'Product C',
        previousQuantity: 50.0,
        countedQuantity: 50.0,
      );

      expect(unchangedItem.difference, equals(0.0));
    });
    test('should validate negative counted quantity', () {
      final invalidItem = StockRecountItem(
        recountId: 'recount123',
        variantId: 'variant456',
        stockId: 'stock789',
        productName: 'Product D',
        previousQuantity: 50.0,
        countedQuantity: -10.0,
      );

      final error = invalidItem.validate();
      expect(error, isNotNull);
      expect(error, contains('cannot be negative'));
    });

    test('should validate counted quantity below previous quantity', () {
      final invalidItem = StockRecountItem(
        recountId: 'recount123',
        variantId: 'variant456',
        stockId: 'stock789',
        productName: 'Product E',
        previousQuantity: 100.0,
        countedQuantity: 50.0,
      );

      final error = invalidItem.validate();
      expect(error, isNotNull);
      expect(error, contains('Cannot count below existing stock'));
      expect(error, contains('100.0'));
    });

    test('should validate successfully for valid counted quantity', () {
      final validItem = StockRecountItem(
        recountId: 'recount123',
        variantId: 'variant456',
        stockId: 'stock789',
        productName: 'Product F',
        previousQuantity: 50.0,
        countedQuantity: 75.0,
      );

      final error = validItem.validate();
      expect(error, isNull);
    });

    test('should validate successfully when counted equals previous', () {
      final validItem = StockRecountItem(
        recountId: 'recount123',
        variantId: 'variant456',
        stockId: 'stock789',
        productName: 'Product G',
        previousQuantity: 50.0,
        countedQuantity: 50.0,
      );

      final error = validItem.validate();
      expect(error, isNull);
    });

    test('should update count and recalculate difference', () {
      final updated = item.updateCount(100.0);

      expect(updated.previousQuantity, equals(50.0));
      expect(updated.countedQuantity, equals(100.0));
      expect(updated.difference, equals(50.0));
    });
    test('should maintain immutability when updating count', () {
      final updated = item.updateCount(90.0);

      // Original item unchanged
      expect(item.countedQuantity, equals(75.0));
      expect(item.difference, equals(25.0));

      // Updated item has new values
      expect(updated.countedQuantity, equals(90.0));
      expect(updated.difference, equals(40.0));

      // Other fields preserved
      expect(updated.id, equals(item.id));
      expect(updated.productName, equals(item.productName));
    });

    test('should create a copy with updated fields', () {
      final copy = item.copyWith(
        countedQuantity: 100.0,
        notes: 'Recounted twice',
      );

      expect(copy.id, equals(item.id));
      expect(copy.recountId, equals(item.recountId));
      expect(copy.countedQuantity, equals(100.0));
      expect(copy.notes, equals('Recounted twice'));
      expect(copy.previousQuantity, equals(item.previousQuantity));
    });

    test('should handle default values correctly', () {
      final defaultItem = StockRecountItem(
        recountId: 'recount123',
        variantId: 'variant456',
        stockId: 'stock789',
        productName: 'Product H',
      );

      expect(defaultItem.previousQuantity, equals(0.0));
      expect(defaultItem.countedQuantity, equals(0.0));
      expect(defaultItem.difference, equals(0.0));
    });
    test('should handle decimal quantities correctly', () {
      final decimalItem = StockRecountItem(
        recountId: 'recount123',
        variantId: 'variant456',
        stockId: 'stock789',
        productName: 'Product I',
        previousQuantity: 12.5,
        countedQuantity: 15.75,
      );

      expect(decimalItem.previousQuantity, equals(12.5));
      expect(decimalItem.countedQuantity, equals(15.75));
      expect(decimalItem.difference, equals(3.25));
    });

    test('should include productName for display purposes', () {
      expect(item.productName, equals('Coca Cola 500ml'));

      final copy = item.copyWith(productName: 'Pepsi 500ml');
      expect(copy.productName, equals('Pepsi 500ml'));
    });

    test('should handle notes field', () {
      final itemWithNotes = StockRecountItem(
        recountId: 'recount123',
        variantId: 'variant456',
        stockId: 'stock789',
        productName: 'Product J',
        notes: 'Damaged packaging found',
      );

      expect(itemWithNotes.notes, equals('Damaged packaging found'));

      final updated = itemWithNotes.copyWith(notes: 'Quality check passed');
      expect(updated.notes, equals('Quality check passed'));
    });

    test('should create UTC timestamps', () {
      expect(item.createdAt.isUtc, isTrue);
    });

    test('should preserve all IDs through copyWith', () {
      final copy = item.copyWith(countedQuantity: 80.0);

      expect(copy.id, equals(item.id));
      expect(copy.recountId, equals(item.recountId));
      expect(copy.variantId, equals(item.variantId));
      expect(copy.stockId, equals(item.stockId));
    });

    test('should handle large quantity differences', () {
      final largeItem = StockRecountItem(
        recountId: 'recount123',
        variantId: 'variant456',
        stockId: 'stock789',
        productName: 'Product K',
        previousQuantity: 1000.0,
        countedQuantity: 5000.0,
      );

      expect(largeItem.difference, equals(4000.0));
    });
    test('should validate edge case: zero previous quantity', () {
      final zeroItem = StockRecountItem(
        recountId: 'recount123',
        variantId: 'variant456',
        stockId: 'stock789',
        productName: 'Product L',
        previousQuantity: 0.0,
        countedQuantity: 10.0,
      );

      final error = zeroItem.validate();
      expect(error, isNull);
      expect(zeroItem.difference, equals(10.0));
    });

    test('should reject counting below zero when previous is zero', () {
      final invalidZeroItem = StockRecountItem(
        recountId: 'recount123',
        variantId: 'variant456',
        stockId: 'stock789',
        productName: 'Product M',
        previousQuantity: 0.0,
        countedQuantity: -5.0,
      );

      final error = invalidZeroItem.validate();
      expect(error, isNotNull);
      expect(error, contains('cannot be negative'));
    });
  });
}
