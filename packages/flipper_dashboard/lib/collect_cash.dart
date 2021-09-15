import 'dart:async';
import 'dart:convert';

import 'package:flipper_routing/routes.logger.dart';
import 'package:flipper_dashboard/customappbar.dart';
import 'package:flipper_dashboard/payable_view.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:flipper_models/view_models/business_home_viewmodel.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';
import 'package:flipper_routing/routes.router.dart';

final socketUrl = 'https://apihub.yegobox.com/ws-message';

class CollectCashView extends StatefulWidget {
  CollectCashView({Key? key, required this.paymentType}) : super(key: key);
  final String paymentType;

  @override
  State<CollectCashView> createState() => _CollectCashViewState();
}

class _CollectCashViewState extends State<CollectCashView> {
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();

  final _formKey = GlobalKey<FormState>();
  String message = '';
  TextEditingController phoneController = TextEditingController();
  TextEditingController cashReceivedController = TextEditingController();
  StreamController<String> streamController =
      StreamController<String>.broadcast();
  late StreamSubscription<String> subscription;
  final log = getLogger('CollectCashView');
  StompClient? stompClient;
  void onConnect(StompFrame frame) {
    stompClient?.subscribe(
        destination: '/topic/payment',
        callback: (StompFrame frame) {
          if (frame.body != null) {
            Map<String, dynamic> result = json.decode(frame.body!);
            log.i(result);
            log.i(result['userId']);
            streamController.add(result['userId']);
          }
        });
  }

  @override
  void initState() {
    super.initState();

    if (stompClient == null) {
      stompClient = StompClient(
          config: StompConfig.SockJS(
        url: socketUrl,
        onConnect: onConnect,
        onWebSocketError: (dynamic error) => print(error.toString()),
      ));

      stompClient?.activate();
    }
  }

  @override
  void dispose() {
    if (stompClient != null) {
      stompClient?.deactivate();
    }
    subscription.cancel(); //unsubscribe from stream
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
                  ProxyService.nav.back();
                },
                title: '',
                icon: Icons.close,
                multi: 3,
                bottomSpacer: 52,
              ),
              body: Container(
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
                                    child: Container(
                                      width: double.infinity,
                                      child: TextFormField(
                                        keyboardType: TextInputType.number,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1!
                                            .copyWith(color: Colors.black),
                                        controller: phoneController,
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
                              child: Container(
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
                                    double totalOrderAmount = model
                                        .kOrder!.orderItems
                                        .fold(0, (a, b) => a + b.price);
                                    if (double.parse(value) <
                                        totalOrderAmount) {
                                      return "Amount is less than amount payable";
                                    }
                                    return null;
                                  },
                                  controller: cashReceivedController,
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
                              borderRadius: 20.0,
                              controller: _btnController,
                              onPressed: () async {
                                double totalOrderAmount = model
                                    .kOrder!.orderItems
                                    .fold(0, (a, b) => a + b.price);

                                if (_formKey.currentState!.validate()) {
                                  model.keypad.setCashReceived(
                                      amount: double.parse(
                                          cashReceivedController.text));
                                  if (widget.paymentType == 'spenn') {
                                    await model.collectSPENNPayment(
                                        phoneNumber: phoneController.text,
                                        payableAmount: totalOrderAmount);
                                  } else {
                                    model.collectCashPayment(
                                        payableAmount: totalOrderAmount);
                                    _btnController.success();

                                    ProxyService.nav.navigateTo(
                                      Routes.afterSale,
                                      arguments: AfterSaleArguments(
                                        totalOrderAmount: totalOrderAmount,
                                      ),
                                    );
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
          // set the OrderId in object box for later use.
          ProxyService.box.write(key: 'orderId', value: model.kOrder!.id);
          Stream<String> stream = streamController.stream;
          subscription = stream.listen((event) {
            String userId = ProxyService.box.read(key: 'userId');
            if (event == userId) {
              _btnController.success();
              double totalOrderAmount =
                  model.kOrder!.orderItems.fold(0, (a, b) => a + b.price);
              ProxyService.nav.navigateTo(Routes.afterSale,
                  arguments:
                      AfterSaleArguments(totalOrderAmount: totalOrderAmount));
            } else {
              _btnController.error();
            }
          });
        },
        viewModelBuilder: () => BusinessHomeViewModel());
  }
}
