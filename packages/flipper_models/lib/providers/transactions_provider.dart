import 'dart:math' show min;

import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_models/helperModels/transaction_payment_sums.dart';
import 'package:flipper_models/helperModels/transaction_report_snapshot.dart';
import 'package:flipper_models/helperModels/transaction_report_kpi_totals.dart';
import 'package:flipper_models/helpers/transaction_item_plu_metrics.dart';
import 'package:flipper_models/helpers/transaction_report_payment_totals.dart';
import 'package:flipper_models/helpers/transaction_report_plu_filters.dart';
import 'package:flipper_models/providers/date_range_provider.dart';
import 'package:flipper_models/sync/capella/capella_sync.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/SyncStrategy.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:rxdart/rxdart.dart';

part 'transactions_provider.g.dart';

/// Transactions shown in Transaction Reports grid: completed and parked,
/// including expenses (cash out, etc.) so rows match KPIs that use [expensesStream].
List<ITransaction> transactionReportScopeFilter(List<ITransaction> all) {
  return all
      .where((tx) => tx.status == COMPLETE || tx.status == PARKED)
      .toList();
}

/// Matches line items to parent sales on the current report page (uuid string tolerant).
/// Same Ditto stream as [transactionItemList] / detailed grid; used when one-shot fetch is empty.
Future<List<TransactionItem>> waitReportPluLinesFromStream({
  required CapellaSync capella,
  required DateTime startDate,
  required DateTime endDate,
  required String branchId,
}) async {
  try {
    final lines = await capella
        .transactionItemsStreams(
          startDate: startDate,
          endDate: endDate,
          branchId: branchId,
          branchIdString: branchId,
          fetchRemote: false,
        )
        .where((items) => items.isNotEmpty)
        .first
        .timeout(const Duration(seconds: 15));
    talker.debug('waitReportPluLinesFromStream: ${lines.length} lines');
    return lines;
  } catch (e) {
    talker.warning('waitReportPluLinesFromStream: $e');
    return capella.fetchTransactionItemsReportScope(
      startDate: startDate,
      endDate: endDate,
      branchId: branchId,
    );
  }
}

bool transactionReportLineMatchesSale(
  TransactionItem item,
  Set<String> saleIds,
) {
  final tid = item.transactionId?.toString().trim();
  if (tid == null || tid.isEmpty) return false;
  if (saleIds.contains(tid)) return true;
  final compact = tid.replaceAll('-', '').toLowerCase();
  if (compact.isEmpty) return false;
  for (final id in saleIds) {
    if (id.replaceAll('-', '').toLowerCase() == compact) return true;
  }
  return false;
}

/// Chunks [getPaymentSumsByTransactionIds] to avoid huge IN-clause queries.
Future<Map<String, TransactionPaymentSums>>
getPaymentSumsByTransactionIdsChunked(
  List<String> transactionIds, {
  required String branchId,
  int chunkSize = 800,
}) async {
  if (transactionIds.isEmpty) return {};
  final strategy = ProxyService.getStrategy(Strategy.capella);
  final out = <String, TransactionPaymentSums>{};
  for (var i = 0; i < transactionIds.length; i += chunkSize) {
    final end = min(i + chunkSize, transactionIds.length);
    final chunk = transactionIds.sublist(i, end);
    final part = await strategy.getPaymentSumsByTransactionIds(
      chunk,
      branchId: branchId,
    );
    out.addAll(part);
  }
  return out;
}

@Riverpod(keepAlive: true)
class TransactionReportPageIndex extends _$TransactionReportPageIndex {
  @override
  int build() => 0;

  void setPage(int page) => state = page < 0 ? 0 : page;

  /// Call when the global report date range or rows-per-page policy changes.
  void reset() => state = 0;
}

