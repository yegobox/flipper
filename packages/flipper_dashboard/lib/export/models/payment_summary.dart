/// Represents a summary of payment information for reporting
class PaymentSummary {
  final String method;
  final double amount;
  final int count;

  const PaymentSummary({
    required this.method,
    required this.amount,
    required this.count,
  });
}
