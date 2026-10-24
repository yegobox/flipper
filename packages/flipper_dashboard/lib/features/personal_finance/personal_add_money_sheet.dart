import 'package:flipper_dashboard/features/branch_location/branch_services.dart';
import 'package:flipper_dashboard/features/personal_finance/loans/loan_picker.dart';
import 'package:flipper_dashboard/features/personal_finance/personal_finance_data.dart';
import 'package:flipper_dashboard/theme/pos_tokens.dart';
import 'package:flipper_dashboard/widgets/sms_review/sms_review_categories.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_models/db_model_export.dart' show Category;
import 'package:flipper_models/personal_loans/personal_loan.dart'
    show kLoanRepaymentCategory;
import 'package:flipper_models/providers/category_provider.dart';
import 'package:flipper_services/payment_methods.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Records one Cash In / Cash Out for a personal account, through the same
/// `completeCashMovement` the Cash Book and the SMS review use, so the ledger,
/// Books and Flo see it like any other movement. Returns the transaction id.
typedef PersonalMovementWriter =
    Future<String> Function({
      required bool isIncome,
      required double amount,
      required String paymentType,
      required String? categoryName,
      required String? categoryId,
      required String? note,
    });

final personalMovementWriterProvider = Provider<PersonalMovementWriter>((ref) {
  return ({
    required isIncome,
    required amount,
    required paymentType,
    required categoryName,
    required categoryId,
    required note,
  }) async {
    final services = ref.read(branchServicesProvider);
    final branchId =
        services.box.branchIdString() ?? services.box.getBranchId();
    if (branchId == null || branchId.isEmpty) {
      throw StateError('No branch selected');
    }
    final movement = isIncome ? 'Cash In' : 'Cash Out';
    final txn = await services.strategy.completeCashMovement(
      branchId: branchId,
      bhfId: (await services.box.bhfId()) ?? '00',
      cashReceived: amount,
      isIncome: isIncome,
      utilityVariantName: movement,
      paymentType: paymentType,
      discount: 0,
      countryCode: 'N/A',
      isProformaMode: false,
      isTrainingMode: false,
      transactionTypeForRecord: categoryName ?? movement,
      categoryId: categoryId,
      note: note,
    );
    return txn.id;
  };
});

/// [categoryName], [amount] and [loanId] prefill the form ("Record this
/// month's repayment" on a loan).
Future<void> showPersonalAddMoneySheet(
  BuildContext context, {
  bool isIncome = false,
  String? categoryName,
  double? amount,
  String? loanId,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (_) => PersonalAddMoneySheet(
      initialIsIncome: isIncome,
      initialCategoryName: categoryName,
      initialAmount: amount,
      initialLoanId: loanId,
    ),
  );
}

class PersonalAddMoneySheet extends ConsumerStatefulWidget {
  const PersonalAddMoneySheet({
    super.key,
    this.initialIsIncome = false,
    this.initialCategoryName,
    this.initialAmount,
    this.initialLoanId,
  });

  final bool initialIsIncome;
  final String? initialCategoryName;
  final double? initialAmount;
  final String? initialLoanId;

  @override
  ConsumerState<PersonalAddMoneySheet> createState() =>
      _PersonalAddMoneySheetState();
}

class _PersonalAddMoneySheetState extends ConsumerState<PersonalAddMoneySheet> {
  late bool _isIncome = widget.initialIsIncome;
  late final _amount = TextEditingController(
    text: widget.initialAmount == null
        ? ''
        : widget.initialAmount!.round().toString(),
  );
  final _note = TextEditingController();
  late SmsCategoryChoice? _category = widget.initialCategoryName == null
      ? null
      : (name: widget.initialCategoryName!, id: null);

  /// The loan a "Loan repayment" pays down.
  late String? _loanId = widget.initialLoanId;

  bool get _isRepayment =>
      !_isIncome && _category?.name == kLoanRepaymentCategory;
  String _method = kPersonalMethodCash;

  /// The Cash Out a failed repayment write already saved: a retry links the
  /// repayment to it instead of writing a second Cash Out.
  ({String id, double amount})? _written;
  bool _busy = false;
  String? _error;

  @override
  void dispose() {
    _amount.dispose();
    _note.dispose();
    super.dispose();
  }

  String _methodLabel(FlipperAppLocalizations l10n, String method) =>
      switch (method) {
        kMobileMoney => 'MTN MoMo',
        kAirtelMoney => 'Airtel Money',
        kPersonalMethodBank => l10n.personalMoneyAccountBank,
        _ => l10n.personalMoneyAccountCash,
      };

