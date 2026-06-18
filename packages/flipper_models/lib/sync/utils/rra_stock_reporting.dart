import 'dart:convert';

import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/helperModels/random.dart';
import 'package:flipper_services/constants.dart';

double _roundMoney(num value) =>
    double.parse(value.toStringAsFixed(2));

/// Stock-in / purchase-side I/O — matches data-connector bulk (no customer fields).
///
/// Sale (`11`) and sale return-out (`12`) are outgoing and keep `custNm` / `custTin`.
bool isIncomingRraStockIo(String sarTyCd) {
  switch (sarTyCd) {
    case StockInOutType.import:
    case StockInOutType.purchase:
    case StockInOutType.returnIn:
    case StockInOutType.stockMovementIn:
    case StockInOutType.processingIn:
    case StockInOutType.adjustmentIn:
      return true;
    default:
      return false;
  }
}

/// Registrar ids for `stock/saveStockItems` envelope — variant ids, not random (bulk path).
Map<String, String> rraStockIoRegistrarFields(
  List<TransactionItem> items, {
  String Function()? fallbackRegistrarId,
}) {
  for (final item in items) {
    final modrId = item.modrId?.toString().trim();
    if (modrId != null && modrId.isNotEmpty) {
      final regrId = item.regrId?.toString().trim();
      final regrNm = item.regrNm?.trim();
      final modrNm = item.modrNm?.trim();
      final effectiveRegrId =
          (regrId != null && regrId.isNotEmpty) ? regrId : modrId;
      return {
        'regrId': effectiveRegrId,
        'regrNm':
            (regrNm != null && regrNm.isNotEmpty) ? regrNm : effectiveRegrId,
        'modrId': modrId,
        'modrNm': (modrNm != null && modrNm.isNotEmpty) ? modrNm : modrId,
      };
    }
  }
  final mod = (fallbackRegistrarId ?? () => randomNumber().toString())();
  final short = mod.length > 15 ? mod.substring(0, 15) : mod;
  return {'regrId': short, 'regrNm': short, 'modrId': short, 'modrNm': short};
}

/// One `itemList` line for `stock/saveStockItems` (data-connector / bulk shape).
Map<String, dynamic> mapRraStockIoItemToJson(
  TransactionItem item, {
  required String bhfId,
  num? approvedQty,
  int? itemSeq,
  String Function()? fallbackModId,
}) {
  final quantity = (approvedQty ?? item.qty).toDouble();
  final retailUnit = (item.prc ?? item.price).toDouble();
  final supplyUnit = (item.supplyPrice ?? item.prc ?? item.price).toDouble();
  final lineTotal = _roundMoney(retailUnit * quantity);
  final modId = item.modrId?.toString().trim();
  final effectiveModId = (modId != null && modId.isNotEmpty)
      ? modId
      : (fallbackModId ?? () => randomNumber().toString())().substring(0, 15);

  final line = <String, dynamic>{
    'itemSeq': itemSeq ?? item.itemSeq ?? 1,
    'itemCd': item.itemCd,
    'itemClsCd': item.itemClsCd,
    'itemNm': item.itemNm ?? item.name,
    'itemTyCd': item.itemTyCd,
    'itemStdNm': item.itemStdNm ?? item.name,
    'qtyUnitCd': item.qtyUnitCd ?? 'U',
    'pkgUnitCd': item.pkgUnitCd ?? 'CT',
    'pkg': 1,
    'qty': quantity,
    'prc': retailUnit,
    'splyAmt': _roundMoney(supplyUnit),
    'taxTyCd': item.taxTyCd ?? 'B',
    'taxblAmt': lineTotal,
    'taxAmt': 0,
    'totAmt': lineTotal,
      'totDcAmt': '0',
      'orgnNatCd': item.orgnNatCd ?? 'RW',
      'isrcAplcbYn': 'N',
      'regrId': item.regrId?.toString() ?? effectiveModId,
      'regrNm': item.regrNm ?? item.regrId?.toString() ?? effectiveModId,
      'modrId': effectiveModId,
      'modrNm': item.modrNm ?? effectiveModId,
    };

    final bcd = item.bcd;
    if (bcd != null && bcd.isNotEmpty) {
      line['bcd'] = bcd;
    }

    // Never strip required RRA keys (empty itemCd caused silent portal misses).
    const keepIfPresent = {
      'itemCd',
      'itemClsCd',
      'itemTyCd',
      'itemNm',
      'itemStdNm',
      'qty',
      'pkg',
      'prc',
      'splyAmt',
      'taxTyCd',
      'taxblAmt',
      'taxAmt',
      'totAmt',
      'totDcAmt',
    };
    line.removeWhere((key, value) {
      if (keepIfPresent.contains(key)) return false;
      return value == null || (value is String && value.isEmpty);
    });
    return line;
}

