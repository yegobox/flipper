import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_models/models/kitchen_order.dart';
import 'package:flutter/material.dart';

/// Kitchen Display presentation of [KitchenStage]. Deliberately separate from
/// the ticket's own status labels — a ticket can be "Parked" at the till and
/// "In Progress" in the kitchen at the same time.
extension KitchenStageDisplay on KitchenStage {
  /// Display label in the app's current language. Widgets should prefer
  /// [labelOf] with `context.flipperL10n` so a language switch rebuilds.
  String get label => labelOf(FlipperL10n.current);

  String labelOf(FlipperAppLocalizations l10n) {
    switch (this) {
      case KitchenStage.incoming:
        return l10n.kitchenStageIncoming;
      case KitchenStage.inProgress:
        return l10n.kitchenStageInProgress;
      case KitchenStage.ready:
        return l10n.kitchenStageReady;
      case KitchenStage.served:
        return l10n.kitchenStageServed;
    }
  }

  Color get color {
    switch (this) {
      case KitchenStage.incoming:
        return Colors.orange;
      case KitchenStage.inProgress:
        return Colors.blue;
      case KitchenStage.ready:
        return Colors.green;
      case KitchenStage.served:
        return Colors.grey;
    }
  }
}

/// What a Kitchen Display card carries while dragged.
@immutable
class KitchenDragData {
  const KitchenDragData({required this.transactionId, required this.from});

  final String transactionId;
  final KitchenStage from;
}

/// Override ids the stream already agrees with, or whose order has left the
/// stream (served elsewhere, ticket deleted). Those can be dropped.
Set<String> settledOverrides(
  List<KitchenOrder> streamOrders,
  Map<String, KitchenStage> overrides,
) {
  final byId = {for (final o in streamOrders) o.transactionId: o.stage};
  return {
    for (final entry in overrides.entries)
      if (!byId.containsKey(entry.key) || byId[entry.key] == entry.value)
        entry.key,
  };
}

/// Buckets [items] into the Kitchen Display columns, oldest order first
/// (first sent, first cooked). Served orders are dropped.
Map<KitchenStage, List<T>> groupKitchenOrders<T>(
  List<T> items,
  KitchenOrder Function(T item) orderOf,
) {
  final grouped = {for (final stage in KitchenStage.active) stage: <T>[]};
  for (final item in items) {
    final bucket = grouped[orderOf(item).stage];
    bucket?.add(item);
  }
  final epoch = DateTime.fromMillisecondsSinceEpoch(0, isUtc: true);
  for (final bucket in grouped.values) {
    bucket.sort((a, b) {
      final byTime = (orderOf(a).sentAt ?? epoch).compareTo(
        orderOf(b).sentAt ?? epoch,
      );
      if (byTime != 0) return byTime;
      return orderOf(a).transactionId.compareTo(orderOf(b).transactionId);
    });
  }
  return grouped;
}

/// Due date to write when an order moves to [to]: starting to cook sets a
/// default 30-minute promise if none was set; sending it back to Incoming
/// clears it. Null means leave the stored due date alone.
({DateTime? dueDate, bool clear}) dueDateForMove({
  required KitchenStage to,
  required DateTime? current,
  required DateTime now,
}) {
  switch (to) {
    case KitchenStage.incoming:
      return (dueDate: null, clear: true);
    case KitchenStage.inProgress:
      return (
        dueDate: current ?? now.toUtc().add(const Duration(minutes: 30)),
        clear: false,
      );
    case KitchenStage.ready:
    case KitchenStage.served:
      return (dueDate: null, clear: false);
  }
}

/// Kitchen Display confirmation after Served, by the ticket's own status —
/// where the order went for the cashier.
String servedMessage(String? ticketStatus, [FlipperAppLocalizations? l10n]) {
  final strings = l10n ?? FlipperL10n.current;
  switch (ticketStatus) {
    case 'completed':
      return strings.kitchenServedAlreadyPaid;
    case 'pending':
      return strings.kitchenServedCashierHasTicket;
    default:
      return strings.kitchenServedInTickets;
  }
}
