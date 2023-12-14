// ignore_for_file: unused_result

import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stacked/stacked.dart';
import 'package:flipper_models/isar_models.dart';
import 'customappbar.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:intl/intl.dart';

class PaymentConfirmation extends StatefulHookConsumerWidget {
  const PaymentConfirmation(
      {Key? key,
      required this.totalTransactionAmount,
      required this.transaction,
      required this.paymentType,
      this.receiptType = "ns"})
      : super(key: key);
  final double totalTransactionAmount;
  final ITransaction transaction;
  final String? receiptType;
  final String paymentType;

  @override
  PaymentConfirmationState createState() => PaymentConfirmationState();
}

class PaymentConfirmationState extends ConsumerState<PaymentConfirmation> {
  final _routerService = locator<RouterService>();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final currentTransaction = ref.watch(pendingTransactionProvider);
    return ViewModelBuilder<CoreViewModel>.reactive(
        builder: (context, model, child) {
          return SafeArea(
            top: false,
            child: Scaffold(
              appBar: CustomAppBar(
                isDividerVisible: false,
                title: 'Payment: ${widget.paymentType}',
                icon: Icons.close,
                onPop: () async {
                  _routerService.clearStackAndShow(FlipperAppRoute());
                },
              ),
              body: SizedBox(
                width: double.infinity,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Center(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 200.0),
                            child: Icon(
                              Icons.check,
                              size: 44,
                              color: Color(0xFF4CAF50),
                            ),
                          ),
                          const SizedBox(height: 51),
                          Text(
                            'Done',
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w400,
                                fontSize: 20,
                                color: Colors.black),
                          ),
                          const SizedBox(height: 40),
                          Text(
                            'RWF ' +
                                NumberFormat('#,###')
                                    .format(model.keypad.cashReceived),
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w400,
                                fontSize: 18,
                                color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      bottom: 20,
                      right: 0,
                      left: 0,
                      child: StreamBuilder<Customer?>(
                        stream: model.getCustomer(
                            transactionId: currentTransaction.value!.value!.id),
                        builder: (context, snapshot) {
                          return Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 15.0),
                                    child: SizedBox(
                                      height: 60,
                                      width: 140,
                                      child: OutlinedButton(
                                        onPressed: () async {
                                          model.keyboardKeyPressed(key: 'C');
                                          if (await ProxyService.isar
                                              .isTaxEnabled()) {
                                            if (model.receiptReady) {
                                              Business? business =
                                                  await ProxyService.isar
                                                      .getBusiness();
                                              List<TransactionItem> items =
                                                  await ProxyService.isar
                                                      .transactionItems(
                                                doneWithTransaction: false,
                                                transactionId:
                                                    widget.transaction.id,
                                              );
                                              model.printReceipt(
                                                  items: items,
                                                  business: business!,
                                                  otransaction:
                                                      widget.transaction,
                                                  receiptType:
                                                      widget.receiptType!);
                                            } else {
                                              //show scaffold message
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  backgroundColor: Colors.green,
                                                  content: Text(
                                                    "We are generating receipt wait a few seconds and try again",
                                                    style: GoogleFonts.poppins(
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontSize: 20,
                                                        color: Colors.black),
                                                  ),
                                                ),
                                              );
                                            }
                                          }
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
                                                  Colors.white),
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
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                'Receipt',
                                                style: GoogleFonts.poppins(
                                                  fontSize: 14,
                                                  color: Colors.black,
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
                                      height: 60,
                                      width: 140,
                                      child: OutlinedButton(
                                        onPressed: () {},
                                        style: ButtonStyle(
                                          side: MaterialStateProperty.all<
                                              BorderSide>(
                                            const BorderSide(
                                                color: Color(0xFF4CAF50)),
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
                                                  Colors.white),
                                          overlayColor: MaterialStateProperty
                                              .resolveWith<Color?>(
                                            (Set<MaterialState> states) {
                                              return Color(
                                                  0xFF4CAF50); // Defer to the widget's default.
                                            },
                                          ),
                                        ),
                                        child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                'Add Note',
                                                style: GoogleFonts.poppins(
                                                  fontSize: 14,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ]),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 13,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('Powered By'),
                                  SizedBox(
                                    width: 30,
                                  ),
                                  SizedBox(
                                    height: 21,
                                    width: 21,
                                    child: Image.asset(
                                      "assets/logo.png",
                                      package: 'flipper_dashboard',
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(height: 10),
                              Padding(
                                padding: EdgeInsets.only(left: 19.0, right: 19),
                                child: SizedBox(
                                  height: 60,
                                  width: double.infinity,
                                  child: OutlinedButton(
                                    child: Text("Return to Home",
                                        style: const TextStyle(
                                            color: Colors.white)),
                                    style: primaryButtonStyle.copyWith(
                                        shape: MaterialStateProperty
                                            .resolveWith<OutlinedBorder>(
                                                (states) =>
                                                    RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(4)))),
                                    onPressed: () async {
                                      // refresh transactions
                                      model.keyboardKeyPressed(key: 'C');

                                      ref.refresh(transactionItemsProvider);
                                      _routerService
                                          .navigateTo(FlipperAppRoute());
                                    },
                                  ),
                                ),
                              )
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        onViewModelReady: (model) async {
          model.getTransactionById();
          // generate rra receipt
          if (await ProxyService.isar.isTaxEnabled()) {
            Business? business = await ProxyService.isar.getBusiness();
            List<TransactionItem> items = await ProxyService.isar
                .transactionItems(
                    transactionId: widget.transaction.id,
                    doneWithTransaction: false);

            final bool isDone = await model.generateRRAReceipt(
                items: items,
                business: business!,
                transaction: widget.transaction,
                receiptType: widget.receiptType,
                callback: (value) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    backgroundColor: Colors.red,
                    content: Text(value),
                  ));
                });

            ///when we don't want to wait for the user to press print button
            if (isDone) {
              model.printReceipt(
                  items: items,
                  business: business,
                  otransaction: widget.transaction,
                  receiptType: widget.receiptType!);
            }
          }
        },
        viewModelBuilder: () => CoreViewModel());
  }
}
