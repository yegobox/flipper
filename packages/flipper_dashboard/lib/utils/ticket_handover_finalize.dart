import 'package:flipper_dashboard/utils/sale_stock_deduction.dart';
import 'package:flipper_models/SyncStrategy.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_models/helpers/ticket_handover_idempotency.dart';
import 'package:flipper_models/sync/utils/rra_stock_reporting.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/widgets.dart';

/// Ticket Review + Handover workflow: finalize a paid ticket at the Stock
/// Manager's handover step.
///
/// Runs the completion work that was deferred from Pay: RRA sign + receipt +
/// fiscal counters ([CoreViewModel.finalizeSaleForHandover]), then stock
/// deduction (local + RRA) now that the invoice number exists. Throws on RRA
/// signing failure so the caller can keep the ticket in `awaitingHandover`
/// (no status flip, nothing lost) and let the user retry.
///
/// Idempotent on retry: if invoice fields are already on the Ditto transaction,
/// RRA sign is skipped; if line `quantityShipped` already matches qty, stock
/// deduct is skipped (shipped is only written after a successful deduct).
///
/// Only call this when `Setting.enableTicketReviewWorkflow` is on; when off,
/// the sale was already finalized at Pay.
Future<void> finalizeTicketHandover({
  required BuildContext context,
  required ITransaction ticket,
}) async {
  final capella = ProxyService.getStrategy(Strategy.capella);
  final branchId = ticket.branchId ?? ProxyService.box.getBranchId();

  ITransaction working = ticket;
  final fresh = await capella.getTransaction(
    id: ticket.id,
    branchId: branchId,
  );
  if (fresh != null) working = fresh;

  final items = await capella.transactionItems(
    transactionId: working.id,
    branchId: branchId,
    active: true,
  );

  final model = CoreViewModel();
  final alreadyFiscalized = ticketHasFiscalInvoice(working);

  if (!alreadyFiscalized) {
    // Sign + RRA receipt + fiscal counters. Capella persists invoice/receipt/
    // sarNo onto the Ditto transaction (needed for stock sync + retry safety).
    await model.finalizeSaleForHandover(
      transaction: working,
      context: context,
      items: items,
    );
    final afterSign = await capella.getTransaction(
      id: working.id,
      branchId: branchId,
    );
    if (afterSign != null) working = afterSign;
  } else {
    talker.info(
      'Handover: skip RRA sign; fiscal invoice already on ${working.id} '
      '(invoice=${working.invoiceNumber} receipt=${working.receiptNumber})',
    );
  }

  // Stock deduction (local + RRA) — deferred from Pay to here so it lands with
  // the signed invoice. Do not block a paid+reviewed sale on stock levels.
  if (!ticketStockLinesNeedDeduction(items)) {
    talker.info(
      'Handover: skip stock deduct; lines already marked shipped for ${working.id}',
    );
    return;
  }

  final isProformaOrTraining =
      ProxyService.box.isProformaMode() || ProxyService.box.isTrainingMode();
  final receiptType =
      model.getFilterType(transactionType: working.receiptType).name;
  await runPostSaleStockDeductionAndRraSync(
    transactionItems: items,
    allowSellingBelowStock: true,
    isProformaOrTraining: isProformaOrTraining,
    transactionId: working.id,
    transaction: working,
    receiptType: receiptType,
    sarTyCd: resolveRraStockIoSarTyCd(receiptType: receiptType),
  );
}
