import 'dart:developer';

import 'package:flipper_dashboard/ProfileFutureWidget.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flutter/services.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flipper_models/realm_model_export.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flipper_services/proxy.dart';
import 'drawerB.dart';
import 'customappbar.dart';

import 'package:flipper_routing/app.locator.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:stacked_services/stacked_services.dart';
import 'widgets/analytics_gauge/flipper_analytic.dart';

class Apps extends StatefulHookConsumerWidget {
  final TextEditingController controller;
  final bool isBigScreen;
  final CoreViewModel model;

  const Apps({
    Key? key,
    required this.controller,
    required this.isBigScreen,
    required this.model,
  }) : super(key: key);

  @override
  _AppsState createState() => _AppsState();
}

class _AppsState extends ConsumerState<Apps> {
  final _routerService = locator<RouterService>();
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
        // elevation: 2,
      ),
      body: Container(
        color: Colors.grey[50],
        child: Column(
          spacing: 1,
          children: [
            _buildFilterRow(),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  // Refresh data
                  // ignore: unused_result
                  await ref.refresh(transactionsStreamProvider);
                },
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    children: [
                      _buildGauge(context, ref),
                      _buildAppIconsGrid(),
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

  Widget _buildAppIconsGrid() {
    final List<Map<String, dynamic>> apps = [
      {
        'icon': FluentIcons.calculator_24_regular,
        'color': const Color(0xff006AFE),
        'page': "POS",
        'label': "Point of Sale"
      },
      {
        'icon': FluentIcons.book_48_regular,
        'color': const Color(0xFF66AAFF),
        'page': "Cashbook",
        'label': "Cash Book"
      },
      {
        'icon': FluentIcons.arrow_swap_20_regular,
        'color': const Color(0xFFFF0331),
        'page': "Transactions",
        'label': "Transactions"
      },
      {
        'icon': FluentIcons.people_32_regular,
        'color': Colors.cyan,
        'page': "Contacts",
        'label': "Contacts"
      },
      {
        'icon':Icons.store_rounded,
        'color': Colors.green,
        'page': "Orders",
        'label': "Orders"
      },
      {
        'icon': Icons.call,
        'color': Colors.lightBlue,
        'page': "Support",
        'label': "Support"
      }
    ];

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: apps.length,
      itemBuilder: (context, index) {
        final app = apps[index];
        return Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () async {
              HapticFeedback.lightImpact();
              await _navigateToPage(app['page']);
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: app['color'].withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    app['icon'],
                    color: app['color'],
                    size: 28,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  app['label'],
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      },
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
    final transactionsData = ref.watch(transactionsStreamProvider);

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
      if (transaction.isIncome!) {
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
      if (transaction.isExpense!) {
        sumCashOut += transaction.subTotal!;
      }
    }
    return sumCashOut;
  }

  Future<void> _navigateToPage(String page) async {
    switch (page) {
      case "POS":
        await _routerService.navigateTo(CheckOutRoute(
          isBigScreen: widget.isBigScreen,
        ));
        break;
      case "Cashbook":
        await _routerService.navigateTo(CashbookRoute(
          isBigScreen: widget.isBigScreen,
        ));
        break;
      case "Settings":
        await _routerService.navigateTo(SettingPageRoute());
        break;
      case "Support":
        final Uri whatsappUri = Uri.parse('https://wa.me/250788360058');
        if (await canLaunchUrl(whatsappUri)) {
          await launchUrl(whatsappUri, mode: LaunchMode.externalApplication);
        } else {
          throw 'Could not launch $whatsappUri';
        }
        break;
      case "Connecta":
        ProxyService.box.writeString(key: 'defaultApp', value: "2");
        await _routerService.navigateTo(SocialHomeViewRoute());
        break;
      case "Transactions":
        await _routerService.navigateTo(TransactionsRoute());
        break;
      case "Contacts":
        await _routerService.navigateTo(CustomersRoute());
        break;
        //TODO: if a user is of type agent do not show this Order menu.
      case "Orders":
        await _routerService.navigateTo(InventoryRequestMobileViewRoute());
        break;
      default:
        await _routerService.navigateTo(CheckOutRoute(
          isBigScreen: widget.isBigScreen,
        ));
    }
  }
}
