import 'dart:async';

import 'package:ditto_live/ditto_live.dart' show Ditto;
import 'package:flipper_models/providers/ditto_presence_provider.dart';
import 'package:flipper_models/providers/ebm_provider.dart';
import 'package:flipper_models/providers/scan_mode_provider.dart';
import 'package:flipper_models/providers/stock_value_report_data.dart';
import 'package:flipper_models/SyncStrategy.dart';
import 'package:flipper_models/sync/utils/stock_qty_milli.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flipper_web/services/ditto_service.dart';

export 'package:flipper_models/providers/stock_value_report_data.dart';

part 'stock_value_report_provider.g.dart';

/// Whether Ditto presence is missing right now ("10% local dataset"
/// resilience: without presence the totals may be partial).
///
/// Read once, never watched: presence is polled every 2 s and its graph
/// changes with every peer or link change, and watching it re-ran the whole
/// report (every variant and stock) that often on this screen and on the
/// dashboard tile.
Future<bool> _presenceMissing(Ref ref) async {
  try {
    final graph = await ref
        .read(dittoPresenceProvider.future)
        .timeout(const Duration(milliseconds: 500));
    return graph == null;
  } catch (_) {
    return true;
  }
}

/// Category id → name for the branch, so variants that store the category id
/// in `categoryName` still show a readable label.
Future<Map<String, String>> _categoryNames(Ditto ditto, String branchId) async {
  try {
    final result = await ditto.store.execute(
      'SELECT _id, id, name FROM categories WHERE branchId = :branchId',
      arguments: {'branchId': branchId},
    );
    final names = <String, String>{};
    for (final item in result.items) {
      final doc = Map<String, dynamic>.from(item.value);
      final name = doc['name']?.toString().trim() ?? '';
      if (name.isEmpty) continue;
      for (final key in [doc['_id'], doc['id']]) {
        final id = key?.toString().trim() ?? '';
        if (id.isNotEmpty) names[id] = name;
      }
    }
    return names;
  } catch (_) {
    return const {};
  }
}

@riverpod
Future<StockValueReportData> stockValueReport(Ref ref) async {
  final branchId = ProxyService.box.getBranchId();
  if (branchId == null || branchId.isEmpty) {
    return StockValueReportData.empty();
  }

  final ditto = DittoService.instance.dittoInstance;
  if (ditto == null) {
    return StockValueReportData.empty(branchId: branchId);
  }

  // Started now, awaited last: neither needs the variants.
  final presenceMissing = _presenceMissing(ref);
  final categoryNames = _categoryNames(ditto, branchId);

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
    final stocksQuery = stockSelectWithMilliDql(
      whereClause: '_id IN ($placeholders)',
    );
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

  return buildStockValueReport(
    branchId: branchId,
    variants: variants,
    stockById: stockById,
    categoryNames: await categoryNames,
    isPossiblyIncomplete: await presenceMissing,
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
