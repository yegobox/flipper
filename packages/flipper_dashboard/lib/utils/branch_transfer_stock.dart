import 'package:flipper_models/SyncStrategy.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_services/proxy.dart';

/// Reject null and Ditto rows with empty [Stock.branchId] (corrupt / incomplete).
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

/// An authentic stock row that actually belongs to [branchId].
///
/// A transfer must never resolve the SOURCE branch's stock document as the
/// destination's: both branches would then share one row (and one
/// `currentStockMilli` COUNTER), so the transferred qty would be added to and
/// deducted from the same on-hand.
bool isStockForBranch(Stock? stock, String branchId) {
  if (!isAuthenticCapellaStock(stock)) return false;
  return stock!.branchId.trim() == branchId.trim();
}

/// Drops the source branch's stock link that [Variant.copyWith] carries over.
///
/// The destination variant is built from the source with `copyWith`, which
/// copies `stock` and `stockId` verbatim. Left in place, the destination row
/// points at the source branch's stock document.
void detachInheritedStockLink(Variant variant) {
  variant.stock = null;
  variant.stockId = null;
}

/// Tax type codes shown in the POS catalog regardless of the viewing branch's
/// VAT setting (regulated fuel / tourism). See `posCatalogTaxTyCds`.
const _branchVatAgnosticTaxTyCds = {'F', 'TT'};

/// Resolves the tax type code a transferred variant should carry on the
/// DESTINATION branch, so it is both visible in and taxed correctly by that
/// branch's POS catalog.
///
/// The catalog filters variants by `taxTyCd IN posCatalogTaxTyCds(destVat)`:
///   VAT-enabled  -> A, B, C, F, TT
///   VAT-disabled -> D, F, TT
/// A variant that simply inherits the source branch's code (e.g. VAT 'B') is
/// otherwise invisible on a non-VAT destination. F/TT are regulated and shown
/// on both, so they are preserved.
String destinationTaxTyCd({
  required String? sourceTaxTyCd,
  required bool destVatEnabled,
}) {
  final code = (sourceTaxTyCd ?? '').trim().toUpperCase();
  if (_branchVatAgnosticTaxTyCds.contains(code)) return code;
  if (destVatEnabled) {
    // Preserve an existing VAT-regime code; default anything else to
    // standard-rated B (18%).
    return (code == 'A' || code == 'B' || code == 'C') ? code : 'B';
  }
  // Non-VAT destination: everything collapses to the non-VAT code D.
  return 'D';
}

/// Standard VAT percentage for a resolved [taxTyCd]: B (standard) = 18,
/// A/C/D (exempt / zero-rated / non-VAT) = 0. F/TT are regulated, so their
/// existing rate is kept ([fallback]).
double? destinationTaxPercentage({required String taxTyCd, num? fallback}) {
  switch (taxTyCd) {
    case 'B':
      return 18.0;
    case 'A':
    case 'C':
    case 'D':
      return 0.0;
    default:
      return fallback?.toDouble();
  }
}

/// POS catalog Ditto query excludes import/purchase workflow statuses. Branch
/// transfers copy the source [Variant] verbatim, so those fields can hide an
/// otherwise valid destination row from the product grid entirely.
void prepareDestinationVariantForPosCatalog(Variant variant) {
  variant.imptItemSttsCd = null;
  variant.pchsSttsCd = null;
}

/// Mirrors Capella POS catalog filters (see [CapellaVariantMixin.variants]).
/// Useful when a raw `SELECT * FROM variants WHERE branchId = …` finds a row
/// but the product grid does not.
bool variantPassesPosCatalogFilters(
  Variant variant, {
  required bool destVatEnabled,
}) {
  const blockedImport = {'2', '4'};
  const blockedPurchase = {'01', '04'};
  const blockedNames = {'Cash In', 'Cash Out', 'Utility', 'Custom Amount'};

  final name = variant.name.trim();
  if (blockedNames.contains(name)) return false;

  final import = variant.imptItemSttsCd?.trim();
  if (import != null && import.isNotEmpty && blockedImport.contains(import)) {
    return false;
  }

  final purchase = variant.pchsSttsCd?.trim();
  if (purchase != null &&
      purchase.isNotEmpty &&
      blockedPurchase.contains(purchase)) {
    return false;
  }

  final taxTyCds = destVatEnabled
      ? const ['A', 'B', 'C', 'F', 'TT']
      : const ['D', 'F', 'TT'];
  final tax = variant.taxTyCd?.trim().toUpperCase();
  if (tax == null || tax.isEmpty || !taxTyCds.contains(tax)) return false;

  return true;
}