/// Builds the JSON body for `POST stock/saveStockItems` (pure; no HTTP).
Map<String, dynamic> buildRraSaveStockItemsRequest({
  required List<TransactionItem> items,
  required List<Map<String, dynamic>> itemList,
  required String tinNumber,
  required String bhfId,
  required String sarTyCd,
  required String regTyCd,
  required String ocrnDt,
  required double totalSupplyPrice,
  required double totalvat,
  required double totalAmount,
  required String remark,
  required String? sarNo,
  required int orgSarNo,
  String? saleCustomerName,
  String? saleCustTin,
  String? saleCustBhfId,
  String Function()? fallbackRegistrarId,
}) {
  final registrar = rraStockIoRegistrarFields(
    items,
    fallbackRegistrarId: fallbackRegistrarId,
  );
  final incoming = isIncomingRraStockIo(sarTyCd);

  final json = <String, dynamic>{
    'totItemCnt': items.length,
    'tin': tinNumber,
    'bhfId': bhfId,
    'regTyCd': regTyCd,
    'sarTyCd': sarTyCd,
    'ocrnDt': ocrnDt,
    'totTaxblAmt': _roundMoney(totalSupplyPrice),
    'totTaxAmt': _roundMoney(totalvat),
    'totAmt': _roundMoney(totalAmount),
    'remark': remark,
    'regrId': registrar['regrId'],
    'regrNm': registrar['regrNm'],
    'modrId': registrar['modrId'],
    'modrNm': registrar['modrNm'],
    'sarNo': sarNo,
    'orgSarNo': orgSarNo,
    'itemList': itemList,
  };

  if (!incoming) {
    final name = saleCustomerName?.trim();
    json['custNm'] = (name != null && name.isNotEmpty) ? name : 'N/A';
    if (saleCustBhfId != null && saleCustBhfId.isNotEmpty) {
      json['custBhfId'] = saleCustBhfId;
    }
    if (saleCustTin != null && saleCustTin.isNotEmpty) {
      json['custTin'] = saleCustTin;
    }
  }

  return json;
}

/// LocalStorage key prefix for stocking levels at POS sale-completion time,
/// keyed by Ditto [`Stock`] id (`stockId`).
const String kRraSaleStockSnapshotPrefix = 'rra_sale_stock_snapshot_';

String rraSaleStockSnapshotBoxKey(String transactionId) =>
    '$kRraSaleStockSnapshotPrefix$transactionId';

/// Whether a sale line can skip local stock decrement.
///
/// [quantityShipped] alone is not trusted — a prior failed deduct can mark
/// shipped without lowering Ditto stock (perf refactor regression).
bool saleLineAlreadyStockDeducted({
  required TransactionItem item,
  required Map<String, Variant> variantsByVariantId,
  required Map<String, Stock> stocksByStockId,
  required Map<String, double>? preSaleStockByStockId,
  double tolerance = 0.001,
}) {
  if (item.quantityShipped != item.qty.toInt()) return false;

  final vid = item.variantId;
  if (vid == null || vid.isEmpty) return true;

  final sid = variantsByVariantId[vid]?.stockId;
  if (sid == null || sid.isEmpty) return true;

  final preSale = preSaleStockByStockId?[sid];
  if (preSale == null) return true;

  final current = stocksByStockId[sid]?.currentStock?.toDouble() ?? 0.0;
  final expectedAfterSale = _roundMoney(preSale - item.qty.toDouble());
  if (expectedAfterSale < 0) return current <= tolerance;
  return current <= expectedAfterSale + tolerance;
}

/// Resolves [sarTyCd] for post-[saveSales] `stock/saveStockItems` (matches [TaxController]).
///
/// Deferred post-sale sync ([runPostSaleStockDeductionAndRraSync]) must use the same
/// codes as the pre-performance path (e.g. [StockInOutType.sale] for NS/CS), not `"06"`.
/// Invoice counter used for post-sale `sarNo` / `orgSarNo` after the sign-only path.
int? resolvePostSaleInvoiceNo({
  int? invoiceNumber,
  int? receiptNumber,
  int? totalReceiptNumber,
}) {
  for (final n in [invoiceNumber, receiptNumber, totalReceiptNumber]) {
    if (n != null && n > 0) return n;
  }
  return null;
}

