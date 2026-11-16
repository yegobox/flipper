import 'dart:math' show min;

import 'package:flipper_models/helpers/cash_movement_rules.dart';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_models/helperModels/transaction_payment_sums.dart';
import 'package:flipper_models/helperModels/transaction_report_snapshot.dart';
import 'package:flipper_models/helperModels/transaction_report_kpi_totals.dart';
import 'package:flipper_models/helpers/transaction_report_payment_totals.dart';
import 'package:flipper_models/helpers/transaction_report_plu_filters.dart';
import 'package:flipper_models/helpers/sale_exchange.dart';
import 'package:flipper_models/providers/active_branch_provider.dart';
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
import 'package:flipper_web/services/ditto_service.dart';
import 'package:supabase_models/sync/shared_sync_subscriptions.dart';

// [transactionReportLineMatchesSale] now lives with the other report PLU
// scoping helpers; re-exported here for the existing importers.
export 'package:flipper_models/helpers/transaction_report_plu_filters.dart'
    show transactionReportLineMatchesSale;

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
@Riverpod(keepAlive: true)
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

  // Scope PLU lines to the current SQL page (not the full date-range sale set).
  ref.watch(transactionReportSnapshotProvider(forceRealData: forceRealData));

  return itemStream
      .map((items) {
        final snap = ref
            .read(
              transactionReportSnapshotProvider(forceRealData: forceRealData),
            )
            .asData
            ?.value;
        if (snap == null || snap.transactions.isEmpty) {
          return const <TransactionItem>[];
        }
        final allowed = snap.transactions.map((t) => t.id.toString()).toSet();
        final filtered = items
            .where((i) => transactionReportLineMatchesSale(i, allowed))
            .toList();
        talker.debug(
          'transactionItemList: ${items.length} raw → ${filtered.length} '
          'page-scoped lines (${allowed.length} sale ids)',
        );
        return filtered;
      })
      .handleError((Object error, StackTrace stackTrace) {
        talker.error('Error loading transaction items: $error');
        throw error;
      });
}

