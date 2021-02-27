import 'package:customappbar/customappbar.dart';
import 'package:flipper/views/sale/complete_sale_viewmodel.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class CompleteSaleView extends StatelessWidget {
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
                actionButtonName: 'Split payment',
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
                          const Text('FRw0.89'),
                          const Text('Select Payment type bellow'),
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
                          ListTile(
                            leading: const Text('Cash'),
                            trailing: const Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.pink,
                              size: 24.0,
                              semanticLabel:
                                  'Text to announce in accessibility modes',
                            ),
                          ),
                          // ignore: prefer_const_constructors
                          ListTile(
                            leading: const Text('SPENN'),
                            trailing: const Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.pink,
                              size: 24.0,
                              semanticLabel:
                                  'Text to announce in accessibility modes',
                            ),
                          ),
                          // ignore: prefer_const_constructors
                          ListTile(
                            leading: const Text('MOMO'),
                            trailing: const Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.pink,
                              size: 24.0,
                              semanticLabel:
                                  'Text to announce in accessibility modes',
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
        viewModelBuilder: () => CompleteSaleViewModel());
  }
}
