import 'package:flipper_hr/features/branding/hr_tokens.dart';
import 'package:flipper_hr/features/pay/data/pay_models.dart';
import 'package:flipper_hr/features/pay/data/pay_period.dart';
import 'package:flipper_hr/features/pay/data/pay_providers.dart';
import 'package:flipper_hr/features/pay/data/pay_repository.dart';
import 'package:flipper_hr/features/pay/widgets/advance_sheet.dart';
import 'package:flipper_hr/features/pay/widgets/pay_sheet.dart';
import 'package:flipper_hr/features/pay/widgets/pay_ui.dart';
import 'package:flipper_hr/features/pay/widgets/payslip_sheet.dart';
import 'package:flipper_hr/features/people/data/employee.dart';
import 'package:flipper_hr/features/people/data/money_format.dart';
import 'package:flipper_hr/features/people/data/people_providers.dart';
import 'package:flipper_hr/features/ui/hr_l10n.dart';
import 'package:flipper_hr/features/ui/hr_ui.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_web/features/business_selection/business_selection_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

enum PayTab { people, payslips, advances, requests, returns }

/// Payroll for a branch: who is due, what was paid, what is owed back, and the
/// month's statutory returns.
class PayPage extends ConsumerStatefulWidget {
  const PayPage({
    super.key,
    required this.businessId,
    required this.branchId,
    this.branchName,
    this.initialTab = PayTab.people,
  });

  final String businessId;
  final String branchId;
  final String? branchName;
  final PayTab initialTab;

  @override
  ConsumerState<PayPage> createState() => _PayPageState();
}

class _PayPageState extends ConsumerState<PayPage> {
  late PayTab _tab = widget.initialTab;

  void _refresh() {
    ref.invalidate(rosterProvider(widget.branchId));
    ref.invalidate(branchPayBookProvider(widget.branchId));
  }

  Future<void> _pay(EmployeePayAccount account) async {
    final slip = await showPaySheet(context, account: account);
    if (slip != null && mounted) {
      hrToast(
        context,
        context.flipperL10n.hrPayPaidToast(
          account.employee.fullName,
          formatPayPeriod(slip.periodStart, slip.periodEnd),
        ),
      );
    }
  }

  Future<void> _advance(EmployeePayAccount account) async {
    final ok = await showGiveAdvanceSheet(context, account: account);
    if (ok == true && mounted) {
      hrToast(context, context.flipperL10n.hrAdvanceRecordedToast);
    }
  }

