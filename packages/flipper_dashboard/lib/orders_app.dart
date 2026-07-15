import 'package:flipper_dashboard/IncomingOrders.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class OrdersApp extends StatefulHookConsumerWidget {
  const OrdersApp({Key? key}) : super(key: key);

  @override
  _OrdersAppState createState() => _OrdersAppState();
}

class _OrdersAppState extends ConsumerState<OrdersApp> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxHeight == 0 || constraints.maxWidth == 0) {
          return const SizedBox.shrink();
        }
        return const IncomingOrders();
      },
    );
  }
}
