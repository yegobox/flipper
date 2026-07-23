/// Decimal rounding aligned with [DoubleExtension.roundToTwoDecimalPlaces] without Flutter deps.
double _roundToTwoDecimalPlaces(double value) =>
    double.parse(value.toStringAsFixed(2));

const double saleCartQtyMatchEpsilon = 0.0001;

/// Minimal row shape for cart qty comparison (VM-safe; no Ditto/Flutter models).
typedef SaleCartQtyRow = ({String? variantId, num qty, bool? active});

/// Per-variant qty sum for comparing checkout display vs Ditto cart lines.
Map<String, double> saleLineQtyByVariantId(Iterable<SaleCartQtyRow> items) {
  final out = <String, double>{};
  for (final item in items) {
    if (item.active == false) continue;
    final vid = item.variantId;
    if (vid == null || vid.isEmpty) continue;
    out[vid] = (out[vid] ?? 0) + item.qty.toDouble();
  }
  return out;
}

/// True when persisted and displayed carts carry the same variant qty totals.
bool saleLineQtyMapsMatch(
  Map<String, double> displayByVariant,
  Map<String, double> persistedByVariant, {
  double epsilon = saleCartQtyMatchEpsilon,
}) {
  if (displayByVariant.length != persistedByVariant.length) return false;
  for (final entry in displayByVariant.entries) {
    final other = persistedByVariant[entry.key];
    if (other == null) return false;
    if ((entry.value - other).abs() > epsilon) return false;
  }
  return true;
}

/// Aligned with [COMPLETE] / [PARKED] in `flipper_services/constants.dart` (VM-safe).
const String saleCompletionStatusComplete = 'completed';
const String saleCompletionStatusParked = 'parked';

/// Aligned with [PENDING_REVIEW] / [AWAITING_HANDOVER] in
/// `flipper_services/constants.dart` (VM-safe — this file must stay
/// Flutter/Ditto-free).
const String saleCompletionStatusPendingReview = 'pendingReview';
const String saleCompletionStatusAwaitingHandover = 'awaitingHandover';

/// Redirects a derived-complete sale to [saleCompletionStatusPendingReview]
/// when the business has the Ticket Review + Handover workflow enabled, so
/// the ticket stays visible in the Review Queue instead of disappearing.
/// Parked/loan outcomes are never redirected — the workflow only intercepts
/// the fully-paid branch, and only the *persisted* status changes; payment
/// collection and tax signing still happen at the same moment they do today.
String applyTicketReviewWorkflowRedirect({
  required String derivedStatus,
  required bool ticketReviewWorkflowEnabled,
}) {
  if (!ticketReviewWorkflowEnabled) return derivedStatus;
  if (derivedStatus != saleCompletionStatusComplete) return derivedStatus;
  return saleCompletionStatusPendingReview;
}

/// Statuses that mean "money already collected, tax already signed" for
/// accounting/reporting purposes, even though the ticket is not yet in its
/// final [saleCompletionStatusComplete] state.
const Set<String> financiallySettledSaleStatuses = {
  saleCompletionStatusComplete,
  saleCompletionStatusPendingReview,
  saleCompletionStatusAwaitingHandover,
};

bool isFinanciallySettledSaleStatus(String? status) =>
    status != null && financiallySettledSaleStatuses.contains(status);

const double _paymentEpsilon = 0.0001;

/// Minimal tender line for completion math (no Flutter controllers).
class PaymentLineForSaleCompletion {
  const PaymentLineForSaleCompletion({
    required this.amount,
    required this.method,
  });

  final double amount;
  final String method;
}

/// Result of [deriveSaleCompletionState] — status and balances for persisting a sale.
class DerivedSaleCompletionState {
  const DerivedSaleCompletionState({
    required this.shouldBeLoan,
    required this.status,
    required this.remainingBalance,
    required this.nonCreditCashReceived,
    required this.effectiveCashReceived,
    required this.totalCredit,
  });

  final bool shouldBeLoan;
  final String status;
  final double remainingBalance;
  final double nonCreditCashReceived;
  final double effectiveCashReceived;
  final double totalCredit;
}

