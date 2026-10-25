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

/// Parks the ticket for an accepted [order] and links it on the server.
Future<String> createOnlineOrderTicket({
  required OnlineShopClient client,
  required OnlineOrderTicketWriter writer,
  required String branchId,
  required OnlineOrder order,
  required String paidNote,
}) async {
  final ticketId = await writer.park(
    branchId: branchId,
    order: order,
    paidNote: paidNote,
  );
  await client.updateOrder(
    branchId: branchId,
    orderId: order.id,
    action: OnlineOrderAction.linkTicket,
    ticketTransactionId: ticketId,
  );
  return ticketId;
}
