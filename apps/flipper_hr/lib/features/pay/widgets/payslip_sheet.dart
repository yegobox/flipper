import 'package:flipper_hr/features/pay/data/pay_models.dart';
import 'package:flipper_hr/features/pay/data/pay_providers.dart';
import 'package:flipper_hr/features/pay/data/pay_repository.dart';
import 'package:flipper_hr/features/pay/widgets/pay_ui.dart';
import 'package:flipper_hr/features/pay/widgets/payslip_pdf.dart';
import 'package:flipper_hr/features/people/data/employee.dart';
import 'package:flipper_hr/features/people/data/money_format.dart';
import 'package:flipper_hr/features/people/data/people_providers.dart';
import 'package:flipper_hr/features/ui/hr_ui.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_web/features/business_selection/business_branch_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:printing/printing.dart';

Future<void> showPayslipSheet(
  BuildContext context, {
  required Payslip slip,
  required Employee employee,
  required List<PayPayment> payments,
  bool canManage = true,
}) => showHrSheet<void>(
  context,
  builder: (_) => PayslipSheet(
    slip: slip,
    employee: employee,
    payments: payments,
    canManage: canManage,
  ),
);

/// One payslip: the breakdown, what has been paid against it, and — for a
/// manager — paying the rest or voiding it.
class PayslipSheet extends ConsumerStatefulWidget {
  const PayslipSheet({
    super.key,
    required this.slip,
    required this.employee,
    required this.payments,
    this.canManage = true,
  });

  final Payslip slip;
  final Employee employee;
  final List<PayPayment> payments;
  final bool canManage;

  @override
  ConsumerState<PayslipSheet> createState() => _PayslipSheetState();
}

class _PayslipSheetState extends ConsumerState<PayslipSheet> {
  bool _busy = false;

  Payslip get _s => widget.slip;
  List<PayPayment> get _paid =>
      widget.payments.where((p) => p.payslipId == _s.id).toList();

  Future<void> _share() async {
    final business = ref.read(selectedBusinessProvider)?.name ?? '';
    final bytes = await buildPayslipPdf(
      slip: _s,
      employee: widget.employee,
      businessName: business,
      payments: _paid,
    );
    final name = widget.employee.fullName.replaceAll(RegExp(r'\s+'), '_');
    await Printing.sharePdf(
      bytes: bytes,
      filename:
          'payslip_${name}_${formatPayPeriod(_s.periodStart, _s.periodEnd).replaceAll(' ', '_')}.pdf',
    );
  }

