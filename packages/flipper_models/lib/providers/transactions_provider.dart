import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_models/providers/date_range_provider.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:rxdart/rxdart.dart';

part 'transactions_provider.g.dart';

// Create a standard provider for dashboard transactions with fixed date range
final dashboardTransactionsProvider = StreamProvider<List<ITransaction>>((ref) {
  final endDate = DateTime.now();
  final startDate = endDate.subtract(const Duration(days: 30));
  final branchId = ProxyService.box.getBranchId();

  if (branchId == null) {
    throw StateError('Branch ID is required');
  }

  // Only log once when this provider is created
  talker.debug('Dashboard transactions provider initialized with 30-day range');

  return ProxyService.strategy.transactionsStream(
    status: COMPLETE,
    branchId: branchId,
    startDate: startDate,
    endDate: endDate,
    removeAdjustmentTransactions: true,
    forceRealData: true,
  );
});
@riverpod
Stream<List<ITransaction>> transactionList(
  Ref ref, {
  required bool forceRealData,
}) async* {
  final dateRange = ref.watch(dateRangeProvider);
  final startDate = dateRange.startDate;
  final endDate = dateRange.endDate;

  // Check if startDate or endDate is null, and return an empty list stream if either is null
  if (startDate == null || endDate == null) {
    yield [];
    return;
  }

  try {
    final stream = ProxyService.strategy.transactionsStream(
      startDate: startDate,
      endDate: endDate,
      removeAdjustmentTransactions: true,
      branchId: ProxyService.box.getBranchId(),
      isCashOut: false,
      status: COMPLETE,
      forceRealData: forceRealData,
    );

    // Use `switchMap` to handle potential changes in dateRangeProvider
    await for (final transactions in stream.switchMap((transactions) {
      // Log the received data to the console
      // talker.info("Transaction Data: $transactions");

      // Handle null or empty transactions if needed
      return Stream.value(transactions);
    })) {
      yield transactions;
    }
  } catch (e) {
    // Log error and rethrow to let Riverpod handle it
    talker.info("Error loading transactions: $e");
    throw e;
  }
}

// Transactions provider with optional date parameters
@riverpod
Stream<List<ITransaction>> transactions(Ref ref, {bool forceRealData = true}) {
  final dateRange = ref.watch(dateRangeProvider);
  DateTime startDate = dateRange.startDate ?? DateTime.now();
  DateTime endDate = dateRange.endDate ?? DateTime.now();
  final branchId = ProxyService.box.getBranchId();

  // Create a cache key based on the parameters
  final cacheKey =
      '${startDate.toIso8601String()}_${endDate.toIso8601String()}_$branchId';

  // Only log once per unique request
  talker.debug('Transactions provider called with key: $cacheKey');

  if (branchId == null) {
    throw StateError('Branch ID is required');
  }

  // Keep provider alive
  ref.keepAlive();

  return ProxyService.strategy.transactionsStream(
    status: COMPLETE,
    branchId: branchId,
    startDate: startDate,
    endDate: endDate,
    removeAdjustmentTransactions: true,
    forceRealData: forceRealData,
  );
}

// Transaction items provider
@riverpod
Stream<List<TransactionItem>> transactionItemList(Ref ref) {
  final dateRange = ref.watch(dateRangeProvider);
  final startDate = dateRange.startDate;
  final endDate = dateRange.endDate;
  final branchId = ProxyService.box.branchIdString();
  final branchIdString = ProxyService.box.branchIdString()!;

  talker.debug('transactionItemList called');

  // Input validation
  if (branchId == null) {
    talker.error('Branch ID is required');
    throw StateError('Branch ID is required');
  }

  if (startDate == null || endDate == null) {
    talker.warning('startDate or endDate is null, returning empty stream');
    return Stream.value([]);
  }

  // Keep provider alive
  ref.keepAlive();

  talker.debug(
      'Fetching transactions from $startDate to $endDate for branch $branchId');

  return ProxyService.strategy
      .transactionItemsStreams(
          startDate: startDate,
          endDate: endDate,
          branchId: branchId,
          branchIdString: branchIdString,
          fetchRemote: true)
      .map((transactions) {
    talker.debug('Received ${transactions.length} transactions items');
    return transactions;
  }).handleError((error, stackTrace) {
    talker.error('Error loading transaction items: $error');
    talker.error(stackTrace);
    throw error;
  });
}

