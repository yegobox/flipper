import 'package:file_picker/file_picker.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_web/features/business_selection/business_branch_selector.dart';
import 'package:flipper_web/modules/accounting/data/accounting_balances.dart';
import 'package:flipper_web/modules/accounting/data/bank_rec_matching.dart';
import 'package:flipper_web/modules/accounting/data/accounting_derive.dart';
import 'package:flipper_web/modules/accounting/data/accounting_models.dart';
import 'package:flipper_web/modules/accounting/data/accounting_providers.dart';
import 'package:flipper_web/modules/accounting/routing/accounting_route.dart';
import 'package:flipper_web/modules/accounting/theme/accounting_tokens.dart';
import 'package:flipper_web/modules/accounting/widgets/account_type_pill.dart';
import 'package:flipper_web/modules/accounting/widgets/accounting_icon.dart';
import 'package:flipper_web/modules/accounting/widgets/accounting_kpi_card.dart';
import 'package:flipper_web/modules/accounting/widgets/accounting_page_header.dart';
import 'package:flipper_web/modules/accounting/widgets/accounting_tag.dart';
import 'package:flipper_web/modules/accounting/widgets/accounting_toast.dart';
import 'package:flipper_web/modules/accounting/widgets/create_account_modal.dart';
import 'package:flipper_web/modules/accounting/widgets/status_pill.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

class AccountingGeneralLedgerView extends ConsumerWidget {
  const AccountingGeneralLedgerView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.flipperL10n;
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
            eyebrow: l10n.booksDaybook,
            title: l10n.booksGeneralLedger,
            subtitle: l10n.booksAccountPostingHistory(currency),
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
                  if (v != null) {
                    ref.read(ledgerAccountCodeProvider.notifier).state = v;
                  }
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
                    l10n.booksClosingBalance(money(account.bal)),
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

/// Stable id per statement line so re-imports and match updates upsert the
/// same row on both backends (valid UUID for Postgres, plain doc id for Ditto).
String _bankLineId(String businessId, BankLine line) => const Uuid().v5(
  Namespace.url.value,
  'flipper:bank-line:$businessId:${line.date}:${line.amt}:${line.desc}',
);

String _bankLineDateLabel(String? isoDate) {
  final dt = isoDate == null ? null : DateTime.tryParse(isoDate);
  if (dt == null) return isoDate ?? '';
  const months = [
    '',
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];
  return '${months[dt.month]} ${dt.day}';
}

/// Debug-only: wipe imported statement lines + in-memory meta so you can re-import.
Future<void> _clearBankStatementImport(
  BuildContext context,
  WidgetRef ref,
) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Clear bank import?'),
      content: const Text(
        'Deletes all imported statement lines for this business and resets '
        'match state. Journal entries are not affected.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text('Clear'),
        ),
      ],
    ),
  );
  if (confirmed != true || !context.mounted) return;

  final businessId = ref.read(accountingBusinessIdProvider);
  if (businessId.isNotEmpty) {
    await ref
        .read(accountingLedgerRepositoryProvider)
        .clearBankStatementLines(businessId: businessId);
  }

  ref.read(bankRecLocalLinesProvider.notifier).state = const [];
  ref.read(bankStatementMetaProvider.notifier).state = null;
  ref.read(bankRecFinishedProvider.notifier).state = false;

  if (!context.mounted) return;
  showAccountingToast(
    context,
    'Bank import cleared',
    subtitle: 'You can import a statement again',
    icon: Icons.delete_outline,
    tone: AccountingToastTone.success,
  );
}

