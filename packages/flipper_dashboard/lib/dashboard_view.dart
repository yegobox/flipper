import 'package:flipper_design_system/flipper_design_system.dart';
import 'dart:developer';

import 'package:flipper_dashboard/widgets/app_icons_grid.dart';
import 'package:flipper_dashboard/widgets/dashboard_quick_access_svgs.dart';
import 'package:flipper_dashboard/features/stock_value/stock_value_report_screen.dart';
import 'package:flipper_models/providers/stock_value_report_provider.dart';
import 'package:flipper_models/providers/transactions_provider.dart';
import 'package:flipper_services/utils.dart';
import 'package:flutter/material.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'widgets/analytics_gauge/flipper_analytic.dart';

class DashboardView extends StatefulHookConsumerWidget {
  final bool isBigScreen;
  final CoreViewModel model;
  final VoidCallback? onQuickAccessSeeAll;

  const DashboardView({
    Key? key,
    required this.isBigScreen,
    required this.model,
    this.onQuickAccessSeeAll,
  }) : super(key: key);

  @override
  _DashboardViewState createState() => _DashboardViewState();
}

class _DashboardViewState extends ConsumerState<DashboardView> {
  String transactionPeriod = 'Today';
  final List<String> transactionPeriodOptions = [
    'Today',
    'This Week',
    'This Month',
    'This Year',
  ];

  String profitType = 'Net Profit';
  final List<String> profitTypeOptions = ['Net Profit', 'Gross Profit'];

  static const Color _mobilePageBg = Color(0xFFF4F6FB);
  static const Color _accentBlue = Color(0xFF2563EB);
  static const Color _blueTint = Color(0xFFEFF4FF);
  static const Color _summaryRevenueStroke = Color(0xFF047857);
  static const Color _summaryExpenseStroke = Color(0xFFB42318);

