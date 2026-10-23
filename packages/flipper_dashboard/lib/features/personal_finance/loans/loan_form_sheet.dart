import 'package:flipper_dashboard/features/branch_location/branch_services.dart';
import 'package:flipper_dashboard/features/personal_finance/loans/loans_screen.dart';
import 'package:flipper_dashboard/features/personal_finance/personal_add_money_sheet.dart';
import 'package:flipper_dashboard/theme/pos_tokens.dart';
import 'package:flipper_dashboard/widgets/sms_review/sms_review_categories.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_models/personal_loans/loan_math.dart';
import 'package:flipper_models/personal_loans/personal_loan.dart';
import 'package:flipper_models/personal_loans/personal_loans_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:uuid/uuid.dart';

Future<void> showLoanFormSheet(BuildContext context, {PersonalLoan? loan}) =>
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => LoanFormSheet(loan: loan),
    );

/// Whether the form holds enough to give a balance and a payoff date.
@visibleForTesting
bool loanFormIsComplete({
  required double? amount,
  required double? payment,
  required int? term,
  required DateTime? end,
  required double? balanceToday,
}) {
  final hasPayment = payment != null && payment > 0;
  if (hasPayment && (end != null || (balanceToday ?? 0) > 0)) return true;
  if (amount != null && amount > 0) {
    return hasPayment || (term ?? 0) > 0 || end != null;
  }
  return false;
}

/// Add or edit a loan. Two ways in, because many people do not remember
/// when or how much they borrowed but know what they pay and until when:
/// "I know the details" (amount, start, term) and "I only know the monthly
/// payment" (payment and end, optionally today's balance).
class LoanFormSheet extends ConsumerStatefulWidget {
  const LoanFormSheet({super.key, this.loan});

  final PersonalLoan? loan;

  @override
  ConsumerState<LoanFormSheet> createState() => _LoanFormSheetState();
}

class _LoanFormSheetState extends ConsumerState<LoanFormSheet> {
  late final PersonalLoan? _loan = widget.loan;
  late bool _simple =
      _loan != null && _loan.principal == null && _loan.endDate != null;
  late final _lender = TextEditingController(text: _loan?.lender ?? '');
  late final _amount = TextEditingController(text: _fmt(_loan?.principal));
  late final _payment = TextEditingController(
    text: _fmt(_loan?.monthlyPayment),
  );
  late final _rate = TextEditingController(text: _fmt(_loan?.annualRatePct));
  late final _term = TextEditingController(
    text: _loan?.termMonths?.toString() ?? '',
  );
  late final _balance = TextEditingController(text: _fmt(_loan?.balance));
  late DateTime? _start = _loan?.startDate;
  late DateTime? _end = _loan?.endDate;
  bool _receivedNow = false;
  bool _busy = false;
  String? _error;

  static String _fmt(double? v) => v == null
      ? ''
      : (v == v.roundToDouble() ? v.round().toString() : v.toString());

  static double? _parse(TextEditingController c) =>
      double.tryParse(c.text.replaceAll(',', '').trim());

  @override
  void dispose() {
    for (final c in [_lender, _amount, _payment, _rate, _term, _balance]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _pickStart() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _start ?? now,
      firstDate: DateTime(now.year - 30),
      lastDate: now,
    );
    if (picked != null) setState(() => _start = picked);
  }

