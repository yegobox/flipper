import 'dart:developer';

import 'package:flipper_models/view_models/cashbook_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'customappbar.dart';
import 'widgets/analytics_gauge/flipper_analytic.dart';
import 'package:flipper_models/isar_models.dart';
import 'package:flipper_services/proxy.dart';
import 'package:stacked/stacked.dart';
import 'keypad_view.dart';

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
      onViewModelReady: (model) async {
        widget.cashInAndOut = await model.getTransactionsAmountsSum();
      },
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
                  SizedBox(height: 80),
                  SemiCircleGauge(
                    dataOnGreenSide: widget.cashInAndOut.elementAt(0),
                    dataOnRedSide: widget.cashInAndOut.elementAt(1),
                    startPadding: 10,
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 400,
                      child: widget.newTransactionPressed == false
                          ? Column(
                              children: [
                                Text('Today',
                                    style: GoogleFonts.poppins(
                                        fontSize: 17,
                                        color: Colors.lightBlue,
                                        fontWeight: FontWeight.w600)),
                                SizedBox(height: 20),
                                TransactionList(context, model),
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
                                                  'cash_in';
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
                                                  'cash_out';
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
                                if (widget.newTransactionType == 'cash_in')
                                  Text('Cash In',
                                      style: GoogleFonts.poppins(
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold))
                                else if (widget.newTransactionType ==
                                    'cash_out')
                                  Text('Cash Out',
                                      style: GoogleFonts.poppins(
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold)),
                                SizedBox(height: 10),
                                KeyPadView(
                                  model: model,
                                  isBigScreen: widget.isBigScreen,
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

  Widget TransactionList(BuildContext context, HomeViewModel model) {
    return StreamBuilder<List<Transaction>>(
      initialData: null,
      stream: ProxyService.isar.getTransactions(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          log("waiting");
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          log(snapshot.error.toString());
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData) {
          log('No transactions');
          return Text('No transactions');
        } else {
          final transactions = snapshot.data!;
          if (transactions.length == 0) {
            return Center(
              child: Text('No records',
                  style: GoogleFonts.poppins(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                  )),
            );
          }
          log(transactions[0].toString());
          return ListView.builder(
            shrinkWrap: true,
            itemCount: transactions.length,
            itemBuilder: (context, index) {
              final transaction = transactions[index];
              return ListTile(
                leading: transaction.transactionType == 'cash_out'
                    ? Icon(Icons.remove)
                    : Icon(Icons.add), // Icon before the title
                title: Text(transaction.subTotal.toString() + ' RWF'),
                subtitle: Text(transaction.status.toString()),

                onTap: () {
                  null;
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => EditRecordPage(recordId: record.id),
                  //   ),
                  // );
                },
              );
            },
          );
        }
      },
    );
  }
}
