import 'package:flipper_dashboard/utils/sale_stock_deduction.dart';
import 'package:flipper_models/DatabaseSyncInterface.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/mixins/TaxController.dart';
import 'package:flipper_models/sync/utils/rra_line_utils.dart';
import 'package:flipper_models/sync/utils/sale_accounting_fields.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/locator.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_services/setting_service.dart';
import 'package:flutter/foundation.dart';

/// The receipt half of completing a sale, shared by every mode that settles a
/// parked ticket — bar tabs and hotel folios.
///
/// Both used to be POS-only behaviour, so a mode that settled its own ticket
/// silently produced no receipt at all: the sale completed, the room or table
/// was released, and nothing was filed or printed.

/// Files [transaction] with RRA and prints it.
///
/// Falls back to a plain non-fiscal print when the branch is not EBM-registered
/// — the ticket is still a real completed sale, so the guest still gets paper.
///
/// [receiptContext] only labels the enrichment log ('receipt', 'folio
/// invoice'), so a missing field can be traced back to the mode that sent it.
///
/// Throws when RRA rejects the receipt, so the caller can abort **before**
/// marking the sale complete. Filing first is deliberate: a settled ticket that
/// RRA refused is far harder to unpick than one the desk retries.
Future<void> issueSaleReceipt({
  required DatabaseSyncInterface sync,
  required ITransaction transaction,
  required List<TransactionItem> lines,
  required String receiptContext,
}) async {
  final businessId = ProxyService.box.getBusinessId();
  final branchId = ProxyService.box.getBranchId();

  var fiscalReceiptHandled = false;
  if (businessId != null && branchId != null) {
    final taxEnabled = await sync.isTaxEnabled(
      businessId: businessId,
      branchId: branchId,
    );
    final stopTax = ProxyService.box.stopTaxService() ?? false;
    final hasBhf = (await ProxyService.box.bhfId()) != null;

    if (taxEnabled && !stopTax && hasBhf) {
      final ebm = await sync.ebm(branchId: branchId);
      if (ebm?.taxServerUrl != null) {
        ProxyService.box.writeString(
          key: 'getServerUrl',
          value: ebm!.taxServerUrl!,
        );
        ProxyService.box.writeString(key: 'bhfId', value: ebm.bhfId);

        final filterType = ProxyService.box.isProformaMode()
            ? FilterType.PS
            : FilterType.NS;
        final receiptLines = await enrichLinesForRraReceipt(
          lines,
          context: receiptContext,
        );
        final result = await TaxController(
          object: transaction,
        ).handleReceipt(filterType: filterType, transactionItems: receiptLines);
        if (result.response.resultCd != '000') {
          throw Exception(result.response.resultMsg);
        }
        fiscalReceiptHandled = true;
      }
    }
  }

  if (!fiscalReceiptHandled && lines.isNotEmpty) {
    try {
      await TaxController(object: transaction).buildNonFiscalReceiptPdfBytes(
        transaction: transaction,
        transactionItems: lines,
      );
    } catch (e) {
      debugPrint('Non-fiscal $receiptContext print failed: $e');
    }
  }
}

/// Records the payment and hands the stock/RRA follow-up to the background.
///
/// Runs *after* the ticket is marked complete, mirroring the order the POS and
/// bar settle paths use.
Future<void> recordSalePaymentAndScheduleStock({
  required DatabaseSyncInterface sync,
  required ITransaction transaction,
  required List<TransactionItem> lines,
  required String transactionId,
  required String paymentType,
  required double amount,
}) async {
  await sync.savePaymentType(
    singlePaymentOnly: true,
    amount: amount,
    transactionId: transactionId,
    paymentMethod: paymentType,
    saleCompletionFastPath: true,
  );

  if (lines.isEmpty) return;

  final allowBelow = await getIt<SettingsService>().isAllowSellingBelowStock();
  final isProformaOrTraining =
      ProxyService.box.isProformaMode() || ProxyService.box.isTrainingMode();
  final receiptType = ProxyService.box.isProformaMode() ? 'PS' : 'NS';
  schedulePostSaleStockDeductionAndRraSync(
    transactionItems: lines,
    allowSellingBelowStock: allowBelow,
    isProformaOrTraining: isProformaOrTraining,
    transactionId: transactionId,
    transaction: transaction,
    receiptType: receiptType,
  );
}

/// Settles a parked ticket: books it, files it, completes it, records it.
///
/// The one seam every service mode goes through, so the order cannot drift
/// between them:
///
///   1. derive the ledger fields from [lines] — the server-side poster splits
///      revenue by `taxAmount`, so a ticket completed without it books its
///      whole value to revenue and nothing to VAT payable;
///   2. file the receipt with RRA, which throws on rejection so nothing is
///      completed behind a refused invoice;
///   3. [complete] — the mode's own write (`settleBarTab`, `checkOutGuest`),
///      the only part that differs between surfaces;
///   4. record the payment and hand stock/RRA follow-up to the background.
///
/// A new mode supplies step 3 and gets the rest right by construction.
Future<ITransaction> finalizeServiceModeSale({
  required DatabaseSyncInterface sync,
  required ITransaction transaction,
  required List<TransactionItem> lines,
  required String transactionId,
  required String paymentType,
  required double amount,
  required String receiptContext,
  required Future<ITransaction> Function(ITransaction invoiced) complete,
}) async {
  applySaleAccountingFields(transaction: transaction, lines: lines);

  await issueSaleReceipt(
    sync: sync,
    transaction: transaction,
    lines: lines,
    receiptContext: receiptContext,
  );

  final settled = await complete(transaction);

  await recordSalePaymentAndScheduleStock(
    sync: sync,
    transaction: settled,
    lines: lines,
    transactionId: transactionId,
    paymentType: paymentType,
    amount: amount,
  );

  return settled;
}
