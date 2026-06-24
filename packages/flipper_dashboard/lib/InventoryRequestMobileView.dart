import 'package:flipper_dashboard/features/incoming_orders/screens/incoming_orders_screen.dart';
import 'package:flutter/material.dart';

class InventoryRequestMobileView extends StatelessWidget {
  const InventoryRequestMobileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: SafeArea(child: IncomingOrdersScreen()));
  }
}
