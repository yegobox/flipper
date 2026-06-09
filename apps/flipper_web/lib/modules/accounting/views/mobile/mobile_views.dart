import 'package:flipper_web/modules/accounting/data/accounting_demo_data.dart';
import 'package:flipper_web/modules/accounting/data/accounting_derive.dart';
import 'package:flipper_web/modules/accounting/data/accounting_models.dart';
import 'package:flipper_web/modules/accounting/data/accounting_providers.dart';
import 'package:flipper_web/modules/accounting/routing/accounting_route.dart';
import 'package:flipper_web/modules/accounting/theme/accounting_tokens.dart';
import 'package:flipper_web/modules/accounting/widgets/trend_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AccountingSnapshotTab extends ConsumerWidget {
  const AccountingSnapshotTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pl = incomeStatement();
    final cashBank = cashAndBankTotal();
    final ar = ageTotals(demoAr).total;
    final ap = ageTotals(demoAp).total;
    final pending = pendingJournalCount();

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      children: [
        _HeroCard(netIncome: pl.netIncome, revenue: pl.netRevenue, expenses: pl.cogs + pl.totalOpex, margin: pl.netMargin),
        const SizedBox(height: 12),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 1.5,
          children: [
            _MiniKpi('Cash & bank', cashBank, Icons.account_balance_wallet_outlined, AccountingTokens.accent),
            _MiniKpi('Stock value', demoAccountMap['1200']!.bal, Icons.inventory_2_outlined, AccountingTokens.gain),
            _MiniKpi('Receivable', ar, Icons.north_east, AccountingTokens.warnAmber),
            _MiniKpi('Payable', ap, Icons.south_west, AccountingTokens.loss),
          ],
        ),
        if (pending > 0) ...[
          const SizedBox(height: 12),
          Material(
            color: AccountingTokens.warnTint,
            borderRadius: BorderRadius.circular(16),
            child: InkWell(
              onTap: () => ref.read(accountingMobileTabProvider.notifier).state = AccountingMobileTab.approvals,
              borderRadius: BorderRadius.circular(16),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Row(
                  children: [
                    const Icon(Icons.verified_user_outlined, color: AccountingTokens.warnAmber),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('$pending entries need approval', style: AccountingTokens.sans(fontSize: 14, fontWeight: FontWeight.w700, color: AccountingTokens.warnAmber)),
                          Text('Review & post before month-end close', style: AccountingTokens.sans(fontSize: 12, color: AccountingTokens.ink3)),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right),
                  ],
                ),
              ),
            ),
          ),
        ],
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(color: AccountingTokens.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: AccountingTokens.line)),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(14),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Revenue vs expenses', style: AccountingTokens.sans(fontSize: 14, fontWeight: FontWeight.w700)),
                    Text('6 mo', style: AccountingTokens.sans(fontSize: 12, color: AccountingTokens.accent)),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 0, 8, 14),
                child: TrendChart(data: demoTrend, height: 150),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(color: AccountingTokens.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: AccountingTokens.line)),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(14),
                child: Text('Recent entries', style: AccountingTokens.sans(fontSize: 14, fontWeight: FontWeight.w700)),
              ),
              for (final e in demoJournal.take(4))
                ListTile(
                  leading: const Icon(Icons.receipt_long_outlined),
                  title: Text(e.memo, style: AccountingTokens.sans(fontSize: 13.5)),
                  subtitle: Text('${e.id} · ${e.date}'),
                  trailing: Text(money(jeTotals(e).dr), style: AccountingTokens.mono(fontSize: 13, fontWeight: FontWeight.w700)),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _HeroCard extends StatelessWidget {
  const _HeroCard({required this.netIncome, required this.revenue, required this.expenses, required this.margin});

  final int netIncome;
  final int revenue;
  final int expenses;
  final double margin;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1D4ED8), Color(0xFF2563EB), Color(0xFF4F46E5)],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('Net income · $demoPeriod', style: AccountingTokens.sans(fontSize: 12.5, color: Colors.white70)),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(999)),
                child: Row(
                  children: [
                    const Icon(Icons.arrow_upward, size: 11, color: Colors.white),
                    Text('18%', style: AccountingTokens.mono(fontSize: 11, color: Colors.white)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          RichText(
            text: TextSpan(
              style: AccountingTokens.mono(fontSize: 32, fontWeight: FontWeight.w700, color: Colors.white),
              children: [
                const TextSpan(text: 'RWF ', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                TextSpan(text: money(netIncome)),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              _HeroCell('Revenue', compact(revenue)),
              _HeroCell('Expenses', compact(expenses)),
              _HeroCell('Margin', '${(margin * 100).round()}%'),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeroCell extends StatelessWidget {
  const _HeroCell(this.label, this.value);

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AccountingTokens.sans(fontSize: 11, color: Colors.white60)),
          Text(value, style: AccountingTokens.mono(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white)),
        ],
      ),
    );
  }
}

class _MiniKpi extends StatelessWidget {
  const _MiniKpi(this.label, this.value, this.icon, this.color);

  final String label;
  final int value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AccountingTokens.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AccountingTokens.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: color),
          const Spacer(),
          Text(label, style: AccountingTokens.sans(fontSize: 11.5, color: AccountingTokens.ink3)),
          Text('RWF ${compact(value)}', style: AccountingTokens.mono(fontSize: 16, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}

class AccountingApprovalsTab extends ConsumerWidget {
  const AccountingApprovalsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final actions = ref.watch(approvalActionsProvider);
    final pending = demoJournal.where((e) => e.status == JournalStatus.pending).toList();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text('Approvals', style: AccountingTokens.sans(fontSize: 22, fontWeight: FontWeight.w800)),
        Text('Pending journal entries — tap approve to post to the ledger.', style: AccountingTokens.sans(fontSize: 13, color: AccountingTokens.ink3)),
        const SizedBox(height: 16),
        for (final e in pending) _ApprovalCard(
          entry: e,
          action: actions[e.id],
          onApprove: () => ref.read(approvalActionsProvider.notifier).update((m) => {...m, e.id: ApprovalAction.approve}),
          onReject: () => ref.read(approvalActionsProvider.notifier).update((m) => {...m, e.id: ApprovalAction.reject}),
        ),
        if (pending.isEmpty)
          Padding(
            padding: const EdgeInsets.all(30),
            child: Center(child: Text("Nothing waiting — you're all caught up.", style: AccountingTokens.sans(color: AccountingTokens.ink3))),
          ),
      ],
    );
  }
}

