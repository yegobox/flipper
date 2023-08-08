import 'package:flipper_models/isar_models.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:flipper_routing/receipt_types.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stacked/stacked.dart';
import 'customappbar.dart';
import 'widgets/transaction_status_widget.dart';
import 'package:intl/intl.dart';

class TransactionDetail extends StatefulWidget {
  const TransactionDetail({Key? key, required this.transaction})
      : super(key: key);
  final Transaction transaction;
  @override
  State<TransactionDetail> createState() => _TransactionDetailState();
}

class _TransactionDetailState extends State<TransactionDetail> {
  bool transactionItemListIsExpanded = false;
  bool transactionStatusWidgetIsExpanded = false;
  bool moreActionsIsPressed = false;
  String status = "pending";
  Widget _list(
      {required List<TransactionItem> items, required HomeViewModel model}) {
    double total = 0;
    for (TransactionItem item in items) {
      total = (item.price * item.qty) + total;
    }
    return Column(
      children: [
        ListTile(
          title: Text('Product: ' + items.length.toString()),
          trailing: Icon(Icons.arrow_drop_down),
          onTap: () {
            setState(() {
              transactionItemListIsExpanded = !transactionItemListIsExpanded;
            });
          },
        ),
        if (transactionItemListIsExpanded)
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      title: Text(
                          items[index].qty.toInt().toString() +
                              " x " +
                              items[index].name,
                          style: GoogleFonts.poppins(
                              fontSize: 14, color: Colors.grey.shade600)),
                      trailing: Text(
                        NumberFormat('#,###').format(double.parse(
                                (items[index].qty * items[index].price)
                                    .toString())) +
                            " RWF",
                        style: GoogleFonts.poppins(
                            fontSize: 14, color: Colors.grey.shade600),
                      ),
                    );
                  },
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                ),
                ListTile(
                  title: Text("Total",
                      style: GoogleFonts.poppins(
                          fontSize: 14, color: Colors.black)),
                  trailing: Text(
                      NumberFormat('#,###')
                              .format(double.parse(total.toString())) +
                          " RWF",
                      style: GoogleFonts.poppins(
                          fontSize: 14, color: Colors.black)),
                )
              ],
            ),
          ),
      ],
    );
  }

  Widget transactionStatusHeader() {
    String status = widget.transaction.status.substring(0, 1).toUpperCase() +
        widget.transaction.status.substring(1);
    Color statusColor;
    if (status == "Pending") {
      statusColor = Colors.orange;
    } else if (status == "Parked") {
      statusColor = Colors.blue;
    } else {
      statusColor = Colors.lightGreen;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [
          Container(
            width: 25,
            height: 25,
            decoration:
                BoxDecoration(shape: BoxShape.circle, color: statusColor),
          ),
          SizedBox(
            width: 10,
          ),
          Text(
            status,
            style: GoogleFonts.poppins(
              fontSize: 20,
              color: Colors.black,
            ),
          ),
        ]),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
                NumberFormat('#,###').format(
                        double.parse(widget.transaction.subTotal.toString())) +
                    " RWF",
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold, fontSize: 20)),
          ],
        ),
      ],
    );
  }

  Widget _statusWidget() {
    List<TransactionStatus> statuses = [];
    TransactionStatus initialPending = TransactionStatus(
        status: "PENDING",
        dateTime: DateTime.parse(widget.transaction.createdAt));
    statuses.insert(0, initialPending);

    String currentStatus = widget.transaction.status;

    if (currentStatus != "pending") {
      TransactionStatus current = TransactionStatus(
          status: currentStatus.toUpperCase() +
              ": " +
              widget.transaction.paymentType.toUpperCase(),
          dateTime: DateTime.parse(widget.transaction.updatedAt!));
      statuses.insert(0, current);
    }
    return Column(
      children: [
        ListTile(
          title: Text('Details'),
          trailing: Icon(Icons.arrow_drop_down),
          onTap: () {
            setState(() {
              transactionStatusWidgetIsExpanded =
                  !transactionStatusWidgetIsExpanded;
            });
          },
        ),
        if (transactionStatusWidgetIsExpanded)
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: TransactionStatusWidget(statuses: statuses),
          ),
      ],
    );
  }

  final _routerService = locator<RouterService>();
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HomeViewModel>.reactive(
        viewModelBuilder: () => HomeViewModel(),
        onViewModelReady: (model) async {
          List<TransactionItem> items = await ProxyService.isar
              .transactionItems(
                  transactionId: widget.transaction.id,
                  doneWithTransaction: true);

          model.completedTransactionItemsList = items;
        },
        builder: (context, model, child) {
          String transactionType;
          if (widget.transaction.transactionType == 'Cash Out') {
            transactionType = 'Expense';
          } else {
            transactionType = 'Income';
          }
          return Scaffold(
            appBar: CustomAppBar(
              isDividerVisible: false,
              title: ' ' +
                  transactionType +
                  ' : ' +
                  NumberFormat('#,###').format(
                      double.parse(widget.transaction.subTotal.toString())) +
                  " RWF",
              icon: Icons.close,
              onPop: () async {
                _routerService.back();
              },
            ),
            body: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: transactionStatusHeader(),
                ),
                _list(items: model.completedTransactionItemsList, model: model),
                _statusWidget(),
                Spacer(),
                Padding(
                  padding: const EdgeInsets.only(bottom: 31.0, left: 16.0),
                  child: !moreActionsIsPressed
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                              SizedBox(
                                height: 45,
                                width: 160,
                                child: OutlinedButton(
                                  onPressed: () {
                                    setState(() {
                                      moreActionsIsPressed =
                                          !moreActionsIsPressed;
                                    });
                                  },
                                  style: ButtonStyle(
                                    side: MaterialStateProperty.all<BorderSide>(
                                      const BorderSide(
                                          color: Color(0xFF000000)),
                                    ),
                                    shape: MaterialStateProperty.resolveWith<
                                        OutlinedBorder>(
                                      (states) => RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                    ),
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Color(0xFFFFFFFF)),
                                    overlayColor: MaterialStateProperty
                                        .resolveWith<Color?>(
                                      (Set<MaterialState> states) {
                                        return Color(
                                            0xFFFFFFFF); // Defer to the widget's default.
                                      },
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text('More Actions',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 14)),
                                      Icon(
                                        Icons.arrow_drop_up,
                                        size: 20,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 45,
                                width: 160,
                                child: OutlinedButton(
                                  onPressed: () {
                                    _routerService.navigateTo(
                                        PaymentConfirmationRoute(
                                            totalTransactionAmount:
                                                widget.transaction.subTotal,
                                            receiptType: ReceiptType.cs,
                                            paymentType:
                                                widget.transaction.paymentType,
                                            transaction: widget.transaction));
                                  },
                                  style: ButtonStyle(
                                    side: MaterialStateProperty.all<BorderSide>(
                                      const BorderSide(
                                          color: Color(0xFF66AAFF)),
                                    ),
                                    shape: MaterialStateProperty.resolveWith<
                                        OutlinedBorder>(
                                      (states) => RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                    ),
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Color(0xFF66AAFF)),
                                    overlayColor: MaterialStateProperty
                                        .resolveWith<Color?>(
                                      (Set<MaterialState> states) {
                                        return Color(
                                            0xFF66AAFF); // Defer to the widget's default.
                                      },
                                    ),
                                  ),
                                  child: const Text('Invoice',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 15)),
                                ),
                              )
                            ])
                      : Container(
                          child: Column(children: [
                            GestureDetector(
                              onTap: null,
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Icon(Icons.edit_note),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text("Edit Note",
                                        style:
                                            GoogleFonts.poppins(fontSize: 20))
                                  ]),
                            ),
                            SizedBox(height: 25),
                            GestureDetector(
                              onTap: null,
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 25,
                                      height: 25,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.greenAccent),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text("Approve Transaction",
                                        style:
                                            GoogleFonts.poppins(fontSize: 20))
                                  ]),
                            ),
                            SizedBox(height: 25),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  moreActionsIsPressed = !moreActionsIsPressed;
                                });
                              },
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Icon(
                                      Icons.cancel_outlined,
                                      color: Colors.red,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text("Cancel",
                                        style:
                                            GoogleFonts.poppins(fontSize: 20))
                                  ]),
                            )
                          ]),
                        ),
                )
              ],
            ),
          );
        });
  }

  Future<void> refund(String id, HomeViewModel model) async {
    ProxyService.isar.refund(itemId: id);
    List<TransactionItem> items = await ProxyService.isar.transactionItems(
        transactionId: widget.transaction.id, doneWithTransaction: false);

    model.completedTransactionItemsList = items;
  }
}
