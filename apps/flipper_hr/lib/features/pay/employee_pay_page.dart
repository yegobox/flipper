import 'package:flipper_hr/features/pay/data/pay_models.dart';
import 'package:flipper_hr/features/pay/data/pay_period.dart';
import 'package:flipper_hr/features/pay/data/pay_providers.dart';
import 'package:flipper_hr/features/pay/pay_page.dart';
import 'package:flipper_hr/features/pay/widgets/advance_sheet.dart';
import 'package:flipper_hr/features/pay/widgets/pay_sheet.dart';
import 'package:flipper_hr/features/pay/widgets/pay_timeline.dart';
import 'package:flipper_hr/features/pay/widgets/pay_ui.dart';
import 'package:flipper_hr/features/pay/widgets/payslip_sheet.dart';
import 'package:flipper_hr/features/people/data/employee.dart';
import 'package:flipper_hr/features/people/data/money_format.dart';
import 'package:flipper_hr/features/people/data/people_providers.dart';
import 'package:flipper_hr/features/ui/hr_ui.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// One person's pay, for whoever runs the business: where they stand, every
/// payment and advance, and the actions to pay them.
class EmployeePayPage extends ConsumerWidget {
  const EmployeePayPage({
    super.key,
    required this.branchId,
    required this.employeeId,
  });

  final String branchId;
  final String employeeId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.flipperL10n;
    final roster = ref.watch(rosterProvider(branchId));
    final book = ref.watch(employeePayBookProvider(employeeId));
    final now = ref.watch(hrClockProvider)();

    Employee? employee;
    for (final e in roster.value ?? const <Employee>[]) {
      if (e.id == employeeId) employee = e;
    }

    if (roster.isLoading || book.isLoading && book.value == null) {
      return const Center(child: CircularProgressIndicator());
    }
    if (employee == null || book.hasError) {
      return Center(
        child: HrEmptyState(
          icon: Icons.person_off_outlined,
          message: book.hasError
              ? '${book.error}'.replaceFirst('PayRepositoryException: ', '')
              : l10n.hrPayPersonNotFound,
          actionLabel: l10n.hrPayBackToPayroll,
          onAction: () => context.go('/pay'),
        ),
      );
    }

    final b = book.value!;
    final account = EmployeePayAccount(
      employee: employee,
      payslips: b.payslips,
      payments: b.payments,
      advances: b.advances,
      today: now,
    );
    return PersonPayView(
      account: account,
      requests: b.requests,
      canManage: true,
      onBack: () => context.go('/pay'),
    );
  }
}

/// The shared body of a manager's per-person page and an employee's "My pay".
class PersonPayView extends ConsumerWidget {
  const PersonPayView({
    super.key,
    required this.account,
    required this.requests,
    required this.canManage,
    this.onBack,
  });

  final EmployeePayAccount account;
  final List<AdvanceRequest> requests;
  final bool canManage;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.flipperL10n;
    final e = account.employee;
    final narrow = MediaQuery.sizeOf(context).width < hrSheetBreakpoint;
    final last = account.lastPayment;
    final latestSlip = account.livePayslips.isEmpty
        ? null
        : account.livePayslips.first;
    final pending = requests.where((r) => r.isPending).toList();

    Future<void> pay() async {
      final slip = await showPaySheet(context, account: account);
      if (slip != null && context.mounted) {
        hrToast(
          context,
          l10n.hrPayPaidToast(
            e.fullName,
            formatPayPeriod(slip.periodStart, slip.periodEnd),
          ),
        );
      }
    }

    Future<void> advance() async {
      final ok = canManage
          ? await showGiveAdvanceSheet(context, account: account)
          : await showRequestAdvanceSheet(context, account: account);
      if (ok == true && context.mounted) {
        hrToast(
          context,
          canManage
              ? l10n.hrAdvanceRecordedToast
              : l10n.hrAdvanceRequestedToast,
        );
      }
    }

