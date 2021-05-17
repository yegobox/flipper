import 'package:flipper_dashboard/customappbar.dart';
import 'package:flutter/material.dart';
import 'package:flipper_services/proxy.dart';

class Payments extends StatelessWidget {
  const Payments({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        onPop: () {
          ProxyService.nav.back();
        },
        title: "Payment options",
        rightActionButtonName: 'Save',
        disableButton: false,
        showActionButton: true,
        onPressedCallback: () async {
          // await model.saveOrder(
          //   variationId: model.checked,
          //   amount: model.amountTotal,
          // );
          // ProxyService.nav.back();
        },
        // actionButtonName: 'Add',
        icon: Icons.close,
        multi: 1,
        bottomSpacer: 49,
      ),
      body: Text('hello'),
    );
  }
}
