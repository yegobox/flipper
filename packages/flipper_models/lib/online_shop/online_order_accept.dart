import 'package:flipper_models/online_shop/online_order.dart';
import 'package:flipper_models/online_shop/online_order_ticket.dart';
import 'package:flipper_models/online_shop/online_shop_client.dart';

/// Accepts [order] and gives it a parked POS ticket.
///
/// The accept goes first: if another till already accepted or rejected it,
/// the server answers 409 and no ticket is made. Then the ticket is parked
/// and linked to the order. If parking fails after the accept, the order
/// stays accepted without a ticket and the card offers "Create ticket"
/// ([OnlineOrder.needsTicket]), which calls [createOnlineOrderTicket].
///
/// Returns the ticket's transaction id.
Future<String> acceptOnlineOrder({
  required OnlineShopClient client,
  required OnlineOrderTicketWriter writer,
  required String branchId,
  required OnlineOrder order,
  required String paidNote,
}) async {
  final accepted = await client.updateOrder(
    branchId: branchId,
    orderId: order.id,
    action: OnlineOrderAction.accept,
  );
  // The server's copy is newer (it may have been paid meanwhile), but keep
  // the lines we already have if the response left them out.
  final latest = accepted.id.isEmpty || accepted.items.isEmpty
      ? order
      : accepted;
  return createOnlineOrderTicket(
    client: client,
    writer: writer,
    branchId: branchId,
    order: latest,
    paidNote: paidNote,
  );
}

/// Tickets parked for an order whose `link_ticket` call failed, by order id.
/// The next "Create ticket" for that order links this ticket instead of
/// parking a second one. Lasts the app session.
final Map<String, String> unlinkedOnlineOrderTickets = {};

/// Parks the ticket for an accepted [order] and links it on the server.
///
/// If the link fails, the parked ticket's id stays in [unlinked] (default
/// [unlinkedOnlineOrderTickets]) so a retry links it instead of parking a
/// duplicate.
Future<String> createOnlineOrderTicket({
  required OnlineShopClient client,
  required OnlineOrderTicketWriter writer,
  required String branchId,
  required OnlineOrder order,
  required String paidNote,
  Map<String, String>? unlinked,
}) async {
  final pending = unlinked ?? unlinkedOnlineOrderTickets;
  final ticketId =
      pending[order.id] ??
      await writer.park(branchId: branchId, order: order, paidNote: paidNote);
  pending[order.id] = ticketId;
  await client.updateOrder(
    branchId: branchId,
    orderId: order.id,
    action: OnlineOrderAction.linkTicket,
    ticketTransactionId: ticketId,
  );
  pending.remove(order.id);
  return ticketId;
}
