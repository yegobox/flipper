import 'package:flipper_dashboard/features/kitchen_display/providers/kitchen_display_provider.dart';
import 'package:flipper_dashboard/features/kitchen_display/widgets/order_column.dart';
import 'package:flipper_models/providers/transactions_provider.dart';
import 'package:flipper_models/realm_model_export.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class KitchenDisplayScreen extends ConsumerStatefulWidget {
  const KitchenDisplayScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<KitchenDisplayScreen> createState() =>
      _KitchenDisplayScreenState();
}

class _KitchenDisplayScreenState extends ConsumerState<KitchenDisplayScreen> {
  @override
  Widget build(BuildContext context) {
    final transactionsStream = ref.watch(transactionsProvider);
    final kitchenOrders = ref.watch(kitchenOrdersProvider);

    // Listen to transactions changes - must be in build method
    ref.listen(transactionsProvider, (previous, next) {
      next.whenData((transactions) {
        // Schedule the update after the current build is complete
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            ref.read(kitchenOrdersProvider.notifier).updateOrders(transactions);
          }
        });
      });
    });

    return Scaffold(
      appBar: AppBar(
        leading: const SizedBox.shrink(),
        title: const Text('Kitchen Display'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              // Force refresh
              ref.invalidate(transactionsProvider);
            },
          ),
        ],
      ),
      body: transactionsStream.when(
        data: (transactions) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: OrderColumn(
                    title: OrderStatus.incoming.displayName,
                    orders: kitchenOrders[OrderStatus.incoming] ?? [],
                    color: OrderStatus.incoming.color,
                    status: OrderStatus.incoming,
                    onOrderAccepted: _handleOrderMoved,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: OrderColumn(
                    title: OrderStatus.inProgress.displayName,
                    orders: kitchenOrders[OrderStatus.inProgress] ?? [],
                    color: OrderStatus.inProgress.color,
                    status: OrderStatus.inProgress,
                    onOrderAccepted: _handleOrderMoved,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: OrderColumn(
                    title: OrderStatus.completed.displayName,
                    orders: kitchenOrders[OrderStatus.completed] ?? [],
                    color: OrderStatus.completed.color,
                    status: OrderStatus.completed,
                    onOrderAccepted: _handleOrderMoved,
                  ),
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text(
            'Error loading orders: $error',
            style: const TextStyle(color: Colors.red),
          ),
        ),
      ),
    );
  }

  void _handleOrderMoved(ITransaction order, OrderStatus fromStatus) async {
    final toStatus = _getNextStatus(fromStatus);

    // Update the UI immediately
    ref.read(kitchenOrdersProvider.notifier).moveOrder(
          order,
          fromStatus,
          toStatus,
        );

    // Update the order status in the database
    try {
      final status = _getStatusString(toStatus);
      // Update the transaction directly
      order.status = status;
      // Save changes
      await ProxyService.strategy.updateTransaction(transaction: order);
    } catch (e) {
      // Show error if update fails
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update order: $e')),
        );
      }
    }
  }

  OrderStatus _getNextStatus(OrderStatus current) {
    switch (current) {
      case OrderStatus.incoming:
        return OrderStatus.inProgress;
      case OrderStatus.inProgress:
        return OrderStatus.completed;
      case OrderStatus.completed:
        return OrderStatus.incoming; // Cycle back to incoming
    }
  }

  String _getStatusString(OrderStatus status) {
    switch (status) {
      case OrderStatus.incoming:
        return PARKED;
      case OrderStatus.inProgress:
        return ORDERING;
      case OrderStatus.completed:
        return COMPLETE;
    }
  }
}