    return RefreshIndicator(
      onRefresh: () async => ref.invalidate(employeePayBookProvider(e.id)),
      child: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 960),
          child: ListView(
            padding: EdgeInsets.fromLTRB(
              narrow ? 16 : 24,
              narrow ? 12 : 24,
              narrow ? 16 : 24,
              32,
            ),
            children: [
              if (onBack != null)
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton.icon(
                    key: const Key('hr-pay-back'),
                    onPressed: onBack,
                    icon: const Icon(Icons.arrow_back, size: 18),
                    label: Text(l10n.hrPayroll),
                  ),
                ),
              Row(
                children: [
                  HrPersonAvatar(initials: e.initials, seed: e.id, radius: 26),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(e.fullName, style: HrType.display),
                        Text(
                          [
                            if (e.jobTitle.isNotEmpty) e.jobTitle,
                            '${formatMoney(e.baseSalary, e.currency)} · ${e.payFrequency.label}',
                          ].join(' · '),
                          style: HrType.caption,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              HrStatGrid(
                tiles: [
                  (w) => HrStatTile(
                    width: w,
                    key: const Key('hr-person-next-pay'),
                    label: account.isDue
                        ? l10n.hrPayDueNow
                        : l10n.hrPayNextPayDay,
                    value: formatShortDate(account.nextPayDate),
                    icon: Icons.event_outlined,
                    tone: account.isDue ? HrTone.danger : HrTone.info,
                    hint: formatPeriodOf(account.nextPeriod),
                  ),
                  (w) => HrStatTile(
                    width: w,
                    key: const Key('hr-person-owed'),
                    label: l10n.hrPayAdvancesOwed,
                    value: formatMoney(account.advanceBalance, e.currency),
                    icon: Icons.savings_outlined,
                    tone: account.advanceBalance > 0
                        ? HrTone.warning
                        : HrTone.neutral,
                  ),
                  (w) => HrStatTile(
                    width: w,
                    key: const Key('hr-person-last-paid'),
                    label: l10n.hrPayLastPayment,
                    value: last == null
                        ? '—'
                        : formatMoney(last.amount, last.currency),
                    icon: Icons.history,
                    hint: last == null ? null : formatShortDate(last.paidOn),
                  ),
                  if (latestSlip != null)
                    (w) => HrStatTile(
                      width: w,
                      label: l10n.hrPayLatestNet,
                      value: formatMoney(
                        latestSlip.netPay,
                        latestSlip.currency,
                      ),
                      icon: Icons.receipt_long_outlined,
                      hint: formatPayPeriod(
                        latestSlip.periodStart,
                        latestSlip.periodEnd,
                      ),
                      onTap: () => showPayslipSheet(
                        context,
                        slip: latestSlip,
                        employee: e,
                        payments: account.payments,
                        canManage: canManage,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  if (canManage)
                    FilledButton.icon(
                      key: const Key('hr-person-pay'),
                      onPressed: e.isActive ? pay : null,
                      style: hrPrimaryButtonStyle(height: 44),
                      icon: const Icon(Icons.payments_outlined, size: 18),
                      label: Text(
                        l10n.hrPayPayFor(formatPeriodOf(account.nextPeriod)),
                      ),
                    ),
                  OutlinedButton.icon(
                    key: const Key('hr-person-advance'),
                    onPressed: e.isActive && (canManage || pending.isEmpty)
                        ? advance
                        : null,
                    style: hrSecondaryButtonStyle(height: 44),
                    icon: const Icon(Icons.savings_outlined, size: 18),
                    label: Text(
                      canManage ? l10n.hrAdvanceGive : l10n.hrAdvanceRequest,
                    ),
                  ),
                ],
              ),
              if (pending.isNotEmpty) ...[
                const SizedBox(height: 16),
                for (final r in pending)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: HrCallout(
                      calloutKey: Key('hr-pending-request-${r.id}'),
                      tone: HrTone.warning,
                      icon: Icons.hourglass_top,
                      message: l10n.hrAdvanceRequestPending(
                        formatMoney(r.amount, e.currency),
                      ),
                    ),
                  ),
                if (canManage)
                  Wrap(
                    spacing: 8,
                    children: [
                      for (final r in pending) ...[
                        OutlinedButton(
                          onPressed: () => decideAdvanceRequest(
                            context,
                            ref,
                            employee: e,
                            request: r,
                            approve: false,
                          ),
                          style: hrSecondaryButtonStyle(height: 36),
                          child: Text(l10n.hrAdvanceDecline),
                        ),
                        FilledButton(
                          onPressed: () => decideAdvanceRequest(
                            context,
                            ref,
                            employee: e,
                            request: r,
                            approve: true,
                          ),
                          style: hrPrimaryButtonStyle(height: 36),
                          child: Text(l10n.hrAdvanceApproveAndGive),
                        ),
                      ],
                    ],
                  )
                else
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton(
                      key: const Key('hr-cancel-request'),
                      onPressed: () async {
                        try {
                          await ref
                              .read(payActionsProvider)
                              .cancelRequest(e, pending.first);
                        } catch (err) {
                          if (context.mounted) {
                            hrToast(context, '$err', error: true);
                          }
                        }
                      },
                      child: Text(l10n.hrAdvanceCancelRequest),
                    ),
                  ),
              ],
              if (account.openAdvances.isNotEmpty) ...[
                const SizedBox(height: 20),
                HrSectionHeader(
                  title: l10n.hrPayAdvances,
                  count: account.openAdvances.length,
                ),
                const SizedBox(height: 10),
                for (final a in account.openAdvances)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: AdvanceTile(
                      advance: a,
                      employee: e,
                      canManage: canManage,
                      showPerson: false,
                    ),
                  ),
              ],
              const SizedBox(height: 20),
              HrSectionHeader(title: l10n.hrPayHistory),
              const SizedBox(height: 10),
              PayTimeline(account: account, canManage: canManage),
            ],
          ),
        ),
      ),
    );
  }
}
