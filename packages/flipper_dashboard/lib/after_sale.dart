import 'package:flipper_routing/app.locator.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:number_display/number_display.dart';
import 'package:stacked/stacked.dart';
import 'package:flipper_models/isar_models.dart';
import 'package:flipper_ui/flipper_ui.dart';
import 'customappbar.dart';
import 'package:stacked_services/stacked_services.dart';

class AfterSale extends StatefulWidget {
  const AfterSale(
      {Key? key,
      required this.totalOrderAmount,
      required this.order,
      this.receiptType = "ns"})
      : super(key: key);
  final double totalOrderAmount;
  final Order order;
  final String? receiptType;

  @override
  _AfterSaleState createState() => _AfterSaleState();
}

class _AfterSaleState extends State<AfterSale> {
  final display = createDisplay(
    length: 8,
    decimal: 0,
  );
  final _routerService = locator<RouterService>();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<BusinessHomeViewModel>.reactive(
        builder: (context, model, child) {
          return SafeArea(
            top: false,
            child: Scaffold(
              appBar: CustomAppBar(
                useTransparentButton: false,
                onPop: () {
                  model.currentOrder();
                  _routerService.clearStackAndShow(FlipperAppRoute());
                },
                closeButton: CLOSEBUTTON.BUTTON,
                disableButton: false,
                showActionButton: false,
                leftActionButtonName:
                    model.app.customer != null ? 'New Sale' : 'New Sale',
                multi: 3,
                bottomSpacer: 52,
              ),
              body: SizedBox(
                width: double.infinity,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Center(
                      child: Column(
                        children: [
                          const SizedBox(height: 40),
                          Text(
                            'FRw' +
                                display(model.keypad.cashReceived -
                                        widget.totalOrderAmount)
                                    .toString() +
                                ' Change',
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w400,
                                fontSize: 20,
                                color: Colors.black),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Out of FRw ' +
                                model.keypad.cashReceived.toStringAsFixed(0),
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w400,
                                fontSize: 18,
                                color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      bottom: 200,
                      right: 0,
                      left: 0,
                      child: StreamBuilder<Customer?>(
                          stream: ProxyService.isarApi.getCustomerByOrderId(
                              id: model.kOrder == null ? 0 : model.kOrder!.id!),
                          builder: (context, snapshot) {
                            return snapshot.data == null
                                ? Column(
                                    children: [
                                      Text('How would you like your receipt?',
                                          style: GoogleFonts.poppins(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 20,
                                              color: Colors.black)),
                                      const SizedBox(height: 10),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 18, right: 18),
                                        child: SizedBox(
                                          height: 50,
                                          width: double.infinity,
                                          child: OutlinedButton(
                                            child: Text('Email Receipt',
                                                style: GoogleFonts.poppins(
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 20,
                                                    color: Colors.white)),
                                            style: ButtonStyle(
                                              shape: MaterialStateProperty
                                                  .resolveWith<OutlinedBorder>(
                                                (states) =>
                                                    RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                ),
                                              ),
                                              backgroundColor:
                                                  MaterialStateProperty.all<
                                                          Color>(
                                                      const Color(0xff006AFE)),
                                              overlayColor:
                                                  MaterialStateProperty
                                                      .resolveWith<Color?>(
                                                (Set<MaterialState> states) {
                                                  if (states.contains(
                                                      MaterialState.hovered)) {
                                                    return Colors.blue
                                                        .withOpacity(0.04);
                                                  }
                                                  if (states.contains(
                                                          MaterialState
                                                              .focused) ||
                                                      states.contains(
                                                          MaterialState
                                                              .pressed)) {
                                                    return Colors.blue
                                                        .withOpacity(0.12);
                                                  }
                                                  return null; // Defer to the widget's default.
                                                },
                                              ),
                                            ),
                                            onPressed: () async {
                                              model.keyboardKeyPressed(
                                                  key:
                                                      'C'); // to clear the keyboard
                                              if (await ProxyService.isarApi
                                                  .isTaxEnabled()) {
                                                if (model.receiptReady) {
                                                  Business? business =
                                                      await ProxyService.isarApi
                                                          .getBusiness();
                                                  List<OrderItem> items =
                                                      await ProxyService.isarApi
                                                          .orderItems(
                                                    orderId: widget.order.id!,
                                                  );
                                                  model.printReceipt(
                                                      items: items,
                                                      business: business!,
                                                      oorder: widget.order,
                                                      receiptType:
                                                          widget.receiptType!);
                                                } else {
                                                  //show scaffold message
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    SnackBar(
                                                      backgroundColor:
                                                          Colors.green,
                                                      content: Text(
                                                        "We are generating receipt wait a few seconds and try again",
                                                        style:
                                                            GoogleFonts.poppins(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                fontSize: 20,
                                                                color: Colors
                                                                    .black),
                                                      ),
                                                    ),
                                                  );
                                                }
                                              }
                                            },
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 18, right: 18),
                                        child: SizedBox(
                                          height: 50,
                                          width: double.infinity,
                                          child: OutlinedButton(
                                            style: ButtonStyle(
                                              shape: MaterialStateProperty
                                                  .resolveWith<OutlinedBorder>(
                                                (states) =>
                                                    RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                ),
                                              ),
                                            ),
                                            child: Text('No Receipt',
                                                style: GoogleFonts.poppins(
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 20,
                                                    color: Color(0xff006AFE))),
                                            onPressed: () {
                                              // refresh orders
                                              model.keyboardKeyPressed(
                                                  key:
                                                      'C'); // to clear the keyboard
                                              model.currentOrder();
                                              _routerService.clearStackAndShow(
                                                  FlipperAppRoute());
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                : Column(
                                    // ignore: prefer_const_literals_to_create_immutables
                                    children: [
                                      const Text(
                                          'How would you like your receipt?'),
                                      const SizedBox(height: 10),
                                      ProxyService.remoteConfig
                                                  .isReceiptOnEmail() ||
                                              kDebugMode
                                          ? Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 18, right: 18),
                                              child: SizedBox(
                                                width: double.infinity,
                                                child: BoxButton.outline(
                                                  title: 'Email(' +
                                                      snapshot.data!.email +
                                                      ')',
                                                  onTap: () {
                                                    model.keyboardKeyPressed(
                                                        key:
                                                            'C'); // to clear the keyboard
                                                  },
                                                ),
                                              ),
                                            )
                                          : const SizedBox.shrink(),
                                      const SizedBox(height: 2),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 18, right: 18),
                                        child: SizedBox(
                                          width: double.infinity,
                                          child: BoxButton.outline(
                                            title: 'No Receipt',
                                            onTap: () {
                                              // refresh orders
                                              model.currentOrder();
                                              model.keyboardKeyPressed(
                                                  key:
                                                      'C'); // to clear the keyboard
                                              _routerService.clearStackAndShow(
                                                  FlipperAppRoute());
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                          }),
                    ),
                    Positioned(
                        bottom: 0,
                        child: Row(
                          children: [
                            IconButton(
                              icon: const FaIcon(FontAwesomeIcons.globe),
                              highlightColor: Color(0xff006AFE),
                              color: Color(0xff006AFE),
                              onPressed: null,
                            ),
                            Text(
                              'English',
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 10,
                                  color: Color(0xff006AFE)),
                            )
                          ],
                        ))
                  ],
                ),
              ),
            ),
          );
        },
        onViewModelReady: (model) async {
          model.getOrderById();
          // generate rra receipt
          if (await ProxyService.isarApi.isTaxEnabled()) {
            Business? business = await ProxyService.isarApi.getBusiness();
            List<OrderItem> items = await ProxyService.isarApi
                .orderItems(orderId: widget.order.id!);

            final bool isDone = await model.generateRRAReceipt(
                items: items,
                business: business!,
                order: widget.order,
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
                  oorder: widget.order,
                  receiptType: widget.receiptType!);
            }
          }
        },
        viewModelBuilder: () => BusinessHomeViewModel());
  }
}
