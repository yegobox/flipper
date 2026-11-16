import 'dart:math' as math;

import 'package:flipper_models/sync/utils/stock_qty_milli.dart';
import 'package:supabase_models/brick/models/variant.model.dart';

/// Severity of a restock alert (only for items with a min-stock alert).
enum StockSeverity { low, critical }

/// Row status in the all-products list. Exactly one per line, highest first:
/// [out] (nothing on hand) > [critical] > [low] (min-stock alerts) > [ok].
enum StockValueLineStatus { ok, low, critical, out }

/// Category label for variants with no usable category.
const String kStockValueOtherCategory = 'Other';

/// RRA item type for services: they have no stock to value.
const String kServiceItemTyCd = '3';

class StockValueProductLine {
  final String variantId;
  final String name;
  final String categoryName;
  final String? bcd;
  final double unitPrice;

  /// Last purchase price per unit; 0 when unknown.
  final double supplyPrice;
  final double currentStock;
  final double minStock;

  /// Units on hand × [unitPrice]. Never negative: a negative on-hand count is
  /// a data problem to fix, not stock the shop owns.
  final double lineValue;

  /// Units on hand × [supplyPrice]; 0 when the cost is unknown.
  final double costValue;
  final StockValueLineStatus status;

  const StockValueProductLine({
    required this.variantId,
    required this.name,
    required this.categoryName,
    required this.bcd,
    required this.unitPrice,
    this.supplyPrice = 0,
    required this.currentStock,
    required this.minStock,
    required this.lineValue,
    this.costValue = 0,
    required this.status,
  });
}

class StockValueTopItem {
  final String name;
  final String categoryName;
  final double lineValue;
  final double currentStock;
  final double lineShareOfTotal;

  const StockValueTopItem({
    required this.name,
    required this.categoryName,
    required this.lineValue,
    required this.currentStock,
    required this.lineShareOfTotal,
  });
}

class StockValueLowItem {
  final String variantId;
  final String name;
  final String categoryName;
  final String? bcd;
  final double currentStock;
  final double minStock;
  final StockSeverity severity;

  const StockValueLowItem({
    required this.variantId,
    required this.name,
    required this.categoryName,
    required this.bcd,
    required this.currentStock,
    required this.minStock,
    required this.severity,
  });
}

class StockValueCategoryBreakdown {
  final String categoryName;
  final int productsCount;
  final double value;
  final double percentOfTotal; // 0..1

  const StockValueCategoryBreakdown({
    required this.categoryName,
    required this.productsCount,
    required this.value,
    required this.percentOfTotal,
  });
}

class StockValueReportData {
  final String branchId;
  final int productsCount;

  /// Lines with status [StockValueLineStatus.ok].
  final int healthyStockCount;
  final double totalValue;

  /// Value at last purchase price, over lines whose cost is known.
  final double totalCostValue;

  /// Retail value minus cost, over the same lines as [totalCostValue] only,
  /// so items with no recorded cost never inflate it.
  final double marginValue;

  /// Items whose min-stock alert fired (`showAlert && minStock > 0 &&
  /// currentStock <= minStock`). Unchanged meaning: the dashboard tile reads it.
  final int needsRestockCount;
  final int lowCount;
  final int criticalCount;
  final int outOfStockCount;
  final List<StockValueProductLine> allProducts;
  final StockValueTopItem? topByLineValue;
  final List<StockValueLowItem> lowAndCriticalItems;
  final List<StockValueCategoryBreakdown> valueByCategory;
  final bool isPossiblyIncomplete;

  const StockValueReportData({
    required this.branchId,
    required this.productsCount,
    required this.healthyStockCount,
    required this.totalValue,
    this.totalCostValue = 0,
    this.marginValue = 0,
    required this.needsRestockCount,
    this.lowCount = 0,
    this.criticalCount = 0,
    this.outOfStockCount = 0,
    required this.allProducts,
    this.topByLineValue,
    required this.lowAndCriticalItems,
    required this.valueByCategory,
    required this.isPossiblyIncomplete,
  });

