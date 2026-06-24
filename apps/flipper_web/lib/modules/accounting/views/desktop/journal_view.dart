import 'package:flipper_web/modules/accounting/data/accounting_derive.dart';
import 'package:flipper_web/modules/accounting/data/accounting_models.dart';
import 'package:flipper_web/modules/accounting/data/accounting_providers.dart';
import 'package:flipper_web/modules/accounting/routing/accounting_route.dart';
import 'package:flipper_web/modules/accounting/theme/accounting_tokens.dart';
import 'package:flipper_web/modules/accounting/widgets/accounting_page_header.dart';
import 'package:flipper_web/modules/accounting/widgets/status_pill.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AccountingJournalView extends ConsumerWidget {
  const AccountingJournalView({
    super.key,
    required this.onNewEntry,
    required this.onRecordExpense,
  });

  final VoidCallback onNewEntry;
  final VoidCallback onRecordExpense;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(journalFilterProvider);
    final sourceFilter = ref.watch(journalSourceFilterProvider);
    final pending = ref.watch(pendingCountProvider);
    final isLoading = ref.watch(accountingLoadingProvider);

    final journal = ref.watch(accountingJournalProvider);
    final sources = journal.map((e) => e.src).toSet().toList()..sort();
    final currency = ref.watch(accountingCurrencyProvider);
    final accountMap = {
      for (final a in ref.watch(accountingAccountsProvider)) a.code: a,
    };

    final list = journal.where((e) {
      final statusOk = switch (filter) {
        JournalFilter.all => true,
        JournalFilter.posted => e.status == JournalStatus.posted,
        JournalFilter.pending => e.status == JournalStatus.pending,
        JournalFilter.draft => e.status == JournalStatus.draft,
      };
      final sourceOk = sourceFilter == null || e.src == sourceFilter;
      return statusOk && sourceOk;
    }).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(28, 24, 28, 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AccountingPageHeader(
            eyebrow: 'Daybook',
            title: 'Journal entries',
            subtitle:
                'Every transaction as a balanced double entry · $currency',
            actions: [
              PopupMenuButton<String?>(
                tooltip: 'Filter by source',
                offset: const Offset(0, 40),
                onSelected: (src) =>
                    ref.read(journalSourceFilterProvider.notifier).state = src,
                itemBuilder: (context) => [
                  const PopupMenuItem<String?>(
                    value: null,
                    child: Text('All sources'),
                  ),
                  for (final src in sources)
                    PopupMenuItem(value: src, child: Text(src)),
                ],
                child: AccountingButton(
                  label: sourceFilter ?? 'Filter',
                  icon: Icons.filter_list,
                  small: true,
                ),
              ),
              AccountingButton(
                label: 'Record expense',
                icon: Icons.account_balance_wallet_outlined,
                small: true,
                onPressed: onRecordExpense,
              ),
              AccountingButton(
                label: 'New journal entry',
                icon: Icons.add,
                primary: true,
                onPressed: onNewEntry,
              ),
            ],
          ),
          if (isLoading)
            const Padding(
              padding: EdgeInsets.only(bottom: 8),
              child: LinearProgressIndicator(),
            ),
          Wrap(
            spacing: 6,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              ...JournalFilter.values.map((f) {
                final label = switch (f) {
                  JournalFilter.all => 'All',
                  JournalFilter.posted => 'Posted',
                  JournalFilter.pending => 'Pending',
                  JournalFilter.draft => 'Drafts',
                };
                final on = filter == f;
                return ChoiceChip(
                  label: Text(
                    f == JournalFilter.pending && pending > 0
                        ? '$label ($pending)'
                        : label,
                    style: AccountingTokens.sans(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: on
                          ? AccountingTokens.accent
                          : AccountingTokens.ink2,
                    ),
                  ),
                  selected: on,
                  onSelected: (_) =>
                      ref.read(journalFilterProvider.notifier).state = f,
                  selectedColor: AccountingTokens.accentTint,
                  backgroundColor: AccountingTokens.surface,
                  side: BorderSide(
                    color: on ? AccountingTokens.accent : AccountingTokens.line,
                  ),
                );
              }),
              if (pending > 0)
                Text(
                  '$pending entries awaiting approval',
                  style: AccountingTokens.sans(
                    fontSize: 13,
                    color: AccountingTokens.warnAmber,
                    fontWeight: FontWeight.w600,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          AccountingCard(
            child: Column(
              children: [
                if (list.isEmpty)
                  Padding(
                    padding: const EdgeInsets.all(32),
                    child: Text(
                      'No entries match this filter.',
                      style: AccountingTokens.sans(
                        fontSize: 13.5,
                        color: AccountingTokens.ink3,
                      ),
                    ),
                  )
                else
                  for (final e in list)
                    _JournalRow(entry: e, accountMap: accountMap),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _JournalRow extends StatelessWidget {
  const _JournalRow({required this.entry, required this.accountMap});

  final JournalEntry entry;
  final Map<String, Account> accountMap;

  @override
  Widget build(BuildContext context) {
    final t = jeTotals(entry);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.id,
                  style: AccountingTokens.mono(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AccountingTokens.accent,
                  ),
                ),
                Text(
                  '${entry.date} · ${entry.ref}',
                  style: AccountingTokens.sans(
                    fontSize: 11.5,
                    color: AccountingTokens.ink3,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.memo,
                  style: AccountingTokens.sans(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text.rich(
                  TextSpan(
                    children: [
                      for (var i = 0; i < entry.lines.length; i++) ...[
                        if (i > 0)
                          TextSpan(
                            text: ' · ',
                            style: AccountingTokens.sans(
                              fontSize: 12,
                              color: AccountingTokens.ink3,
                            ),
                          ),
                        TextSpan(
                          text:
                              '${entry.lines[i].dr > 0 ? 'Dr' : 'Cr'} ${acctName(entry.lines[i].ac, accountMap)}',
                          style: AccountingTokens.sans(
                            fontSize: 12,
                            color: entry.lines[i].dr > 0
                                ? AccountingTokens.drInk
                                : AccountingTokens.crInk,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
          Flexible(
            child: Wrap(
              spacing: 8,
              runSpacing: 4,
              alignment: WrapAlignment.end,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AccountingTokens.surface2,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    entry.src,
                    style: AccountingTokens.sans(
                      fontSize: 11.5,
                      color: AccountingTokens.ink2,
                    ),
                  ),
                ),
                StatusPill(status: entry.status),
                Text(
                  money(t.dr),
                  style: AccountingTokens.mono(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
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
