import 'package:flipper/routes.router.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:number_display/number_display.dart';
import 'package:stacked/stacked.dart';
import 'package:flipper_models/view_models/business_home_viewmodel.dart';

import 'customappbar.dart';
import 'flipper_ui.dart';

class AfterSale extends StatefulWidget {
  const AfterSale({Key? key, required this.totalOrderAmount}) : super(key: key);
  final double totalOrderAmount;

  @override
  _AfterSaleState createState() => _AfterSaleState();
}

class _AfterSaleState extends State<AfterSale> {
  final display = createDisplay(
    length: 8,
    decimal: 0,
  );

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<BusinessHomeViewModel>.reactive(
        builder: (context, model, child) {
          return SafeArea(
            child: Scaffold(
              appBar: CustomAppBar(
                useTransparentButton: true,
                onPop: () {
                  ProxyService.nav.popUntil(ModalRoute.withName(Routes.home));
                },
                title: '',
                closeButton: CLOSEBUTTON.BUTTON,
                disableButton: false,
                showActionButton: true,
                onPressedCallback: () {
                  // ProxyService.nav.navigateTo(Routing.customerListView);
                  //show coming soon snackbar
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
                        children: [
                          const SizedBox(height: 40),
                          Text(
                            'FRw' +
                                display(model.keypad.cashReceived -
                                        widget.totalOrderAmount)
                                    .toString() +
                                ' Change',
                            style: const TextStyle(
                                fontSize: 20.0, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Out of FRw ' +
                                model.keypad.cashReceived.toStringAsFixed(0),
                            style: const TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
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
                              child: FLipperButton(
                                disableButton: false,
                                buttonName: 'Email',
                                onPressedCallback: () {},
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 18.0, right: 18.0),
                            child: Container(
                              width: double.infinity,
                              child: FLipperButton(
                                disableButton: false,
                                buttonName: 'No Receipt',
                                onPressedCallback: () {},
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
        onModelReady: (model) {
          print(model.keypad.cashReceived);
        },
        viewModelBuilder: () => BusinessHomeViewModel());
  }
}
