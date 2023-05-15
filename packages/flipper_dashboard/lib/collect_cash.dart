import 'package:flipper_models/isar_models.dart';
import 'package:flipper_dashboard/customappbar.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:flipper_routing/receipt_types.dart';
import 'package:flipper_ui/helpers/utils.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stacked/stacked.dart';
import 'package:pubnub/pubnub.dart' as nub;
import 'package:stacked_services/stacked_services.dart';

import 'rounded_loading_button.dart';

class CollectCashView extends StatefulWidget {
  const CollectCashView(
      {Key? key, required this.paymentType, required this.order})
      : super(key: key);
  final String paymentType;
  final Order order;

  @override
  State<CollectCashView> createState() => _CollectCashViewState();
}

class _CollectCashViewState extends State<CollectCashView> {
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();

  final _formKey = GlobalKey<FormState>();
  String message = '';
  final TextEditingController _phone = TextEditingController();
  final TextEditingController _cash = TextEditingController();
  final _routerService = locator<RouterService>();

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<BusinessHomeViewModel>.reactive(
        builder: (context, model, child) {
          return SafeArea(
            child: Scaffold(
              appBar: CustomAppBar(
                onPop: () {
                  _routerService.pop();
                },
                rightActionButtonName: "Save",
                showActionButton: true,
                icon: Icons.close,
                multi: 2,
                bottomSpacer: 40,
              ),
              body: SizedBox(
                width: double.infinity,
                child: Stack(
                  children: [
                    Positioned(
                      left: 0,
                      top: 0,
                      right: 0,
                      bottom: 0,
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            const SizedBox(height: 40),
                            widget.paymentType == 'spenn'
                                ? Padding(
                                    padding: const EdgeInsets.only(
                                        left: 18, right: 18),
                                    child: SizedBox(
                                      width: double.infinity,
                                      child: TextFormField(
                                        keyboardType: TextInputType.number,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge!
                                            .copyWith(color: Colors.black),
                                        controller: _phone,
                                        decoration: InputDecoration(
                                          hintText: 'Payer phone number',
                                          fillColor: Theme.of(context)
                                              .copyWith(
                                                  canvasColor: Colors.white)
                                              .canvasColor,
                                          filled: true,
                                          border: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: HexColor('#D0D7E3')),
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                : const SizedBox.shrink(),
                            const SizedBox(height: 10),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 18, right: 18),
                              child: SizedBox(
                                width: double.infinity,
                                child: TextFormField(
                                  keyboardType: TextInputType.number,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .copyWith(color: Colors.black),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter Cash Received';
                                    }
                                    double totalOrderAmount =
                                        model.totalPayable;
                                    if (double.parse(value) <
                                        totalOrderAmount) {
                                      return "Amount is less than amount payable";
                                    }
                                    return null;
                                  },
                                  controller: _cash,
                                  onFieldSubmitted: (value) {
                                    _cash.text = value;
                                  },
                                  onChanged: (String cash) {},
                                  decoration: InputDecoration(
                                    hintText: 'Cash Received',
                                    fillColor: Theme.of(context)
                                        .copyWith(canvasColor: Colors.white)
                                        .canvasColor,
                                    filled: true,
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: HexColor('#D0D7E3'),
                                      ),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  16.0, 8.0, 16.0, 8.0),
                              child: SizedBox(
                                width: double.infinity,
                                height: 50,
                                child: TextButton(
                                  child: Text('Tender',
                                      style: GoogleFonts.poppins(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black,
                                      )),
                                  style: ButtonStyle(
                                    shape: MaterialStateProperty.resolveWith<
                                        OutlinedBorder>(
                                      (states) => RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                    ),
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            const Color(0xffF2F2F2)),
                                    overlayColor: MaterialStateProperty
                                        .resolveWith<Color?>(
                                      (Set<MaterialState> states) {
                                        if (states
                                            .contains(MaterialState.hovered)) {
                                          return Colors.blue.withOpacity(0.04);
                                        }
                                        if (states.contains(
                                                MaterialState.focused) ||
                                            states.contains(
                                                MaterialState.pressed)) {
                                          return Colors.blue.withOpacity(0.12);
                                        }
                                        return null; // Defer to the widget's default.
                                      },
                                    ),
                                  ),
                                  onPressed: () async {
                                    model.keypad.setCashReceived(
                                        amount: double.parse(_cash.text));
                                    if (_formKey.currentState!.validate()) {
                                      if (widget.paymentType == 'spenn') {
                                        await model.collectSPENNPayment(
                                          phoneNumber: _phone.text,
                                          cashReceived:
                                              double.parse(_cash.text),
                                        );
                                      } else {
                                        await model.collectCashPayment();
                                        _btnController.success();
                                        String receiptType = "ns";
                                        if (ProxyService.box
                                            .isPoroformaMode()) {
                                          receiptType = ReceiptType.ps;
                                        }
                                        if (ProxyService.box.isTrainingMode()) {
                                          receiptType = ReceiptType.ts;
                                        }
                                        _routerService.navigateTo(
                                            AfterSaleRoute(
                                                totalOrderAmount:
                                                    model.totalPayable,
                                                receiptType: receiptType,
                                                order: model.kOrder!));
                                      }
                                    } else {
                                      _btnController.stop();
                                    }
                                  },
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        onViewModelReady: (model) {
          nub.PubNub pubnub = ProxyService.event.connect();
          ProxyService.box.write(key: 'orderId', value: model.kOrder!.id!);
          nub.Subscription subscription =
              pubnub.subscribe(channels: {"payment"});
          subscription.messages.listen((event) {
            Spenn payment = Spenn.fromJson(event.payload);
            if (payment.userId.toString() == ProxyService.box.getUserId()) {
              double totalOrderAmount = model.keypad.totalPayable;
              _btnController.success();

              _routerService.navigateTo(AfterSaleRoute(
                  totalOrderAmount: totalOrderAmount, order: model.kOrder!));
            }
          });
        },
        viewModelBuilder: () => BusinessHomeViewModel());
  }
}
