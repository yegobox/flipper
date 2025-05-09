import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_models/providers/date_range_provider.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

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
  );
});

// Transactions provider with optional date parameters
@riverpod
Stream<List<ITransaction>> transactions(Ref ref) {
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
  );
}

// Transaction items provider
@riverpod
Stream<List<TransactionItem>> transactionItemList(Ref ref) {
  final dateRange = ref.watch(dateRangeProvider);
  final startDate = dateRange.startDate;
  final endDate = dateRange.endDate;
  final branchId = ProxyService.box.getBranchId();
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
          fetchRemote: false)
      .map((transactions) {
    talker.debug('Received ${transactions.length} transactions');
    return transactions;
  }).handleError((error, stackTrace) {
    talker.error('Error loading transaction items: $error');
    talker.error(stackTrace);
    throw error;
  });
}

@riverpod
Stream<ITransaction> pendingTransactionStream(Ref ref,
    {required bool isExpense}) {
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
}) async* {
  branchId ??= ProxyService.box.getBranchId();
  if (branchId == null) {
    talker.error('Branch ID is required for netProfitStream');
    throw StateError('Branch ID is required');
  }

  final incomeStream = ProxyService.strategy.transactionsStream(
    startDate: startDate,
    endDate: endDate,
    branchId: branchId,
    isCashOut: false, // Only get income transactions
    removeAdjustmentTransactions: true,
  );

  final expensesStream = ProxyService.strategy.transactionsStream(
    startDate: startDate,
    endDate: endDate,
    branchId: branchId,
    isCashOut: true, // Only get expense transactions
    removeAdjustmentTransactions: true,
  );

  // Fetch all transaction items for the period, for tax computation
  final taxItemsStream = ProxyService.strategy.transactionItemsStreams(
    startDate: startDate,
    endDate: endDate,
    branchId: branchId,
    fetchRemote: false, // Changed to false to match other streams and avoid unnecessary network calls
  );

  await for (final incomeTransactions in incomeStream) {
    // Log the number of income transactions for debugging
    talker.debug('Net Profit: Found ${incomeTransactions.length} income transactions');
    
    final expenseTransactions = await expensesStream.first;
    talker.debug('Net Profit: Found ${expenseTransactions.length} expense transactions');
    
    final allTransactionItems = await taxItemsStream.first;
    talker.debug('Net Profit: Found ${allTransactionItems.length} transaction items');

    // Filter out any transactions that are marked as expenses in the income stream
    final filteredIncome =
        incomeTransactions.where((tx) => !(tx.isExpense ?? false)).toList();

    // Calculate total from filtered income transactions (revenue)
    final totalIncome = filteredIncome.fold<double>(
      0.0,
      (sum, tx) => sum + (tx.subTotal ?? 0.0),
    );

    // Calculate total for expense transactions (operational expenses)
    final totalExpenses = expenseTransactions.fold<double>(
      0.0,
      (sum, tx) => sum + (tx.subTotal ?? 0.0),
    );

    // Calculate total tax payable from all transaction items in the period
    final totalTaxPayable = allTransactionItems.fold<double>(
      0.0,
      (sum, item) => sum + (item.taxAmt ?? 0.0),
    );

    // Calculate COGS (Cost of Goods Sold)
    double totalCOGS = 0.0;

    // Process each income transaction to calculate COGS
    for (final transaction in filteredIncome) {
      try {
        // Get transaction items for this transaction
        final transactionItems = await ProxyService.strategy.transactionItems(
          transactionId: transaction.id,
        );

        // If transaction has items, calculate COGS based on variants
        if (transactionItems.isNotEmpty) {
          for (final item in transactionItems) {
            if (item.variantId != null) {
              try {
                // Check if splyAmt is available
                if (item.splyAmt != null) {
                  // splyAmt already includes quantity as per our fix in transaction_item_mixin.dart
                  // So we just add it directly to totalCOGS
                  totalCOGS += item.splyAmt!;

                  talker.debug(
                      'Item: ${item.name}, Qty: ${item.qty}, Supply Amount: ${item.splyAmt}, COGS: ${item.splyAmt}');
                } else {
                  // Fallback: estimate COGS as 70% of item price * quantity
                  final itemCOGS = item.price * item.qty * 0.7;
                  totalCOGS += itemCOGS;

                  talker.debug(
                      'Item: ${item.name}, Qty: ${item.qty}, Using fallback calculation, COGS: $itemCOGS');
                }
              } catch (e) {
                talker
                    .error('Error calculating COGS for item ${item.name}: $e');
                // Fallback: estimate COGS as 70% of item price * quantity
                final itemCOGS = item.price * item.qty * 0.7;
                totalCOGS += itemCOGS;
                talker.debug('Using fallback COGS for ${item.name}: $itemCOGS');
              }
            }
          }
        } else {
          // If transaction has no items, it's likely a non-inventory transaction
          // Current implementation already handles this correctly
          talker.debug(
              'Transaction ${transaction.id} has no items, skipping COGS calculation');
        }
      } catch (e) {
        talker.error(
            'Error fetching items for transaction ${transaction.id}: $e');
      }
    }

    talker.debug('Total COGS: $totalCOGS');
    talker.debug('Total tax payable: $totalTaxPayable');
    talker.debug('Total income: $totalIncome');
    talker.debug('Total expenses: $totalExpenses');

    // Net profit = Revenue - COGS - Operational Expenses - Taxes
    final netProfit = totalIncome - totalCOGS - totalExpenses - totalTaxPayable;
    
    // Detailed logging for debugging the calculation
    talker.debug('Net Profit Calculation:');
    talker.debug('  Total Income: $totalIncome');
    talker.debug('  Total COGS: $totalCOGS');
    talker.debug('  Total Expenses: $totalExpenses');
    talker.debug('  Total Tax Payable: $totalTaxPayable');
    talker.debug('  Net Profit = $totalIncome - $totalCOGS - $totalExpenses - $totalTaxPayable = $netProfit');

    yield netProfit;
  }
}

@riverpod
Stream<double> grossProfitStream(
  Ref ref, {
  required DateTime startDate,
  required DateTime endDate,
  int? branchId,
}) async* {
  branchId ??= ProxyService.box.getBranchId();
  if (branchId == null) {
    talker.error('Branch ID is required for grossProfitStream');
    throw StateError('Branch ID is required');
  }

  final incomeStream = ProxyService.strategy.transactionsStream(
    startDate: startDate,
    endDate: endDate,
    branchId: branchId,
    isCashOut: false, // Only get income transactions
    removeAdjustmentTransactions: true,
  );

  await for (final incomeTransactions in incomeStream) {
    // Filter out any transactions that are marked as expenses in the income stream
    final filteredIncome =
        incomeTransactions.where((tx) => !(tx.isExpense ?? false)).toList();

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
}) async* {
  branchId ??= ProxyService.box.getBranchId();
  if (branchId == null) {
    talker.error('Branch ID is required for totalIncomeStream');
    throw StateError('Branch ID is required');
  }

  final transactionsStream = ProxyService.strategy.transactionsStream(
    startDate: startDate,
    endDate: endDate,
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