Future<void> _importBankStatement(BuildContext context, WidgetRef ref) async {
  final picked = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: ['pdf'],
    withData: true,
  );
  final file = picked?.files.single;
  final bytes = file?.bytes;
  if (file == null || bytes == null) return;

  if (!context.mounted) return;
  showAccountingToast(
    context,
    context.flipperL10n.booksReadingStatement,
    subtitle: file.name,
    icon: Icons.sync,
  );

  try {
    final statement = await ref.read(bankStatementServiceProvider).parse(bytes);
    final businessId = ref.read(accountingBusinessIdProvider);
    final repo = ref.read(accountingLedgerRepositoryProvider);

    final lines = <BankLine>[];
    for (final parsed in statement.lines) {
      final line = BankLine(
        date: _bankLineDateLabel(parsed.date),
        desc: parsed.description ?? '',
        amt: parsed.amount.round(),
        matched: false,
      );
      lines.add(line);
      if (businessId.isNotEmpty) {
        await repo.upsertBankLine(
          businessId: businessId,
          line: line,
          id: _bankLineId(businessId, line),
        );
      }
    }

    ref.read(bankRecLocalLinesProvider.notifier).state = lines;
    ref.read(bankStatementMetaProvider.notifier).state = statement;
    ref.read(bankRecFinishedProvider.notifier).state = false;

    if (!context.mounted) return;
    showAccountingToast(
      context,
      context.flipperL10n.booksStatementImported,
      subtitle: context.flipperL10n.booksStatementLinesLoaded(
        lines.length,
        statement.bankName ?? file.name,
      ),
      icon: Icons.sync,
      tone: AccountingToastTone.success,
    );
  } catch (e) {
    if (!context.mounted) return;
    showAccountingToast(
      context,
      context.flipperL10n.booksImportFailed,
      subtitle: '$e',
      icon: Icons.error_outline,
      tone: AccountingToastTone.warn,
    );
  }
}

Future<List<JournalEntry>> _journalEntriesForBankRec(WidgetRef ref) async {
  final businessId = ref.read(accountingBusinessIdProvider);
  if (businessId.isEmpty) return [];
  final repo = ref.read(accountingLedgerRepositoryProvider);
  final meta = ref.read(bankStatementMetaProvider);
  final (start, end) = bankRecJournalDateRange(meta);
  final scoped = await repo
      .watchJournalEntries(
        businessId: businessId,
        startDate: start,
        endDate: end,
      )
      .first;
  // If the statement period was wrong or sparse, search the full ledger too.
  if (scoped.length >= 25) return scoped;
  final all = await repo.watchJournalEntries(businessId: businessId).first;
  if (all.length <= scoped.length) return scoped;
  final seen = <String>{};
  return [
    for (final e in [...scoped, ...all])
      if (seen.add(e.uuid ?? e.id)) e,
  ];
}

Future<void> _matchBankLine(
  BuildContext context,
  WidgetRef ref,
  int index,
  BankLine line,
) async {
  const bankAccountCode = '1020';
  final journal = await _journalEntriesForBankRec(ref);
  final matchCandidates = findBankMatchCandidates(
    journal: journal,
    line: line,
    primaryAccountCode: bankAccountCode,
  );

  if (matchCandidates.isEmpty) {
    if (!context.mounted) return;
    // No existing journal moves this amount (bank fees, transfers, owner
    // draws, un-rung income, …). Instead of a dead end, let the user pick a
    // plain-language category; we post the balanced entry for them and match.
    await _categorizeBankLine(context, ref, index, line);
    return;
  }

  BankMatchCandidate? chosen = matchCandidates.length == 1
      ? matchCandidates.first
      : await _pickBankMatchCandidate(context, matchCandidates, line);
  if (chosen == null || !context.mounted) return;

  if (chosen.accountCode != bankAccountCode) {
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.flipperL10n.booksMatchDifferentAccountTitle),
        content: Text(
          context.flipperL10n.booksMatchDifferentAccountBody(
            liquidAccountLabel(chosen.accountCode),
            money(line.amt.abs()),
            bankAccountCode,
            chosen.accountCode,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(context.flipperL10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(context.flipperL10n.booksMatch),
          ),
        ],
      ),
    );
    if (ok != true) return;
  }

  final entry = chosen.entry;
  await _persistBankLineMatch(
    ref,
    index,
    line,
    entryUuid: entry.uuid ?? entry.id,
    entryNumber: entry.id,
  );

  if (!context.mounted) return;
  showAccountingToast(
    context,
    context.flipperL10n.booksBankLineMatched,
    subtitle: '${line.desc} → ${entry.id}',
    icon: Icons.check,
    tone: AccountingToastTone.success,
  );
}

/// Marks [line] matched in local state + persists the link to the ledger
/// backend. Shared by auto-match and the categorize-and-create flow.
Future<void> _persistBankLineMatch(
  WidgetRef ref,
  int index,
  BankLine line, {
  required String entryUuid,
  required String entryNumber,
}) async {
  final matched = BankLine(
    date: line.date,
    desc: line.desc,
    amt: line.amt,
    matched: true,
    je: entryNumber,
  );

  final lines = List<BankLine>.from(ref.read(accountingBankLinesProvider));
  if (index < lines.length) lines[index] = matched;
  ref.read(bankRecLocalLinesProvider.notifier).state = lines;
  ref.read(bankRecFinishedProvider.notifier).state = false;

  final businessId = ref.read(accountingBusinessIdProvider);
  if (businessId.isNotEmpty) {
    await ref
        .read(accountingLedgerRepositoryProvider)
        .upsertBankLine(
          businessId: businessId,
          line: matched,
          id: _bankLineId(businessId, line),
          matchedJournalEntryId: entryUuid,
          matchedEntryNumber: entryNumber,
        );
  }
}

