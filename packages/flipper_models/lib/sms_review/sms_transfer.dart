import 'package:flipper_accounting/accounting_models.dart';
import 'package:flipper_accounting/liquid_accounts.dart';
import 'package:flipper_models/sms_review/sms_review_item.dart';

/// The business's own money accounts an SMS can move money between: cash on
/// hand, Bank and Mobile Money (the seeded chart of accounts), plus each
/// bank's and wallet's own account (`liquid_accounts.dart`).
const kSmsCashAccount = kCashAccountCode;
const kSmsBankAccount = kBankAccountCode;
const kSmsMobileMoneyAccount = kMobileMoneyAccountCode;
const kSmsTransferAccounts = [
  kSmsCashAccount,
  kSmsBankAccount,
  kSmsMobileMoneyAccount,
];

/// English account name for the persisted memo, which every user of the
/// business reads whatever their UI language.
String smsAccountName(String code) => switch (code) {
  kSmsCashAccount => 'Cash',
  kSmsBankAccount => 'Bank',
  kSmsMobileMoneyAccount => 'Mobile Money',
  _ => providerAccountFor(code)?.providerLabel ?? code,
};

/// Where the money could have gone to (money out) or come from (money in):
/// cash, Bank, Mobile Money and every bank or wallet account on the chart
/// ([chartCodes]), except the one the SMS is about. A journal line is keyed
/// by account code, so a move within one account has no entry to post.
/// [counterpart]'s account is offered even before its chart entry syncs.
List<String> smsTransferTargets(
  SmsReviewItem item, {
  Iterable<String> chartCodes = const [],
  SmsReviewItem? counterpart,
}) {
  final codes = <String>{
    ...kSmsTransferAccounts,
    ...chartCodes.where(isLiquidAccount),
    ?counterpart?.bankAccountCode,
  }..remove(item.bankAccountCode);
  return codes.toList()..sort();
}

/// Deterministic, so a retry or a second till converges on one entry.
String smsTransferEntryId(String smsId) => 'je_smsxfer_$smsId';

/// The transfer as a balanced entry: money out of the SMS's account is
/// Dr [otherAccountCode] / Cr own; money in is Dr own / Cr other. Mirrors
/// Books' bank-rec adjustments, so both read the same in the ledger.
JournalEntry smsTransferEntry(
  SmsReviewItem item,
  String otherAccountCode, {
  JournalStatus status = JournalStatus.posted,
}) => _moveEntry(
  item,
  otherAccountCode,
  refPrefix: 'XFER',
  memo:
      'Transfer · ${item.providerLabel} ${item.isIncome ? 'from' : 'to'} '
      '${smsAccountName(otherAccountCode)}',
  status: status,
);

/// Deterministic, like [smsTransferEntryId].
String smsClearingEntryId(String smsId) => 'je_smsclear_$smsId';

/// The clearing account reviewed money first lands in: a Cash Book movement,
/// a linked sale or a debt repayment posts to Bank (1020) or Mobile Money
/// (1030) by its payment method, which never says which bank or wallet.
/// Null when the SMS's own account is that clearing account (an SMS written
/// before each bank had its own account): nothing is left to move.
String? smsClearingAccount(SmsReviewItem item) {
  final group = liquidGroupOf(item.bankAccountCode);
  return group == item.bankAccountCode ? null : group;
}

/// Moves the money from [smsClearingAccount] into the SMS's own account, as
/// a bank feed clears deposits: money in is Dr own / Cr clearing, money out
/// Dr clearing / Cr own. Null when there is nothing to move.
JournalEntry? smsClearingEntry(SmsReviewItem item) {
  final clearing = smsClearingAccount(item);
  if (clearing == null) return null;
  return _moveEntry(
    item,
    clearing,
    refPrefix: 'CLR',
    memo:
        '${item.providerLabel} · cleared ${item.isIncome ? 'from' : 'to'} '
        '${smsAccountName(clearing)}',
  );
}

JournalEntry _moveEntry(
  SmsReviewItem item,
  String otherAccountCode, {
  required String refPrefix,
  required String memo,
  JournalStatus status = JournalStatus.posted,
}) {
  final own = item.bankAccountCode;
  final ref =
      '$refPrefix-${item.id.replaceAll(RegExp('[^A-Za-z0-9]'), '').padRight(8, '0').substring(0, 8).toUpperCase()}';
  return JournalEntry(
    id: ref,
    date:
        item.lineDate ??
        item.occurredAt?.substring(0, 10) ??
        DateTime.now().toIso8601String().substring(0, 10),
    memo: memo,
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
