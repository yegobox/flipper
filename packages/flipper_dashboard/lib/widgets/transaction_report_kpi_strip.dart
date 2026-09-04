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
    required this.showDetailed,
    this.metrics = ReportMetrics.comfortable,
  });

  /// The period is not passed in: every card reads
  /// [transactionReportKpiTotalsProvider], which watches the global
  /// [dateRangeProvider] the grid pages against. Keeping one source of the
  /// window is what stops the cards and the grid disagreeing.
  final bool showDetailed;

  /// Height-aware sizing; defaults to the legacy (large screen) values.
  final ReportMetrics metrics;

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

  /// Net Profit comes from the same rollup as the other three cards
  /// ([TransactionReportKpiTotals.netProfit] = in-scope gross − VAT −
  /// in-scope expenses), so it can never report a figure for a period whose
  /// grid is empty.
  Widget _netProfitCard(AsyncValue<TransactionReportKpiTotals> kpiAsync) {
    if (kpiAsync.isLoading && !kpiAsync.hasValue) {
      return _summaryCard('Net Profit', 0.0, true, Colors.purple);
    }

    // asData?.value (not .value) so an AsyncError degrades to zeros instead of
    // rethrowing synchronously and crashing the whole KPI strip.
    final kpi = kpiAsync.asData?.value ?? const TransactionReportKpiTotals();
    return _summaryCard(
      'Net Profit',
      kpi.netProfit,
      kpiAsync.isLoading,
      Colors.purple,
    );
  }

  Widget _twoCardRow(AsyncValue<TransactionReportKpiTotals> kpiAsync) {
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
        Expanded(child: _netProfitCard(kpiAsync)),
        SizedBox(width: metrics.kpiGap),
      ],
    );
  }

  Widget _fourCardRow(AsyncValue<TransactionReportKpiTotals> kpiAsync) {
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
        Expanded(child: _netProfitCard(kpiAsync)),
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
      return _twoCardRow(kpiAsync);
    }
    return _fourCardRow(kpiAsync);
  }
}
