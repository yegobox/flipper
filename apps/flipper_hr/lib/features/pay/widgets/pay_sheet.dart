import 'package:flipper_hr/features/branding/hr_tokens.dart';
import 'package:flipper_hr/features/pay/data/pay_models.dart';
import 'package:flipper_hr/features/pay/data/pay_period.dart';
import 'package:flipper_hr/features/pay/data/pay_providers.dart';
import 'package:flipper_hr/features/pay/data/pay_repository.dart';
import 'package:flipper_hr/features/pay/data/rwanda_payroll.dart';
import 'package:flipper_hr/features/pay/widgets/pay_ui.dart';
import 'package:flipper_hr/features/people/data/employee.dart';
import 'package:flipper_hr/features/people/data/money_format.dart';
import 'package:flipper_hr/features/people/data/people_providers.dart';
import 'package:flipper_hr/features/ui/hr_ui.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Opens the pay sheet for [account]'s next due period. Resolves to the
/// payslip created, or null when dismissed.
Future<Payslip?> showPaySheet(
  BuildContext context, {
  required EmployeePayAccount account,
  PayPeriod? period,
}) {
  return showHrSheet<Payslip>(
    context,
    maxWidth: 600,
    builder: (_) => PaySheet(account: account, initialPeriod: period),
  );
}

/// Pay one person for one period.
///
/// Built around the question the owner asked: "how much do I still owe, given
/// what I already handed over?" So before any figure, it says what was paid in
/// this period already; the advances owed are taken back on the payslip, within
/// the half-of-pay limit; and the last line is the cash to hand over now.
class PaySheet extends ConsumerStatefulWidget {
  const PaySheet({super.key, required this.account, this.initialPeriod});

  final EmployeePayAccount account;
  final PayPeriod? initialPeriod;

  @override
  ConsumerState<PaySheet> createState() => _PaySheetState();
}

class _PaySheetState extends ConsumerState<PaySheet> {
  late PayPeriod _period;
  final _units = TextEditingController();
  final _extra = TextEditingController();
  final _other = TextEditingController();
  final _amount = TextEditingController();
  final _reference = TextEditingController();
  final _note = TextEditingController();
  final Map<String, TextEditingController> _recoveries = {};
  late PaymentMethod _method;
  bool _payNow = true;
  bool _amountEdited = false;
  bool _unitsPrefilled = false;
  bool _busy = false;
  String? _error;

  Employee get _e => widget.account.employee;
  bool get _usesUnits =>
      _e.payFrequency == PayFrequency.daily ||
      _e.payFrequency == PayFrequency.hourly;

  @override
  void initState() {
    super.initState();
    _period = widget.initialPeriod ?? widget.account.nextPeriod;
    _method = _e.paymentMethod;
    for (final a in widget.account.openAdvances) {
      _recoveries[a.id] = TextEditingController();
    }
    _resetRecoveries();
  }