// ---------------------------------------------------------------------------
// dashboardTransactionsProvider — intentionally kept on the default (SQLite)
// strategy; it has its own fixed 30-day window and must not be affected by the
// Capella migration.
// ---------------------------------------------------------------------------
final dashboardTransactionsProvider = StreamProvider<List<ITransaction>>((ref) {
  final endDate = DateTime.now();
  final startDate = endDate.subtract(const Duration(days: 30));
  final branchId = ProxyService.box.getBranchId();

  if (branchId == null) throw StateError('Branch ID is required');

  talker.debug('Dashboard transactions provider initialized with 30-day range');

  return ProxyService.strategy.transactionsStream(
    status: COMPLETE,
    includeParked: false,
    branchId: branchId,
    skipOriginalTransactionCheck: true,
    startDate: startDate,
    endDate: endDate,
    removeAdjustmentTransactions: true,
    forceRealData: true,
  );
});

// ---------------------------------------------------------------------------
// CORE STREAM — single Capella query for the active date range.
// Every derived provider below filters this list in Dart memory,
// so we hit the database exactly once per date-range change.
// ---------------------------------------------------------------------------
@riverpod
Stream<List<ITransaction>> coreTransactionsStream(
  Ref ref, {
  required DateTime startDate,
  required DateTime endDate,
  required String branchId,
  bool forceRealData = true,
  bool includeParked = false,
}) {
  talker.debug(
    'coreTransactionsStream: $startDate → $endDate  branch=$branchId '
    'includeParked=$includeParked',
  );
  return ProxyService.getStrategy(Strategy.capella).transactionsStream(
    startDate: startDate,
    endDate: endDate,
    branchId: branchId,
    // When includeParked is false: completed only. When true: completed + parked (+ waiting momo at SQL layer; filter in Dart for reports).
    skipOriginalTransactionCheck: true,
    removeAdjustmentTransactions: true,
    includeParked: includeParked,
    // isCashOut intentionally omitted → returns both income and expense.
    forceRealData: forceRealData,
  );
}

/// Recent Cash Book list: same Capella [coreTransactionsStream] source as dashboard KPIs,
/// rolling 30-day window, completed transactions only.
@riverpod
Stream<List<ITransaction>> cashbookRecentTransactions(Ref ref) {
  final endDate = DateTime.now();
  final startDate = endDate.subtract(const Duration(days: 30));
  final branchId =
      ProxyService.box.branchIdString() ?? ProxyService.box.getBranchId();
  if (branchId == null || branchId.isEmpty) {
    throw StateError('Branch ID is required');
  }

  talker.debug(
    'cashbookRecentTransactions: Capella 30-day window branch=$branchId',
  );

  return coreTransactionsStream(
    ref,
    startDate: startDate,
    endDate: endDate,
    branchId: branchId,
    forceRealData: true,
    includeParked: false,
  ).map((all) => all.where((tx) => tx.status == COMPLETE).toList());
}

/// Transactions screen list: Capella [coreTransactionsStream] for the global
/// [dateRangeProvider] window (aligned with Cash Book / dashboard analytics).
@riverpod
Stream<List<ITransaction>> transactionsScreenTransactions(Ref ref) {
  final dateRange = ref.watch(dateRangeProvider);
  final startDate = dateRange.startDate;
  final endDate = dateRange.endDate;

  if (startDate == null || endDate == null) {
    return Stream.value([]);
  }

  final branchId =
      ProxyService.box.branchIdString() ?? ProxyService.box.getBranchId();
  if (branchId == null || branchId.isEmpty) {
    throw StateError('Branch ID is required');
  }

  talker.debug(
    'transactionsScreenTransactions: $startDate → $endDate branch=$branchId',
  );

  return coreTransactionsStream(
    ref,
    startDate: startDate,
    endDate: endDate,
    branchId: branchId,
    forceRealData: true,
    includeParked: false,
  ).map((all) => all.where((tx) => tx.status == COMPLETE).toList());
}

