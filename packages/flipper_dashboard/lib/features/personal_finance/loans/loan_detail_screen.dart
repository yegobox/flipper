import 'package:flipper_dashboard/features/personal_finance/loans/loan_form_sheet.dart';
import 'package:flipper_dashboard/features/personal_finance/loans/loans_screen.dart';
import 'package:flipper_dashboard/features/personal_finance/personal_add_money_sheet.dart';
import 'package:flipper_dashboard/theme/pos_tokens.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_models/personal_loans/loan_math.dart';
import 'package:flipper_models/personal_loans/personal_loan.dart';
import 'package:flipper_models/personal_loans/personal_loans_store.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

/// One loan: what is left, how long it takes at the current payment, the
/// interest still to pay, and every repayment recorded.
class LoanDetailScreen extends ConsumerWidget {
  const LoanDetailScreen({super.key, required this.loanId});

  final String loanId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.flipperL10n;
    final overview = ref.watch(personalLoansOverviewProvider);
    final status = overview.loans.where((s) => s.loan.id == loanId).firstOrNull;
    if (status == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    final loan = status.loan;
    final o = status.outlook;
    final payments = (ref.watch(personalLoanPaymentsProvider).value ?? const [])
        .where((p) => p.loanId == loan.id)
        .toList();
    final installment = effectiveInstallment(loan);

    Widget row(String label, String value, {Key? key}) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: Text(label, style: const TextStyle(color: PosTokens.ink2)),
          ),
          Text(
            value,
            key: key,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );

    return Scaffold(
      key: const ValueKey('personal-loan-detail'),
      backgroundColor: PosTokens.posBg,
      appBar: AppBar(
        backgroundColor: PosTokens.posBg,
        surfaceTintColor: Colors.transparent,
        title: Text(loan.lender),
        actions: [
          IconButton(
            tooltip: l10n.personalLoanEdit,
            icon: const Icon(Icons.edit_outlined),
            onPressed: () => showLoanFormSheet(context, loan: loan),
          ),
          PopupMenuButton<String>(
            onSelected: (v) => _menu(context, ref, loan, v),
            itemBuilder: (_) => [
              PopupMenuItem(
                value: loan.isOpen ? 'clear' : 'reopen',
                child: Text(
                  loan.isOpen
                      ? l10n.personalLoanMarkCleared
                      : l10n.personalLoanReopen,
                ),
              ),
              PopupMenuItem(
                value: 'delete',
                child: Text(l10n.personalLoanDelete),
              ),
            ],
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
        children: [
          Material(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.personalLoanBalance +
                        (status.estimated && loan.isOpen
                            ? ' (${l10n.personalLoanEstimated})'
                            : ''),
                    style: const TextStyle(color: PosTokens.ink3),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    status.balance == null
                        ? '—'
                        : loanMoney(ref, status.balance!),
                    key: const ValueKey('loan-detail-balance'),
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (o != null && o.neverEnds)
                    Text(
                      l10n.personalLoanNeverEnds,
                      style: const TextStyle(color: PosTokens.lossInk),
                    ),
                  if (o?.monthsLeft != null && loan.isOpen) ...[
                    row(
                      l10n.personalLoanTimeLeft,
                      l10n.personalLoanMonthsLeft(o!.monthsLeft!),
                      key: const ValueKey('loan-detail-months'),
                    ),
                    if (o.payoffDate != null)
                      row(
                        l10n.personalLoanPaidOffBy,
                        loanMonth(context, o.payoffDate!),
                        key: const ValueKey('loan-detail-payoff'),
                      ),
                    if ((o.interestLeft ?? 0) > 0)
                      row(
                        l10n.personalLoanInterestLeft,
                        loanMoney(ref, o.interestLeft!),
                      ),
                  ],
                  if (installment != null)
                    row(
                      l10n.personalLoanMonthlyPayment,
                      loanMoney(ref, installment),
                    ),
                  if ((loan.annualRatePct ?? 0) > 0)
                    row(
                      l10n.personalLoanRateShort,
                      '${loan.annualRatePct!.toStringAsFixed(1)}%',
                    ),
                  if (loan.endDate != null)
                    row(
                      l10n.personalLoanPlannedEnd,
                      loanMonth(context, loan.endDate!),
                    ),
                  row(
                    l10n.personalLoanPaidSoFar,
                    loanMoney(ref, status.paidTotal),
                  ),
                ],
              ),
            ),
          ),
          if (loan.isOpen) ...[
            const SizedBox(height: 12),
            FilledButton.icon(
              key: const ValueKey('loan-detail-record'),
              style: FilledButton.styleFrom(
                backgroundColor: PosTokens.blue,
                minimumSize: const Size.fromHeight(52),
              ),
              onPressed: () => showPersonalAddMoneySheet(
                context,
                categoryName: kLoanRepaymentCategory,
                amount: installment,
                loanId: loan.id,
              ),
              icon: const Icon(Icons.add_rounded),
              label: Text(l10n.personalLoanRecordPayment),
            ),
            if (status.repaymentDue)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  l10n.personalLoanDue,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: PosTokens.warnAmber),
                ),
              ),
          ],
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 20, 4, 8),
            child: Text(
              l10n.personalLoanRepayments,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                color: PosTokens.ink2,
              ),
            ),
          ),
          Material(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            child: payments.isEmpty
                ? Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      l10n.personalLoanNoRepayments,
                      style: const TextStyle(color: PosTokens.ink3),
                    ),
                  )
                : Column(
                    children: [
                      for (final p in payments)
                        ListTile(
                          title: Text(loanMoney(ref, p.amount)),
                          subtitle: Text(DateFormat.yMMMd().format(p.paidAt)),
                          trailing: Icon(
                            p.source == 'sms'
                                ? Icons.sms_outlined
                                : Icons.edit_note_outlined,
                            color: PosTokens.ink3,
                          ),
                        ),
                    ],
                  ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Text(
              l10n.personalLoanDisclaimer,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12, color: PosTokens.ink3),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _menu(
    BuildContext context,
    WidgetRef ref,
    PersonalLoan loan,
    String action,
  ) async {
    final store = ref.read(personalLoansStoreProvider);
    switch (action) {
      case 'clear':
        await store.saveLoan(loan.copyWith(closedAt: DateTime.now()));
      case 'reopen':
        await store.saveLoan(loan.copyWith(clearClosed: true));
      case 'delete':
        final l10n = context.flipperL10n;
        final ok = await showDialog<bool>(
          context: context,
          builder: (c) => AlertDialog(
            title: Text(l10n.personalLoanDelete),
            content: Text(l10n.personalLoanDeleteConfirm),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(c).pop(false),
                child: Text(l10n.cancel),
              ),
              TextButton(
                onPressed: () => Navigator.of(c).pop(true),
                style: TextButton.styleFrom(foregroundColor: PosTokens.lossInk),
                child: Text(l10n.personalLoanDelete),
              ),
            ],
          ),
        );
        if (ok != true) return;
        await store.deleteLoan(loan);
        if (context.mounted) Navigator.of(context).pop();
    }
  }
}