String resolveRraStockIoSarTyCd({
  String? sarTyCd,
  String? receiptType,
  String? transactionSarTyCd,
}) {
  if (sarTyCd != null && sarTyCd.isNotEmpty) return sarTyCd;
  // Retail sale receipts are always outgoing stock (11). Do not reuse
  // [transactionSarTyCd] from prior stock adjustments (e.g. "06").
  switch (receiptType) {
    case 'NS':
    case 'CS':
    case 'TS':
    case 'PS':
      return StockInOutType.sale;
    case 'NR':
    case 'TR':
      return StockInOutType.returnIn;
    default:
      break;
  }
  if (transactionSarTyCd != null && transactionSarTyCd.isNotEmpty) {
    return transactionSarTyCd;
  }
  return StockInOutType.sale;
}

/// Parses [JSON-encoded] `{ stockId -> qty }` from [LocalStorage.writeString].
Map<String, double>? decodeRraSaleStockSnapshot(String? encoded) {
  if (encoded == null || encoded.isEmpty) return null;
  try {
    final decoded = jsonDecode(encoded);
    if (decoded is! Map) return null;
    final out = <String, double>{};
    decoded.forEach((k, v) {
      final key = k is String ? k : '$k';
      final n = (v as num?)?.toDouble();
      if (n != null) out[key] = n;
    });
    return out;
  } catch (_) {
    return null;
  }
}

/// Computes per transaction line how many units should be reported to RRA stock
/// movement (`stock/saveStockItems`) given on-hand qty at sale start per [stockId].
///
/// When [allowSellingBelowStock] is false or [snapshotByStockId] is null/empty,
/// each non-service line uses its full sale [TransactionItem.qty].
///
/// Service lines ([itemTyCd] == `"3"`) get allocation `null` — callers should
/// omit them before building RRA payloads (same as legacy filters).
///
/// Ordering: preserves [items] iteration while consuming a remaining budget per
/// [Variant.stockId] from [snapshotByStockId] (values floored at `0`).
Map<String, num> rraAllocatedQtyByTransactionItemId({
  required List<TransactionItem> items,
  required Map<String, Variant> variantsByVariantId,
  required Map<String, double>? snapshotByStockId,
  required bool allowSellingBelowStock,
}) {
  final useCap =
      allowSellingBelowStock &&
      snapshotByStockId != null &&
      snapshotByStockId.isNotEmpty;

  final remainingBudget = useCap
      ? snapshotByStockId.map(
          (k, v) => MapEntry(k, v <= 0 ? 0.0 : v.toDouble()),
        )
      : <String, double>{};

  final out = <String, num>{};
  for (final item in items) {
    if (item.variantId == null || item.variantId!.isEmpty) {
      continue;
    }
    if (item.itemTyCd == '3') {
      out[item.id] = 0;
      continue;
    }
    if (!useCap) {
      out[item.id] = item.qty;
      continue;
    }

    final variant = variantsByVariantId[item.variantId!];
    final sid = variant?.stockId;
    if (sid == null || sid.isEmpty || !remainingBudget.containsKey(sid)) {
      out[item.id] = item.qty;
      continue;
    }

    final budget = remainingBudget[sid] ?? 0.0;
    final lineQty = item.qty.toDouble();
    final take = lineQty < budget ? lineQty : budget;
    remainingBudget[sid] = budget - take;
    out[item.id] = take;
  }
  return out;
}

/// Builds non-service [`TransactionItem`] rows for [`saveStockItems`] with qty set to the
/// RRA-reported movement (possibly less than sold qty when overselling).
List<TransactionItem> movementItemsWithRraCapAllocation(
  List<TransactionItem> items,
  Map<String, num> allocations,
) {
  final capped = <TransactionItem>[];
  for (final item in items) {
    if (item.itemTyCd == '3') continue;
    final vid = item.variantId;
    if (vid == null || vid.isEmpty) continue;
    final allocated = allocations[item.id];
    if (allocated == null || allocated <= 0) continue;
    if (allocated == item.qty) {
      capped.add(item);
    } else {
      capped.add(item.copyWith(qty: allocated));
    }
  }
  return capped;
}