// ---------------------------------------------------------------------------
// transactionReportSnapshot — paged async load (Capella SQL window + chunked payment sums).
// Matches report scope: COMPLETE + PARKED rows in range (agent-scoped like core stream).
// ---------------------------------------------------------------------------
@riverpod
Future<TransactionReportSnapshot> transactionReportSnapshot(
  Ref ref, {
  required bool forceRealData,
}) async {
  final dateRange = ref.watch(dateRangeProvider);
  final startDate = dateRange.startDate;
  final endDate = dateRange.endDate;

  if (startDate == null || endDate == null) {
    return const TransactionReportSnapshot(
      transactions: [],
      paymentSumsByTransactionId: {},
      totalRowCount: 0,
    );
  }

  final branchId = ProxyService.box.getBranchId();
  if (branchId == null) throw StateError('Branch ID is required');

  final rowsPerPage = ref.watch(rowsPerPageProvider);
  final pageIndex = ref.watch(transactionReportPageIndexProvider);
  final limit = rowsPerPage.clamp(1, 10000);
  final offset = pageIndex * limit;

  final capella = ProxyService.getStrategy(Strategy.capella) as CapellaSync;

  final total = await capella.countTransactionsReportPagingWindow(
    startDate: startDate,
    endDate: endDate,
    branchId: branchId,
    forceRealData: forceRealData,
  );

  final page = await capella.pageTransactionsReportPagingWindow(
    startDate: startDate,
    endDate: endDate,
    branchId: branchId,
    forceRealData: forceRealData,
    limit: limit,
    offset: offset,
  );

  final filtered = transactionReportScopeFilter(page);
  if (filtered.isEmpty) {
    return TransactionReportSnapshot(
      transactions: const [],
      paymentSumsByTransactionId: const {},
      totalRowCount: total,
    );
  }

  final ids = filtered.map((t) => t.id.toString()).toList();
  try {
    final sums = await getPaymentSumsByTransactionIdsChunked(
      ids,
      branchId: branchId,
    );
    return TransactionReportSnapshot(
      transactions: filtered,
      paymentSumsByTransactionId: sums,
      totalRowCount: total,
    );
  } catch (e, s) {
    talker.error('transactionReportSnapshot payment sums: $e\n$s');
    return TransactionReportSnapshot(
      transactions: filtered,
      paymentSumsByTransactionId: {
        for (final id in ids)
          id: const TransactionPaymentSums(
            byHand: 0,
            credit: 0,
            hasAnyRecord: false,
          ),
      },
      totalRowCount: total,
    );
  }
}

// ---------------------------------------------------------------------------
// transactionList — backward-compatible list-only view of the report snapshot page.
// ---------------------------------------------------------------------------
@riverpod
Future<List<ITransaction>> transactionList(
  Ref ref, {
  required bool forceRealData,
}) async {
  final snap = await ref.watch(
    transactionReportSnapshotProvider(forceRealData: forceRealData).future,
  );
  return snap.transactions;
}

// ---------------------------------------------------------------------------
// transactions — general-purpose COMPLETE sales stream (e.g. export / summary).
// ---------------------------------------------------------------------------
@riverpod
Stream<List<ITransaction>> transactions(Ref ref, {bool forceRealData = true}) {
  final dateRange = ref.watch(dateRangeProvider);
  final startDate = dateRange.startDate ?? DateTime.now();
  final endDate = dateRange.endDate ?? DateTime.now();
  final branchId = ProxyService.box.getBranchId();
  if (branchId == null) throw StateError('Branch ID is required');

  return coreTransactionsStream(
    ref,
    startDate: startDate,
    endDate: endDate,
    branchId: branchId,
    forceRealData: forceRealData,
  ).map(
    (all) => all
        .where((tx) => tx.status == COMPLETE && !(tx.isExpense ?? false))
        .toList(),
  );
}

