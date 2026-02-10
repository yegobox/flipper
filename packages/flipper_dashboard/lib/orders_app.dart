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
    // final selectedStatus =
    //     ref.watch(oldImplementationOfRiverpod.orderStatusProvider);
    return LayoutBuilder(
      builder: (context, constraints) {
        // Handle case when constraints are not yet available
        if (constraints.maxHeight == 0 || constraints.maxWidth == 0) {
          return const SizedBox.shrink();
        }
        return Padding(
          padding: const EdgeInsets.only(top: 30.0),
          child: Column(
            children: [
              const SizedBox(height: 20),
              Expanded(child: const IncomingOrders()),
            ],
          ),
        );
      },
    );
  }
}