  Future<void> _pick(
    List<EmployeePayAccount> accounts,
    Future<void> Function(EmployeePayAccount) then,
  ) async {
    final active = accounts.where((a) => a.employee.isActive).toList();
    final chosen = await showHrSheet<EmployeePayAccount>(
      context,
      builder: (_) => _PersonPicker(accounts: active),
    );
    if (chosen != null && mounted) await then(chosen);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.flipperL10n;
    final accountsAsync = ref.watch(branchPayAccountsProvider(widget.branchId));
    final book = ref.watch(branchPayBookProvider(widget.branchId)).value;
    final now = ref.watch(hrClockProvider)();
    final narrow = MediaQuery.sizeOf(context).width < hrSheetBreakpoint;

    final accounts = accountsAsync.value ?? const <EmployeePayAccount>[];
    final pendingRequests =
        book?.requests.where((r) => r.isPending).length ?? 0;

    final giveAdvance = OutlinedButton.icon(
      key: const Key('hr-payroll-give-advance'),
      onPressed: accounts.isEmpty ? null : () => _pick(accounts, _advance),
      style: hrSecondaryButtonStyle(height: 44),
      icon: const Icon(Icons.savings_outlined, size: 17),
      label: Text(l10n.hrAdvanceGive),
    );
    final paySomeone = FilledButton.icon(
      key: const Key('hr-payroll-pay'),
      onPressed: accounts.isEmpty ? null : () => _pick(accounts, _pay),
      style: hrPrimaryButtonStyle(height: 44),
      icon: const Icon(Icons.payments_outlined, size: 17),
      label: Text(l10n.hrPayPaySomeone),
    );

    final header = Wrap(
      alignment: WrapAlignment.spaceBetween,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 12,
      runSpacing: 12,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.hrPayroll, style: HrType.display),
            const SizedBox(height: 4),
            Text(
              [
                '${hrMonthName(l10n, now.month)} ${now.year}',
                if ((widget.branchName ?? '').isNotEmpty) widget.branchName!,
              ].join(' · '),
              style: HrType.caption,
            ),
          ],
        ),
        // On a phone the two actions share a full-width row, thumb-sized.
        if (!narrow)
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [giveAdvance, paySomeone],
          ),
      ],
    );

    Widget body;
    if (accountsAsync.hasError && accountsAsync.value == null) {
      body = HrPanel(
        child: HrEmptyState(
          icon: Icons.cloud_off_outlined,
          title: l10n.hrPayErrorLoad,
          message: '${accountsAsync.error}'.replaceFirst(
            'PayRepositoryException: ',
            '',
          ),
          actionLabel: l10n.retry,
          onAction: _refresh,
        ),
      );
    } else if (accountsAsync.isLoading && accountsAsync.value == null) {
      body = const Padding(
        padding: EdgeInsets.all(48),
        child: Center(child: CircularProgressIndicator()),
      );
    } else {
      body = switch (_tab) {
        PayTab.people => _PeopleTab(
          accounts: accounts,
          onPay: _pay,
          onAdvance: _advance,
          onOpen: (a) => context.go('/pay/${a.employee.id}'),
          narrow: narrow,
        ),
        PayTab.payslips => _PayslipsTab(book: book, accounts: accounts),
        PayTab.advances => _AdvancesTab(book: book, accounts: accounts),
        PayTab.requests => _RequestsTab(book: book, accounts: accounts),
        PayTab.returns => _ReturnsTab(book: book, accounts: accounts),
      };
    }

    return RefreshIndicator(
      onRefresh: () async => _refresh(),
      child: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: ListView(
            padding: EdgeInsets.fromLTRB(
              narrow ? 16 : 24,
              narrow ? 16 : 24,
              narrow ? 16 : 24,
              32,
            ),
            children: [
              header,
              if (narrow) ...[
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(child: giveAdvance),
                    const SizedBox(width: 10),
                    Expanded(child: paySomeone),
                  ],
                ),
              ],
              const SizedBox(height: 18),
              _Kpis(accounts: accounts, book: book, now: now),
              const SizedBox(height: 18),
              _Tabs(
                value: _tab,
                requests: pendingRequests,
                onChanged: (t) => setState(() => _tab = t),
              ),
              const SizedBox(height: 14),
              body,
            ],
          ),
        ),
      ),
    );
  }
}

// ─── KPIs ─────────────────────────────────────────────────────────────────────

class _Kpis extends StatelessWidget {
  const _Kpis({required this.accounts, required this.book, required this.now});

  final List<EmployeePayAccount> accounts;
  final PayBook? book;
  final DateTime now;