// ---------------------------------------------------------------------------
// transactionItemList — PLU lines for Transaction Reports (detailed grid).
// Stream + Ditto observer (pre–May-26); joined to report-scoped sales in range.
// [filteredTransactionItemListProvider] narrows to the current page / UI filters.
// ---------------------------------------------------------------------------
@riverpod
Stream<List<TransactionItem>> transactionItemList(Ref ref) {
  final dateRange = ref.watch(dateRangeProvider);
  final startDate = dateRange.startDate;
  final endDate = dateRange.endDate;
  final branchId =
      ProxyService.box.branchIdString() ?? ProxyService.box.getBranchId();
  final forceRealData = !(ProxyService.box.enableDebug() ?? false);

  talker.debug('transactionItemList (stream) called');

  if (branchId == null) {
    talker.error('Branch ID is required');
    throw StateError('Branch ID is required');
  }
  if (startDate == null || endDate == null) {
    talker.warning('startDate or endDate is null, returning empty stream');
    return Stream.value(const <TransactionItem>[]);
  }

  final itemStream = ProxyService.getStrategy(Strategy.capella)
      .transactionItemsStreams(
        startDate: startDate,
        endDate: endDate,
        branchId: branchId,
        branchIdString: branchId,
        fetchRemote: false,
      )
      .startWith(const <TransactionItem>[]);

  final reportSalesStream = coreTransactionsStream(
    ref,
    startDate: startDate,
    endDate: endDate,
    branchId: branchId,
    forceRealData: forceRealData,
    includeParked: true,
  ).map(transactionReportScopeFilter).startWith(const <ITransaction>[]);

  // Rebuild when the paged report snapshot updates so PLU ids match visible sales.
  ref.watch(transactionReportSnapshotProvider(forceRealData: forceRealData));

  return Rx.combineLatest2<
    List<TransactionItem>,
    List<ITransaction>,
    List<TransactionItem>
  >(itemStream, reportSalesStream, (items, sales) {
    final snap = ref
        .read(transactionReportSnapshotProvider(forceRealData: forceRealData))
        .asData
        ?.value;
    final allowed = sales.map((t) => t.id.toString()).toSet();
    if (snap != null) {
      allowed.addAll(snap.transactions.map((t) => t.id.toString()));
    }
    final filtered = items
        .where((i) => transactionReportLineMatchesSale(i, allowed))
        .toList();
    if (items.isNotEmpty && filtered.isEmpty) {
      talker.warning(
        'transactionItemList: ${items.length} PLU rows but none matched '
        '${allowed.length} sale id(s); sample item tx=${items.first.transactionId}',
      );
    } else {
      talker.debug(
        'transactionItemList: ${items.length} raw → ${filtered.length} '
        'report-scoped lines (${allowed.length} sale ids)',
      );
    }
    return filtered;
  }).handleError((Object error, StackTrace stackTrace) {
    talker.error('Error loading transaction items: $error');
    throw error;
  });
}

// ---------------------------------------------------------------------------
// transactionReportKpiTotals — full-period PLU + payment rollups (batched; not page-limited).
// ---------------------------------------------------------------------------
@riverpod
Future<TransactionReportKpiTotals> transactionReportKpiTotals(Ref ref) async {
  final dateRange = ref.watch(dateRangeProvider);
  final startDate = dateRange.startDate;
  final endDate = dateRange.endDate;
  if (startDate == null || endDate == null) {
    return const TransactionReportKpiTotals();
  }
  final branchId = ProxyService.box.getBranchId();
  if (branchId == null) throw StateError('Branch ID is required');

  final forceRealData = !(ProxyService.box.enableDebug() ?? false);
  final capella = ProxyService.getStrategy(Strategy.capella) as CapellaSync;
  final branchIdForPlu =
      ProxyService.box.branchIdString() ?? branchId;

  // Recompute when the live PLU stream updates (same source as detailed grid).
  final pluAsync = ref.watch(transactionItemListProvider);
  var periodLines = pluAsync.asData?.value ?? const <TransactionItem>[];
  if (periodLines.isEmpty) {
    periodLines = await waitReportPluLinesFromStream(
      capella: capella,
      startDate: startDate,
      endDate: endDate,
      branchId: branchIdForPlu,
    );
  }

  var pluLineSales = 0.0;
  var pluGrossProfit = 0.0;
  var pluLineTax = 0.0;
  for (final item in periodLines) {
    if (transactionReportCashMovementPluLine(item)) continue;
    pluLineSales += item.price.toDouble() * item.qty.toDouble();
    pluGrossProfit += TransactionItemPluMetrics.profitMade(item);
    pluLineTax += TransactionItemPluMetrics.taxPayable(item);
  }

  var periodByHand = 0.0;
  var periodCredit = 0.0;

  const batchTx = 500;
  var offset = 0;
  while (true) {
    final batch = await capella.pageTransactionsReportPagingWindow(
      startDate: startDate,
      endDate: endDate,
      branchId: branchId,
      forceRealData: forceRealData,
      limit: batchTx,
      offset: offset,
    );
    if (batch.isEmpty) break;

    final scoped = transactionReportScopeFilter(batch);
    final ids = scoped.map((t) => t.id.toString()).toList();
    final sums = await getPaymentSumsByTransactionIdsChunked(
      ids,
      branchId: branchId,
    );

    for (final tx in scoped) {
      if (tx.isExpense == true) continue;
      final s = sums[tx.id.toString()];
      periodByHand += transactionReportByHandForTotals(tx, s);
      periodCredit += transactionReportCreditForTotals(tx, s);
    }

    offset += batch.length;
  }

  return TransactionReportKpiTotals(
    pluLineSales: pluLineSales,
    pluGrossProfit: pluGrossProfit,
    pluLineTax: pluLineTax,
    periodByHand: periodByHand,
    periodCredit: periodCredit,
  );
}

