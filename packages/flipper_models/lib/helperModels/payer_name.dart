/// Helpers for the optional "who actually paid" name captured per tender line.
///
/// For mobile-money and bank tenders the account the money arrives from is
/// frequently not the customer attached to the transaction — a relative sends
/// the MoMo, a company account settles a personal bill. Capturing that name on
/// the payment line lets the cashier reconcile a statement later without
/// overwriting the transaction's own customer.
library;

/// Payment methods for which the payer-name field is offered.
///
/// Deliberately limited to the tenders that arrive through a named third-party
/// account. Cash and credit have no payer to disambiguate, so they keep the
/// payment row exactly as it was before this field existed.
const Set<String> payerNameCapablePaymentMethods = {
  'MOBILE MONEY',
  'MTN MOMO',
  'AIRTEL MONEY',
  'BANK CHECK',
  'DEBIT&CREDIT CARD',
};

/// Whether [paymentMethod] should offer/carry a payer name.
bool paymentMethodSupportsPayerName(String? paymentMethod) {
  if (paymentMethod == null) return false;
  return payerNameCapablePaymentMethods.contains(
    paymentMethod.trim().toUpperCase(),
  );
}

/// Trims [payerName] and collapses blank input to null so an untouched field
/// never persists an empty string.
String? normalizedPayerName(String? payerName) {
  final trimmed = payerName?.trim();
  if (trimmed == null || trimmed.isEmpty) return null;
  return trimmed;
}
