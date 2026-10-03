import 'package:flipper_dashboard/customappbar.dart';
import 'package:flipper_dashboard/features/incoming_orders/screens/incoming_orders_screen.dart';
import 'package:flutter/material.dart';

class InventoryRequestMobileView extends StatelessWidget {
  const InventoryRequestMobileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Branch Orders',
        icon: Icons.arrow_back,
        onPop: () => Navigator.of(context).maybePop(),
      ),
      body: const SafeArea(
        top: false,
        child: IncomingOrdersScreen(showTitle: false),
      ),
    );
  }
}
