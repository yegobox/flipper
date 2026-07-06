import 'package:flipper_models/SyncStrategy.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/sync/utils/sale_line_pricing.dart';
import 'package:flipper_services/proxy.dart';
import 'package:supabase_models/brick/models/tenant.model.dart';
import 'package:supabase_models/brick/models/transactionItem.model.dart';

/// Same length as [SignInTokens.pinCellCount] / login PIN UI (6 cells).
const int barPinCellCount = 6;

/// `0` means "no PIN" on `users` / `tenants` rows — real login PINs live in `pins`.
bool isUsableStaffPin(int? pin) => pin != null && pin != 0;

/// Whether [enteredPin] matches the staff PIN on [tenant] (local merge from `pins`).
bool barPinMatchesTenant(Tenant tenant, String enteredPin) {
  final stored = tenant.pin;
  if (!isUsableStaffPin(stored)) return false;
  final parsed = int.tryParse(enteredPin);
  if (parsed != null && parsed == stored) return true;
  return stored.toString() == enteredPin;
}

/// Same verification path as [PinLogin] — `GET /v2/api/pin/{pin}` then match user.
Future<bool> barVerifyStaffPin(Tenant tenant, String enteredPin) async {
  if (barPinMatchesTenant(tenant, enteredPin)) return true;

  final expectedUserId = tenant.userId?.trim();
  if (expectedUserId == null || expectedUserId.isEmpty) return false;

  try {
    final record = await ProxyService.strategy.getPin(
      pinString: enteredPin,
      flipperHttpClient: ProxyService.http,
    );
    if (record == null) return false;
    return record.userId.trim() == expectedUserId;
  } catch (_) {
    return false;
  }
}

/// Σ price × qty for tab lines.
double barTabTotal(Iterable<TransactionItem> lines) {
  var total = 0.0;
  for (final line in lines) {
    total += line.price.toDouble() * line.qty.toDouble();
  }
  return total;
}

/// Σ qty (item count).
int barTabItemCount(Iterable<TransactionItem> lines) {
  var count = 0;
  for (final line in lines) {
    count += line.qty.toInt();
  }
  return count;
}

/// Distinct cashier tenant ids in first-seen order.
List<String> barTabServerIds(Iterable<TransactionItem> lines) {
  final seen = <String>{};
  final ordered = <String>[];
  for (final line in lines) {
    final id = line.loggedByTenantId;
    if (id == null || id.isEmpty || seen.contains(id)) continue;
    seen.add(id);
    ordered.add(id);
  }
  return ordered;
}

/// Inclusive VAT 18% breakdown.
({double subtotal, double vat, double total}) barVatBreakdown(double total) {
  if (total <= 0) {
    return (subtotal: 0, vat: 0, total: 0);
  }
  final vat = total - total / 1.18;
  final subtotal = total - vat;
  return (subtotal: subtotal, vat: vat, total: total);
}

num? _barDittoOptNum(dynamic v) {
  if (v == null) return null;
  if (v is num) return v;
  return num.tryParse(v.toString());
}

String? _barDittoOptString(dynamic v) {
  if (v == null) return null;
  final s = v.toString().trim();
  return s.isEmpty ? null : s;
}

bool _barDittoBool(dynamic v, {required bool fallback}) {
  if (v == null) return fallback;
  if (v is bool) return v;
  if (v == 1 || v == '1' || v == 'true') return true;
  if (v == 0 || v == '0' || v == 'false') return false;
  return fallback;
}

const int _rraItemCdMaxLen = 20;

bool _isInvalidRraItemCd(String? itemCd, {String? variantId}) {
  if (itemCd == null || itemCd.isEmpty) return true;
  if (itemCd.length > _rraItemCdMaxLen) return true;
  if (variantId != null && itemCd == variantId) return true;
  return false;
}

