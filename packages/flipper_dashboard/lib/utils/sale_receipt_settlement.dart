import 'package:flipper_dashboard/utils/sale_stock_deduction.dart';
import 'package:flipper_models/DatabaseSyncInterface.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/helperModels/sale_completion_helpers.dart';
import 'package:flipper_models/mixins/TaxController.dart';
import 'package:flipper_models/sync/utils/rra_line_utils.dart';
import 'package:flipper_models/sync/utils/sale_accounting_fields.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/locator.dart';
import 'package:flipper_services/payment_methods.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_services/setting_service.dart';
import 'package:flutter/foundation.dart';

/// The receipt half of completing a sale, shared by every mode that settles a
/// parked ticket — bar tabs and hotel folios.
///
/// Both used to be POS-only behaviour, so a mode that settled its own ticket
/// silently produced no receipt at all: the sale completed, the room or table
/// was released, and nothing was filed or printed.

/// Whether RRA already signed [stored] as a sale: it carries the receipt
/// number [TaxController] persists after a successful filing.
bool saleAlreadyReceipted(ITransaction stored) {
  final number = stored.receiptNumber;
  return number != null &&
      number > 0 &&
      const {'NS', 'TS', 'PS'}.contains(stored.receiptType);
}

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
  // A retry after a later step failed: RRA already signed this sale, and
  // filing it again would issue a second receipt for it. Carry the stored
  // receipt fields so the mode's write does not clear them.
  final stored = await sync.getTransaction(id: transaction.id);
  if (stored != null && saleAlreadyReceipted(stored)) {
    transaction
      ..receiptType = stored.receiptType
      ..sarNo = stored.sarNo
      ..receiptNumber = stored.receiptNumber
      ..totalReceiptNumber = stored.totalReceiptNumber
      ..invoiceNumber = stored.invoiceNumber;
    return;
  }

  final box = ProxyService.box;
  final businessId = box.getBusinessId();
  final branchId = box.getBranchId();

  var fiscalReceiptHandled = false;
  if (businessId != null && branchId != null) {
    final taxEnabled = await sync.isTaxEnabled(
      businessId: businessId,
      branchId: branchId,
    );
    final stopTax = box.stopTaxService() ?? false;
    final hasBhf = (await box.bhfId()) != null;

    if (taxEnabled && !stopTax && hasBhf) {
      final ebm = await sync.ebm(branchId: branchId);
      if (ebm?.taxServerUrl != null) {
        box.writeString(key: 'getServerUrl', value: ebm!.taxServerUrl!);
        box.writeString(key: 'bhfId', value: ebm.bhfId);
        // The receipt request reads pmtTyCd from the box. Bar and hotel never
        // touch the POS picker that sets it, so without this they file under
        // whatever tender the last POS sale used.
        box.writeString(
          key: 'pmtTyCd',
          value: rraPaymentTypeCode(transaction.paymentType),
        );

        final filterType = box.isProformaMode() ? FilterType.PS : FilterType.NS;
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
/// One payment row per tender in [payments].
///
/// With [replacePriorRows], only the first write clears the sale's earlier
/// rows, so a retried completion does not leave the previous attempt's rows
/// beside these. Leave it off where those rows are earlier installments of a
/// resumed loan: the balance is read back from them.
Future<void> saveSalePaymentRows({
  required DatabaseSyncInterface sync,
  required String transactionId,
  required List<PaymentLineForSaleCompletion> payments,
  bool replacePriorRows = true,
}) async {
  for (var i = 0; i < payments.length; i++) {
    final payment = payments[i];
    await sync.savePaymentType(
      singlePaymentOnly: replacePriorRows && i == 0,
      amount: payment.amount,
      transactionId: transactionId,
      paymentMethod: payment.method,
      payerName: payment.payerName,
      saleCompletionFastPath: true,
    );
  }
}

/// Runs *after* the ticket is marked complete, mirroring the order the POS and
/// bar settle paths use.
///
/// One payment row per tender in [payments], so a table paid part cash, part
/// MoMo shows both in the Cash Book. Only the first write clears earlier rows:
/// a retried settle must not leave the previous attempt's rows beside these.
Future<void> recordSalePaymentAndScheduleStock({
  required DatabaseSyncInterface sync,
  required ITransaction transaction,
  required List<TransactionItem> lines,
  required String transactionId,
  required List<PaymentLineForSaleCompletion> payments,
}) async {
  await saveSalePaymentRows(
    sync: sync,
    transactionId: transactionId,
    payments: payments,
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
///   4. record the payment — one row per tender in [payments] — and hand
///      stock/RRA follow-up to the background.
///
/// The receipt is filed under `transaction.paymentType` alone (RRA takes one
/// `pmtTyCd`), so callers set it to the primary tender, as the POS does.
///
/// A new mode supplies step 3 and gets the rest right by construction.
Future<ITransaction> finalizeServiceModeSale({
  required DatabaseSyncInterface sync,
  required ITransaction transaction,
  required List<TransactionItem> lines,
  required String transactionId,
  required List<PaymentLineForSaleCompletion> payments,
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
    payments: payments,
  );

  return settled;
}
