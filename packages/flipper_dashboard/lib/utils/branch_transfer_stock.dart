import 'package:flipper_models/SyncStrategy.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_services/proxy.dart';

/// Capella [getStockById] returns a zero placeholder (empty [Stock.branchId])
/// when the Ditto document is missing. Treat those as "not found".
bool isAuthenticCapellaStock(Stock? stock) {
  if (stock == null) return false;
  final branchId = stock.branchId.trim();
  return branchId.isNotEmpty;
}

double onHandFromStock(Stock? stock, {double? qtyFallback}) {
  if (isAuthenticCapellaStock(stock)) {
    return stock!.currentStock ?? 0;
  }
  return qtyFallback ?? 0;
}

/// Resolved Capella on-hand for one transfer line (variant + stock docs).
class TransferOnHand {
  const TransferOnHand({
    required this.variantId,
    required this.onHand,
    this.variant,
    this.stock,
  });

  final String variantId;
  final Variant? variant;
  final Stock? stock;
  final double onHand;
}

/// Batch-resolve on-hand stock the same way sales [validateStockQuantity] does:
/// Capella variants by id → Capella stocks by [Variant.stockId].
///
/// Avoids Brick SQLite stock associations, which can lag Capella/Ditto and
/// falsely report "no stock available to transfer" while the POS tile shows qty.
Future<Map<String, TransferOnHand>> resolveCapellaOnHandByVariantIds(
  Iterable<String> variantIds,
) async {
  final ids = variantIds
      .where((id) => id.trim().isNotEmpty)
      .map((id) => id.trim())
      .toSet()
      .toList();
  if (ids.isEmpty) return {};

  final capella = ProxyService.getStrategy(Strategy.capella);
  final variantsMap = await capella.batchGetVariantsByIds(ids);

  // Capella batch may miss docs that single getVariant still finds (and vice
  // versa). Fill gaps with getVariant so transfer confirm matches catalog.
  for (final id in ids) {
    if (variantsMap.containsKey(id)) continue;
    try {
      final v = await capella.getVariant(id: id);
      if (v != null) variantsMap[id] = v;
    } catch (e, st) {
      talker.warning(
        'resolveCapellaOnHand: getVariant($id) failed: $e\n$st',
      );
    }
  }

  final stockIds = <String>{};
  for (final id in ids) {
    final sid = variantsMap[id]?.stockId?.trim();
    if (sid != null && sid.isNotEmpty) stockIds.add(sid);
  }

  final stocksMap = stockIds.isEmpty
      ? <String, Stock>{}
      : await capella.batchGetStocksByIds(stockIds.toList());

  for (final sid in stockIds) {
    if (stocksMap.containsKey(sid) &&
        isAuthenticCapellaStock(stocksMap[sid])) {
      continue;
    }
    try {
      final stock = await capella.getStockById(id: sid);
      if (isAuthenticCapellaStock(stock)) {
        stocksMap[sid] = stock;
      }
    } catch (e, st) {
      talker.warning(
        'resolveCapellaOnHand: getStockById($sid) failed: $e\n$st',
      );
    }
  }

  final out = <String, TransferOnHand>{};
  for (final id in ids) {
    final variant = variantsMap[id];
    final sid = variant?.stockId?.trim();
    Stock? stock;
    if (sid != null && sid.isNotEmpty) {
      stock = stocksMap[sid];
      if (!isAuthenticCapellaStock(stock)) {
        stock = null;
      }
    }
    // Prefer Capella stock doc; last resort: embedded stock on variant when
    // authentic (Brick attach / Capella getVariant). Never invent on-hand from
    // Variant.qty alone — that caused false transfer approvals against missing
    // stock rows.
    final embedded = variant?.stock;
    final resolved = isAuthenticCapellaStock(stock)
        ? stock
        : (isAuthenticCapellaStock(embedded) ? embedded : null);
    final onHand = onHandFromStock(resolved);
    out[id] = TransferOnHand(
      variantId: id,
      variant: variant,
      stock: resolved,
      onHand: onHand,
    );
  }
  return out;
}