  @override
  Widget build(BuildContext context) {
    final l10n = context.flipperL10n;
    final currency = accounts.isEmpty
        ? 'RWF'
        : accounts.first.employee.currency;
    final month = PayPeriod.containing(PayFrequency.monthly, now);
    final due = accounts.where((a) => a.isDue).toList();
    final paidThisMonth = (book?.payments ?? const <PayPayment>[])
        .where((p) => !p.voided && month.contains(p.paidOn))
        .fold(0.0, (s, p) => s + p.amount);
    final owed = accounts.fold(0.0, (s, a) => s + a.advanceBalance);
    final cost = PayrollTotals(
      (book?.payslips ?? const <Payslip>[]).where(
        (p) => month.contains(p.periodEnd),
      ),
    );
    final unpaid = accounts.fold(0.0, (s, a) => s + a.unpaidOnPayslips);

    return HrStatGrid(
      tiles: [
        (w) => HrStatTile(
          width: w,
          key: const Key('hr-pay-kpi-due'),
          label: l10n.hrPayDueNow,
          value: '${due.length}',
          icon: Icons.event_available_outlined,
          tone: due.isEmpty ? HrTone.positive : HrTone.danger,
          hint: due.isEmpty ? l10n.hrAllClear : l10n.hrPayPeopleToPay,
        ),
        (w) => HrStatTile(
          width: w,
          key: const Key('hr-pay-kpi-paid'),
          label: l10n.hrPayPaidThisMonth,
          value: formatCompactMoney(paidThisMonth, currency),
          icon: Icons.payments_outlined,
          tone: HrTone.positive,
          hint: unpaid > 0
              ? l10n.hrPayUnpaidOnSlips(formatCompactMoney(unpaid, currency))
              : null,
        ),
        (w) => HrStatTile(
          width: w,
          key: const Key('hr-pay-kpi-advances'),
          label: l10n.hrPayAdvancesOwed,
          value: formatCompactMoney(owed, currency),
          icon: Icons.savings_outlined,
          tone: owed > 0 ? HrTone.warning : HrTone.neutral,
        ),
        (w) => HrStatTile(
          width: w,
          label: l10n.hrPayCostThisMonth,
          value: formatCompactMoney(cost.employerCost, currency),
          icon: Icons.account_balance_wallet_outlined,
          hint: cost.count == 0 ? null : l10n.hrPayPayslipCount(cost.count),
        ),
      ],
    );
  }
}

// ─── Tabs ─────────────────────────────────────────────────────────────────────

class _Tabs extends StatelessWidget {
  const _Tabs({
    required this.value,
    required this.requests,
    required this.onChanged,
  });

  final PayTab value;
  final int requests;
  final ValueChanged<PayTab> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = context.flipperL10n;
    String label(PayTab t) => switch (t) {
      PayTab.people => l10n.hrPeople,
      PayTab.payslips => l10n.hrPayslips,
      PayTab.advances => l10n.hrPayAdvances,
      PayTab.requests =>
        requests == 0
            ? l10n.hrPayRequests
            : '${l10n.hrPayRequests} · $requests',
      PayTab.returns => l10n.hrPayReturns,
    };
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (final t in PayTab.values)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ChoiceChip(
                key: Key('hr-pay-tab-${t.name}'),
                label: Text(label(t)),
                selected: value == t,
                onSelected: (_) => onChanged(t),
                showCheckmark: false,
                selectedColor: HrTokens.ink1,
                backgroundColor: HrTokens.surface,
                side: BorderSide(
                  color: value == t ? HrTokens.ink1 : HrTokens.border,
                ),
                labelStyle: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: value == t ? Colors.white : HrTokens.ink2,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ─── People ───────────────────────────────────────────────────────────────────

class _PeopleTab extends StatelessWidget {
  const _PeopleTab({
    required this.accounts,
    required this.onPay,
    required this.onAdvance,
    required this.onOpen,
    required this.narrow,
  });

  final List<EmployeePayAccount> accounts;
  final Future<void> Function(EmployeePayAccount) onPay;
  final Future<void> Function(EmployeePayAccount) onAdvance;
  final void Function(EmployeePayAccount) onOpen;
  final bool narrow;

  @override
  Widget build(BuildContext context) {
    final l10n = context.flipperL10n;
    if (accounts.isEmpty) {
      return HrPanel(
        child: HrEmptyState(
          icon: Icons.groups_outlined,
          title: l10n.hrPayNobodyYet,
          message: l10n.hrPayNobodyYetBody,
          actionLabel: l10n.hrAddAPerson,
          onAction: () => context.go('/people'),
        ),
      );
    }
    // Due first, soonest pay date first; everyone else after.
    final sorted = accounts.toList()
      ..sort((a, b) {
        if (a.isDue != b.isDue) return a.isDue ? -1 : 1;
        return a.nextPayDate.compareTo(b.nextPayDate);
      });
    return Column(
      children: [
        for (final a in sorted)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: PayPersonTile(
              account: a,
              narrow: narrow,
              onPay: () => onPay(a),
              onAdvance: () => onAdvance(a),
              onOpen: () => onOpen(a),
            ),
          ),
      ],
    );
  }
}

/// One person's line on the payroll: when they are due, what they owe back,
/// when they were last paid, and the button that pays them.
class PayPersonTile extends StatelessWidget {
  const PayPersonTile({
    super.key,
    required this.account,
    required this.narrow,
    required this.onPay,
    required this.onAdvance,
    required this.onOpen,
  });

