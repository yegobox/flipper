import 'dart:async';

import 'package:flipper_models/online_shop/online_order.dart';
import 'package:flipper_models/sms_review/sms_review_providers.dart'
    show usableDittoProvider;
import 'package:flipper_models/sync/dql_for_sync_subscription.dart';
import 'package:flipper_services/constants.dart' show COMPLETE;
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

/// The linked tickets of [branchId]'s open orders that are completed sales on
/// this device. The connector completes an order only once its ticket is one
/// (409 otherwise), so the card offers Complete from this set.
///
/// One observer for every open order's ticket, re-registered only when the
/// set of linked tickets changes.
final soldOnlineOrderTicketsProvider = StreamProvider.autoDispose
    .family<Set<String>, String>((ref, branchId) {
      final ticketIds = ref.watch(
        onlineOrdersProvider(branchId).select(
          (orders) => openOrderTicketIds(orders.value ?? const []).join(','),
        ),
      );
      if (ticketIds.isEmpty) return Stream.value(const <String>{});
      final ditto = ref.watch(usableDittoProvider).value;
      if (ditto == null) return Stream.value(const <String>{});

      final controller = StreamController<Set<String>>.broadcast();
      final observer = ditto.store.registerObserver(
        'SELECT _id, status, branchId FROM transactions WHERE _id IN :ids',
        arguments: {'ids': ticketIds.split(',')},
        onChange: (result) {
          if (controller.isClosed) return;
          controller.add(
            soldTicketIds(
              result.items.map((i) => Map<String, dynamic>.from(i.value)),
              branchId: branchId,
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

/// The tickets linked to orders still open, sorted so the same set always
/// gives the same key.
List<String> openOrderTicketIds(Iterable<OnlineOrder> orders) => [
  for (final o in orders)
    if (o.status.isOpen && o.hasTicket) o.ticketTransactionId!,
]..sort();

/// Ids of the transaction docs that are completed sales at [branchId].
Set<String> soldTicketIds(
  Iterable<Map<String, dynamic>> docs, {
  required String branchId,
}) => {
  for (final doc in docs)
    if (doc['status'] == COMPLETE && doc['branchId'] == branchId)
      if (doc['_id'] case final String id) id,
};