// ---------------------------------------------------------------------------
// expensesStream — cash-out / purchase transactions derived from coreStream.
// ---------------------------------------------------------------------------
@riverpod
Stream<List<ITransaction>> expensesStream(
  Ref ref, {
  required DateTime startDate,
  required DateTime endDate,
  String? branchId,
  bool forceRealData = true,
}) {
  final bid = branchId ?? ProxyService.box.getBranchId();
  if (bid == null) {
    talker.error('Branch ID is required for expensesStream');
    throw StateError('Branch ID is required');
  }

  return coreTransactionsStream(
    ref,
    startDate: startDate,
    endDate: endDate,
    branchId: bid,
    forceRealData: forceRealData,
  ).map((all) => all.where((tx) => tx.isExpense == true).toList());
}

// ---------------------------------------------------------------------------
// grossProfitStream — revenue from non-expense, non-refunded transactions.
// ---------------------------------------------------------------------------
@riverpod
Stream<double> grossProfitStream(
  Ref ref, {
  required DateTime startDate,
  required DateTime endDate,
  String? branchId,
  bool forceRealData = true,
}) {
  final bid = branchId ?? ProxyService.box.getBranchId();
  if (bid == null) {
    talker.error('Branch ID is required for grossProfitStream');
    throw StateError('Branch ID is required');
  }

  return coreTransactionsStream(
    ref,
    startDate: startDate,
    endDate: endDate,
    branchId: bid,
    forceRealData: forceRealData,
  ).map((all) {
    final income = all.where(
      (tx) => !(tx.isExpense ?? false) && !(tx.isRefunded ?? false),
    );
    return income.fold<double>(0.0, (sum, tx) => sum + (tx.subTotal ?? 0.0));
  });
}

// ---------------------------------------------------------------------------
// netProfitStream — gross revenue minus COGS, expenses and taxes.
// Both income and expenses come from the same coreTransactionsStream emission
// so they are always in sync.
// ---------------------------------------------------------------------------
@riverpod
Stream<double> netProfitStream(
  Ref ref, {
  required DateTime startDate,
  required DateTime endDate,
  String? branchId,
  bool forceRealData = true,
}) {
  final bid = branchId ?? ProxyService.box.getBranchId();
  if (bid == null) {
    talker.error('Branch ID is required for netProfitStream');
    throw StateError('Branch ID is required');
  }

  return coreTransactionsStream(
    ref,
    startDate: startDate,
    endDate: endDate,
    branchId: bid,
    forceRealData: forceRealData,
  ).map((all) {
    final income = all
        .where((tx) => !(tx.isExpense ?? false) && !(tx.isRefunded ?? false))
        .toList();

    final expenses = all.where((tx) => tx.isExpense == true);

    final totalIncome = income.fold<double>(
      0.0,
      (sum, tx) => sum + (tx.subTotal ?? 0.0),
    );

    final totalExpenses = expenses.fold<double>(
      0.0,
      (sum, tx) => sum + (tx.subTotal ?? 0.0),
    );

    final totalTax = income.fold<double>(
      0.0,
      (sum, tx) => sum + (tx.taxAmount ?? 0.0),
    );

    // Simplified COGS: 60 % of revenue — avoids item-by-item lookups.
    final totalCOGS = income.fold<double>(
      0.0,
      (sum, tx) => sum + ((tx.subTotal ?? 0.0) * 0.6),
    );

    final net = totalIncome - totalCOGS - totalExpenses - totalTax;

    talker.debug(
      'netProfit: income=$totalIncome cogs=$totalCOGS '
      'expenses=$totalExpenses tax=$totalTax → net=$net',
    );

    return net;
  });
}