  final EmployeePayAccount account;
  final bool narrow;
  final VoidCallback onPay;
  final VoidCallback onAdvance;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    final l10n = context.flipperL10n;
    final e = account.employee;
    final last = account.lastPayment;
    final dueLabel = _dueLabel(l10n);

    final identity = Row(
      children: [
        HrPersonAvatar(initials: e.initials, seed: e.id, radius: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                e.fullName,
                style: HrType.bodyStrong,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                [
                  formatMoney(e.baseSalary, e.currency),
                  e.payFrequency.label,
                ].join(' · '),
                style: HrType.caption,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );

    final facts = Wrap(
      spacing: 6,
      runSpacing: 6,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        HrPill(
          label: dueLabel.$1,
          tone: dueLabel.$2,
          icon: Icons.event_outlined,
        ),
        if (account.advanceBalance > 0)
          HrPill(
            label: l10n.hrPayOwesBack(
              formatCompactMoney(account.advanceBalance, e.currency),
            ),
            tone: HrTone.warning,
            icon: Icons.savings_outlined,
          ),
        if (last != null)
          Text(
            l10n.hrPayLastPaid(
              formatMoney(last.amount, last.currency),
              formatShortDate(last.paidOn),
            ),
            style: HrType.caption,
          ),
      ],
    );

    final actions = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          tooltip: null,
          key: Key('hr-pay-advance-${e.id}'),
          onPressed: e.isActive ? onAdvance : null,
          icon: const Icon(Icons.savings_outlined, size: 20),
          color: HrTokens.ink2,
        ),
        const SizedBox(width: 4),
        FilledButton(
          key: Key('hr-pay-person-${e.id}'),
          onPressed: e.isActive ? onPay : null,
          style: hrPrimaryButtonStyle(height: 36),
          child: Text(l10n.hrPayPay),
        ),
      ],
    );

    return HrPanel(
      onTap: onOpen,
      padding: const EdgeInsets.all(14),
      child: narrow
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                identity,
                const SizedBox(height: 10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(child: facts),
                    actions,
                  ],
                ),
              ],
            )
          : Row(
              children: [
                Expanded(flex: 4, child: identity),
                const SizedBox(width: 12),
                Expanded(flex: 5, child: facts),
                actions,
              ],
            ),
    );
  }

  (String, HrTone) _dueLabel(FlipperAppLocalizations l10n) {
    if (!account.employee.isActive) {
      return (account.employee.status.label, HrTone.neutral);
    }
    final days = account.daysToPay;
    final date = formatShortDate(account.nextPayDate);
    if (account.isDue) {
      return days < 0
          ? (l10n.hrPayOverdueSince(date), HrTone.danger)
          : (l10n.hrPayDueToday, HrTone.danger);
    }
    if (days <= 3) return (l10n.hrPayDueOn(date), HrTone.warning);
    return (l10n.hrPayNextOn(date), HrTone.info);
  }
}

// ─── Payslips ─────────────────────────────────────────────────────────────────

class _PayslipsTab extends StatelessWidget {
  const _PayslipsTab({required this.book, required this.accounts});

  final PayBook? book;
  final List<EmployeePayAccount> accounts;

