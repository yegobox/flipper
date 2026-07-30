import 'package:flipper_dashboard/features/transaction_reports/transaction_report_density.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/helperModels/extensions.dart';
import 'package:flipper_models/helperModels/transaction_report_kpi_totals.dart';
import 'package:flipper_models/providers/transactions_provider.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// KPI row for Transaction Reports — full-period aggregates (batched), not tied to grid page.
class TransactionReportKpiStrip extends ConsumerWidget {
  const TransactionReportKpiStrip({
    super.key,
    required this.startDate,
    required this.endDate,
    required this.showDetailed,
    this.metrics = ReportMetrics.comfortable,
  });

  final DateTime startDate;
  final DateTime endDate;
  final bool showDetailed;

  /// Height-aware sizing; defaults to the legacy (large screen) values.
  final ReportMetrics metrics;

  double _sumExpenseSubtotals(List<ITransaction> expenseTransactions) {
    return expenseTransactions.fold<double>(
      0.0,
      (sum, tx) => sum + (tx.subTotal ?? 0.0),
    );
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
            height: metrics.kpiBarHeight,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          SizedBox(width: metrics.kpiGap),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: metrics.kpiCardVerticalPadding,
                horizontal: 8,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    label.toUpperCase(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: metrics.kpiLabelFontSize,
                      letterSpacing: 0.9,
                      fontWeight: FontWeight.w800,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  SizedBox(height: metrics.kpiLabelValueGap),
                  // Scale (never clip) the amount so narrow cards keep the full
                  // figure readable on small laptops.
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      // Placeholder dash while the period totals are still loading.
                      isLoading
                          ? '—'
                          : displayTotal.toCurrencyFormatted(
                              symbol: ProxyService.box.defaultCurrency(),
                            ),
                      maxLines: 1,
                      style: TextStyle(
                        fontSize: metrics.kpiValueFontSize,
                        fontWeight: FontWeight.w800,
                        color: color,
                      ),
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

  Widget _netProfitCard(
    WidgetRef ref,
    AsyncValue<TransactionReportKpiTotals> kpiAsync,
  ) {
    final bid = ProxyService.box.getBranchId();

    if (kpiAsync.isLoading && !kpiAsync.hasValue) {
      return _summaryCard('Net Profit', 0.0, true, Colors.purple);
    }

    // asData?.value (not .value) so an AsyncError degrades to zeros instead of
    // rethrowing synchronously and crashing the whole KPI strip.
    final kpi = kpiAsync.asData?.value ?? const TransactionReportKpiTotals();
    final gross = kpi.pluGrossProfit;
    final tax = kpi.pluLineTax;
    final kpiLoading = kpiAsync.isLoading;

    if (bid == null) {
      return _summaryCard('Net Profit', gross - tax, kpiLoading, Colors.purple);
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
        kpiLoading,
        Colors.purple,
      ),
      loading: () =>
          _summaryCard('Net Profit', gross - tax, true, Colors.purple),
      // Expenses failed to load: never show `gross - tax` as a final figure —
      // that silently drops the expense deduction and overstates Net Profit.
      // Keep the card in its loading state; the live stream re-emits and
      // self-heals when the backend recovers.
      error: (_, __) =>
          _summaryCard('Net Profit', gross - tax, true, Colors.purple),
    );
  }

  Widget _twoCardRow(
    WidgetRef ref,
    AsyncValue<TransactionReportKpiTotals> kpiAsync,
  ) {
    final loading = kpiAsync.isLoading && !kpiAsync.hasValue;
    final kpi = kpiAsync.asData?.value;

    return Row(
      children: [
        SizedBox(width: metrics.kpiGap),
        Expanded(
          child: _summaryCard(
            'Total Sales',
            kpi?.periodSubtotal,
            loading,
            Colors.green,
          ),
        ),
        SizedBox(width: metrics.kpiGap),
        Expanded(child: _netProfitCard(ref, kpiAsync)),
        SizedBox(width: metrics.kpiGap),
      ],
    );
  }

  Widget _fourCardRow(
    WidgetRef ref,
    AsyncValue<TransactionReportKpiTotals> kpiAsync,
  ) {
    final loading = kpiAsync.isLoading && !kpiAsync.hasValue;
    final kpi = kpiAsync.asData?.value;
    // Collected = Total Sales (subTotal) − Owed, so the cards partition exactly.
    final collected =
        kpi == null ? null : (kpi.periodSubtotal - kpi.periodOwed);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(width: metrics.kpiGap),
        Expanded(
          child: _summaryCard(
            'Total Sales',
            kpi?.periodSubtotal,
            loading,
            Colors.green,
          ),
        ),
        SizedBox(width: metrics.kpiGap),
        Expanded(child: _netProfitCard(ref, kpiAsync)),
        SizedBox(width: metrics.kpiGap),
        Expanded(
          child: _summaryCard(
            'Collected',
            collected,
            loading,
            Colors.teal,
          ),
        ),
        SizedBox(width: metrics.kpiGap),
        Expanded(
          child: _summaryCard(
            'Owed',
            kpi?.periodOwed,
            loading,
            Colors.brown,
          ),
        ),
        SizedBox(width: metrics.kpiGap),
      ],
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final kpiAsync = ref.watch(transactionReportKpiTotalsProvider);
    if (showDetailed) {
      return _twoCardRow(ref, kpiAsync);
    }
    return _fourCardRow(ref, kpiAsync);
  }
}
