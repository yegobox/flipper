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
DerivedSaleCompletionState deriveSaleCompletionState({
  required double transactionCashReceived,
  required double finalSubTotal,
  required List<PaymentLineForSaleCompletion> paymentMethods,
}) {
  var effectiveCashReceived = transactionCashReceived;
  final sumFromPaymentLines = paymentMethods.fold<double>(
    0,
    (sum, p) => sum + p.amount,
  );
  if (effectiveCashReceived <= _paymentEpsilon) {
    // Do not assume full payment when tender is unknown — that skipped loan/park.
    effectiveCashReceived = sumFromPaymentLines > _paymentEpsilon
        ? sumFromPaymentLines
        : 0.0;
  } else if (sumFromPaymentLines > _paymentEpsilon &&
      sumFromPaymentLines + _paymentEpsilon < effectiveCashReceived) {
    // Payment rows are authoritative when the received-amount field is stale
    // (auto-filled to full total while the user underpaid on the payment card).
    effectiveCashReceived = sumFromPaymentLines;
  }

  final totalCredit = paymentMethods
      .where((p) => p.method.toUpperCase() == 'CREDIT')
      .fold<double>(0, (sum, p) => sum + p.amount);

  final saleTotal = finalSubTotal;

  final nonCreditCashReceivedRaw = effectiveCashReceived - totalCredit;
  final nonCreditCashReceived = nonCreditCashReceivedRaw < 0
      ? 0.0
      : nonCreditCashReceivedRaw;
  final isFullyPaid = (nonCreditCashReceived + _paymentEpsilon) >= saleTotal;

  final shouldBeLoan = totalCredit > 0 || !isFullyPaid;
  final status = shouldBeLoan ? saleCompletionStatusParked : saleCompletionStatusComplete;

  final remainingBalance = shouldBeLoan
      ? (totalCredit > 0
            ? totalCredit
            : ((saleTotal - nonCreditCashReceived) < 0
                  ? 0.0
                  : (saleTotal - nonCreditCashReceived)))
      : 0.0;

  return DerivedSaleCompletionState(
    shouldBeLoan: shouldBeLoan,
    status: status,
    remainingBalance: remainingBalance,
    nonCreditCashReceived: nonCreditCashReceived,
    effectiveCashReceived: effectiveCashReceived,
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
