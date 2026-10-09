import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_web/features/business_selection/business_branch_selector.dart';
import 'package:flipper_web/modules/accounting/data/accounting_derive.dart';
import 'package:flipper_web/modules/accounting/data/accounting_models.dart';
import 'package:flipper_web/modules/accounting/data/accounting_providers.dart';
import 'package:flipper_web/modules/accounting/data/services/books_file_saver.dart';
import 'package:flipper_web/modules/accounting/data/services/books_overview_export.dart';
import 'package:flipper_web/modules/accounting/theme/accounting_tokens.dart';
import 'package:flipper_web/modules/accounting/widgets/accounting_icon.dart';
import 'package:flipper_web/modules/accounting/widgets/accounting_kpi_card.dart';
import 'package:flipper_web/modules/accounting/widgets/accounting_page_header.dart';
import 'package:flipper_web/modules/accounting/widgets/accounting_toast.dart';
import 'package:flipper_web/modules/accounting/widgets/status_pill.dart';
import 'package:flipper_web/modules/accounting/widgets/trend_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AccountingDashboardView extends ConsumerWidget {
  const AccountingDashboardView({
    super.key,
    required this.onNewEntry,
    required this.onRecordExpense,
  });

  final VoidCallback onNewEntry;
  final VoidCallback onRecordExpense;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.flipperL10n;
    final isLoading = ref.watch(accountingLoadingProvider);
    final pl = ref.watch(accountingIncomeStatementProvider);
    final journal = ref.watch(accountingJournalProvider);
    final trend = ref.watch(accountingTrendProvider);
    final cashBank = ref.watch(accountingCashBankTotalProvider);
    final arAge = ageTotals(ref.watch(accountingArAgingProvider));
    final apAge = ageTotals(ref.watch(accountingApAgingProvider));
    final entityName = ref.watch(selectedBusinessProvider)?.name ?? '';
    final period = ref.watch(accountingPeriodLabelProvider);
    final currency = ref.watch(accountingCurrencyProvider);
    final accounts = ref.watch(accountingAccountsProvider);
    final arOverdue60 = ref
        .watch(accountingArAgingProvider)
        .fold<int>(0, (s, r) => s + r.d60 + r.d90);
    final liquidAccountCount = accounts
        .where((a) => {'1010', '1020', '1030'}.contains(a.code))
        .length;
    final incomeDelta = _trendDeltaPercent(trend, income: true);
    final cashDelta = _trendDeltaPercent(trend, income: false);

    final opexSegs = pl.opex.asMap().entries.map((e) {
      const colors = [
        AccountingTokens.accent,
        AccountingTokens.crInk,
        AccountingTokens.violet,
        Color(0xFFE89A2A),
        AccountingTokens.loss,
        Color(0xFF64748B),
      ];
      return (
        label: e.value.name,
        value: e.value.bal,
        color: colors[e.key % colors.length],
      );
    }).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(28, 24, 28, 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AccountingPageHeader(
            eyebrow: l10n.booksFinancialOverview,
            title: l10n.booksAtAGlance,
            subtitle: entityName.isNotEmpty
                ? l10n.booksDashSubtitleEntity(currency, entityName, period)
                : l10n.booksDashSubtitle(currency, period),
            actions: [
              PopupMenuButton<String>(
                tooltip: l10n.booksExport,
                offset: const Offset(0, 40),
                onSelected: (value) => _exportOverview(context, ref, value),
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'excel',
                    child: Text(l10n.booksExcelWorkbook),
                  ),
                  PopupMenuItem(value: 'pdf', child: Text(l10n.booksPdfReport)),
                  PopupMenuItem(
                    value: 'csv',
                    child: Text(l10n.booksCsvRawLedger),
                  ),
                ],
                child: AccountingButton(
                  label: l10n.booksExport,
                  icon: Icons.download_outlined,
                ),
              ),
              AccountingButton(
                label: l10n.booksRecordExpense,
                icon: Icons.account_balance_wallet_outlined,
                onPressed: onRecordExpense,
              ),
              AccountingButton(
                label: l10n.booksNewJournalEntry,
                icon: Icons.add,
                primary: true,
                onPressed: onNewEntry,
              ),
            ],
          ),
          if (isLoading)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: LinearProgressIndicator(),
            ),
          AccountingKpiGrid(
            children: [
              AccountingKpiCard(
                label: profitOrLossLabel(pl.netIncome),
                value: pl.netIncome,
                icon: AccIcon.chart,
                tone: pl.netIncome < 0 ? KpiTone.red : KpiTone.green,
                delta: incomeDelta,
                footnote: incomeDelta != null ? l10n.booksVsPriorPeriod : null,
              ),
              AccountingKpiCard(
                label: l10n.booksCashAndBank,
                value: cashBank,
                icon: AccIcon.wallet,
                tone: KpiTone.blue,
                delta: cashDelta,
                footnote: liquidAccountCount > 0
                    ? l10n.booksAcrossAccounts(liquidAccountCount)
                    : null,
              ),
              AccountingKpiCard(
                label: l10n.booksReceivable,
                value: arAge.total,
                icon: AccIcon.arrowUpRight,
                tone: KpiTone.amber,
                footnote: arOverdue60 > 0
                    ? l10n.booksOverdue60(money(arOverdue60))
                    : l10n.booksNoOverdue60,
                deltaPositive: false,
              ),
              AccountingKpiCard(
                label: l10n.booksPayable,
                value: apAge.total,
                icon: AccIcon.arrowDown,
                tone: KpiTone.red,
                footnote: apAge.total == 0
                    ? l10n.booksNoOpenBills
                    : l10n.booksOpenBills(
                        ref.watch(accountingApAgingProvider).length,
                      ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          LayoutBuilder(
            builder: (context, c) {
              if (c.maxWidth < 800) {
                return Column(
                  children: [
                    _TrendCard(trend: trend),
                    const SizedBox(height: 12),
                    _DonutCard(segments: opexSegs, totalOpex: pl.totalOpex),
                  ],
                );
              }
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 7, child: _TrendCard(trend: trend)),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 5,
                    child: _DonutCard(
                      segments: opexSegs,
                      totalOpex: pl.totalOpex,
                    ),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 16),
          LayoutBuilder(
            builder: (context, c) {
              if (c.maxWidth < 800) {
                return Column(
                  children: [
                    _RecentJournalCard(journal: journal),
                    const SizedBox(height: 12),
                    _MiniPlCard(pl: pl),
                  ],
                );
              }
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 7,
                    child: _RecentJournalCard(journal: journal),
                  ),
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
  const _TrendCard({required this.trend});

  final List<TrendPoint> trend;

  @override
  Widget build(BuildContext context) {
    return AccountingCard(
      child: Column(
        children: [
          AccountingCardHeader(
            title: context.flipperL10n.booksRevenueVsExpenses,
            subtitle: context.flipperL10n.booksTrailing6Months,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: TrendChart(data: trend),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AccountingCardHeader(
            title: context.flipperL10n.booksWhereMoneyWent,
            subtitle: context.flipperL10n.booksOpexBreakdown,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
            child: Row(
              children: [
                DonutChart(
                  segments: segments,
                  center: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        compact(totalOpex),
                        style: AccountingTokens.mono(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        context.flipperL10n.booksOpexShort,
                        style: AccountingTokens.sans(
                          fontSize: 10.5,
                          color: AccountingTokens.ink3,
                        ),
                      ),
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
                              Container(
                                width: 9,
                                height: 9,
                                decoration: BoxDecoration(
                                  color: s.color,
                                  borderRadius: BorderRadius.circular(3),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  s.label,
                                  style: AccountingTokens.sans(
                                    fontSize: 12.5,
                                    color: AccountingTokens.ink2,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Text(
                                compact(s.value),
                                style: AccountingTokens.mono(fontSize: 12.5),
                              ),
                            ],
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

class _RecentJournalCard extends StatelessWidget {
  const _RecentJournalCard({required this.journal});

  final List<JournalEntry> journal;

  @override
  Widget build(BuildContext context) {
    final entries = journal.take(5);
    return AccountingCard(
      child: Column(
        children: [
          AccountingCardHeader(
            title: context.flipperL10n.booksRecentJournalEntries,
          ),
          if (entries.isEmpty)
            Padding(
              padding: const EdgeInsets.all(24),
              child: Text(
                context.flipperL10n.booksNoJournalEntriesYet,
                style: AccountingTokens.sans(color: AccountingTokens.ink3),
              ),
            ),
          for (final e in entries)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          e.id,
                          style: AccountingTokens.mono(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: AccountingTokens.accent,
                          ),
                        ),
                        Text(
                          e.date,
                          style: AccountingTokens.sans(
                            fontSize: 11.5,
                            color: AccountingTokens.ink3,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text(
                      e.memo,
                      style: AccountingTokens.sans(fontSize: 13.5),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ),
                  Flexible(
                    child: Wrap(
                      spacing: 8,
                      alignment: WrapAlignment.end,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        StatusPill(status: e.status),
                        Text(
                          money(jeTotals(e).dr),
                          style: AccountingTokens.mono(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w700,
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

class _MiniPlCard extends StatelessWidget {
  const _MiniPlCard({required this.pl});

  final IncomeStatementResult pl;

  @override
  Widget build(BuildContext context) {
    return AccountingCard(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 18),
      child: Column(
        children: [
          AccountingCardHeader(title: context.flipperL10n.booksProfitLoss),
          _PlRow(context.flipperL10n.booksNetRevenue, pl.netRevenue),
          _PlRow(context.flipperL10n.booksCogs, -pl.cogs, muted: true),
          _PlRow(
            context.flipperL10n.booksGrossProfit,
            pl.grossProfit,
            strong: true,
          ),
          _PlRow(
            context.flipperL10n.booksOperatingExpenses,
            -pl.totalOpex,
            muted: true,
          ),
          Builder(
            builder: (context) {
              final loss = pl.netIncome < 0;
              final bg = loss
                  ? AccountingTokens.lossTint
                  : AccountingTokens.gainTint;
              final fg = loss
                  ? AccountingTokens.lossInk
                  : AccountingTokens.gainInk;
              return Container(
                margin: const EdgeInsets.only(top: 10),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: bg,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      profitOrLossLabel(pl.netIncome),
                      style: AccountingTokens.sans(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: fg,
                      ),
                    ),
                    Text(
                      money(pl.netIncome),
                      style: AccountingTokens.mono(
                        fontSize: 19,
                        fontWeight: FontWeight.w800,
                        color: fg,
                      ),
                    ),
                  ],
                ),
              );
            },
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
          Text(
            label,
            style: AccountingTokens.sans(
              fontSize: 13.5,
              fontWeight: strong ? FontWeight.w700 : FontWeight.w500,
              color: muted ? AccountingTokens.ink2 : AccountingTokens.ink1,
            ),
          ),
          Text(
            money(val),
            style: AccountingTokens.mono(
              fontSize: 13.5,
              fontWeight: strong ? FontWeight.w700 : FontWeight.w600,
              color: muted ? AccountingTokens.ink2 : AccountingTokens.ink1,
            ),
          ),
        ],
      ),
    );
  }
}

Future<void> _exportOverview(
  BuildContext context,
  WidgetRef ref,
  String format,
) async {
  final l10n = context.flipperL10n;
  final snapshot = BooksOverviewSnapshot(
    entityName: ref.read(selectedBusinessProvider)?.name ?? '',
    period: ref.read(accountingPeriodLabelProvider),
    currency: ref.read(accountingCurrencyProvider),
    pl: ref.read(accountingIncomeStatementProvider),
    cashBank: ref.read(accountingCashBankTotalProvider),
    arTotal: ageTotals(ref.read(accountingArAgingProvider)).total,
    apTotal: ageTotals(ref.read(accountingApAgingProvider)).total,
    trend: ref.read(accountingTrendProvider),
    journal: ref.read(accountingJournalProvider),
    accounts: ref.read(accountingAccountsProvider),
  );
  final saver = ref.read(booksFileSaverProvider);
  final ext = switch (format) {
    'excel' => 'xlsx',
    'pdf' => 'pdf',
    _ => 'csv',
  };
  final fileName = booksExportFileName(
    snapshot.entityName,
    snapshot.period,
    ext,
  );

  showAccountingToast(
    context,
    switch (format) {
      'excel' => l10n.booksExportingExcel,
      'pdf' => l10n.booksGeneratingPdf,
      _ => l10n.booksExportingCsv,
    },
    subtitle: fileName,
    icon: Icons.download_outlined,
  );
  try {
    final bytes = switch (format) {
      'excel' => buildOverviewXlsx(snapshot, l10n),
      'pdf' => await buildOverviewPdf(snapshot, l10n),
      _ => buildLedgerCsv(snapshot, l10n),
    };
    final saved = await saver.save(bytes, fileName, ext);
    if (!saved || !context.mounted) return;
    showAccountingToast(
      context,
      l10n.booksExportReady,
      subtitle: fileName,
      icon: Icons.download_done_outlined,
      tone: AccountingToastTone.success,
    );
  } catch (e) {
    if (!context.mounted) return;
    showAccountingToast(
      context,
      l10n.booksActionFailed('$e'),
      icon: Icons.error_outline,
      tone: AccountingToastTone.warn,
    );
  }
}

int? _trendDeltaPercent(List<TrendPoint> trend, {required bool income}) {
  if (trend.length < 2) return null;
  final last = trend.last;
  final prev = trend[trend.length - 2];
  final lastVal = income ? last.rev - last.exp : last.rev;
  final prevVal = income ? prev.rev - prev.exp : prev.rev;
  if (prevVal == 0) return null;
  return (((lastVal - prevVal) / prevVal.abs()) * 100).round();
}
