import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_web/modules/accounting/data/accounting_derive.dart';
import 'package:flipper_web/modules/accounting/data/accounting_providers.dart';
import 'package:flipper_web/modules/accounting/data/services/vat_position_service.dart';
import 'package:flipper_web/modules/accounting/theme/accounting_tokens.dart';
import 'package:flipper_web/modules/accounting/widgets/accounting_page_header.dart';
import 'package:flipper_web/modules/accounting/widgets/accounting_switch.dart';
import 'package:flipper_web/modules/accounting/widgets/accounting_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Where the business stands on VAT, on the Books dashboard.
///
/// - Registered (EBM branch, or "Registered for VAT" on): VAT Payable from
///   the ledger.
/// - Not registered: it owes none; an estimate of the VAT in its sales, the
///   VAT it paid on purchases, and its turnover against RRA's registration
///   threshold. None of that is in the ledger.
///
/// Without an EBM branch the card also holds the "Registered for VAT"
/// setting. Nothing shows while the position cannot be read.
class BooksVatCard extends ConsumerWidget {
  const BooksVatCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final position = ref.watch(booksVatPositionProvider).value;
    if (position == null) return const SizedBox.shrink();
    final l10n = context.flipperL10n;
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: AccountingCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AccountingCardHeader(title: l10n.booksVatTitle),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (position.registered)
                    _RegisteredBody(position: position)
                  else
                    _EstimateBody(position: position),
                  if (!position.hasEbmBranch) ...[
                    const Divider(height: 24, color: AccountingTokens.line),
                    _RegisteredSetting(position: position),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RegisteredBody extends StatelessWidget {
  const _RegisteredBody({required this.position});

  final BooksVatPosition position;

  @override
  Widget build(BuildContext context) {
    final l10n = context.flipperL10n;
    // Without the ledger figure, vatOwed is only the default 0: say so
    // instead of showing "VAT payable 0".
    if (!position.hasEstimate) {
      return Text(
        l10n.booksVatLedgerUnavailable,
        style: AccountingTokens.sans(
          fontSize: 12.5,
          color: AccountingTokens.ink3,
        ),
      );
    }
    final credit = position.vatOwed < 0;
    return _Figure(
      label: credit ? l10n.booksVatCreditLedger : l10n.booksVatOwedLedger,
      value: money(position.vatOwed.abs()),
      color: credit ? AccountingTokens.gainInk : AccountingTokens.ink1,
    );
  }
}

class _EstimateBody extends StatelessWidget {
  const _EstimateBody({required this.position});

  final BooksVatPosition position;

  @override
  Widget build(BuildContext context) {
    final l10n = context.flipperL10n;
    final share = position.annualThreshold <= 0
        ? 0.0
        : (position.turnover12m / position.annualThreshold).clamp(0.0, 1.0);
    final (Color barColor, String? warning) = switch (position.threshold) {
      VatThreshold.crossed => (
        AccountingTokens.loss,
        l10n.booksVatThresholdCrossed,
      ),
      VatThreshold.near => (
        AccountingTokens.warnAmber,
        l10n.booksVatThresholdNear,
      ),
      VatThreshold.none => (AccountingTokens.accent, null),
    };
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.booksVatNotRegistered,
          style: AccountingTokens.sans(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: AccountingTokens.gainInk,
          ),
        ),
        if (position.hasEstimate) ...[
          const SizedBox(height: 12),
          Wrap(
            spacing: 24,
            runSpacing: 12,
            children: [
              _Figure(
                label: l10n.booksVatEstimateSales,
                value: money(position.monthEstimatedOutputVat),
              ),
              _Figure(
                label: l10n.booksVatPaidPurchases,
                value: money(position.monthPurchaseVat),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            l10n.booksVatTurnover12m(
              money(position.turnover12m),
              money(position.annualThreshold),
            ),
            style: AccountingTokens.sans(
              fontSize: 12.5,
              color: AccountingTokens.ink2,
            ),
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: share,
              minHeight: 6,
              color: barColor,
              backgroundColor: AccountingTokens.surface2,
            ),
          ),
          if (warning != null) ...[
            const SizedBox(height: 10),
            Text(
              warning,
              style: AccountingTokens.sans(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: barColor,
              ),
            ),
          ],
          const SizedBox(height: 10),
          Text(
            l10n.booksVatEstimateNote,
            style: AccountingTokens.sans(
              fontSize: 12,
              color: AccountingTokens.ink3,
            ),
          ),
        ],
      ],
    );
  }
}

class _Figure extends StatelessWidget {
  const _Figure({required this.label, required this.value, this.color});

  final String label;
  final String value;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: AccountingTokens.sans(
            fontSize: 12.5,
            color: AccountingTokens.ink2,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: AccountingTokens.mono(
            fontSize: 19,
            fontWeight: FontWeight.w800,
            color: color ?? AccountingTokens.ink1,
          ),
        ),
      ],
    );
  }
}

class _RegisteredSetting extends ConsumerStatefulWidget {
  const _RegisteredSetting({required this.position});

  final BooksVatPosition position;

  @override
  ConsumerState<_RegisteredSetting> createState() => _RegisteredSettingState();
}

class _RegisteredSettingState extends ConsumerState<_RegisteredSetting> {
  bool _saving = false;

  Future<void> _set(bool registered) async {
    if (_saving) return;
    setState(() => _saving = true);
    try {
      await ref.read(setBooksVatRegisteredProvider)(registered);
      if (mounted) {
        showAccountingToast(
          context,
          context.flipperL10n.booksVatSettingSaved,
          tone: AccountingToastTone.success,
        );
      }
    } catch (e) {
      debugPrint('Books: VAT setting not saved: $e');
      if (mounted) {
        showAccountingToast(
          context,
          context.flipperL10n.booksVatSettingFailed,
          tone: AccountingToastTone.warn,
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.flipperL10n;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.booksVatRegisteredSetting,
                style: AccountingTokens.sans(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w700,
                  color: AccountingTokens.ink1,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                l10n.booksVatRegisteredSettingHint,
                style: AccountingTokens.sans(
                  fontSize: 12,
                  color: AccountingTokens.ink3,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        AccountingSwitch(
          value: widget.position.settingRegistered,
          onChanged: _set,
        ),
      ],
    );
  }
}

/// Shown when 2200 Bank Loan has a debit balance: repayments were recorded
/// for a loan Books never saw received (taken before the business used
/// Books). [onRecord] opens the journal composer for the opening balance.
class BooksLoanOpeningPrompt extends ConsumerWidget {
  const BooksLoanOpeningPrompt({super.key, required this.onRecord});

  final VoidCallback onRecord;

  /// The Bank Loan account's debit balance, or 0 when there is none.
  static int overRepaid(Iterable<({String code, int bal})> accounts) {
    for (final a in accounts) {
      if (a.code == '2200') return a.bal < 0 ? -a.bal : 0;
    }
    return 0;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accounts = ref.watch(accountingAccountsProvider);
    final over = overRepaid(accounts.map((a) => (code: a.code, bal: a.bal)));
    if (over == 0) return const SizedBox.shrink();
    final l10n = context.flipperL10n;
    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AccountingTokens.warnTint,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.booksLoanOpeningTitle,
                  style: AccountingTokens.sans(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: AccountingTokens.warnAmber,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.booksLoanOpeningBody(money(over)),
                  style: AccountingTokens.sans(
                    fontSize: 12.5,
                    color: AccountingTokens.ink2,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          AccountingButton(
            label: l10n.booksLoanOpeningAction,
            icon: Icons.add,
            onPressed: onRecord,
          ),
        ],
      ),
    );
  }
}