class _ApprovalCard extends StatelessWidget {
  const _ApprovalCard({required this.entry, required this.action, required this.onApprove, required this.onReject});

  final JournalEntry entry;
  final ApprovalAction? action;
  final VoidCallback onApprove;
  final VoidCallback onReject;

  @override
  Widget build(BuildContext context) {
    final t = jeTotals(entry);
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AccountingTokens.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AccountingTokens.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(entry.id, style: AccountingTokens.mono(fontSize: 13, fontWeight: FontWeight.w700, color: AccountingTokens.accent)),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(color: AccountingTokens.warnTint, borderRadius: BorderRadius.circular(999)),
                child: Text('pending', style: AccountingTokens.sans(fontSize: 11, color: AccountingTokens.warnAmber, fontWeight: FontWeight.w600)),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(entry.memo, style: AccountingTokens.sans(fontSize: 15, fontWeight: FontWeight.w600)),
          Text('${entry.date} · ${entry.ref} · via ${entry.src}', style: AccountingTokens.sans(fontSize: 12, color: AccountingTokens.ink3)),
          const SizedBox(height: 12),
          for (final l in entry.lines)
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: l.dr > 0 ? AccountingTokens.accentTint : const Color(0xFFE6F4F2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(l.dr > 0 ? 'Dr' : 'Cr', style: AccountingTokens.mono(fontSize: 11, color: l.dr > 0 ? AccountingTokens.drInk : AccountingTokens.crInk)),
                  ),
                  const SizedBox(width: 8),
                  Expanded(child: Text('${acctName(l.ac)} ${l.ac}', style: AccountingTokens.sans(fontSize: 13))),
                  Text(money(l.dr > 0 ? l.dr : l.cr), style: AccountingTokens.mono(fontSize: 13, color: l.dr > 0 ? AccountingTokens.drInk : AccountingTokens.crInk)),
                ],
              ),
            ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: AccountingTokens.gainTint, borderRadius: BorderRadius.circular(8)),
            child: Text('Balanced · ${money(t.dr)} = ${money(t.cr)}', style: AccountingTokens.sans(fontSize: 12, color: AccountingTokens.gainInk, fontWeight: FontWeight.w600)),
          ),
          const SizedBox(height: 12),
          if (action != null)
            Text(
              action == ApprovalAction.approve ? 'Approved & posted' : 'Sent back to drafts',
              style: AccountingTokens.sans(fontSize: 13, color: AccountingTokens.ink3, fontStyle: FontStyle.italic),
            )
          else
            Row(
              children: [
                Expanded(child: OutlinedButton(onPressed: onReject, child: const Text('Reject'))),
                const SizedBox(width: 10),
                Expanded(child: FilledButton(onPressed: onApprove, child: const Text('Approve'))),
              ],
            ),
        ],
      ),
    );
  }
}

class AccountingReportsTab extends ConsumerWidget {
  const AccountingReportsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final report = ref.watch(mobileReportProvider);

