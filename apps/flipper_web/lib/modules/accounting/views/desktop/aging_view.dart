import 'package:flipper_web/modules/accounting/data/accounting_derive.dart';
import 'package:flipper_web/modules/accounting/data/accounting_models.dart';
import 'package:flipper_web/modules/accounting/data/accounting_providers.dart';
import 'package:flipper_web/modules/accounting/theme/accounting_tokens.dart';
import 'package:flipper_web/modules/accounting/widgets/accounting_page_header.dart';
import 'package:flipper_web/modules/accounting/widgets/accounting_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const _agingBuckets = <({String key, String label, Color color})>[
  (key: 'current', label: 'Current', color: AccountingTokens.accent),
  (key: 'd30', label: '1–30 days', color: Color(0xFF0EA5A4)),
  (key: 'd60', label: '31–60 days', color: Color(0xFFE89A2A)),
  (key: 'd90', label: '60+ days', color: AccountingTokens.loss),
];

class AccountingAgingView extends ConsumerWidget {
  const AccountingAgingView({
    super.key,
    required this.kind,
    required this.onNewEntry,
  });

  final String kind; // ar | ap
  final VoidCallback onNewEntry;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isAr = kind == 'ar';
    final rows = isAr
        ? ref.watch(accountingArAgingProvider)
        : ref.watch(accountingApAgingProvider);
    final currency = ref.watch(accountingCurrencyProvider);
    final totals = ageTotals(rows);

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(28, 24, 28, 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AccountingPageHeader(
            eyebrow: isAr ? 'Money in' : 'Money out',
            title: isAr ? 'Accounts receivable' : 'Accounts payable',
            subtitle:
                '${isAr ? 'What customers owe you' : 'What you owe suppliers'} · aged · $currency',
            actions: [
              AccountingButton(
                label: isAr ? 'Send reminders' : 'Schedule payment',
                icon: Icons.mail_outlined,
                small: true,
                onPressed: () => showAccountingToast(
                  context,
                  isAr ? 'Reminders sent' : 'Payment scheduled',
                  subtitle: isAr
                      ? 'Emailed 4 customers with open balances'
                      : 'Queued 4 supplier payments',
                  icon: Icons.mail_outlined,
                  tone: isAr
                      ? AccountingToastTone.success
                      : AccountingToastTone.info,
                ),
              ),
              AccountingButton(
                label: isAr ? 'New invoice' : 'New bill',
                icon: Icons.add,
                primary: true,
                small: true,
                onPressed: onNewEntry,
              ),
            ],
          ),
          _AgingSummaryCard(currency: currency, totals: totals),
          const SizedBox(height: 16),
          _AgingTableCard(isAr: isAr, rows: rows, totals: totals),
        ],
      ),
    );
  }
}

class _AgingSummaryCard extends StatelessWidget {
  const _AgingSummaryCard({required this.currency, required this.totals});

  final String currency;
  final AgeTotals totals;

