import 'package:flipper_web/modules/accounting/data/accounting_demo_data.dart';
import 'package:flipper_web/modules/accounting/data/accounting_derive.dart';
import 'package:flipper_web/modules/accounting/data/accounting_models.dart';
import 'package:flipper_web/modules/accounting/theme/accounting_tokens.dart';
import 'package:flipper_web/modules/accounting/widgets/accounting_kpi_card.dart';
import 'package:flipper_web/modules/accounting/widgets/accounting_page_header.dart';
import 'package:flipper_web/modules/accounting/widgets/status_pill.dart';
import 'package:flipper_web/modules/accounting/widgets/trend_chart.dart';
import 'package:flutter/material.dart';

class AccountingDashboardView extends StatelessWidget {
  const AccountingDashboardView({super.key, required this.onNewEntry});

  final VoidCallback onNewEntry;

  @override
  Widget build(BuildContext context) {
    final pl = incomeStatement();
    final arAge = ageTotals(demoAr);
    final apAge = ageTotals(demoAp);
    final cashBank = cashAndBankTotal();
    final opexSegs = pl.opex.asMap().entries.map((e) {
      const colors = [AccountingTokens.accent, AccountingTokens.crInk, AccountingTokens.violet, Color(0xFFE89A2A), AccountingTokens.loss, Color(0xFF64748B)];
      return (label: e.value.name, value: e.value.bal, color: colors[e.key % colors.length]);
    }).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(28, 24, 28, 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AccountingPageHeader(
            eyebrow: 'Financial overview',
            title: 'Books at a glance',
            subtitle: '$demoEntityName · fiscal period $demoPeriod · all amounts in $demoCurrency',
            actions: [
              const AccountingButton(label: 'Export', icon: Icons.download_outlined),
              AccountingButton(label: 'New journal entry', icon: Icons.add, primary: true, onPressed: onNewEntry),
            ],
          ),
          AccountingKpiGrid(
            children: [
              AccountingKpiCard(label: 'Net income', value: pl.netIncome, icon: Icons.trending_up, tone: KpiTone.green, delta: 18, footnote: 'vs April'),
              AccountingKpiCard(label: 'Cash & bank', value: cashBank, icon: Icons.account_balance_wallet_outlined, tone: KpiTone.blue, delta: 6, footnote: 'across 3 accounts'),
              AccountingKpiCard(label: 'Receivable', value: arAge.total, icon: Icons.north_east, tone: KpiTone.amber, footnote: 'overdue 60+', deltaPositive: false),
              AccountingKpiCard(label: 'Payable', value: apAge.total, icon: Icons.south_west, tone: KpiTone.red, footnote: '${demoAp.length} open bills'),
            ],
          ),
          const SizedBox(height: 16),
          LayoutBuilder(
            builder: (context, c) {
              if (c.maxWidth < 800) {
                return Column(children: [_TrendCard(), const SizedBox(height: 12), _DonutCard(segments: opexSegs, totalOpex: pl.totalOpex)]);
              }
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 7, child: _TrendCard()),
                  const SizedBox(width: 12),
                  Expanded(flex: 5, child: _DonutCard(segments: opexSegs, totalOpex: pl.totalOpex)),
                ],
              );
            },
          ),
          const SizedBox(height: 16),
          LayoutBuilder(
            builder: (context, c) {
              if (c.maxWidth < 800) {
                return Column(children: [_RecentJournalCard(), const SizedBox(height: 12), _MiniPlCard(pl: pl)]);
              }
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 7, child: _RecentJournalCard()),
                  const SizedBox(width: 12),
                  Expanded(flex: 5, child: _MiniPlCard(pl: pl)),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _TrendCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AccountingCard(
      child: Column(
        children: [
          const AccountingCardHeader(title: 'Revenue vs expenses', subtitle: 'Trailing 6 months'),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: TrendChart(data: demoTrend),
          ),
        ],
      ),
    );
  }
}

class _DonutCard extends StatelessWidget {
  const _DonutCard({required this.segments, required this.totalOpex});

  final List<({String label, int value, Color color})> segments;
  final int totalOpex;

  @override
  Widget build(BuildContext context) {
    return AccountingCard(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          children: [
            DonutChart(
              segments: segments,
              center: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(compact(totalOpex), style: AccountingTokens.mono(fontSize: 18, fontWeight: FontWeight.w700)),
                  Text('opex', style: AccountingTokens.sans(fontSize: 10.5, color: AccountingTokens.ink3)),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                children: [
                  for (final s in segments.take(5))
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          Container(width: 9, height: 9, decoration: BoxDecoration(color: s.color, borderRadius: BorderRadius.circular(3))),
                          const SizedBox(width: 8),
                          Expanded(child: Text(s.label, style: AccountingTokens.sans(fontSize: 12.5, color: AccountingTokens.ink2), overflow: TextOverflow.ellipsis)),
                          Text(compact(s.value), style: AccountingTokens.mono(fontSize: 12.5)),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RecentJournalCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AccountingCard(
      child: Column(
        children: [
          const AccountingCardHeader(title: 'Recent journal entries'),
          for (final e in demoJournal.take(5))
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(e.id, style: AccountingTokens.mono(fontSize: 13, fontWeight: FontWeight.w700, color: AccountingTokens.accent)),
                        Text(e.date, style: AccountingTokens.sans(fontSize: 11.5, color: AccountingTokens.ink3)),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text(e.memo, style: AccountingTokens.sans(fontSize: 13.5), overflow: TextOverflow.ellipsis, maxLines: 2),
                  ),
                  Flexible(
                    child: Wrap(
                      spacing: 8,
                      alignment: WrapAlignment.end,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        StatusPill(status: e.status),
                        Text(money(jeTotals(e).dr), style: AccountingTokens.mono(fontSize: 13.5, fontWeight: FontWeight.w700)),
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

class _MiniPlCard extends StatelessWidget {
  const _MiniPlCard({required this.pl});

  final IncomeStatementResult pl;

  @override
  Widget build(BuildContext context) {
    return AccountingCard(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 18),
      child: Column(
        children: [
          const AccountingCardHeader(title: 'Profit & loss', trailing: Text('May 2026')),
          _PlRow('Net revenue', pl.netRevenue),
          _PlRow('Cost of goods sold', -pl.cogs, muted: true),
          _PlRow('Gross profit', pl.grossProfit, strong: true),
          _PlRow('Operating expenses', -pl.totalOpex, muted: true),
          Container(
            margin: const EdgeInsets.only(top: 10),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: AccountingTokens.gainTint, borderRadius: BorderRadius.circular(12)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Net income', style: AccountingTokens.sans(fontSize: 14, fontWeight: FontWeight.w800, color: AccountingTokens.gainInk)),
                Text(money(pl.netIncome), style: AccountingTokens.mono(fontSize: 19, fontWeight: FontWeight.w800, color: AccountingTokens.gainInk)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PlRow extends StatelessWidget {
  const _PlRow(this.label, this.val, {this.strong = false, this.muted = false});

  final String label;
  final int val;
  final bool strong;
  final bool muted;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AccountingTokens.sans(fontSize: 13.5, fontWeight: strong ? FontWeight.w700 : FontWeight.w500, color: muted ? AccountingTokens.ink2 : AccountingTokens.ink1)),
          Text(money(val), style: AccountingTokens.mono(fontSize: 13.5, fontWeight: strong ? FontWeight.w700 : FontWeight.w600, color: muted ? AccountingTokens.ink2 : AccountingTokens.ink1)),
        ],
      ),
    );
  }
}
