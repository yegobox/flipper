/// Moving weighted-average inventory cost.
///
/// `variant.supplyPrice` holds the LAST price paid. Valuing inventory and COGS
/// at that price behaves like replacement cost, which IAS 2 does not permit —
/// it allows only FIFO or weighted average. This is the weighted-average half.
///
/// Only **receipts** move the average. A sale relieves stock at whatever the
/// average is at that moment and leaves it unchanged, which is what makes the
/// cost stamped onto a sale line historical and immutable: nothing later
/// rewrites the COGS of a sale already posted.
///
/// The opening average is seeded lazily from `supplyPrice` the first time a
/// variant receives stock, so existing inventory needs no migration and no
/// past period is restated.
library;

class AverageCost {
  const AverageCost._();

  /// The unit cost to use for valuation and for stamping onto a sale line.
  ///
  /// Falls back to `supplyPrice` for a variant that has never received stock
  /// since this feature shipped — the same number it would have used before,
  /// so behaviour only improves as receipts arrive.
  static double? unitCost({double? avgCost, double? supplyPrice}) {
    if (avgCost != null && avgCost > 0) return avgCost;
    if (supplyPrice != null && supplyPrice > 0) return supplyPrice;
    return null;
  }

  /// Blends a receipt into the running average and returns the new average.
  ///
  /// Returns [avgCost] unchanged — never zero — when the receipt cannot be
  /// costed, because a missing cost is unknown, not free. Several callers hand
  /// us a `0.0` that really means null (`variant.model.dart` coerces a missing
  /// cost that way), and letting that through would drag the average down on
  /// every such receipt.
  static double? applyReceipt({
    required double? avgCost,
    required double? supplyPrice,
    required double qtyOnHand,
    required double qtyReceived,
    required double? receiptUnitCost,
  }) {
    // Not a receipt. Returns, transfers out and corrections must not touch the
    // average: only goods coming in at a known price change it.
    if (qtyReceived <= 0) return avgCost;

    // Unknown cost — leave the average where it was.
    if (receiptUnitCost == null || receiptUnitCost <= 0) return avgCost;

    final opening = unitCost(avgCost: avgCost, supplyPrice: supplyPrice);

    // Nothing to blend with: no prior cost, or no stock on hand to carry it.
    // Negative stock is clamped rather than trusted — an oversold variant would
    // otherwise invert the weighting and produce a nonsense average.
    final priorQty = qtyOnHand > 0 ? qtyOnHand : 0.0;
    if (opening == null || priorQty == 0) return receiptUnitCost;

    return (opening * priorQty + receiptUnitCost * qtyReceived) /
        (priorQty + qtyReceived);
  }
}