  @override
  Widget build(BuildContext context) {
    return AccountingCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
            child: Row(
              children: [
                Text('Aging summary', style: AccountingTokens.cardTitle),
                const Spacer(),
                Text(
                  '$currency ${money(totals.total)}',
                  style: AccountingTokens.mono(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(7),
                  child: SizedBox(
                    height: 16,
                    child: ColoredBox(
                      color: AccountingTokens.surface2,
                      child: Row(
                        children: [
                          if (totals.total > 0)
                            for (final b in _agingBuckets)
                              if ((totals.buckets[b.key] ?? 0) > 0)
                                Expanded(
                                  flex: totals.buckets[b.key]!,
                                  child: ColoredBox(color: b.color),
                                ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    for (final b in _agingBuckets)
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border(
                              left: BorderSide(color: b.color, width: 3),
                            ),
                          ),
                          padding: const EdgeInsets.only(left: 12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                b.label,
                                style: AccountingTokens.sans(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: AccountingTokens.ink3,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                money(totals.buckets[b.key] ?? 0),
                                style: AccountingTokens.mono(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AgingTableCard extends StatelessWidget {
  const _AgingTableCard({
    required this.isAr,
    required this.rows,
    required this.totals,
  });

  final bool isAr;
  final List<AgingRow> rows;
  final AgeTotals totals;

  @override
  Widget build(BuildContext context) {
    return AccountingCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          _AgingTableRow(
            isHeader: true,
            cells: [
              isAr ? 'Customer' : 'Supplier',
              'Reference',
              ..._agingBuckets.map((b) => b.label),
              'Total',
            ],
          ),
          for (final r in rows)
            _AgingDataRow(
              isAr: isAr,
              row: r,
            ),
          _AgingFooterRow(totals: totals),
        ],
      ),
    );
  }
}

class _AgingTableRow extends StatelessWidget {
  const _AgingTableRow({
    required this.cells,
    this.isHeader = false,
  });

  final List<String> cells;
  final bool isHeader;

  @override
  Widget build(BuildContext context) {
    assert(cells.length == 7);

    return Container(
      decoration: BoxDecoration(
        color: isHeader ? AccountingTokens.surface2 : null,
        border: isHeader
            ? const Border(bottom: BorderSide(color: AccountingTokens.line))
            : null,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: 16,
        vertical: isHeader ? 11 : 13,
      ),
      child: Row(
        children: [
          Expanded(
            flex: 21,
            child: Text(
              isHeader ? cells[0].toUpperCase() : cells[0],
              style: AccountingTokens.tableHead,
            ),
          ),
          Expanded(
            flex: 11,
            child: Text(
              isHeader ? cells[1].toUpperCase() : cells[1],
              style: isHeader ? AccountingTokens.tableHead : const TextStyle(),
            ),
          ),
          for (var i = 2; i < 6; i++)
            Expanded(
              flex: 10,
              child: Text(
                isHeader ? cells[i].toUpperCase() : cells[i],
                style: AccountingTokens.tableHead,
                textAlign: TextAlign.right,
              ),
            ),
          Expanded(
            flex: 10,
            child: Text(
              isHeader ? cells[6].toUpperCase() : cells[6],
              style: AccountingTokens.tableHead,
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}

class _AgingFooterRow extends StatelessWidget {
  const _AgingFooterRow({required this.totals});

  final AgeTotals totals;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AccountingTokens.surface2,
        border: Border(
          top: BorderSide(color: AccountingTokens.lineStrong, width: 2),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
      child: Row(
        children: [
          Expanded(
            flex: 32,
            child: Text(
              'Totals',
              style: AccountingTokens.sans(
                fontSize: 13.5,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          for (final b in _agingBuckets)
            Expanded(
              flex: 10,
              child: Text(
                money(totals.buckets[b.key] ?? 0),
                style: AccountingTokens.mono(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.right,
              ),
            ),
          Expanded(
            flex: 10,
            child: Text(
              money(totals.total),
              style: AccountingTokens.mono(
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}

class _AgingDataRow extends StatelessWidget {
  const _AgingDataRow({required this.isAr, required this.row});

  final bool isAr;
  final AgingRow row;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => showAccountingToast(
          context,
          'Statement of account',
          subtitle: '${row.name} · ${money(row.total)} outstanding',
          icon: isAr ? Icons.north_east : Icons.south_west,
        ),
        hoverColor: AccountingTokens.surface2,
        child: Container(
          decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: AccountingTokens.line)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
          child: Row(
            children: [
              Expanded(
                flex: 21,
                child: Text(
                  row.name,
                  style: AccountingTokens.sans(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Expanded(
                flex: 11,
                child: Text(
                  row.inv,
                  style: AccountingTokens.mono(
                    fontSize: 12.5,
                    color: AccountingTokens.ink3,
                  ),
                ),
              ),
              Expanded(
                flex: 10,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: _AgingAmountCell(value: row.current),
                ),
              ),
              Expanded(
                flex: 10,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: _AgingAmountCell(value: row.d30),
                ),
              ),
              Expanded(
                flex: 10,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: _AgingAmountCell(value: row.d60, bucket: 'd60'),
                ),
              ),
              Expanded(
                flex: 10,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: _AgingAmountCell(value: row.d90, bucket: 'd90'),
                ),
              ),
              Expanded(
                flex: 10,
                child: Text(
                  money(row.total),
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
      ),
    );
  }
}

class _AgingAmountCell extends StatelessWidget {
  const _AgingAmountCell({required this.value, this.bucket});

  final int value;
  final String? bucket;

  @override
  Widget build(BuildContext context) {
    if (value == 0) {
      return Text(
        '—',
        style: AccountingTokens.mono(
          fontSize: 12.5,
          color: AccountingTokens.ink3,
        ),
        textAlign: TextAlign.right,
      );
    }

    final color = switch (bucket) {
      'd60' => AccountingTokens.warnAmber,
      'd90' => AccountingTokens.lossInk,
      _ => AccountingTokens.ink1,
    };

    return Text(
      money(value),
      style: AccountingTokens.mono(
        fontSize: 12.5,
        fontWeight: FontWeight.w600,
        color: color,
      ),
      textAlign: TextAlign.right,
    );
  }
}
