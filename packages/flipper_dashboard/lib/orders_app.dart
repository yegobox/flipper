import 'package:flipper_dashboard/IncomingOrders.dart';
import 'package:flipper_dashboard/OrderStatusSelector.dart';
import 'package:flipper_dashboard/checkout.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart'
    as oldImplementationOfRiverpod;
import 'package:flipper_services/constants.dart';
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
    return Padding(
      padding: const EdgeInsets.only(top: 30.0),
      child: Column(
        children: [
          // OrderStatusSelector(
          //   selectedStatus: selectedStatus,
          //   onStatusChanged: (newStatus) {
          //     ref
          //         .read(
          //             oldImplementationOfRiverpod.orderStatusProvider.notifier)
          //         .state = newStatus;
          //     ref
          //             .read(oldImplementationOfRiverpod
          //                 .requestStatusProvider.notifier)
          //             .state =
          //         newStatus == OrderStatus.approved
          //             ? RequestStatus.approved
          //             : RequestStatus.pending;
          //   },
          // ),
          const SizedBox(height: 20),
          Flexible(
            child: SingleChildScrollView(
              child: const IncomingOrders(),
            ),
          ),
        ],
      ),
    );
  }
}
