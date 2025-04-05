import 'package:flipper_dashboard/features/kitchen_display/providers/kitchen_display_provider.dart';
import 'package:flipper_dashboard/features/kitchen_display/widgets/order_column.dart';
import 'package:flipper_models/db_model_export.dart';
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
  // Create a StreamProvider for kitchen orders
  final kitchenOrdersStreamProvider = StreamProvider<List<ITransaction>>((ref) {
    final branchId = ProxyService.box.getBranchId();
    if (branchId == null) {
      return Stream.value([]);
    }

    // Create a merged stream of transactions with all three statuses
    final parkedStream = ProxyService.strategy
        .transactionsStream(
          status: PARKED,
          branchId: branchId,
          removeAdjustmentTransactions: true,
        )
        .asBroadcastStream();

    final orderingStream = ProxyService.strategy
        .transactionsStream(
          status: ORDERING,
          branchId: branchId,
          removeAdjustmentTransactions: true,
        )
        .asBroadcastStream();

    final completeStream = ProxyService.strategy
        .transactionsStream(
          status: COMPLETE,
          branchId: branchId,
          removeAdjustmentTransactions: true,
        )
        .asBroadcastStream();

    // Merge all streams and combine their results
    return Stream.periodic(const Duration(seconds: 1)).asyncMap((_) async {
      final parkedOrders = await parkedStream.first;
      final orderingOrders = await orderingStream.first;
      final completeOrders = await completeStream.first;

      return [...parkedOrders, ...orderingOrders, ...completeOrders];
    });
  });

  @override
  Widget build(BuildContext context) {
    final kitchenOrdersStream = ref.watch(kitchenOrdersStreamProvider);
    final kitchenOrders = ref.watch(kitchenOrdersProvider);

    // Listen to kitchen orders changes - must be in build method
    ref.listen(kitchenOrdersStreamProvider, (previous, next) {
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
              ref.invalidate(kitchenOrdersStreamProvider);
            },
          ),
        ],
      ),
      body: kitchenOrdersStream.when(
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
      // Get the new status string
      final status = _getStatusString(toStatus);

      // Update the transaction properties
      final updatedOrder = order;
      updatedOrder.status = status;
      updatedOrder.lastTouched = DateTime.now();

      // Use the same approach as in transaction_mixin.dart to update the transaction
      // This is how transactions are updated throughout the Flipper codebase
      await ProxyService.strategy.updateTransaction(transaction: updatedOrder);

      // Force refresh the stream to reflect changes
      ref.invalidate(kitchenOrdersStreamProvider);
    } catch (e) {
      // Show error if update fails
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update order: $e')),
        );
        // Revert the UI change since the database update failed
        ref.invalidate(kitchenOrdersStreamProvider);
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
        return ORDERING; // This is correct, but was being overridden in the updatedOrder.status assignment
      case OrderStatus.completed:
        return COMPLETE;
    }
  }
}
