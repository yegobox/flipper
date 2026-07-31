import 'package:supabase_models/brick/models/transaction.model.dart';
import 'package:supabase_models/brick/models/transactionItem.model.dart';

/// True when Capella already has a usable fiscal invoice/receipt counter.
///
/// Matches [resolvePostSaleInvoiceNo] without importing Capella/RRA helpers.
bool ticketHasFiscalInvoice(ITransaction ticket) {
  for (final n in [
    ticket.invoiceNumber,
    ticket.receiptNumber,
    ticket.totalReceiptNumber,
  ]) {
    if (n != null && n > 0) return true;
  }
  return false;
}

/// True when any stock-tracked line still needs local deduction.
///
/// Relies on `quantityShipped` only after a prior successful handover deduct
/// (markers are written after `batchUpdateStocks`).
bool ticketStockLinesNeedDeduction(List<TransactionItem> items) {
  for (final item in items) {
    if (item.itemTyCd == '3') continue;
    final vid = item.variantId;
    if (vid == null || vid.isEmpty) continue;
    if (item.quantityShipped != item.qty.toInt()) return true;
  }
  return false;
}
