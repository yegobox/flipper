import 'package:flipper_models/helpers/average_cost.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AverageCost.applyReceipt', () {
    test('the first receipt seeds the average from supplyPrice', () {
      // Existing inventory needs no migration: the price last paid becomes the
      // opening average the first time the variant receives stock.
      final avg = AverageCost.applyReceipt(
        avgCost: null,
        supplyPrice: 100,
        qtyOnHand: 10,
        qtyReceived: 10,
        receiptUnitCost: 120,
      );
      expect(avg, 110); // (100*10 + 120*10) / 20
    });

    test('a later receipt blends against the running average, not supplyPrice', () {
      // Once seeded, supplyPrice is irrelevant to costing — it keeps meaning
      // "last price paid" for RRA and display only.
      final avg = AverageCost.applyReceipt(
        avgCost: 110,
        supplyPrice: 999,
        qtyOnHand: 20,
        qtyReceived: 20,
        receiptUnitCost: 130,
      );
      expect(avg, 120); // (110*20 + 130*20) / 40
    });

    test('weights by quantity, not by number of receipts', () {
      final avg = AverageCost.applyReceipt(
        avgCost: 100,
        supplyPrice: null,
        qtyOnHand: 90,
        qtyReceived: 10,
        receiptUnitCost: 200,
      );
      expect(avg, 110); // (100*90 + 200*10) / 100
    });

    test('no stock on hand means the receipt sets the average outright', () {
      final avg = AverageCost.applyReceipt(
        avgCost: 100,
        supplyPrice: null,
        qtyOnHand: 0,
        qtyReceived: 5,
        receiptUnitCost: 250,
      );
      expect(avg, 250);
    });

    test('negative stock on hand is clamped, not trusted', () {
      // An oversold variant would otherwise invert the weighting.
      final avg = AverageCost.applyReceipt(
        avgCost: 100,
        supplyPrice: null,
        qtyOnHand: -30,
        qtyReceived: 10,
        receiptUnitCost: 200,
      );
      expect(avg, 200);
    });

    test('an uncosted receipt leaves the average alone, never zeroes it', () {
      // variant.model.dart coerces a missing cost to 0.0, so callers do hand us
      // a zero that means "unknown". Treating it as free would drag the average
      // down on every such receipt.
      for (final bad in <double?>[null, 0, -5]) {
        expect(
          AverageCost.applyReceipt(
            avgCost: 110,
            supplyPrice: 100,
            qtyOnHand: 10,
            qtyReceived: 10,
            receiptUnitCost: bad,
          ),
          110,
          reason: 'receiptUnitCost $bad must not move the average',
        );
      }
    });

    test('a non-receipt leaves the average alone', () {
      // Sales, returns out and corrections do not re-cost inventory under a
      // moving average — only goods coming in do.
      for (final qty in <double>[0, -10]) {
        expect(
          AverageCost.applyReceipt(
            avgCost: 110,
            supplyPrice: 100,
            qtyOnHand: 10,
            qtyReceived: qty,
            receiptUnitCost: 500,
          ),
          110,
          reason: 'qtyReceived $qty is not a receipt',
        );
      }
    });

    test('a variant with no cost at all takes the receipt price', () {
      final avg = AverageCost.applyReceipt(
        avgCost: null,
        supplyPrice: null,
        qtyOnHand: 10,
        qtyReceived: 10,
        receiptUnitCost: 75,
      );
      expect(avg, 75);
    });

    test('repeated receipts at one price converge on that price', () {
      double? avg = 100;
      for (var i = 0; i < 20; i++) {
        avg = AverageCost.applyReceipt(
          avgCost: avg,
          supplyPrice: null,
          qtyOnHand: 10,
          qtyReceived: 10,
          receiptUnitCost: 200,
        );
      }
      expect(avg, closeTo(200, 0.01));
    });
  });

  group('AverageCost.unitCost', () {
    test('prefers the average once it exists', () {
      expect(AverageCost.unitCost(avgCost: 110, supplyPrice: 100), 110);
    });

    test('falls back to supplyPrice before the first receipt', () {
      // Behaviour is unchanged for a variant that has never received stock.
      expect(AverageCost.unitCost(avgCost: null, supplyPrice: 100), 100);
      expect(AverageCost.unitCost(avgCost: 0, supplyPrice: 100), 100);
    });

    test('returns null when neither is usable, rather than zero', () {
      // Zero would silently book a sale at no cost and overstate gross profit.
      expect(AverageCost.unitCost(avgCost: null, supplyPrice: null), isNull);
      expect(AverageCost.unitCost(avgCost: 0, supplyPrice: 0), isNull);
    });
  });
}
