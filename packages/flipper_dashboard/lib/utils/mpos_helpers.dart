import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_services/payment_methods.dart';
import 'package:flutter/material.dart';
import 'package:flipper_dashboard/theme/pos_tokens.dart';
import 'package:flipper_dashboard/utils/split_tender.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:intl/intl.dart';

/// Stable 12-color palette from [design_handoff_mobile_pos/mpos/mpos-data.jsx].
const List<Color> _mposPalette = [
  Color(0xFF3B6FE0),
  Color(0xFF5457D6),
  Color(0xFF7A56E8),
  Color(0xFF9A5BC4),
  Color(0xFFC2557E),
  Color(0xFFC76B45),
  Color(0xFFB5893B),
  Color(0xFF5E8C3C),
  Color(0xFF2E9E83),
  Color(0xFF2C8FB0),
  Color(0xFF5B7488),
  Color(0xFF9A6248),
];

int _mposHash(String s) {
  var h = 0;
  for (var i = 0; i < s.length; i++) {
    h = (h * 31 + s.codeUnitAt(i)) & 0x7FFFFFFF;
  }
  return h;
}

Color mposColorForName(String name) {
  if (name.trim().isEmpty) return _mposPalette[0];
  return _mposPalette[_mposHash(name) % _mposPalette.length];
}

String mposAbbreviation(String name) {
  final parts = name.trim().split(RegExp(r'\s+'));
  if (parts.length >= 2) {
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }
  final t = name.trim();
  if (t.length >= 2) return t.substring(0, 2).toUpperCase();
  if (t.isNotEmpty) return t[0].toUpperCase();
  return '?';
}

/// Thousands-separated amount without currency symbol (handoff `mpMoney`).
String mposMoneyLabel(double amount) {
  final v = amount.round();
  return NumberFormat('#,###', 'en_US').format(v);
}

TextStyle mposMonoStyle(
  TextTheme textTheme, {
  double fontSize = 15,
  FontWeight fontWeight = FontWeight.w700,
  Color? color,
}) {
  return PosTokens.posMonoStyle(
    textTheme,
    fontSize: fontSize,
    fontWeight: fontWeight,
    color: color ?? PosTokens.ink1,
  );
}

String mposCheckoutTimeLabel(DateTime? createdAt) {
  final dt = createdAt ?? DateTime.now();
  final h = dt.hour.toString().padLeft(2, '0');
  final m = dt.minute.toString().padLeft(2, '0');
  return '$h:$m';
}

/// Prior non-credit payments already collected for a mobile checkout ticket.
///
/// Mirrors [QuickSellingView._effectiveAlreadyPaid]. [ITransaction.cashReceived]
/// is written synchronously as part of sale completion, while the
/// payment-records fetch behind [fetchedNonCreditPaid] is persisted in a
/// deferred/fire-and-forget write and can resolve to a stale/low value shortly
/// after a prior installment (or still be in flight). Floor the fetched value
/// with cashReceived on a resumed loan/layaway so a lagging fetch never
/// auto-fills the full sale total instead of the true remaining balance, or
/// makes `deriveSaleCompletionState` think an already-fully-paid ticket is
/// underpaid and re-park it. Never used for non-loan sales, where cashReceived
/// may just mirror the in-progress tender.
double mposAlreadyPaid(ITransaction transaction, double? fetchedNonCreditPaid) {
  final loanFloor = transaction.isLoan == true
      ? (transaction.cashReceived ?? 0.0)
      : 0.0;
  if (fetchedNonCreditPaid == null) return loanFloor;
  return fetchedNonCreditPaid > loanFloor ? fetchedNonCreditPaid : loanFloor;
}

/// Change and balance still due for a single cash tender, measured against
/// what was owed **before** this payment ([outstanding]).
///
/// Never against the balance left after the tender: that already has the
/// tender taken off, so change came out as the whole tender (RWF 1,600 change
/// on an exact 1,600 sale) and a short tender showed no balance due.
({double? change, double? due}) mposCashChangeAndDue({
  required double tender,
  required double outstanding,
}) {
  if (tender <= 0) return (change: null, due: null);
  final diff = tender - outstanding;
  return (change: diff > 0.01 ? diff : null, due: diff < -0.01 ? -diff : null);
}

/// Cash handed over on a single cash line: what was typed, or the
/// pre-filled exact amount when nothing larger was.
double mposCashTenderAmount(List<Payment> payments) {
  if (payments.isEmpty) return 0;
  final p = payments.first;
  final typed = double.tryParse(p.controller.text) ?? 0.0;
  return typed > p.amount ? typed : p.amount;
}

/// What the checkout's payment lines come to against [outstanding] (owed
/// before this payment): Totals' change and balance due, and whether the
/// tender lets Charge go ahead.
///
/// Several lines mean the cashier split the payment, and the split decides;
/// one cash line needs the whole bill; any other single tender pays it all.
({bool isCash, double? change, double? due, bool tenderOk}) mposCheckoutTender(
  List<Payment> payments,
  double outstanding,
) {
  if (payments.length > 1) {
    final split = splitSummary(mposSplitTenders(payments), outstanding);
    return (
      isCash: false,
      change: split.change > 0.01 ? split.change : null,
      due: split.remaining > 0.01 ? split.remaining : null,
      tenderOk: split.canConfirm,
    );
  }
  final isCash =
      payments.isNotEmpty && payments.first.method.toUpperCase() == 'CASH';
  if (!isCash) return (isCash: false, change: null, due: null, tenderOk: true);
  final tender = mposCashTenderAmount(payments);
  final r = mposCashChangeAndDue(tender: tender, outstanding: outstanding);
  return (
    isCash: true,
    change: r.change,
    due: r.due,
    tenderOk: tender >= outstanding - 0.01,
  );
}

