import 'package:flipper_analytics/flipper_analytics.dart';
import 'package:flipper_dashboard/features/kitchen_display/kitchen_stage.dart';
import 'package:flipper_dashboard/features/kitchen_display/providers/kitchen_display_provider.dart';
import 'package:flipper_dashboard/features/kitchen_display/widgets/order_column.dart';
import 'package:flipper_models/DatabaseSyncInterface.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_models/providers/kitchen_orders_provider.dart';
import 'package:flipper_models/sync/interfaces/transaction_interface.dart';
import 'package:flipper_services/proxy.dart';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Kitchen Display: orders sent to the kitchen (`kitchen_orders`, Capella).
///
/// Moving a card only ever writes the order's kitchen stage. The ticket's own
/// `status` is left alone, so the till can still Collect / Resume it and the
/// Tickets badge still counts it while the kitchen is cooking.
class KitchenDisplayScreen extends ConsumerStatefulWidget {
  const KitchenDisplayScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<KitchenDisplayScreen> createState() =>
      _KitchenDisplayScreenState();
}

class _KitchenDisplayScreenState extends ConsumerState<KitchenDisplayScreen> {
  ProductAnalytics get _analytics => ProxyService.productAnalytics;

  DatabaseSyncInterface get _capella => ref.read(kitchenCapellaProvider);

  @override
  void initState() {
    super.initState();
    unawaited(_repairLegacyTickets());
  }

  /// Tickets the old Kitchen Display stranded as `inProgress` / `waiting` go
  /// back to `parked` and onto this display. No-op once there are none.
  Future<void> _repairLegacyTickets() async {
    final branchId = ref.read(kitchenBranchIdProvider);
    if (branchId == null) return;
    try {
      await _capella.repairLegacyKitchenStatuses(branchId: branchId);
    } catch (e, s) {
      talker.error('Kitchen Display: legacy ticket repair failed: $e', s);
    }
  }

  @override
  Widget build(BuildContext context) {
    final ordersAsync = ref.watch(kitchenOrdersStreamProvider);
    final overrides = ref.watch(kitchenStageOverridesProvider);

    // Drop pending drags the stream now agrees with.
    ref.listen(kitchenOrdersStreamProvider, (_, next) {
      final views = next.value;
      if (views == null) return;
      final settled = settledOverrides([
        for (final v in views) v.order,
      ], ref.read(kitchenStageOverridesProvider));
      ref.read(kitchenStageOverridesProvider.notifier).removeAll(settled);
    });

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
      body: ordersAsync.when(
        // Keep the columns on screen while the stream reloads (refresh,
        // branch switch) instead of flashing a spinner mid-drag.
        skipLoadingOnReload: true,
        data: (views) {
          final effective = [
            for (final v in views)
              if (overrides[v.order.transactionId] case final stage?)
                KitchenOrderView(
                  order: v.order.copyWith(stage: stage),
                  ticket: v.ticket,
                )
              else
                v,
          ];
          final columns = groupKitchenOrders<KitchenOrderView>(
            effective,
            (v) => v.order,
          );

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (final stage in KitchenStage.active) ...[
                  if (stage != KitchenStage.active.first)
                    const SizedBox(width: 16),
                  Expanded(
                    child: OrderColumn(
                      stage: stage,
                      orders: columns[stage] ?? const [],
                      onOrderMoved: (id, from, to) {
                        // The order can leave the stream mid-drag (served on
                        // another screen, ticket deleted): drop the move.
                        for (final view in effective) {
                          if (view.order.transactionId == id) {
                            unawaited(_moveOrder(view, from, to));
                            return;
                          }
                        }
                      },
                      onSetDueDate: (view, dueDate) =>
                          unawaited(_setDueDate(view, dueDate)),
                      onServed: (view) => unawaited(
                        _moveOrder(view, stage, KitchenStage.served),
                      ),
                    ),
                  ),
                ],
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

  Future<void> _moveOrder(
    KitchenOrderView view,
    KitchenStage from,
    KitchenStage to,
  ) async {
    if (from == to) return;
    final id = view.order.transactionId;
    final overridesNotifier = ref.read(kitchenStageOverridesProvider.notifier);
    overridesNotifier.set(id, to);

    final due = dueDateForMove(
      to: to,
      current: view.order.dueDate,
      now: DateTime.now(),
    );

    try {
      await _capella.updateKitchenStage(
        transactionId: id,
        stage: to,
        dueDate: due.dueDate,
        clearDueDate: due.clear,
      );
      if (to == KitchenStage.served && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(servedMessage(view.ticket?.status))),
        );
      }

      unawaited(
        _analytics.track(
          'kitchen_order_status_changed',
          properties: {
            'order_id': id,
            'from_status': from.wire,
            'to_status': to.wire,
            'is_loan': view.ticket?.isLoan == true,
            'business_id': ProxyService.box.getBusinessId() ?? '',
            'branch_id': ProxyService.box.getBranchId() ?? '',
            'timestamp': DateTime.now().toIso8601String(),
            'source': 'kitchen_display',
          },
        ),
      );
    } catch (e, s) {
      talker.error('Kitchen Display: move $id $from -> $to failed: $e', s);
      unawaited(
        _analytics.track(
          'kitchen_order_status_change_failed',
          properties: {
            'order_id': id,
            'from_status': from.wire,
            'to_status': to.wire,
            'error': e.toString(),
            'source': 'kitchen_display',
            'timestamp': DateTime.now().toIso8601String(),
          },
        ),
      );
      if (!mounted) return;
      overridesNotifier.remove(id);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to update order: $e')));
    }
  }

  Future<void> _setDueDate(KitchenOrderView view, DateTime dueDate) async {
    try {
      await _capella.updateKitchenStage(
        transactionId: view.order.transactionId,
        stage: view.order.stage,
        dueDate: dueDate,
      );
    } catch (e, s) {
      talker.error('Kitchen Display: set due date failed: $e', s);
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to set due date: $e')));
    }
  }
}
