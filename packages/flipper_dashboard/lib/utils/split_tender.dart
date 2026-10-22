import 'dart:math' as math;

import 'package:flipper_models/helperModels/sale_completion_helpers.dart';
import 'package:flipper_services/payment_methods.dart';

/// Tender math for a bill paid several ways (part cash, part MoMo, part card),
/// kept free of widgets so it can be tested. Shared by the bar settle screens
/// and the mobile POS checkout.
///
/// A bill paid one way is just a list with one tender, so a split bill and a
/// plain one go through the same code.

const double _epsilon = 0.01;

/// Cash is the only tender that gives change; [canonicalPaymentMethod] keeps
/// both bar's `Cash` and the POS's `CASH` as they are.
bool splitTenderIsCash(String method) =>
    canonicalPaymentMethod(method).toUpperCase() == 'CASH';

class SplitTender {
  const SplitTender({required this.method, this.amount = 0});

  final String method;
  final double amount;

  SplitTender copyWith({String? method, double? amount}) =>
      SplitTender(method: method ?? this.method, amount: amount ?? this.amount);
}

class SplitSummary {
  const SplitSummary({
    required this.total,
    required this.paid,
    required this.nonCash,
    required this.primaryMethod,
    required this.paymentLines,
  });

  final double total;

  /// Everything handed over, cash before change.
  final double paid;

  /// The MoMo/card part. Change only ever comes out of cash, so this can never
  /// exceed the bill.
  final double nonCash;

  /// What the sale and its RRA receipt are filed under: the first tender that
  /// carries money, as the POS does for a split sale.
  final String primaryMethod;

  /// One payment row per tender, with the change taken off the cash, so the
  /// rows add up to exactly [total].
  final List<PaymentLineForSaleCompletion> paymentLines;

  double get remaining => math.max(0, total - paid);

  double get change => math.max(0, paid - total);

  bool get nonCashOverTotal => nonCash > total + _epsilon;

  bool get canConfirm => remaining <= _epsilon && !nonCashOverTotal;
}

/// Sums [tenders] against a bill of [total].
///
/// A single non-cash tender pays the whole bill without an amount being typed:
/// the cashier only picks MoMo or card, exactly as before split payment existed,
/// and the bill can still grow while the payment screen is open.
SplitSummary splitSummary(List<SplitTender> tenders, double total) {
  final effective =
      tenders.length == 1 && !splitTenderIsCash(tenders.first.method)
      ? [tenders.first.copyWith(amount: total)]
      : tenders;

  var paid = 0.0;
  var nonCash = 0.0;
  for (final t in effective) {
    final amount = math.max(0.0, t.amount);
    paid += amount;
    if (!splitTenderIsCash(t.method)) nonCash += amount;
  }

  // Change comes back out of the cash, last cash tender first.
  var change = math.max(0.0, paid - total);
  final amounts = [for (final t in effective) math.max(0.0, t.amount)];
  for (var i = effective.length - 1; i >= 0 && change > 0; i--) {
    if (!splitTenderIsCash(effective[i].method)) continue;
    final taken = math.min(change, amounts[i]);
    amounts[i] -= taken;
    change -= taken;
  }

  final lines = <PaymentLineForSaleCompletion>[
    for (var i = 0; i < effective.length; i++)
      if (amounts[i] > _epsilon)
        PaymentLineForSaleCompletion(
          amount: amounts[i],
          method: effective[i].method,
        ),
  ];

  final withMoney = effective.where((t) => t.amount > _epsilon);
  final primary = withMoney.isNotEmpty
      ? withMoney.first.method
      : (effective.isNotEmpty ? effective.first.method : 'CASH');

  return SplitSummary(
    total: total,
    paid: paid,
    nonCash: nonCash,
    primaryMethod: primary,
    paymentLines: lines,
  );
}

/// Re-balances a split so it adds up to [total], the way the POS split card
/// does: the last tender takes whatever is unpaid, or the first one while the
/// last is the one being typed into. Lets the cashier type a single figure.
List<SplitTender> rebalanceSplit(
  List<SplitTender> tenders,
  double total, {
  int? editedIndex,
}) {
  if (tenders.length < 2) return tenders;
  var fill = tenders.length - 1;
  if (editedIndex == fill) fill = 0;
  var others = 0.0;
  for (var i = 0; i < tenders.length; i++) {
    if (i != fill) others += math.max(0.0, tenders[i].amount);
  }
  return [
    for (var i = 0; i < tenders.length; i++)
      i == fill
          ? tenders[i].copyWith(amount: math.max(0.0, total - others))
          : tenders[i],
  ];
}

/// The first of [methods] not yet in [tenders], or null when every method is
/// already on the bill.
String? unusedSplitMethod(List<SplitTender> tenders, List<String> methods) {
  final used = tenders.map((t) => t.method).toSet();
  for (final method in methods) {
    if (!used.contains(method)) return method;
  }
  return null;
}

/// Turns a one-tender bill into a split, or adds one more tender to a split.
///
/// The new tender starts with whatever is still unpaid. A single MoMo or card
/// tender pays the whole bill implicitly, so it starts the split at zero and
/// the new tender takes the full bill until the cashier types the MoMo part.
/// The new tender is the first of [methods] not yet used. Returns null when
/// every method is already on the bill.
List<SplitTender>? addSplitTender(
  List<SplitTender> tenders,
  double total, {
  required List<String> methods,
}) {
  final method = unusedSplitMethod(tenders, methods);
  if (method == null) return null;
  final base = tenders.length == 1 && !splitTenderIsCash(tenders.first.method)
      ? [tenders.first.copyWith(amount: 0)]
      : tenders;
  return rebalanceSplit([...base, SplitTender(method: method)], total);
}

/// [tenders] without the one at [index], re-balanced.
List<SplitTender> removeSplitTender(
  List<SplitTender> tenders,
  int index,
  double total,
) {
  final rest = [...tenders]..removeAt(index);
  return rebalanceSplit(rest, total);
}
