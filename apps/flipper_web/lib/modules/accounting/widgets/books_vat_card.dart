import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_web/modules/accounting/data/accounting_derive.dart';
import 'package:flipper_web/modules/accounting/data/accounting_providers.dart';
import 'package:flipper_web/modules/accounting/data/services/vat_position_service.dart';
import 'package:flipper_web/modules/accounting/theme/accounting_tokens.dart';
import 'package:flipper_web/modules/accounting/widgets/accounting_icon.dart';
import 'package:flipper_web/modules/accounting/widgets/accounting_page_header.dart';
import 'package:flipper_web/modules/accounting/widgets/accounting_switch.dart';
import 'package:flipper_web/modules/accounting/widgets/accounting_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Where the business stands on VAT, on the Books dashboard.
///
/// - Registered (EBM branch, or "Registered for VAT" on): VAT Payable from
///   the ledger.
/// - Not registered: its sales carry no VAT; an estimate of the VAT in its
///   sales, the VAT it paid on purchases, and its turnover against RRA's
///   registration threshold. None of that is in the ledger.
///
/// Every amount carries the business currency. Without an EBM branch the
/// card also holds the "Registered for VAT" setting. Nothing shows while the
/// position cannot be read.
class BooksVatCard extends ConsumerWidget {
  const BooksVatCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final position = ref.watch(booksVatPositionProvider).value;
    if (position == null) return const SizedBox.shrink();
    final currency = ref.watch(accountingCurrencyProvider);
    final l10n = context.flipperL10n;
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: AccountingCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AccountingCardHeader(
              title: l10n.booksVatTitle,
              subtitle: position.registered ? null : l10n.booksVatNotRegistered,
              trailing: _StatusPill(registered: position.registered),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (position.registered)
                    _RegisteredBody(position: position, currency: currency)
                  else
                    _EstimateBody(position: position, currency: currency),
                  if (!position.hasEbmBranch) ...[
                    const Divider(height: 28, color: AccountingTokens.line),
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

/// "Registered" / "Not registered", in the dot-and-label pill style of
/// the journal status pills.
class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.registered});

  final bool registered;

  @override
  Widget build(BuildContext context) {
    final l10n = context.flipperL10n;
    final (bg, fg, label) = registered
        ? (
            AccountingTokens.accentTint,
            AccountingTokens.accent,
            l10n.booksVatPillRegistered,
          )
        : (
            AccountingTokens.gainTint,
            AccountingTokens.gainInk,
            l10n.booksVatPillNotRegistered,
          );
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(color: fg, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: AccountingTokens.sans(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: fg,
            ),
          ),
        ],
      ),
    );
  }
}

/// An amount with the currency in front, smaller and muted, the way the
/// dashboard KPI cards show money: "RWF 54,000".
class _Amount extends StatelessWidget {
  const _Amount({
    required this.currency,
    required this.value,
    this.fontSize = 20,
    this.color,
  });

  final String currency;
  final int value;
  final double fontSize;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: '$currency ',
            style: AccountingTokens.mono(
              fontSize: fontSize * 0.55,
              fontWeight: FontWeight.w600,
              color: AccountingTokens.ink3,
            ),
          ),
          TextSpan(text: money(value)),
        ],
      ),
      style: AccountingTokens.mono(
        fontSize: fontSize,
        fontWeight: FontWeight.w800,
        color: color ?? AccountingTokens.ink1,
      ),
    );
  }
}

/// A rounded square holding an icon, on a tint.
class _IconChip extends StatelessWidget {
  const _IconChip({required this.icon, required this.bg, required this.fg});

  final AccIcon icon;
  final Color bg;
  final Color fg;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 38,
      height: 38,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(11),
      ),
      alignment: Alignment.center,
      child: AccountingIcon(icon: icon, size: 20, color: fg),
    );
  }
}

class _RegisteredBody extends StatelessWidget {
  const _RegisteredBody({required this.position, required this.currency});

