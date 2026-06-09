import 'package:flipper_web/features/business_selection/business_branch_selector.dart';
import 'package:flipper_web/modules/accounting/data/accounting_balances.dart';
import 'package:flipper_web/modules/accounting/data/accounting_derive.dart';
import 'package:flipper_web/modules/accounting/data/accounting_models.dart';
import 'package:flipper_web/modules/accounting/data/accounting_providers.dart';
import 'package:flipper_web/modules/accounting/routing/accounting_route.dart';
import 'package:flipper_web/modules/accounting/theme/accounting_tokens.dart';
import 'package:flipper_web/modules/accounting/widgets/account_type_pill.dart';
import 'package:flipper_web/modules/accounting/widgets/accounting_kpi_card.dart';
import 'package:flipper_web/modules/accounting/widgets/accounting_page_header.dart';
import 'package:flipper_web/modules/accounting/widgets/status_pill.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const _ageBuckets = [
  ('current', 'Current', AccountingTokens.accent),
  ('d30', '1–30 days', AccountingTokens.crInk),
  ('d60', '31–60 days', Color(0xFFE89A2A)),
  ('d90', '60+ days', AccountingTokens.loss),
];

class AccountingGeneralLedgerView extends ConsumerWidget {
  const AccountingGeneralLedgerView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final code = ref.watch(ledgerAccountCodeProvider);
    final accounts = ref.watch(accountingAccountsProvider);
    final journal = ref.watch(accountingJournalProvider);
    final currency = ref.watch(accountingCurrencyProvider);
    final accountMap = {for (final a in accounts) a.code: a};
    final account = accountMap[code];
    final postings = account == null
        ? <GlPosting>[]
        : generalLedgerPostings(code, journal, accounts);

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(28, 24, 28, 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AccountingPageHeader(
            eyebrow: 'Daybook',
            title: 'General ledger',
            subtitle: 'Account-level posting history · $currency',
            actions: [
              DropdownButton<String>(
                value: code,
                items: [
                  for (final a in accounts)
                    DropdownMenuItem(
                      value: a.code,
                      child: Text('${a.code} · ${a.name}'),
                    ),
                ],
                onChanged: (v) {
                  if (v != null)
                    ref.read(ledgerAccountCodeProvider.notifier).state = v;
                },
              ),
            ],
          ),
          if (account != null)
            AccountingCard(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Text(
                    account.code,
                    style: AccountingTokens.mono(
                      fontSize: 14,
                      color: AccountingTokens.ink3,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      account.name,
                      style: AccountingTokens.sans(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 12),
                  AccountTypePill(type: account.type),
                  const SizedBox(width: 12),
                  Text(
                    'Closing ${money(account.bal)}',
                    style: AccountingTokens.mono(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 16),
          AccountingCard(
            child: Column(
              children: [
                for (final p in postings)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 80,
                          child: Text(
                            p.date,
                            style: AccountingTokens.sans(
                              fontSize: 13,
                              color: AccountingTokens.ink3,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            p.memo,
                            style: AccountingTokens.sans(fontSize: 13.5),
                          ),
                        ),
                        SizedBox(
                          width: 90,
                          child: Text(
                            p.debit > 0 ? money(p.debit) : '—',
                            style: AccountingTokens.mono(
                              fontSize: 13,
                              color: AccountingTokens.drInk,
                            ),
                            textAlign: TextAlign.right,
                          ),
                        ),
                        SizedBox(
                          width: 90,
                          child: Text(
                            p.credit > 0 ? money(p.credit) : '—',
                            style: AccountingTokens.mono(
                              fontSize: 13,
                              color: AccountingTokens.crInk,
                            ),
                            textAlign: TextAlign.right,
                          ),
                        ),
                        SizedBox(
                          width: 100,
                          child: Text(
                            money(p.balance),
                            style: AccountingTokens.mono(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                            ),
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AccountingBankRecView extends ConsumerWidget {
  const AccountingBankRecView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lines = ref.watch(accountingBankLinesProvider);
    final accounts = ref.watch(accountingAccountsProvider);
    final currency = ref.watch(accountingCurrencyProvider);
    final period = ref.watch(accountingPeriodLabelProvider);
    final bankBal = accounts
        .where((a) => a.code == '1020')
        .fold<int>(0, (s, a) => s + a.bal);
    final matched = lines.where((l) => l.matched).length;
    final unmatched = lines.length - matched;
    final diff = lines.where((l) => !l.matched).fold<int>(0, (s, l) => s + l.amt);

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(28, 24, 28, 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AccountingPageHeader(
            eyebrow: 'Daybook',
            title: 'Bank reconciliation',
            subtitle: 'Bank · $period · $currency',
            actions: [
              AccountingButton(
                label: 'Import statement',
                icon: Icons.sync,
                small: true,
              ),
              AccountingButton(
                label: 'Finish reconciliation',
                icon: Icons.check,
                primary: true,
                small: true,
                enabled: false,
              ),
            ],
          ),
          AccountingKpiGrid(
            maxColumns: 3,
            children: [
              AccountingKpiCard(
                label: 'Ledger balance',
                value: bankBal,
                icon: Icons.account_balance_wallet_outlined,
                tone: KpiTone.blue,
              ),
              AccountingKpiCard(
                label: 'Matched',
                value: matched,
                icon: Icons.check,
                tone: KpiTone.green,
                footnote: lines.isEmpty ? 'no lines yet' : 'of ${lines.length}',
              ),
              AccountingKpiCard(
                label: 'Needs attention',
                value: unmatched,
                icon: Icons.warning_amber_outlined,
                tone: KpiTone.amber,
                footnote: money(diff.abs()),
              ),
            ],
          ),
          const SizedBox(height: 16),
          AccountingCard(
            child: Column(
              children: [
                const AccountingCardHeader(
                  title: 'Statement lines',
                  subtitle: 'Match each bank line to a journal entry',
                ),
                if (lines.isEmpty)
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text(
                      'No bank statement lines yet. Import a statement to begin.',
                      style: AccountingTokens.sans(
                        fontSize: 13.5,
                        color: AccountingTokens.ink3,
                      ),
                    ),
                  ),
                for (final l in lines)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 70,
                          child: Text(
                            l.date,
                            style: AccountingTokens.sans(
                              fontSize: 13,
                              color: AccountingTokens.ink3,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            l.desc,
                            style: AccountingTokens.sans(fontSize: 13.5),
                          ),
                        ),
                        Text(
                          l.amt < 0 ? '(${money(-l.amt)})' : money(l.amt),
                          style: AccountingTokens.mono(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w700,
                            color: l.amt < 0
                                ? AccountingTokens.lossInk
                                : AccountingTokens.gainInk,
                          ),
                        ),
                        const SizedBox(width: 16),
                        if (l.matched) ...[
                          Text(
                            l.je!,
                            style: AccountingTokens.mono(
                              fontSize: 12,
                              color: AccountingTokens.accent,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const MatchedPill(),
                        ] else
                          const AccountingButton(
                            label: 'Match',
                            primary: true,
                            small: true,
                          ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AccountingAgingView extends ConsumerWidget {
  const AccountingAgingView({super.key, required this.kind});

  final String kind; // ar | ap

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rows = kind == 'ar'
        ? ref.watch(accountingArAgingProvider)
        : ref.watch(accountingApAgingProvider);
    final period = ref.watch(accountingPeriodLabelProvider);
    final currency = ref.watch(accountingCurrencyProvider);
    final totals = ageTotals(rows);
    final isAr = kind == 'ar';

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(28, 24, 28, 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AccountingPageHeader(
            eyebrow: 'Money',
            title: isAr ? 'Receivables' : 'Payables',
            subtitle: 'Aging analysis · $period · $currency',
            actions: [
              AccountingButton(
                label: isAr ? 'Send reminders' : 'Schedule payment',
                icon: Icons.send_outlined,
                small: true,
              ),
              AccountingButton(
                label: isAr ? 'New invoice' : 'New bill',
                icon: Icons.add,
                primary: true,
                small: true,
              ),
            ],
          ),
          AccountingCard(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                for (final b in _ageBuckets)
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border: Border(left: BorderSide(color: b.$3, width: 3)),
                        color: AccountingTokens.surface2,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            b.$2,
                            style: AccountingTokens.sans(
                              fontSize: 11,
                              color: AccountingTokens.ink3,
                            ),
                          ),
                          Text(
                            money(totals.buckets[b.$1] ?? 0),
                            style: AccountingTokens.mono(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          AccountingCard(
            child: Column(
              children: [
                for (final r in rows)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text(
                            r.name,
                            style: AccountingTokens.sans(
                              fontSize: 13.5,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            r.inv,
                            style: AccountingTokens.mono(
                              fontSize: 12,
                              color: AccountingTokens.ink3,
                            ),
                          ),
                        ),
                        _BucketCell(r.current),
                        _BucketCell(r.d30),
                        _BucketCell(r.d60, warn: true),
                        _BucketCell(r.d90, danger: true),
                        SizedBox(
                          width: 90,
                          child: Text(
                            money(r.total),
                            style: AccountingTokens.mono(
                              fontSize: 13.5,
                              fontWeight: FontWeight.w700,
                            ),
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BucketCell extends StatelessWidget {
  const _BucketCell(this.val, {this.warn = false, this.danger = false});

  final int val;
  final bool warn;
  final bool danger;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 80,
      child: Text(
        val == 0 ? '—' : money(val),
        style: AccountingTokens.mono(
          fontSize: 12.5,
          color: danger
              ? AccountingTokens.lossInk
              : (warn ? AccountingTokens.warnAmber : AccountingTokens.ink2),
        ),
        textAlign: TextAlign.right,
      ),
    );
  }
}

class AccountingTaxVatView extends ConsumerWidget {
  const AccountingTaxVatView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vat = ref.watch(accountingVatProvider);
    final period = ref.watch(accountingPeriodLabelProvider);
    final ratePct = vat != null ? (vat.rate * 100).round() : 18;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(28, 24, 28, 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AccountingPageHeader(
            eyebrow: 'Money',
            title: 'Tax & VAT',
            subtitle: vat != null
                ? 'Standard rate $ratePct% · $period'
                : 'No VAT data for $period',
            actions: [
              AccountingButton(
                label: 'File with RRA',
                icon: Icons.verified_user_outlined,
                primary: true,
              ),
            ],
          ),
          AccountingKpiGrid(
            maxColumns: 3,
            children: [
              AccountingKpiCard(
                label: 'Output VAT',
                value: vat?.outputVat ?? 0,
                icon: Icons.trending_up,
                tone: KpiTone.green,
              ),
              AccountingKpiCard(
                label: 'Input VAT',
                value: vat?.inputVat ?? 0,
                icon: Icons.receipt_long,
                tone: KpiTone.blue,
              ),
              AccountingKpiCard(
                label: 'Net VAT payable',
                value: vat?.netPayable ?? 0,
                icon: Icons.shield_outlined,
                tone: KpiTone.amber,
                footnote: vat != null ? 'Due ${vat.dueDate}' : '—',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class AccountingFinancialStatementsView extends ConsumerWidget {
  const AccountingFinancialStatementsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final StatementsTab tab = ref.watch(statementsTabProvider);
    final accounts = ref.watch(accountingAccountsProvider);
    final journal = ref.watch(accountingJournalProvider);
    final pl = incomeStatement(accounts);
    final bs = balanceSheet(accounts);
    final cf = cashFlowFromJournal(journal);
    final entityName = ref.watch(selectedBusinessProvider)?.name ?? '';
    final period = ref.watch(accountingPeriodLabelProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(28, 24, 28, 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AccountingPageHeader(
            eyebrow: 'Reports',
            title: 'Financial statements',
            subtitle: entityName.isNotEmpty ? '$entityName · $period' : period,
            actions: [
              AccountingButton(
                label: 'Print',
                icon: Icons.print_outlined,
                small: true,
              ),
              AccountingButton(
                label: 'PDF',
                icon: Icons.picture_as_pdf_outlined,
                small: true,
              ),
            ],
          ),
          Wrap(
            spacing: 6,
            children: StatementsTab.values.map((t) {
              final label = switch (t) {
                StatementsTab.income => 'Income statement',
                StatementsTab.balance => 'Balance sheet',
                StatementsTab.cashFlow => 'Cash flow',
              };
              final on = tab == t;
              return ChoiceChip(
                label: Text(label),
                selected: on,
                onSelected: (_) =>
                    ref.read(statementsTabProvider.notifier).state = t,
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          AccountingCard(
            padding: const EdgeInsets.all(24),
            child: switch (tab) {
              StatementsTab.income => _StmtBody(
                entityName: entityName,
                rows: [
                  _StmtRow('Net revenue', pl.netRevenue),
                  _StmtRow('Cost of goods sold', -pl.cogs),
                  _StmtRow('Gross profit', pl.grossProfit),
                  _StmtRow('Operating expenses', -pl.totalOpex),
                  _StmtRow('Net income', pl.netIncome, total: true),
                ],
              ),
              StatementsTab.balance => _StmtBody(
                entityName: entityName,
                rows: [
                  _StmtRow('Total assets', bs.totalAssets),
                  _StmtRow('Total liabilities', bs.totalLiab),
                  _StmtRow('Total equity', bs.totalEquity),
                  _StmtRow(
                    'Liabilities + equity',
                    bs.totalLiabEquity,
                    total: true,
                  ),
                ],
                balanced: bs.totalAssets == bs.totalLiabEquity,
              ),
              StatementsTab.cashFlow => _StmtBody(
                entityName: entityName,
                rows: [
                  _StmtRow('Operating activities', cf.operating),
                  _StmtRow('Investing activities', cf.investing),
                  _StmtRow('Financing activities', cf.financing),
                  _StmtRow('Net change in cash', cf.netChange, total: true),
                ],
              ),
            },
          ),
        ],
      ),
    );
  }
}

class _StmtRow {
  const _StmtRow(this.label, this.value, {this.total = false});

  final String label;
  final int value;
  final bool total;
}

class _StmtBody extends StatelessWidget {
  const _StmtBody({required this.rows, this.balanced = false, this.entityName = ''});

  final List<_StmtRow> rows;
  final bool balanced;
  final String entityName;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (entityName.isNotEmpty)
          Text(
            entityName.toUpperCase(),
          style: AccountingTokens.sans(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.1 * 12,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        for (final r in rows)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  r.label,
                  style: AccountingTokens.sans(
                    fontSize: 14,
                    fontWeight: r.total ? FontWeight.w800 : FontWeight.w500,
                  ),
                ),
                Text(
                  money(r.value),
                  style: AccountingTokens.mono(
                    fontSize: r.total ? 19 : 14,
                    fontWeight: r.total ? FontWeight.w800 : FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        if (balanced)
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Text(
              'Balanced — assets equal liabilities plus equity',
              style: AccountingTokens.sans(
                fontSize: 12,
                color: AccountingTokens.gainInk,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
      ],
    );
  }
}

class AccountingTrialBalanceView extends ConsumerWidget {
  const AccountingTrialBalanceView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accounts = ref.watch(accountingAccountsProvider);
    final tb = trialBalance(accounts);
    final period = ref.watch(accountingPeriodLabelProvider);
    final currency = ref.watch(accountingCurrencyProvider);
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(28, 24, 28, 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AccountingPageHeader(
            eyebrow: 'Reports',
            title: 'Trial balance',
            subtitle: 'As of $period · $currency',
            actions: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AccountingTokens.gainTint,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  tb.balanced ? 'In balance' : 'Out of balance',
                  style: AccountingTokens.sans(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: tb.balanced
                        ? AccountingTokens.gainInk
                        : AccountingTokens.lossInk,
                  ),
                ),
              ),
            ],
          ),
          AccountingCard(
            child: Column(
              children: [
                if (tb.rows.isEmpty)
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text(
                      'No accounts loaded yet.',
                      style: AccountingTokens.sans(color: AccountingTokens.ink3),
                    ),
                  ),
                for (final r in tb.rows)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 50,
                          child: Text(
                            r.account.code,
                            style: AccountingTokens.mono(fontSize: 12),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            r.account.name,
                            style: AccountingTokens.sans(fontSize: 13.5),
                          ),
                        ),
                        SizedBox(
                          width: 100,
                          child: Text(
                            r.dr > 0 ? money(r.dr) : '—',
                            style: AccountingTokens.mono(
                              fontSize: 13,
                              color: AccountingTokens.drInk,
                            ),
                            textAlign: TextAlign.right,
                          ),
                        ),
                        SizedBox(
                          width: 100,
                          child: Text(
                            r.cr > 0 ? money(r.cr) : '—',
                            style: AccountingTokens.mono(
                              fontSize: 13,
                              color: AccountingTokens.crInk,
                            ),
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ],
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'Totals',
                          style: TextStyle(fontWeight: FontWeight.w800),
                        ),
                      ),
                      SizedBox(
                        width: 100,
                        child: Text(
                          money(tb.totDr),
                          style: AccountingTokens.mono(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: AccountingTokens.drInk,
                          ),
                          textAlign: TextAlign.right,
                        ),
                      ),
                      SizedBox(
                        width: 100,
                        child: Text(
                          money(tb.totCr),
                          style: AccountingTokens.mono(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: AccountingTokens.crInk,
                          ),
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AccountingChartOfAccountsView extends ConsumerWidget {
  const AccountingChartOfAccountsView({super.key});

  static const _typeOrder = [
    (AccountType.asset, 'Assets'),
    (AccountType.liability, 'Liabilities'),
    (AccountType.equity, 'Equity'),
    (AccountType.income, 'Income'),
    (AccountType.expense, 'Expenses'),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accounts = ref.watch(accountingAccountsProvider);
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(28, 24, 28, 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AccountingPageHeader(
            eyebrow: 'Setup',
            title: 'Chart of accounts',
            subtitle:
                '${accounts.length} accounts · numbered ledger structure',
            actions: const [
              AccountingButton(
                label: 'Filter',
                icon: Icons.filter_list,
                small: true,
              ),
              AccountingButton(
                label: 'Add account',
                icon: Icons.add,
                primary: true,
                small: true,
              ),
            ],
          ),
          AccountingCard(
            child: Column(
              children: [
                for (final (type, label) in _typeOrder) ...[
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    color: AccountingTokens.surface2,
                    child: Text(
                      label,
                      style: AccountingTokens.sans(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  for (final a in accounts.where((x) => x.type == type))
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 50,
                            child: Text(
                              a.code,
                              style: AccountingTokens.mono(fontSize: 12),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              a.name,
                              style: AccountingTokens.sans(fontSize: 13.5),
                            ),
                          ),
                          AccountTypePill(type: a.type),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              a.sub,
                              style: AccountingTokens.sans(
                                fontSize: 12,
                                color: AccountingTokens.ink3,
                              ),
                            ),
                          ),
                          Text(
                            a.contra ? '(${money(a.bal)})' : money(a.bal),
                            style: AccountingTokens.mono(
                              fontSize: 13.5,
                              fontWeight: FontWeight.w700,
                              color: a.contra
                                  ? AccountingTokens.lossInk
                                  : AccountingTokens.ink1,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