  static StockValueReportData empty({
    String branchId = '',
    bool isPossiblyIncomplete = true,
  }) => StockValueReportData(
    branchId: branchId,
    productsCount: 0,
    healthyStockCount: 0,
    totalValue: 0,
    needsRestockCount: 0,
    allProducts: const [],
    lowAndCriticalItems: const [],
    valueByCategory: const [],
    isPossiblyIncomplete: isPossiblyIncomplete,
  );
}

class StockValueSummaryData {
  final String branchId;
  final double totalValue;
  final int needsRestockCount;
  final int productsCount;
  final bool isPossiblyIncomplete;

  const StockValueSummaryData({
    required this.branchId,
    required this.totalValue,
    required this.needsRestockCount,
    required this.productsCount,
    required this.isPossiblyIncomplete,
  });
}

double _asDouble(dynamic v) {
  if (v == null) return 0;
  if (v is num) return v.toDouble();
  return double.tryParse(v.toString()) ?? 0;
}

double _effectiveUnitPrice(Variant variant) {
  final retail = (variant.retailPrice ?? 0).toDouble();
  if (retail > 0) return retail;
  return (variant.supplyPrice ?? 0).toDouble();
}

/// On-hand qty for a raw `stocks` document.
///
/// Prefers the `currentStockMilli` COUNTER over the `currentStock` register —
/// the register lags behind concurrent deducts, so valuing off it overstates
/// stock on a busy till.
double stockValueOnHandQty(Map<String, dynamic>? stock) {
  if (stock == null) return 0;
  final milli = parseStockMilli(stock[stockCurrentStockMilliField]);
  if (milli != null) return fromMilli(milli);
  return _asDouble(stock['currentStock']);
}

StockSeverity _severityFor({
  required double currentStock,
  required double minStock,
}) {
  if (currentStock <= 0) return StockSeverity.critical;
  if (minStock <= 0) return StockSeverity.low;
  return currentStock <= (minStock * 0.5)
      ? StockSeverity.critical
      : StockSeverity.low;
}

final RegExp _uuidLike = RegExp(
  r'^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$',
  caseSensitive: false,
);

/// The category label to show for [variant].
///
/// Some variants carry the category *id* in `categoryName` (seen in the field
/// as UUIDs in the Value-by-category legend), so ids are resolved through
/// [categoryNames] (category id → name) and an unresolvable id is never shown.
String resolveStockValueCategory(
  Variant variant,
  Map<String, String> categoryNames,
) {
  String? named(String? id) {
    final key = id?.trim();
    if (key == null || key.isEmpty) return null;
    final name = categoryNames[key]?.trim();
    return (name == null || name.isEmpty) ? null : name;
  }

  final byId = named(variant.categoryId);
  if (byId != null) return byId;
  final raw = variant.categoryName?.trim() ?? '';
  if (raw.isEmpty) return kStockValueOtherCategory;
  final rawAsId = named(raw);
  if (rawAsId != null) return rawAsId;
  if (_uuidLike.hasMatch(raw)) return kStockValueOtherCategory;
  return raw;
}