  @override
  Widget build(BuildContext context) {
    final l10n = context.flipperL10n;
    final people = {for (final a in accounts) a.employee.id: a.employee};
    final slips = (book?.payslips ?? const <Payslip>[])
        .where((s) => people.containsKey(s.employeeId))
        .toList();
    if (slips.isEmpty) {
      return HrPanel(
        child: HrEmptyState(
          icon: Icons.receipt_long_outlined,
          message: l10n.hrPayNoPayslips,
        ),
      );
    }
    return HrPanel(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          for (final s in slips) ...[
            ListTile(
              key: Key('hr-payslip-${s.id}'),
              onTap: () => showPayslipSheet(
                context,
                slip: s,
                employee: people[s.employeeId]!,
                payments: book?.payments ?? const [],
              ),
              leading: HrPersonAvatar(
                initials: people[s.employeeId]!.initials,
                seed: s.employeeId,
              ),
              title: Text(
                people[s.employeeId]!.fullName,
                style: HrType.bodyStrong,
              ),
              subtitle: Text(
                formatPayPeriod(s.periodStart, s.periodEnd),
                style: HrType.caption,
              ),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    formatMoney(s.netPay, s.currency),
                    style: HrType.bodyStrong,
                  ),
                  const SizedBox(height: 2),
                  HrPill(label: s.status.label, tone: payslipTone(s.status)),
                ],
              ),
            ),
            if (s != slips.last) const Divider(height: 1, color: HrTokens.line),
          ],
        ],
      ),
    );
  }
}

// ─── Advances ─────────────────────────────────────────────────────────────────

class _AdvancesTab extends ConsumerWidget {
  const _AdvancesTab({required this.book, required this.accounts});

  final PayBook? book;
  final List<EmployeePayAccount> accounts;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.flipperL10n;
    final people = {for (final a in accounts) a.employee.id: a.employee};
    final advances =
        (book?.advances ?? const <Advance>[])
            .where((a) => people.containsKey(a.employeeId))
            .toList()
          ..sort((a, b) {
            if (a.isOpen != b.isOpen) return a.isOpen ? -1 : 1;
            return b.givenOn.compareTo(a.givenOn);
          });
    if (advances.isEmpty) {
      return HrPanel(
        child: HrEmptyState(
          icon: Icons.savings_outlined,
          message: l10n.hrPayNoAdvances,
        ),
      );
    }
    return Column(
      children: [
        for (final a in advances)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: AdvanceTile(
              advance: a,
              employee: people[a.employeeId]!,
              canManage: true,
            ),
          ),
      ],
    );
  }
}

/// One advance: how much, how much is back, and what can still be done to it.
class AdvanceTile extends ConsumerWidget {
  const AdvanceTile({
    super.key,
    required this.advance,
    required this.employee,
    required this.canManage,
    this.showPerson = true,
  });

  final Advance advance;
  final Employee employee;
  final bool canManage;

  /// Off on a person's own page, where their name is already the heading.
  final bool showPerson;

  Future<void> _close(
    BuildContext context,
    WidgetRef ref,
    bool writeOff,
  ) async {
    final l10n = context.flipperL10n;
    final reason = await askReason(
      context,
      title: writeOff ? l10n.hrAdvanceWriteOffTitle : l10n.hrAdvanceVoidTitle,
      message: writeOff
          ? l10n.hrAdvanceWriteOffMessage(
              formatMoney(advance.outstanding, advance.currency),
            )
          : l10n.hrAdvanceVoidMessage,
      confirmLabel: writeOff ? l10n.hrAdvanceWriteOff : l10n.hrPayVoid,
    );
    if (reason == null) return;
    final actions = ref.read(payActionsProvider);
    try {
      writeOff
          ? await actions.writeOffAdvance(employee, advance, reason)
          : await actions.voidAdvance(employee, advance, reason);
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
    final a = advance;
    final progress = a.amount <= 0
        ? 0.0
        : (a.recovered / a.amount).clamp(0.0, 1.0);
    return HrPanel(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (showPerson) ...[
                HrPersonAvatar(initials: employee.initials, seed: employee.id),
                const SizedBox(width: 12),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      showPerson
                          ? employee.fullName
                          : context.flipperL10n.hrPayAdvanceGivenOn(
                              formatShortDate(a.givenOn),
                            ),
                      style: HrType.bodyStrong,
                    ),
                    Text(
                      [
                        formatShortDate(a.givenOn),
                        a.method.label,
                        if (a.reason != null) a.reason!,
                      ].join(' · '),
                      style: HrType.caption,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    formatMoney(a.amount, a.currency),
                    style: HrType.bodyStrong,
                  ),
                  HrPill(label: a.status.label, tone: _tone(a.status)),
                ],
              ),
              if (canManage && a.isOpen)
                PopupMenuButton<bool>(
                  key: Key('hr-advance-menu-${a.id}'),
                  tooltip: '',
                  onSelected: (writeOff) => _close(context, ref, writeOff),
                  itemBuilder: (_) => [
                    PopupMenuItem(
                      value: true,
                      child: Text(l10n.hrAdvanceWriteOff),
                    ),
                    if (a.recovered == 0)
                      PopupMenuItem(value: false, child: Text(l10n.hrPayVoid)),
                  ],
                ),
            ],
          ),
          if (a.isOpen) ...[
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(99),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 6,
                backgroundColor: HrTokens.surface2,
                color: HrTokens.success,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              l10n.hrAdvanceProgress(
                formatMoney(a.recovered, a.currency),
                formatMoney(a.outstanding, a.currency),
              ),
              style: HrType.caption,
            ),
            if (a.installmentAmount != null)
              Text(
                l10n.hrAdvanceInstallmentOf(
                  formatMoney(a.installmentAmount!, a.currency),
                ),
                style: HrType.caption,
              ),
          ],
        ],
      ),
    );
  }

  static HrTone _tone(AdvanceStatus s) => switch (s) {
    AdvanceStatus.open => HrTone.warning,
    AdvanceStatus.recovered => HrTone.positive,
    AdvanceStatus.writtenOff => HrTone.neutral,
    AdvanceStatus.voided => HrTone.neutral,
  };
}

