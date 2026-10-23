import 'package:flipper_dashboard/features/branch_location/branch_services.dart';
import 'package:flipper_dashboard/features/personal_finance/loans/loan_affordability_screen.dart';
import 'package:flipper_dashboard/features/personal_finance/loans/loan_detail_screen.dart';
import 'package:flipper_dashboard/features/personal_finance/loans/loan_form_sheet.dart';
import 'package:flipper_dashboard/theme/pos_tokens.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_models/helperModels/extensions.dart';
import 'package:flipper_models/personal_loans/loan_math.dart';
import 'package:flipper_models/personal_loans/personal_loans_store.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

String loanMoney(WidgetRef ref, double v) => v.toCurrencyFormatted(
  symbol: ref.read(branchServicesProvider).box.defaultCurrency(),
  decimalDigits: 0,
);

String loanMonth(BuildContext context, DateTime d) {
  final locale = Localizations.maybeLocaleOf(context)?.toLanguageTag();
  try {
    return DateFormat.yMMM(locale).format(d);
  } catch (_) {
    return DateFormat.yMMM().format(d);
  }
}

void openLoans(BuildContext context) => Navigator.of(
  context,
).push(MaterialPageRoute<void>(builder: (_) => const LoansScreen()));

/// Every loan: what is owed in total, what goes out every month, when the
/// last one ends, and each loan's own balance and payoff.
class LoansScreen extends ConsumerWidget {
  const LoansScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.flipperL10n;
    final overview = ref.watch(personalLoansOverviewProvider);
    final open = overview.loans.where((s) => s.loan.isOpen).toList();
    final cleared = overview.loans.where((s) => !s.loan.isOpen).toList();
    return Scaffold(
      key: const ValueKey('personal-loans'),
      backgroundColor: PosTokens.posBg,
      appBar: AppBar(
        backgroundColor: PosTokens.posBg,
        surfaceTintColor: Colors.transparent,
        title: Text(l10n.personalLoans),
      ),
      floatingActionButton: FloatingActionButton.extended(
        key: const ValueKey('personal-loan-add'),
        backgroundColor: PosTokens.blue,
        foregroundColor: Colors.white,
        onPressed: () => showLoanFormSheet(context),
        icon: const Icon(Icons.add_rounded),
        label: Text(l10n.personalLoanAdd),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
        children: [
          LoansOverviewCard(overview: overview),
          const SizedBox(height: 12),
          Material(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            child: ListTile(
              key: const ValueKey('personal-loan-what-if'),
              leading: const Icon(
                Icons.calculate_outlined,
                color: PosTokens.blue,
              ),
              title: Text(l10n.personalLoanWhatIf),
              subtitle: Text(l10n.personalLoanWhatIfHint),
              trailing: const Icon(Icons.chevron_right_rounded),
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => const LoanAffordabilityScreen(),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          if (overview.loans.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 32),
              child: Text(
                l10n.personalLoansEmpty,
                textAlign: TextAlign.center,
                style: const TextStyle(color: PosTokens.ink3, height: 1.4),
              ),
            ),
          for (final s in open) ...[
            LoanTile(status: s),
            const SizedBox(height: 8),
          ],
          if (cleared.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(4, 16, 4, 8),
              child: Text(
                l10n.personalLoanCleared,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  color: PosTokens.ink2,
                ),
              ),
            ),
            for (final s in cleared) ...[
              LoanTile(status: s),
              const SizedBox(height: 8),
            ],
          ],
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
}

/// Total owed, paid every month, debt-free date.
class LoansOverviewCard extends ConsumerWidget {
  const LoansOverviewCard({super.key, required this.overview});

  final LoansOverview overview;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.flipperL10n;
    Widget figure(String label, String value, {Key? key, Color? color}) =>
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(fontSize: 12, color: PosTokens.ink3),
              ),
              const SizedBox(height: 4),
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(
                  value,
                  key: key,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: color ?? PosTokens.ink1,
                  ),
                ),
              ),
            ],
          ),
        );
    final last = overview.lastPayoff;
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            figure(
              l10n.personalLoansTotalOwed,
              loanMoney(ref, overview.totalOwed),
              key: const ValueKey('personal-loans-owed'),
            ),
            figure(
              l10n.personalLoansMonthly,
              loanMoney(ref, overview.monthlyPayments),
              key: const ValueKey('personal-loans-monthly'),
            ),
            figure(
              l10n.personalLoansDebtFree,
              last == null ? '—' : loanMonth(context, last),
              key: const ValueKey('personal-loans-debt-free'),
              color: PosTokens.blue,
            ),
          ],
        ),
      ),
    );
  }
}

class LoanTile extends ConsumerWidget {
  const LoanTile({super.key, required this.status});

  final LoanStatus status;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.flipperL10n;
    final s = status;
    final o = s.outlook;
    final subtitle = <String>[
      if (!s.loan.isOpen)
        l10n.personalLoanCleared
      else if (o?.neverEnds ?? false)
        l10n.personalLoanNeverEndsShort
      else if (o?.monthsLeft != null && o!.monthsLeft! > 0) ...[
        l10n.personalLoanMonthsLeft(o.monthsLeft!),
        l10n.personalLoanPayoff(loanMonth(context, o.payoffDate!)),
      ],
      if (s.repaymentDue) l10n.personalLoanDue,
    ].join(' · ');
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: ListTile(
        key: ValueKey('loan-tile-${s.loan.id}'),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        leading: CircleAvatar(
          backgroundColor: PosTokens.blueTint,
          foregroundColor: PosTokens.blue,
          child: const Icon(Icons.account_balance_outlined, size: 20),
        ),
        title: Text(
          s.loan.lender,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: subtitle.isEmpty ? null : Text(subtitle),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              s.balance == null ? '—' : loanMoney(ref, s.balance!),
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
            if (s.estimated && s.loan.isOpen)
              Text(
                l10n.personalLoanEstimated,
                style: const TextStyle(fontSize: 11, color: PosTokens.ink3),
              ),
          ],
        ),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => LoanDetailScreen(loanId: s.loan.id),
          ),
        ),
      ),
    );
  }
}

/// On the personal Home: the loans summary, or a way to add the first one.
class LoansHomeCard extends ConsumerWidget {
  const LoansHomeCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.flipperL10n;
    final overview = ref.watch(personalLoansOverviewProvider);
    final open = overview.loans.where((s) => s.loan.isOpen).toList();
    final due = open.where((s) => s.repaymentDue).length;
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        child: ListTile(
          key: const ValueKey('personal-loans-card'),
          leading: const Icon(
            Icons.account_balance_outlined,
            color: PosTokens.blue,
          ),
          title: Text(
            open.isEmpty
                ? l10n.personalLoans
                : '${l10n.personalLoansTotalOwed}: ${loanMoney(ref, overview.totalOwed)}',
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          subtitle: Text(
            open.isEmpty
                ? l10n.personalLoansEmptyShort
                : [
                    '${l10n.personalLoansMonthly}: ${loanMoney(ref, overview.monthlyPayments)}',
                    if (overview.lastPayoff != null)
                      '${l10n.personalLoansDebtFree}: ${loanMonth(context, overview.lastPayoff!)}',
                    if (due > 0) l10n.personalLoanDue,
                  ].join(' · '),
          ),
          trailing: const Icon(Icons.chevron_right_rounded),
          onTap: () => openLoans(context),
        ),
      ),
    );
  }
}
