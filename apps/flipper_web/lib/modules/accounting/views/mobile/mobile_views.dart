import 'package:flipper_web/features/business_selection/business_branch_selector.dart';
import 'package:flipper_web/modules/accounting/data/accounting_derive.dart';
import 'package:flipper_web/modules/accounting/data/accounting_models.dart';
import 'package:flipper_web/modules/accounting/data/accounting_providers.dart';
import 'package:flipper_web/modules/accounting/data/accounting_session_actions.dart';
import 'package:flipper_web/modules/accounting/routing/accounting_route.dart';
import 'package:flipper_web/modules/accounting/theme/accounting_tokens.dart';
import 'package:flipper_web/modules/accounting/widgets/accounting_icon.dart';
import 'package:flipper_web/modules/accounting/widgets/accounting_toast.dart';
import 'package:flipper_web/modules/accounting/widgets/journal_approval_card.dart';
import 'package:flipper_web/modules/accounting/widgets/trend_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AccountingSnapshotTab extends ConsumerWidget {
  const AccountingSnapshotTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pl = ref.watch(accountingIncomeStatementProvider);
    final cashBank = ref.watch(accountingCashBankTotalProvider);
    final ar = ageTotals(ref.watch(accountingArAgingProvider)).total;
    final ap = ageTotals(ref.watch(accountingApAgingProvider)).total;
    final pending = ref.watch(pendingCountProvider);
    final trend = ref.watch(accountingTrendProvider);
    final journal = ref.watch(accountingJournalProvider);
    final currency = ref.watch(accountingCurrencyProvider);
    final inventoryAsync = ref.watch(accountingInventoryValueProvider);
    final stockValue = inventoryAsync.value ?? 0;
    final trendMonths = trend.length;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      children: [
        _HeroCard(
          netIncome: pl.netIncome,
          revenue: pl.netRevenue,
          expenses: pl.cogs + pl.totalOpex,
          margin: pl.netMargin,
          period: ref.watch(accountingPeriodLabelProvider),
          currency: currency,
        ),
        const SizedBox(height: 12),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 1.5,
          children: [
            _MiniKpi('Cash & bank', cashBank, Icons.account_balance_wallet_outlined, AccountingTokens.accent, currency: currency),
            _MiniKpi('Stock value', stockValue, Icons.inventory_2_outlined, AccountingTokens.gain, currency: currency),
            _MiniKpi('Receivable', ar, Icons.north_east, AccountingTokens.warnAmber, currency: currency),
            _MiniKpi('Payable', ap, Icons.south_west, AccountingTokens.loss, currency: currency),
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
                    Text(
                      trendMonths > 0 ? '$trendMonths mo' : '—',
                      style: AccountingTokens.sans(fontSize: 12, color: AccountingTokens.accent),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 0, 8, 14),
                child: TrendChart(data: trend, height: 150),
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
              for (final e in journal.take(4))
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
  const _HeroCard({
    required this.netIncome,
    required this.revenue,
    required this.expenses,
    required this.margin,
    required this.period,
    required this.currency,
  });

  final int netIncome;
  final int revenue;
  final int expenses;
  final double margin;
  final String period;
  final String currency;

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
              Text(
                '${profitOrLossLabel(netIncome)} · $period',
                style: AccountingTokens.sans(fontSize: 12.5, color: Colors.white70),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(999)),
                child: Text(
                  '${(margin * 100).round()}% margin',
                  style: AccountingTokens.mono(fontSize: 11, color: Colors.white),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          RichText(
            text: TextSpan(
              style: AccountingTokens.mono(fontSize: 32, fontWeight: FontWeight.w700, color: Colors.white),
              children: [
                TextSpan(text: '$currency ', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
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
  const _MiniKpi(this.label, this.value, this.icon, this.color, {required this.currency});

  final String label;
  final int value;
  final IconData icon;
  final Color color;
  final String currency;

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
          Text('$currency ${compact(value)}', style: AccountingTokens.mono(fontSize: 16, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}

class AccountingApprovalsTab extends ConsumerStatefulWidget {
  const AccountingApprovalsTab({super.key});

  @override
  ConsumerState<AccountingApprovalsTab> createState() =>
      _AccountingApprovalsTabState();
}

class _AccountingApprovalsTabState extends ConsumerState<AccountingApprovalsTab> {
  String? _approvingEntryId;

  @override
  Widget build(BuildContext context) {
    final journalAsync = ref.watch(journalEntriesStreamProvider);
    final actions = ref.watch(approvalActionsProvider);
    final journal = journalAsync.value ?? [];
    final pending =
        journal.where((e) => e.status == JournalStatus.pending).toList();
    final accountMap = {
      for (final a in ref.watch(accountingAccountsProvider)) a.code: a,
    };

    if (journalAsync.isLoading && journal.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (journalAsync.hasError && journal.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            'Could not load journal entries: ${journalAsync.error}',
            style: AccountingTokens.sans(color: AccountingTokens.ink3),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      children: [
        Text(
          'Approvals',
          style: AccountingTokens.sans(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.025 * 22,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          'Pending journal entries — tap approve to post to the ledger.',
          style: AccountingTokens.sans(fontSize: 13, color: AccountingTokens.ink3),
        ),
        const SizedBox(height: 14),
        for (final e in pending)
          JournalApprovalCard(
            entry: e,
            action: actions[e.id],
            accountMap: accountMap,
            isApproving: _approvingEntryId == e.id,
            onApprove: () async {
              if (_approvingEntryId != null) return;
              final businessId = ref.read(accountingBusinessIdProvider);
              final uuid = e.uuid;
              if (businessId.isEmpty || uuid == null) return;

              setState(() => _approvingEntryId = e.id);
              try {
                await ref.read(accountingLedgerRepositoryProvider).postJournalEntry(
                      businessId: businessId,
                      entryId: uuid,
                    );
                if (!mounted) return;
                ref.read(approvalActionsProvider.notifier).update(
                      (m) => {...m, e.id: ApprovalAction.approve},
                    );
              } finally {
                if (mounted) setState(() => _approvingEntryId = null);
              }
            },
            onReject: () => ref.read(approvalActionsProvider.notifier).update(
                  (m) => {...m, e.id: ApprovalAction.reject},
                ),
          ),
        if (pending.isEmpty)
          Padding(
            padding: const EdgeInsets.all(30),
            child: Center(
              child: Text(
                journalAsync.isLoading
                    ? 'Loading journal entries…'
                    : journal.isEmpty
                        ? 'Journal entries are still syncing from the cloud. '
                            'Pull down to refresh in a moment.'
                        : "Nothing waiting — you're all caught up.",
                style: AccountingTokens.sans(color: AccountingTokens.ink3),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }
}

class AccountingReportsTab extends ConsumerWidget {
  const AccountingReportsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final report = ref.watch(mobileReportProvider);

    final vat = ref.watch(accountingVatProvider);

    if (report != null) {
      return AccountingStatementDetail(report: report, onBack: () => ref.read(mobileReportProvider.notifier).state = null);
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text('Reports', style: AccountingTokens.sans(fontSize: 22, fontWeight: FontWeight.w800)),
        Text('Generated live from the ledger · ${ref.watch(selectedBusinessProvider)?.name ?? ''}', style: AccountingTokens.sans(fontSize: 13, color: AccountingTokens.ink3)),
        const SizedBox(height: 16),
        for (final r in _buildMobileReports(vat))
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

List<(String, String, IconData, MobileReportKey)> _buildMobileReports(VatInfo? vat) => [
  ('Income statement', 'Profit & loss', Icons.trending_up, MobileReportKey.pl),
  ('Balance sheet', 'Financial position', Icons.layers_outlined, MobileReportKey.bs),
  ('Trial balance', 'In balance', Icons.grid_view, MobileReportKey.tb),
  ('Tax & VAT', vat != null ? 'Net due ${money(vat.netPayable)}' : 'No VAT data yet', Icons.verified_user_outlined, MobileReportKey.vat),
];

class AccountingStatementDetail extends ConsumerWidget {
  const AccountingStatementDetail({super.key, required this.report, required this.onBack});

  final MobileReportKey report;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accounts = ref.watch(accountingAccountsProvider);
    final pl = incomeStatement(accounts);
    final bs = balanceSheet(accounts);
    final tb = trialBalance(accounts);
    final vat = ref.watch(accountingVatProvider);
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
                  _SRow(profitOrLossLabel(pl.netIncome), pl.netIncome, bold: true),
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
                  if (vat == null)
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        'No VAT data for this period.',
                        style: AccountingTokens.sans(color: AccountingTokens.ink3),
                      ),
                    )
                  else ...[
                    _SRow('Output VAT', vat.outputVat),
                    _SRow('Input VAT', vat.inputVat),
                    _SRow('Net payable', vat.netPayable, bold: true),
                    _SRow('Due', 0, labelOverride: vat.dueDate),
                  ],
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
    final loss = bold && value < 0;
    final emphasis = loss ? AccountingTokens.lossInk : AccountingTokens.ink1;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AccountingTokens.sans(
              fontSize: 14,
              fontWeight: bold ? FontWeight.w800 : FontWeight.w500,
              color: emphasis,
            ),
          ),
          Text(
            labelOverride ?? money(value),
            style: AccountingTokens.mono(
              fontSize: bold ? 16 : 14,
              fontWeight: bold ? FontWeight.w800 : FontWeight.w600,
              color: emphasis,
            ),
          ),
        ],
      ),
    );
  }
}

class AccountingMoreTab extends ConsumerStatefulWidget {
  const AccountingMoreTab({super.key});

  @override
  ConsumerState<AccountingMoreTab> createState() => _AccountingMoreTabState();
}

class _AccountingMoreTabState extends ConsumerState<AccountingMoreTab> {
  bool _refreshing = false;

  Future<void> _refresh() async {
    if (_refreshing) return;
    setState(() => _refreshing = true);
    try {
      await refreshAccountingFromCloud(ref);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Books data refreshed from cloud')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Refresh failed: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _refreshing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text('More', style: AccountingTokens.sans(fontSize: 22, fontWeight: FontWeight.w800)),
        const SizedBox(height: 12),
        for (final group in accountingNavGroups)
          for (final item in group.items)
            ListTile(
              leading: AccountingIcon(icon: item.icon, size: 20),
              title: Text(item.view.label),
              subtitle: Text(group.section),
              onTap: () {
                ref.read(accountingViewProvider.notifier).state = item.view;
                showAccountingToast(
                  context,
                  item.view.label,
                  subtitle: 'Open on a wider screen for the desktop workspace',
                  accIcon: item.icon,
                );
              },
            ),
        const SizedBox(height: 16),
        OutlinedButton.icon(
          onPressed: _refreshing ? null : _refresh,
          icon: _refreshing
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.cloud_sync_outlined),
          label: const Text('Refresh from cloud'),
          style: OutlinedButton.styleFrom(
            minimumSize: const Size.fromHeight(48),
          ),
        ),
        const SizedBox(height: 8),
        OutlinedButton.icon(
          onPressed: () => signOutFromBooks(context, ref),
          icon: const Icon(Icons.logout),
          label: const Text('Sign out'),
          style: OutlinedButton.styleFrom(
            minimumSize: const Size.fromHeight(48),
          ),
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