// ─── Requests ─────────────────────────────────────────────────────────────────

class _RequestsTab extends ConsumerWidget {
  const _RequestsTab({required this.book, required this.accounts});

  final PayBook? book;
  final List<EmployeePayAccount> accounts;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.flipperL10n;
    final people = {for (final a in accounts) a.employee.id: a};
    final requests = (book?.requests ?? const <AdvanceRequest>[])
        .where((r) => people.containsKey(r.employeeId))
        .toList();
    if (requests.isEmpty) {
      return HrPanel(
        child: HrEmptyState(
          icon: Icons.mark_email_read_outlined,
          message: l10n.hrPayNoRequests,
        ),
      );
    }
    final decider = ref.watch(currentUserProfileProvider).value?.id;
    return Column(
      children: [
        for (final r in requests)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: HrPanel(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      HrPersonAvatar(
                        initials: people[r.employeeId]!.employee.initials,
                        seed: r.employeeId,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              people[r.employeeId]!.employee.fullName,
                              style: HrType.bodyStrong,
                            ),
                            Text(
                              [
                                formatShortDate(r.createdAt.toLocal()),
                                if (r.reason != null) r.reason!,
                              ].join(' · '),
                              style: HrType.caption,
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            formatMoney(
                              r.amount,
                              people[r.employeeId]!.employee.currency,
                            ),
                            style: HrType.bodyStrong,
                          ),
                          HrPill(
                            label: r.status.label,
                            tone: r.isPending ? HrTone.warning : HrTone.neutral,
                          ),
                        ],
                      ),
                    ],
                  ),
                  if (r.isPending) ...[
                    const SizedBox(height: 10),
                    if (people[r.employeeId]!.advanceBalance > 0)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Text(
                          l10n.hrAdvanceAlreadyOwed(
                            formatMoney(
                              people[r.employeeId]!.advanceBalance,
                              people[r.employeeId]!.employee.currency,
                            ),
                          ),
                          style: HrType.caption,
                        ),
                      ),
                    Wrap(
                      spacing: 8,
                      children: [
                        OutlinedButton(
                          key: Key('hr-request-decline-${r.id}'),
                          onPressed: () => decideAdvanceRequest(
                            context,
                            ref,
                            employee: people[r.employeeId]!.employee,
                            request: r,
                            approve: false,
                            deciderUserId: decider,
                          ),
                          style: hrSecondaryButtonStyle(height: 36),
                          child: Text(l10n.hrAdvanceDecline),
                        ),
                        FilledButton(
                          key: Key('hr-request-approve-${r.id}'),
                          onPressed: () => decideAdvanceRequest(
                            context,
                            ref,
                            employee: people[r.employeeId]!.employee,
                            request: r,
                            approve: true,
                            deciderUserId: decider,
                          ),
                          style: hrPrimaryButtonStyle(height: 36),
                          child: Text(l10n.hrAdvanceApproveAndGive),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
      ],
    );
  }
}

