import 'dart:developer';

import 'package:flipper_dashboard/ProfileFutureWidget.dart';
import 'package:flipper_dashboard/widgets/app_icons_grid.dart';
import 'package:flipper_models/providers/transactions_provider.dart';
import 'package:flutter/material.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'drawerB.dart';
import 'customappbar.dart';

import 'widgets/analytics_gauge/flipper_analytic.dart';

class MobileView extends StatefulHookConsumerWidget {
  final TextEditingController controller;
  final bool isBigScreen;
  final CoreViewModel model;

  const MobileView({
    Key? key,
    required this.controller,
    required this.isBigScreen,
    required this.model,
  }) : super(key: key);

  @override
  _MobileViewState createState() => _MobileViewState();
}

class _MobileViewState extends ConsumerState<MobileView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String transactionPeriod = "Today";
  final List<String> transactionPeriodOptions = [
    "Today",
    "This Week",
    "This Month",
    "This Year"
  ];

  String profitType = "Net Profit";
  final List<String> profitTypeOptions = ["Net Profit", "Gross Profit"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: MyDrawer(),
      appBar: CustomAppBar(
        isDividerVisible: false,
        bottomSpacer: 48.99,
        closeButton: CLOSEBUTTON.WIDGET,
        customTrailingWidget: ProfileFutureWidget(),
        customLeadingWidget: _buildDrawerButton(),
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          spacing: 1,
          children: [
            _buildFilterRow(),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  // Refresh the dashboard transactions provider
                  ref.invalidate(dashboardTransactionsProvider);
                },
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    children: [
                      _buildGauge(context, ref),
                      AppIconsGrid(
                        isBigScreen: widget.isBigScreen,
                      ),
                      const SizedBox(height: 24),
                      _buildFooter(),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  StatelessWidget? _buildDrawerButton() {
    return GestureDetector(
      onTap: () => _scaffoldKey.currentState?.openDrawer(),
      child: Padding(
        padding: const EdgeInsets.only(left: 12.0),
        child: Image.asset(
          'assets/logo.png',
          package: 'flipper_dashboard',
          width: 30,
          height: 30,
        ),
      ),
    );
  }

  Widget _buildFilterRow() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(1),
            offset: const Offset(0, 2),
            blurRadius: 4,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //  spacing:1,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(8),
              ),
              child: DropdownButtonHideUnderline(
                child: ButtonTheme(
                  alignedDropdown: true,
                  child: DropdownButton<String>(
                    value: transactionPeriod,
                    items: transactionPeriodOptions.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        setState(() => transactionPeriod = newValue);
                      }
                    },
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(8),
              ),
              child: DropdownButtonHideUnderline(
                child: ButtonTheme(
                  alignedDropdown: true,
                  child: DropdownButton<String>(
                    value: profitType,
                    items: profitTypeOptions.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        setState(() => profitType = newValue);
                      }
                    },
                  ),
                ),
              ),
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
    // Use the dedicated dashboard transactions provider
    final transactionsData = ref.watch(dashboardTransactionsProvider);

    return transactionsData.when(
      data: (value) {
        final filteredTransactions =
            _filterTransactionsByPeriod(value, transactionPeriod);
        final cashIn =
            _calculateCashIn(filteredTransactions, transactionPeriod);
        final cashOut =
            _calculateCashOut(filteredTransactions, transactionPeriod);

        return SemiCircleGauge(
          dataOnGreenSide: cashIn,
          dataOnRedSide: cashOut,
          startPadding: 50.0,
          profitType: profitType,
          areValueColumnsVisible: true,
        );
      },
      error: (err, stack) {
        log('error: $err stack: $stack');
        return const Center(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'An error occurred while loading data',
              style: TextStyle(color: Colors.red),
            ),
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

  // Keep existing helper methods unchanged
  List<ITransaction> _filterTransactionsByPeriod(
      List<ITransaction> transactions, String period) {
    log(transactions.length.toString(), name: 'render transactions on gauge');
    DateTime startingDate = _calculateStartingDate(transactionPeriod);
    return transactions
        .where((transaction) =>
            transaction.createdAt!.isAfter(startingDate) ||
            transaction.createdAt!.isAtSameMomentAs(startingDate))
        .toList();
  }

  DateTime _calculateStartingDate(String transactionPeriod) {
    DateTime now = DateTime.now();
    if (transactionPeriod == 'Today') {
      return DateTime(now.year, now.month, now.day);
    } else if (transactionPeriod == 'This Week') {
      return DateTime(now.year, now.month, now.day - 7).subtract(
          Duration(hours: now.hour, minutes: now.minute, seconds: now.second));
    } else if (transactionPeriod == 'This Month') {
      return DateTime(now.year, now.month - 1, now.day).subtract(
          Duration(hours: now.hour, minutes: now.minute, seconds: now.second));
    } else {
      return DateTime(now.year - 1, now.month, now.day).subtract(
          Duration(hours: now.hour, minutes: now.minute, seconds: now.second));
    }
  }

  double _calculateCashIn(List<ITransaction> transactions, String period) {
    DateTime oldDate = _calculateStartingDate(transactionPeriod);
    List<ITransaction> filteredTransactions = transactions
        .where((transaction) => transaction.createdAt!.isAfter(oldDate))
        .toList();
    double sumCashIn = 0;
    for (final transaction in filteredTransactions) {
      if (transaction.isIncome != null && transaction.isIncome!) {
        sumCashIn += transaction.subTotal!;
      }
    }
    return sumCashIn;
  }

  double _calculateCashOut(List<ITransaction> transactions, String period) {
    DateTime oldDate = _calculateStartingDate(transactionPeriod);
    List<ITransaction> filteredTransactions = transactions
        .where((transaction) => transaction.createdAt!.isAfter(oldDate))
        .toList();
    double sumCashOut = 0;
    for (final transaction in filteredTransactions) {
      if (transaction.isExpense != null && transaction.isExpense!) {
        sumCashOut += transaction.subTotal!;
      }
    }
    return sumCashOut;
  }
}
