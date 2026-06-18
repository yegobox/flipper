import 'package:supabase_models/brick/models/purchase.model.dart';
import 'package:supabase_models/brick/models/stock.model.dart';
import 'package:supabase_models/brick/models/variant.model.dart';

/// Parses a variant document from data-connector `GET /imports` (nested stock).
Variant variantFromApiJson(Map<String, dynamic> json) {
  final copy = Map<String, dynamic>.from(json);
  final nestedStock = copy.remove('stock');
  final branchId = copy['branchId']?.toString() ?? '';
  final variant = _variantFromApiMap(copy, branchId: branchId);
  if (nestedStock is Map) {
    variant.stock = stockFromApiJson(
      Map<String, dynamic>.from(nestedStock),
      fallbackBranchId: branchId,
    );
    variant.stockId = variant.stock?.id ?? copy['stockId']?.toString();
  }
  return variant;
}

Variant _variantFromApiMap(Map<String, dynamic> json, {required String branchId}) {
  num? parseNum(dynamic value) {
    if (value == null) return null;
    if (value is num) return value;
    if (value is String) return num.tryParse(value);
    return null;
  }

  DateTime? parseDate(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    if (value is int) return DateTime.fromMillisecondsSinceEpoch(value);
    if (value is String) return DateTime.tryParse(value);
    return null;
  }

  String? optionalString(dynamic value) {
    if (value == null) return null;
    final s = value is String ? value : value.toString();
    return s.isEmpty ? null : s;
  }

  final id = json['id']?.toString() ?? json['_id']?.toString() ?? '';
  final name = json['name']?.toString() ?? json['itemNm']?.toString() ?? '';

  return Variant(
    id: id.isEmpty ? null : id,
    branchId: json['branchId']?.toString() ?? branchId,
    name: name,
    itemNm: json['itemNm']?.toString() ?? name,
    color: optionalString(json['color']),
    sku: optionalString(json['sku']),
    productId: optionalString(json['productId']),
    unit: optionalString(json['unit']),
    productName: optionalString(json['productName']),
    categoryId: optionalString(json['categoryId']),
    categoryName: optionalString(json['categoryName']),
    taxName: optionalString(json['taxName']),
    taxPercentage: parseNum(json['taxPercentage'])?.toDouble(),
    itemSeq: parseNum(json['itemSeq'])?.toInt(),
    taxTyCd: optionalString(json['taxTyCd']),
    bcd: optionalString(json['bcd']),
    itemClsCd: optionalString(json['itemClsCd']),
    itemTyCd: optionalString(json['itemTyCd']),
    itemStdNm: optionalString(json['itemStdNm']),
    orgnNatCd: optionalString(json['orgnNatCd']),
    pkg: parseNum(json['pkg'])?.toInt(),
    itemCd: optionalString(json['itemCd']),
    pkgUnitCd: optionalString(json['pkgUnitCd']),
    qtyUnitCd: optionalString(json['qtyUnitCd']),
    prc: parseNum(json['prc'])?.toDouble(),
    splyAmt: parseNum(json['splyAmt'])?.toDouble(),
    tin: parseNum(json['tin'])?.toInt(),
    bhfId: optionalString(json['bhfId']),
    supplyPrice: parseNum(json['supplyPrice'])?.toDouble(),
    retailPrice: parseNum(json['retailPrice'])?.toDouble(),
    spplrItemClsCd: optionalString(json['spplrItemClsCd']),
    spplrItemCd: optionalString(json['spplrItemCd']),
    spplrItemNm: optionalString(json['spplrItemNm']),
    spplrNm: optionalString(json['spplrNm']),
    ebmSynced: json['ebmSynced'] as bool?,
    hsCd: optionalString(json['hsCd']),
    dclNo: optionalString(json['dclNo']),
    imptItemSttsCd: optionalString(
      json['imptItemSttsCd'] ?? json['imptItemsttsCd'],
    ),
    pchsSttsCd: optionalString(json['pchsSttsCd']),
    purchaseId: optionalString(json['purchaseId']),
    stockId: optionalString(json['stockId']),
    assigned: json['assigned'] as bool?,
    qty: parseNum(json['qty'])?.toDouble(),
    lastTouched: parseDate(json['lastTouched']),
    taxblAmt: parseNum(json['taxblAmt'])?.toDouble(),
    taxAmt: parseNum(json['taxAmt'])?.toDouble(),
    totAmt: parseNum(json['totAmt'])?.toDouble(),
  );
}

Stock stockFromApiJson(
  Map<String, dynamic> json, {
  required String fallbackBranchId,
}) {
  num? parseNum(dynamic value) {
    if (value == null) return null;
    if (value is num) return value;
    if (value is String) return num.tryParse(value);
    return null;
  }

  DateTime? parseDate(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    if (value is int) return DateTime.fromMillisecondsSinceEpoch(value);
    if (value is String) return DateTime.tryParse(value);
    return null;
  }

  return Stock(
    id: json['id']?.toString() ?? '',
    branchId: json['branchId']?.toString() ?? fallbackBranchId,
    currentStock: parseNum(json['currentStock'])?.toDouble(),
    initialStock: parseNum(json['initialStock'])?.toDouble(),
    rsdQty: parseNum(json['rsdQty'])?.toDouble(),
    lowStock: parseNum(json['lowStock'])?.toDouble(),
    lastTouched: parseDate(json['lastTouched']),
    tin: parseNum(json['tin'])?.toInt(),
    bhfId: json['bhfId']?.toString(),
  );
}

