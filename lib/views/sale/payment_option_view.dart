import 'package:customappbar/customappbar.dart';
import 'package:flipper/views/sale/complete_sale_viewmodel.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:number_display/number_display.dart';
import 'package:stacked/stacked.dart';

import 'package:flipper/routes/router.gr.dart';

class PaymentOptionView extends StatelessWidget {
  final display = createDisplay(
    length: 8,
    decimal: 0,
  );
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
                onPressedCallback: () {
                  ProxyService.nav.pop();
                },
                title: '',
                rightActionButtonName: 'Split payment',
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
                          Text(
                            'FRw ' + display(model.total).toString(),
                            style: const TextStyle(
                                fontSize: 20.0, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 40),
                          const Text(
                            'Select Payment type Bellow',
                            style: TextStyle(
                                fontSize: 18.0, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      left: 0,
                      child: Column(
                        // ignore: prefer_const_literals_to_create_immutables
                        children: [
                          // ignore: prefer_const_constructors
                          GestureDetector(
                            onTap: () {
                              ProxyService.nav.navigateTo(
                                  Routing.collectCashView,
                                  arguments: CollectCashViewArguments(
                                      paymentType: 'cash'));
                            },
                            child: const ListTile(
                              leading: Text('Cash',
                                  style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold)),
                              trailing: Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.pink,
                                size: 24.0,
                                semanticLabel: 'Cash',
                              ),
                            ),
                          ),
                          // ignore: prefer_const_constructors
                          GestureDetector(
                            onTap: () {
                              ProxyService.nav.navigateTo(
                                  Routing.collectCashView,
                                  arguments: CollectCashViewArguments(
                                      paymentType: 'spenn'));
                            },
                            child: const ListTile(
                              leading: Text('SPENN',
                                  style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold)),
                              trailing: Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.pink,
                                size: 24.0,
                                semanticLabel: 'SPENN',
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
        onModelReady: (CompleteSaleViewModel model) {
          ProxyService.pusher.clean();
          model.setCurrentItemKeyPadSaleValue();
        },
        viewModelBuilder: () => CompleteSaleViewModel());
  }
}
