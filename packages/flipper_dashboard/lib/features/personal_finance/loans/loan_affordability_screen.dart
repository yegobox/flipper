import 'package:flipper_dashboard/features/personal_finance/loans/loans_screen.dart';
import 'package:flipper_dashboard/features/personal_finance/personal_finance_data.dart';
import 'package:flipper_dashboard/features/personal_finance/personal_finance_providers.dart';
import 'package:flipper_dashboard/theme/pos_tokens.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_models/personal_loans/loan_math.dart';
import 'package:flipper_models/personal_loans/personal_loan.dart';
import 'package:flipper_models/personal_loans/personal_loans_store.dart';
import 'package:flipper_models/providers/transactions_provider.dart'
    show coreTransactionsStream;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Money in and out over the last 30 days, loans themselves left out: a
/// borrowed amount is not income, and installments are counted separately.
/// 30 days because that is the history this device keeps.
typedef PersonalMonthlyFlow = ({double income, double spending});

@visibleForTesting
PersonalMonthlyFlow monthlyFlowWithoutLoans(Iterable<PersonalMovement> moves) {
  var income = 0.0;
  var spending = 0.0;
  for (final m in moves) {
    if (m.isIncome) {
      if (m.category != kLoanReceivedCategory) income += m.amount;
    } else {
      if (m.category != kLoanRepaymentCategory) spending += m.amount;
    }
  }
  return (income: income, spending: spending);
}

final personalLast30DaysFlowProvider =
    StreamProvider.autoDispose<PersonalMonthlyFlow>((ref) {
      final branchId = ref.watch(personalBranchIdProvider);
      if (branchId == null) return Stream.value((income: 0, spending: 0));
      final now = DateTime.now();
      return coreTransactionsStream(
        ref,
        startDate: now.subtract(const Duration(days: 30)),
        endDate: now,
        branchId: branchId,
        forceRealData: true,
        includeParked: false,
      ).map(
        (all) => monthlyFlowWithoutLoans(
          all.map(personalMovementFrom).whereType<PersonalMovement>(),
        ),
      );
    });

/// "What if I borrow…": the new installment next to what the user earns,
/// spends and already repays every month, and what would be left.
class LoanAffordabilityScreen extends ConsumerStatefulWidget {
  const LoanAffordabilityScreen({super.key});

  @override
  ConsumerState<LoanAffordabilityScreen> createState() =>
      _LoanAffordabilityScreenState();
}

class _LoanAffordabilityScreenState
    extends ConsumerState<LoanAffordabilityScreen> {
  final _amount = TextEditingController();
  final _months = TextEditingController(text: '12');
  final _rate = TextEditingController(text: '16');

  @override
  void dispose() {
    _amount.dispose();
    _months.dispose();
    _rate.dispose();
    super.dispose();
  }

  Widget _field(
    TextEditingController c,
    String label, {
    Key? key,
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
        border: const OutlineInputBorder(),
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final l10n = context.flipperL10n;
    final flow =
        ref.watch(personalLast30DaysFlowProvider).value ??
        (income: 0.0, spending: 0.0);
    final existing = ref.watch(personalLoansOverviewProvider).monthlyPayments;
    final amount = parseLoanAmount(_amount.text);
    final months = int.tryParse(_months.text.trim());
    final rate = parseLoanRate(_rate.text);
    final check = amount == null || amount <= 0 || months == null || months <= 0
        ? null
        : affordability(
            amount: amount,
            annualRatePct: rate,
            months: months,
            existingInstallments: existing,
            avgIncome: flow.income,
            avgSpending: flow.spending,
            now: DateTime.now(),
          );

    Widget row(String label, String value, {Key? key, Color? color}) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: Text(label, style: const TextStyle(color: PosTokens.ink2)),
          ),
          Text(
            value,
            key: key,
            style: TextStyle(fontWeight: FontWeight.w700, color: color),
          ),
        ],
      ),
    );

    return Scaffold(
      key: const ValueKey('personal-loan-affordability'),
      backgroundColor: PosTokens.posBg,
      appBar: AppBar(
        backgroundColor: PosTokens.posBg,
        surfaceTintColor: Colors.transparent,
        title: Text(l10n.personalLoanWhatIf),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
        children: [
          _field(
            _amount,
            l10n.personalLoanAmount,
            key: const ValueKey('what-if-amount'),
          ),
          _field(
            _months,
            l10n.personalLoanTermMonths,
            integer: true,
            key: const ValueKey('what-if-months'),
          ),
          _field(
            _rate,
            l10n.personalLoanRate,
            key: const ValueKey('what-if-rate'),
          ),
          Material(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  row(l10n.personalLoanAvgIncome, loanMoney(ref, flow.income)),
                  row(
                    l10n.personalLoanAvgSpending,
                    loanMoney(ref, flow.spending),
                  ),
                  row(
                    l10n.personalLoanCurrentInstallments,
                    loanMoney(ref, existing),
                  ),
                  if (check != null) ...[
                    const Divider(height: 24),
                    row(
                      l10n.personalLoanNewInstallment,
                      loanMoney(ref, check.newInstallment),
                      key: const ValueKey('what-if-installment'),
                      color: PosTokens.blue,
                    ),
                    if ((check.outlook.interestLeft ?? 0) > 0)
                      row(
                        l10n.personalLoanTotalInterest,
                        loanMoney(ref, check.outlook.interestLeft!),
                      ),
                    row(
                      l10n.personalLoanLeftEachMonth,
                      loanMoney(ref, check.leftOver),
                      key: const ValueKey('what-if-left'),
                      color: check.leftOver < 0 ? PosTokens.lossInk : null,
                    ),
                    if (check.debtShare != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          l10n.personalLoanDebtShare(
                            (check.debtShare! * 100).round(),
                          ),
                          style: const TextStyle(color: PosTokens.ink2),
                        ),
                      ),
                    const SizedBox(height: 12),
                    _Verdict(verdict: check.verdict),
                  ],
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Text(
              l10n.personalLoanAffordabilityNote,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12, color: PosTokens.ink3),
            ),
          ),
        ],
      ),
    );
  }
}

class _Verdict extends StatelessWidget {
  const _Verdict({required this.verdict});

  final Affordability verdict;

  @override
  Widget build(BuildContext context) {
    final l10n = context.flipperL10n;
    final (text, color, tint) = switch (verdict) {
      Affordability.comfortable => (
        l10n.personalLoanVerdictComfortable,
        PosTokens.gainInk,
        const Color(0xFFE7F6EE),
      ),
      Affordability.tight => (
        l10n.personalLoanVerdictTight,
        PosTokens.warnAmber,
        PosTokens.warnTint,
      ),
      Affordability.risky => (
        l10n.personalLoanVerdictRisky,
        PosTokens.lossInk,
        PosTokens.lossTint,
      ),
      Affordability.notCovered => (
        l10n.personalLoanVerdictNotCovered,
        PosTokens.lossInk,
        PosTokens.lossTint,
      ),
      Affordability.unknown => (
        l10n.personalLoanVerdictUnknown,
        PosTokens.ink2,
        PosTokens.surface2,
      ),
    };
    return Container(
      key: ValueKey('what-if-verdict-${verdict.name}'),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: tint,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: TextStyle(color: color, fontWeight: FontWeight.w600),
      ),
    );
  }
}
