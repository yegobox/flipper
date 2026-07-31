import 'package:supabase_models/brick/models/transaction.model.dart';

/// Pure helpers for refund stock restoration (testable without I/O).

/// Qty to restore per line item for a partial or full refund.
int stockRestoreQtyForLine({
  required int lineQty,
  required double refundAmount,
  required double originalTotal,
  required int lineIndex,
  required int lineCount,
}) {
  if (lineQty <= 0 || originalTotal <= 0 || refundAmount <= 0) {
    return 0;
  }
  if (refundAmount >= originalTotal - 0.001) {
    return lineQty;
  }
  final ratio = refundAmount / originalTotal;
  var qty = (lineQty * ratio).round();
  if (qty < 1 && lineQty > 0) {
    qty = 1;
  }
  if (qty > lineQty) {
    qty = lineQty;
  }
  return qty.clamp(0, lineQty);
}

bool isPartialRefund(double refundAmount, double originalTotal) {
  if (originalTotal <= 0) return false;
  return refundAmount < originalTotal - 0.001;
}

String refundStatusForAmount(double refundAmount, double originalTotal) {
  return isPartialRefund(refundAmount, originalTotal)
      ? 'partially_refunded'
      : 'refunded';
}

/// Resolves RRA receipt type string for VAT refund (from legacy Refund widget).
String? resolveVatRefundReceiptType(ITransaction transaction) {
  final rt = transaction.receiptType;
  if (rt == 'TS') return 'TR';
  if (rt == 'PS') return null;
  if (rt == 'NS') return 'NR';
  if (rt == 'CS') return 'CR';
  return null;
}

const _refundReceiptTypes = {'NR', 'CR', 'TR'};

/// Whether a transaction must not be refunded again (UI + service guard).
bool isTransactionRefunded(ITransaction transaction) {
  if (transaction.isRefunded == true) return true;

  final status = (transaction.status ?? '').toLowerCase();
  if (status == 'refunded' || status == 'partially_refunded') return true;

  final receiptType = transaction.receiptType ?? '';
  if (_refundReceiptTypes.contains(receiptType)) return true;

  if (transaction.isOriginalTransaction == false &&
      (transaction.originalTransactionId?.isNotEmpty ?? false)) {
    return true;
  }

  return false;
}

/// Completed Flipper sale status (case-insensitive).
bool isTransactionCompletedForRefund(ITransaction transaction) {
  final status = (transaction.status ?? '').toLowerCase().trim();
  return status == 'completed';
}

/// True when the sale still has credit / unpaid balance.
///
/// Credit (loan) sales with remaining balance owed cannot be refunded. Fully
/// paid completed sales (`cashReceived` covers `subTotal`, or a settled loan
/// with remainingBalance ≈ 0) are eligible.
bool hasOutstandingCreditOrBalance(ITransaction transaction) {
  final total = (transaction.subTotal ?? 0).toDouble();
  if (total <= 0.01) return false;

  final paid = (transaction.cashReceived ?? 0).toDouble();
  final due = (transaction.remainingBalance ?? 0).toDouble();

  // Open loan / CREDIT sale — must be fully settled first.
  if (transaction.isLoan == true) {
    if (due > 0.01) return true;
    return paid < total - 0.01;
  }

  // Non-loan: require paid to cover the sale (ignore constructor default
  // remainingBalance == subTotal when cashReceived already covers the total).
  if (paid >= total - 0.01) return false;
  if (due > 0.01) return true;
  return paid < total - 0.01;
}

/// Human-readable reason the sale cannot be refunded, or null if allowed.
String? refundBlockReason(ITransaction transaction) {
  if (isTransactionRefunded(transaction)) {
    return 'This transaction is already refunded';
  }
  if (transaction.receiptType == 'PS') {
    return 'Cannot refund a proforma receipt';
  }
  if (!isTransactionCompletedForRefund(transaction)) {
    return 'Only completed transactions can be refunded';
  }
  if (hasOutstandingCreditOrBalance(transaction)) {
    return 'Credit or partially paid sales cannot be refunded until fully paid';
  }
  return null;
}

/// Whether UI / service may offer a refund for this sale.
bool canRefundTransaction(ITransaction transaction) =>
    refundBlockReason(transaction) == null;
