import 'package:flipper_models/view_models/cashbook_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'customappbar.dart';
import 'widgets/analytics_gauge/flipper_analytic.dart';
import 'package:flipper_models/isar_models.dart';
import 'package:flipper_services/proxy.dart';
import 'package:stacked/stacked.dart';

class Cashbook extends StatefulWidget {
  Cashbook({Key? key, this.hasBeenPressed = false}) : super(key: key);
  bool hasBeenPressed;
  @override
  _CashbookState createState() => _CashbookState();
}

class _CashbookState extends State<Cashbook> {
  List<int> transactionIds = [];
  int totalCashIn = 0;
  int totalCashOut = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CashbookViewModel>.reactive(
      fireOnViewModelReadyOnce: true,
      viewModelBuilder: () => CashbookViewModel(),
      onViewModelReady: (model) async {
        model.getTransactions();
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
                    dataOnGreenSide: 10000,
                    dataOnRedSide: 5000,
                    startPadding: 10,
                  ),
                  SizedBox(height: 20),
                  Text('Today',
                      style: GoogleFonts.poppins(
                          fontSize: 17,
                          color: Colors.lightBlue,
                          fontWeight: FontWeight.w600)),
                  SizedBox(height: 20),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 200,
                    child: TransactionList(context,model),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 75.0),
                        child: SizedBox(
                          height: 45,
                          width: 140,
                          child: OutlinedButton(
                            onPressed: null,
                            style: ButtonStyle(
                              side: MaterialStateProperty.all<BorderSide>(
                                const BorderSide(color: Colors.green),
                              ),
                              shape: MaterialStateProperty.resolveWith<
                                  OutlinedBorder>(
                                (states) => RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  const Color(0x008000)),
                              overlayColor:
                                  MaterialStateProperty.resolveWith<Color?>(
                                (Set<MaterialState> states) {
                                  if (states.contains(MaterialState.hovered)) {
                                    return Colors.green.withOpacity(0.04);
                                  }
                                  if (states.contains(MaterialState.focused) ||
                                      states.contains(MaterialState.pressed)) {
                                    return Colors.green.withOpacity(0.12);
                                  }
                                  return null; // Defer to the widget's default.
                                },
                              ),
                            ),
                            child: const Text('Cash In',
                                style: TextStyle(color: Colors.black)),
                          ),
                        ),
                      ),
                      SizedBox(width: 20),
                      Padding(
                        padding: const EdgeInsets.only(top: 75.0),
                        child: SizedBox(
                          height: 45,
                          width: 140,
                          child: OutlinedButton(
                            onPressed: null,
                            style: ButtonStyle(
                              side: MaterialStateProperty.all<BorderSide>(
                                const BorderSide(color: Colors.red),
                              ),
                              shape: MaterialStateProperty.resolveWith<
                                  OutlinedBorder>(
                                (states) => RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  const Color(0x800000)),
                              overlayColor:
                                  MaterialStateProperty.resolveWith<Color?>(
                                (Set<MaterialState> states) {
                                  if (states.contains(MaterialState.hovered)) {
                                    return Colors.red.withOpacity(0.04);
                                  }
                                  if (states.contains(MaterialState.focused) ||
                                      states.contains(MaterialState.pressed)) {
                                    return Colors.red.withOpacity(0.12);
                                  }
                                  return null; // Defer to the widget's default.
                                },
                              ),
                            ),
                            child: const Text('Cash Out',
                                style: TextStyle(color: Colors.black)),
                          ),
                        ),
                      ),
                    ],
                  )
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

  Widget TransactionList(BuildContext context, CashbookViewModel model) {
    return FutureBuilder<List<Transaction>>(
      initialData: null,
      future: ProxyService.isar.getTransactions(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData) {
          return Text('No transactions');
        } else {
          final transactions = snapshot.data!;

          return ListView.builder(
            itemCount: transactions.length,
            itemBuilder: (context, index) {
              final transaction = transactions[index];
              return ListTile(
                leading: 
                transaction.transactionType == 'in' ? Icon(Icons.add) : Icon(Icons.remove),// Icon before the title
                title: Text(transaction.cashReceived.toString()),
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
