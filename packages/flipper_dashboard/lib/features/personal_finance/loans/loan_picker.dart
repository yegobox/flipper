import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_models/personal_loans/personal_loan.dart';
import 'package:flipper_models/personal_loans/personal_loans_store.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Records a repayment of a loan, linked to the Cash Out it came from so the
/// money also counts as spending.
typedef LoanRepaymentWriter =
    Future<void> Function({
      required String loanId,
      required double amount,
      required DateTime paidAt,
      required String transactionId,
      required String source,
    });

/// The payment doc id for the Cash Out [transactionId]: one Cash Out pays
/// one loan once, so a retried write updates the same payment.
String loanPaymentIdFor(String transactionId) => 'loanpay-$transactionId';

/// Reads the store and the business now, so the returned writer finishes
/// even if the sheet that started it is dismissed before it runs.
LoanRepaymentWriter loanRepaymentWriter(WidgetRef ref) {
  final store = ref.read(personalLoansStoreProvider);
  final businessId = ref.read(personalLoansBusinessIdProvider);
  return ({
    required loanId,
    required amount,
    required paidAt,
    required transactionId,
    required source,
  }) async {
    if (businessId == null) return;
    await store.addPayment(
      PersonalLoanPayment(
        id: loanPaymentIdFor(transactionId),
        loanId: loanId,
        businessId: businessId,
        amount: amount,
        paidAt: paidAt,
        transactionId: transactionId,
        source: source,
      ),
    );
  };
}

/// The loans are still loading: a repayment saved now could not be linked.
bool loanPickerPending(WidgetRef ref) {
  final loans = ref.watch(personalLoansProvider);
  return loans.isLoading && !loans.hasValue;
}

/// "Which loan is this for?" — chips of the open loans. Shows nothing when
/// there are none, so a repayment without a tracked loan still saves.
class LoanPicker extends ConsumerStatefulWidget {
  const LoanPicker({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  final String? selected;
  final ValueChanged<String?> onChanged;

  @override
  ConsumerState<LoanPicker> createState() => _LoanPickerState();
}

class _LoanPickerState extends ConsumerState<LoanPicker> {
  /// The single-loan preselect happens once: a loan the user deselects stays
  /// deselected (the repayment may be for a loan that is not tracked).
  bool _preselectDone = false;

  @override
  Widget build(BuildContext context) {
    if (loanPickerPending(ref)) {
      return const Padding(
        key: ValueKey('loan-pick-loading'),
        padding: EdgeInsets.only(top: 12),
        child: LinearProgressIndicator(),
      );
    }
    final loans = (ref.watch(personalLoansProvider).value ?? const [])
        .where((l) => l.isOpen)
        .toList();
    if (loans.isEmpty) return const SizedBox.shrink();
    if (!_preselectDone) {
      _preselectDone = true;
      // One loan: it is the one, without a tap.
      if (loans.length == 1 && widget.selected == null) {
        final id = loans.single.id;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) widget.onChanged(id);
        });
      }
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
                  selected: widget.selected == l.id,
                  onSelected: (on) => widget.onChanged(on ? l.id : null),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
