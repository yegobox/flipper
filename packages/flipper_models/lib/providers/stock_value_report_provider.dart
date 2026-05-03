import 'dart:math' as math;

import 'package:flipper_models/providers/ditto_presence_provider.dart';
import 'package:flipper_models/providers/ebm_provider.dart';
import 'package:flipper_models/providers/scan_mode_provider.dart';
import 'package:flipper_models/SyncStrategy.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flipper_web/services/ditto_service.dart';

part 'stock_value_report_provider.g.dart';

enum StockSeverity { low, critical }

/// Row status in the all-products list (aligns with restock rules in the main loop).
enum StockValueLineStatus { ok, low, critical }

class StockValueProductLine {
  final String variantId;
  final String name;
  final String categoryName;
  final String? bcd;
  final double unitPrice;
  final double currentStock;
  final double minStock;
  final double lineValue;
  final StockValueLineStatus status;

  const StockValueProductLine({
    required this.variantId,
    required this.name,
    required this.categoryName,
    required this.bcd,
    required this.unitPrice,
    required this.currentStock,
    required this.minStock,
    required this.lineValue,
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

  /// Count of products not in the restock set (see loop: `showAlert && minStock > 0 && currentStock <= minStock`).
  final int healthyStockCount;
  final double totalValue;
  final int needsRestockCount;
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
    required this.needsRestockCount,
    required this.allProducts,
    this.topByLineValue,
    required this.lowAndCriticalItems,
    required this.valueByCategory,
    required this.isPossiblyIncomplete,
  });
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

double _stockValueFor({
  required Variant variant,
  required Map<String, dynamic>? stock,
}) {
  final qty = _asDouble(stock?['currentStock']);
  return qty * _effectiveUnitPrice(variant);
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

@riverpod
Future<StockValueReportData> stockValueReport(Ref ref) async {
  final branchId = ProxyService.box.getBranchId();
  if (branchId == null || branchId.isEmpty) {
    return const StockValueReportData(
      branchId: '',
      productsCount: 0,
      healthyStockCount: 0,
      totalValue: 0,
      needsRestockCount: 0,
      allProducts: [],
      topByLineValue: null,
      lowAndCriticalItems: [],
      valueByCategory: [],
      isPossiblyIncomplete: true,
    );
  }

  // “10% local dataset” resilience: if presence is missing, treat totals as partial.
  final presence = ref.watch(dittoPresenceProvider).asData?.value;
  final isPossiblyIncomplete = presence == null;

  final ditto = DittoService.instance.dittoInstance;
  if (ditto == null) {
    return StockValueReportData(
      branchId: branchId,
      productsCount: 0,
      healthyStockCount: 0,
      totalValue: 0,
      needsRestockCount: 0,
      allProducts: const [],
      topByLineValue: null,
      lowAndCriticalItems: const [],
      valueByCategory: const [],
      isPossiblyIncomplete: true,
    );
  }

  // Use the same variants fetch path as ProductView/OuterVariants:
  // `ProxyService.getStrategy(Strategy.capella).variants(...)` is Ditto-backed and
  // contains the canonical filtering logic (excluded names, statuses, etc).
  final vatEnabled = await getVatEnabledFromEbm();
  final taxTyCds = vatEnabled ? const ['A', 'B', 'C', 'TT'] : const ['D', 'TT'];
  final scanMode = ref.watch(scanningModeProvider);

  final paged = await ProxyService.getStrategy(Strategy.capella).variants(
    branchId: branchId,
    taxTyCds: taxTyCds,
    scanMode: scanMode,
    fetchRemote: true,
  );
  final variants = List<Variant>.from(paged.variants);

  // Only pull stocks for the stockIds we actually reference, to avoid unrelated
  // rows skewing joins when Ditto has stale/extra stock rows.
  final neededStockIds = variants
      .map((v) => v.stockId)
      .where((id) => id != null && id.isNotEmpty)
      .cast<String>()
      .toSet()
      .toList();

  Map<String, Map<String, dynamic>> stockById =
      <String, Map<String, dynamic>>{};
  if (neededStockIds.isNotEmpty) {
    final placeholders = neededStockIds
        .asMap()
        .keys
        .map((i) => ':sid$i')
        .join(', ');
    final stocksQuery = 'SELECT * FROM stocks WHERE _id IN ($placeholders)';
    final stocksArgs = <String, dynamic>{
      for (var i = 0; i < neededStockIds.length; i++)
        'sid$i': neededStockIds[i],
    };
    final stocksResult = await ditto.store.execute(
      stocksQuery,
      arguments: stocksArgs,
    );

    stockById = <String, Map<String, dynamic>>{
      for (final e in stocksResult.items)
        (e.value['_id'] ?? e.value['id']).toString(): Map<String, dynamic>.from(
          e.value,
        ),
    };
  }

  double totalValue = 0;
  int needsRestockCount = 0;
  final lowCritical = <StockValueLowItem>[];
  final allLines = <StockValueProductLine>[];

  final categoryValue = <String, double>{};
  final categoryCount = <String, int>{};

  for (final v in variants) {
    final stockId = v.stockId;
    final stock = stockId == null ? null : stockById[stockId];

    final currentStock = _asDouble(stock?['currentStock']);
    final minStock = _asDouble(stock?['lowStock']);
    final showAlert = (stock?['showLowStockAlert'] ?? true) == true;
    final unitPrice = _effectiveUnitPrice(v);

    final value = _stockValueFor(variant: v, stock: stock);
    totalValue += value;

    final categoryRaw = v.categoryName;
    final category = (categoryRaw == null || categoryRaw.trim().isEmpty)
        ? 'Other'
        : categoryRaw.trim();
    categoryValue[category] = (categoryValue[category] ?? 0) + value;
    categoryCount[category] = (categoryCount[category] ?? 0) + 1;

    final needsRestock = showAlert && minStock > 0 && currentStock <= minStock;
    final StockValueLineStatus lineStatus;
    if (needsRestock) {
      final sev = _severityFor(currentStock: currentStock, minStock: minStock);
      lineStatus = sev == StockSeverity.critical
          ? StockValueLineStatus.critical
          : StockValueLineStatus.low;
    } else {
      lineStatus = StockValueLineStatus.ok;
    }

    allLines.add(
      StockValueProductLine(
        variantId: v.id,
        name: v.name,
        categoryName: category,
        bcd: v.bcd,
        unitPrice: unitPrice,
        currentStock: currentStock,
        minStock: minStock,
        lineValue: value,
        status: lineStatus,
      ),
    );

    if (needsRestock) {
      needsRestockCount += 1;
      lowCritical.add(
        StockValueLowItem(
          variantId: v.id,
          name: v.name,
          categoryName: category,
          bcd: v.bcd,
          currentStock: currentStock,
          minStock: minStock,
          severity: _severityFor(
            currentStock: currentStock,
            minStock: minStock,
          ),
        ),
      );
    }
  }

  allLines.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));

