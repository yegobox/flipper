import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flutter/services.dart';
import 'package:flipper_dashboard/profile.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flipper_models/isar_models.dart';
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

  Apps({
    Key? key,
    required this.controller,
    required this.isBigScreen,
    required this.model,
  }) : super(key: key);
  final List<double> cashInAndOut = [1, 1];

  @override
  _AppsState createState() => _AppsState();
}

class _AppsState extends ConsumerState<Apps> {
  final _routerService = locator<RouterService>();
  String transactionPeriod = "Today";
  List<String> transactionPeriodOptions = [
    "Today",
    "This Week",
    "This Month",
    "This Year"
  ];

  String profitType = "Net Profit";
  List<String> profitTypeOptions = ["Net Profit", "Gross Profit"];
  Widget _buildCustomPaintWithIcon(
      {dynamic iconData, required Color color, required String page}) {
    return GestureDetector(
      onTap: () async {
        HapticFeedback.lightImpact();
        switch (page) {
          case "POS":
            _routerService.navigateTo(CheckOutRoute(
              isBigScreen: widget.isBigScreen,
            ));
            return;
          case "Cashbook":
            _routerService
                .navigateTo(CashbookRoute(isBigScreen: widget.isBigScreen));
            return;
          case "Settings":
            _routerService.navigateTo(SettingPageRoute());
            return;
          case "Support":
            final Uri whatsappUri = Uri.parse('https://wa.me/250788360058');
            if (await canLaunchUrl(whatsappUri)) {
              await launchUrl(whatsappUri,
                  mode: LaunchMode.externalApplication);
            } else {
              throw 'Could not launch $whatsappUri';
            }
            return;
          case "Connecta":
            ProxyService.box.writeString(key: 'defaultApp', value: "2");
            _routerService.navigateTo(SocialHomeViewRoute());
            return;
          case "Transactions":
            _routerService.navigateTo(TransactionsRoute());
            return;
          case "Contacts":
            _routerService.navigateTo(CustomersRoute());
            break;
          case "Orders":
            _routerService.navigateTo(OrdersRoute());
            break;
          default:
            _routerService.navigateTo(CheckOutRoute(
              isBigScreen: widget.isBigScreen,
            ));
        }
      },
      child: MiniAppIcon(
        icon: iconData,
        color: color,
        page: page,
        showPageName: true,
      ),
    );
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: MyDrawer(),
      appBar: CustomAppBar(
        isDividerVisible: false,
        bottomSpacer: 48.99,
        closeButton: CLOSEBUTTON.WIDGET,
        customTrailingWidget: Container(
          child: FutureBuilder<Branch?>(
            future: ProxyService.isar
                .activeBranch(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting ||
                  !snapshot.hasData) {
                return const SizedBox.shrink();
              }
              final data = snapshot.data;
              return Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child: SizedBox(
                  height: 40,
                  width: 40,
                  child: ProfileWidget(
                    branch: data!,
                    sessionActive: true,
                    size: 25,
                    showIcon: false,
                  ),
                ),
              );
            },
          ),
        ),
        customLeadingWidget: GestureDetector(
          onTap: () {
            // Open the drawer when the customLeadingWidget is tapped
            _scaffoldKey.currentState?.openDrawer();
          },
          child: Container(
            child: Padding(
              padding: const EdgeInsets.only(left: 12.0),
              child: Image.asset(
                'assets/logo.png',
                package: 'flipper_dashboard',
                width: 30,
                height: 30,
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.0),
              child: ListTile(
                leading: ReusableDropdown(
                  options: transactionPeriodOptions,
                  selectedOption: transactionPeriod,
                  onChanged: (String? newPeriod) {
                    setState(() {
                      transactionPeriod = newPeriod!;
                    });
                  },
                ),
                trailing: ReusableDropdown(
                  options: profitTypeOptions,
                  selectedOption: profitType,
                  onChanged: (String? newProfitType) {
                    setState(() {});
                  },
                ),
                dense: true,
              ),
            ),
            Wrap(
              alignment: WrapAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 85.0),
                  child: _buildGauge(context, ref),
                  // child: _buildGaugeOldImpl(context, widget.model),
                ),
                SizedBox(
                  height: 340,
                  width: 340,
                  child: GridView.count(
                    crossAxisCount: 3,
                    crossAxisSpacing: 0,
                    mainAxisSpacing: 1,
                    padding: EdgeInsets.zero,
                    children: [
                      _buildCustomPaintWithIcon(
                          iconData: "assets/flipper_keypad.svg",
                          color: const Color(0xff006AFE),
                          page: "POS"),
                      _buildCustomPaintWithIcon(
                          iconData: FluentIcons.calculator_24_regular,
                          color: Color(0xFF66AAFF),
                          page: "Cashbook"),
                      _buildCustomPaintWithIcon(
                          iconData: FluentIcons.arrow_swap_20_regular,
                          color: Color(0xFFFF0331),
                          page: "Transactions"),
                      _buildCustomPaintWithIcon(
                          iconData: FluentIcons.communication_20_regular,
                          color: Colors.cyan,
                          page: "Connecta"),
                      _buildCustomPaintWithIcon(
                          iconData: FluentIcons.settings_20_regular,
                          color: Color(0xFFCC0F03),
                          page: "Settings"),
                      _buildCustomPaintWithIcon(
                          iconData: FluentIcons.people_32_regular,
                          color: Colors.cyan,
                          page: "Contacts"),
                      _buildCustomPaintWithIcon(
                          iconData: Icons.call,
                          color: Colors.lightBlue,
                          page: "Support"),
                      _buildCustomPaintWithIcon(
                          iconData: FluentIcons.cart_24_regular,
                          color: Colors.amber,
                          page: "Orders"),
                    ],
                  ),
                ),
              ],
            ),
            Container(
              height: 200,
              child: Column(
                children: [
                  !kDebugMode
                      ? ProxyService.remoteConfig.bannerAd()
                      : SizedBox.shrink(),
                  Center(
                    child: Text(
                      'FROM YEGOBOX',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.black.withOpacity(0.3100000023841858),
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  double _calculateCashIn(
      List<ITransaction> transactions, String transactionPeriod) {
    DateTime oldDate = _calculateStartingDate(transactionPeriod);
    List<ITransaction> filteredTransactions = transactions
        .where((transaction) =>
            DateTime.parse(transaction.createdAt).isAfter(oldDate))
        .toList();
    double sumCashIn = 0;
    for (final transaction in filteredTransactions) {
      if (transaction.transactionType != 'Cash Out') {
        sumCashIn += transaction.subTotal;
      }
    }
    return sumCashIn;
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

  double _calculateCashOut(
      List<ITransaction> transactions, String transactionPeriod) {
    DateTime oldDate = _calculateStartingDate(transactionPeriod);
    List<ITransaction> filteredTransactions = transactions
        .where((transaction) =>
            DateTime.parse(transaction.createdAt).isAfter(oldDate))
        .toList();
    double sumCashOut = 0;
    for (final transaction in filteredTransactions) {
      if (transaction.transactionType == 'Cash Out') {
        sumCashOut += transaction.subTotal;
      }
    }
    return sumCashOut;
  }

  List<ITransaction> _filterTransactionsByPeriod(
      List<ITransaction> transactions, String transactionPeriod) {
    log(transactions.length.toString(), name: 'render transactions on gauge');
    DateTime startingDate = _calculateStartingDate(transactionPeriod);
    return transactions
        .where((transaction) =>
            DateTime.parse(transaction.createdAt).isAfter(startingDate))
        .toList();
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
          startPadding: 0,
          profitType: profitType,
        );
      },
      error: (error, stackTrace) {
        return Text(error.toString());
      },
      loading: () {
        return SemiCircleGauge(
          dataOnGreenSide: 0,
          dataOnRedSide: 0,
          startPadding: 0,
          profitType: profitType,
        );
      },
    );
  }

  Widget _buildGaugeOldImpl(BuildContext context, CoreViewModel model) {
    return StreamBuilder<List<ITransaction>>(
      initialData: null,
      stream: model.getTransactions(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return SemiCircleGauge(
            dataOnGreenSide: 0,
            dataOnRedSide: 0,
            startPadding: 0,
            profitType: profitType,
          );
        } else {
          final transactions = snapshot.data!;
          DateTime oldDate;
          DateTime temporaryDate;

          if (transactionPeriod == 'Today') {
            oldDate = DateTime.now();
            oldDate = DateTime(oldDate.year, oldDate.month, oldDate.day);
          } else if (transactionPeriod == 'This Week') {
            oldDate = DateTime.now().subtract(Duration(days: 7));
            oldDate = DateTime(oldDate.year, oldDate.month, oldDate.day);
          } else if (transactionPeriod == 'This Month') {
            oldDate = DateTime.now().subtract(Duration(days: 30));
            oldDate = DateTime(oldDate.year, oldDate.month, oldDate.day);
          } else {
            oldDate = DateTime.now().subtract(Duration(days: 365));
            oldDate = DateTime(oldDate.year, oldDate.month, oldDate.day);
          }

          List<ITransaction> filteredTransactions = [];
          for (final transaction in transactions) {
            temporaryDate = DateTime.parse(transaction.createdAt);
            if (temporaryDate.isAfter(oldDate)) {
              filteredTransactions.add(transaction);
            }
          }

          double sum_cash_in = 0;
          double sum_cash_out = 0;
          for (final transaction in filteredTransactions) {
            if (transaction.transactionType == 'Cash Out') {
              sum_cash_out = transaction.subTotal + sum_cash_out;
            } else {
              sum_cash_in = transaction.subTotal + sum_cash_in;
            }
          }
          return SemiCircleGauge(
            dataOnGreenSide: sum_cash_in,
            dataOnRedSide: sum_cash_out,
            startPadding: 0,
            profitType: profitType,
          );
        }
      },
    );
  }

  Widget PeriodDropDown() {
    return DropdownButton<String>(
      value: transactionPeriod,
      items: transactionPeriodOptions
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(
            value,
          ),
        );
      }).toList(),
      onChanged: (String? newPeriod) {
        setState(() {
          transactionPeriod = newPeriod!;
        });
      },
    );
  }
}