/// A plain-language reason a bank line exists, mapped to the GL account the
/// non-bank leg of the auto-generated journal entry should hit.
class _BankLineCategory {
  const _BankLineCategory({
    required this.label,
    required this.hint,
    required this.accountCode,
  });

  final String label;
  final String hint;

  /// GL code for the counter-leg (the bank leg is always 1020).
  final String accountCode;
}

/// Categories shown when no journal matches a bank line. Money-in and money-out
/// lists differ; every code exists in the default chart of accounts.
List<_BankLineCategory> _bankLineCategories(
  FlipperAppLocalizations l10n, {
  required bool moneyIn,
}) {
  if (moneyIn) {
    return [
      _BankLineCategory(
        label: l10n.booksBankCatSaleIncome,
        hint: l10n.booksBankCatSaleIncomeHint,
        accountCode: '4010',
      ),
      _BankLineCategory(
        label: l10n.booksBankCatCustomerPaid,
        hint: l10n.booksBankCatCustomerPaidHint,
        accountCode: '1100',
      ),
      _BankLineCategory(
        label: l10n.booksBankCatOwnerAdded,
        hint: l10n.booksBankCatOwnerAddedHint,
        accountCode: '3010',
      ),
      _BankLineCategory(
        label: l10n.booksBankCatLoanReceived,
        hint: l10n.booksBankCatLoanReceivedHint,
        accountCode: '2200',
      ),
      _BankLineCategory(
        label: l10n.booksBankCatFromCash,
        hint: l10n.booksBankCatFromCashHint,
        accountCode: '1010',
      ),
      _BankLineCategory(
        label: l10n.booksBankCatFromMomo,
        hint: l10n.booksBankCatFromMomoHint,
        accountCode: '1030',
      ),
      _BankLineCategory(
        label: l10n.booksBankCatOtherIncome,
        hint: l10n.booksBankCatOtherIncomeHint,
        accountCode: '4020',
      ),
    ];
  }
  return [
    _BankLineCategory(
      label: l10n.booksBankCatBankFee,
      hint: l10n.booksBankCatBankFeeHint,
      accountCode: '6000',
    ),
    _BankLineCategory(
      label: l10n.booksBankCatPaidSupplier,
      hint: l10n.booksBankCatPaidSupplierHint,
      accountCode: '1200',
    ),
    _BankLineCategory(
      label: l10n.booksBankCatRent,
      hint: l10n.booksBankCatRentHint,
      accountCode: '6010',
    ),
    _BankLineCategory(
      label: l10n.booksBankCatSalaries,
      hint: l10n.booksBankCatSalariesHint,
      accountCode: '6020',
    ),
    _BankLineCategory(
      label: l10n.booksBankCatUtilities,
      hint: l10n.booksBankCatUtilitiesHint,
      accountCode: '6030',
    ),
    _BankLineCategory(
      label: l10n.booksBankCatTransport,
      hint: l10n.booksBankCatTransportHint,
      accountCode: '6040',
    ),
    _BankLineCategory(
      label: l10n.booksBankCatLoanRepayment,
      hint: l10n.booksBankCatLoanRepaymentHint,
      accountCode: '2200',
    ),
    _BankLineCategory(
      label: l10n.booksBankCatOwnerWithdrew,
      hint: l10n.booksBankCatOwnerWithdrewHint,
      accountCode: '3010',
    ),
    _BankLineCategory(
      label: l10n.booksBankCatToCash,
      hint: l10n.booksBankCatToCashHint,
      accountCode: '1010',
    ),
    _BankLineCategory(
      label: l10n.booksBankCatToMomo,
      hint: l10n.booksBankCatToMomoHint,
      accountCode: '1030',
    ),
    _BankLineCategory(
      label: l10n.booksBankCatOtherExpense,
      hint: l10n.booksBankCatOtherExpenseHint,
      accountCode: '6000',
    ),
  ];
}

