import 'dart:developer';

import 'package:flipper_dashboard/widgets/app_icons_grid.dart';
import 'package:flipper_models/providers/transactions_provider.dart';
import 'package:flutter/material.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'widgets/analytics_gauge/flipper_analytic.dart';

class DashboardView extends StatefulHookConsumerWidget {
  final bool isBigScreen;
  final CoreViewModel model;

  const DashboardView({
    Key? key,
    required this.isBigScreen,
    required this.model,
  }) : super(key: key);

  @override
  _DashboardViewState createState() => _DashboardViewState();
}

class _DashboardViewState extends ConsumerState<DashboardView> {
  String transactionPeriod = "Today";
  final List<String> transactionPeriodOptions = [
    "Today",
    "This Week",
    "This Month",
    "This Year",
  ];

  String profitType = "Net Profit";
  final List<String> profitTypeOptions = ["Net Profit", "Gross Profit"];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildFilterRow(),
        Expanded(
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
                  _buildGauge(context, ref),
                  AppIconsGrid(isBigScreen: widget.isBigScreen),
                  const SizedBox(height: 24),
                  _buildFooter(),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFilterRow() {
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
                      color: isSelected ? Colors.green[800] : Colors.black87,
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

  Widget _buildFooter() {
    return Column(
      children: [
        Text(
          'FROM YEGOBOX',
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: Colors.black87,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.2,
          ),
        ),
      ],
    );
  }

  Widget _buildGauge(BuildContext context, WidgetRef ref) {
    final gaugeAsync = ref.watch(
      dashboardGaugeSnapshotProvider(transactionPeriod),
    );

    return gaugeAsync.when(
      data: (snapshot) {
        return SemiCircleGauge(
          dataOnGreenSide: snapshot.grossProfit,
          dataOnRedSide: snapshot.deductions,
          startPadding: 50.0,
          profitType: profitType,
          areValueColumnsVisible: true,
        );
      },
      error: (err, stack) {
        log('error: $err stack: $stack');
        return SemiCircleGauge(
          dataOnGreenSide: 0,
          dataOnRedSide: 0,
          startPadding: 0.0,
          profitType: profitType,
          areValueColumnsVisible: true,
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
}