// ---------------------------------------------------------------------------
// totalIncomeStream — plain sum of all non-expense transactions (used by some
// legacy callers; now just an alias over grossProfitStream logic).
// ---------------------------------------------------------------------------
@riverpod
Stream<double> totalIncomeStream(
  Ref ref, {
  required DateTime startDate,
  required DateTime endDate,
  String? branchId,
  bool forceRealData = true,
}) {
  final bid = branchId ?? ProxyService.box.getBranchId();
  if (bid == null) {
    talker.error('Branch ID is required for totalIncomeStream');
    throw StateError('Branch ID is required');
  }

  return coreTransactionsStream(
    ref,
    startDate: startDate,
    endDate: endDate,
    branchId: bid,
    forceRealData: forceRealData,
  ).map((all) {
    final income = all.where((tx) => !(tx.isExpense ?? false));
    return income.fold<double>(0.0, (sum, tx) => sum + (tx.subTotal ?? 0.0));
  });
}

// ---------------------------------------------------------------------------
// pendingTransactionStream — Capella/Ditto pending cart (single writer path).
// ---------------------------------------------------------------------------
@riverpod
Stream<ITransaction> pendingTransactionStream(
  Ref ref, {
  required bool isExpense,
  bool forceRealData = true,
}) async* {
  String? branchId = ProxyService.box.getBranchId();

  if (branchId == null) {
    await Future.delayed(const Duration(milliseconds: 100));
    branchId = ProxyService.box.getBranchId();
    if (branchId == null) {
      throw StateError(
        'No default branch selected. Please select a branch first.',
      );
    }
  }

  try {
    talker.info(
      'Starting pendingTransaction stream (Capella) for branch $branchId '
      '(isExpense: $isExpense)',
    );
    yield* ProxyService.getStrategy(Strategy.capella)
        .pendingTransaction(
          branchId: branchId,
          transactionType: isExpense
              ? TransactionType.purchase
              : TransactionType.sale,
          isExpense: isExpense,
        )
        .map((txn) {
          talker.info(
            'pendingTransactionStream emitted id=${txn.id} status=${txn.status}',
          );
          return txn;
        });
  } catch (e, stack) {
    talker.error('FATAL: pendingTransaction stream threw an error!', e, stack);
    rethrow;
  }
}

// ---------------------------------------------------------------------------
// transactionById — Ditto-backed: [Strategy.capella].transactionsStream with
// current [branchId] so the observer matches [transactionItemsStreamProvider].
// ---------------------------------------------------------------------------
@riverpod
Stream<ITransaction?> transactionById(Ref ref, String transactionId) {
  final branchId = ProxyService.box.getBranchId();
  return ProxyService.getStrategy(Strategy.capella)
      .transactionsStream(
        id: transactionId,
        branchId: branchId,
        includePending: true,
        includeParked: true,
        includeZeroSubTotal: true,
        skipOriginalTransactionCheck: true,
        removeAdjustmentTransactions: true,
      )
      .map((list) => list.firstOrNull);
}

// ---------------------------------------------------------------------------
// Dashboard gauge — PLU gross / deductions aligned with DataView summary cards
// (Capella line items + expenses; same formulas as Transaction Reports).
// ---------------------------------------------------------------------------