    if (report != null) {
      return AccountingStatementDetail(report: report, onBack: () => ref.read(mobileReportProvider.notifier).state = null);
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text('Reports', style: AccountingTokens.sans(fontSize: 22, fontWeight: FontWeight.w800)),
        Text('Generated live from the ledger · $demoEntityName', style: AccountingTokens.sans(fontSize: 13, color: AccountingTokens.ink3)),
        const SizedBox(height: 16),
        for (final r in _mobileReports)
          ListTile(
            leading: Icon(r.$3),
            title: Text(r.$1),
            subtitle: Text(r.$2),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => ref.read(mobileReportProvider.notifier).state = r.$4,
          ),
      ],
    );
  }
}

final _mobileReports = [
  ('Income statement', 'Profit & loss · May', Icons.trending_up, MobileReportKey.pl),
  ('Balance sheet', 'Financial position', Icons.layers_outlined, MobileReportKey.bs),
  ('Trial balance', 'In balance', Icons.grid_view, MobileReportKey.tb),
  ('Tax & VAT', 'Net due ${money(demoVat.netPayable)}', Icons.verified_user_outlined, MobileReportKey.vat),
];

class AccountingStatementDetail extends StatelessWidget {
  const AccountingStatementDetail({super.key, required this.report, required this.onBack});

  final MobileReportKey report;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final pl = incomeStatement();
    final bs = balanceSheet();
    final tb = trialBalance();
    final title = switch (report) {
      MobileReportKey.pl => 'Income statement',
      MobileReportKey.bs => 'Balance sheet',
      MobileReportKey.tb => 'Trial balance',
      MobileReportKey.vat => 'Tax & VAT',
    };

    return Column(
      children: [
        ListTile(
          leading: IconButton(icon: const Icon(Icons.chevron_left), onPressed: onBack),
          title: Text(title, style: AccountingTokens.sans(fontSize: 16, fontWeight: FontWeight.w700)),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: switch (report) {
              MobileReportKey.pl => [
                  _SRow('Net revenue', pl.netRevenue),
                  _SRow('COGS', -pl.cogs),
                  _SRow('Gross profit', pl.grossProfit),
                  _SRow('Operating expenses', -pl.totalOpex),
                  _SRow('Net income', pl.netIncome, bold: true),
                ],
              MobileReportKey.bs => [
                  _SRow('Total assets', bs.totalAssets),
                  _SRow('Total liabilities', bs.totalLiab),
                  _SRow('Total equity', bs.totalEquity),
                  _SRow('Liabilities + equity', bs.totalLiabEquity, bold: true),
                  if (bs.totalAssets == bs.totalLiabEquity)
                    Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: Text('Balanced with total assets', style: AccountingTokens.sans(color: AccountingTokens.gainInk, fontWeight: FontWeight.w600)),
                    ),
                ],
              MobileReportKey.tb => [
                  for (final r in tb.rows) _SRow('${r.account.code} ${r.account.name}', r.dr > 0 ? r.dr : r.cr),
                  _SRow('Totals Dr/Cr', tb.totDr, bold: true),
                ],
              MobileReportKey.vat => [
                  _SRow('Output VAT', demoVat.outputVat),
                  _SRow('Input VAT', demoVat.inputVat),
                  _SRow('Net payable', demoVat.netPayable, bold: true),
                  _SRow('Due', 0, labelOverride: demoVat.dueDate),
                ],
            },
          ),
        ),
      ],
    );
  }
}

class _SRow extends StatelessWidget {
  const _SRow(this.label, this.value, {this.bold = false, this.labelOverride});

  final String label;
  final int value;
  final bool bold;
  final String? labelOverride;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AccountingTokens.sans(fontSize: 14, fontWeight: bold ? FontWeight.w800 : FontWeight.w500)),
          Text(labelOverride ?? money(value), style: AccountingTokens.mono(fontSize: bold ? 16 : 14, fontWeight: bold ? FontWeight.w800 : FontWeight.w600)),
        ],
      ),
    );
  }
}

class AccountingMoreTab extends ConsumerWidget {
  const AccountingMoreTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text('More', style: AccountingTokens.sans(fontSize: 22, fontWeight: FontWeight.w800)),
        const SizedBox(height: 12),
        for (final group in accountingNavGroups)
          for (final item in group.items)
            ListTile(
              leading: Icon(item.icon),
              title: Text(item.view.label),
              subtitle: Text(group.section),
            ),
        const SizedBox(height: 16),
        FilledButton(
          style: FilledButton.styleFrom(backgroundColor: AccountingTokens.ink1, minimumSize: const Size.fromHeight(48)),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Use a wider screen for the full desktop workspace.')),
            );
          },
          child: const Text('Open desktop workspace'),
        ),
      ],
    );
  }
}