  StockValueTopItem? topByLineValue;
  for (final line in allLines) {
    if (line.lineValue <= 0) continue;
    if (topByLineValue == null) {
      topByLineValue = StockValueTopItem(
        name: line.name,
        categoryName: line.categoryName,
        lineValue: line.lineValue,
        currentStock: line.currentStock,
        lineShareOfTotal: totalValue <= 0 ? 0.0 : line.lineValue / totalValue,
      );
      continue;
    }
    if (line.lineValue > topByLineValue.lineValue) {
      topByLineValue = StockValueTopItem(
        name: line.name,
        categoryName: line.categoryName,
        lineValue: line.lineValue,
        currentStock: line.currentStock,
        lineShareOfTotal: totalValue <= 0 ? 0.0 : line.lineValue / totalValue,
      );
    } else if (line.lineValue == topByLineValue.lineValue) {
      if (line.name.toLowerCase().compareTo(topByLineValue.name.toLowerCase()) <
          0) {
        topByLineValue = StockValueTopItem(
          name: line.name,
          categoryName: line.categoryName,
          lineValue: line.lineValue,
          currentStock: line.currentStock,
          lineShareOfTotal: totalValue <= 0 ? 0.0 : line.lineValue / totalValue,
        );
      }
    }
  }

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
    productsCount: variants.length,
    healthyStockCount: variants.length - needsRestockCount,
    totalValue: totalValue,
    needsRestockCount: needsRestockCount,
    allProducts: allLines,
    topByLineValue: topByLineValue,
    lowAndCriticalItems: lowCritical,
    valueByCategory: valueByCategory,
    isPossiblyIncomplete: isPossiblyIncomplete,
  );
}

@riverpod
Future<StockValueSummaryData> stockValueSummary(Ref ref) async {
  final report = await ref.watch(stockValueReportProvider.future);
  return StockValueSummaryData(
    branchId: report.branchId,
    totalValue: report.totalValue,
    needsRestockCount: report.needsRestockCount,
    productsCount: report.productsCount,
    isPossiblyIncomplete: report.isPossiblyIncomplete,
  );
}