  Future<void> _save() async {
    final l10n = context.flipperL10n;
    final amount = double.tryParse(_amount.text.replaceAll(',', '').trim());
    if (amount == null || amount <= 0) {
      setState(() => _error = l10n.personalMoneyAmountRequired);
      return;
    }
    setState(() {
      _busy = true;
      _error = null;
    });
    // Read before the first await: the sheet can be dismissed while the
    // writes run, and the repayment must still be linked to its Cash Out.
    final box = ref.read(branchServicesProvider).box;
    final categories = ref.read(smsCategoryStoreProvider);
    final writeMovement = ref.read(personalMovementWriterProvider);
    final recordRepayment = loanRepaymentWriter(ref);
    final loanId = _isRepayment ? _loanId : null;
    final note = _note.text.trim();
    try {
      var written = _written;
      if (written == null) {
        var categoryId = _category?.id;
        final categoryName = _category?.name;
        if (categoryName != null && categoryId == null) {
          final branchId = box.branchIdString() ?? box.getBranchId();
          if (branchId != null) {
            categoryId = await categories.create(categoryName, branchId);
          }
        }
        final transactionId = await writeMovement(
          isIncome: _isIncome,
          amount: amount,
          paymentType: _method,
          categoryName: categoryName,
          categoryId: categoryId,
          note: note.isEmpty ? null : note,
        );
        written = _written = (id: transactionId, amount: amount);
      }
      if (loanId != null) {
        await recordRepayment(
          loanId: loanId,
          amount: written.amount,
          paidAt: DateTime.now(),
          transactionId: written.id,
          source: 'form',
        );
      }
      HapticFeedback.lightImpact();
      if (!mounted) return;
      final messenger = ScaffoldMessenger.maybeOf(context);
      Navigator.of(context).pop();
      messenger?.showSnackBar(SnackBar(content: Text(l10n.personalMoneySaved)));
    } catch (_) {
      if (mounted) {
        setState(() {
          _busy = false;
          _error = l10n.personalMoneySaveFailed;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.flipperL10n;
    final branch = ref.watch(categoryProvider).value ?? const <Category>[];
    final choices = smsCategoryChoices(
      isIncome: _isIncome,
      branch: branch,
      personal: true,
    );
    final all = [...choices.suggested, ...choices.more];
    // A prefilled category matches the branch's own row once it is loaded.
    final picked = _category;
    if (picked != null && picked.id == null) {
      final match = all.where((c) => c.name == picked.name).firstOrNull;
      if (match != null && match.id != null) _category = match;
    }

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: PosTokens.lineStrong,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              l10n.personalMoneyAddTitle,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: PosTokens.ink1,
              ),
            ),
            const SizedBox(height: 16),
            SegmentedButton<bool>(
              key: const ValueKey('personal-add-direction'),
              segments: [
                ButtonSegment(
                  value: false,
                  label: Text(l10n.personalMoneyOut),
                  icon: const Icon(Icons.arrow_upward_rounded),
                ),
                ButtonSegment(
                  value: true,
                  label: Text(l10n.personalMoneyIn),
                  icon: const Icon(Icons.arrow_downward_rounded),
                ),
              ],
              selected: {_isIncome},
              onSelectionChanged: (s) => setState(() {
                _isIncome = s.first;
                _category = null;
              }),
            ),
            const SizedBox(height: 20),
            TextField(
              key: const ValueKey('personal-add-amount'),
              controller: _amount,
              autofocus: true,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
              ],
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w700),
              decoration: InputDecoration(
                labelText: l10n.personalMoneyAmount,
                prefixText:
                    '${ref.read(branchServicesProvider).box.defaultCurrency()} ',
                errorText: _error,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            _Label(l10n.personalMoneyCategory),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final c in all)
                  ChoiceChip(
                    avatar: Icon(personalCategoryIcon(c.name), size: 18),
                    label: Text(c.name),
                    selected: _category?.name == c.name,
                    onSelected: (on) =>
                        setState(() => _category = on ? c : null),
                  ),
              ],
            ),
            if (_isRepayment)
              LoanPicker(
                selected: _loanId,
                onChanged: (id) => setState(() => _loanId = id),
              ),
            const SizedBox(height: 20),
            _Label(l10n.personalMoneyAccount),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final m in kPersonalPaymentMethods)
                  ChoiceChip(
                    label: Text(_methodLabel(l10n, m)),
                    selected: _method == m,
                    onSelected: (_) => setState(() => _method = m),
                  ),
              ],
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _note,
              decoration: InputDecoration(
                labelText: l10n.personalMoneyNote,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            FilledButton(
              key: const ValueKey('personal-add-save'),
              style: FilledButton.styleFrom(
                backgroundColor: PosTokens.blue,
                minimumSize: const Size.fromHeight(52),
              ),
              onPressed: _busy || (_isRepayment && loanPickerPending(ref))
                  ? null
                  : _save,
              child: _busy
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Text(l10n.personalMoneySave),
            ),
          ],
        ),
      ),
    );
  }
}

class _Label extends StatelessWidget {
  const _Label(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text(
      text,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: PosTokens.ink2,
      ),
    ),
  );
}
