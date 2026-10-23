import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_models/personal_loans/personal_loan.dart';
import 'package:flipper_models/personal_loans/personal_loans_store.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:uuid/uuid.dart';

/// Records [amount] as a repayment of [loanId], linked to the Cash Out it came
/// from so the money also counts as spending.
Future<void> recordLoanRepayment(
  WidgetRef ref, {
  required String loanId,
  required double amount,
  required DateTime paidAt,
  required String? transactionId,
  required String source,
}) async {
  final businessId = ref.read(personalLoansBusinessIdProvider);
  if (businessId == null) return;
  await ref
      .read(personalLoansStoreProvider)
      .addPayment(
        PersonalLoanPayment(
          id: const Uuid().v4(),
          loanId: loanId,
          businessId: businessId,
          amount: amount,
          paidAt: paidAt,
          transactionId: transactionId,
          source: source,
        ),
      );
}

/// "Which loan is this for?" — chips of the open loans. Shows nothing when
/// there are none, so a repayment without a tracked loan still saves.
class LoanPicker extends ConsumerWidget {
  const LoanPicker({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  final String? selected;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loans = (ref.watch(personalLoansProvider).value ?? const [])
        .where((l) => l.isOpen)
        .toList();
    if (loans.isEmpty) return const SizedBox.shrink();
    // One loan: it is the one, without a tap.
    if (loans.length == 1 && selected == null) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => onChanged(loans.single.id),
      );
    }
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.flipperL10n.personalLoanWhichLoan,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final l in loans)
                ChoiceChip(
                  key: ValueKey('loan-pick-${l.id}'),
                  avatar: const Icon(Icons.account_balance_outlined, size: 18),
                  label: Text(l.lender),
                  selected: selected == l.id,
                  onSelected: (on) => onChanged(on ? l.id : null),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