  Future<void> _payRest() async {
    final l10n = context.flipperL10n;
    final draft = await showHrSheet<PaymentDraft>(
      context,
      builder: (_) => PaymentSheet(
        title: l10n.hrPayRemainingTitle,
        employee: widget.employee,
        maxAmount: _s.outstanding,
        currency: _s.currency,
      ),
    );
    if (draft == null || !mounted) return;
    setState(() => _busy = true);
    try {
      await ref
          .read(payActionsProvider)
          .payBalance(employee: widget.employee, payslip: _s, payment: draft);
      if (mounted) {
        Navigator.of(context).pop();
        hrToast(context, l10n.hrPayRecordedToast);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _busy = false);
        hrToast(context, _clean(e), error: true);
      }
    }
  }

  Future<void> _void() async {
    final l10n = context.flipperL10n;
    final reason = await askReason(
      context,
      title: l10n.hrPayVoidPayslipTitle,
      message: _paid.any((p) => !p.voided)
          ? l10n.hrPayVoidPayslipWithPayments
          : l10n.hrPayVoidPayslipMessage,
      confirmLabel: l10n.hrPayVoid,
    );
    if (reason == null || !mounted) return;
    setState(() => _busy = true);
    try {
      final actions = ref.read(payActionsProvider);
      // Payments first: the database refuses to void a payslip that still has
      // live money against it.
      for (final p in _paid.where((p) => !p.voided)) {
        await actions.voidPayment(widget.employee, p, reason);
      }
      await actions.voidPayslip(widget.employee, _s, reason);
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      if (mounted) {
        setState(() => _busy = false);
        hrToast(context, _clean(e), error: true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.flipperL10n;
    final c = _s.currency;
    return HrSheetFrame(
      title: l10n.hrPayslipFor(formatPayPeriod(_s.periodStart, _s.periodEnd)),
      subtitle: widget.employee.fullName,
      leading: HrPill(label: _s.status.label, tone: payslipTone(_s.status)),
      actions: [
        if (widget.canManage && !_s.isVoid)
          TextButton(
            key: const Key('hr-payslip-void'),
            onPressed: _busy ? null : _void,
            child: Text(l10n.hrPayVoid),
          ),
        OutlinedButton.icon(
          key: const Key('hr-payslip-share'),
          onPressed: _busy ? null : _share,
          style: hrSecondaryButtonStyle(height: 44),
          icon: const Icon(Icons.ios_share, size: 18),
          label: Text(l10n.hrPayShareSlip),
        ),
        if (widget.canManage && _s.outstanding > 0 && !_s.isVoid)
          FilledButton.icon(
            key: const Key('hr-payslip-pay-rest'),
            onPressed: _busy ? null : _payRest,
            style: hrPrimaryButtonStyle(height: 44),
            icon: const Icon(Icons.payments_outlined, size: 18),
            label: Text(l10n.hrPayRemaining(formatMoney(_s.outstanding, c))),
          ),
      ],
      children: [
        if (_s.isVoid && _s.voidReason != null)
          HrCallout(
            tone: HrTone.danger,
            icon: Icons.block,
            message: l10n.hrPayVoidedBecause(_s.voidReason!),
          ),
        HrSubheading(l10n.hrPayEarnings),
        HrAmountRow(label: l10n.hrPayBasePay, amount: _s.basePay, currency: c),
        if (_s.allowances > 0)
          HrAmountRow(
            label: l10n.hrPayAllowances,
            amount: _s.allowances,
            currency: c,
          ),
        if (_s.extraEarnings > 0)
          HrAmountRow(
            label: l10n.hrPayBonus,
            amount: _s.extraEarnings,
            currency: c,
          ),
        HrAmountRow(
          label: l10n.hrPayGross,
          amount: _s.gross,
          currency: c,
          strong: true,
        ),
        HrSubheading(l10n.hrPayDeductions),
        HrAmountRow(
          label: l10n.hrPayPaye,
          amount: _s.paye,
          currency: c,
          negative: true,
        ),
        if (_s.pensionEmployee > 0)
          HrAmountRow(
            label: l10n.hrPayPensionPlain,
            amount: _s.pensionEmployee,
            currency: c,
            negative: true,
          ),
        if (_s.maternityEmployee > 0)
          HrAmountRow(
            label: l10n.hrPayMaternity,
            amount: _s.maternityEmployee,
            currency: c,
            negative: true,
          ),
        HrAmountRow(
          label: l10n.hrPayCbhi,
          amount: _s.cbhi,
          currency: c,
          negative: true,
        ),
        if (_s.otherDeductions > 0)
          HrAmountRow(
            label: l10n.hrPayOtherDeductions,
            amount: _s.otherDeductions,
            currency: c,
            negative: true,
          ),
        if (_s.advanceRecovery > 0)
          HrAmountRow(
            label: l10n.hrPayAdvanceRecovered,
            amount: _s.advanceRecovery,
            currency: c,
            negative: true,
          ),
        const SizedBox(height: 10),
        HrTotalBanner(
          label: l10n.hrPayNetPay,
          amount: _s.netPay,
          currency: c,
          caption: _s.outstanding > 0
              ? l10n.hrPayStillToPay(formatMoney(_s.outstanding, c))
              : null,
        ),
        if (widget.canManage) ...[
          HrSubheading(l10n.hrPayEmployerContributions),
          HrAmountRow(
            label: l10n.hrPayPensionPlain,
            amount: _s.pensionEmployer,
            currency: c,
          ),
          HrAmountRow(
            label: l10n.hrPayMaternity,
            amount: _s.maternityEmployer,
            currency: c,
          ),
          HrAmountRow(
            label: l10n.hrPayOccupationalHazards,
            amount: _s.occupationalHazards,
            currency: c,
          ),
        ],
        HrSubheading(l10n.hrPayPaymentsMade),
        if (_paid.isEmpty)
          Text(l10n.hrPayNothingPaidYet, style: HrType.caption)
        else
          for (final p in _paid)
            HrAmountRow(
              label: '${formatShortDate(p.paidOn)} · ${p.method.label}',
              hint: [
                if (p.reference != null) p.reference!,
                if (p.voided) l10n.hrPayStatusVoid,
              ].join(' · ').ifEmptyNull,
              amount: p.amount,
              currency: p.currency,
            ),
      ],
    );
  }
}

/// Records an amount of money handed over. Resolves to the draft, or null.
class PaymentSheet extends ConsumerStatefulWidget {
  const PaymentSheet({
    super.key,
    required this.title,
    required this.employee,
    required this.currency,
    this.maxAmount,
  });

  final String title;
  final Employee employee;
  final String currency;
  final double? maxAmount;

  @override
  ConsumerState<PaymentSheet> createState() => _PaymentSheetState();
}

class _PaymentSheetState extends ConsumerState<PaymentSheet> {
  final _amount = TextEditingController();
  final _reference = TextEditingController();
  late PaymentMethod _method = widget.employee.paymentMethod;
  String? _error;

  @override
  void initState() {
    super.initState();
    final max = widget.maxAmount;
    if (max != null && max > 0) _amount.text = formatNumber(max);
  }

  @override
  void dispose() {
    _amount.dispose();
    _reference.dispose();
    super.dispose();
  }

  void _done() {
    final l10n = context.flipperL10n;
    final amount = parseMoneyInput(_amount.text) ?? 0;
    final max = widget.maxAmount;
    if (amount <= 0) {
      setState(() => _error = l10n.hrPayEnterAmount);
      return;
    }
    if (max != null && amount > max) {
      setState(
        () => _error = l10n.hrPayMoreThanNet(formatMoney(max, widget.currency)),
      );
      return;
    }
    Navigator.of(context).pop(
      PaymentDraft(
        amount: amount,
        method: _method,
        paidOn: ref.read(hrClockProvider)(),
        reference: _reference.text,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.flipperL10n;
    return HrSheetFrame(
      title: widget.title,
      subtitle: widget.employee.fullName,
      actions: [
        OutlinedButton(
          onPressed: () => Navigator.of(context).pop(),
          style: hrSecondaryButtonStyle(height: 44),
          child: Text(l10n.cancel),
        ),
        FilledButton(
          key: const Key('hr-payment-confirm'),
          onPressed: _done,
          style: hrPrimaryButtonStyle(height: 44),
          child: Text(l10n.hrPayRecord),
        ),
      ],
      children: [
        HrMoneyField(
          fieldKey: const Key('hr-payment-amount'),
          controller: _amount,
          label: l10n.hrPayAmountPaidNow,
          currency: widget.currency,
          autofocus: true,
        ),
        const SizedBox(height: 12),
        HrMethodChips(
          value: _method,
          onChanged: (m) => setState(() => _method = m),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _reference,
          decoration: hrInputDecoration(
            label: l10n.hrPayReference,
            hint: l10n.hrPayReferenceHint,
          ),
        ),
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
}

HrTone payslipTone(PayslipStatus s) => switch (s) {
  PayslipStatus.paid => HrTone.positive,
  PayslipStatus.partiallyPaid => HrTone.warning,
  PayslipStatus.unpaid => HrTone.danger,
  PayslipStatus.voided => HrTone.neutral,
};

String _clean(Object e) =>
    e.toString().replaceFirst('PayRepositoryException: ', '');

extension on String {
  String? get ifEmptyNull => isEmpty ? null : this;
}
