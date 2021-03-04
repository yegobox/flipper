import 'package:customappbar/customappbar.dart';
import 'package:flipper/utils/HexColor.dart';
import 'package:flipper/utils/validators.dart';
import 'package:flipper/views/sale/complete_sale_viewmodel.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class CollectCashView extends StatelessWidget {
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
                          FlatButton(
                            onPressed: () {
                              model.collectCash();
                            },
                            child: const Text('Tender'),
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
          //listen on completed.
          ProxyService.pusher.subs();
          model.listenPaymentComplete();
        },
        viewModelBuilder: () => CompleteSaleViewModel());
  }
}