/// Computes loan vs complete status from keypad/cart tender lines (matches PreviewCartMixin).
///
/// [priorAlreadyPaidNonCredit] is the sum of non-credit payments already
/// persisted for this transaction (e.g. earlier installments on a resumed
/// loan/layaway). Pass 0 for a fresh sale. When provided, the current tender
/// ([paymentMethods]) is treated as the new installment, and both amounts are
/// added when deciding whether the sale is fully covered.
///
/// [nonCreditCashReceived] in the result is the **cumulative** non-credit total
/// that should be stored on [ITransaction.cashReceived] (prior + this tender).
DerivedSaleCompletionState deriveSaleCompletionState({
  required double transactionCashReceived,
  required double finalSubTotal,
  required List<PaymentLineForSaleCompletion> paymentMethods,
  double priorAlreadyPaidNonCredit = 0.0,
}) {
  var currentInstallment = transactionCashReceived;
  final sumFromPaymentLines = paymentMethods.fold<double>(
    0,
    (sum, p) => sum + p.amount,
  );

  // When explicit prior payments are known and there's a current tender, use
  // sumFromPaymentLines as the current-installment tender so prior payments are
  // counted separately below (avoids double-counting transactionCashReceived,
  // which for resumed loans holds the prior-paid amount stored in Ditto — or
  // the already-accumulated total after collectPayment mutates in memory).
  if (priorAlreadyPaidNonCredit > _paymentEpsilon &&
      sumFromPaymentLines > _paymentEpsilon) {
    currentInstallment = sumFromPaymentLines;
  } else if (currentInstallment <= _paymentEpsilon) {
    // Do not assume full payment when tender is unknown — that skipped loan/park.
    currentInstallment = sumFromPaymentLines > _paymentEpsilon
        ? sumFromPaymentLines
        : 0.0;
  } else if (sumFromPaymentLines > _paymentEpsilon &&
      sumFromPaymentLines + _paymentEpsilon < currentInstallment) {
    // Payment rows are authoritative when the received-amount field is stale
    // (auto-filled to full total while the user underpaid on the payment card).
    currentInstallment = sumFromPaymentLines;
  } else if (sumFromPaymentLines > _paymentEpsilon &&
      sumFromPaymentLines > currentInstallment + _paymentEpsilon) {
    // Payment rows show more than the cached cashReceived field — the field is
    // stale (e.g. item-add Ditto update hasn't propagated to the stream yet
    // while the in-memory payment methods already reflect the correct tender).
    // Use the authoritative in-memory value to avoid a spurious loan flag.
    currentInstallment = sumFromPaymentLines;
  }

  final totalCredit = paymentMethods
      .where((p) => p.method.toUpperCase() == 'CREDIT')
      .fold<double>(0, (sum, p) => sum + p.amount);

  final saleTotal = finalSubTotal;

  final installmentNonCreditRaw = currentInstallment - totalCredit;
  final installmentNonCredit =
      installmentNonCreditRaw < 0 ? 0.0 : installmentNonCreditRaw;

  // Cumulative non-credit paid after this tender (what cashReceived must store).
  final nonCreditCashReceived =
      installmentNonCredit + priorAlreadyPaidNonCredit;

  final remainingAfterAll = saleTotal - nonCreditCashReceived;
  final remainingClamped =
      remainingAfterAll < 0 ? 0.0 : remainingAfterAll;

  // Fully paid when cumulative non-credit covers the sale. Also treat a
  // sub-epsilon leftover as paid so we never park a ticket with remaining 0.
  final isFullyPaid =
      (nonCreditCashReceived + _paymentEpsilon) >= saleTotal ||
      (totalCredit <= _paymentEpsilon && remainingClamped <= _paymentEpsilon);

  // Credit lines always park; otherwise park only while money is still owed.
  final shouldBeLoan = totalCredit > _paymentEpsilon || !isFullyPaid;
  final status = shouldBeLoan
      ? saleCompletionStatusParked
      : saleCompletionStatusComplete;

  final remainingBalance = shouldBeLoan
      ? (totalCredit > _paymentEpsilon ? totalCredit : remainingClamped)
      : 0.0;

  return DerivedSaleCompletionState(
    shouldBeLoan: shouldBeLoan,
    status: status,
    remainingBalance: remainingBalance,
    nonCreditCashReceived: nonCreditCashReceived,
    effectiveCashReceived: currentInstallment,
    totalCredit: totalCredit,
  );
}

/// Scales non-CREDIT rows so their sum does not exceed [saleTotal] (matches PreviewCartMixin).
List<PaymentLineForSaleCompletion> normalizePaymentLinesToSaleTotal({
  required List<PaymentLineForSaleCompletion> paymentMethods,
  required double saleTotal,
  required bool shouldBeLoan,
}) {
  if (shouldBeLoan || saleTotal <= 0) return paymentMethods;

  final nonCredit = paymentMethods
      .where((p) => p.method.toUpperCase() != 'CREDIT')
      .toList();
  final sumNonCredit = nonCredit.fold<double>(0, (s, p) => s + p.amount);
  if (sumNonCredit <= saleTotal + 0.0001) return paymentMethods;

  final factor = saleTotal / sumNonCredit;
  final adjusted = <PaymentLineForSaleCompletion>[];
  for (final p in paymentMethods) {
    if (p.method.toUpperCase() == 'CREDIT') {
      adjusted.add(p);
      continue;
    }
    adjusted.add(
      PaymentLineForSaleCompletion(
        amount: _roundToTwoDecimalPlaces(p.amount * factor),
        method: p.method,
      ),
    );
  }

  var sumAdj = 0.0;
  for (final p in adjusted) {
    if (p.method.toUpperCase() != 'CREDIT') sumAdj += p.amount;
  }
  final drift = saleTotal - sumAdj;
  if (drift.abs() > 0.0001) {
    for (var i = adjusted.length - 1; i >= 0; i--) {
      if (adjusted[i].method.toUpperCase() == 'CREDIT') continue;
      final p = adjusted[i];
      adjusted[i] = PaymentLineForSaleCompletion(
        amount: _roundToTwoDecimalPlaces(p.amount + drift),
        method: p.method,
      );
      break;
    }
  }

  return adjusted;
}

String? _nonEmptyCustomerField(String? value) {
  final trimmed = value?.trim();
  if (trimmed == null || trimmed.isEmpty) return null;
  return trimmed;
}

/// Resolves customer name/phone for sale completion without wiping ticket fields.
///
/// Priority: non-empty box → typed controller name → denormalized transaction.
({String? name, String? phone}) resolveSaleCustomerFieldsForCompletion({
  String? boxName,
  String? boxPhone,
  String? controllerName,
  String? transactionName,
  String? transactionPhone,
  String? transactionSalePhone,
}) {
  return (
    name: _nonEmptyCustomerField(boxName) ??
        _nonEmptyCustomerField(controllerName) ??
        _nonEmptyCustomerField(transactionName),
    phone: _nonEmptyCustomerField(boxPhone) ??
        _nonEmptyCustomerField(transactionPhone) ??
        _nonEmptyCustomerField(transactionSalePhone),
  );
}