/// Balanced double-entry for a bank line categorized as [categoryCode].
/// Money in → Dr Bank / Cr category; money out → Dr category / Cr Bank.
List<JournalLine> _bankAdjustmentLines(BankLine line, String categoryCode) {
  const bank = '1020';
  final amt = line.amt.abs();
  if (line.amt >= 0) {
    return [
      JournalLine(ac: bank, dr: amt),
      JournalLine(ac: categoryCode, cr: amt),
    ];
  }
  return [
    JournalLine(ac: categoryCode, dr: amt),
    JournalLine(ac: bank, cr: amt),
  ];
}

/// Lets the user categorize an unmatched bank line in plain language, then
/// posts the balanced journal entry for them and matches the line — no
/// accounting knowledge required.
Future<void> _categorizeBankLine(
  BuildContext context,
  WidgetRef ref,
  int index,
  BankLine line,
) async {
  final moneyIn = line.amt >= 0;
  final categoryIndex = await showDialog<int>(
    context: context,
    builder: (context) => _BankLineCategoryDialog(line: line),
  );
  if (categoryIndex == null || !context.mounted) return;
  final category = _bankLineCategories(
    context.flipperL10n,
    moneyIn: moneyIn,
  )[categoryIndex];
  // The memo is persisted ledger data shared by every user of the business,
  // so it is always written in English regardless of the UI language.
  final memoLabel = _bankLineCategories(
    lookupFlipperAppLocalizations(const Locale('en')),
    moneyIn: moneyIn,
  )[categoryIndex].label;

  final businessId = ref.read(accountingBusinessIdProvider);
  if (businessId.isEmpty) return;

  // Derive everything from the stable bank-line id so a retry after a partial
  // failure converges on the same documents instead of double-counting: the
  // header is upserted under a deterministic id, the ref is collision-free, and
  // the bank-line match is keyed identically.
  final bankLineId = _bankLineId(businessId, line);
  final deterministicEntryId = 'je_bankrec_$bankLineId';
  final refText =
      'ADJ-${bankLineId.replaceAll('-', '').substring(0, 10).toUpperCase()}';
  final entry = JournalEntry(
    id: refText,
    date: line.date,
    memo: '$memoLabel · ${line.desc}',
    ref: refText,
    status: JournalStatus.posted,
    src: 'Bank rec',
    lines: _bankAdjustmentLines(line, category.accountCode),
  );

  try {
    final ledger = ref.read(accountingLedgerRepositoryProvider);
    final entryId = await ledger.createJournalEntry(
      businessId: businessId,
      entry: entry,
      journalCode: 'misc',
      entryId: deterministicEntryId,
    );
    // createJournalEntry writes the header with the entry's status, but post
    // explicitly so the entry counts in balances/reports regardless of backend.
    // Both create and post are idempotent upserts on the deterministic id, so a
    // retry re-runs the whole sequence without producing duplicates.
    await ledger.postJournalEntry(businessId: businessId, entryId: entryId);
    ref.invalidate(journalEntriesStreamProvider);

    await _persistBankLineMatch(
      ref,
      index,
      line,
      entryUuid: entryId,
      entryNumber: refText,
    );

    if (!context.mounted) return;
    showAccountingToast(
      context,
      context.flipperL10n.booksEntryCreatedMatched,
      subtitle: context.flipperL10n.booksEntryCreatedMatchedDetail(
        money(line.amt.abs()),
        category.label,
        refText,
      ),
      icon: Icons.check,
      tone: AccountingToastTone.success,
    );
  } catch (e) {
    if (!context.mounted) return;
    showAccountingToast(
      context,
      context.flipperL10n.booksCouldNotCreateEntry,
      subtitle: '$e',
      icon: Icons.error_outline,
      tone: AccountingToastTone.warn,
    );
  }
}

class _BankLineCategoryDialog extends StatelessWidget {
  const _BankLineCategoryDialog({required this.line});

  final BankLine line;