// ─── Returns ──────────────────────────────────────────────────────────────────

/// The month's PAYE and RSSB figures, ready to declare by the 15th.
class _ReturnsTab extends ConsumerStatefulWidget {
  const _ReturnsTab({required this.book, required this.accounts});

  final PayBook? book;
  final List<EmployeePayAccount> accounts;

  @override
  ConsumerState<_ReturnsTab> createState() => _ReturnsTabState();
}

class _ReturnsTabState extends ConsumerState<_ReturnsTab> {
  late PayPeriod _month = PayPeriod.containing(
    PayFrequency.monthly,
    ref.read(hrClockProvider)(),
  );

  @override
  Widget build(BuildContext context) {
    final l10n = context.flipperL10n;
    final people = {for (final a in widget.accounts) a.employee.id: a.employee};
    final slips = (widget.book?.payslips ?? const <Payslip>[])
        .where((s) => !s.isVoid && _month.contains(s.periodEnd))
        .toList();
    final t = PayrollTotals(slips);
    final currency = widget.accounts.isEmpty
        ? 'RWF'
        : widget.accounts.first.employee.currency;
    final deadline = DateTime(_month.end.year, _month.end.month + 1, 15);

    String tsv() {
      final b = StringBuffer(
        'Name\tNational ID\tRSSB No\tGross\tPAYE\tPension (EE)\tPension (ER)\t'
        'Maternity (EE)\tMaternity (ER)\tOccupational hazards\tCBHI\tNet\n',
      );
      for (final s in slips) {
        final e = people[s.employeeId];
        b.writeln(
          [
            e?.fullName ?? s.employeeId,
            e?.nationalId ?? '',
            e?.rssbNumber ?? '',
            s.gross,
            s.paye,
            s.pensionEmployee,
            s.pensionEmployer,
            s.maternityEmployee,
            s.maternityEmployer,
            s.occupationalHazards,
            s.cbhi,
            s.netPay,
          ].join('\t'),
        );
      }
      return b.toString();
    }

    final summary = HrPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              IconButton(
                key: const Key('hr-returns-prev'),
                onPressed: () => setState(
                  () => _month = _month.previous(PayFrequency.monthly),
                ),
                icon: const Icon(Icons.chevron_left),
              ),
              Expanded(
                child: Text(
                  formatPeriodOf(_month),
                  textAlign: TextAlign.center,
                  style: HrType.title,
                ),
              ),
              IconButton(
                key: const Key('hr-returns-next'),
                onPressed: () =>
                    setState(() => _month = _month.next(PayFrequency.monthly)),
                icon: const Icon(Icons.chevron_right),
              ),
            ],
          ),
          HrCallout(
            icon: Icons.event_note_outlined,
            message: l10n.hrPayReturnsDeadline(formatShortDate(deadline)),
          ),
          HrSubheading(l10n.hrPayReturnsRra),
          HrAmountRow(
            label: l10n.hrPayPaye,
            amount: t.paye,
            currency: currency,
            strong: true,
          ),
          HrSubheading(l10n.hrPayReturnsRssb),
          HrAmountRow(
            label: l10n.hrPayPensionBothSides,
            amount: t.pensionEmployee + t.pensionEmployer,
            currency: currency,
          ),
          HrAmountRow(
            label: l10n.hrPayMaternityBothSides,
            amount: t.maternityEmployee + t.maternityEmployer,
            currency: currency,
          ),
          HrAmountRow(
            label: l10n.hrPayOccupationalHazards,
            amount: t.occupationalHazards,
            currency: currency,
          ),
          HrAmountRow(
            label: l10n.hrPayCbhi,
            amount: t.cbhi,
            currency: currency,
          ),
          HrAmountRow(
            label: l10n.hrPayRssbTotal,
            amount: t.rssb,
            currency: currency,
            strong: true,
          ),
          HrSubheading(l10n.hrPaySummary),
          HrAmountRow(
            label: l10n.hrPayGross,
            amount: t.gross,
            currency: currency,
          ),
          HrAmountRow(
            label: l10n.hrPayNetPay,
            amount: t.net,
            currency: currency,
          ),
          HrAmountRow(
            label: l10n.hrPayTotalCost,
            amount: t.employerCost,
            currency: currency,
            strong: true,
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: OutlinedButton.icon(
              key: const Key('hr-returns-copy'),
              onPressed: slips.isEmpty
                  ? null
                  : () async {
                      await Clipboard.setData(ClipboardData(text: tsv()));
                      if (context.mounted) {
                        hrToast(context, l10n.hrPayReturnsCopied);
                      }
                    },
              style: hrSecondaryButtonStyle(),
              icon: const Icon(Icons.copy_all_outlined, size: 17),
              label: Text(l10n.hrPayReturnsCopy),
            ),
          ),
        ],
      ),
    );
    final list = slips.isEmpty
        ? HrPanel(
            child: HrEmptyState(
              compact: true,
              icon: Icons.receipt_long_outlined,
              message: l10n.hrPayNoPayslipsThisMonth,
            ),
          )
        : HrPanel(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                for (final s in slips)
                  ListTile(
                    dense: true,
                    title: Text(
                      people[s.employeeId]?.fullName ?? '—',
                      style: HrType.bodyStrong,
                    ),
                    subtitle: Text(
                      '${l10n.hrPayGross} ${formatMoney(s.gross, s.currency)} · '
                      '${l10n.hrPayPaye} ${formatMoney(s.paye, s.currency)}',
                      style: HrType.caption,
                    ),
                    trailing: Text(
                      formatMoney(s.netPay, s.currency),
                      style: HrType.bodyStrong,
                    ),
                  ),
              ],
            ),
          );

    // Side by side on a desk: the totals to file, and who they add up from.
    if (MediaQuery.sizeOf(context).width >= 1000) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(flex: 5, child: summary),
          const SizedBox(width: 16),
          Expanded(flex: 6, child: list),
        ],
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [summary, const SizedBox(height: 12), list],
    );
  }
}

