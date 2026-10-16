import 'package:flipper_accounting/accounting_models.dart';
import 'package:flipper_models/sms_review/sms_review_item.dart';

/// The business's own money accounts an SMS can move money between: cash on
/// hand, bank, mobile money (the seeded chart of accounts).
const kSmsCashAccount = '1010';
const kSmsBankAccount = '1020';
const kSmsMobileMoneyAccount = '1030';
const kSmsTransferAccounts = [
  kSmsCashAccount,
  kSmsBankAccount,
  kSmsMobileMoneyAccount,
];

/// English account names for the persisted memo, which every user of the
/// business reads whatever their UI language.
const _accountNames = {
  kSmsCashAccount: 'Cash',
  kSmsBankAccount: 'Bank',
  kSmsMobileMoneyAccount: 'Mobile Money',
};

/// Where the money could have gone to (money out) or come from (money in):
/// every own account except the one the SMS is about. A journal line is keyed
/// by account code, so a move within one account has no entry to post.
List<String> smsTransferTargets(SmsReviewItem item) => [
  for (final code in kSmsTransferAccounts)
    if (code != item.bankAccountCode) code,
];

/// Deterministic, so a retry or a second till converges on one entry.
String smsTransferEntryId(String smsId) => 'je_smsxfer_$smsId';

/// The transfer as a balanced entry: money out of the SMS's account is
/// Dr [otherAccountCode] / Cr own; money in is Dr own / Cr other. Mirrors
/// Books' bank-rec adjustments, so both read the same in the ledger.
JournalEntry smsTransferEntry(
  SmsReviewItem item,
  String otherAccountCode, {
  JournalStatus status = JournalStatus.posted,
}) {
  final own = item.bankAccountCode;
  final other = _accountNames[otherAccountCode] ?? otherAccountCode;
  final ref =
      'XFER-${item.id.replaceAll(RegExp('[^A-Za-z0-9]'), '').padRight(8, '0').substring(0, 8).toUpperCase()}';
  return JournalEntry(
    id: ref,
    date:
        item.lineDate ??
        item.occurredAt?.substring(0, 10) ??
        DateTime.now().toIso8601String().substring(0, 10),
    memo:
        'Transfer · ${item.providerLabel} ${item.isIncome ? 'from' : 'to'} $other',
    ref: ref,
    status: status,
    src: 'SMS',
    lines: status == JournalStatus.posted
        ? [
            JournalLine(
              ac: item.isIncome ? own : otherAccountCode,
              dr: item.amount,
            ),
            JournalLine(
              ac: item.isIncome ? otherAccountCode : own,
              cr: item.amount,
            ),
          ]
        : const [],
  );
}

/// The SMS the other account sent for the same move: Equity "money out
/// 25,000" and MoMo "money in 25,000" a few minutes apart. Closed with the
/// transfer so the move is not counted twice. Its account is the transfer's
/// other side, so it must differ from [item]'s. Nearest in time wins.
SmsReviewItem? findTransferCounterpart(
  SmsReviewItem item,
  Iterable<SmsReviewItem> pending,
) {
  final at = item.occurredAtDate;
  SmsReviewItem? best;
  Duration? bestGap;
  for (final other in pending) {
    if (other.id == item.id ||
        other.isFee ||
        other.isIncome == item.isIncome ||
        other.amount != item.amount ||
        other.bankAccountCode == item.bankAccountCode) {
      continue;
    }
    final otherAt = other.occurredAtDate;
    final gap = at == null || otherAt == null
        ? const Duration(days: 1)
        : at.difference(otherAt).abs();
    if (gap > const Duration(days: 1)) continue;
    if (bestGap == null || gap < bestGap) {
      best = other;
      bestGap = gap;
    }
  }
  return best;
}
