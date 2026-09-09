import 'package:flipper_models/SyncStrategy.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/sync/utils/sale_line_pricing.dart';
import 'package:flipper_services/proxy.dart';

/// RRA-facing helpers shared by every running-ticket surface (bar tabs,
/// hotel folios). Kept free of any feature-specific naming so a new module
/// never has to import another module's utils.

const int _rraItemCdMaxLen = 20;

bool _isInvalidRraItemCd(String? itemCd, {String? variantId}) {
  if (itemCd == null || itemCd.isEmpty) return true;
  if (itemCd.length > _rraItemCdMaxLen) return true;
  if (variantId != null && itemCd == variantId) return true;
  return false;
}

/// RRA `itemCd`: registered catalog code (≤20 chars), never a variant UUID.
String? rraItemCd({
  Variant? variant,
  String? sku,
  String? legacyItemCd,
  String? variantId,
}) {
  for (final candidate in <String?>[
    variant?.itemCd,
    sku,
    variant?.sku,
    legacyItemCd,
  ]) {
    if (!_isInvalidRraItemCd(candidate, variantId: variantId)) {
      return candidate;
    }
  }
  return null;
}

/// Tourism tax category — RRA only accepts `TT` when applicable.
String? rraTtCatCd({Variant? variant, String? legacy}) {
  for (final value in [variant?.ttCatCd, legacy]) {
    if (value == 'TT') return 'TT';
  }
  return null;
}

/// [TransactionItem.copyWith] cannot clear nullable fields with `null` — use `''`.
String rraTtCatCdForItem({Variant? variant, String? legacy}) =>
    rraTtCatCd(variant: variant, legacy: legacy) ?? '';

/// Σ price × qty for ticket lines.
double ticketLineTotal(Iterable<TransactionItem> lines) {
  var total = 0.0;
  for (final line in lines) {
    total += line.price.toDouble() * line.qty.toDouble();
  }
  return total;
}

/// Σ qty (item count).
int ticketItemCount(Iterable<TransactionItem> lines) {
  var count = 0;
  for (final line in lines) {
    count += line.qty.toInt();
  }
  return count;
}

/// Inclusive VAT 18% breakdown.
({double subtotal, double vat, double total}) inclusiveVatBreakdown(
  double total,
) {
  if (total <= 0) {
    return (subtotal: 0, vat: 0, total: 0);
  }
  final vat = total - total / 1.18;
  final subtotal = total - vat;
  return (subtotal: subtotal, vat: vat, total: total);
}

/// Merge key for "tap the same product twice": variant + logger + price.
bool lineMatchesMerge({
  required TransactionItem line,
  required String variantId,
  required String loggedByTenantId,
  required num defaultPrice,
}) {
  return line.variantId == variantId &&
      line.loggedByTenantId == loggedByTenantId &&
      line.price == defaultPrice;
}

/// Fills RRA-required fields on ticket lines (variant catalog + pricing).
///
/// [context] is used only in the error message when a line has no `itemCd`.
Future<List<TransactionItem>> enrichLinesForRraReceipt(
  List<TransactionItem> lines, {
  String context = 'receipt',
}) async {
  final capella = ProxyService.getStrategy(Strategy.capella);
  final variantIds = lines
      .map((line) => line.variantId)
      .whereType<String>()
      .where((id) => id.trim().isNotEmpty)
      .toSet()
      .toList();
  final variantsById = variantIds.isEmpty
      ? <String, Variant>{}
      : await capella.batchGetVariantsByIds(variantIds);

  final enriched = <TransactionItem>[];

  for (final line in lines) {
    final variantId = line.variantId;
    final variant = (variantId != null && variantId.isNotEmpty)
        ? variantsById[variantId]
        : null;

    final taxTyCd = line.taxTyCd ?? variant?.taxTyCd ?? 'B';
    final taxPct = (line.taxPercentage ?? variant?.taxPercentage ?? 18.0)
        .toDouble();
    final dcRt = (line.dcRt ?? variant?.dcRt ?? 0).toDouble();
    final pricing = SaleLinePricing.compute(
      unitPrice: line.price.toDouble(),
      qty: line.qty.toDouble(),
      dcRt: dcRt,
      taxTyCd: taxTyCd,
      taxPercentage: taxPct,
    );

    final itemCd = rraItemCd(
      variant: variant,
      sku: line.sku ?? variant?.sku,
      legacyItemCd: line.itemCd,
      variantId: line.variantId,
    );
    if (itemCd == null) {
      throw StateError(
        'Cannot print RRA $context: "${line.name}" has no RRA itemCd. '
        'Register the product with RRA first.',
      );
    }

    enriched.add(
      line.copyWith(
        dcRt: pricing.dcRt,
        dcAmt: pricing.dcAmt,
        discount: pricing.discount,
        taxblAmt: pricing.taxblAmt,
        taxAmt: pricing.taxAmt,
        totAmt: pricing.totAmt,
        taxTyCd: taxTyCd,
        taxPercentage: taxPct,
        qtyUnitCd: line.qtyUnitCd ?? variant?.qtyUnitCd,
        pkgUnitCd: line.pkgUnitCd ?? variant?.pkgUnitCd,
        itemCd: itemCd,
        itemClsCd: line.itemClsCd ?? variant?.itemClsCd,
        itemTyCd: line.itemTyCd ?? variant?.itemTyCd ?? '2',
        itemNm: line.itemNm ?? variant?.itemNm ?? line.name,
        bhfId: line.bhfId ?? variant?.bhfId,
        regrNm: line.regrNm ?? variant?.regrNm ?? 'Registrar',
        ttCatCd: rraTtCatCdForItem(variant: variant, legacy: line.ttCatCd),
        sku: line.sku ?? variant?.sku,
        orgnNatCd: line.orgnNatCd ?? variant?.orgnNatCd ?? 'RW',
        itemSeq: line.itemSeq ?? variant?.itemSeq,
      ),
    );
  }

  return enriched;
}

/// Initials for an avatar chip ("Jean Bosco" → "JB").
String tenantInitials(String? name) {
  if (name == null || name.trim().isEmpty) return '?';
  final parts = name.trim().split(RegExp(r'\s+'));
  if (parts.length == 1) {
    return parts.first.length >= 2
        ? parts.first.substring(0, 2).toUpperCase()
        : parts.first.toUpperCase();
  }
  return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
}
