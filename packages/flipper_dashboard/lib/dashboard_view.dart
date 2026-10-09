import 'package:flipper_design_system/flipper_design_system.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'dart:developer';

import 'package:flipper_dashboard/features/daily_goal/daily_goal_card.dart';
import 'package:flipper_dashboard/widgets/app_icons_grid.dart';
import 'package:flipper_dashboard/widgets/dashboard_mobile_bottom_nav.dart';
import 'package:flipper_dashboard/widgets/mpos/mpos_states.dart';
import 'package:flipper_dashboard/widgets/dashboard_quick_access_svgs.dart';
import 'package:flipper_dashboard/features/stock_value/stock_value_report_screen.dart';
import 'package:flipper_models/providers/currency_provider.dart';
import 'package:flipper_models/providers/stock_value_report_provider.dart';
import 'package:flipper_models/providers/transactions_provider.dart';
import 'package:flipper_services/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  /// Display label for a period option; the raw value feeds the providers.
  String _periodLabel(String period) {
    final l10n = context.flipperL10n;
    switch (period) {
      case 'Today':
        return l10n.dashViewToday;
      case 'This Week':
        return l10n.dashViewThisWeek;
      case 'This Month':
        return l10n.dashViewThisMonth;
      case 'This Year':
        return l10n.dashViewThisYear;
      default:
        return period;
    }
  }

  /// What the gauge delta is compared against, e.g. "12% vs yesterday".
  String _comparisonLabel(String period) {
    final l10n = context.flipperL10n;
    switch (period) {
      case 'Today':
        return l10n.dashboardCompareYesterday;
      case 'This Week':
        return l10n.dashboardCompareLastWeek;
      case 'This Month':
        return l10n.dashboardCompareLastMonth;
      case 'This Year':
        return l10n.dashboardCompareLastYear;
      default:
        return l10n.dashboardGaugeLastPeriod;
    }
  }

  /// Display label for a profit option; the raw value feeds [displayValue].
  String _profitTypeLabel(String type) {
    final l10n = context.flipperL10n;
    switch (type) {
      case 'Net Profit':
        return l10n.dashViewNetProfit;
      case 'Gross Profit':
        return l10n.dashViewGrossProfit;
      default:
        return type;
    }
  }

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
                  dashboardPreviousGaugeSnapshotProvider(transactionPeriod),
                );
                ref.invalidate(stockValueSummaryProvider);
                await mposAwaitRefresh(
                  ref.refresh(
                    dashboardGaugeSnapshotProvider(transactionPeriod).future,
                  ),
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
                      // Clear the New sale button, which rises above the bar.
                      const SizedBox(
                        height: 16 + DashboardMobileBottomNav.fabRise,
                      ),
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
          border: Border(bottom: BorderSide(color: Color(0xFFE5E7EB))),
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
                      label: _periodLabel(period),
                      selected: isSelected,
                      onTap: () => setState(() => transactionPeriod = period),
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
                    padding: const EdgeInsets.only(right: 8),
                    child: _mobileProfitChip(
                      label: _profitTypeLabel(type),
                      selected: isSelected,
                      onTap: () => setState(() => profitType = type),
                    ),
                  );
                }).toList(),
              ),
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
                    label: Text(_periodLabel(period)),
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
                    label: Text(_profitTypeLabel(type)),
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
  }) => _mobileChip(
    label: label,
    selected: selected,
    onTap: onTap,
    selectedFill: const Color(0xFF111827),
    selectedBorder: const Color(0xFF111827),
    selectedInk: Colors.white,
  );

  Widget _mobileProfitChip({
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) => _mobileChip(
    label: label,
    selected: selected,
    onTap: onTap,
    selectedFill: _blueTint,
    selectedBorder: _accentBlue,
    selectedInk: _accentBlue,
  );

  /// Filter chip shared by the period and profit rows: same height, padding
  /// and type; only the selected colours differ (period is the primary
  /// filter, so it gets the solid fill).
  ///
  /// The fill sits *under* a transparent [Material] so the ripple paints on
  /// top of it — an [InkWell] below an opaque container never shows.
  Widget _mobileChip({
    required String label,
    required bool selected,
    required VoidCallback onTap,
    required Color selectedFill,
    required Color selectedBorder,
    required Color selectedInk,
  }) {
    final shape = BorderRadius.circular(22);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      curve: Curves.ease,
      decoration: BoxDecoration(
        color: selected ? selectedFill : Colors.white,
        borderRadius: shape,
        border: Border.all(
          color: selected ? selectedBorder : const Color(0xFFE5E7EB),
          width: 1.5,
        ),
      ),
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          borderRadius: shape,
          onTap: () {
            if (!selected) HapticFeedback.selectionClick();
            onTap();
          },
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 44),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Center(
                widthFactor: 1,
                child: Text(
                  label,
                  style: GoogleFonts.outfit(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: selected ? selectedInk : const Color(0xFF4B5563),
                  ),
                ),
              ),
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
          context.flipperL10n.dashViewFromYegobox,
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
    if (!current.hasActivity) return null;
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
      final currency = ref.watch(defaultCurrencyProvider);
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
                  periodLabel: _periodLabel(transactionPeriod),
                  currencyCode: currency,
                  isEmpty: !snapshot.hasActivity,
                  deltaPercent: _deltaPercent(snapshot, previous),
                  comparisonLabel: _comparisonLabel(transactionPeriod),
                ),
                const SizedBox(height: 12),
                _buildStockValueSummaryCard(context, ref, currency),
                const SizedBox(height: 12),
                _buildRevenueExpenseRow(snapshot, previous, currency),
                const SizedBox(height: 12),
                const DailyGoalCard(),
              ],
            ),
          );
        },
        // A failed load used to draw an empty gauge saying "No
        // transactions yet", which looked like a quiet day.
        error: (err, stack) {
          log('error: $err stack: $stack');
          return Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: MposErrorState(
              onRetry: () => ref.invalidate(
                dashboardGaugeSnapshotProvider(transactionPeriod),
              ),
            ),
          );
        },
        // Same card stack as the loaded state, so nothing jumps on arrival.
        loading: () => const Padding(
          padding: EdgeInsets.fromLTRB(16, 12, 16, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              MposSkeletonCard(height: 290, lines: 4),
              SizedBox(height: 12),
              MposSkeletonCard(height: 136),
              SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: MposSkeletonCard(height: 150)),
                  SizedBox(width: 12),
                  Expanded(child: MposSkeletonCard(height: 150)),
                ],
              ),
            ],
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

  Widget _buildStockValueSummaryCard(
    BuildContext context,
    WidgetRef ref,
    String currency,
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
                    context.flipperL10n.dashViewStockValue,
                    style: GoogleFonts.outfit(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: AlignmentDirectional.centerEnd,
                      child: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: '$currency ',
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
                        maxLines: 1,
                      ),
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
                    color: hasLowStock
                        ? const Color(0xFFB45309)
                        : Colors.grey.shade500,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      context.flipperL10n.dashViewItemsLowOnStock(
                        summary.needsRestockCount,
                      ),
                      style: GoogleFonts.outfit(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: hasLowStock
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
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                    ),
                    child: Text(
                      context.flipperL10n.dashViewFullReport,
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
                  context.flipperL10n.dashViewDataIncomplete,
                  style: GoogleFonts.outfit(
                    fontSize: 12,
                    color: Colors.black54,
                  ),
                ),
              ],
            ],
          );
        },
        loading: () => SizedBox(
          height: 88,
          child: MposSkeleton(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    MposSkeleton.bar(width: 110, height: 14),
                    const Spacer(),
                    MposSkeleton.bar(width: 96, height: 22),
                  ],
                ),
                const SizedBox(height: 16),
                MposSkeleton.bar(height: 6),
                const SizedBox(height: 16),
                MposSkeleton.bar(width: 150),
              ],
            ),
          ),
        ),
        error: (_, __) => MposErrorState(
          compact: true,
          title: context.flipperL10n.dashViewUnableToLoadStock,
          onRetry: () => ref.invalidate(stockValueSummaryProvider),
        ),
      ),
    );
  }

  Widget _buildRevenueExpenseRow(
    DashboardGaugeSnapshot snapshot,
    DashboardGaugeSnapshot? previous,
    String currency,
  ) {
    final hasRevenue = snapshot.hasRevenue;
    final hasExpenses = snapshot.hasDeductions;
    final revenueDelta = hasRevenue
        ? _percentChange(snapshot.revenue, previous?.revenue ?? 0)
        : null;
    final expenseDelta = hasExpenses
        ? _percentChange(snapshot.deductions, previous?.deductions ?? 0)
        : null;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: _summaryStatCard(
              icon: DashboardQuickAccessSvgs.revenueSummaryIcon(),
              currency: currency,
              iconBackground: const Color(0xFFE6F7EF),
              label: context.flipperL10n.dashViewRevenue,
              valueText: hasRevenue ? formatNumber(snapshot.revenue) : '0',
              valueColor: hasRevenue
                  ? _summaryRevenueStroke
                  : Colors.grey.shade400,
              deltaPercent: revenueDelta,
              isUp: revenueDelta != null && revenueDelta >= 0,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _summaryStatCard(
              icon: DashboardQuickAccessSvgs.expensesSummaryIcon(),
              currency: currency,
              iconBackground: const Color(0xFFFDECEC),
              label: context.flipperL10n.dashViewExpenses,
              valueText: hasExpenses ? formatNumber(snapshot.deductions) : '0',
              valueColor: hasExpenses
                  ? _summaryExpenseStroke
                  : Colors.grey.shade400,
              deltaPercent: expenseDelta,
              isUp: expenseDelta != null && expenseDelta >= 0,
              // More spending than last period is the bad direction.
              upIsGood: false,
            ),
          ),
        ],
      ),
    );
  }

  int? _percentChange(double current, double previous) {
    if (previous == 0) return null;
    return (((current - previous) / previous.abs()) * 100).round();
  }

  Widget _summaryStatCard({
    required Widget icon,
    required String currency,
    required Color iconBackground,
    required String label,
    required String valueText,
    required Color valueColor,
    int? deltaPercent,
    bool isUp = true,
    bool upIsGood = true,
  }) {
    final deltaColor = isUp == upIsGood
        ? _summaryRevenueStroke
        : _summaryExpenseStroke;
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
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: AlignmentDirectional.centerStart,
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: '$currency ',
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
              maxLines: 1,
            ),
          ),
          if (deltaPercent != null) ...[
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(
                  isUp ? Icons.arrow_upward : Icons.arrow_downward,
                  size: 12,
                  color: deltaColor,
                ),
                const SizedBox(width: 2),
                Flexible(
                  child: Text(
                    isUp
                        ? context.flipperL10n.dashViewDeltaUp(
                            '${deltaPercent.abs()}',
                          )
                        : context.flipperL10n.dashViewDeltaDown(
                            '${deltaPercent.abs()}',
                          ),
                    style: FlipperFonts.mono(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: deltaColor,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
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
