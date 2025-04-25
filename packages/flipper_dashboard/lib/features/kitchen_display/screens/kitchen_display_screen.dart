import 'package:flipper_dashboard/features/kitchen_display/providers/kitchen_display_provider.dart';
import 'package:flipper_dashboard/features/kitchen_display/widgets/order_column.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/posthog_service.dart';
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
  // Load transactions using the same approach as TicketsListMixin (tickets_list.dart)
  // This stream matches the logic for ticket display, but filters out isLoan == true
  final kitchenOrdersStreamProvider = StreamProvider<List<ITransaction>>((ref) {
    // Create broadcast streams for each status to allow multiple listeners
    final parkedStream = ProxyService.strategy
        .transactionsStream(
          status: PARKED,
          removeAdjustmentTransactions: true,
        )
        .asBroadcastStream();

    final inProgressStream = ProxyService.strategy
        .transactionsStream(
            status: IN_PROGRESS, removeAdjustmentTransactions: true)
        .asBroadcastStream();

    final waitingStream = ProxyService.strategy
        .transactionsStream(status: WAITING, removeAdjustmentTransactions: true)
        .asBroadcastStream();

    // Merge streams with periodic polling (excluding COMPLETE status)
    return Stream.periodic(const Duration(seconds: 2)).asyncMap((_) async {
      // Fetch the latest data from each stream
      final parkedOrders = await parkedStream.first;
      final inProgressOrders = await inProgressStream.first;
      final waitingOrders = await waitingStream.first;

      // Combine all transactions - use the same order as tickets_list.dart for consistency
      final allOrders = [
        ...waitingOrders,
        ...parkedOrders,
        ...inProgressOrders
      ];

      // FILTER: Only show non-loan tickets in the kitchen display
      final filteredOrders = allOrders.where((t) => t.isLoan != true).toList();

      // Sort by status priority and then by creation date (newest first)
      filteredOrders.sort((a, b) {
        final statusA = a.status;
        final statusB = b.status;

        if (statusA == WAITING && statusB != WAITING) return -1;
        if (statusA != WAITING && statusB == WAITING) return 1;
        if (statusA == PARKED && statusB == IN_PROGRESS) return -1;
        if (statusA == IN_PROGRESS && statusB == PARKED) return 1;

        final dateA = a.createdAt ?? DateTime(1970);
        final dateB = b.createdAt ?? DateTime(1970);
        return dateB.compareTo(dateA);
      });

      return filteredOrders;
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
                    title: OrderStatus.waiting.displayName,
                    orders: kitchenOrders[OrderStatus.waiting] ?? [],
                    color: OrderStatus.waiting.color,
                    status: OrderStatus.waiting,
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

  void _handleOrderMoved(
      ITransaction order, OrderStatus fromStatus, OrderStatus toStatus) async {
    // toStatus is now directly passed from the OrderColumn, representing the column where the order was dropped

    // Track order progress event
    await PosthogService.instance
        .capture('kitchen_order_status_changed', properties: {
      'order_id': order.id,
      'from_status': fromStatus.toString(),
      'to_status': toStatus.toString(),
      'is_loan': order.isLoan == true,
      'business_id': ProxyService.box.getBusinessId()!,
      'branch_id': ProxyService.box.getBranchId()!,
      'timestamp': DateTime.now().toIso8601String(),
      'source': 'kitchen_display',
    });

    // Update the UI immediately
    ref.read(kitchenOrdersProvider.notifier).moveOrder(
          order,
          fromStatus,
          toStatus,
        );

    // Update the order status in the database
    try {
      // Get the new status string based on the destination column
      final status = _getStatusString(toStatus);

      // Update the transaction properties using a new instance (do not mutate original)
      final updatedOrder = ITransaction(
        id: order.id,
        ticketName: order.ticketName,
        categoryId: order.categoryId,
        transactionNumber: order.transactionNumber,
        currentSaleCustomerPhoneNumber: order.currentSaleCustomerPhoneNumber,
        reference: order.reference,
        branchId: order.branchId,
        status: status, // updated status
        transactionType: order.transactionType,
        subTotal: order.subTotal,
        paymentType: order.paymentType,
        cashReceived: order.cashReceived,
        customerChangeDue: order.customerChangeDue,
        createdAt: order.createdAt,
        receiptType: order.receiptType,
        updatedAt: DateTime.now().toUtc(),
        customerId: order.customerId,
        customerType: order.customerType,
        note: order.note,
        lastTouched: DateTime.now().toUtc(),
        supplierId: order.supplierId,
        ebmSynced: order.ebmSynced,
        isIncome: order.isIncome,
        isExpense: order.isExpense,
        isRefunded: order.isRefunded,
        customerName: order.customerName,
        customerTin: order.customerTin,
        remark: order.remark,
        customerBhfId: order.customerBhfId,
        receiptFileName: order.receiptFileName,
        sarTyCd: order.sarTyCd,
        receiptNumber: order.receiptNumber,
        totalReceiptNumber: order.totalReceiptNumber,
        isDigitalReceiptGenerated: order.isDigitalReceiptGenerated,
        invoiceNumber: order.invoiceNumber,
        sarNo: order.sarNo,
        orgSarNo: order.orgSarNo,
        isLoan: order.isLoan,
        dueDate: (toStatus == OrderStatus.incoming && order.isLoan != true)
            ? null
            : (toStatus == OrderStatus.inProgress && order.isLoan != true
                ? (order.dueDate ??
                    DateTime.now().toUtc().add(const Duration(minutes: 30)))
                : order.dueDate?.toUtc()),
      );

      // Use the same approach as in transaction_mixin.dart to update the transaction
      // This is how transactions are updated throughout the Flipper codebase
      await ProxyService.strategy.updateTransaction(transaction: updatedOrder);

      // Force refresh the stream to reflect changes
      ref.invalidate(kitchenOrdersStreamProvider);
    } catch (e) {
      // Track error event
      await PosthogService.instance
          .capture('kitchen_order_status_change_failed', properties: {
        'order_id': order.id,
        'from_status': fromStatus.toString(),
        'to_status': toStatus.toString(),
        'error': e.toString(),
        'source': 'kitchen_display',
        'timestamp': DateTime.now().toIso8601String(),
      });

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

  String _getStatusString(OrderStatus status) {
    switch (status) {
      case OrderStatus.incoming:
        return PARKED;
      case OrderStatus.inProgress:
        return IN_PROGRESS;
      case OrderStatus.waiting:
        return WAITING;
    }
  }
}