/// The split payment lines as tenders for [splitSummary].
List<SplitTender> mposSplitTenders(List<Payment> payments) => [
  for (final p in payments) SplitTender(method: p.method, amount: p.amount),
];

/// A split written back as the lines that get saved: one per tender that
/// carries money, cash net of change, so the payment rows and the Cash Book
/// add up to the sale. Each line keeps its row's id, controller and payer.
List<Payment> mposSplitSavedLines(List<Payment> payments, SplitSummary split) {
  final byMethod = {for (final p in payments) p.method: p};
  return [
    for (final line in split.paymentLines)
      Payment(
        amount: line.amount,
        method: line.method,
        id: byMethod[line.method]?.id,
        controller: byMethod[line.method]?.controller,
        payerName: byMethod[line.method]?.payerName,
      ),
  ];
}

/// The split's lines as the cashier left them, for putting back when a charge
/// fails after [mposSplitSavedLines] replaced them (a declined MoMo part):
/// otherwise the retry shows the cash net of change, and no change.
///
/// Each call builds fresh controllers holding the typed text, because the
/// saved lines may have dropped a row, and with it disposed its controller.
List<Payment> Function() mposSplitRestorer(List<Payment> payments) {
  final rows = [
    for (final p in payments)
      (
        amount: p.amount,
        method: p.method,
        id: p.id,
        payerName: p.payerName,
        text: p.controller.text,
      ),
  ];
  return () => [
    for (final r in rows)
      Payment(
        amount: r.amount,
        method: r.method,
        id: r.id,
        payerName: r.payerName,
        controller: TextEditingController(text: r.text),
      ),
  ];
}

/// Charge on a split saves its lines net of change ([mposSplitSavedLines]).
///
/// Returns what puts the cashier's own lines back after a failed charge, or
/// null when [payments] is not a split. That does nothing once something else
/// replaced the lines: a completed sale resets them for the next cart.
VoidCallback? mposSaveSplitForCharge({
  required List<Payment> payments,
  required double owed,
  required List<Payment> Function() readLines,
  required void Function(List<Payment>) writeLines,
}) {
  if (payments.length < 2) return null;
  final restore = mposSplitRestorer(payments);
  final saved = mposSplitSavedLines(
    payments,
    splitSummary(mposSplitTenders(payments), owed),
  );
  writeLines(saved);
  return () {
    if (identical(readLines(), saved)) writeLines(restore());
  };
}

/// Cash handed over and change for the success screen, measured against
/// [owed] (what was still owed before this payment), as the Totals card does.
/// Both null when the sale gives no cash change to show.
({double? tendered, double? change}) mposChargedCash(
  List<Payment> payments,
  double owed,
) {
  if (payments.length > 1) {
    final change = splitSummary(mposSplitTenders(payments), owed).change;
    if (change <= 0.01) return (tendered: null, change: null);
    return (tendered: owed + change, change: change);
  }
  if (payments.isEmpty || payments.first.method.toUpperCase() != 'CASH') {
    return (tendered: null, change: null);
  }
  // Exact cash (nothing typed) tenders what was owed, so change is zero.
  final tender = mposCashTenderAmount(payments);
  final handed = tender < owed ? owed : tender;
  return (tendered: handed, change: handed - owed);
}

/// Whether the sale asks a phone for MoMo. One line is MoMo by its method
/// alone (it pays the whole bill); in a split only a MoMo row carrying money
/// counts, so a row just added at zero does not ask for a phone.
bool mposHasMomoTender(List<Payment> payments) {
  bool isMomo(Payment p) => canonicalPaymentMethod(p.method) == kMobileMoney;
  if (payments.length == 1) return isMomo(payments.first);
  return payments.any((p) => isMomo(p) && p.amount > 0.01);
}

/// The label a mobile checkout shows for one tender.
String mposTenderLabel(FlipperAppLocalizations l10n, String method) {
  final m = method.toUpperCase();
  if (canonicalPaymentMethod(m) == kMobileMoney) return 'MoMo';
  if (m.contains('CARD')) return l10n.paymentsTypeCard;
  if (m.contains('BANK')) return l10n.paymentsTypeBank;
  if (m == 'CREDIT') return l10n.credit;
  return l10n.cash;
}

/// "Cash + MoMo" for a split payment, else the one tender's label.
String mposTendersLabel(FlipperAppLocalizations l10n, List<Payment> payments) {
  final labels = <String>{
    for (final p in payments)
      if (payments.length == 1 || p.amount > 0.01)
        mposTenderLabel(l10n, p.method),
  };
  return labels.isEmpty ? l10n.cash : labels.join(' + ');
}

/// Which cart has a payment read that mobile checkout may trust for Transfer.
///
/// Every read takes a ticket from [start]; only the newest ticket may set
/// [txnId]. [invalidate] (a charge starting) clears [txnId] and voids every
/// read still in flight, so a pre-charge "nothing paid" can never land late.
class MposPaidRead {
  String? txnId;
  int _generation = 0;

  int start() => ++_generation;

  bool isCurrent(int ticket) => ticket == _generation;

  void invalidate() {
    txnId = null;
    _generation++;
  }
}
