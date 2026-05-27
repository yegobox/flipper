import 'package:flipper_models/helperModels/transaction_report_snapshot.dart';
import 'package:flipper_models/providers/date_range_provider.dart';
import 'package:flipper_dashboard/export/transaction_report_full_export_loader.dart';
import 'package:flipper_dashboard/providers/transaction_report_filters_provider.dart';
import 'package:flipper_services/proxy.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Full-period snapshot when the Transactions report shows the chart tab (heavy).
final transactionReportChartSnapshotProvider =
    FutureProvider.family<TransactionReportSnapshot, bool>((ref, forceRealData) async {
  final filters = ref.watch(transactionReportFiltersProvider);
  if (filters.viewMode != TransactionReportViewMode.chart) {
    return const TransactionReportSnapshot(
      transactions: [],
      paymentSumsByTransactionId: {},
      totalRowCount: 0,
    );
  }

  final range = ref.watch(dateRangeProvider);
  final start = range.startDate;
  final end = range.endDate;
  if (start == null || end == null) {
    return const TransactionReportSnapshot(
      transactions: [],
      paymentSumsByTransactionId: {},
      totalRowCount: 0,
    );
  }

  final branchId = ProxyService.box.getBranchId();
  if (branchId == null || branchId.isEmpty) {
    throw StateError('Branch ID is required');
  }

  final full = await loadTransactionReportSnapshotFullForExport(
    startDate: start,
    endDate: end,
    branchId: branchId,
    forceRealData: forceRealData,
  );
  return applyTransactionFiltersToSnapshot(full, filters);
});
