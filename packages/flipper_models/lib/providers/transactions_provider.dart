import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_models/providers/date_range_provider.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'transactions_provider.g.dart';

// Transactions provider
@riverpod
Stream<List<ITransaction>> transactions(Ref ref) {
  final dateRange = ref.watch(dateRangeProvider);
  final startDate = dateRange.startDate;
  final endDate = dateRange.endDate;
  final branchId = ProxyService.box.getBranchId();
  
  talker.debug('transactions provider called');
  
  if (branchId == null) {
    throw StateError('Branch ID is required');
  }

  // Keep provider alive
  ref.keepAlive();
  
  talker.debug('Fetching transactions from ${startDate?.toIso8601String() ?? 'null'} to ${endDate?.toIso8601String() ?? 'null'} for branch $branchId');

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
          fetchRemote: true)
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
