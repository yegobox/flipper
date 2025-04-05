import 'package:flipper_models/realm_model_export.dart';
import 'package:flipper_services/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum OrderStatus {
  incoming,
  inProgress,
  completed
}

extension OrderStatusExtension on OrderStatus {
  String get displayName {
    switch (this) {
      case OrderStatus.incoming:
        return 'Incoming';
      case OrderStatus.inProgress:
        return 'In Progress';
      case OrderStatus.completed:
        return 'Completed';
    }
  }
  
  Color get color {
    switch (this) {
      case OrderStatus.incoming:
        return Colors.orange;
      case OrderStatus.inProgress:
        return Colors.blue;
      case OrderStatus.completed:
        return Colors.green;
    }
  }
}

class KitchenOrdersNotifier extends StateNotifier<Map<OrderStatus, List<ITransaction>>> {
  KitchenOrdersNotifier() : super({
    OrderStatus.incoming: [],
    OrderStatus.inProgress: [],
    OrderStatus.completed: [],
  });

  void updateOrders(List<ITransaction> transactions) {
    final Map<OrderStatus, List<ITransaction>> categorizedOrders = {
      OrderStatus.incoming: [],
      OrderStatus.inProgress: [],
      OrderStatus.completed: [],
    };

    for (final transaction in transactions) {
      if (transaction.status == PARKED) {
        categorizedOrders[OrderStatus.incoming]!.add(transaction);
      } else if (transaction.status == ORDERING) {
        categorizedOrders[OrderStatus.inProgress]!.add(transaction);
      } else if (transaction.status == COMPLETE) {
        categorizedOrders[OrderStatus.completed]!.add(transaction);
      }
    }

    state = categorizedOrders;
  }

  void moveOrder(ITransaction order, OrderStatus fromStatus, OrderStatus toStatus) {
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
        updatedOrder.status = ORDERING;
        break;
      case OrderStatus.completed:
        updatedOrder.status = COMPLETE;
        break;
    }
    
    // Add to target list
    updatedState[toStatus] = [...updatedState[toStatus]!, updatedOrder];
    
    state = updatedState;
  }
}

final kitchenOrdersProvider = StateNotifierProvider<KitchenOrdersNotifier, Map<OrderStatus, List<ITransaction>>>((ref) {
  return KitchenOrdersNotifier();
});
