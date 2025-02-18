import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_models/providers/date_range_provider.dart';
import 'package:flipper_models/realm_model_export.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'transactions_provider.g.dart';

// Transactions provider
@riverpod
Stream<List<ITransaction>> transactions(Ref ref) {
  final branchId = ProxyService.box.getBranchId();
  if (branchId == null) {
    throw StateError('Branch ID is required');
  }

  return ProxyService.strategy.transactionsStream(
    status: PARKED,
    branchId: branchId,
  );
}

// Transaction items provider
@riverpod
Stream<List<TransactionItem>> transactionItemList(Ref ref) {
  final dateRange = ref.watch(dateRangeProvider);
  final startDate = dateRange.startDate;
  final endDate = dateRange.endDate;
  final branchId = ProxyService.box.getBranchId();

  // Input validation
  if (branchId == null) {
    throw StateError('Branch ID is required');
  }

  if (startDate == null || endDate == null) {
    return Stream.value([]);
  }

  // Keep provider alive
  ref.keepAlive();

  return ProxyService.strategy
      .transactionItemsStreams(
        startDate: startDate,
        endDate: endDate,
        branchId: branchId,
      )
      .map((transactions) => transactions)
      .handleError((error, stackTrace) {
    talker.error('Error loading transaction items: $error');
    talker.error(stackTrace);
    throw error;
  });
}

@riverpod
Stream<ITransaction> pendingTransactionStream(Ref ref,
    {required bool isExpense}) {
  return ProxyService.strategy.manageTransactionStream(
    transactionType:
        isExpense ? TransactionType.purchase : TransactionType.sale,
    isExpense: isExpense,
    branchId: ProxyService.box.getBranchId()!,
  );
}