class DashboardGaugeSnapshot {
  const DashboardGaugeSnapshot({
    required this.grossProfit,
    required this.deductions,
    this.revenue = 0,
    this.transactionCount = 0,
  });

  /// Sum of line-level (price×qty − supply) for completed non-expense sales.
  final double grossProfit;

  /// Line VAT + expense transaction [subTotal]s in the period.
  final double deductions;

  /// Sum of completed sale [subTotal]s in the period (denominator for gauge fill).
  final double revenue;

  /// Completed non-expense sales in the period.
  final int transactionCount;

  double get netProfit => grossProfit - deductions;

  bool get isEmpty => transactionCount == 0;

  /// Profit margin fill for the semicircle gauge (0–1).
  double fillFraction(String profitType) {
    if (revenue <= 0) return 0;
    final value = profitType == 'Gross Profit' ? grossProfit : netProfit;
    return (value / revenue).clamp(0.0, 1.0);
  }

  double displayValue(String profitType) =>
      profitType == 'Gross Profit' ? grossProfit : netProfit;
}

/// Inclusive start of the dashboard filter window (matches [DashboardView] chips).
DateTime dashboardPeriodStart(String period) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  if (period == 'Today') return today;
  if (period == 'This Week') {
    return today.subtract(const Duration(days: 7));
  }
  if (period == 'This Month') {
    var y = now.year;
    var m = now.month - 1;
    if (m < 1) {
      y -= 1;
      m = 12;
    }
    final lastDay = DateTime(y, m + 1, 0).day;
    final d = now.day > lastDay ? lastDay : now.day;
    return DateTime(y, m, d);
  }
  final lastDayYear = DateTime(now.year - 1, now.month + 1, 0).day;
  final d = now.day > lastDayYear ? lastDayYear : now.day;
  return DateTime(now.year - 1, now.month, d);
}

final dashboardGaugeSnapshotProvider =
    StreamProvider.family<DashboardGaugeSnapshot, String>((ref, period) {
      final start = dashboardPeriodStart(period);
      final end = DateTime.now();
      final branchId = ProxyService.box.branchIdString();
      if (branchId == null) {
        return Stream.value(
          const DashboardGaugeSnapshot(grossProfit: 0, deductions: 0),
        );
      }

      final itemStream = ProxyService.getStrategy(Strategy.capella)
          .transactionItemsStreams(
            startDate: start,
            endDate: end,
            branchId: branchId,
            branchIdString: branchId,
            fetchRemote: true,
          )
          .startWith(const <TransactionItem>[]);

      final completedSalesStream =
          coreTransactionsStream(
                ref,
                startDate: start,
                endDate: end,
                branchId: branchId,
                forceRealData: true,
              )
              .map(
                (all) => all
                    .where(
                      (tx) => tx.isExpense != true && tx.status == COMPLETE,
                    )
                    .toList(),
              )
              .startWith(const <ITransaction>[]);

      final expenseTxStream = expensesStream(
        ref,
        startDate: start,
        endDate: end,
        branchId: branchId,
        forceRealData: true,
      ).startWith(const <ITransaction>[]);

      return Rx.combineLatest3<
        List<TransactionItem>,
        List<ITransaction>,
        List<ITransaction>,
        DashboardGaugeSnapshot
      >(itemStream, completedSalesStream, expenseTxStream, (items, txs, exps) {
        final allowed = txs.map((t) => t.id.toString()).toSet();
        final filtered = items.where((i) {
          final tid = i.transactionId?.toString();
          return tid != null && allowed.contains(tid);
        }).toList();
        final gross = filtered.fold<double>(
          0.0,
          (s, i) => s + TransactionItemPluMetrics.profitMade(i),
        );
        final tax = filtered.fold<double>(
          0.0,
          (s, i) => s + TransactionItemPluMetrics.taxPayable(i),
        );
        final expSum = exps.fold<double>(
          0.0,
          (s, e) => s + (e.subTotal ?? 0.0),
        );
        final revenue = txs.fold<double>(
          0.0,
          (s, t) => s + (t.subTotal ?? 0.0),
        );
        return DashboardGaugeSnapshot(
          grossProfit: gross,
          deductions: tax + expSum,
          revenue: revenue,
          transactionCount: txs.length,
        );
      });
    });