@riverpod
Stream<ITransaction> pendingTransactionStream(Ref ref,
    {required bool isExpense, bool forceRealData = true}) {
  int? branchId = ProxyService.box.getBranchId();
  return ProxyService.strategy.manageTransactionStream(
    transactionType:
        isExpense ? TransactionType.purchase : TransactionType.sale,
    isExpense: isExpense,
    branchId: branchId!,
  );
}

@riverpod
Stream<List<ITransaction>> expensesStream(
  Ref ref, {
  required DateTime startDate,
  required DateTime endDate,
  int? branchId,
  bool forceRealData = true,
}) {
  branchId ??= ProxyService.box.getBranchId();
  if (branchId == null) {
    talker.error('Branch ID is required for expensesStream');
    throw StateError('Branch ID is required');
  }

  ref.keepAlive();
  talker.debug(
      'Fetching expenses from $startDate to $endDate for branch $branchId');
  return ProxyService.strategy
      .transactionsStream(
        startDate: startDate,
        endDate: endDate,
        branchId: branchId,
        isCashOut: true, // <-- This filters for expenses
        removeAdjustmentTransactions: true,
        forceRealData: true,
      )
      .map((transactions) => transactions.cast<ITransaction>())
      .handleError((error, stackTrace) {
    talker.error('Error loading expense items: $error');
    talker.error(stackTrace);
    throw error;
  });
}

@riverpod
Stream<double> netProfitStream(
  Ref ref, {
  required DateTime startDate,
  required DateTime endDate,
  int? branchId,
  bool forceRealData = true,
}) async* {
  branchId ??= ProxyService.box.getBranchId();
  if (branchId == null) {
    talker.error('Branch ID is required for netProfitStream');
    throw StateError('Branch ID is required');
  }

  // Convert streams to broadcast streams to allow multiple listeners
  final incomeStream = ProxyService.strategy
      .transactionsStream(
        startDate: startDate,
        endDate: endDate,
        branchId: branchId,
        forceRealData: forceRealData,
        isCashOut: false, // Only get income transactions
        removeAdjustmentTransactions: true,
      )
      .asBroadcastStream();

  final expensesStream = ProxyService.strategy
      .transactionsStream(
        startDate: startDate,
        endDate: endDate,
        branchId: branchId,
        isCashOut: true, // Only get expense transactions
        removeAdjustmentTransactions: true,
        forceRealData: true,
      )
      .asBroadcastStream();

  await for (final incomeTransactions in incomeStream) {
    // Log the number of income transactions for debugging
    talker.debug(
        'Net Profit: Found ${incomeTransactions.length} income transactions');

    final expenseTransactions = await expensesStream.first;
    talker.debug(
        'Net Profit: Found ${expenseTransactions.length} expense transactions');

    // Filter out any transactions that are marked as expenses or refunded in the income stream
    final filteredIncome = incomeTransactions
        .where((tx) => !(tx.isExpense ?? false) && !(tx.isRefunded ?? false))
        .toList();

    // Calculate total from filtered income transactions (revenue)
    final totalIncome = filteredIncome.fold<double>(
      0.0,
      (sum, transaction) => sum + (transaction.subTotal ?? 0.0),
    );

    // Calculate total from expense transactions
    final totalExpenses = expenseTransactions.fold<double>(
      0.0,
      (sum, transaction) => sum + (transaction.subTotal ?? 0.0),
    );

    // Calculate tax payable directly from transactions
    double totalTaxPayable = 0.0;
    double totalCOGS = 0.0;

    // Use the tax amount directly from transactions for better performance
    for (final transaction in filteredIncome) {
      // Add tax amount from transaction
      totalTaxPayable += transaction.taxAmount ?? 0.0;
    }

    // For COGS, we'll use a simplified approach based on transaction subtotals
    // This avoids the expensive item-by-item variant lookups
    // Assuming average COGS is approximately 60% of revenue
    totalCOGS = filteredIncome.fold<double>(
      0.0,
      (sum, transaction) => sum + ((transaction.subTotal ?? 0.0) * 0.6),
    );

    talker.debug('Using simplified COGS calculation: 60% of revenue');
    talker.debug('This avoids expensive item-by-item variant lookups');

    // If more accurate COGS is needed, consider pre-calculating and storing
    // COGS values when items are added to transactions

    talker.debug('Total COGS: $totalCOGS');
    talker.debug('Total tax payable: $totalTaxPayable');
    talker.debug('Total income: $totalIncome');
    talker.debug('Total expenses: $totalExpenses');

    // Net profit = Revenue - COGS - Operational Expenses - Taxes
    // totalCOGS
    final netProfit = totalIncome - totalCOGS - totalExpenses - totalTaxPayable;

    // Detailed logging for debugging the calculation
    talker.debug('Net Profit Calculation:');
    talker.debug('  Total Income: $totalIncome');
    talker.debug('  Total COGS: $totalCOGS');
    talker.debug('  Total Expenses: $totalExpenses');
    talker.debug('  Total Tax Payable: $totalTaxPayable');
    talker.debug(
        '  Net Profit = $totalIncome - $totalCOGS - $totalExpenses - $totalTaxPayable = $netProfit');

    yield netProfit;
  }
}

