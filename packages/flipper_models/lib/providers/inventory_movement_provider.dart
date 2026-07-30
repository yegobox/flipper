import 'package:flipper_models/SyncStrategy.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_models/helpers/inventory_movement.dart';
import 'package:flipper_models/helpers/transaction_report_plu_filters.dart';
import 'package:flipper_models/providers/transactions_provider.dart'
    show transactionReportLineMatchesSale;
import 'package:flipper_models/sync/capella/capella_sync.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// The window enum and the movement maths live in a dependency-free helper so
// they stay unit-testable; callers only need this import.
export 'package:flipper_models/helpers/inventory_movement.dart';

/// A dated stock reading taken from a sale line: stock left after the line sold.
class _LedgerPoint {
  const _LedgerPoint({
    required this.at,
    required this.remainingStock,
    required this.qty,
  });

  final DateTime at;
  final double remainingStock;
  final double qty;

  /// Stock that must have been on the shelf immediately before this line sold.
  double get stockBefore => remainingStock + qty;
}

/// Real stock movement per variant, read from completed sales and recounts.
///
/// Ditto is the source of truth here (same path as Transaction Reports), so
/// figures match the reports rather than the `initialStock - currentStock`
/// approximation the inventory dashboard used to show.
final inventoryMovementProvider = FutureProvider.autoDispose
    .family<InventoryMovementData, ({String branchId, InventoryWindow window})>(
  (ref, args) async {
    final range = inventoryWindowRange(args.window);
    if (args.branchId.isEmpty) {
      return InventoryMovementData.unavailableFor(
        branchId: args.branchId,
        window: args.window,
        start: range.start,
        end: range.end,
      );
    }

    try {
      final capella = ProxyService.getStrategy(Strategy.capella) as CapellaSync;

      // Reach back past the window when collecting sale ids: a ticket parked on
      // Monday and settled on Thursday carries line dates inside the window
      // while the sale itself falls outside it. Lines are still scoped to the
      // window — this only decides which parents count as completed sales.
      final sales = await capella.transactions(
        startDate: range.start.subtract(const Duration(days: 14)),
        endDate: range.end,
        branchId: args.branchId,
        status: COMPLETE,
        includeZeroSubTotal: true,
      );
      final saleIds = sales.map((tx) => tx.id.toString()).toSet();

      final lines = await capella.fetchTransactionItemsReportScope(
        startDate: range.start,
        endDate: range.end,
        branchId: args.branchId,
      );

      final sold = <String, _SoldAccumulator>{};
      final countedSaleIds = <String>{};
      for (final item in lines) {
        final variantId = item.variantId?.trim();
        if (variantId == null || variantId.isEmpty) continue;
        if (item.ignoreForReport) continue;
        if (transactionReportCashMovementPluLine(item)) continue;
        if (saleIds.isNotEmpty &&
            !transactionReportLineMatchesSale(item, saleIds)) {
          continue;
        }

        final acc = sold.putIfAbsent(variantId, _SoldAccumulator.new);
        acc.add(item);
        final tid = item.transactionId?.trim();
        if (tid != null && tid.isNotEmpty) countedSaleIds.add(tid);
      }

      final adjustments = await _readAdjustments(
        capella: capella,
        branchId: args.branchId,
        start: range.start,
        end: range.end,
      );

      final byVariant = <String, VariantMovement>{};
      for (final variantId in {...sold.keys, ...adjustments.keys}) {
        final acc = sold[variantId];
        final adjustment = adjustments[variantId];
        byVariant[variantId] = (acc ?? _SoldAccumulator()).build(
          variantId: variantId,
          adjustment: adjustment?.total ?? 0,
          lastCountedAt: adjustment?.lastCountedAt,
        );
      }

      return InventoryMovementData(
        branchId: args.branchId,
        window: args.window,
        start: range.start,
        end: range.end,
        byVariant: byVariant,
        // Sales that actually contributed counted lines, so the figure matches
        // the units on screen rather than counting cash-book-only receipts.
        salesCount: countedSaleIds.length,
        unavailable: false,
      );
    } catch (e, s) {
      talker.error('inventoryMovementProvider: $e', s);
      return InventoryMovementData.unavailableFor(
        branchId: args.branchId,
        window: args.window,
        start: range.start,
        end: range.end,
      );
    }
  },
);

