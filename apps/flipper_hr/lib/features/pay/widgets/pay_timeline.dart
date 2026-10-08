import 'package:flipper_hr/features/branding/hr_tokens.dart';
import 'package:flipper_hr/features/pay/data/pay_models.dart';
import 'package:flipper_hr/features/pay/data/pay_period.dart';
import 'package:flipper_hr/features/pay/data/pay_providers.dart';
import 'package:flipper_hr/features/pay/widgets/pay_ui.dart';
import 'package:flipper_hr/features/pay/widgets/payslip_sheet.dart';
import 'package:flipper_hr/features/people/data/money_format.dart';
import 'package:flipper_hr/features/ui/hr_ui.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Everything that happened between a person and the business, newest first:
/// payslips, money handed over, advances. The "how much did I pay them?"
/// answer, written down.
class PayTimeline extends ConsumerWidget {
  const PayTimeline({
    super.key,
    required this.account,
    required this.canManage,
  });

  final EmployeePayAccount account;
  final bool canManage;

  Future<void> _voidPayment(
    BuildContext context,
    WidgetRef ref,
    PayPayment p,
  ) async {
    final l10n = context.flipperL10n;
    final reason = await askReason(
      context,
      title: l10n.hrPayVoidPaymentTitle,
      message: l10n.hrPayVoidPaymentMessage(formatMoney(p.amount, p.currency)),
      confirmLabel: l10n.hrPayVoid,
    );
    if (reason == null) return;
    try {
      await ref
          .read(payActionsProvider)
          .voidPayment(account.employee, p, reason);
    } catch (e) {
      if (context.mounted) {
        hrToast(
          context,
          e.toString().replaceFirst('PayRepositoryException: ', ''),
          error: true,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.flipperL10n;
    final entries = <(DateTime, Widget)>[];

    for (final s in account.payslips) {
      entries.add((
        s.periodEnd,
        _Entry(
          key: Key('hr-timeline-slip-${s.id}'),
          icon: Icons.receipt_long_outlined,
          tone: payslipTone(s.status),
          title: l10n.hrPayslipFor(formatPayPeriod(s.periodStart, s.periodEnd)),
          subtitle: [
            '${l10n.hrPayGross} ${formatMoney(s.gross, s.currency)}',
            if (s.advanceRecovery > 0)
              l10n.hrPayAdvanceRecoveredAmount(
                formatMoney(s.advanceRecovery, s.currency),
              ),
          ].join(' · '),
          amount: formatMoney(s.netPay, s.currency),
          pill: s.status.label,
          struck: s.isVoid,
          onTap: () => showPayslipSheet(
            context,
            slip: s,
            employee: account.employee,
            payments: account.payments,
            canManage: canManage,
          ),
        ),
      ));
    }

    for (final p in account.payments) {
      // Advance payouts are shown on the advance itself.
      if (p.kind == PaymentKind.advance) continue;
      entries.add((
        p.paidOn,
        _Entry(
          key: Key('hr-timeline-payment-${p.id}'),
          icon: Icons.payments_outlined,
          tone: p.voided ? HrTone.neutral : HrTone.positive,
          title: l10n.hrPayPaidKind(p.kind.label),
          subtitle: [
            formatShortDate(p.paidOn),
            p.method.label,
            if (p.reference != null) p.reference!,
            if (p.voided && p.voidReason != null)
              l10n.hrPayVoidedBecause(p.voidReason!),
          ].join(' · '),
          amount: formatMoney(p.amount, p.currency),
          struck: p.voided,
          menu: canManage && !p.voided
              ? () => _voidPayment(context, ref, p)
              : null,
        ),
      ));
    }

    for (final a in account.advances) {
      entries.add((
        a.givenOn,
        _Entry(
          key: Key('hr-timeline-advance-${a.id}'),
          icon: Icons.savings_outlined,
          tone: a.isOpen ? HrTone.warning : HrTone.neutral,
          title: l10n.hrPayAdvanceGivenOn(formatShortDate(a.givenOn)),
          subtitle: [
            a.method.label,
            if (a.reason != null) a.reason!,
            if (a.isOpen)
              l10n.hrPayStillOwed(formatMoney(a.outstanding, a.currency)),
          ].join(' · '),
          amount: formatMoney(a.amount, a.currency),
          pill: a.status.label,
          struck: a.status == AdvanceStatus.voided,
        ),
      ));
    }

    entries.sort((x, y) => y.$1.compareTo(x.$1));

    if (entries.isEmpty) {
      return HrPanel(
        child: HrEmptyState(
          icon: Icons.history_outlined,
          message: l10n.hrPayNoHistory,
        ),
      );
    }

    return HrPanel(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        children: [
          for (var i = 0; i < entries.length; i++) ...[
            entries[i].$2,
            if (i < entries.length - 1)
              const Divider(height: 1, indent: 60, color: HrTokens.line),
          ],
        ],
      ),
    );
  }
}

class _Entry extends StatelessWidget {
  const _Entry({
    super.key,
    required this.icon,
    required this.tone,
    required this.title,
    required this.subtitle,
    required this.amount,
    this.pill,
    this.struck = false,
    this.onTap,
    this.menu,
  });

  final IconData icon;
  final HrTone tone;
  final String title;
  final String subtitle;
  final String amount;
  final String? pill;
  final bool struck;
  final VoidCallback? onTap;
  final VoidCallback? menu;

  @override
  Widget build(BuildContext context) {
    final strike = struck
        ? const TextStyle(decoration: TextDecoration.lineThrough)
        : const TextStyle();
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        child: Row(
          children: [
            Container(
              width: 34,
              height: 34,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                color: HrTokens.surface2,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 17, color: HrTokens.ink2),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: HrType.bodyStrong.merge(strike)),
                  if (subtitle.isNotEmpty)
                    Text(
                      subtitle,
                      style: HrType.caption,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(amount, style: HrType.bodyStrong.merge(strike)),
                if (pill != null) ...[
                  const SizedBox(height: 2),
                  HrPill(label: pill!, tone: tone),
                ],
              ],
            ),
            if (menu != null)
              PopupMenuButton<int>(
                tooltip: '',
                onSelected: (_) => menu!(),
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 0,
                    child: Text(context.flipperL10n.hrPayVoid),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
