import 'dart:developer';

import 'package:flipper_dashboard/create/category_selector.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
            closeButton: CLOSEBUTTON.WIDGET,
            customLeadingWidget: Container(
                child: Text(
              '  Cash Book',
              style: GoogleFonts.poppins(
                  fontSize: 17,
                  color: Colors.grey,
                  fontWeight: FontWeight.w600),
            )),
          ),
          body: Center(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Column(
                children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ReusableDropdown(
                          options: widget.transactionPeriodOptions,
                          selectedOption: widget.transactionPeriod,
                          onChanged: (String? newPeriod) {
                            setState(() {
                              widget.transactionPeriod = newPeriod!;
                            });
                          },
                        ),
                        SizedBox(width: 100),
                        ReusableDropdown(
                          options: widget.profitTypeOptions,
                          selectedOption: widget.profitType,
                          onChanged: (String? newProfitType) {
                            setState(() {
                              widget.profitType = newProfitType!;
                            });
                          },
                        ),
                      ]),
                  SizedBox(height: 80),
                  buildGaugeOrList(context, model, 'gauge'),
                  SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 400,
                      child: widget.newTransactionPressed == false
                          ? Column(
                              children: [
                                Text(widget.transactionPeriod,
                                    style: GoogleFonts.poppins(
                                        fontSize: 17,
                                        color: Colors.lightBlue,
                                        fontWeight: FontWeight.w600)),
                                SizedBox(height: 20),
                                Expanded(
                                  child:
                                      buildGaugeOrList(context, model, 'list'),
                                ),
                                SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 75.0),
                                      child: SizedBox(
                                        height: 45,
                                        width: 140,
                                        child: OutlinedButton(
                                          onPressed: () {
                                            setState(() {
                                              widget.newTransactionPressed =
                                                  true;
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
                                              (states) =>
                                                  RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                              ),
                                            ),
                                            backgroundColor:
                                                MaterialStateProperty.all<
                                                        Color>(
                                                    const Color(0x008000)),
                                            overlayColor: MaterialStateProperty
                                                .resolveWith<Color?>(
                                              (Set<MaterialState> states) {
                                                if (states.contains(
                                                    MaterialState.hovered)) {
                                                  return Colors.green
                                                      .withOpacity(0.04);
                                                }
                                                if (states.contains(
                                                        MaterialState
                                                            .focused) ||
                                                    states.contains(
                                                        MaterialState
                                                            .pressed)) {
                                                  return Colors.green
                                                      .withOpacity(0.12);
                                                }
                                                return null; // Defer to the widget's default.
                                              },
                                            ),
                                          ),
                                          child: const Text('Cash In',
                                              style: TextStyle(
                                                  color: Colors.black)),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 75.0),
                                      child: SizedBox(
                                        height: 45,
                                        width: 140,
                                        child: OutlinedButton(
                                          onPressed: () {
                                            setState(() {
                                              widget.newTransactionPressed =
                                                  true;
                                              widget.newTransactionType =
                                                  'Cash Out';
                                            });
                                          },
                                          style: ButtonStyle(
                                            side: MaterialStateProperty.all<
                                                BorderSide>(
                                              const BorderSide(
                                                  color: Colors.red),
                                            ),
                                            shape: MaterialStateProperty
                                                .resolveWith<OutlinedBorder>(
                                              (states) =>
                                                  RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                              ),
                                            ),
                                            backgroundColor:
                                                MaterialStateProperty.all<
                                                        Color>(
                                                    const Color(0x800000)),
                                            overlayColor: MaterialStateProperty
                                                .resolveWith<Color?>(
                                              (Set<MaterialState> states) {
                                                if (states.contains(
                                                    MaterialState.hovered)) {
                                                  return Colors.red
                                                      .withOpacity(0.04);
                                                }
                                                if (states.contains(
                                                        MaterialState
                                                            .focused) ||
                                                    states.contains(
                                                        MaterialState
                                                            .pressed)) {
                                                  return Colors.red
                                                      .withOpacity(0.12);
                                                }
                                                return null; // Defer to the widget's default.
                                              },
                                            ),
                                          ),
                                          child: const Text('Cash Out',
                                              style: TextStyle(
                                                  color: Colors.black)),
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    if (widget.newTransactionType == 'Cash In')
                                      Text('Record Cash In',
                                          style: GoogleFonts.poppins(
                                              fontSize: 17,
                                              fontWeight: FontWeight.bold))
                                    else if (widget.newTransactionType ==
                                        'Cash Out')
                                      Text('Record Cash Out',
                                          style: GoogleFonts.poppins(
                                              fontSize: 17,
                                              fontWeight: FontWeight.bold)),
                                    CategorySelector.transactionMode(
                                        categories: model.categories),
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
                            ))

                  //List of transactions will go here
                  //Then the add transaction buttons underneath
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget buildGaugeOrList(
      BuildContext context, HomeViewModel model, String widgetType) {
    return StreamBuilder<List<Transaction>>(
      initialData: null,
      stream: ProxyService.isar.getCompletedTransactions(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          log("waiting");
          if (widgetType == 'gauge') {
            return SemiCircleGauge(
              dataOnGreenSide: 0,
              dataOnRedSide: 0,
              startPadding: 10,
              profitType: widget.profitType,
            );
          } else {
            return CircularProgressIndicator();
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
            oldDate = DateTime(tempToday.year, tempToday.month, tempToday.day);
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
                startPadding: 10,
                profitType: widget.profitType,
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
                  return ListTile(
                    leading: transaction.transactionType == 'Cash Out'
                        ? Icon(Icons.remove)
                        : Icon(Icons.add), // Icon before the title
                    title: Text(transaction.subTotal.toString() + ' RWF'),
                    subtitle: Text(transaction.status.toString()),

                    onTap: () {
                      null;
                    },
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
    );
  }
}
