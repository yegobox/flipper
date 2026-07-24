import 'package:flipper_dashboard/utils/sale_stock_deduction.dart';
import 'package:flipper_models/SyncStrategy.dart';
import 'package:flipper_models/db_model_export.dart';
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
/// Only call this when `Setting.enableTicketReviewWorkflow` is on; when off,
/// the sale was already finalized at Pay.
Future<void> finalizeTicketHandover({
  required BuildContext context,
  required ITransaction ticket,
}) async {
  final branchId = ticket.branchId ?? ProxyService.box.getBranchId();
  final items = await ProxyService.getStrategy(Strategy.capella).transactionItems(
    transactionId: ticket.id,
    branchId: branchId,
    active: true,
  );

  final model = CoreViewModel();

  // Sign + RRA receipt + fiscal counters. Assigns invoice/receipt fields onto
  // [ticket] in memory (needed by the stock sync below). Throws on failure.
  await model.finalizeSaleForHandover(
    transaction: ticket,
    context: context,
    items: items,
  );

  // Stock deduction (local + RRA) — deferred from Pay to here so it lands with
  // the signed invoice. Do not block a paid+reviewed sale on stock levels.
  final isProformaOrTraining =
      ProxyService.box.isProformaMode() || ProxyService.box.isTrainingMode();
  final receiptType =
      model.getFilterType(transactionType: ticket.receiptType).name;
  await runPostSaleStockDeductionAndRraSync(
    transactionItems: items,
    allowSellingBelowStock: true,
    isProformaOrTraining: isProformaOrTraining,
    transactionId: ticket.id,
    transaction: ticket,
    receiptType: receiptType,
    sarTyCd: resolveRraStockIoSarTyCd(receiptType: receiptType),
  );
}
