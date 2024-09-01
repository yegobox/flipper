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
import 'widgets/dropdown.dart';
import 'customappbar.dart';
import 'widgets/mini_app_icon.dart';
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
        customTrailingWidget: _buildProfileWidget(),
        customLeadingWidget: _buildDrawerButton(),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildFilterRow(),
            Padding(
              padding: const EdgeInsets.only(top: 40.0),
              child: _buildGauge(context, ref),
            ),
            _buildAppIconsGrid(),
            const SizedBox(height: 20),
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  StatelessWidget? _buildProfileWidget() {
    return const ProfileFutureWidget();
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ReusableDropdown(
            options: transactionPeriodOptions,
            selectedOption: transactionPeriod,
            onChanged: (String? newPeriod) {
              setState(() {
                transactionPeriod = newPeriod!;
              });
            },
          ),
          ReusableDropdown(
            options: profitTypeOptions,
            selectedOption: profitType,
            onChanged: (String? newProfitType) {
              setState(() {
                profitType = newProfitType!;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAppIconsGrid() {
    return GridView.count(
      crossAxisCount: 3,
      crossAxisSpacing: 8,
      mainAxisSpacing: 8,
      padding: const EdgeInsets.all(16),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        _buildCustomPaintWithIcon(
          iconData: FluentIcons.calculator_24_regular,
          color: const Color(0xff006AFE),
          page: "POS",
        ),
        _buildCustomPaintWithIcon(
          iconData: FluentIcons.book_48_regular,
          color: const Color(0xFF66AAFF),
          page: "Cashbook",
        ),
        _buildCustomPaintWithIcon(
          iconData: FluentIcons.arrow_swap_20_regular,
          color: const Color(0xFFFF0331),
          page: "Transactions",
        ),
        _buildCustomPaintWithIcon(
          iconData: FluentIcons.people_32_regular,
          color: Colors.cyan,
          page: "Contacts",
        ),
        _buildCustomPaintWithIcon(
          iconData: Icons.call,
          color: Colors.lightBlue,
          page: "Support",
        ),
        _buildCustomPaintWithIcon(
          iconData: FluentIcons.cart_24_regular,
          color: Colors.amber,
          page: "Orders",
        ),
      ],
    );
  }

  Widget _buildFooter() {
    return Column(
      children: [
        FutureBuilder<LPermission?>(
          future: ProxyService.realm
              .permission(userId: ProxyService.box.getUserId()!),
          builder: (context, snapshot) {
            return Text(
              snapshot.data?.name?.toUpperCase() ?? "-",
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.black.withOpacity(0.7),
                fontWeight: FontWeight.bold,
              ),
            );
          },
        ),
        const SizedBox(height: 8.0),
        Text(
          'FROM YEGOBOX',
          style: GoogleFonts.poppins(
            fontSize: 16,
            color: Colors.black.withOpacity(0.7),
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildCustomPaintWithIcon({
    required dynamic iconData,
    required Color color,
    required String page,
  }) {
    return GestureDetector(
      onTap: () async {
        HapticFeedback.lightImpact();
        await _navigateToPage(page);
      },
      child: MiniAppIcon(
        icon: iconData,
        color: color,
        page: page,
        showPageName: true,
      ),
    );
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
      case "Orders":
        await _routerService.navigateTo(OrdersRoute());
        break;
      default:
        await _routerService.navigateTo(CheckOutRoute(
          isBigScreen: widget.isBigScreen,
        ));
    }
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
          //maxDataValue: cashIn + cashOut,
          startPadding: 50.0,
          profitType: profitType,
          areValueColumnsVisible: true,
        );
      },
      error: (err, stack) {
        log('error: $err stack: $stack');
        return const Center(child: Text('An error occurred'));
      },
      loading: () {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  List<ITransaction> _filterTransactionsByPeriod(
      List<ITransaction> transactions, String period) {
    log(transactions.length.toString(), name: 'render transactions on gauge');
    DateTime startingDate = _calculateStartingDate(transactionPeriod);
    return transactions
        .where((transaction) =>
            DateTime.parse(transaction.createdAt!).isAfter(startingDate))
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
        .where((transaction) =>
            DateTime.parse(transaction.createdAt!).isAfter(oldDate))
        .toList();
    double sumCashIn = 0;
    for (final transaction in filteredTransactions) {
      if (transaction.isIncome) {
        sumCashIn += transaction.subTotal;
      }
    }
    return sumCashIn;
  }

  double _calculateCashOut(List<ITransaction> transactions, String period) {
    DateTime oldDate = _calculateStartingDate(transactionPeriod);
    List<ITransaction> filteredTransactions = transactions
        .where((transaction) =>
            DateTime.parse(transaction.createdAt!).isAfter(oldDate))
        .toList();
    double sumCashOut = 0;
    for (final transaction in filteredTransactions) {
      if (transaction.isExpense) {
        sumCashOut += transaction.subTotal;
      }
    }
    return sumCashOut;
  }
}
