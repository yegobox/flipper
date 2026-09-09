import 'package:supabase_models/brick/models/transactionItem.model.dart';

/// Coercion helpers for Ditto documents.
///
/// Ditto often stores numeric fields as strings; the generated
/// [TransactionItemDittoAdapter] does not coerce them and also performs branch
/// filtering + stock hydration that order-taking screens do not need.
num? dittoOptNum(dynamic v) {
  if (v == null) return null;
  if (v is num) return v;
  return num.tryParse(v.toString());
}

String? dittoOptString(dynamic v) {
  if (v == null) return null;
  final s = v.toString().trim();
  return s.isEmpty ? null : s;
}

bool dittoBool(dynamic v, {required bool fallback}) {
  if (v == null) return fallback;
  if (v is bool) return v;
  if (v == 1 || v == '1' || v == 'true') return true;
  if (v == 0 || v == '0' || v == 'false') return false;
  return fallback;
}

DateTime? dittoDate(dynamic raw) {
  if (raw == null) return null;
  if (raw is DateTime) return raw;
  return DateTime.tryParse(raw.toString());
}

/// Parses a raw Ditto `transaction_items` row into a [TransactionItem].
///
/// Shared by every "running ticket" surface (bar tabs, hotel folios) that
/// reads `transaction_items` straight off the Ditto store.
TransactionItem? transactionLineFromDitto(Map<String, dynamic> data) {
  final id = data['_id'] ?? data['id'];
  if (id == null) return null;

  return TransactionItem(
    id: id.toString(),
    name: dittoOptString(data['name']) ?? dittoOptString(data['itemNm']) ?? '',
    transactionId: dittoOptString(data['transactionId']),
    variantId: dittoOptString(data['variantId']),
    qty: dittoOptNum(data['qty']) ?? 0,
    price: dittoOptNum(data['price']) ?? 0,
    discount: dittoOptNum(data['discount']) ?? 0,
    dcRt: dittoOptNum(data['dcRt']) ?? 0,
    dcAmt: dittoOptNum(data['dcAmt']),
    prc: dittoOptNum(data['prc']) ?? 0,
    taxblAmt: dittoOptNum(data['taxblAmt']),
    taxAmt: dittoOptNum(data['taxAmt']),
    totAmt: dittoOptNum(data['totAmt']),
    taxPercentage: dittoOptNum(data['taxPercentage']),
    qtyUnitCd: dittoOptString(data['qtyUnitCd']),
    pkgUnitCd: dittoOptString(data['pkgUnitCd']),
    itemClsCd: dittoOptString(data['itemClsCd']),
    bhfId: dittoOptString(data['bhfId']),
    regrNm: dittoOptString(data['regrNm']),
    remainingStock: dittoOptNum(data['remainingStock']),
    active: dittoBool(data['active'], fallback: true),
    doneWithTransaction: dittoBool(
      data['doneWithTransaction'],
      fallback: false,
    ),
    lastTouched: dittoDate(data['lastTouched']),
    branchId: dittoOptString(data['branchId']),
    taxTyCd: dittoOptString(data['taxTyCd']),
    itemTyCd: dittoOptString(data['itemTyCd']),
    itemCd: dittoOptString(data['itemCd']),
    itemNm: dittoOptString(data['itemNm']),
    ttCatCd: dittoOptString(data['ttCatCd']),
    color: dittoOptString(data['color']),
    sku: dittoOptString(data['sku']),
    loggedByTenantId: dittoOptString(data['loggedByTenantId']),
    loggedByName: dittoOptString(data['loggedByName']),
    createdAt: dittoDate(data['createdAt']),
    updatedAt: dittoDate(data['updatedAt']),
  );
}