// ─── Person picker ────────────────────────────────────────────────────────────

class _PersonPicker extends StatefulWidget {
  const _PersonPicker({required this.accounts});
  final List<EmployeePayAccount> accounts;

  @override
  State<_PersonPicker> createState() => _PersonPickerState();
}

class _PersonPickerState extends State<_PersonPicker> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final l10n = context.flipperL10n;
    final q = _query.trim().toLowerCase();
    final list =
        widget.accounts
            .where(
              (a) => q.isEmpty || a.employee.fullName.toLowerCase().contains(q),
            )
            .toList()
          ..sort((a, b) {
            if (a.isDue != b.isDue) return a.isDue ? -1 : 1;
            return a.employee.fullName.compareTo(b.employee.fullName);
          });
    return HrSheetFrame(
      title: l10n.hrPayChoosePerson,
      children: [
        HrSearchField(
          hintText: l10n.hrSearchPeople,
          onChanged: (v) => setState(() => _query = v),
        ),
        const SizedBox(height: 8),
        for (final a in list)
          ListTile(
            key: Key('hr-pick-${a.employee.id}'),
            contentPadding: EdgeInsets.zero,
            onTap: () => Navigator.of(context).pop(a),
            leading: HrPersonAvatar(
              initials: a.employee.initials,
              seed: a.employee.id,
            ),
            title: Text(a.employee.fullName, style: HrType.bodyStrong),
            subtitle: Text(
              a.isDue
                  ? l10n.hrPayDueFor(formatPeriodOf(a.nextPeriod))
                  : l10n.hrPayNextOn(formatShortDate(a.nextPayDate)),
              style: HrType.caption,
            ),
            trailing: a.advanceBalance > 0
                ? HrPill(
                    label: l10n.hrPayOwesBack(
                      formatCompactMoney(a.advanceBalance, a.employee.currency),
                    ),
                    tone: HrTone.warning,
                  )
                : null,
          ),
      ],
    );
  }
}