  @override
  void dispose() {
    for (final c in [
      _units,
      _extra,
      _other,
      _amount,
      _reference,
      _note,
      ..._recoveries.values,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  /// Each advance's suggested recovery, oldest first, until the legal cap.
  void _resetRecoveries() {
    var room = _figures().maxRecovery;
    final oldestFirst = widget.account.openAdvances.toList()
      ..sort((a, b) => a.givenOn.compareTo(b.givenOn));
    for (final a in oldestFirst) {
      final take = a.suggestedRecovery < room ? a.suggestedRecovery : room;
      room -= take;
      _recoveries[a.id]!.text = take <= 0 ? '' : formatNumber(take);
    }
  }

  double get _unitsValue => parseMoneyInput(_units.text) ?? 0;

  PayslipFigures _figures() => computeRwandaPayslip(
    PayslipInput(
      basePay: basePayFor(_e, units: _unitsValue),
      allowances: allowancesFor(_e, _period),
      extraEarnings: parseMoneyInput(_extra.text) ?? 0,
      otherDeductions: parseMoneyInput(_other.text) ?? 0,
      periodStart: _period.start,
      periodEnd: _period.end,
      taxCategory: _e.taxCategory,
      rssbEnrolled: _e.rssbEnrolled,
    ),
  );

  double get _recoveryTotal => _recoveries.values.fold(
    0.0,
    (sum, c) => sum + (parseMoneyInput(c.text) ?? 0),
  );

  void _move(int direction) {
    setState(() {
      _period = direction < 0
          ? _period.previous(_e.payFrequency)
          : _period.next(_e.payFrequency);
      _unitsPrefilled = false;
      _units.clear();
      _resetRecoveries();
      _amountEdited = false;
    });
  }

  String? _validate(PayslipFigures f) {
    final l10n = context.flipperL10n;
    if (widget.account.payslipFor(_period) != null) {
      return l10n.hrPayPeriodAlreadyPaid;
    }
    if (f.gross <= 0) return l10n.hrPayNothingEarned;
    for (final a in widget.account.openAdvances) {
      final v = parseMoneyInput(_recoveries[a.id]!.text) ?? 0;
      if (v > a.outstanding) {
        return l10n.hrPayRecoverMoreThanOwed(
          formatMoney(a.outstanding, a.currency),
        );
      }
    }
    if (_recoveryTotal > f.maxRecovery) {
      return l10n.hrPayRecoveryOverHalf(
        formatMoney(f.maxRecovery, _e.currency),
      );
    }
    final net = f.netAfter(_recoveryTotal);
    if (net < 0) return l10n.hrPayNetNegative;
    if (_payNow) {
      final pay = parseMoneyInput(_amount.text) ?? 0;
      if (pay <= 0) return l10n.hrPayEnterAmount;
      if (pay > net) {
        return l10n.hrPayMoreThanNet(formatMoney(net, _e.currency));
      }
    }
    return null;
  }

  Future<void> _submit(PayslipFigures f) async {
    final problem = _validate(f);
    if (problem != null) {
      setState(() => _error = problem);
      return;
    }
    setState(() {
      _busy = true;
      _error = null;
    });
    final now = ref.read(hrClockProvider)();
    try {
      final slip = await ref
          .read(payActionsProvider)
          .pay(
            employee: _e,
            period: _period,
            figures: f,
            recoveries: [
              for (final entry in _recoveries.entries)
                AdvanceRecovery(
                  advanceId: entry.key,
                  amount: parseMoneyInput(entry.value.text) ?? 0,
                ),
            ],
            payment: _payNow
                ? PaymentDraft(
                    amount: parseMoneyInput(_amount.text) ?? 0,
                    method: _method,
                    paidOn: now,
                    reference: _reference.text,
                  )
                : null,
            workedMinutes: switch (_e.payFrequency) {
              PayFrequency.hourly => (_unitsValue * 60).round(),
              _ => null,
            },
            note: _note.text,
          );
      if (mounted) Navigator.of(context).pop(slip);
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
    final account = widget.account;
    final currency = _e.currency;

    // Days or hours worked come from attendance, once per period, and stay
    // editable — attendance is a starting point, not the last word.
    if (_usesUnits && !_unitsPrefilled) {
      final worked = ref.watch(
        workedTimeProvider(EmployeePeriod(_e.id, _period)),
      );
      worked.whenData((w) {
        _unitsPrefilled = true;
        final v = _e.payFrequency == PayFrequency.hourly
            ? (w.hours * 100).round() / 100
            : w.days.toDouble();
        if (_units.text.isEmpty && v > 0) {
          _units.text = formatNumber(v);
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) setState(_resetRecoveries);
          });
        }
      });
    }

    final f = _figures();
    final net = f.netAfter(_recoveryTotal);
    if (!_amountEdited) {
      final text = net > 0 ? formatNumber(net) : '';
      if (_amount.text != text) _amount.text = text;
    }

    final alreadyPaid = account.livePayments
        .where((p) => _period.contains(p.paidOn))
        .toList();
    final existing = account.payslipFor(_period);

    return HrSheetFrame(
      title: l10n.hrPayPersonTitle(_e.fullName),
      subtitle: [
        if (_e.jobTitle.isNotEmpty) _e.jobTitle,
        _e.payFrequency.label,
        _e.paymentMethod.label,
      ].join(' · '),
      leading: HrPersonAvatar(initials: _e.initials, seed: _e.id, radius: 20),
      actions: [
        OutlinedButton(
          onPressed: _busy ? null : () => Navigator.of(context).pop(),
          style: hrSecondaryButtonStyle(height: 44),
          child: Text(l10n.cancel),
        ),
        FilledButton.icon(
          key: const Key('hr-pay-confirm'),
          onPressed: _busy || existing != null ? null : () => _submit(f),
          style: hrPrimaryButtonStyle(height: 44),
          icon: _busy
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : const Icon(Icons.check, size: 18),
          label: Text(
            _payNow
                ? l10n.hrPayConfirmAmount(
                    formatMoney(parseMoneyInput(_amount.text) ?? 0, currency),
                  )
                : l10n.hrPaySaveUnpaid,
          ),
        ),
      ],
      children: [
        // ── Period ───────────────────────────────────────────────────────
        Row(
          children: [
            IconButton(
              key: const Key('hr-pay-prev-period'),
              onPressed: _busy ? null : () => _move(-1),
              icon: const Icon(Icons.chevron_left),
            ),
            Expanded(
              child: Column(
                children: [
                  Text(
                    formatPeriodOf(_period),
                    key: const Key('hr-pay-period'),
                    style: HrType.title,
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    l10n.hrPayDueOn(
                      formatShortDate(
                        _period.payDate(_e.payFrequency, _e.payDay),
                      ),
                    ),
                    style: HrType.caption,
                  ),
                ],
              ),
            ),
            IconButton(
              key: const Key('hr-pay-next-period'),
              onPressed: _busy ? null : () => _move(1),
              icon: const Icon(Icons.chevron_right),
            ),
          ],
        ),
        if (existing != null) ...[
          const SizedBox(height: 8),
          HrCallout(
            tone: HrTone.positive,
            icon: Icons.check_circle_outline,
            message: l10n.hrPayPeriodHasPayslip(
              existing.status.label,
              formatMoney(existing.netPay, existing.currency),
            ),
          ),
        ],

        // ── What was already handed over ────────────────────────────────
        if (alreadyPaid.isNotEmpty) ...[
          const SizedBox(height: 10),
          HrCallout(
            calloutKey: const Key('hr-pay-already-paid'),
            tone: HrTone.warning,
            icon: Icons.history,
            message: [
              l10n.hrPayAlreadyPaidThisPeriod(
                formatMoney(
                  alreadyPaid.fold(0.0, (s, p) => s + p.amount),
                  currency,
                ),
              ),
              for (final p in alreadyPaid)
                '• ${p.kind.label} · ${formatMoney(p.amount, p.currency)} · '
                    '${formatShortDate(p.paidOn)}',
            ].join('\n'),
          ),
        ],

        // ── Earnings ─────────────────────────────────────────────────────
        HrSubheading(l10n.hrPayEarnings),
        if (_usesUnits) ...[
          TextField(
            key: const Key('hr-pay-units'),
            controller: _units,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            onChanged: (_) => setState(_resetRecoveries),
            decoration: hrInputDecoration(
              label: _e.payFrequency == PayFrequency.hourly
                  ? l10n.hrPayHoursWorked
                  : l10n.hrPayDaysWorked,
              helper: l10n.hrPayRateHelper(
                formatMoney(_e.baseSalary, currency),
              ),
            ),
          ),
          const SizedBox(height: 10),
        ],
        HrAmountRow(
          label: l10n.hrPayBasePay,
          amount: f.basePay,
          currency: currency,
        ),
        if (f.allowances > 0)
          HrAmountRow(
            label: l10n.hrPayAllowances,
            amount: f.allowances,
            currency: currency,
          ),
        const SizedBox(height: 6),
        HrMoneyField(
          fieldKey: const Key('hr-pay-extra'),
          controller: _extra,
          label: l10n.hrPayBonus,
          currency: currency,
          onChanged: (_) => setState(_resetRecoveries),
        ),
        const SizedBox(height: 6),
        HrAmountRow(
          label: l10n.hrPayGross,
          amount: f.gross,
          currency: currency,
          strong: true,
        ),

        // ── Deductions ───────────────────────────────────────────────────
        HrSubheading(l10n.hrPayDeductions),
        HrAmountRow(
          label: l10n.hrPayPaye,
          hint: _e.taxCategory.label,
          amount: f.paye,
          currency: currency,
          negative: true,
        ),
        if (_e.rssbEnrolled) ...[
          HrAmountRow(
            label: l10n.hrPayPension(
              '${(f.rates.pensionEmployee * 100).round()}',
            ),
            amount: f.pensionEmployee,
            currency: currency,
            negative: true,
          ),
          HrAmountRow(
            label: l10n.hrPayMaternity,
            amount: f.maternityEmployee,
            currency: currency,
            negative: true,
          ),
        ],
        HrAmountRow(
          label: l10n.hrPayCbhi,
          amount: f.cbhi,
          currency: currency,
          negative: true,
        ),
        const SizedBox(height: 6),
        HrMoneyField(
          fieldKey: const Key('hr-pay-other'),
          controller: _other,
          label: l10n.hrPayOtherDeductions,
          currency: currency,
          onChanged: (_) => setState(_resetRecoveries),
        ),

        // ── Advances ─────────────────────────────────────────────────────
        if (account.openAdvances.isNotEmpty) ...[
          HrSubheading(l10n.hrPayAdvancesToRecover),
          for (final a in account.openAdvances)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: HrMoneyField(
                fieldKey: Key('hr-pay-recover-${a.id}'),
                controller: _recoveries[a.id]!,
                label: l10n.hrPayAdvanceOf(
                  formatMoney(a.amount, a.currency),
                  formatShortDate(a.givenOn),
                ),
                helper: l10n.hrPayStillOwed(
                  formatMoney(a.outstanding, a.currency),
                ),
                currency: currency,
                onChanged: (_) => setState(() {}),
              ),
            ),
          Text(
            l10n.hrPayRecoveryLimit(formatMoney(f.maxRecovery, currency)),
            style: HrType.caption,
          ),
        ],

        const SizedBox(height: 14),
        HrTotalBanner(
          valueKey: const Key('hr-pay-net'),
          label: l10n.hrPayNetPay,
          amount: net,
          currency: currency,
          caption: l10n.hrPayEmployerCost(
            formatMoney(f.employerCost, currency),
          ),
        ),

        // ── Hand it over ─────────────────────────────────────────────────
        HrSubheading(l10n.hrPayPayment),
        SwitchListTile.adaptive(
          key: const Key('hr-pay-now'),
          contentPadding: EdgeInsets.zero,
          value: _payNow,
          onChanged: (v) => setState(() => _payNow = v),
          title: Text(l10n.hrPayRecordPaymentNow, style: HrType.bodyStrong),
          subtitle: Text(l10n.hrPayRecordPaymentHint, style: HrType.caption),
        ),
        if (_payNow) ...[
          HrMethodChips(
            value: _method,
            onChanged: (m) => setState(() => _method = m),
          ),
          if (_method == PaymentMethod.mobileMoney &&
              _e.momoPhone.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(l10n.hrPaySendTo(_e.momoPhone), style: HrType.caption),
          ],
          if (_method == PaymentMethod.bankTransfer &&
              _e.bankAccount.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              l10n.hrPaySendTo('${_e.bankName} ${_e.bankAccount}'.trim()),
              style: HrType.caption,
            ),
          ],
          const SizedBox(height: 10),
          HrMoneyField(
            fieldKey: const Key('hr-pay-amount'),
            controller: _amount,
            label: l10n.hrPayAmountPaidNow,
            helper: l10n.hrPayPartialHint,
            currency: currency,
            onChanged: (_) => setState(() => _amountEdited = true),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _reference,
            decoration: hrInputDecoration(
              label: l10n.hrPayReference,
              hint: l10n.hrPayReferenceHint,
            ),
          ),
        ],
        const SizedBox(height: 10),
        TextField(
          controller: _note,
          decoration: hrInputDecoration(label: l10n.hrPayNote),
        ),
        if (_error != null) ...[
          const SizedBox(height: 12),
          HrCallout(
            calloutKey: const Key('hr-pay-error'),
            tone: HrTone.danger,
            icon: Icons.error_outline,
            message: _error!,
          ),
        ],
        const SizedBox(height: 4),
        Text(
          l10n.hrPayRatesFootnote(f.rates.version),
          style: HrType.caption.copyWith(color: HrTokens.ink4),
        ),
      ],
    );
  }
}
