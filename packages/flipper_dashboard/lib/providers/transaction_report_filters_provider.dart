import 'package:flipper_dashboard/data_view_reports/DynamicDataSource.dart';
import 'package:flipper_dashboard/transaction_report_mock_cashiers.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/helperModels/transaction_payment_sums.dart';
import 'package:flipper_models/helperModels/transaction_report_snapshot.dart';
import 'package:flipper_models/providers/transactions_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

enum TransactionReportViewMode { table, chart }

enum TransactionReportPaymentFilter { all, byHand, credit }

class TransactionReportFilters {
  const TransactionReportFilters({
    this.receiptQuery = '',
    this.status,
    this.transactionType,
    this.payment = TransactionReportPaymentFilter.all,
    this.cashierAgentId,
    this.viewMode = TransactionReportViewMode.table,
  });

  final String receiptQuery;
  final String? status;

  /// In the current grid, the “Type” column is `receiptType` (e.g. NS, RFN).
  /// We keep the name `transactionType` to match existing plan terminology.
  final String? transactionType;

  final TransactionReportPaymentFilter payment;
  final String? cashierAgentId;
  final TransactionReportViewMode viewMode;

  TransactionReportFilters copyWith({
    String? receiptQuery,
    String? status,
    String? transactionType,
    TransactionReportPaymentFilter? payment,
    String? cashierAgentId,
    TransactionReportViewMode? viewMode,
    bool clearStatus = false,
    bool clearTransactionType = false,
    bool clearCashierAgentId = false,
  }) {
    return TransactionReportFilters(
      receiptQuery: receiptQuery ?? this.receiptQuery,
      status: clearStatus ? null : (status ?? this.status),
      transactionType: clearTransactionType
          ? null
          : (transactionType ?? this.transactionType),
      payment: payment ?? this.payment,
      cashierAgentId:
          clearCashierAgentId ? null : (cashierAgentId ?? this.cashierAgentId),
      viewMode: viewMode ?? this.viewMode,
    );
  }
}

class TransactionReportFiltersNotifier extends Notifier<TransactionReportFilters> {
  @override
  TransactionReportFilters build() => const TransactionReportFilters();

  void setReceiptQuery(String value) =>
      state = state.copyWith(receiptQuery: value);

  void clearReceiptQuery() => state = state.copyWith(receiptQuery: '');

  void setStatus(String? value) =>
      state = state.copyWith(status: value, clearStatus: value == null);

  void setTransactionType(String? value) => state = state.copyWith(
        transactionType: value,
        clearTransactionType: value == null,
      );

  void setPayment(TransactionReportPaymentFilter value) =>
      state = state.copyWith(payment: value);

  void setCashierAgentId(String? value) => state = state.copyWith(
        cashierAgentId: value,
        clearCashierAgentId: value == null,
      );

  void setViewMode(TransactionReportViewMode mode) =>
      state = state.copyWith(viewMode: mode);
}

final transactionReportFiltersProvider =
    NotifierProvider<TransactionReportFiltersNotifier, TransactionReportFilters>(
  TransactionReportFiltersNotifier.new,
);

TransactionReportSnapshot _applyFiltersToSnapshot(
  TransactionReportSnapshot snap,
  TransactionReportFilters filters,
) {
  final q = filters.receiptQuery.trim().toLowerCase();

  bool matchesPayment(
    ITransaction tx,
    TransactionPaymentSums? sums,
    TransactionReportPaymentFilter payment,
  ) {
    if (payment == TransactionReportPaymentFilter.all) return true;
    final byHand = transactionReportByHandForTotals(tx, sums);
    final credit = transactionReportCreditForTotals(tx, sums);
    if (payment == TransactionReportPaymentFilter.byHand) {
      return byHand > 0.0001;
    }
    return credit > 0.0001;
  }

  final filtered = <ITransaction>[];
  for (final tx in snap.transactions) {
    if (q.isNotEmpty) {
      final receipt = tx.receiptNumber?.toString() ?? '';
      if (!receipt.toLowerCase().contains(q)) continue;
    }
    if (filters.status != null && filters.status!.isNotEmpty) {
      if (tx.status != filters.status) continue;
    }
    if (filters.transactionType != null && filters.transactionType!.isNotEmpty) {
      // “Type” in the report grid maps to receiptType.
      if ((tx.receiptType ?? '') != filters.transactionType) continue;
    }
    if (!transactionMatchesCashierFilter(tx, filters.cashierAgentId)) {
      continue;
    }
    final sums = snap.paymentSumsByTransactionId[tx.id.toString()];
    if (!matchesPayment(tx, sums, filters.payment)) continue;
    filtered.add(tx);
  }

  final ids = filtered.map((t) => t.id.toString()).toSet();
  final sums = <String, TransactionPaymentSums>{};
  for (final id in ids) {
    final s = snap.paymentSumsByTransactionId[id];
    if (s != null) sums[id] = s;
  }

  return TransactionReportSnapshot(
    transactions: filtered,
    paymentSumsByTransactionId: sums,
  );
}

/// Filtered summary snapshot (transactions + payment sums) for table, chart and export.
final filteredTransactionReportSnapshotProvider =
    Provider.family<AsyncValue<TransactionReportSnapshot>, bool>((
  ref,
  forceRealData,
) {
  final base =
      ref.watch(transactionReportSnapshotProvider(forceRealData: forceRealData));
  final filters = ref.watch(transactionReportFiltersProvider);
  return base.whenData((snap) => _applyFiltersToSnapshot(snap, filters));
});

/// Filtered detailed line items (AsyncValue). Uses the filtered summary transaction id set.
final filteredTransactionItemListProvider =
    Provider.family<AsyncValue<List<TransactionItem>>, bool>((ref, forceRealData) {
  final snapAsync = ref.watch(
    filteredTransactionReportSnapshotProvider(forceRealData),
  );
  final itemsAsync = ref.watch(transactionItemListProvider);

  if (snapAsync.isLoading || itemsAsync.isLoading) {
    return const AsyncValue.loading();
  }
  final snapErr = snapAsync.error;
  final itemsErr = itemsAsync.error;
  if (snapErr != null) {
    return AsyncValue.error(
      snapErr,
      snapAsync.stackTrace ?? StackTrace.current,
    );
  }
  if (itemsErr != null) {
    return AsyncValue.error(
      itemsErr,
      itemsAsync.stackTrace ?? StackTrace.current,
    );
  }

  final snap = snapAsync.value;
  final items = itemsAsync.value;
  if (snap == null || items == null) {
    return const AsyncValue.data(<TransactionItem>[]);
  }

  final allowed = snap.transactions.map((t) => t.id.toString()).toSet();
  final filtered = items
      .where((i) {
        final tid = i.transactionId?.toString();
        return tid != null && allowed.contains(tid);
      })
      .toList();
  return AsyncValue.data(filtered);
});

