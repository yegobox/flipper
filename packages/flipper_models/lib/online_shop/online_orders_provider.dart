import 'dart:async';

import 'package:flipper_models/online_shop/online_order.dart';
import 'package:flipper_models/sms_review/sms_review_providers.dart'
    show usableDittoProvider;
import 'package:flipper_models/sync/dql_for_sync_subscription.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const _ordersQuery =
    'SELECT * FROM $kOnlineOrdersCollection WHERE branchId = :branchId '
    'ORDER BY createdAt DESC LIMIT 200';

/// The newest 200 online-shop orders of [branchId], newest first.
///
/// One Ditto observer for the whole list, plus a sync subscription so orders
/// the connector writes reach this till. The server is the only writer.
final onlineOrdersProvider = StreamProvider.autoDispose
    .family<List<OnlineOrder>, String>((ref, branchId) {
      if (branchId.isEmpty) return Stream.value(const []);
      final ditto = ref.watch(usableDittoProvider).value;
      if (ditto == null) return Stream.value(const []);

      final args = {'branchId': branchId};
      try {
        // Sync subscriptions reject ORDER BY / LIMIT; subscribe to the branch.
        final prepared = prepareDqlSyncSubscription(
          'SELECT * FROM $kOnlineOrdersCollection WHERE branchId = :branchId',
          args,
        );
        ditto.sync.registerSubscription(
          prepared.dql,
          arguments: prepared.arguments,
        );
      } catch (_) {
        // The observer still reads what is already on this device.
      }

      final controller = StreamController<List<OnlineOrder>>.broadcast();
      final observer = ditto.store.registerObserver(
        _ordersQuery,
        arguments: args,
        onChange: (result) {
          if (controller.isClosed) return;
          controller.add(
            parseOnlineOrders(
              result.items.map((i) => Map<String, dynamic>.from(i.value)),
            ),
          );
        },
      );
      ref.onDispose(() async {
        observer.cancel();
        await controller.close();
      });
      return controller.stream;
    });

/// Docs to orders, dropping junk, newest first.
List<OnlineOrder> parseOnlineOrders(Iterable<Map<String, dynamic>> docs) {
  final orders = [
    for (final doc in docs) OnlineOrder.fromDitto(doc),
  ].where((o) => o.id.isNotEmpty).toList();
  orders.sort((a, b) {
    final ac = a.createdAt, bc = b.createdAt;
    if (ac == null || bc == null) return 0;
    return bc.compareTo(ac);
  });
  return orders;
}
