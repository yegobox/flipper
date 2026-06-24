import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_services/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';

enum OrderStatus { incoming, inProgress, waiting }

extension OrderStatusExtension on OrderStatus {
  String get displayName {
    switch (this) {
      case OrderStatus.incoming:
        return 'Incoming';
      case OrderStatus.inProgress:
        return 'In Progress';
      case OrderStatus.waiting:
        return 'Waiting';
    }
  }

  Color get color {
    switch (this) {
      case OrderStatus.incoming:
        return Colors.orange;
      case OrderStatus.inProgress:
        return Colors.blue;
      case OrderStatus.waiting:
        return Colors.purple;
    }
  }
}

class KitchenOrdersNotifier
    extends StateNotifier<Map<OrderStatus, List<ITransaction>>> {
  KitchenOrdersNotifier()
    : super({
        OrderStatus.incoming: [],
        OrderStatus.inProgress: [],
        OrderStatus.waiting: [],
      });

  void updateOrders(List<ITransaction> transactions) {
    state = categorizeKitchenOrders(transactions);
  }

  void clearOrders() {
    state = {
      OrderStatus.incoming: [],
      OrderStatus.inProgress: [],
      OrderStatus.waiting: [],
    };
  }

  void moveOrder(
    ITransaction order,
    OrderStatus fromStatus,
    OrderStatus toStatus,
  ) {
    final updatedState = Map<OrderStatus, List<ITransaction>>.from(state);

    // Remove from source list
    updatedState[fromStatus] = updatedState[fromStatus]!
        .where((t) => t.id != order.id)
        .toList();

    // Update order status based on the target column
    final updatedOrder = order;
    switch (toStatus) {
      case OrderStatus.incoming:
        updatedOrder.status = PARKED;
        break;
      case OrderStatus.inProgress:
        updatedOrder.status = IN_PROGRESS;
        break;
      case OrderStatus.waiting:
        updatedOrder.status = WAITING;
        break;
    }

    // Add to target list
    updatedState[toStatus] = [...updatedState[toStatus]!, updatedOrder];

    state = updatedState;
  }
}

bool kitchenDisplayOrdersDiffer(
  Map<OrderStatus, List<ITransaction>> stream,
  Map<OrderStatus, List<ITransaction>> optimistic,
) {
  for (final status in OrderStatus.values) {
    final streamIds = stream[status]!.map((t) => t.id).toList()..sort();
    final optimisticIds = optimistic[status]!.map((t) => t.id).toList()..sort();
    if (streamIds.join(',') != optimisticIds.join(',')) {
      return true;
    }
  }
  return false;
}

Map<OrderStatus, List<ITransaction>> categorizeKitchenOrders(
  List<ITransaction> transactions,
) {
  final categorizedOrders = <OrderStatus, List<ITransaction>>{
    OrderStatus.incoming: [],
    OrderStatus.inProgress: [],
    OrderStatus.waiting: [],
  };

  for (final transaction in transactions) {
    if (transaction.isLoan == true) continue;

    if (transaction.status == PARKED) {
      categorizedOrders[OrderStatus.incoming]!.add(transaction);
    } else if (transaction.status == IN_PROGRESS ||
        transaction.status == ORDERING) {
      categorizedOrders[OrderStatus.inProgress]!.add(transaction);
    } else if (transaction.status == WAITING) {
      categorizedOrders[OrderStatus.waiting]!.add(transaction);
    }
  }

  return categorizedOrders;
}

final kitchenOrdersProvider =
    StateNotifierProvider<
      KitchenOrdersNotifier,
      Map<OrderStatus, List<ITransaction>>
    >((ref) {
      return KitchenOrdersNotifier();
    });