/// Stable Capella stock document id for a branch-transfer destination variant.
/// Survives missing [Variant.stockId] on the variant row so repeat transfers
/// increment the same stock doc instead of minting orphans.
String destinationTransferStockId(String destVariantId) =>
    '$destVariantId-transfer-stock';

/// Adds [approvedQuantity] to destination on-hand, reading the current Ditto
/// stock row first (never trusting embedded [Variant.stock] / [Variant.qty]).
///
/// Candidate stock documents are accepted only when they belong to
/// [destinationBranchId] — see [isStockForBranch]. The add itself is an atomic
/// `currentStockMilli` COUNTER increment (`appending: true`), not a
/// read-then-absolute-write: an absolute `base + qty` write would silently drop
/// any sale the destination till rang up between the read and the write.
Future<Stock> applyDestinationStockDelta({
  required Variant destVariant,
  required String destinationBranchId,
  required int approvedQuantity,
}) async {
  if (approvedQuantity < 1) {
    throw ArgumentError.value(approvedQuantity, 'approvedQuantity');
  }

  final capella = ProxyService.getStrategy(Strategy.capella);
  final candidateStockIds = <String>[];
  void addCandidate(String? raw) {
    final id = raw?.trim();
    if (id == null || id.isEmpty) return;
    if (!candidateStockIds.contains(id)) candidateStockIds.add(id);
  }

  addCandidate(destVariant.stockId);
  addCandidate(destinationTransferStockId(destVariant.id));

  Stock? resolved;
  for (final stockId in candidateStockIds) {
    final fetched = await capella.getStockById(id: stockId);
    if (isStockForBranch(fetched, destinationBranchId)) {
      resolved = fetched;
      break;
    }
    if (isAuthenticCapellaStock(fetched)) {
      // Older transfers linked the destination variant to the SOURCE branch's
      // stock document (inherited via copyWith). Skip it and mint/return the
      // destination's own row instead of growing the source's on-hand.
      talker.warning(
        'Branch transfer: ignoring stock $stockId on branch '
        '${fetched!.branchId} for destination $destinationBranchId '
        '(variant=${destVariant.id})',
      );
    }
  }

  final now = DateTime.now().toUtc();
  final unitPrice =
      (destVariant.retailPrice ?? destVariant.supplyPrice ?? 0).toDouble();

  if (resolved != null) {
    final base = resolved.currentStock ?? 0;
    await capella.updateStock(
      stockId: resolved.id,
      currentStock: approvedQuantity.toDouble(),
      appending: true,
      lastTouched: now,
      ebmSynced: false,
    );
    // Re-read so `value` and the returned Stock carry the merged counter rather
    // than this device's estimate of it.
    final after = await capella.getStockById(id: resolved.id);
    final newQty = after?.currentStock ?? (base + approvedQuantity);
    final newValue = newQty * unitPrice;
    // Metadata-only update: leaves currentStock / rsdQty (and the COUNTER) alone.
    await capella.updateStock(stockId: resolved.id, value: newValue);
    final out = after ?? resolved;
    out
      ..currentStock = newQty
      ..rsdQty = newQty
      ..value = newValue
      ..lastTouched = now;
    talker.info(
      'Branch transfer stock increment: variant=${destVariant.id} '
      'stockId=${resolved.id} $base + $approvedQuantity = $newQty',
    );
    return out;
  }

  final qty = approvedQuantity.toDouble();
  final created = await capella.saveStock(
    id: destinationTransferStockId(destVariant.id),
    rsdQty: qty,
    currentStock: qty,
    value: qty * unitPrice,
    productId: destVariant.productId!,
    variantId: destVariant.id,
    branchId: destinationBranchId,
  );
  talker.info(
    'Branch transfer stock create: variant=${destVariant.id} '
    'stockId=${created.id} qty=$qty',
  );
  return created;
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
      if (stock != null && isAuthenticCapellaStock(stock)) {
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