class _AdjustmentTotal {
  double total = 0;
  DateTime? lastCountedAt;
}

/// Net counted differences from stock recounts submitted inside the window.
/// Draft sessions are ignored — they have not touched stock yet.
Future<Map<String, _AdjustmentTotal>> _readAdjustments({
  required CapellaSync capella,
  required String branchId,
  required DateTime start,
  required DateTime end,
}) async {
  final out = <String, _AdjustmentTotal>{};
  try {
    final recounts = await capella.getRecounts(branchId: branchId);
    final inWindow = recounts.where((r) {
      if (r.status == 'draft') return false;
      final at = r.submittedAt ?? r.syncedAt ?? r.createdAt;
      final local = at.isUtc ? at.toLocal() : at;
      return !local.isBefore(start) && !local.isAfter(end);
    }).toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

    // Bounded: a branch counting more than this in one window is an outlier,
    // and each session costs a query.
    for (final recount in inWindow.take(30)) {
      final items = await capella.getRecountItems(recountId: recount.id);
      for (final item in items) {
        if (item.difference == 0) continue;
        final acc = out.putIfAbsent(item.variantId, _AdjustmentTotal.new);
        acc.total += item.difference;
        final at = recount.submittedAt ?? recount.syncedAt ?? recount.createdAt;
        final local = at.isUtc ? at.toLocal() : at;
        if (acc.lastCountedAt == null || local.isAfter(acc.lastCountedAt!)) {
          acc.lastCountedAt = local;
        }
      }
    }
  } catch (e) {
    talker.warning('inventoryMovement adjustments: $e');
  }
  return out;
}

class _SoldAccumulator {
  double units = 0;
  double refunded = 0;
  double revenue = 0;
  double profit = 0;
  DateTime? lastSoldAt;
  final Set<String> transactionIds = <String>{};
  final List<_LedgerPoint> ledger = <_LedgerPoint>[];

  void add(TransactionItem item) {
    final qty = item.qty.toDouble();
    final at = item.createdAt ?? item.lastTouched ?? item.updatedAt;

    if (item.isRefunded == true) {
      refunded += qty.abs();
      return;
    }

    units += qty;
    revenue += item.price.toDouble() * qty;
    profit += TransactionItemPluMetrics.profitMade(item);

    final tid = item.transactionId?.trim();
    if (tid != null && tid.isNotEmpty) transactionIds.add(tid);

    if (at != null && (lastSoldAt == null || at.isAfter(lastSoldAt!))) {
      lastSoldAt = at;
    }

    final remaining = item.remainingStock?.toDouble();
    if (at != null && remaining != null) {
      ledger.add(_LedgerPoint(at: at, remainingStock: remaining, qty: qty));
    }
  }

  VariantMovement build({
    required String variantId,
    required double adjustment,
    required DateTime? lastCountedAt,
  }) {
    ledger.sort((a, b) => a.at.compareTo(b.at));

    double? opening;
    double? restocked;
    double? lastRemaining;

    if (ledger.isNotEmpty) {
      opening = ledger.first.stockBefore;
      lastRemaining = ledger.last.remainingStock;
      var received = 0.0;
      for (var i = 1; i < ledger.length; i++) {
        // Stock stood higher before this line than it did after the previous
        // one, so units came in between the two sales.
        final gap = ledger[i].stockBefore - ledger[i - 1].remainingStock;
        if (gap > 0.001) received += gap;
      }
      restocked = received;
    }

    return VariantMovement(
      variantId: variantId,
      unitsSold: units,
      unitsRefunded: refunded,
      revenue: revenue,
      profit: profit,
      saleCount: transactionIds.length,
      lastSoldAt: lastSoldAt,
      adjustment: adjustment,
      lastCountedAt: lastCountedAt,
      openingStock: opening,
      restocked: restocked,
      lastRemainingStock: lastRemaining,
    );
  }
}