/// RRA [itemCd]: registered catalog code (≤20 chars), never a variant UUID.
String? barRraItemCd({
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
String? barRraTtCatCd({Variant? variant, String? legacy}) {
  for (final value in [variant?.ttCatCd, legacy]) {
    if (value == 'TT') return 'TT';
  }
  return null;
}

/// [TransactionItem.copyWith] cannot clear nullable fields with `null` — use `''`.
String barRraTtCatCdForItem({Variant? variant, String? legacy}) =>
    barRraTtCatCd(variant: variant, legacy: legacy) ?? '';

/// Parses a Ditto `transaction_items` row for bar tabs.
///
/// Ditto often stores numeric fields as strings; the generated
/// [TransactionItemDittoAdapter] does not coerce them and also
/// performs branch filtering + stock hydration we do not need here.
TransactionItem? barTransactionLineFromDitto(Map<String, dynamic> data) {
  final id = data['_id'] ?? data['id'];
  if (id == null) return null;

  DateTime? parseDate(dynamic raw) {
    if (raw == null) return null;
    if (raw is DateTime) return raw;
    return DateTime.tryParse(raw.toString());
  }

  return TransactionItem(
    id: id.toString(),
    name: _barDittoOptString(data['name']) ??
        _barDittoOptString(data['itemNm']) ??
        '',
    transactionId: _barDittoOptString(data['transactionId']),
    variantId: _barDittoOptString(data['variantId']),
    qty: _barDittoOptNum(data['qty']) ?? 0,
    price: _barDittoOptNum(data['price']) ?? 0,
    discount: _barDittoOptNum(data['discount']) ?? 0,
    dcRt: _barDittoOptNum(data['dcRt']) ?? 0,
    dcAmt: _barDittoOptNum(data['dcAmt']),
    prc: _barDittoOptNum(data['prc']) ?? 0,
    taxblAmt: _barDittoOptNum(data['taxblAmt']),
    taxAmt: _barDittoOptNum(data['taxAmt']),
    totAmt: _barDittoOptNum(data['totAmt']),
    taxPercentage: _barDittoOptNum(data['taxPercentage']),
    qtyUnitCd: _barDittoOptString(data['qtyUnitCd']),
    pkgUnitCd: _barDittoOptString(data['pkgUnitCd']),
    itemClsCd: _barDittoOptString(data['itemClsCd']),
    bhfId: _barDittoOptString(data['bhfId']),
    regrNm: _barDittoOptString(data['regrNm']),
    remainingStock: _barDittoOptNum(data['remainingStock']),
    active: _barDittoBool(data['active'], fallback: true),
    doneWithTransaction: _barDittoBool(data['doneWithTransaction'], fallback: false),
    lastTouched: parseDate(data['lastTouched']),
    branchId: _barDittoOptString(data['branchId']),
    taxTyCd: _barDittoOptString(data['taxTyCd']),
    itemTyCd: _barDittoOptString(data['itemTyCd']),
    itemCd: _barDittoOptString(data['itemCd']),
    itemNm: _barDittoOptString(data['itemNm']),
    ttCatCd: _barDittoOptString(data['ttCatCd']),
    color: _barDittoOptString(data['color']),
    sku: _barDittoOptString(data['sku']),
    loggedByTenantId: _barDittoOptString(data['loggedByTenantId']),
    loggedByName: _barDittoOptString(data['loggedByName']),
    createdAt: parseDate(data['createdAt']),
    updatedAt: parseDate(data['updatedAt']),
  );
}

/// Fills RRA-required fields on bar tab lines (variant catalog + pricing).
Future<List<TransactionItem>> enrichBarTabLinesForRraReceipt(
  List<TransactionItem> lines,
) async {
  final capella = ProxyService.getStrategy(Strategy.capella);
  final enriched = <TransactionItem>[];

  for (final line in lines) {
    final variantId = line.variantId;
    Variant? variant;
    if (variantId != null && variantId.isNotEmpty) {
      variant = await capella.getVariant(id: variantId);
    }

    final taxTyCd = line.taxTyCd ?? variant?.taxTyCd ?? 'B';
    final taxPct =
        (line.taxPercentage ?? variant?.taxPercentage ?? 18.0).toDouble();
    final dcRt = (line.dcRt ?? variant?.dcRt ?? 0).toDouble();
    final pricing = SaleLinePricing.compute(
      unitPrice: line.price.toDouble(),
      qty: line.qty.toDouble(),
      dcRt: dcRt,
      taxTyCd: taxTyCd,
      taxPercentage: taxPct,
    );

    final itemCd = barRraItemCd(
      variant: variant,
      sku: line.sku ?? variant?.sku,
      legacyItemCd: line.itemCd,
      variantId: line.variantId,
    );
    if (itemCd == null) {
      throw StateError(
        'Cannot print RRA receipt: "${line.name}" has no RRA itemCd. '
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
        ttCatCd: barRraTtCatCdForItem(variant: variant, legacy: line.ttCatCd),
        sku: line.sku ?? variant?.sku,
        orgnNatCd: line.orgnNatCd ?? variant?.orgnNatCd ?? 'RW',
        itemSeq: line.itemSeq ?? variant?.itemSeq,
      ),
    );
  }

  return enriched;
}

/// Merge key: variant + cashier + default price only.
bool barLineMatchesMerge({
  required TransactionItem line,
  required String variantId,
  required String cashierTenantId,
  required num defaultPrice,
}) {
  return line.variantId == variantId &&
      line.loggedByTenantId == cashierTenantId &&
      line.price == defaultPrice;
}

String barTenantInitials(String? name) {
  if (name == null || name.trim().isEmpty) return '?';
  final parts = name.trim().split(RegExp(r'\s+'));
  if (parts.length == 1) {
    return parts.first.length >= 2
        ? parts.first.substring(0, 2).toUpperCase()
        : parts.first.toUpperCase();
  }
  return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
}

/// Demo palette for server avatars (cycles by index).
const barServerColors = [
  0xFF2563EB,
  0xFF2E9E83,
  0xFFC2557E,
  0xFF5457D6,
  0xFFE08600,
  0xFF7C3AED,
];

int barServerColorForIndex(int index) =>
    barServerColors[index % barServerColors.length];

String barFormatDuration(Duration d) {
  if (d.inHours >= 1) return '${d.inHours}h ${d.inMinutes % 60}m';
  return '${d.inMinutes}m';
}
