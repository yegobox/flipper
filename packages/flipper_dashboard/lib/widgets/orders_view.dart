import 'package:flipper_dashboard/IncomingOrders.dart';
import 'package:flipper_dashboard/OrderStatusSelector.dart';
import 'package:flipper_dashboard/checkout.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart' as oldImplementationOfRiverpod;
import 'package:flipper_services/constants.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class OrdersView extends ConsumerStatefulWidget {
  const OrdersView({Key? key}) : super(key: key);

  @override
  ConsumerState<OrdersView> createState() => _OrdersViewState();
}

class _OrdersViewState extends ConsumerState<OrdersView> {
  OrderStatus _selectedStatus = OrderStatus.pending;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 30.0),
      child: Column(
        children: [
          OrderStatusSelector(
            selectedStatus: _selectedStatus,
            onStatusChanged: (newStatus) {
              setState(() {
                _selectedStatus = newStatus;
              });
              ref
                  .watch(oldImplementationOfRiverpod.stringProvider.notifier)
                  .updateString(
                    newStatus == OrderStatus.approved
                        ? RequestStatus.approved
                        : RequestStatus.pending,
                  );
            },
          ),
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
