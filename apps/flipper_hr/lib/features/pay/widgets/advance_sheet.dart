import 'package:flipper_hr/features/pay/data/pay_models.dart';
import 'package:flipper_hr/features/pay/data/pay_period.dart';
import 'package:flipper_hr/features/pay/data/pay_providers.dart';
import 'package:flipper_hr/features/pay/data/rwanda_payroll.dart';
import 'package:flipper_hr/features/pay/widgets/pay_ui.dart';
import 'package:flipper_hr/features/people/data/employee.dart';
import 'package:flipper_hr/features/people/data/money_format.dart';
import 'package:flipper_hr/features/people/data/people_providers.dart';
import 'package:flipper_hr/features/ui/hr_ui.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Give [account] an advance. Resolves true when one was recorded.
Future<bool?> showGiveAdvanceSheet(
  BuildContext context, {
  required EmployeePayAccount account,
}) =>
    showHrSheet<bool>(context, builder: (_) => AdvanceSheet(account: account));

/// The signed-in person asks for an advance. Resolves true once filed.
Future<bool?> showRequestAdvanceSheet(
  BuildContext context, {
  required EmployeePayAccount account,
}) => showHrSheet<bool>(
  context,
  builder: (_) => AdvanceSheet(account: account, isRequest: true),
);

enum _Recovery { nextPay, installments }

/// Money ahead of pay — given by a manager, or asked for by the person.
class AdvanceSheet extends ConsumerStatefulWidget {
  const AdvanceSheet({
    super.key,
    required this.account,
    this.isRequest = false,
  });

  final EmployeePayAccount account;

  /// The person asking for themselves: no method, no recovery plan — those are
  /// the manager's to decide when they approve.
  final bool isRequest;

  @override
  ConsumerState<AdvanceSheet> createState() => _AdvanceSheetState();
}

class _AdvanceSheetState extends ConsumerState<AdvanceSheet> {
  final _amount = TextEditingController();
  final _installment = TextEditingController();
  final _reason = TextEditingController();
  final _reference = TextEditingController();
  late PaymentMethod _method;
  _Recovery _recovery = _Recovery.nextPay;
  bool _busy = false;
  String? _error;

  Employee get _e => widget.account.employee;

  @override
  void initState() {
    super.initState();
    _method = _e.paymentMethod;
  }

  @override
  void dispose() {
    _amount.dispose();
    _installment.dispose();
    _reason.dispose();
    _reference.dispose();
    super.dispose();
  }

  /// Half of one period's pay after compulsory deductions: the most a single
  /// payslip may take back (Law 66/2018 art. 73).
  double _recoverablePerPayslip() {
    final period = widget.account.nextPeriod;
    final f = computeRwandaPayslip(
      PayslipInput(
        basePay: basePayFor(
          _e,
          units: switch (_e.payFrequency) {
            PayFrequency.daily => Employee.workingDaysPerMonth.toDouble(),
            PayFrequency.hourly =>
              (Employee.workingDaysPerMonth * Employee.workingHoursPerDay)
                  .toDouble(),
            _ => null,
          },
        ),
        allowances: allowancesFor(_e, period),
        periodStart: period.start,
        periodEnd: period.end,
        taxCategory: _e.taxCategory,
        rssbEnrolled: _e.rssbEnrolled,
      ),
    );
    return f.maxRecovery;
  }

