import 'package:customappbar/customappbar.dart';
import 'package:flipper/routes/router.gr.dart';
// import 'package:flipper/routes/router.gr.dart';
import 'package:flipper/views/sale/complete_sale_viewmodel.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_ui/flipper_ui.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:stacked/stacked.dart';

class AfterSaleView extends StatelessWidget {
  const AfterSaleView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder.reactive(
        builder:
            (BuildContext context, CompleteSaleViewModel model, Widget child) {
          return SafeArea(
            child: Scaffold(
              appBar: CommonAppBar(
                onPop: () {
                  ProxyService.nav.popUntil(Routing.dashboard);
                },
                title: '',
                closeButton: CLOSEBUTTON.BUTTON,
                disableButton: false,
                showActionButton: true,
                onPressedCallback: () {
                  ProxyService.nav.navigateTo(Routing.customerListView);
                },
                leftActionButtonName: 'New Sale',
                rightActionButtonName: 'Add Customer',
                // icon: Icons.close,
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
                            'FRw' +
                                (model.keypad.amount - model.keypad.totalPayable)
                                    .toStringAsFixed(0) +
                                ' Change',
                            style: const TextStyle(
                                fontSize: 20.0, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Out of FRw ' +
                                model.keypad.amount.toStringAsFixed(0),
                            style: const TextStyle(
                                fontSize: 18.0, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      bottom: 200,
                      right: 0,
                      left: 0,
                      child: Column(
                        // ignore: prefer_const_literals_to_create_immutables
                        children: [
                          const Text('How would you like your receipt?'),
                          const SizedBox(height: 10),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 18.0, right: 18.0),
                            child: Container(
                              width: double.infinity,
                              child: const Button(
                                disableButton: false,
                                onPressedCallback: null,
                                buttonName: 'Email',
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 18.0, right: 18.0),
                            child: Container(
                              width: double.infinity,
                              child: const Button(
                                disableButton: false,
                                onPressedCallback: null,
                                buttonName: 'No Receipt',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                        bottom: 0,
                        // right: ,
                        left: MediaQuery.of(context).size.width / 2.5,
                        child: Row(
                          // ignore: prefer_const_literals_to_create_immutables
                          children: [
                            const IconButton(
                              icon: FaIcon(FontAwesomeIcons.globe),
                              onPressed: null,
                            ),
                            const Text('English')
                          ],
                        ))
                  ],
                ),
              ),
            ),
          );
        },
        onModelReady: (CompleteSaleViewModel model) {
          //listen on completed.
          // ProxyService.pusher.subs();
        },
        viewModelBuilder: () => CompleteSaleViewModel());
  }
}