  Future<void> _pickEnd() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _end ?? DateTime(now.year + 1, now.month),
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 40),
      initialDatePickerMode: DatePickerMode.year,
    );
    if (picked != null) setState(() => _end = picked);
  }

  Future<void> _save() async {
    final l10n = context.flipperL10n;
    final lender = _lender.text.trim();
    final amount = _simple ? null : _parse(_amount);
    final payment = _parse(_payment);
    final rate = _parse(_rate);
    final term = _simple ? null : int.tryParse(_term.text.trim());
    final balance = _parse(_balance);
    if (lender.isEmpty) {
      setState(() => _error = l10n.personalLoanLenderRequired);
      return;
    }
    if (!loanFormIsComplete(
      amount: amount,
      payment: payment,
      term: term,
      end: _end,
      balanceToday: balance,
    )) {
      setState(() => _error = l10n.personalLoanNeedsMore);
      return;
    }
    final businessId = ref.read(personalLoansBusinessIdProvider);
    final box = ref.read(branchServicesProvider).box;
    final branchId = box.branchIdString() ?? box.getBranchId() ?? '';
    if (businessId == null) {
      setState(() => _error = l10n.personalMoneySaveFailed);
      return;
    }
    setState(() {
      _busy = true;
      _error = null;
    });
    final now = DateTime.now();
    final existing = _loan;
    final loan = PersonalLoan(
      id: existing?.id ?? const Uuid().v4(),
      businessId: existing?.businessId ?? businessId,
      branchId: existing?.branchId ?? branchId,
      lender: lender,
      monthlyPayment: payment,
      annualRatePct: rate,
      principal: amount,
      startDate: _simple ? null : (_start ?? (amount != null ? now : null)),
      endDate: _end,
      termMonths: term,
      balance: balance,
      // A balance typed now is today's; an unchanged one keeps its date.
      balanceAt: balance == null
          ? null
          : (existing?.balance == balance ? existing?.balanceAt : now),
      currency: box.defaultCurrency(),
      note: existing?.note,
      createdAt: existing?.createdAt ?? now,
      closedAt: existing?.closedAt,
    );
    try {
      await ref.read(personalLoansStoreProvider).saveLoan(loan);
      if (_receivedNow && amount != null && existing == null) {
        await _recordReceived(amount);
      }
      if (!mounted) return;
      Navigator.of(context).pop();
    } catch (_) {
      if (mounted) {
        setState(() {
          _busy = false;
          _error = l10n.personalMoneySaveFailed;
        });
      }
    }
  }

  /// The borrowed money as money in, under "Loan received".
  Future<void> _recordReceived(double amount) async {
    final box = ref.read(branchServicesProvider).box;
    final branchId = box.branchIdString() ?? box.getBranchId();
    String? categoryId;
    if (branchId != null) {
      categoryId = await ref
          .read(smsCategoryStoreProvider)
          .create(kLoanReceivedCategory, branchId);
    }
    await ref.read(personalMovementWriterProvider)(
      isIncome: true,
      amount: amount,
      paymentType: 'CASH',
      categoryName: kLoanReceivedCategory,
      categoryId: categoryId,
      note: _lender.text.trim(),
    );
  }

  Widget _number(
    TextEditingController c,
    String label, {
    Key? key,
    String? hint,
    bool integer = false,
  }) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: TextField(
      key: key,
      controller: c,
      keyboardType: TextInputType.numberWithOptions(decimal: !integer),
      inputFormatters: [
        FilteringTextInputFormatter.allow(
          integer ? RegExp(r'[0-9]') : RegExp(r'[0-9.,]'),
        ),
      ],
      onChanged: (_) => setState(() {}),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: const OutlineInputBorder(),
      ),
    ),
  );

  Widget _date(String label, DateTime? value, VoidCallback onTap, {Key? key}) =>
      Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: OutlinedButton.icon(
          key: key,
          style: OutlinedButton.styleFrom(
            alignment: Alignment.centerLeft,
            minimumSize: const Size.fromHeight(52),
            foregroundColor: PosTokens.ink1,
          ),
          onPressed: onTap,
          icon: const Icon(Icons.event_outlined),
          label: Text(
            value == null ? label : '$label: ${loanMonth(context, value)}',
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final l10n = context.flipperL10n;
    final preview = _previewLine(l10n);
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              _loan == null ? l10n.personalLoanAdd : l10n.personalLoanEdit,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: PosTokens.ink1,
              ),
            ),
            const SizedBox(height: 16),
            SegmentedButton<bool>(
              key: const ValueKey('loan-form-mode'),
              segments: [
                ButtonSegment(
                  value: false,
                  label: Text(l10n.personalLoanModeDetails),
                ),
                ButtonSegment(
                  value: true,
                  label: Text(l10n.personalLoanModeSimple),
                ),
              ],
              selected: {_simple},
              onSelectionChanged: (s) => setState(() => _simple = s.first),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: TextField(
                key: const ValueKey('loan-form-lender'),
                controller: _lender,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  labelText: l10n.personalLoanLender,
                  hintText: l10n.personalLoanLenderHint,
                  border: const OutlineInputBorder(),
                ),
              ),
            ),
            if (!_simple) ...[
              _number(
                _amount,
                l10n.personalLoanAmount,
                key: const ValueKey('loan-form-amount'),
              ),
              _date(l10n.personalLoanStartDate, _start, _pickStart),
              _number(
                _term,
                l10n.personalLoanTermMonths,
                integer: true,
                key: const ValueKey('loan-form-term'),
              ),
            ],
            _number(
              _payment,
              l10n.personalLoanMonthlyPayment,
              key: const ValueKey('loan-form-payment'),
            ),
            _date(
              l10n.personalLoanEndDate,
              _end,
              _pickEnd,
              key: const ValueKey('loan-form-end'),
            ),
            _number(
              _rate,
              l10n.personalLoanRate,
              key: const ValueKey('loan-form-rate'),
            ),
            _number(
              _balance,
              l10n.personalLoanBalanceToday,
              key: const ValueKey('loan-form-balance'),
            ),
            if (!_simple && _loan == null)
              CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                value: _receivedNow,
                onChanged: (v) => setState(() => _receivedNow = v ?? false),
                title: Text(l10n.personalLoanReceivedNow),
              ),
            if (preview != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text(
                  preview,
                  key: const ValueKey('loan-form-preview'),
                  style: const TextStyle(color: PosTokens.blue),
                ),
              ),
            if (_error != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text(
                  _error!,
                  style: const TextStyle(color: PosTokens.lossInk),
                ),
              ),
            FilledButton(
              key: const ValueKey('loan-form-save'),
              style: FilledButton.styleFrom(
                backgroundColor: PosTokens.blue,
                minimumSize: const Size.fromHeight(52),
              ),
              onPressed: _busy ? null : _save,
              child: Text(l10n.personalMoneySave),
            ),
          ],
        ),
      ),
    );
  }

  /// "About 20 months left · paid off by Sep 2027" as the user types.
  String? _previewLine(FlipperAppLocalizations l10n) {
    final now = DateTime.now();
    final draft = PersonalLoan(
      id: 'draft',
      businessId: '',
      branchId: '',
      lender: '',
      monthlyPayment: _parse(_payment),
      annualRatePct: _parse(_rate),
      principal: _simple ? null : _parse(_amount),
      startDate: _simple ? null : _start,
      endDate: _end,
      termMonths: _simple ? null : int.tryParse(_term.text.trim()),
      balance: _parse(_balance),
      balanceAt: _parse(_balance) == null ? null : now,
      createdAt: now,
    );
    final status = loanStatus(draft, const [], now);
    final o = status.outlook;
    if (status.balance == null || o == null) return null;
    if (o.neverEnds) return l10n.personalLoanNeverEnds;
    final parts = [
      '${l10n.personalLoanBalance}: ${loanMoney(ref, status.balance!)}',
      if (o.monthsLeft != null) l10n.personalLoanMonthsLeft(o.monthsLeft!),
      if (o.payoffDate != null)
        l10n.personalLoanPayoff(loanMonth(context, o.payoffDate!)),
    ];
    return parts.join(' · ');
  }
}