  Future<void> _submit() async {
    final l10n = context.flipperL10n;
    final amount = parseMoneyInput(_amount.text) ?? 0;
    if (amount <= 0) {
      setState(() => _error = l10n.hrPayEnterAmount);
      return;
    }
    double? step;
    if (!widget.isRequest && _recovery == _Recovery.installments) {
      step = parseMoneyInput(_installment.text);
      if (step == null || step <= 0) {
        setState(() => _error = l10n.hrAdvanceEnterInstallment);
        return;
      }
    }
    setState(() {
      _busy = true;
      _error = null;
    });
    final actions = ref.read(payActionsProvider);
    try {
      if (widget.isRequest) {
        await actions.requestAdvance(_e, amount: amount, reason: _reason.text);
      } else {
        await actions.giveAdvance(
          employee: _e,
          amount: amount,
          method: _method,
          givenOn: ref.read(hrClockProvider)(),
          reference: _reference.text,
          reason: _reason.text,
          installmentAmount: step,
        );
      }
      if (mounted) Navigator.of(context).pop(true);
    } catch (e) {
      if (mounted) {
        setState(() {
          _busy = false;
          _error = e.toString().replaceFirst('PayRepositoryException: ', '');
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.flipperL10n;
    final currency = _e.currency;
    final owed = widget.account.advanceBalance;
    final amount = parseMoneyInput(_amount.text) ?? 0;
    final perPayslip = _recoverablePerPayslip();
    final heavy = amount > 0 && owed + amount > perPayslip;

    return HrSheetFrame(
      title: widget.isRequest
          ? l10n.hrAdvanceRequestTitle
          : l10n.hrAdvanceGiveTitle(_e.fullName),
      subtitle: widget.isRequest
          ? l10n.hrAdvanceRequestSubtitle
          : l10n.hrAdvanceGiveSubtitle,
      leading: HrPersonAvatar(initials: _e.initials, seed: _e.id, radius: 20),
      actions: [
        OutlinedButton(
          onPressed: _busy ? null : () => Navigator.of(context).pop(),
          style: hrSecondaryButtonStyle(height: 44),
          child: Text(l10n.cancel),
        ),
        FilledButton.icon(
          key: const Key('hr-advance-confirm'),
          onPressed: _busy ? null : _submit,
          style: hrPrimaryButtonStyle(height: 44),
          icon: const Icon(Icons.check, size: 18),
          label: Text(
            widget.isRequest
                ? l10n.hrAdvanceSendRequest
                : l10n.hrAdvanceGiveAmount(formatMoney(amount, currency)),
          ),
        ),
      ],
      children: [
        if (owed > 0) ...[
          HrCallout(
            calloutKey: const Key('hr-advance-owed'),
            tone: HrTone.warning,
            icon: Icons.history,
            message: l10n.hrAdvanceAlreadyOwed(formatMoney(owed, currency)),
          ),
          const SizedBox(height: 12),
        ],
        HrMoneyField(
          fieldKey: const Key('hr-advance-amount'),
          controller: _amount,
          autofocus: true,
          label: l10n.hrAdvanceAmount,
          currency: currency,
          onChanged: (_) => setState(() {}),
        ),
        if (heavy) ...[
          const SizedBox(height: 10),
          HrCallout(
            calloutKey: const Key('hr-advance-heavy'),
            tone: HrTone.warning,
            icon: Icons.warning_amber_rounded,
            message: l10n.hrAdvanceOverHalf(formatMoney(perPayslip, currency)),
          ),
        ],
        const SizedBox(height: 12),
        TextField(
          controller: _reason,
          decoration: hrInputDecoration(
            label: l10n.hrAdvanceReason,
            hint: l10n.hrAdvanceReasonHint,
          ),
        ),
        if (!widget.isRequest) ...[
          HrSubheading(l10n.hrPayPayment),
          HrMethodChips(
            value: _method,
            onChanged: (m) => setState(() => _method = m),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _reference,
            decoration: hrInputDecoration(
              label: l10n.hrPayReference,
              hint: l10n.hrPayReferenceHint,
            ),
          ),
          HrSubheading(l10n.hrAdvanceRecovery),
          RadioGroup<_Recovery>(
            groupValue: _recovery,
            onChanged: (v) => setState(() => _recovery = v ?? _recovery),
            child: Column(
              children: [
                RadioListTile<_Recovery>(
                  contentPadding: EdgeInsets.zero,
                  value: _Recovery.nextPay,
                  title: Text(l10n.hrAdvanceRecoverNextPay),
                  subtitle: Text(
                    l10n.hrAdvanceRecoverNextPayHint,
                    style: HrType.caption,
                  ),
                ),
                RadioListTile<_Recovery>(
                  key: const Key('hr-advance-installments'),
                  contentPadding: EdgeInsets.zero,
                  value: _Recovery.installments,
                  title: Text(l10n.hrAdvanceRecoverInstallments),
                ),
              ],
            ),
          ),
          if (_recovery == _Recovery.installments)
            HrMoneyField(
              fieldKey: const Key('hr-advance-installment'),
              controller: _installment,
              label: l10n.hrAdvancePerPayslip,
              currency: currency,
              helper: _installmentHelper(l10n, amount),
              onChanged: (_) => setState(() {}),
            ),
        ],
        if (_error != null) ...[
          const SizedBox(height: 12),
          HrCallout(
            tone: HrTone.danger,
            icon: Icons.error_outline,
            message: _error!,
          ),
        ],
      ],
    );
  }

  String? _installmentHelper(FlipperAppLocalizations l10n, double amount) {
    final step = parseMoneyInput(_installment.text) ?? 0;
    if (step <= 0 || amount <= 0) return null;
    final count = (amount / step).ceil();
    return l10n.hrAdvanceInstallmentCount('$count');
  }
}

/// Approve or decline an employee's advance request.
Future<void> decideAdvanceRequest(
  BuildContext context,
  WidgetRef ref, {
  required Employee employee,
  required AdvanceRequest request,
  required bool approve,
  String? deciderUserId,
}) async {
  final l10n = context.flipperL10n;
  final actions = ref.read(payActionsProvider);
  try {
    if (approve) {
      await actions.approveRequest(
        employee,
        request,
        method: employee.paymentMethod,
        decidedBy: deciderUserId,
      );
      if (context.mounted) {
        hrToast(
          context,
          l10n.hrAdvanceApprovedToast(
            formatMoney(request.amount, employee.currency),
            employee.fullName,
          ),
        );
      }
    } else {
      final note = await askReason(
        context,
        title: l10n.hrAdvanceDeclineTitle,
        message: l10n.hrAdvanceDeclineMessage,
        confirmLabel: l10n.hrAdvanceDecline,
      );
      if (note == null) return;
      await actions.declineRequest(
        employee,
        request,
        decidedBy: deciderUserId,
        note: note,
      );
    }
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