/// Label for period-over-period comparison copy on the dashboard gauge.
String dashboardComparisonPeriodLabel(String period) {
  switch (period) {
    case 'Today':
      return 'yesterday';
    case 'This Week':
      return 'last week';
    case 'This Month':
      return 'last month';
    case 'This Year':
      return 'last year';
    default:
      return 'previous period';
  }
}

/// Inclusive start of the window immediately before [period]'s current window.
DateTime dashboardPreviousPeriodStart(String period) {
  final current = dashboardPeriodStart(period);
  if (period == 'Today') {
    return current.subtract(const Duration(days: 1));
  }
  if (period == 'This Week') {
    return current.subtract(const Duration(days: 7));
  }
  if (period == 'This Month') {
    var y = current.year;
    var m = current.month - 1;
    if (m < 1) {
      y -= 1;
      m = 12;
    }
    final lastDay = DateTime(y, m + 1, 0).day;
    final d = current.day > lastDay ? lastDay : current.day;
    return DateTime(y, m, d);
  }
  final lastDayYear = DateTime(current.year - 1, current.month + 1, 0).day;
  final d = current.day > lastDayYear ? lastDayYear : current.day;
  return DateTime(current.year - 1, current.month, d);
}

/// Stream gauge snapshot for the period window before [period].
final dashboardPreviousGaugeSnapshotProvider =
    StreamProvider.family<DashboardGaugeSnapshot, String>((ref, period) {
      final prevStart = dashboardPreviousPeriodStart(period);
      final prevEnd = dashboardPeriodStart(period);
      final branchId = ProxyService.box.branchIdString();
      if (branchId == null) {
        return Stream.value(
          const DashboardGaugeSnapshot(grossProfit: 0, deductions: 0),
        );
      }

      final itemStream = ProxyService.getStrategy(Strategy.capella)
          .transactionItemsStreams(
            startDate: prevStart,
            endDate: prevEnd,
            branchId: branchId,
            branchIdString: branchId,
            fetchRemote: true,
          )
          .startWith(const <TransactionItem>[]);

      final completedSalesStream =
          coreTransactionsStream(
                ref,
                startDate: prevStart,
                endDate: prevEnd,
                branchId: branchId,
                forceRealData: true,
              )
              .map(
                (all) => all
                    .where(
                      (tx) => tx.isExpense != true && tx.status == COMPLETE,
                    )
                    .toList(),
              )
              .startWith(const <ITransaction>[]);

      final expenseTxStream = expensesStream(
        ref,
        startDate: prevStart,
        endDate: prevEnd,
        branchId: branchId,
        forceRealData: true,
      ).startWith(const <ITransaction>[]);

      return Rx.combineLatest3<
        List<TransactionItem>,
        List<ITransaction>,
        List<ITransaction>,
        DashboardGaugeSnapshot
      >(itemStream, completedSalesStream, expenseTxStream, (items, txs, exps) {
        final allowed = txs.map((t) => t.id.toString()).toSet();
        final filtered = items.where((i) {
          final tid = i.transactionId?.toString();
          return tid != null && allowed.contains(tid);
        }).toList();
        final gross = filtered.fold<double>(
          0.0,
          (s, i) => s + TransactionItemPluMetrics.profitMade(i),
        );
        final tax = filtered.fold<double>(
          0.0,
          (s, i) => s + TransactionItemPluMetrics.taxPayable(i),
        );
        final expSum = exps.fold<double>(
          0.0,
          (s, e) => s + (e.subTotal ?? 0.0),
        );
        final revenue = txs.fold<double>(
          0.0,
          (s, t) => s + (t.subTotal ?? 0.0),
        );
        return DashboardGaugeSnapshot(
          grossProfit: gross,
          deductions: tax + expSum,
          revenue: revenue,
          transactionCount: txs.length,
        );
      });
    });
