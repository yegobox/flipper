import 'package:flipper_models/domain/party/party_validation.dart';
import 'package:flipper_models/sms_review/sms_review_item.dart';

const _epsilon = 0.01;

/// A credit sale still owed, that an incoming SMS may be repaying.
class SmsDebtCandidate {
  const SmsDebtCandidate({
    required this.transactionId,
    required this.remainingBalance,
    this.customerName,
    this.customerPhone,
    this.createdAt,
  });

  final String transactionId;
  final double remainingBalance;
  final String? customerName;
  final String? customerPhone;
  final DateTime? createdAt;

  factory SmsDebtCandidate.fromDitto(Map<String, dynamic> doc) {
    final remaining = doc['remainingBalance'];
    String? text(String key) {
      final v = doc[key]?.toString().trim();
      return v == null || v.isEmpty ? null : v;
    }

    return SmsDebtCandidate(
      transactionId: (doc['_id'] ?? doc['id'] ?? '').toString(),
      remainingBalance: remaining is num ? remaining.toDouble() : 0,
      customerName: text('customerName'),
      customerPhone: text('customerPhone'),
      createdAt: DateTime.tryParse(doc['createdAt']?.toString() ?? ''),
    );
  }

  /// `****0123`, for telling two customers with one name apart.
  String? get phoneHint {
    final digits = normalizePartyPhone(customerPhone);
    return digits.length < 4
        ? null
        : '****${digits.substring(digits.length - 4)}';
  }
}

/// Whether [item] could repay a debt at all: money in, not a charge.
bool smsCanSettleDebt(SmsReviewItem item) => item.isIncome && !item.isFee;

/// The last 4 digits the SMS shows of the payer's number (`****0123`).
String? _payerLastFour(SmsReviewItem item) {
  final digits = (item.counterpartyAccount ?? '').replaceAll(RegExp(r'\D'), '');
  return digits.length < 4 ? null : digits.substring(digits.length - 4);
}

Set<String> _nameWords(String? name) => {
  for (final w in (name ?? '').toLowerCase().split(RegExp(r'[^a-z]+')))
    if (w.length >= 3) w,
};

/// The open debts [item] may be repaying, most likely first.
///
/// A debt qualifies when the SMS's amount does not exceed what is still owed
/// and the payer looks like the customer: the last 4 digits of the payer's
/// number match the customer's phone, or they share a name (a word of 3+
/// letters). Both together rank first; then a debt the SMS clears exactly.
List<SmsDebtCandidate> smsMatchingDebts(
  SmsReviewItem item,
  Iterable<SmsDebtCandidate> candidates,
) {
  if (!smsCanSettleDebt(item)) return const [];
  final lastFour = _payerLastFour(item);
  final payerWords = _nameWords(item.counterpartyName);

  int score(SmsDebtCandidate c) {
    final phone = normalizePartyPhone(c.customerPhone);
    final phoneHit = lastFour != null && phone.endsWith(lastFour);
    final nameHit = _nameWords(c.customerName).any(payerWords.contains);
    return (phoneHit ? 2 : 0) + (nameHit ? 1 : 0);
  }

  final scored = [
    for (final c in candidates)
      if (c.transactionId.isNotEmpty &&
          c.remainingBalance > _epsilon &&
          item.amount <= c.remainingBalance + _epsilon)
        (candidate: c, score: score(c)),
  ].where((s) => s.score > 0).toList();

  double gap(SmsDebtCandidate c) => (c.remainingBalance - item.amount).abs();
  scored.sort((a, b) {
    final byScore = b.score.compareTo(a.score);
    return byScore != 0
        ? byScore
        : gap(a.candidate).compareTo(gap(b.candidate));
  });
  return [for (final s in scored) s.candidate];
}

/// What a repayment of [amount] does to a loan, as a POS installment would:
/// the cumulative amount collected, what is still owed, and whether the sale
/// stays a loan.
({double cashReceived, double remaining, bool stillLoan}) applySmsRepayment({
  required double cashReceived,
  required double remaining,
  required double amount,
}) {
  final left = remaining - amount;
  final stillLoan = left > _epsilon;
  return (
    cashReceived: cashReceived + amount,
    remaining: stillLoan ? left : 0,
    stillLoan: stillLoan,
  );
}

/// The id of the entry the data-connector posts for a loan repayment
/// (`poster::post_loan_payments`): keyed by the payment record's `createdAt`
/// in milliseconds.
String smsLoanPaymentEntryId(
  String businessId,
  String transactionId,
  DateTime paidAt,
) => 'je_${businessId}_${transactionId}_pay_${paidAt.millisecondsSinceEpoch}';
