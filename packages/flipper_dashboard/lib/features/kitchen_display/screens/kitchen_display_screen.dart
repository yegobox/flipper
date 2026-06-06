import 'package:flipper_dashboard/features/kitchen_display/providers/kitchen_display_provider.dart';
import 'package:flipper_dashboard/features/kitchen_display/widgets/order_column.dart';
import 'package:flipper_models/SyncStrategy.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/posthog_service.dart';
import 'package:flipper_services/proxy.dart';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class KitchenDisplayScreen extends ConsumerStatefulWidget {
  const KitchenDisplayScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<KitchenDisplayScreen> createState() =>
      _KitchenDisplayScreenState();
}

class _KitchenDisplayScreenState extends ConsumerState<KitchenDisplayScreen> {
  bool _pendingDrag = false;

  /// Same Capella observer as the tickets screen (WAITING + PARKED + IN_PROGRESS).
  static final kitchenOrdersStreamProvider = StreamProvider<List<ITransaction>>((
    ref,
  ) {
    final branchId = ProxyService.box.getBranchId();
    if (branchId == null) {
      return Stream.value([]);
    }

    return ProxyService.getStrategy(Strategy.capella)
        .openPosTicketsTransactionsStream(
          branchId: branchId,
          removeAdjustmentTransactions: true,
          forceRealData: true,
          skipOriginalTransactionCheck: true,
        )
        .map((allOrders) {
          final filteredOrders =
              allOrders.where((t) => t.isLoan != true).toList();
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
    final optimisticOrders = ref.watch(kitchenOrdersProvider);

    return Scaffold(
      appBar: AppBar(
        leading: const SizedBox.shrink(),
        title: const Text('Kitchen Display'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.invalidate(kitchenOrdersStreamProvider);
            },
          ),
        ],
      ),
      body: kitchenOrdersStream.when(
        data: (transactions) {
          final streamOrders = categorizeKitchenOrders(transactions);
          if (_pendingDrag &&
              !kitchenDisplayOrdersDiffer(streamOrders, optimisticOrders)) {
            _pendingDrag = false;
            Future.microtask(() {
              if (mounted) {
                ref.read(kitchenOrdersProvider.notifier).clearOrders();
              }
            });
          }

          final kitchenOrders = _pendingDrag &&
                  kitchenDisplayOrdersDiffer(streamOrders, optimisticOrders)
              ? optimisticOrders
              : streamOrders;

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
    ITransaction order,
    OrderStatus fromStatus,
    OrderStatus toStatus,
  ) async {
    if (fromStatus == toStatus) return;

    setState(() => _pendingDrag = true);
    ref
        .read(kitchenOrdersProvider.notifier)
        .moveOrder(order, fromStatus, toStatus);

    final status = _getStatusString(toStatus);
    final clearDueDate =
        toStatus == OrderStatus.incoming && order.isLoan != true;
    DateTime? dueDate;
    if (!clearDueDate &&
        toStatus == OrderStatus.inProgress &&
        order.isLoan != true) {
      dueDate =
          order.dueDate ?? DateTime.now().toUtc().add(const Duration(minutes: 30));
    } else if (!clearDueDate) {
      dueDate = order.dueDate?.toUtc();
    }

    try {
      await ProxyService.getStrategy(Strategy.capella)
          .updateKitchenOrderStatusFast(
        transactionId: order.id,
        status: status,
        dueDate: dueDate,
        clearDueDate: clearDueDate,
      );

      unawaited(
        PosthogService.instance.capture(
          'kitchen_order_status_changed',
          properties: {
            'order_id': order.id,
            'from_status': fromStatus.toString(),
            'to_status': toStatus.toString(),
            'is_loan': order.isLoan == true,
            'business_id': ProxyService.box.getBusinessId()!,
            'branch_id': ProxyService.box.getBranchId()!,
            'timestamp': DateTime.now().toIso8601String(),
            'source': 'kitchen_display',
          },
        ),
      );
    } catch (e) {
      // Track error event
      await PosthogService.instance.capture(
        'kitchen_order_status_change_failed',
        properties: {
          'order_id': order.id,
          'from_status': fromStatus.toString(),
          'to_status': toStatus.toString(),
          'error': e.toString(),
          'source': 'kitchen_display',
          'timestamp': DateTime.now().toIso8601String(),
        },
      );

      if (mounted) {
        setState(() => _pendingDrag = false);
        ref.read(kitchenOrdersProvider.notifier).clearOrders();
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to update order: $e')));
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
