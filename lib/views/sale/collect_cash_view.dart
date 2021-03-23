import 'package:customappbar/customappbar.dart';
import 'package:flipper/utils/HexColor.dart';
import 'package:flipper/utils/validators.dart';
import 'package:flipper/views/sale/complete_sale_viewmodel.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class CollectCashView extends StatelessWidget {
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder.reactive(
        builder:
            (BuildContext context, CompleteSaleViewModel model, Widget child) {
          return SafeArea(
            child: Scaffold(
              appBar: CommonAppBar(
                onPop: () {
                  ProxyService.nav.pop();
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
                      child: Column(
                        // ignore: prefer_const_literals_to_create_immutables
                        children: [
                          const SizedBox(height: 40),
                          Padding(
                            padding: const EdgeInsets.only(left: 18, right: 18),
                            child: Container(
                              width: double.infinity,
                              child: TextFormField(
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    .copyWith(color: Colors.black),
                                validator: Validators.isValid,
                                onChanged: (String phone) {
                                  model.phone = phone;
                                },
                                decoration: InputDecoration(
                                  hintText: 'Payer phone number',
                                  fillColor: Theme.of(context)
                                      .copyWith(canvasColor: Colors.white)
                                      .canvasColor,
                                  filled: true,
                                  border: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: HexColor('#D0D7E3')),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.only(left: 18, right: 18),
                            child: Container(
                              width: double.infinity,
                              child: TextFormField(
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    .copyWith(color: Colors.black),
                                validator: Validators.isValid,
                                onChanged: (String cash) {
                                  model.keypad.cash.value = double.parse(cash);
                                },
                                decoration: InputDecoration(
                                  hintText: 'Cash Received',
                                  fillColor: Theme.of(context)
                                      .copyWith(canvasColor: Colors.white)
                                      .canvasColor,
                                  filled: true,
                                  border: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: HexColor('#D0D7E3')),
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
                            onPressed: () {
                              model.collectSPENNPayment();
                            },
                            child: const Text('Tender',
                                style: TextStyle(color: Colors.white)),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        onModelReady: (CompleteSaleViewModel model) {
          model.completedSale.value = null;
          model.completedSale.listen((v) {
            try {
              if (v != null && v == true) {
                _btnController.success();
              } else if (v != null && v == false) {
                _btnController.error();
              }
            } on Exception {
              rethrow;
            }
          });
          ProxyService.pusher.subs();
          model.listenPaymentComplete();
        },
        viewModelBuilder: () => CompleteSaleViewModel());
  }
}
