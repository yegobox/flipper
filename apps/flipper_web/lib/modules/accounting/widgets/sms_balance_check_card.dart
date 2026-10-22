import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_web/modules/accounting/data/accounting_derive.dart';
import 'package:flipper_web/modules/accounting/data/accounting_models.dart';
import 'package:flipper_web/modules/accounting/data/services/bank_balance_service.dart';
import 'package:flipper_web/modules/accounting/theme/accounting_tokens.dart';
import 'package:flipper_web/modules/accounting/widgets/accounting_page_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

/// The bank's own balance (from its SMS) against the Books ledger.
///
/// SMS lines nobody has matched yet are money the bank already counts and
/// Books does not, so they explain that much of the gap; whatever is left is
/// the unexplained difference an adjustment can close.
class SmsBalanceCheck {
  SmsBalanceCheck({
    required this.bank,
    required this.books,
    required List<BankLine> lines,
  }) : pendingLines = lines.where((l) => l.isFromSms && !l.matched).toList();

  final int bank;
  final int books;
  final List<BankLine> pendingLines;

  int get pendingNet => pendingLines.fold(0, (s, l) => s + l.amt);
  int get difference => bank - books;
  int get unexplained => difference - pendingNet;
}

String smsBalanceTime(DateTime at) => DateFormat('d MMM, HH:mm').format(at);

class SmsBalanceCheckCard extends StatefulWidget {
  const SmsBalanceCheckCard({
    super.key,
    required this.total,
    required this.accounts,
    required this.check,
    required this.onPostAdjustment,
    required this.onSaveAlert,
    this.alert,
    this.gaps = const [],
  });

  final SmsBalanceTotal total;
  final List<SmsAccountBalance> accounts;
  final SmsBalanceCheck check;
  final SmsBalanceAlert? alert;

  /// Where SMS seem to be missing on this account, newest last.
  final List<SmsBalanceGap> gaps;

  /// Posts an entry moving Books by the unexplained difference.
  final void Function(int amount) onPostAdjustment;

  /// Saves the low-balance alert level; completes when it is stored.
  final Future<void> Function(int threshold) onSaveAlert;

  @override
  State<SmsBalanceCheckCard> createState() => _SmsBalanceCheckCardState();
}

class _SmsBalanceCheckCardState extends State<SmsBalanceCheckCard> {
  late final TextEditingController _threshold = TextEditingController(
    text: widget.alert == null ? '' : '${widget.alert!.threshold}',
  );
  bool _saving = false;

  @override
  void dispose() {
    _threshold.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final value = int.tryParse(_threshold.text.trim());
    if (value == null) return;
    setState(() => _saving = true);
    try {
      await widget.onSaveAlert(value);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Widget _row(String label, int amount, {bool strong = false, Key? key}) {
    return Padding(
      key: key,
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: AccountingTokens.sans(
                fontSize: 13.5,
                fontWeight: strong ? FontWeight.w700 : FontWeight.w500,
                color: strong ? AccountingTokens.ink1 : AccountingTokens.ink2,
              ),
            ),
          ),
          Text(
            money(amount),
            style: AccountingTokens.mono(
              fontSize: 13.5,
              fontWeight: strong ? FontWeight.w700 : FontWeight.w600,
              color: amount < 0
                  ? AccountingTokens.lossInk
                  : AccountingTokens.ink1,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.flipperL10n;
    final check = widget.check;
    final muted = AccountingTokens.sans(
      fontSize: 12.5,
      color: AccountingTokens.ink3,
    );
    return AccountingCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AccountingCardHeader(
            title: l10n.booksSmsBalanceCheck,
            subtitle: l10n.booksSmsBalanceSubtitle(
              smsBalanceTime(widget.total.observedAt),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _row(l10n.booksSmsBalanceBank, check.bank),
                if (widget.accounts.length > 1)
                  for (final a in widget.accounts)
                    Padding(
                      padding: const EdgeInsets.only(left: 12),
                      child: Text(
                        '${a.label} · ${money(a.balance)} · ${smsBalanceTime(a.observedAt)}',
                        style: muted,
                      ),
                    ),
                _row(l10n.booksSmsBalanceBooks, check.books),
                const Divider(height: 16),
                _row(
                  l10n.booksSmsBalanceDifference,
                  check.difference,
                  strong: true,
                  key: const Key('sms-balance-difference'),
                ),
                if (check.pendingLines.isNotEmpty)
                  Text(
                    l10n.booksSmsBalancePending(
                      '${check.pendingLines.length}',
                      money(check.pendingNet, sign: true),
                    ),
                    style: muted,
                  ),
                const SizedBox(height: 6),
                if (check.unexplained == 0)
                  Row(
                    children: [
                      const Icon(
                        Icons.check_circle_outline,
                        size: 16,
                        color: AccountingTokens.gainInk,
                      ),
                      const SizedBox(width: 6),
                      Text(l10n.booksSmsBalanceAgrees, style: muted),
                    ],
                  )
                else
                  Row(
                    children: [
                      Expanded(
                        child: _row(
                          l10n.booksSmsBalanceUnexplained,
                          check.unexplained,
                          strong: true,
                          key: const Key('sms-balance-unexplained'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      AccountingButton(
                        key: const Key('sms-balance-adjust'),
                        label: l10n.booksSmsBalancePostAdjustment,
                        small: true,
                        onPressed: () =>
                            widget.onPostAdjustment(check.unexplained),
                      ),
                    ],
                  ),
                if (widget.gaps.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  for (final g in widget.gaps.reversed.take(3))
                    Text(
                      (g.amount < 0
                          ? l10n.booksSmsBalanceGapOut
                          : l10n.booksSmsBalanceGapIn)(
                        money(g.amount.abs()),
                        smsBalanceTime(g.after),
                        smsBalanceTime(g.before),
                      ),
                      style: muted,
                    ),
                  Text(
                    l10n.booksSmsBalanceGapHint,
                    key: const Key('sms-balance-gap-hint'),
                    style: AccountingTokens.sans(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                      color: AccountingTokens.lossInk,
                    ),
                  ),
                ],
                if (widget.total.stale) ...[
                  const SizedBox(height: 6),
                  Text(
                    l10n.booksSmsBalanceStale,
                    key: const Key('sms-balance-stale'),
                    style: AccountingTokens.sans(
                      fontSize: 12.5,
                      color: AccountingTokens.lossInk,
                    ),
                  ),
                ],
                const SizedBox(height: 12),
                Row(
                  children: [
                    Flexible(
                      child: Text(l10n.booksSmsBalanceAlertLabel, style: muted),
                    ),
                    const SizedBox(width: 8),
                    SizedBox(
                      width: 130,
                      child: TextField(
                        key: const Key('sms-balance-alert-field'),
                        controller: _threshold,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        decoration: const InputDecoration(
                          isDense: true,
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    AccountingButton(
                      key: const Key('sms-balance-alert-save'),
                      label: l10n.save,
                      small: true,
                      primary: true,
                      isLoading: _saving,
                      onPressed: _saving ? null : _save,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