/// Builds the report from already-loaded rows. Pure, so it is unit-tested.
///
/// [stockById] maps a variant's `stockId` to its raw `stocks` document.
/// [categoryNames] maps category ids to names. Services are left out: they
/// have no stock to value.
StockValueReportData buildStockValueReport({
  required String branchId,
  required Iterable<Variant> variants,
  required Map<String, Map<String, dynamic>> stockById,
  Map<String, String> categoryNames = const {},
  bool isPossiblyIncomplete = false,
}) {
  double totalValue = 0;
  double totalCostValue = 0;
  double marginValue = 0;
  int needsRestockCount = 0;
  int lowCount = 0;
  int criticalCount = 0;
  int outCount = 0;
  final lowCritical = <StockValueLowItem>[];
  final allLines = <StockValueProductLine>[];
  final categoryValue = <String, double>{};
  final categoryCount = <String, int>{};

  for (final v in variants) {
    if (v.itemTyCd == kServiceItemTyCd) continue;

    final stockId = v.stockId;
    final stock = stockId == null ? null : stockById[stockId];

    final currentStock = stockValueOnHandQty(stock);
    final minStock = _asDouble(stock?['lowStock']);
    final showAlert = (stock?['showLowStockAlert'] ?? true) == true;
    final unitPrice = _effectiveUnitPrice(v);
    final supplyPrice = (v.supplyPrice ?? 0).toDouble();
    final onHand = currentStock > 0 ? currentStock : 0.0;
    final value = onHand * unitPrice;
    final cost = supplyPrice > 0 ? onHand * supplyPrice : 0.0;
    totalValue += value;
    totalCostValue += cost;
    if (supplyPrice > 0) marginValue += value - cost;

    final category = resolveStockValueCategory(v, categoryNames);
    categoryValue[category] = (categoryValue[category] ?? 0) + value;
    categoryCount[category] = (categoryCount[category] ?? 0) + 1;

    final needsRestock = showAlert && minStock > 0 && currentStock <= minStock;
    final severity = needsRestock
        ? _severityFor(currentStock: currentStock, minStock: minStock)
        : null;
    final StockValueLineStatus status;
    if (currentStock <= 0) {
      status = StockValueLineStatus.out;
      outCount += 1;
    } else if (severity == StockSeverity.critical) {
      status = StockValueLineStatus.critical;
      criticalCount += 1;
    } else if (severity == StockSeverity.low) {
      status = StockValueLineStatus.low;
      lowCount += 1;
    } else {
      status = StockValueLineStatus.ok;
    }

    allLines.add(
      StockValueProductLine(
        variantId: v.id,
        name: v.name,
        categoryName: category,
        bcd: v.bcd,
        unitPrice: unitPrice,
        supplyPrice: supplyPrice,
        currentStock: currentStock,
        minStock: minStock,
        lineValue: value,
        costValue: cost,
        status: status,
      ),
    );

    if (severity != null) {
      needsRestockCount += 1;
      lowCritical.add(
        StockValueLowItem(
          variantId: v.id,
          name: v.name,
          categoryName: category,
          bcd: v.bcd,
          currentStock: currentStock,
          minStock: minStock,
          severity: severity,
        ),
      );
    }
  }

  // Most valuable first: what an owner looks for on a stock value page.
  allLines.sort((a, b) {
    final byValue = b.lineValue.compareTo(a.lineValue);
    if (byValue != 0) return byValue;
    return a.name.toLowerCase().compareTo(b.name.toLowerCase());
  });

  final top = allLines.isEmpty || allLines.first.lineValue <= 0
      ? null
      : allLines.first;

  // Stable ordering: critical first, then lowest currentStock.
  lowCritical.sort((a, b) {
    final sev = b.severity.index.compareTo(a.severity.index);
    if (sev != 0) return sev;
    return a.currentStock.compareTo(b.currentStock);
  });

  final valueByCategory = categoryValue.entries.map((e) {
    final percent = totalValue <= 0 ? 0.0 : (e.value / totalValue);
    return StockValueCategoryBreakdown(
      categoryName: e.key,
      productsCount: categoryCount[e.key] ?? 0,
      value: e.value,
      percentOfTotal: math.min(1, math.max(0, percent)),
    );
  }).toList()..sort((a, b) => b.value.compareTo(a.value));

  return StockValueReportData(
    branchId: branchId,
    productsCount: allLines.length,
    healthyStockCount: allLines.length - lowCount - criticalCount - outCount,
    totalValue: totalValue,
    totalCostValue: totalCostValue,
    marginValue: marginValue,
    needsRestockCount: needsRestockCount,
    lowCount: lowCount,
    criticalCount: criticalCount,
    outOfStockCount: outCount,
    allProducts: allLines,
    topByLineValue: top == null
        ? null
        : StockValueTopItem(
            name: top.name,
            categoryName: top.categoryName,
            lineValue: top.lineValue,
            currentStock: top.currentStock,
            lineShareOfTotal: totalValue <= 0
                ? 0.0
                : top.lineValue / totalValue,
          ),
    lowAndCriticalItems: lowCritical,
    valueByCategory: valueByCategory,
    isPossiblyIncomplete: isPossiblyIncomplete,
  );
}
