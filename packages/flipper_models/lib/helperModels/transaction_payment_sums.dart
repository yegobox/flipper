/// Per-transaction breakdown from [transaction_payment_records] for reports.
class TransactionPaymentSums {
  const TransactionPaymentSums({
    required this.byHand,
    required this.credit,
    required this.hasAnyRecord,
  });

  /// Sum of payment rows whose method is not CREDIT (case-insensitive).
  final double byHand;

  /// Sum of payment rows whose method is CREDIT (case-insensitive).
  final double credit;

  /// True when at least one payment row exists for this transaction.
  final bool hasAnyRecord;
}

/// Shared normalization for payment method strings (aligns with report / Excel export).
bool paymentMethodEqualsIgnoreCase(String? a, String b) {
  if (a == null) return false;
  return a.trim().toUpperCase() == b.trim().toUpperCase();
}

bool paymentMethodIsCredit(String? method) =>
    paymentMethodEqualsIgnoreCase(method, 'CREDIT');

double parsePaymentAmount(dynamic amount) {
  if (amount == null) return 0.0;
  if (amount is num) return amount.toDouble();
  if (amount is String) return double.tryParse(amount) ?? 0.0;
  return 0.0;
}
