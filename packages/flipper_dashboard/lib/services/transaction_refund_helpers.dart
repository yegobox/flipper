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
