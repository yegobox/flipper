import 'package:ditto_live/ditto_live.dart' show Ditto;
import 'package:flipper_models/DatabaseSyncInterface.dart';
import 'package:flipper_models/helpers/default_sale_receipt_type.dart';
import 'package:flipper_models/online_shop/online_order.dart';
import 'package:flipper_models/sync/utils/ticket_reference_sequence.dart';
import 'package:flipper_services/constants.dart' show PENDING, SALE;
import 'package:supabase_models/brick/models/transaction.model.dart';

/// Mints the empty sale row a ticket is built on, without touching this
/// till's own cart (`manageTransaction` would hand back the open cart).
typedef CreateTicketTransaction =
    Future<ITransaction> Function({
      required String branchId,
      required OnlineOrder order,
    });

/// Turns an accepted online order into a parked POS ticket, using the same
/// writers the POS uses: [DatabaseSyncInterface.saveTransactionItem] for each
/// line (pricing and tax as for a tapped item) and
/// [DatabaseSyncInterface.parkSaleTicketFast] to park it. Staff then resume it
/// from Tickets and take payment as for any other sale.
class OnlineOrderTicketWriter {
  OnlineOrderTicketWriter({
    required DatabaseSyncInterface db,
    required CreateTicketTransaction createTransaction,
  }) : _db = db,
       _create = createTransaction;

  final DatabaseSyncInterface _db;
  final CreateTicketTransaction _create;

  /// Parks a ticket for [order] at [branchId] and returns its transaction id.
  ///
  /// Throws [StateError] when a line's variant is not on this device (the
  /// catalog has not synced, or the item was deleted) or a line fails to
  /// save, before anything is parked.
  Future<String> park({
    required String branchId,
    required OnlineOrder order,
    required String paidNote,
  }) async {
    if (order.items.isEmpty) {
      throw StateError('Online order ${order.orderNumber} has no items');
    }
    final txn = await _create(branchId: branchId, order: order);
    for (final line in order.items) {
      final variant = await _db.getVariant(id: line.variantId);
      if (variant == null) {
        throw StateError('Item "${line.name}" is not in this branch catalog');
      }
      final saved = await _db.saveTransactionItem(
        variation: variant,
        amountTotal: line.unitPrice,
        customItem: false,
        pendingTransaction: txn,
        currentStock: variant.stock?.currentStock ?? 0,
        partOfComposite: false,
        doneWithTransaction: false,
        ignoreForReport: false,
        updatableQty: line.qty,
      );
      if (!saved) {
        throw StateError('Could not add "${line.name}" to the ticket');
      }
    }
    await _db.parkSaleTicketFast(
      transaction: txn,
      ticketName: order.ticketName,
      ticketNote: onlineOrderTicketNote(order, paidNote: paidNote),
    );
    return txn.id;
  }
}

/// The parked ticket's note: who ordered, how it is fulfilled and, when the
/// customer already paid by MoMo, [paidNote] so the cashier completes it with
/// the MoMo tender instead of taking cash again.
String onlineOrderTicketNote(OnlineOrder order, {required String paidNote}) {
  final parts = <String>[
    if (order.isPaid) paidNote,
    order.customerPhone,
    if (order.isDelivery && (order.deliveryAddress ?? '').isNotEmpty)
      order.deliveryAddress!,
    if ((order.note ?? '').isNotEmpty) order.note!,
  ].where((p) => p.trim().isNotEmpty);
  return parts.join(' · ');
}

/// The default [CreateTicketTransaction]: a PENDING sale row in Ditto with no
/// device id, so no till's cart lookup (which matches on device id) can pick
/// it up before it is parked a moment later.
CreateTicketTransaction dittoTicketTransactionFactory({
  required Ditto ditto,
  required String agentId,
}) {
  return ({required String branchId, required OnlineOrder order}) async {
    final now = DateTime.now().toUtc();
    final reference = (await nextTicketReferenceNumber(
      ditto: ditto,
      branchId: branchId,
    )).toString();
    final txn = ITransaction(
      branchId: branchId,
      status: PENDING,
      transactionType: SALE,
      subTotal: 0,
      cashReceived: 0,
      customerChangeDue: 0,
      // The cashier picks the real tender when completing the ticket.
      paymentType: 'Cash',
      isIncome: true,
      isExpense: false,
      agentId: agentId,
      customerName: order.customerName,
      customerPhone: order.customerPhone,
      receiptType: defaultSaleReceiptType(),
      createdAt: now,
      updatedAt: now,
      lastTouched: now,
      reference: reference,
      transactionNumber: reference,
    );
    final doc = await ITransactionDittoAdapter.instance.toDittoDocument(txn);
    await ditto.store.execute(
      'INSERT INTO transactions DOCUMENTS (:doc)',
      arguments: {'doc': doc},
    );
    return txn;
  };
}
