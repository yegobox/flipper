import 'dart:developer';

import 'package:flipper_routing/app.locator.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stacked_services/stacked_services.dart';
import 'widgets/mini_app_icon.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'customappbar.dart';
import 'widgets/analytics_gauge/flipper_analytic.dart';
import 'package:flipper_models/isar_models.dart';
import 'package:flipper_services/proxy.dart';
import 'package:stacked/stacked.dart';
import 'keypad_view.dart';
import 'widgets/dropdown.dart';

class Cashbook extends StatefulWidget {
  Cashbook(
      {Key? key,
      required this.isBigScreen,
      this.newTransactionPressed = false,
      this.newTransactionType = 'none'})
      : super(key: key);
  bool isBigScreen;
  bool newTransactionPressed;
  String newTransactionType;
  String transactionPeriod = "Today";
  List<String> transactionPeriodOptions = [
    "Today",
    "This Week",
    "This Month",
    "This Year"
  ];

  String profitType = "Net Profit";
  List<String> profitTypeOptions = ["Net Profit", "Gross Profit"];

  List<double> cashInAndOut = [1, 1];
  @override
  _CashbookState createState() => _CashbookState();
}

class _CashbookState extends State<Cashbook> {
  List<int> transactionIds = [];
  final _routerService = locator<RouterService>();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HomeViewModel>.reactive(
      fireOnViewModelReadyOnce: true,
      viewModelBuilder: () => HomeViewModel(),
      onViewModelReady: (model) async {},
      builder: (context, model, child) {
        return Scaffold(
          appBar: CustomAppBar(
            isDividerVisible: false,
            title: 'Cash Book',
            icon: Icons.close,
            onPop: () async {
              _routerService.back();
            },
          ),
          body: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Column(
              children: [
                ListTile(
                  contentPadding: EdgeInsets.only(left: 30, right: 0),
                  leading: ReusableDropdown(
                    options: widget.transactionPeriodOptions,
                    selectedOption: widget.transactionPeriod,
                    onChanged: (String? newPeriod) {
                      setState(() {
                        widget.transactionPeriod = newPeriod!;
                      });
                    },
                  ),
                  trailing: ReusableDropdown(
                    options: widget.profitTypeOptions,
                    selectedOption: widget.profitType,
                    onChanged: (String? newProfitType) {
                      setState(() {
                        widget.profitType = newProfitType!;
                      });
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 70.0),
                  child: buildGaugeOrList(context, model, 'gauge'),
                ),
                Expanded(
                    child: widget.newTransactionPressed == false
                        ? Column(
                            children: [
                              Text(widget.transactionPeriod,
                                  style: GoogleFonts.poppins(
                                      fontSize: 17,
                                      color: Colors.lightBlue,
                                      fontWeight: FontWeight.w600)),
                              SizedBox(height: 5),
                              Expanded(
                                child: buildGaugeOrList(context, model, 'list'),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 15.0),
                                    child: SizedBox(
                                      height: 41,
                                      width: 150,
                                      child: OutlinedButton(
                                        onPressed: () {
                                          setState(() {
                                            widget.newTransactionPressed = true;
                                            widget.newTransactionType =
                                                'Cash In';
                                          });
                                        },
                                        style: ButtonStyle(
                                          side: MaterialStateProperty.all<
                                              BorderSide>(
                                            const BorderSide(
                                                color: Colors.green),
                                          ),
                                          shape: MaterialStateProperty
                                              .resolveWith<OutlinedBorder>(
                                            (states) => RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                            ),
                                          ),
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  Colors.green),
                                          overlayColor: MaterialStateProperty
                                              .resolveWith<Color?>(
                                            (Set<MaterialState> states) {
                                              return Colors
                                                  .green; // Defer to the widget's default.
                                            },
                                          ),
                                        ),
                                        child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Icon(
                                                Icons.add,
                                                color: Colors.white,
                                              ),
                                              Spacer(),
                                              Text(
                                                'Cash In',
                                                style: GoogleFonts.poppins(
                                                  fontSize: 14,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ]),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 15.0),
                                    child: SizedBox(
                                      height: 41,
                                      width: 150,
                                      child: OutlinedButton(
                                        onPressed: () {
                                          setState(() {
                                            widget.newTransactionPressed = true;
                                            widget.newTransactionType =
                                                'Cash Out';
                                          });
                                        },
                                        style: ButtonStyle(
                                          side: MaterialStateProperty.all<
                                              BorderSide>(
                                            const BorderSide(
                                                color: Color(0xFFFF0331)),
                                          ),
                                          shape: MaterialStateProperty
                                              .resolveWith<OutlinedBorder>(
                                            (states) => RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                            ),
                                          ),
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  Color(0xFFFF0331)),
                                          overlayColor: MaterialStateProperty
                                              .resolveWith<Color?>(
                                            (Set<MaterialState> states) {
                                              return Color(
                                                  0xFFFF0331); // Defer to the widget's default.
                                            },
                                          ),
                                        ),
                                        child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Icon(
                                                Icons.remove,
                                                color: Colors.white,
                                              ),
                                              Spacer(),
                                              Text(
                                                'Cash Out',
                                                style: GoogleFonts.poppins(
                                                  fontSize: 14,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ]),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          )
                        : Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(width: 10),
                                  SvgPicture.asset(
                                    'assets/flipper_keypad_blue.svg',
                                    package: 'flipper_dashboard',
                                  ),
                                  if (widget.newTransactionType == 'Cash In')
                                    Text(' Cash In',
                                        style: GoogleFonts.poppins(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold))
                                  else if (widget.newTransactionType ==
                                      'Cash Out')
                                    Text(' Cash Out',
                                        style: GoogleFonts.poppins(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold)),
                                  Spacer(),
                                  IconButton(
                                    icon: Icon(Icons.close),
                                    onPressed: () {
                                      setState(() {
                                        widget.newTransactionPressed = false;
                                      });
                                    },
                                  )
                                ],
                              ),
                              KeyPadView.cashBookMode(
                                model: model,
                                isBigScreen: widget.isBigScreen,
                                transactionMode: true,
                                transactionType: widget.newTransactionType,
                              )
                            ],
                          )),
                SizedBox(height: 31),

                //List of transactions will go here
                //Then the add transaction buttons underneath
              ],
            ),
          ),
        );
      },
    );
  }

  Widget buildGaugeOrList(
      BuildContext context, HomeViewModel model, String widgetType) {
    return KeyedSubtree(
      key: UniqueKey(),
      child: StreamBuilder<List<Transaction>>(
        initialData: null,
        stream: ProxyService.isar.getCompletedTransactions(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            log("waiting");
            if (widgetType == 'gauge') {
              return SemiCircleGauge(
                dataOnGreenSide: 0,
                dataOnRedSide: 0,
                startPadding: 0,
                profitType: widget.profitType,
                areValueColumnsVisible: !widget.newTransactionPressed,
              );
            } else {
              return SizedBox.shrink();
            }
          } else if (snapshot.hasError) {
            log(snapshot.error.toString());
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData) {
            log('No transactions');
            return Text(
                'No records for ' + widget.transactionPeriod.toLowerCase());
          } else {
            final transactions = snapshot.data!;
            DateTime oldDate;
            DateTime temporaryDate;

            if (widget.transactionPeriod == 'Today') {
              DateTime tempToday = DateTime.now();
              oldDate =
                  DateTime(tempToday.year, tempToday.month, tempToday.day);
            } else if (widget.transactionPeriod == 'This Week') {
              oldDate = DateTime.now().subtract(Duration(days: 7));
              oldDate = DateTime(oldDate.year, oldDate.month, oldDate.day);
            } else if (widget.transactionPeriod == 'This Month') {
              oldDate = DateTime.now().subtract(Duration(days: 30));
              oldDate = DateTime(oldDate.year, oldDate.month, oldDate.day);
            } else {
              oldDate = DateTime.now().subtract(Duration(days: 365));
              oldDate = DateTime(oldDate.year, oldDate.month, oldDate.day);
            }

            List<Transaction> filteredTransactions = [];
            for (final transaction in transactions) {
              temporaryDate = DateTime.parse(transaction.createdAt);
              if (temporaryDate.isAfter(oldDate)) {
                filteredTransactions.add(transaction);
              }
            }

            switch (widgetType) {
              case 'gauge':
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
                  profitType: widget.profitType,
                  areValueColumnsVisible: !widget.newTransactionPressed,
                );

              case 'list':
                if (filteredTransactions.length == 0) {
                  return Center(
                    child: Text(
                        'No records for ' +
                            widget.transactionPeriod.toLowerCase(),
                        style: GoogleFonts.poppins(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                        )),
                  );
                }
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: filteredTransactions.length,
                  itemBuilder: (context, index) {
                    final transaction = filteredTransactions[index];
                    return Container(
                      height: 70,
                      child: ListTile(
                        leading: Container(
                          height: 75,
                          width: 55,
                          child: Center(
                            child: MiniAppIcon(
                              icon: 'assets/flipper_transaction_icon.svg',
                              color: transaction.transactionType != 'Cash Out'
                                  ? Color(0xFF4CAF50)
                                  : Color(0xFFFF0331),
                              page: transaction.transactionType != 'Cash Out'
                                  ? "Income"
                                  : "Expense",
                              showPageName: false,
                              sideSize: 55,
                            ),
                          ),
                        ), // Icon before the title
                        title: Text(
                            NumberFormat('#,###').format(double.parse(
                                    transaction.subTotal.toString())) +
                                " RWF",
                            style: GoogleFonts.poppins(
                                fontSize: 17, fontWeight: FontWeight.bold)),
                        subtitle: Text(
                            DateFormat('dd/MM/yyyy')
                                .format(DateTime.parse(transaction.createdAt)),
                            style: GoogleFonts.poppins(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey)),
                        trailing: Text(
                            DateFormat('HH:mm')
                                .format(DateTime.parse(transaction.createdAt)),
                            style: GoogleFonts.poppins(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey)),

                        onTap: () => _routerService.navigateTo(
                            TransactionDetailRoute(transaction: transaction)),
                      ),
                    );
                  },
                );
              default:
                return Center(
                  child: Text('Incorrect widget type',
                      style: GoogleFonts.poppins(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      )),
                );
            }
          }
        },
      ),
    );
  }
}
