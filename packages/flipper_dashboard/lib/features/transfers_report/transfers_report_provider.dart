import 'package:flipper_models/SyncStrategy.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Filter state for the HQ transfers-to-branch report.
class TransfersReportFilters {
  const TransfersReportFilters({
    this.destinationBranchId,
    this.start,
    this.end,
    this.status = 'all',
  });

  final String? destinationBranchId;
  final DateTime? start;
  final DateTime? end;

  /// `all` | [RequestStatus.pending] | [RequestStatus.approved]
  final String status;

  TransfersReportFilters copyWith({
    String? destinationBranchId,
    DateTime? start,
    DateTime? end,
    String? status,
    bool clearDestination = false,
  }) {
    return TransfersReportFilters(
      destinationBranchId: clearDestination
          ? null
          : (destinationBranchId ?? this.destinationBranchId),
      start: start ?? this.start,
      end: end ?? this.end,
      status: status ?? this.status,
    );
  }
}

final transfersReportFiltersProvider =
    StateProvider<TransfersReportFilters>((ref) {
  final now = DateTime.now();
  final startOfMonth = DateTime(now.year, now.month, 1);
  return TransfersReportFilters(
    destinationBranchId: ProxyService.box.getBranchId(),
    start: startOfMonth,
    end: DateTime(now.year, now.month, now.day, 23, 59, 59),
    status: 'all',
  );
});

/// Capella fetch of stock requests / transfers to the selected destination.
final transfersToBranchProvider =
    FutureProvider.autoDispose<List<InventoryRequest>>((ref) async {
  final filters = ref.watch(transfersReportFiltersProvider);
  final destId = filters.destinationBranchId;
  if (destId == null || destId.isEmpty) return [];

  final raw = await ProxyService.getStrategy(Strategy.capella)
      .stockRequestsToBranch(
    destinationBranchId: destId,
    start: filters.start,
    end: filters.end,
    status: filters.status,
  );

  // Hydrate embedded lines when the stock_requests doc omitted them.
  final out = <InventoryRequest>[];
  for (final request in raw) {
    if (request.transactionItems != null &&
        request.transactionItems!.isNotEmpty) {
      out.add(request);
      continue;
    }
    try {
      final lines = await ProxyService.getStrategy(Strategy.capella)
          .transactionItems(requestId: request.id);
      if (lines.isNotEmpty) {
        request.transactionItems = lines;
      }
    } catch (_) {}
    out.add(request);
  }
  return out;
});
