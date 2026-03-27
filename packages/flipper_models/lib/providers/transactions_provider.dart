import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_models/providers/date_range_provider.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/SyncStrategy.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'transactions_provider.g.dart';

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
    includeParked: true,
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
}) {
  talker.debug(
    'coreTransactionsStream: $startDate → $endDate  branch=$branchId',
  );
  return ProxyService.getStrategy(Strategy.capella).transactionsStream(
    startDate: startDate,
    endDate: endDate,
    branchId: branchId,
    // Fetch everything (income + expenses) so derived providers can split freely.
    skipOriginalTransactionCheck: true,
    removeAdjustmentTransactions: true,
    includeParked: true,
    // isCashOut intentionally omitted → returns both income and expense.
    forceRealData: forceRealData,
  );
}

// ---------------------------------------------------------------------------
// transactionList — visible rows in the Transaction Reports grid.
// Filters the core stream to only confirmed sales.
// ---------------------------------------------------------------------------
@riverpod
Stream<List<ITransaction>> transactionList(
  Ref ref, {
  required bool forceRealData,
}) {
  final dateRange = ref.watch(dateRangeProvider);
  final startDate = dateRange.startDate;
  final endDate = dateRange.endDate;

  if (startDate == null || endDate == null) {
    return Stream.value([]);
  }

  final branchId = ProxyService.box.getBranchId();
  if (branchId == null) throw StateError('Branch ID is required');

  return coreTransactionsStream(
    ref,
    startDate: startDate,
    endDate: endDate,
    branchId: branchId,
    forceRealData: forceRealData,
  ).map(
    (all) => all.where((tx) {
      if (tx.isExpense == true) return false; // exclude cash-outs
      if (tx.status == COMPLETE) return true;
      if (tx.status == PARKED && (tx.cashReceived ?? 0) > 0) return true;
      if (tx.status == WAITING_MOMO_COMPLETE) return true;
      return false;
    }).toList(),
  );
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
// transactionItemList — line-items for the selected date range.
// Kept separate because it queries a different collection (TransactionItem).
// ---------------------------------------------------------------------------

/// Attaches live [Stock] from each line's variant so "Current stock" / export match inventory.
Future<List<TransactionItem>> _enrichTransactionItemsWithVariantStock(
  List<TransactionItem> items,
) async {
  if (items.isEmpty) return items;
  final strategy = ProxyService.getStrategy(Strategy.capella);
  final variantIds = items.map((e) => e.variantId).whereType<String>().toSet();
  if (variantIds.isEmpty) return items;

  final stockByVariantId = <String, Stock>{};
  await Future.wait(
    variantIds.map((vid) async {
      try {
        final v = await strategy.getVariant(id: vid);
        if (v == null) return;
        Stock? stock = v.stock;
        final stockId = v.stockId;
        if (stock == null &&
            stockId != null &&
            stockId.toString().isNotEmpty) {
          stock = await strategy.getStockById(id: stockId.toString());
        }
        if (stock != null) stockByVariantId[vid] = stock;
      } catch (_) {}
    }),
  );
  if (stockByVariantId.isEmpty) return items;

  return items
      .map((item) {
        final vid = item.variantId;
        if (vid == null) return item;
        final stock = stockByVariantId[vid];
        if (stock == null) return item;
        return item.copyWith(stock: stock);
      })
      .toList();
}

@riverpod
Stream<List<TransactionItem>> transactionItemList(Ref ref) {
  final dateRange = ref.watch(dateRangeProvider);
  final startDate = dateRange.startDate;
  final endDate = dateRange.endDate;
  final branchId = ProxyService.box.branchIdString();

  talker.debug('transactionItemList called');

  if (branchId == null) {
    talker.error('Branch ID is required');
    throw StateError('Branch ID is required');
  }
  if (startDate == null || endDate == null) {
    talker.warning('startDate or endDate is null, returning empty stream');
    return Stream.value([]);
  }

  // Removed ref.keepAlive() to allow proper disposal and prevent duplicate queries

  return ProxyService.getStrategy(Strategy.capella)
      .transactionItemsStreams(
        startDate: startDate,
        endDate: endDate,
        branchId: branchId,
        branchIdString: branchId,
        fetchRemote: true,
      )
      .asyncMap((items) async {
        talker.debug('Received ${items.length} transaction items');
        return _enrichTransactionItemsWithVariantStock(items);
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
    return income.fold<double>(
      0.0,
      (sum, tx) =>
          sum +
          (tx.status == COMPLETE
              ? (tx.subTotal ?? 0.0)
              : (tx.cashReceived ?? 0.0)),
    );
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
      (sum, tx) =>
          sum +
          (tx.status == COMPLETE
              ? (tx.subTotal ?? 0.0)
              : (tx.cashReceived ?? 0.0)),
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
    return income.fold<double>(
      0.0,
      (sum, tx) =>
          sum +
          (tx.status == COMPLETE
              ? (tx.subTotal ?? 0.0)
              : (tx.cashReceived ?? 0.0)),
    );
  });
}

// ---------------------------------------------------------------------------
// pendingTransactionStream — unchanged; uses the default strategy because
// pending/managing transactions must remain on SQLite.
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
      'Starting manageTransactionStream for branch $branchId '
      '(isExpense: $isExpense)',
    );
    yield* ProxyService.strategy.manageTransactionStream(
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