  bool get _mobileChrome => !widget.isBigScreen;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildFilterRow(),
        Expanded(
          child: ColoredBox(
            color: _mobileChrome ? _mobilePageBg : Colors.transparent,
            child: RefreshIndicator(
              onRefresh: () async {
                ref.invalidate(
                  dashboardGaugeSnapshotProvider(transactionPeriod),
                );
                ref.invalidate(
                  dashboardPreviousGaugeSnapshotProvider(transactionPeriod),
                );
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    _buildAnalyticsSection(ref),
                    if (!_mobileChrome) ...[
                      AppIconsGrid(
                        isBigScreen: widget.isBigScreen,
                        onQuickAccessSeeAll: widget.onQuickAccessSeeAll,
                      ),
                      const SizedBox(height: 24),
                      _buildFooter(),
                      const SizedBox(height: 16),
                    ] else ...[
                      const SizedBox(height: 16),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFilterRow() {
    if (_mobileChrome) {
      return Container(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 14),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(
            bottom: BorderSide(color: Color(0xFFE5E7EB)),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: transactionPeriodOptions.map((period) {
                  final isSelected = transactionPeriod == period;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: _mobilePeriodChip(
                      label: period,
                      selected: isSelected,
                      onTap: () => setState(() => transactionPeriod = period),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: profitTypeOptions.map((type) {
                final isSelected = profitType == type;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: _mobileProfitChip(
                    label: type,
                    selected: isSelected,
                    onTap: () => setState(() => profitType = type),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            offset: const Offset(0, 2),
            blurRadius: 4,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: transactionPeriodOptions.map((period) {
                final isSelected = transactionPeriod == period;
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: ChoiceChip(
                    label: Text(period),
                    selected: isSelected,
                    onSelected: (selected) {
                      if (selected) {
                        setState(() => transactionPeriod = period);
                      }
                    },
                    selectedColor: const Color(
                      0xFF0078D4,
                    ).withValues(alpha: 0.1),
                    backgroundColor: Colors.grey[100],
                    labelStyle: TextStyle(
                      color: isSelected
                          ? const Color(0xFF0078D4)
                          : Colors.black87,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.normal,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(
                        color: isSelected
                            ? const Color(0xFF0078D4)
                            : Colors.transparent,
                      ),
                    ),
                    showCheckmark: false,
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: profitTypeOptions.map((type) {
                final isSelected = profitType == type;
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: ChoiceChip(
                    label: Text(type),
                    selected: isSelected,
                    onSelected: (selected) {
                      if (selected) {
                        setState(() => profitType = type);
                      }
                    },
                    selectedColor: Colors.green.withValues(alpha: 0.1),
                    backgroundColor: Colors.grey[100],
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.green[800]! : Colors.black87,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.normal,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(
                        color: isSelected ? Colors.green : Colors.transparent,
                      ),
                    ),
                    showCheckmark: false,
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _mobilePeriodChip({
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          curve: Curves.ease,
          decoration: BoxDecoration(
            color: selected ? const Color(0xFF111827) : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: selected ? const Color(0xFF111827) : const Color(0xFFE5E7EB),
              width: 1.5,
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Text(
            label,
            style: GoogleFonts.outfit(
              fontSize: 14.5,
              fontWeight: FontWeight.w600,
              color: selected ? Colors.white : const Color(0xFF4B5563),
            ),
          ),
        ),
      ),
    );
  }

  Widget _mobileProfitChip({
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          curve: Curves.ease,
          decoration: BoxDecoration(
            color: selected ? _blueTint : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: selected ? _accentBlue : const Color(0xFFE5E7EB),
              width: 1.5,
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
          child: Text(
            label,
            style: GoogleFonts.outfit(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: selected ? _accentBlue : const Color(0xFF4B5563),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Column(
      children: [
        Text(
          'FROM YEGOBOX',
          style: GoogleFonts.outfit(
            fontSize: 14,
            color: Colors.black87,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.2,
          ),
        ),
      ],
    );
  }

  int? _deltaPercent(
    DashboardGaugeSnapshot current,
    DashboardGaugeSnapshot? previous,
  ) {
    if (current.isEmpty) return null;
    final currentVal = current.displayValue(profitType);
    final prevVal = previous?.displayValue(profitType) ?? 0;
    if (prevVal == 0) return null;
    return (((currentVal - prevVal) / prevVal.abs()) * 100).round();
  }

  Widget _buildAnalyticsSection(WidgetRef ref) {
    final gaugeAsync = ref.watch(
      dashboardGaugeSnapshotProvider(transactionPeriod),
    );
    final prevAsync = _mobileChrome
        ? ref.watch(dashboardPreviousGaugeSnapshotProvider(transactionPeriod))
        : const AsyncValue<DashboardGaugeSnapshot>.data(
            DashboardGaugeSnapshot(grossProfit: 0, deductions: 0),
          );

    if (_mobileChrome) {
      return gaugeAsync.when(
        data: (snapshot) {
          final previous = prevAsync.hasValue ? prevAsync.value : null;
          return Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                DashboardHomeGauge(
                  value: snapshot.displayValue(profitType),
                  revenue: snapshot.revenue,
                  grossProfit: snapshot.grossProfit,
                  deductions: snapshot.deductions,
                  profitType: profitType,
                  periodLabel: transactionPeriod,
                  isEmpty: snapshot.isEmpty,
                  deltaPercent: _deltaPercent(snapshot, previous),
                  comparisonLabel:
                      dashboardComparisonPeriodLabel(transactionPeriod),
                ),
                const SizedBox(height: 12),
                _buildStockValueSummaryCard(context, ref, snapshot.isEmpty),
                const SizedBox(height: 12),
                _buildRevenueExpenseRow(snapshot, previous),
                const SizedBox(height: 12),
                _buildDailyGoalCard(ref),
              ],
            ),
          );
        },
        error: (err, stack) {
          log('error: $err stack: $stack');
          return Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: DashboardHomeGauge(
              value: 0,
              revenue: 0,
              grossProfit: 0,
              deductions: 0,
              profitType: profitType,
              periodLabel: transactionPeriod,
              isEmpty: true,
            ),
          );
        },
        loading: () => const Center(
          child: Padding(
            padding: EdgeInsets.all(24.0),
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }

    return gaugeAsync.when(
      data: (snapshot) {
        return Padding(
          padding: const EdgeInsets.only(top: 12),
          child: SemiCircleGauge(
            dataOnGreenSide: snapshot.grossProfit,
            dataOnRedSide: snapshot.deductions,
            startPadding: 50.0,
            profitType: profitType,
            areValueColumnsVisible: true,
            presentation: GaugePresentation.standard,
          ),
        );
      },
      error: (err, stack) {
        log('error: $err stack: $stack');
        return Padding(
          padding: const EdgeInsets.only(top: 12),
          child: SemiCircleGauge(
            dataOnGreenSide: 0,
            dataOnRedSide: 0,
            startPadding: 0.0,
            profitType: profitType,
            areValueColumnsVisible: true,
            presentation: GaugePresentation.standard,
          ),
        );
      },
      loading: () => const Center(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

  Widget _buildDailyGoalCard(WidgetRef ref) {
    const goalTarget = 10;
    final todayAsync = ref.watch(dashboardGaugeSnapshotProvider('Today'));

    return todayAsync.when(
      data: (today) {
        final count = today.transactionCount;
        final progress = (count / goalTarget).clamp(0.0, 1.0);
        final remaining = (goalTarget - count).clamp(0, goalTarget);

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFFFFF8EB),
                Color(0xFFFFF3D6),
              ],
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFFCE0BE)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFC24B).withValues(alpha: 0.25),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.card_giftcard_outlined,
                  color: Color(0xFFB25A00),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      count == 0
                          ? "Today's goal · 0 of $goalTarget sales"
                          : "Today's goal · $count of $goalTarget sales",
                      style: GoogleFonts.outfit(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF92400E),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text.rich(
                      TextSpan(
                        style: GoogleFonts.outfit(
                          fontSize: 13,
                          color: const Color(0xFFB45309),
                        ),
                        children: [
                          TextSpan(
                            text: count == 0
                                ? 'Log your first sale to start earning'
                                : remaining == 0
                                    ? 'Goal reached! '
                                    : 'Just $remaining more to ',
                          ),
                          if (count > 0 && remaining > 0)
                            const TextSpan(
                              text: '+50 pts',
                              style: TextStyle(fontWeight: FontWeight.w700),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(999),
                      child: TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0, end: progress),
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeOutCubic,
                        builder: (context, value, _) {
                          return LinearProgressIndicator(
                            value: value,
                            minHeight: 6,
                            backgroundColor: const Color(0xFFFCE0BE),
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              Color(0xFFFB9D00),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }

  Widget _buildStockValueSummaryCard(
    BuildContext context,
    WidgetRef ref,
    bool analyticsEmpty,
  ) {
    final summaryAsync = ref.watch(stockValueSummaryProvider);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            offset: const Offset(0, 4),
            blurRadius: 12,
          ),
        ],
      ),
      child: summaryAsync.when(
        data: (summary) {
          final stockLevel = summary.productsCount > 0
              ? ((summary.productsCount - summary.needsRestockCount) /
                      summary.productsCount)
                  .clamp(0.0, 1.0)
              : 0.0;
          final hasLowStock = summary.needsRestockCount > 0;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.layers_outlined,
                    size: 20,
                    color: Colors.grey.shade700,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Stock value',
                    style: GoogleFonts.outfit(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  const Spacer(),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: 'RWF ',
                          style: GoogleFonts.outfit(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey.shade500,
                          ),
                        ),
                        TextSpan(
                          text: formatNumber(summary.totalValue),
                          style: FlipperFonts.mono(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: Colors.black87,
                            letterSpacing: -0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(999),
                child: TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: stockLevel),
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeOutCubic,
                  builder: (context, value, _) {
                    return LinearProgressIndicator(
                      value: value,
                      minHeight: 6,
                      backgroundColor: const Color(0xFFE5E7EB),
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        Color(0xFF2563EB),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(
                    Icons.warning_amber_rounded,
                    size: 16,
                    color: hasLowStock && !analyticsEmpty
                        ? const Color(0xFFB45309)
                        : Colors.grey.shade500,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      analyticsEmpty
                          ? '0 items low on stock'
                          : '${summary.needsRestockCount} items low on stock',
                      style: GoogleFonts.outfit(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: hasLowStock && !analyticsEmpty
                            ? const Color(0xFF92400E)
                            : Colors.grey.shade600,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const StockValueReportScreen(),
                        ),
                      );
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: _accentBlue,
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      'Full report ›',
                      style: GoogleFonts.outfit(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              if (summary.isPossiblyIncomplete) ...[
                const SizedBox(height: 6),
                Text(
                  'Data may be incomplete (partial sync).',
                  style: GoogleFonts.outfit(
                    fontSize: 12,
                    color: Colors.black54,
                  ),
                ),
              ],
            ],
          );
        },
        loading: () => const SizedBox(
          height: 88,
          child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
        ),
        error: (_, __) => Text(
          'Unable to load stock value.',
          style: GoogleFonts.outfit(fontSize: 14, color: Colors.black54),
        ),
      ),
    );
  }

  Widget _buildRevenueExpenseRow(
    DashboardGaugeSnapshot snapshot,
    DashboardGaugeSnapshot? previous,
  ) {
    final isEmpty = snapshot.isEmpty;
    final revenueDelta = isEmpty
        ? null
        : _percentChange(snapshot.revenue, previous?.revenue ?? 0);
    final expenseDelta = isEmpty
        ? null
        : _percentChange(snapshot.deductions, previous?.deductions ?? 0);

    return Row(
      children: [
        Expanded(
          child: _summaryStatCard(
            icon: DashboardQuickAccessSvgs.revenueSummaryIcon(),
            iconBackground: const Color(0xFFE6F7EF),
            label: 'Revenue',
            valueText: isEmpty ? '0' : formatNumber(snapshot.revenue),
            valueColor: isEmpty ? Colors.grey.shade400 : _summaryRevenueStroke,
            deltaPercent: revenueDelta,
            isUp: revenueDelta != null && revenueDelta >= 0,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _summaryStatCard(
            icon: DashboardQuickAccessSvgs.expensesSummaryIcon(),
            iconBackground: const Color(0xFFFDECEC),
            label: 'Expenses',
            valueText: isEmpty ? '0' : formatNumber(snapshot.deductions),
            valueColor: isEmpty ? Colors.grey.shade400 : _summaryExpenseStroke,
            deltaPercent: expenseDelta,
            isUp: expenseDelta != null && expenseDelta >= 0,
          ),
        ),
      ],
    );
  }

  int? _percentChange(double current, double previous) {
    if (previous == 0) return null;
    return (((current - previous) / previous.abs()) * 100).round();
  }

  Widget _summaryStatCard({
    required Widget icon,
    required Color iconBackground,
    required String label,
    required String valueText,
    required Color valueColor,
    int? deltaPercent,
    bool isUp = true,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            offset: const Offset(0, 4),
            blurRadius: 12,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconBackground,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(child: icon),
          ),
          const SizedBox(height: 12),
          Text(
            label,
            style: GoogleFonts.outfit(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade600,
              letterSpacing: 0.08 * 11,
            ),
          ),
          const SizedBox(height: 4),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: 'RWF ',
                  style: GoogleFonts.outfit(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.shade500,
                  ),
                ),
                TextSpan(
                  text: valueText,
                  style: FlipperFonts.mono(
                    fontSize: 21,
                    fontWeight: FontWeight.w700,
                    color: valueColor,
                    letterSpacing: -0.5,
                  ),
                ),
              ],
            ),
          ),
          if (deltaPercent != null) ...[
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(
                  isUp ? Icons.trending_up : Icons.arrow_downward,
                  size: 12,
                  color: isUp ? _summaryRevenueStroke : _summaryExpenseStroke,
                ),
                const SizedBox(width: 2),
                Text(
                  '${deltaPercent.abs()}% ${isUp ? 'up' : 'up'}',
                  style: FlipperFonts.mono(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: isUp ? _summaryRevenueStroke : _summaryExpenseStroke,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