/// Parses a purchase + nested variants from data-connector `GET /purchases`.
Purchase purchaseFromApiJson(Map<String, dynamic> json) {
  final copy = Map<String, dynamic>.from(json);
  final variantsRaw = copy.remove('variants') ?? copy.remove('itemList');
  final purchase = _purchaseHeaderFromJson(copy);
  if (variantsRaw is List) {
    purchase.variants = variantsRaw
        .whereType<Map>()
        .map((e) => variantFromApiJson(Map<String, dynamic>.from(e)))
        .toList();
  }
  return purchase;
}

Purchase _purchaseHeaderFromJson(Map<String, dynamic> json) {
  num parseNumRequired(dynamic value, [num defaultValue = 0]) {
    if (value == null) return defaultValue;
    if (value is num) return value;
    if (value is String) return num.tryParse(value) ?? defaultValue;
    return defaultValue;
  }

  DateTime parseCreatedAt(dynamic value) {
    if (value == null) return DateTime.now().toUtc();
    if (value is DateTime) return value;
    if (value is int) return DateTime.fromMillisecondsSinceEpoch(value);
    if (value is String) return DateTime.tryParse(value) ?? DateTime.now().toUtc();
    return DateTime.now().toUtc();
  }

  return Purchase(
    id: json['id']?.toString(),
    branchId: json['branchId']?.toString(),
    hasUnApprovedVariant: json['hasUnApprovedVariant'] as bool?,
    spplrTin: json['spplrTin']?.toString() ?? '',
    spplrNm: json['spplrNm']?.toString() ?? '',
    spplrBhfId: json['spplrBhfId']?.toString() ?? '00',
    spplrInvcNo: parseNumRequired(json['spplrInvcNo']).toInt(),
    rcptTyCd: json['rcptTyCd']?.toString() ?? 'P',
    pmtTyCd: json['pmtTyCd']?.toString() ?? '01',
    cfmDt: json['cfmDt']?.toString() ?? '',
    salesDt: json['salesDt']?.toString() ?? '',
    stockRlsDt: json['stockRlsDt']?.toString(),
    totItemCnt: parseNumRequired(json['totItemCnt']).toInt(),
    taxblAmtA: parseNumRequired(json['taxblAmtA']),
    taxblAmtB: parseNumRequired(json['taxblAmtB']),
    taxblAmtC: parseNumRequired(json['taxblAmtC']),
    taxblAmtD: parseNumRequired(json['taxblAmtD']),
    taxRtA: parseNumRequired(json['taxRtA']),
    taxRtB: parseNumRequired(json['taxRtB']),
    taxRtC: parseNumRequired(json['taxRtC']),
    taxRtD: parseNumRequired(json['taxRtD']),
    taxAmtA: parseNumRequired(json['taxAmtA']),
    taxAmtB: parseNumRequired(json['taxAmtB']),
    taxAmtC: parseNumRequired(json['taxAmtC']),
    taxAmtD: parseNumRequired(json['taxAmtD']),
    totTaxblAmt: parseNumRequired(json['totTaxblAmt']),
    totTaxAmt: parseNumRequired(json['totTaxAmt']),
    totAmt: parseNumRequired(json['totAmt']),
    regTyCd: json['regTyCd']?.toString(),
    remark: json['remark']?.toString(),
    createdAt: parseCreatedAt(json['createdAt'] ?? json['created_at']),
    approved: json['approved'] != null
        ? parseNumRequired(json['approved']).toInt()
        : null,
    rejected: json['rejected'] != null
        ? parseNumRequired(json['rejected']).toInt()
        : null,
    pending: json['pending'] != null
        ? parseNumRequired(json['pending']).toInt()
        : null,
  );
}

/// UI line assignments `{ targetVariantId: [purchaseVariant, ...] }` → API itemMapper.
Map<String, List<String>> buildPurchaseItemMapper(
  Map<String, List<Variant>> uiMapper,
) {
  final out = <String, List<String>>{};
  for (final entry in uiMapper.entries) {
    final ids = entry.value.map((v) => v.id).where((id) => id.isNotEmpty).toList();
    if (ids.isNotEmpty) {
      out[entry.key] = ids;
    }
  }
  return out;
}

/// Import status filter key → API `status` query param.
String? importStatusApiParam(String uiFilter) {
  switch (uiFilter) {
    case 'pending':
      return '2';
    case 'approved':
      return '3';
    case 'rejected':
      return '4';
    default:
      return null;
  }
}

/// Purchase status filter key → API `status` query param.
String? purchaseStatusApiParam(String uiFilter) {
  switch (uiFilter) {
    case 'pending':
      return '01';
    case 'approved':
      return '02';
    case 'rejected':
      return '04';
    default:
      return null;
  }
}