@riverpod
Stream<double> grossProfitStream(
  Ref ref, {
  required DateTime startDate,
  required DateTime endDate,
  int? branchId,
  bool forceRealData = true,
}) async* {
  branchId ??= ProxyService.box.getBranchId();
  if (branchId == null) {
    talker.error('Branch ID is required for grossProfitStream');
    throw StateError('Branch ID is required');
  }

  final incomeStream = ProxyService.strategy.transactionsStream(
    startDate: startDate,
    endDate: endDate,
    forceRealData: forceRealData,
    branchId: branchId,
    isCashOut: false, // Only get income transactions
    removeAdjustmentTransactions: true,
  );

  await for (final incomeTransactions in incomeStream) {
    // Filter out any transactions that are marked as expenses in the income stream
    final filteredIncome = incomeTransactions
        .where((tx) => !(tx.isExpense ?? false) && !(tx.isRefunded ?? false))
        .toList();

    // Calculate total from filtered income transactions
    final totalIncome = filteredIncome.fold<double>(
      0.0,
      (sum, tx) => sum + (tx.subTotal ?? 0.0),
    );

    yield totalIncome;
  }
}

@riverpod
Stream<double> totalIncomeStream(
  Ref ref, {
  required DateTime startDate,
  required DateTime endDate,
  int? branchId,
  bool forceRealData = true,
}) async* {
  branchId ??= ProxyService.box.getBranchId();
  if (branchId == null) {
    talker.error('Branch ID is required for totalIncomeStream');
    throw StateError('Branch ID is required');
  }

  final transactionsStream = ProxyService.strategy.transactionsStream(
    startDate: startDate,
    endDate: endDate,
    forceRealData: forceRealData,
    branchId: branchId,
    removeAdjustmentTransactions: true,
  );

  await for (final transactions in transactionsStream) {
    // Filter out any expense transactions directly
    final incomeTransactions =
        transactions.where((tx) => !(tx.isExpense ?? false)).toList();

    // Calculate total income only from non-expense transactions
    final totalIncome = incomeTransactions.fold<double>(
      0.0,
      (sum, tx) => sum + (tx.subTotal ?? 0.0),
    );

    yield totalIncome;
  }
}
