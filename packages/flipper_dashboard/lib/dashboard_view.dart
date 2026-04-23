import 'dart:developer';

import 'package:flipper_dashboard/widgets/app_icons_grid.dart';
import 'package:flipper_dashboard/widgets/dashboard_quick_access_svgs.dart';
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

  static const Color _pageBg = Color(0xFFF8F9FA);
  static const Color _accentGreen = Color(0xFF2ECC71);
  static const Color _summaryRevenueStroke = Color(0xFF16A34A);
  static const Color _summaryExpenseStroke = Color(0xFFDC2626);

  bool get _mobileChrome => !widget.isBigScreen;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildFilterRow(),
        Expanded(
          child: ColoredBox(
            color: _mobileChrome ? _pageBg : Colors.transparent,
            child: RefreshIndicator(
              onRefresh: () async {
                ref.invalidate(
                  dashboardGaugeSnapshotProvider(transactionPeriod),
                );
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    _buildAnalyticsSection(ref),
                    AppIconsGrid(
                      isBigScreen: widget.isBigScreen,
                      onQuickAccessSeeAll: widget.onQuickAccessSeeAll,
                    ),
                    const SizedBox(height: 24),
                    _buildFooter(),
                    const SizedBox(height: 16),
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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
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
        child: Ink(
          decoration: BoxDecoration(
            color: selected ? Colors.black : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: selected ? Colors.black : const Color(0xFFE0E0E0),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Text(
              label,
              style: GoogleFonts.outfit(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: selected ? Colors.white : const Color(0xFF4A4A4A),
              ),
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
        child: Ink(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: selected ? _accentGreen : const Color(0xFFE0E0E0),
              width: selected ? 1.5 : 1,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Text(
              label,
              style: GoogleFonts.outfit(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: selected ? _accentGreen : const Color(0xFF4A4A4A),
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

  Widget _buildAnalyticsSection(WidgetRef ref) {
    final gaugeAsync = ref.watch(
      dashboardGaugeSnapshotProvider(transactionPeriod),
    );

    final presentation =
        _mobileChrome
            ? GaugePresentation.dashboardHome
            : GaugePresentation.standard;

    return gaugeAsync.when(
      data: (snapshot) {
        return Padding(
          padding: EdgeInsets.fromLTRB(_mobileChrome ? 16 : 0, 12, _mobileChrome ? 16 : 0, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SemiCircleGauge(
                dataOnGreenSide: snapshot.grossProfit,
                dataOnRedSide: snapshot.deductions,
                startPadding: 50.0,
                profitType: profitType,
                areValueColumnsVisible: true,
                presentation: presentation,
              ),
              if (_mobileChrome) ...[
                const SizedBox(height: 16),
                _buildRevenueExpenseRow(snapshot),
              ],
            ],
          ),
        );
      },
      error: (err, stack) {
        log('error: $err stack: $stack');
        return Padding(
          padding: EdgeInsets.fromLTRB(_mobileChrome ? 16 : 0, 12, _mobileChrome ? 16 : 0, 0),
          child: SemiCircleGauge(
            dataOnGreenSide: 0,
            dataOnRedSide: 0,
            startPadding: 0.0,
            profitType: profitType,
            areValueColumnsVisible: true,
            presentation: presentation,
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

  Widget _buildRevenueExpenseRow(DashboardGaugeSnapshot snapshot) {
    return Row(
      children: [
        Expanded(
          child: _summaryStatCard(
            icon: DashboardQuickAccessSvgs.revenueSummaryIcon(),
            iconBackground: const Color.fromRGBO(22, 163, 74, 0.10),
            label: 'REVENUE',
            valueText: '${formatNumber(snapshot.grossProfit)} RWF',
            valueColor: _summaryRevenueStroke,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _summaryStatCard(
            icon: DashboardQuickAccessSvgs.expensesSummaryIcon(),
            iconBackground: const Color.fromRGBO(220, 38, 38, 0.09),
            label: 'EXPENSES',
            valueText: '${formatNumber(snapshot.deductions)} RWF',
            valueColor: _summaryExpenseStroke,
          ),
        ),
      ],
    );
  }

  Widget _summaryStatCard({
    required Widget icon,
    required Color iconBackground,
    required String label,
    required String valueText,
    required Color valueColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
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
          Text(
            valueText,
            style: GoogleFonts.jetBrainsMono(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: valueColor,
              letterSpacing: -0.5,
            ),
          ),
        ],
      ),
    );
  }
}
