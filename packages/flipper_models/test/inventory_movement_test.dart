import 'package:flipper_models/helpers/inventory_movement.dart';
import 'package:flutter_test/flutter_test.dart';

/// Movement figures replace the old `initialStock - currentStock` guess, so the
/// derived numbers (runway, sell-through, available stock) are worth pinning.
void main() {
  VariantMovement movement({
    double unitsSold = 0,
    double revenue = 0,
    double profit = 0,
    double adjustment = 0,
    double? openingStock,
    double? restocked,
    double? lastRemainingStock,
  }) {
    return VariantMovement(
      variantId: 'v1',
      unitsSold: unitsSold,
      unitsRefunded: 0,
      revenue: revenue,
      profit: profit,
      saleCount: 1,
      lastSoldAt: null,
      adjustment: adjustment,
      lastCountedAt: null,
      openingStock: openingStock,
      restocked: restocked,
      lastRemainingStock: lastRemainingStock,
    );
  }

  group('velocity and runway', () {
    test('velocity spreads units over the window', () {
      final m = movement(unitsSold: 60);
      expect(m.velocityPerDay(30), 2);
    });

    test('days of cover divides live stock by the measured pace', () {
      final m = movement(unitsSold: 60);
      expect(m.daysOfCover(30, 30), 15);
    });

    test('no sales means no pace to judge, not zero runway', () {
      expect(movement().daysOfCover(40, 30), isNull);
      expect(movement().velocityPerDay(30), 0);
    });
  });

  group('available stock and sell-through', () {
    test('available stock is opening plus everything received', () {
      final m = movement(
        unitsSold: 30,
        openingStock: 50,
        restocked: 20,
        lastRemainingStock: 10,
      );
      // 50 opening + 20 received between sales + 5 received after the last sale.
      expect(m.availableInWindow(15), 75);
      expect(m.sellThrough(15), closeTo(30 / 75, 0.0001));
    });

    test('receipts after the last sale are inferred from live stock', () {
      final m = movement(
        unitsSold: 10,
        openingStock: 20,
        restocked: 0,
        lastRemainingStock: 10,
      );
      expect(m.availableInWindow(30), 40);
    });

    test('stock lower than the last reading is not treated as a receipt', () {
      final m = movement(
        unitsSold: 10,
        openingStock: 20,
        restocked: 0,
        lastRemainingStock: 10,
      );
      expect(m.availableInWindow(4), 20);
    });

    test('without a ledger it falls back to sold against stock on hand', () {
      final m = movement(unitsSold: 25);
      expect(m.availableInWindow(75), isNull);
      expect(m.sellThrough(75), closeTo(0.25, 0.0001));
      expect(m.hasLedger, isFalse);
    });

    test('sell-through never exceeds 100%', () {
      final m = movement(unitsSold: 100, openingStock: 10, restocked: 0);
      expect(m.sellThrough(0), 1);
    });
  });

  group('adjustments', () {
    test('a shortfall at count is reported as shrink', () {
      expect(movement(adjustment: -7).shrink, 7);
    });

    test('extra stock found at count is not shrink', () {
      expect(movement(adjustment: 4).shrink, 0);
    });
  });

  test('margin is profit over revenue and safe at zero revenue', () {
    expect(movement(revenue: 1000, profit: 250).margin, closeTo(0.25, 0.0001));
    expect(movement().margin, 0);
  });

  group('window range', () {
    test('today is a single inclusive day', () {
      final range = inventoryWindowRange(InventoryWindow.today);
      expect(range.start.hour, 0);
      expect(range.end.hour, 23);
      expect(range.end.difference(range.start).inHours, lessThan(24));
    });

    test('a 30 day window spans 30 inclusive days', () {
      final range = inventoryWindowRange(InventoryWindow.days30);
      expect(range.end.difference(range.start).inDays, 29);
      expect(InventoryWindow.days30.days, 30);
    });
  });
}