  @override
  Widget build(BuildContext context) {
    final l10n = context.flipperL10n;
    final moneyIn = line.amt >= 0;
    final categories = _bankLineCategories(l10n, moneyIn: moneyIn);
    return AlertDialog(
      title: Text(
        moneyIn ? l10n.booksWhereMoneyFrom : l10n.booksWhatPaymentFor,
      ),
      content: SizedBox(
        width: 440,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AccountingTokens.surface2,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      '${line.date} · ${line.desc}',
                      style: AccountingTokens.sans(
                        fontSize: 13,
                        color: AccountingTokens.ink2,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    line.amt < 0 ? '(${money(-line.amt)})' : money(line.amt),
                    style: AccountingTokens.mono(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w700,
                      color: moneyIn
                          ? AccountingTokens.gainInk
                          : AccountingTokens.lossInk,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.booksPickClosestMatch,
              style: AccountingTokens.sans(
                fontSize: 12,
                color: AccountingTokens.ink3,
              ),
            ),
            const SizedBox(height: 8),
            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (final (i, c) in categories.indexed)
                      ListTile(
                        dense: true,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 8,
                        ),
                        title: Text(
                          c.label,
                          style: AccountingTokens.sans(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        subtitle: Text(
                          c.hint,
                          style: AccountingTokens.sans(
                            fontSize: 12,
                            color: AccountingTokens.ink3,
                          ),
                        ),
                        trailing: const Icon(Icons.chevron_right, size: 18),
                        onTap: () => Navigator.of(context).pop(i),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.cancel),
        ),
      ],
    );
  }
}

Future<BankMatchCandidate?> _pickBankMatchCandidate(
  BuildContext context,
  List<BankMatchCandidate> candidates,
  BankLine line,
) {
  return showDialog<BankMatchCandidate>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(context.flipperL10n.booksMatchBankLine),
      content: SizedBox(
        width: 420,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${line.date} · ${line.desc}',
              style: AccountingTokens.sans(
                fontSize: 13,
                color: AccountingTokens.ink3,
              ),
            ),
            const SizedBox(height: 12),
            Flexible(
              child: ListView(
                shrinkWrap: true,
                children: [
                  for (final c in candidates)
                    ListTile(
                      dense: true,
                      title: Text(
                        '${c.entry.id} · ${c.entry.date}',
                        style: AccountingTokens.mono(fontSize: 13),
                      ),
                      subtitle: Text(
                        '${c.entry.memo} · ${liquidAccountLabel(c.accountCode)}',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      onTap: () => Navigator.of(context).pop(c),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(context.flipperL10n.cancel),
        ),
      ],
    ),
  );
}

class AccountingBankRecView extends ConsumerWidget {
  const AccountingBankRecView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.flipperL10n;
    final lines = ref.watch(accountingBankLinesProvider);
    final accounts = ref.watch(accountingAccountsProvider);
    final currency = ref.watch(accountingCurrencyProvider);
    final period = ref.watch(accountingPeriodLabelProvider);
    final finished = ref.watch(bankRecFinishedProvider);
    final meta = ref.watch(bankStatementMetaProvider);
    final bankBal = accounts
        .where((a) => a.code == '1020')
        .fold<int>(0, (s, a) => s + a.bal);
    // Prefer the imported statement's closing balance; fall back to the GL.
    final statementBalance = meta?.closingBalance?.round() ?? bankBal;
    // Fall back to the chart-of-accounts name for the bank account (1020),
    // then a neutral label — never a hardcoded bank brand.
    final bankAccounts = accounts.where((a) => a.code == '1020');
    final bankAccountName = bankAccounts.isNotEmpty
        ? bankAccounts.first.name
        : '';
    final bankName =
        meta?.bankName ??
        (bankAccountName.isNotEmpty ? bankAccountName : l10n.booksBank);
    final matched = lines.where((l) => l.matched).length;
    final unmatched = lines.length - matched;
    final diff = lines
        .where((l) => !l.matched)
        .fold<int>(0, (s, l) => s + l.amt);
    final canFinish = unmatched == 0 && lines.isNotEmpty && !finished;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(28, 24, 28, 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AccountingPageHeader(
            eyebrow: l10n.booksDaybook,
            title: l10n.booksBankReconciliation,
            subtitle: l10n.booksBankRecSubtitle(bankName, currency, period),
            actions: [
              if (kDebugMode)
                AccountingButton(
                  label: 'Clear import',
                  icon: Icons.delete_outline,
                  small: true,
                  onPressed: () => _clearBankStatementImport(context, ref),
                ),
              AccountingButton(
                label: l10n.booksImportStatement,
                icon: Icons.sync,
                small: true,
                onPressed: () => _importBankStatement(context, ref),
              ),
              AccountingButton(
                label: finished
                    ? l10n.booksReconciled
                    : l10n.booksFinishReconciliation,
                icon: Icons.check,
                primary: true,
                small: true,
                enabled: canFinish || finished,
                onPressed: canFinish
                    ? () {
                        ref.read(bankRecFinishedProvider.notifier).state = true;
                        showAccountingToast(
                          context,
                          l10n.booksReconciliationComplete,
                          subtitle: l10n.booksLinesMatchedOfTotal(
                            '${lines.length}',
                            '${lines.length}',
                          ),
                          icon: Icons.verified_user_outlined,
                          tone: AccountingToastTone.success,
                        );
                      }
                    : null,
              ),
            ],
          ),
          AccountingKpiGrid(
            maxColumns: 3,
            children: [
              AccountingKpiCard(
                label: l10n.booksStatementBalance,
                value: statementBalance,
                icon: AccIcon.wallet,
                tone: KpiTone.blue,
                footnote: meta != null ? l10n.booksFromImportedStatement : null,
              ),
              AccountingKpiCard(
                label: l10n.booksMatched,
                value: matched,
                icon: AccIcon.check,
                tone: KpiTone.green,
                footnote: lines.isEmpty
                    ? l10n.booksNoLinesYet
                    : l10n.booksOfTotal('${lines.length}'),
                currencyPrefix: false,
              ),
              AccountingKpiCard(
                label: l10n.booksNeedsAttention,
                value: unmatched,
                icon: AccIcon.warn,
                tone: KpiTone.amber,
                footnote: money(diff.abs()),
              ),
            ],
          ),
          const SizedBox(height: 16),
          AccountingCard(
            child: Column(
              children: [
                AccountingCardHeader(
                  title: l10n.booksStatementLines,
                  subtitle: l10n.booksMatchEachLine,
                ),
                if (lines.isEmpty)
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text(
                      l10n.booksNoStatementLines,
                      style: AccountingTokens.sans(
                        fontSize: 13.5,
                        color: AccountingTokens.ink3,
                      ),
                    ),
                  ),
                for (var i = 0; i < lines.length; i++)
                  Builder(
                    builder: (context) {
                      final l = lines[i];
                      return Padding(
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
                                l.je ?? '—',
                                style: AccountingTokens.mono(
                                  fontSize: 12,
                                  color: AccountingTokens.accent,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const MatchedPill(),
                            ] else
                              AccountingButton(
                                label: l10n.booksMatch,
                                primary: true,
                                small: true,
                                onPressed: () =>
                                    _matchBankLine(context, ref, i, l),
                              ),
                          ],
                        ),
                      );
                    },
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AccountingTaxVatView extends ConsumerWidget {
  const AccountingTaxVatView({super.key});

  static const _netVatGradient = LinearGradient(
    begin: Alignment(-0.5, -0.8),
    end: Alignment(0.8, 1),
    colors: [Color(0xFFFFFBF2), Color(0xFFFEF3E2)],
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.flipperL10n;
    final vat = ref.watch(accountingVatProvider);
    final period = ref.watch(accountingPeriodLabelProvider);
    final ratePct = vat != null ? (vat.rate * 100).round() : 18;
    final outputVat = vat?.outputVat ?? 0;
    final inputVat = vat?.inputVat ?? 0;
    final netPayable = vat?.netPayable ?? 0;
    final totalSales = vat?.totalSalesVatInclusive ?? 0;
    final dueDate = vat?.dueDate ?? '—';

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(28, 24, 28, 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AccountingPageHeader(
            eyebrow: l10n.booksCompliance,
            title: l10n.booksTaxVat,
            subtitle: l10n.booksVatSubtitle('$ratePct', period),
            actions: [
              AccountingButton(
                label: l10n.booksFileWithRra,
                accIcon: AccIcon.shieldCheck,
                primary: true,
                small: true,
                onPressed: vat == null
                    ? null
                    : () => showAccountingToast(
                        context,
                        l10n.booksVatReturnSubmitted,
                        subtitle: l10n.booksRraAckRef('RRA-2026-05-0042'),
                        accIcon: AccIcon.shieldCheck,
                        tone: AccountingToastTone.success,
                      ),
              ),
            ],
          ),
          AccountingKpiGrid(
            maxColumns: 3,
            children: [
              AccountingKpiCard(
                label: l10n.booksOutputVatOnSales,
                value: outputVat,
                icon: AccIcon.arrowUpRight,
                tone: KpiTone.green,
              ),
              AccountingKpiCard(
                label: l10n.booksInputVatReclaimable,
                value: inputVat,
                icon: AccIcon.arrowDown,
                tone: KpiTone.blue,
              ),
              AccountingKpiCard(
                label: l10n.booksNetVatPayable,
                value: netPayable,
                icon: AccIcon.receipt,
                tone: KpiTone.amber,
                note: vat != null ? l10n.booksDueDate(dueDate) : null,
                highlightGradient: _netVatGradient,
              ),
            ],
          ),
          const SizedBox(height: 16),
          AccountingCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 18, 20, 14),
                  child: Row(
                    children: [
                      Text(
                        l10n.booksVatReturnSummary,
                        style: AccountingTokens.cardTitle,
                      ),
                      const Spacer(),
                      AccountingTag(label: l10n.booksDraft),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 6, 24, 18),
                  child: Column(
                    children: [
                      _VatStmtRow(l10n.booksTotalSalesVatInclusive, totalSales),
                      _VatStmtRow(l10n.booksOutputVatCollected, outputVat),
                      _VatStmtRow(l10n.booksInputVatOnPurchases, -inputVat),
                      _VatStmtTotal(l10n.booksNetVatDueToRra, netPayable),
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

/// Handoff `.stmt-row` — label left, mono value right.
class _VatStmtRow extends StatelessWidget {
  const _VatStmtRow(this.label, this.value);

  final String label;
  final int value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [
          Expanded(
            child: Text(
              label,
              style: AccountingTokens.sans(
                fontSize: 14,
                color: AccountingTokens.ink1,
              ),
            ),
          ),
          SizedBox(
            width: 130,
            child: Text(
              money(value),
              textAlign: TextAlign.right,
              style: AccountingTokens.mono(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Handoff `.stmt-total` — shaded footer row.
class _VatStmtTotal extends StatelessWidget {
  const _VatStmtTotal(this.label, this.value);

  final String label;
  final int value;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.fromLTRB(14, 13, 14, 13),
      decoration: BoxDecoration(
        color: AccountingTokens.surface2,
        borderRadius: BorderRadius.circular(AccountingTokens.radiusMd),
        border: Border.all(color: AccountingTokens.line),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [
          Expanded(
            child: Text(
              label,
              style: AccountingTokens.sans(
                fontSize: 15,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          SizedBox(
            width: 130,
            child: Text(
              money(value),
              textAlign: TextAlign.right,
              style: AccountingTokens.mono(
                fontSize: 19,
                fontWeight: FontWeight.w800,
              ),
            ),
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
    final l10n = context.flipperL10n;
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
            eyebrow: l10n.reports,
            title: l10n.booksFinancialStatements,
            subtitle: entityName.isNotEmpty ? '$entityName · $period' : period,
            actions: [
              AccountingButton(
                label: l10n.booksPrint,
                icon: Icons.print_outlined,
                small: true,
                onPressed: () => showAccountingToast(
                  context,
                  l10n.booksPreparingPrintLayout,
                  subtitle: '${l10n.booksFinancialStatements} · $period',
                  icon: Icons.print_outlined,
                ),
              ),
              AccountingButton(
                label: 'PDF',
                icon: Icons.picture_as_pdf_outlined,
                small: true,
                onPressed: () => showAccountingToast(
                  context,
                  l10n.booksGeneratingPdf,
                  subtitle: l10n.booksStatementPack(
                    ref.watch(accountingCurrencyProvider),
                  ),
                  icon: Icons.download_outlined,
                  tone: AccountingToastTone.success,
                ),
              ),
            ],
          ),
          Wrap(
            spacing: 6,
            children: StatementsTab.values.map((t) {
              final label = switch (t) {
                StatementsTab.income => l10n.booksIncomeStatement,
                StatementsTab.balance => l10n.booksBalanceSheet,
                StatementsTab.cashFlow => l10n.booksCashFlow,
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
                  _StmtRow(l10n.booksNetRevenue, pl.netRevenue),
                  _StmtRow(l10n.booksCogs, -pl.cogs),
                  _StmtRow(l10n.booksGrossProfit, pl.grossProfit),
                  _StmtRow(l10n.booksOperatingExpenses, -pl.totalOpex),
                  _StmtRow(
                    profitOrLossLabel(pl.netIncome),
                    pl.netIncome,
                    total: true,
                  ),
                ],
              ),
              StatementsTab.balance => _StmtBody(
                entityName: entityName,
                rows: [
                  _StmtRow(l10n.booksTotalAssets, bs.totalAssets),
                  _StmtRow(l10n.booksTotalLiabilities, bs.totalLiab),
                  _StmtRow(l10n.booksTotalEquity, bs.totalEquity),
                  _StmtRow(
                    l10n.booksLiabilitiesPlusEquity,
                    bs.totalLiabEquity,
                    total: true,
                  ),
                ],
                balanced: bs.totalAssets == bs.totalLiabEquity,
              ),
              StatementsTab.cashFlow => _StmtBody(
                entityName: entityName,
                rows: [
                  _StmtRow(l10n.booksOperatingActivities, cf.operating),
                  _StmtRow(l10n.booksInvestingActivities, cf.investing),
                  _StmtRow(l10n.booksFinancingActivities, cf.financing),
                  _StmtRow(
                    l10n.booksNetChangeInCash,
                    cf.netChange,
                    total: true,
                  ),
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
  const _StmtBody({
    required this.rows,
    this.balanced = false,
    this.entityName = '',
  });

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
          Builder(
            builder: (context) {
              final loss = r.total && r.value < 0;
              final emphasis = loss
                  ? AccountingTokens.lossInk
                  : AccountingTokens.ink1;
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      r.label,
                      style: AccountingTokens.sans(
                        fontSize: 14,
                        fontWeight: r.total ? FontWeight.w800 : FontWeight.w500,
                        color: r.total ? emphasis : AccountingTokens.ink1,
                      ),
                    ),
                    Text(
                      money(r.value),
                      style: AccountingTokens.mono(
                        fontSize: r.total ? 19 : 14,
                        fontWeight: r.total ? FontWeight.w800 : FontWeight.w600,
                        color: r.total ? emphasis : AccountingTokens.ink1,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        if (balanced)
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Text(
              context.flipperL10n.booksBalancedAssetsEqual,
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
    final l10n = context.flipperL10n;
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
            eyebrow: l10n.reports,
            title: l10n.booksTrialBalance,
            subtitle: l10n.booksAsOfPeriod(currency, period),
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
                  tb.balanced ? l10n.booksInBalance : l10n.booksOutOfBalance,
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
                      l10n.booksNoAccountsYet,
                      style: AccountingTokens.sans(
                        color: AccountingTokens.ink3,
                      ),
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
                      Expanded(
                        child: Text(
                          l10n.booksTotals,
                          style: const TextStyle(fontWeight: FontWeight.w800),
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

  static List<(AccountType, String)> _typeOrderFor(
    FlipperAppLocalizations l10n,
  ) => [
    (AccountType.asset, l10n.booksAssets),
    (AccountType.liability, l10n.booksLiabilities),
    (AccountType.equity, l10n.booksEquity),
    (AccountType.income, l10n.booksIncome),
    (AccountType.expense, l10n.booksExpenses),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.flipperL10n;
    final typeOrder = _typeOrderFor(l10n);
    final accounts = ref.watch(accountingAccountsProvider);
    final typeFilter = ref.watch(coaTypeFilterProvider);
    final filteredTypes = typeFilter == null
        ? typeOrder
        : typeOrder.where((t) => t.$1 == typeFilter).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(28, 24, 28, 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AccountingPageHeader(
            eyebrow: l10n.booksSetup,
            title: l10n.booksChartOfAccounts,
            subtitle: l10n.booksCoaSubtitle('${accounts.length}'),
            actions: [
              PopupMenuButton<AccountType?>(
                tooltip: l10n.booksFilterByType,
                offset: const Offset(0, 40),
                onSelected: (t) =>
                    ref.read(coaTypeFilterProvider.notifier).state = t,
                itemBuilder: (context) => [
                  PopupMenuItem<AccountType?>(
                    value: null,
                    child: Text(l10n.booksAllTypes),
                  ),
                  for (final (type, label) in typeOrder)
                    PopupMenuItem(value: type, child: Text(label)),
                ],
                child: AccountingButton(
                  label: typeFilter == null
                      ? l10n.booksFilter
                      : typeOrder.firstWhere((t) => t.$1 == typeFilter).$2,
                  icon: Icons.filter_list,
                  small: true,
                ),
              ),
              AccountingButton(
                label: l10n.booksAddAccount,
                icon: Icons.add,
                primary: true,
                small: true,
                onPressed: () {
                  ref.read(createAccountModalProvider.notifier).state =
                      const CreateAccountModalRequest();
                },
              ),
            ],
          ),
          AccountingCard(
            child: Column(
              children: [
                for (final (type, label) in filteredTypes) ...[
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
