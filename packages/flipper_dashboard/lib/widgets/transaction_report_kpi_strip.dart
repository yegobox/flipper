import 'package:flipper_dashboard/data_view_reports/DynamicDataSource.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/providers/transactions_provider.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// KPI row for Transaction Reports — lives on the grey page chrome (not inside the table card).
class TransactionReportKpiStrip extends ConsumerWidget {
  const TransactionReportKpiStrip({
    super.key,
    required this.transactions,
    required this.transactionItems,
    required this.paymentSumsByTransactionId,
    required this.startDate,
    required this.endDate,
    required this.showDetailed,
  });

  final List<ITransaction> transactions;
  final List<TransactionItem>? transactionItems;
  final Map<String, TransactionPaymentSums>? paymentSumsByTransactionId;
  final DateTime startDate;
  final DateTime endDate;
  final bool showDetailed;

  static double _pluLineRevenueFromItemList(List<TransactionItem> items) {
    if (items.isEmpty) return 0.0;
    return items.fold<double>(
      0.0,
      (sum, item) => sum + item.price.toDouble() * item.qty.toDouble(),
    );
  }

  static double _pluGrossProfitFromItemList(List<TransactionItem> items) {
    if (items.isEmpty) return 0.0;
    return items.fold<double>(
      0.0,
      (sum, item) => sum + TransactionItemPluMetrics.profitMade(item),
    );
  }

  static double _pluTotalLineTaxFromList(List<TransactionItem> items) {
    if (items.isEmpty) return 0.0;
    return items.fold<double>(
      0.0,
      (sum, item) => sum + TransactionItemPluMetrics.taxPayable(item),
    );
  }

  static double _sumExpenseSubtotals(List<ITransaction> expenseTransactions) {
    return expenseTransactions.fold<double>(
      0.0,
      (sum, tx) => sum + (tx.subTotal ?? 0.0),
    );
  }

  List<TransactionItem> _profitCardItems(
    AsyncValue<List<TransactionItem>> itemsAsync,
  ) {
    return transactionItems ?? itemsAsync.value ?? [];
  }

  bool _profitCardItemsLoading(AsyncValue<List<TransactionItem>> itemsAsync) {
    return transactionItems == null && itemsAsync.isLoading;
  }

  Widget _summaryCard(
    String label,
    double? value,
    bool isLoading,
    Color color,
  ) {
    final raw = value ?? 0.0;
    final displayTotal = double.parse(raw.toStringAsFixed(2));
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        children: [
          Container(
            width: 6,
            height: 70,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label.toUpperCase(),
                    style: TextStyle(
                      fontSize: 10,
                      letterSpacing: 0.9,
                      fontWeight: FontWeight.w800,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  isLoading
                      ? SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: color,
                          ),
                        )
                      : Text(
                          displayTotal.toCurrencyFormatted(
                            symbol: ProxyService.box.defaultCurrency(),
                          ),
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: color,
                          ),
                        ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _twoCardRow(WidgetRef ref) {
    return Row(
      children: [
        const SizedBox(width: 12),
        Expanded(
          child: Consumer(
            builder: (context, ref, _) {
              final itemsAsync = ref.watch(transactionItemListProvider);
              final items = _profitCardItems(itemsAsync);
              final loading = _profitCardItemsLoading(itemsAsync);
              final lineSales = _pluLineRevenueFromItemList(items);
              return _summaryCard('Total Sales', lineSales, loading, Colors.green);
            },
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Consumer(
            builder: (context, ref, _) {
              final itemsAsync = ref.watch(transactionItemListProvider);
              final items = _profitCardItems(itemsAsync);
              final itemsLoading = _profitCardItemsLoading(itemsAsync);
              final gross = _pluGrossProfitFromItemList(items);
              final tax = _pluTotalLineTaxFromList(items);
              final bid = ProxyService.box.getBranchId();

              if (bid == null) {
                return _summaryCard(
                  'Net Profit',
                  gross - tax,
                  itemsLoading,
                  Colors.purple,
                );
              }

              final expAsync = ref.watch(
                expensesStreamProvider(
                  startDate: startDate,
                  endDate: endDate,
                  branchId: bid,
                ),
              );

              return expAsync.when(
                data: (expenseTxs) => _summaryCard(
                  'Net Profit',
                  gross - tax - _sumExpenseSubtotals(expenseTxs),
                  itemsLoading,
                  Colors.purple,
                ),
                loading: () => _summaryCard('Net Profit', gross - tax, true, Colors.purple),
                error: (_, __) => _summaryCard(
                  'Net Profit',
                  gross - tax,
                  itemsLoading,
                  Colors.purple,
                ),
              );
            },
          ),
        ),
        const SizedBox(width: 12),
      ],
    );
  }

  Widget _fourCardRow(WidgetRef ref) {
    final sumsMap = paymentSumsByTransactionId ?? <String, TransactionPaymentSums>{};
    var byHand = 0.0;
    var credit = 0.0;
    for (final tx in transactions) {
      final s = sumsMap[tx.id.toString()];
      byHand += transactionReportByHandForTotals(tx, s);
      credit += transactionReportCreditForTotals(tx, s);
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(width: 12),
        Expanded(
          child: Consumer(
            builder: (context, ref, _) {
              final itemsAsync = ref.watch(transactionItemListProvider);
              final items = _profitCardItems(itemsAsync);
              final loading = _profitCardItemsLoading(itemsAsync);
              final lineSales = _pluLineRevenueFromItemList(items);
              return _summaryCard('Total Sales', lineSales, loading, Colors.green);
            },
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Consumer(
            builder: (context, ref, _) {
              final itemsAsync = ref.watch(transactionItemListProvider);
              final items = _profitCardItems(itemsAsync);
              final itemsLoading = _profitCardItemsLoading(itemsAsync);
              final gross = _pluGrossProfitFromItemList(items);
              final tax = _pluTotalLineTaxFromList(items);
              final bid = ProxyService.box.getBranchId();

              if (bid == null) {
                return _summaryCard(
                  'Net Profit',
                  gross - tax,
                  itemsLoading,
                  Colors.purple,
                );
              }

              final expAsync = ref.watch(
                expensesStreamProvider(
                  startDate: startDate,
                  endDate: endDate,
                  branchId: bid,
                ),
              );

              return expAsync.when(
                data: (expenseTxs) => _summaryCard(
                  'Net Profit',
                  gross - tax - _sumExpenseSubtotals(expenseTxs),
                  itemsLoading,
                  Colors.purple,
                ),
                loading: () => _summaryCard('Net Profit', gross - tax, true, Colors.purple),
                error: (_, __) => _summaryCard(
                  'Net Profit',
                  gross - tax,
                  itemsLoading,
                  Colors.purple,
                ),
              );
            },
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _summaryCard(
            'Period \u2014 By Hand',
            byHand,
            false,
            Colors.teal,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _summaryCard(
            'Period \u2014 Credit',
            credit,
            false,
            Colors.deepOrange,
          ),
        ),
        const SizedBox(width: 12),
      ],
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (showDetailed) {
      return _twoCardRow(ref);
    }
    return _fourCardRow(ref);
  }
}