  final BooksVatPosition position;
  final String currency;

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
    final (tint, ink, icon) = credit
        ? (AccountingTokens.gainTint, AccountingTokens.gainInk, AccIcon.wallet)
        : (
            AccountingTokens.accentTint,
            AccountingTokens.accent,
            AccIcon.receipt,
          );
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: tint,
        borderRadius: BorderRadius.circular(AccountingTokens.radiusMd),
      ),
      child: Row(
        children: [
          _IconChip(icon: icon, bg: AccountingTokens.surface, fg: ink),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  credit ? l10n.booksVatCreditLedger : l10n.booksVatOwedLedger,
                  style: AccountingTokens.sans(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: AccountingTokens.ink2,
                  ),
                ),
                const SizedBox(height: 4),
                _Amount(
                  currency: currency,
                  value: position.vatOwed.abs(),
                  fontSize: 28,
                  color: credit
                      ? AccountingTokens.gainInk
                      : AccountingTokens.ink1,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EstimateBody extends StatelessWidget {
  const _EstimateBody({required this.position, required this.currency});

  final BooksVatPosition position;
  final String currency;

  @override
  Widget build(BuildContext context) {
    final l10n = context.flipperL10n;
    // Nothing to show past the status in the header.
    if (!position.hasEstimate) return const SizedBox.shrink();
    final ratio = position.annualThreshold <= 0
        ? 0.0
        : position.turnover12m / position.annualThreshold;
    final (
      Color barColor,
      Color barTint,
      String? warning,
    ) = switch (position.threshold) {
      VatThreshold.crossed => (
        AccountingTokens.loss,
        AccountingTokens.lossTint,
        l10n.booksVatThresholdCrossed,
      ),
      VatThreshold.near => (
        AccountingTokens.warnAmber,
        AccountingTokens.warnTint,
        l10n.booksVatThresholdNear,
      ),
      VatThreshold.none => (
        AccountingTokens.accent,
        AccountingTokens.accentTint,
        null,
      ),
    };
    // Darker ink for the red callout text, so it reads on its tint.
    final warnInk = position.threshold == VatThreshold.crossed
        ? AccountingTokens.lossInk
        : barColor;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LayoutBuilder(
          builder: (context, c) {
            // Side by side when there is room, stacked on phones.
            final tileWidth = c.maxWidth >= 460
                ? (c.maxWidth - 12) / 2
                : c.maxWidth;
            return Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                SizedBox(
                  width: tileWidth,
                  child: _StatTile(
                    icon: AccIcon.arrowUpRight,
                    iconBg: AccountingTokens.accentTint,
                    iconFg: AccountingTokens.accent,
                    label: l10n.booksVatEstimateSales,
                    currency: currency,
                    value: position.monthEstimatedOutputVat,
                  ),
                ),
                SizedBox(
                  width: tileWidth,
                  child: _StatTile(
                    icon: AccIcon.truck,
                    iconBg: AccountingTokens.warnTint,
                    iconFg: AccountingTokens.warnAmber,
                    label: l10n.booksVatPaidPurchases,
                    currency: currency,
                    value: position.monthPurchaseVat,
                  ),
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 18),
        Row(
          children: [
            Expanded(
              child: Text(
                l10n.booksVatThresholdLabel.toUpperCase(),
                style: AccountingTokens.eyebrow,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: barTint,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                '${(ratio * 100).round()}%',
                style: AccountingTokens.mono(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: barColor,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: LinearProgressIndicator(
            value: ratio.clamp(0.0, 1.0),
            minHeight: 10,
            color: barColor,
            backgroundColor: AccountingTokens.surface2,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          l10n.booksVatTurnover12m(
            '$currency ${money(position.turnover12m)}',
            '$currency ${money(position.annualThreshold)}',
          ),
          style: AccountingTokens.sans(
            fontSize: 12.5,
            color: AccountingTokens.ink2,
          ),
        ),
        if (warning != null) ...[
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: barTint,
              borderRadius: BorderRadius.circular(AccountingTokens.radiusSm),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AccountingIcon(icon: AccIcon.warn, size: 18, color: barColor),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    warning,
                    style: AccountingTokens.sans(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: warnInk,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
        const SizedBox(height: 12),
        Text(
          l10n.booksVatEstimateNote,
          style: AccountingTokens.sans(
            fontSize: 12,
            color: AccountingTokens.ink3,
          ),
        ),
      ],
    );
  }
}

/// One estimate figure: an icon chip, its label and the amount.
class _StatTile extends StatelessWidget {
  const _StatTile({
    required this.icon,
    required this.iconBg,
    required this.iconFg,
    required this.label,
    required this.currency,
    required this.value,
  });

  final AccIcon icon;
  final Color iconBg;
  final Color iconFg;
  final String label;
  final String currency;
  final int value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AccountingTokens.surface2,
        borderRadius: BorderRadius.circular(AccountingTokens.radiusMd),
      ),
      child: Row(
        children: [
          _IconChip(icon: icon, bg: iconBg, fg: iconFg),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AccountingTokens.sans(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AccountingTokens.ink2,
                  ),
                ),
                const SizedBox(height: 3),
                _Amount(currency: currency, value: value),
              ],
            ),
          ),
        ],
      ),
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
