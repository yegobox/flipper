import 'package:flipper_models/isar_models.dart';
import 'package:flipper_routing/routes.logger.dart';
import 'package:flipper_dashboard/customappbar.dart';
import 'package:flipper_rw/helpers/utils.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:pubnub/pubnub.dart' as nub;
import 'package:flipper_routing/routes.router.dart';
import 'package:go_router/go_router.dart';

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

  final log = getLogger('CollectCashView');

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<BusinessHomeViewModel>.reactive(
        builder: (context, model, child) {
          return SafeArea(
            child: Scaffold(
              appBar: CustomAppBar(
                onPop: () {
                  GoRouter.of(context).pop();
                },
                title: '',
                icon: Icons.close,
                multi: 3,
                bottomSpacer: 52,
              ),
              body: SizedBox(
                width: double.infinity,
                child: Stack(
                  children: [
                    Center(
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
                                            .bodyText1!
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
                                      .bodyText1!
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
                            RoundedLoadingButton(
                              borderRadius: 4.0,
                              controller: _btnController,
                              color: Theme.of(context).primaryColor,
                              onPressed: () async {
                                double totalOrderAmount = model.totalPayable;

                                if (_formKey.currentState!.validate()) {
                                  model.keypad.setCashReceived(
                                    amount: double.parse(_cash.text),
                                  );
                                  if (widget.paymentType == 'spenn') {
                                    await model.collectSPENNPayment(
                                      phoneNumber: _phone.text,
                                      cashReceived: model.keypad.cashReceived,
                                    );
                                  } else {
                                    model.collectCashPayment(
                                      cashReceived: model.keypad.cashReceived,
                                    );
                                    String receiptType = ReceiptType.ns;
                                    if (ProxyService.box.isPoroformaMode()) {
                                      receiptType = ReceiptType.ps;
                                    }
                                    if (ProxyService.box.isTrainingMode()) {
                                      receiptType = ReceiptType.ts;
                                    }
                                    _btnController.success();
                                    GoRouter.of(context).push(
                                        Routes.afterSale +
                                            "/$totalOrderAmount/$receiptType",
                                        extra: widget.order);
                                  }
                                } else {
                                  _btnController.stop();
                                }
                              },
                              child: const Text(
                                'Tender',
                                style: TextStyle(
                                  color: Colors.white,
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
        onModelReady: (model) {
          nub.PubNub pubnub = ProxyService.event.connect();
          ProxyService.box.write(key: 'orderId', value: model.kOrder!.id);
          nub.Subscription subscription =
              pubnub.subscribe(channels: {"payment"});
          subscription.messages.listen((event) {
            Spenn payment = Spenn.fromJson(event.payload);
            if (payment.userId.toString() == ProxyService.box.getUserId()) {
              // double totalOrderAmount = model.kOrder!.orderItems
              //     .fold(0, (a, b) => a + (b.price * b.qty));
              double totalOrderAmount = model.keypad.totalPayable;
              _btnController.success();
              GoRouter.of(context).push(
                Routes.afterSale + "/$totalOrderAmount",
              );
            }
          });
        },
        viewModelBuilder: () => BusinessHomeViewModel());
  }
}
