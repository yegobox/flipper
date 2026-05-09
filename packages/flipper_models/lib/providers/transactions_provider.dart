import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_models/helperModels/transaction_payment_sums.dart';
import 'package:flipper_models/helperModels/transaction_report_snapshot.dart';
import 'package:flipper_models/providers/date_range_provider.dart';
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
// transactionReportSnapshot — Transaction Reports grid + payment breakdown.
// Parked + completed (sales and expenses); by-hand vs CREDIT from payment records.
// ---------------------------------------------------------------------------
@riverpod
Stream<TransactionReportSnapshot> transactionReportSnapshot(
  Ref ref, {
  required bool forceRealData,
}) {
  final dateRange = ref.watch(dateRangeProvider);
  final startDate = dateRange.startDate;
  final endDate = dateRange.endDate;

  if (startDate == null || endDate == null) {
    return Stream.value(
      const TransactionReportSnapshot(
        transactions: [],
        paymentSumsByTransactionId: {},
      ),
    );
  }

  final branchId = ProxyService.box.getBranchId();
  if (branchId == null) throw StateError('Branch ID is required');

  return coreTransactionsStream(
    ref,
    startDate: startDate,
    endDate: endDate,
    branchId: branchId,
    forceRealData: forceRealData,
    includeParked: true,
  ).asyncMap((all) async {
    final filtered = transactionReportScopeFilter(all);
    if (filtered.isEmpty) {
      return const TransactionReportSnapshot(
        transactions: [],
        paymentSumsByTransactionId: {},
      );
    }

    final ids = filtered.map((t) => t.id.toString()).toList();
    try {
      final sums = await ProxyService.getStrategy(
        Strategy.capella,
      ).getPaymentSumsByTransactionIds(ids, branchId: branchId);
      return TransactionReportSnapshot(
        transactions: filtered,
        paymentSumsByTransactionId: sums,
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
      );
    }
  });
}

// ---------------------------------------------------------------------------
// transactionList — backward-compatible list-only view of the report snapshot.
// ---------------------------------------------------------------------------
@riverpod
Stream<List<ITransaction>> transactionList(
  Ref ref, {
  required bool forceRealData,
}) {
  return transactionReportSnapshot(
    ref,
    forceRealData: forceRealData,
  ).map((snap) => snap.transactions);
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
// transactionItemList — line-items for completed + parked transactions in report scope.
// Joins items with the same scope as [transactionReportSnapshot] / summary grid.
// ---------------------------------------------------------------------------
@riverpod
Stream<List<TransactionItem>> transactionItemList(Ref ref) {
  final dateRange = ref.watch(dateRangeProvider);
  final startDate = dateRange.startDate;
  final endDate = dateRange.endDate;
  final branchId = ProxyService.box.branchIdString();
  final forceRealData = !(ProxyService.box.enableDebug() ?? false);

  talker.debug('transactionItemList called');

  if (branchId == null) {
    talker.error('Branch ID is required');
    throw StateError('Branch ID is required');
  }
  if (startDate == null || endDate == null) {
    talker.warning('startDate or endDate is null, returning empty stream');
    return Stream.value([]);
  }

  final itemStream = ProxyService.getStrategy(Strategy.capella)
      .transactionItemsStreams(
        startDate: startDate,
        endDate: endDate,
        branchId: branchId,
        branchIdString: branchId,
        // Local-first: summary mode no longer subscribes here, but detailed PLU
        // view should paint from local replica immediately without alwaysHydrate.
        fetchRemote: false,
      )
      .startWith(const <TransactionItem>[]);

  final completedSalesStream = coreTransactionsStream(
    ref,
    startDate: startDate,
    endDate: endDate,
    branchId: branchId,
    forceRealData: forceRealData,
    includeParked: true,
  ).map(transactionReportScopeFilter).startWith(const <ITransaction>[]);

  return Rx.combineLatest2<
        List<TransactionItem>,
        List<ITransaction>,
        List<TransactionItem>
      >(itemStream, completedSalesStream, (items, txs) {
        final allowed = txs.map((t) => t.id.toString()).toSet();
        final filtered = items.where((i) {
          final tid = i.transactionId?.toString();
          return tid != null && allowed.contains(tid);
        }).toList();
        talker.debug(
          'transactionItemList: ${items.length} raw → ${filtered.length} report-scoped lines',
        );
        return filtered;
      })
      .handleError((error, stackTrace) {
        talker.error('Error loading transaction items: $error');
        throw error;
      });
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
      'Starting manageTransactionStream (Capella) for branch $branchId '
      '(isExpense: $isExpense)',
    );
    yield* ProxyService.getStrategy(Strategy.capella).manageTransactionStream(
      transactionType: isExpense
          ? TransactionType.purchase
          : TransactionType.sale,
      isExpense: isExpense,
      branchId: branchId,
    );
  } catch (e, stack) {
    talker.error('FATAL: manageTransactionStream threw an error!', e, stack);
    rethrow;
  }
}

// ---------------------------------------------------------------------------
// transactionById — single-transaction lookup; kept on default strategy.
// ---------------------------------------------------------------------------
@riverpod
Stream<ITransaction?> transactionById(Ref ref, String transactionId) {
  return ProxyService.strategy
      .transactionsStream(
        id: transactionId,
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
  });

  /// Sum of line-level (price×qty − supply) for completed non-expense sales.
  final double grossProfit;

  /// Line VAT + expense transaction [subTotal]s in the period.
  final double deductions;

  double get netProfit => grossProfit - deductions;
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
        return DashboardGaugeSnapshot(
          grossProfit: gross,
          deductions: tax + expSum,
        );
      });
    });