// ---------------------------------------------------------------------------
// transactionReportKpiTotals — full-period rollups for the KPI strip.
//
// Every figure here derives from ONE row set: the report's own paging window
// (the same WHERE [transactionReportSnapshot] pages for the grid). PLU lines
// are joined to those sales and expenses are read off the same rows, so an
// empty grid necessarily yields zeros across all four cards. Reading profit
// from an unjoined `transaction_items` sweep — which also carries pending
// carts and purchase lines whose supply cost makes profit negative — is what
// let Net Profit go negative over a period with no reported transactions.
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

  // --- Pass 1: the report-scope transactions, paged like the grid. ---
  final saleIds = <String>{};
  // Item-exchange returns: money and units that went back (see
  // `isExchangeReturn`). Plain refunds are read as they always were.
  final exchangeReturnIds = <String>{};
  var periodByHand = 0.0;
  var periodCredit = 0.0;
  var periodOwed = 0.0;
  var periodSubtotal = 0.0;
  var periodExpense = 0.0;
  var periodCashIn = 0.0;

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
      // Hotel booking advances move money owed to a guest: not a sale, an
      // expense or Cash In profit. The stay is counted once, at checkout.
      if (isBookingAdvanceTransaction(tx)) continue;
      if (tx.isExpense == true) {
        periodExpense += tx.subTotal ?? 0.0;
        continue;
      }
      if (isExchangeReturn(tx)) {
        final back = tx.subTotal ?? 0.0;
        periodSubtotal -= back;
        periodByHand -= back;
        saleIds.add(tx.id.toString());
        exchangeReturnIds.add(tx.id.toString());
        continue;
      }
      if (tx.receiptType == TransactionType.cashIn) {
        periodCashIn += tx.subTotal ?? 0.0;
      }
      // PLU lines roll up against sales only; expense rows are deducted whole
      // via [periodExpense], so their lines must not also count as profit.
      saleIds.add(tx.id.toString());
      final s = sums[tx.id.toString()];
      periodByHand += transactionReportByHandForTotals(tx, s);
      periodCredit += transactionReportCreditForTotals(tx, s);
      // Clean partition: Total Sales (subTotal) = Collected + Owed, where
      // Owed is the unpaid balance clamped to the sale amount.
      final sub = tx.subTotal ?? 0.0;
      periodSubtotal += sub;
      final rb = (tx.remainingBalance ?? 0).toDouble();
      periodOwed += rb <= 0.01 ? 0.0 : (rb > sub ? sub : rb);
    }

    offset += batch.length;
  }

  // --- Pass 2: PLU lines, scoped to those sales. ---
  // No sales in range means no lines to weigh: skip the fetch entirely rather
  // than block on a stream that will never emit for this window.
  var plu = const TransactionReportPluTotals();
  if (saleIds.isNotEmpty) {
    final branchIdForPlu = ProxyService.box.branchIdString() ?? branchId;
    final periodLines = await waitReportPluLinesFromStream(
      capella: capella,
      startDate: startDate,
      endDate: endDate,
      branchId: branchIdForPlu,
    );
    plu = sumReportScopedPluLines(
      lines: periodLines,
      saleIds: saleIds,
      negativeSaleIds: exchangeReturnIds,
    );
    talker.debug(
      'transactionReportKpiTotals: ${periodLines.length} raw lines → '
      '${saleIds.length} in-scope sales, gross=${plu.grossProfit}',
    );
  }

  return TransactionReportKpiTotals(
    pluLineSales: plu.lineSales,
    pluGrossProfit: plu.grossProfit,
    pluLineTax: plu.lineTax,
    periodByHand: periodByHand,
    periodCredit: periodCredit,
    periodOwed: periodOwed,
    periodSubtotal: periodSubtotal,
    periodExpense: periodExpense,
    periodCashIn: periodCashIn,
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
    // Exchange returns count negative; every other row is its subTotal.
    return income.fold<double>(0.0, (sum, tx) => sum + signedSubTotal(tx));
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
      (sum, tx) => sum + signedSubTotal(tx),
    );

    final totalExpenses = expenses.fold<double>(
      0.0,
      (sum, tx) => sum + (tx.subTotal ?? 0.0),
    );

    final totalTax = income.fold<double>(
      0.0,
      (sum, tx) => sum + exchangeSign(tx) * (tx.taxAmount ?? 0.0),
    );

    // Simplified COGS: 60 % of revenue — avoids item-by-item lookups.
    final totalCOGS = income.fold<double>(
      0.0,
      (sum, tx) => sum + signedSubTotal(tx) * 0.6,
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
    // Exchange returns count negative; every other row is its subTotal.
    return income.fold<double>(0.0, (sum, tx) => sum + signedSubTotal(tx));
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
  // Re-subscribe when the active branch changes (startup / branch switch).
  ref.watch(activeBranchProvider);

  String? branchId = ProxyService.box.getBranchId();
  const maxAttempts = 50;
  var attempt = 0;
  while (branchId == null && attempt < maxAttempts) {
    await Future.delayed(const Duration(milliseconds: 100));
    branchId = ProxyService.box.getBranchId();
    attempt++;
  }

  if (branchId == null) {
    throw StateError(
      'No default branch selected. Please select a branch first.',
    );
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

  /// Revenue / Expenses cards key off their own totals: [isEmpty] counts
  /// sales only, so a day with only cash-outs used to show Expenses as 0.
  bool get hasRevenue => revenue != 0;
  bool get hasDeductions => deductions != 0;

  /// Anything to plot on the profit gauge (a cash-out alone moves net profit).
  bool get hasActivity => transactionCount > 0 || hasDeductions;

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

/// Completed, non-expense sales in a gauge window. A hotel booking advance
/// (received, applied or refunded) is money owed to a guest, not revenue.
List<ITransaction> dashboardGaugeSales(List<ITransaction> all) => all
    .where(
      (tx) =>
          tx.isExpense != true &&
          tx.status == COMPLETE &&
          !isBookingAdvanceTransaction(tx),
    )
    .toList();

/// Expenses in a gauge window, booking advances excluded as for sales.
List<ITransaction> dashboardGaugeExpenses(List<ITransaction> all) => all
    .where((tx) => tx.isExpense == true && !isBookingAdvanceTransaction(tx))
    .toList();

/// The gauge numbers for one window. Line [items] count only when they
/// belong to one of [sales].
DashboardGaugeSnapshot dashboardGaugeSnapshotFrom({
  required List<TransactionItem> items,
  required List<ITransaction> sales,
  required List<ITransaction> expenses,
}) {
  final allowed = sales.map((t) => t.id.toString()).toSet();
  var gross = 0.0;
  var tax = 0.0;
  for (final i in items) {
    final tid = i.transactionId?.toString();
    if (tid == null || !allowed.contains(tid)) continue;
    gross += TransactionItemPluMetrics.profitMade(i);
    tax += TransactionItemPluMetrics.taxPayable(i);
  }
  final expSum = expenses.fold<double>(0.0, (s, e) => s + (e.subTotal ?? 0.0));
  final revenue = sales.fold<double>(0.0, (s, t) => s + (t.subTotal ?? 0.0));
  return DashboardGaugeSnapshot(
    grossProfit: gross,
    deductions: tax + expSum,
    revenue: revenue,
    transactionCount: sales.length,
  );
}

/// Line items for the gauge: a one-shot `execute` read (the Transaction
/// Reports scope), never a store observer. Null when the read failed, so the
/// gauge keeps its last good lines instead of showing zero profit and tax.
Future<List<TransactionItem>?> _gaugeLineItems({
  required DateTime start,
  required DateTime end,
  required String branchId,
}) async {
  try {
    final capella = ProxyService.getStrategy(Strategy.capella) as CapellaSync;
    return await capella.fetchTransactionItemsReportScope(
      startDate: start,
      endDate: end,
      branchId: branchId,
      rethrowErrors: true,
    );
  } catch (e) {
    talker.warning('dashboard gauge line items: $e');
    return null;
  }
}

/// Reads the gauge's line items for [saleIds], retrying when the read fails
/// or when a completed sale has no lines yet (they can sync in after the
/// sale's transaction). A failed read emits nothing, so the gauge keeps its
/// last good lines; a partial read is shown and then retried. With no
/// [maxAttempts] it keeps retrying, backing off to once a minute, for as long
/// as it is listened to, so a store that recovers later is picked up without
/// a new sale. Cancelled (by `switchMap`) when the sales change again.
Stream<List<TransactionItem>> dashboardGaugeLinesWithRetry({
  required Future<List<TransactionItem>?> Function() fetch,
  required Set<String> saleIds,
  int? maxAttempts,
  Duration Function(int attempt) backoff = _gaugeRetryBackoff,
}) async* {
  for (
    var attempt = 1;
    maxAttempts == null || attempt <= maxAttempts;
    attempt++
  ) {
    final lines = await fetch();
    if (lines != null) {
      yield lines;
      final covered = {
        for (final line in lines) line.transactionId?.toString(),
      };
      if (saleIds.every(covered.contains)) return;
    }
    if (maxAttempts == null || attempt < maxAttempts) {
      await Future<void>.delayed(backoff(attempt));
    }
  }
}

/// 2, 4, 8, 16, 32 s, then once a minute.
Duration _gaugeRetryBackoff(int attempt) =>
    Duration(seconds: attempt >= 6 ? 60 : 2 << (attempt - 1));

/// Keeps other tills' line items syncing into this device while the
/// dashboard gauge reads them with one-shot queries.
///
/// The live line-item observer this replaced also registered a sync
/// subscription; without one, lines from other devices never reach the store
/// and profit and tax read low. One shared subscription per branch, from the
/// previous period's start so both gauges are covered, with no end bound so
/// new lines keep arriving. `historyWindowStart` is a moving argument, so a
/// newer start replaces the older subscription instead of adding one.
void registerDashboardGaugeLineSync({
  required String branchId,
  required DateTime since,
}) {
  final ditto = DittoService.instance.dittoInstance;
  if (ditto == null) return;
  final day = DateTime(since.year, since.month, since.day);
  try {
    SharedSyncSubscriptions.register(
      ditto,
      dashboardGaugeLineSyncDql,
      arguments: {
        'branchId': branchId,
        'historyWindowStart': day.toIso8601String(),
      },
    );
  } catch (e) {
    talker.warning('dashboard gauge line sync: $e');
  }
}

/// The gauge's line-item sync subscription (see [registerDashboardGaugeLineSync]).
const String dashboardGaugeLineSyncDql =
    'SELECT * FROM transaction_items '
    'WHERE (branchId = :branchId OR branch_id = :branchId) '
    'AND createdAt >= :historyWindowStart';

/// The ids of the completed sales, to tell a new sale from a cart edit.
Set<String> _saleIds(List<ITransaction> sales) =>
    sales.map((t) => t.id.toString()).toSet();

bool _sameIds(Set<String> a, Set<String> b) =>
    a.length == b.length && a.containsAll(b);

/// When the gauge re-reads line items: once at start, then only when the set
/// of completed sales changes (a cart edit changes no sale id), at most once
/// per [window].
///
/// Emits the completed sale ids, so the read can tell which sales still lack
/// their lines.
Stream<Set<String>> dashboardGaugeLineRefreshes(
  Stream<List<ITransaction>> sales, {
  Duration window = const Duration(seconds: 2),
}) => sales
    .map(_saleIds)
    .distinct(_sameIds)
    .throttleTime(window, leading: true, trailing: true)
    // The trailing edge repeats the leading value after a lone change.
    .distinct(_sameIds);

// Live gauge for the current period. One transaction observer feeds both
// sales and expenses (expensesStream is the same query filtered, so the gauge
// used to open it twice).
//
// Line items are NOT observed. A branch-wide transaction_items observer fired
// on every cart tap on any till (pending lines fall inside the period) and
// re-decoded every line of the period on the UI isolate: a year of rows per
// tap on "This Year". Lines are now read once, again only when the set of
// completed sales changes, at most every 2 s.
//
// autoDispose: nothing here should outlive the dashboard.
final dashboardGaugeSnapshotProvider = StreamProvider.autoDispose
    .family<DashboardGaugeSnapshot, String>((ref, period) {
      final start = dashboardPeriodStart(period);
      final end = DateTime.now();
      final branchId = ProxyService.box.branchIdString();
      if (branchId == null) {
        return Stream.value(
          const DashboardGaugeSnapshot(grossProfit: 0, deductions: 0),
        );
      }

      final all = coreTransactionsStream(
        ref,
        startDate: start,
        endDate: end,
        branchId: branchId,
        forceRealData: true,
      ).shareReplay(maxSize: 1);
      final sales = all.map(dashboardGaugeSales).shareReplay(maxSize: 1);
      final expenses = all.map(dashboardGaugeExpenses);

      registerDashboardGaugeLineSync(
        branchId: branchId,
        since: dashboardPreviousPeriodStart(period),
      );
      final items = dashboardGaugeLineRefreshes(sales).switchMap(
        (saleIds) => dashboardGaugeLinesWithRetry(
          fetch: () =>
              _gaugeLineItems(start: start, end: end, branchId: branchId),
          saleIds: saleIds,
        ),
      );

      return Rx.combineLatest3<
        List<TransactionItem>,
        List<ITransaction>,
        List<ITransaction>,
        DashboardGaugeSnapshot
      >(
        items.startWith(const <TransactionItem>[]),
        sales.startWith(const <ITransaction>[]),
        expenses.startWith(const <ITransaction>[]),
        (i, s, e) =>
            dashboardGaugeSnapshotFrom(items: i, sales: s, expenses: e),
      );
    });

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

/// Gauge snapshot for the window before [period], read once.
///
/// That window has already closed, so it is computed once instead of keeping
/// three live observers (two transaction, one branch-wide line item) that
/// re-decoded it on every write. Pull-to-refresh invalidates it.
final dashboardPreviousGaugeSnapshotProvider = StreamProvider.autoDispose
    .family<DashboardGaugeSnapshot, String>((ref, period) {
      final prevStart = dashboardPreviousPeriodStart(period);
      final prevEnd = dashboardPeriodStart(period);
      final branchId = ProxyService.box.branchIdString();
      if (branchId == null) {
        return Stream.value(
          const DashboardGaugeSnapshot(grossProfit: 0, deductions: 0),
        );
      }

      Future<DashboardGaugeSnapshot> load() async {
        // The timeout sits on the stream, so when it fires the stream closes
        // and `.first` cancels the observer instead of leaving it subscribed.
        List<ITransaction> all;
        try {
          all =
              await coreTransactionsStream(
                    ref,
                    startDate: prevStart,
                    endDate: prevEnd,
                    branchId: branchId,
                    forceRealData: true,
                  )
                  .timeout(
                    const Duration(seconds: 10),
                    onTimeout: (sink) => sink.close(),
                  )
                  .first;
        } on StateError {
          all = const <ITransaction>[]; // timed out before the first result
        }
        final sales = dashboardGaugeSales(all);
        var items = const <TransactionItem>[];
        if (sales.isNotEmpty) {
          await for (final lines in dashboardGaugeLinesWithRetry(
            fetch: () => _gaugeLineItems(
              start: prevStart,
              end: prevEnd,
              branchId: branchId,
            ),
            saleIds: _saleIds(sales),
            // Read once: this awaits the stream to its end.
            maxAttempts: 5,
          )) {
            items = lines;
          }
        }
        return dashboardGaugeSnapshotFrom(
          items: items,
          sales: sales,
          expenses: dashboardGaugeExpenses(all),
        );
      }

      return Stream.fromFuture(load());
    });

/// A hotel booking-advance movement (received, applied or refunded): money
/// owed to a guest, kept out of revenue, expenses and profit.
bool isBookingAdvanceTransaction(ITransaction tx) => isBookingAdvanceMovement(
  transactionType: tx.transactionType,
  receiptType: tx.receiptType,
  categoryId: tx.categoryId,
);
