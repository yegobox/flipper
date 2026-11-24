import 'package:ditto_live/ditto_live.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/sync/utils/combo_stock_lines.dart';
import 'package:flipper_models/sync/utils/pos_catalog_stock_filter.dart';
import 'package:flipper_web/services/ditto_service.dart';

/// What a combo costs the business: a sale's cost of goods (COGS) and a
/// product's stock value come from a supply price, so a combo must carry the
/// cost of what goes into it.
///
/// - Sold as made (a service): the cost of its components at the time of
///   sale, written onto the sale line ([comboLineCosts]).
/// - Made in production (a finished product): each batch costs its
///   components; the product's supply price is the moving average
///   ([movingAverageCost]).
///
/// The data-connector books COGS from each line's `splyAmt`, so no journal
/// entry is written here: turning flour into bread moves value within
/// Inventory (1200), and selling the bread books its cost.

/// Two costs closer than this are the same (rounding).
const comboCostTolerance = 0.005;

/// One combo's cost: [Composite.qty] (1 when unset) of each component at its
/// supply price.
///
/// Null when any component's cost is unknown (its variant is gone, or goods
/// with no supply price above 0): a missing price would count as 0 and
/// overwrite a cost the owner set, so the caller keeps the cost it has. A
/// service with no supply price (labour, delivery, a packaging fee) is a known
/// 0 ([componentUnitCost]).
double? comboUnitCost(
  Iterable<Composite> components,
  Map<String, Variant> variantsById,
) {
  var total = 0.0;
  for (final component in components) {
    final variant = variantsById[component.variantId];
    if (variant == null) return null;
    final cost = componentUnitCost(variant.supplyPrice, variant.itemTyCd);
    if (cost == null) return null;
    final perCombo = (component.qty ?? 0) > 0 ? component.qty! : 1.0;
    total += perCombo * cost;
  }
  return total;
}

/// A component's unit cost from its [supplyPrice]: goods without one above 0
/// are unknown (null); a service without one costs nothing.
double? componentUnitCost(num? supplyPrice, String? itemTyCd) {
  if (supplyPrice != null && supplyPrice > 0) return supplyPrice.toDouble();
  return isServiceItemType(itemTyCd) ? 0 : null;
}

/// Each combo sale line's total cost, from its expanded component lines
/// ([expandComboLines]): Σ component supply price × quantity.
///
/// A combo with a goods component line lacking a supply price above 0 is
/// left out, so its sale keeps the cost it was saved with.
Map<String, double> comboLineCosts(Iterable<TransactionItem> expandedLines) {
  final costs = <String, double>{};
  final unknown = <String>{};
  for (final line in expandedLines) {
    final comboId = comboLineIdOf(line.id);
    if (comboId == null) continue;
    final cost = componentUnitCost(line.supplyPrice, line.itemTyCd);
    if (cost == null) {
      unknown.add(comboId);
      continue;
    }
    costs[comboId] = (costs[comboId] ?? 0) + cost * line.qty.toDouble();
  }
  costs.removeWhere((comboId, _) => unknown.contains(comboId));
  return costs;
}

/// The unit cost after adding [qty] made at [unitCost] to [onHandBefore]
/// units held at [oldCost]. Stock below zero counts as none, so a negative
/// balance can't drag the average.
double movingAverageCost({
  required double onHandBefore,
  required double oldCost,
  required double qty,
  required double unitCost,
}) {
  final held = onHandBefore > 0 ? onHandBefore : 0.0;
  final total = held + qty;
  if (total <= 0) return unitCost;
  return (held * oldCost + qty * unitCost) / total;
}

/// Sets a variant's supply price and nothing else (a whole-document upsert
/// could overwrite a field another till changed meanwhile).
Future<void> writeVariantSupplyPrice(
  Ditto ditto, {
  required String variantId,
  required double supplyPrice,
}) => ditto.store.execute(
  'UPDATE variants SET supplyPrice = :supplyPrice, lastTouched = :now '
  'WHERE _id = :id',
  arguments: {
    'supplyPrice': supplyPrice,
    'now': DateTime.now().toUtc().toIso8601String(),
    'id': variantId,
  },
);

/// Sets a sale line's cost: unit supply price and line total (`splyAmt`, the
/// field the data-connector books COGS from).
Future<void> writeLineSupplyCost(
  Ditto ditto, {
  required String lineId,
  required double unitCost,
  required double qty,
}) => ditto.store.execute(
  'UPDATE transaction_items SET supplyPrice = :unit, '
  'supplyPriceAtSale = :unit, splyAmt = :total, updatedAt = :now '
  'WHERE _id = :id',
  arguments: {
    'unit': unitCost,
    'total': unitCost * qty,
    'now': DateTime.now().toIso8601String(),
    'id': lineId,
  },
);

/// Where combo costs are written: [ComboCostWriter.live] is the app's Ditto
/// store; tests pass their own functions.
class ComboCostWriter {
  const ComboCostWriter({
    required this.variantSupplyPrice,
    required this.lineSupplyCost,
  });

  /// Writes through [ditto] ([writeVariantSupplyPrice], [writeLineSupplyCost]).
  ComboCostWriter.ditto(Ditto ditto)
    : variantSupplyPrice = ((variantId, supplyPrice) => writeVariantSupplyPrice(
        ditto,
        variantId: variantId,
        supplyPrice: supplyPrice,
      )),
      lineSupplyCost = ((lineId, unitCost, qty) => writeLineSupplyCost(
        ditto,
        lineId: lineId,
        unitCost: unitCost,
        qty: qty,
      ));

  /// The app's Ditto store, or null before Ditto is open. The one place the
  /// cost writers reach the global [DittoService].
  static ComboCostWriter? live() {
    final ditto = DittoService.instance.dittoInstance;
    return ditto == null ? null : ComboCostWriter.ditto(ditto);
  }

  /// Sets a variant's supply price.
  final Future<void> Function(String variantId, double supplyPrice)
  variantSupplyPrice;

  /// Sets a sale line's unit cost and `splyAmt` (unit cost × [qty]).
  final Future<void> Function(String lineId, double unitCost, double qty)
  lineSupplyCost;
}
