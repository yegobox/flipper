import 'package:flipper_accounting/statutory_accounts.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_web/modules/accounting/data/accounting_models.dart';
import 'package:flipper_web/modules/accounting/data/accounting_providers.dart';
import 'package:flipper_web/modules/accounting/data/chart_account_resolver.dart';
import 'package:flipper_web/modules/accounting/data/expense_entry_posting.dart';
import 'package:flipper_web/modules/accounting/theme/accounting_tokens.dart';
import 'package:flipper_web/modules/accounting/widgets/accounting_page_header.dart';
import 'package:flipper_web/modules/accounting/widgets/create_account_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:intl/intl.dart';

/// Sentinel value for the "add expense account" dropdown option.
const _addExpenseAccountValue = '__add_expense_account__';

/// Dropdown values for payments to RRA and RSSB (not expense account codes).
const _statutoryValues = {
  '__pay_vat__': StatutoryPayment.vat,
  '__pay_paye__': StatutoryPayment.paye,
  '__pay_rssb__': StatutoryPayment.rssb,
};

/// The dropdown value for [p].
/// Upper bound for showing what is owed (a negative balance shows as 0).
const _owedCap = 1 << 52;

/// What [statutoryOwed] reads: the chart's opening balances, every entry up
/// to today and every entry waiting for approval.
typedef _OwedLedger = ({
  List<Account> chart,
  List<JournalEntry> throughToday,
  List<JournalEntry> pending,
});

/// For choices that never split by what is owed (expenses and VAT).
const _OwedLedger _noLedger = (chart: [], throughToday: [], pending: []);

String _statutoryValue(StatutoryPayment p) =>
    _statutoryValues.entries.firstWhere((e) => e.value == p).key;

final expenseUiProvider = StateProvider<bool>((ref) => false);

class ExpenseEntryPanel extends ConsumerStatefulWidget {
  const ExpenseEntryPanel({super.key, required this.onClose});

  final VoidCallback onClose;

  @override
  ConsumerState<ExpenseEntryPanel> createState() => _ExpenseEntryPanelState();
}

class _ExpenseEntryPanelState extends ConsumerState<ExpenseEntryPanel> {
  static String _nextEntryRef() {
    final n = DateTime.now().microsecondsSinceEpoch % 10000;
    return 'Auto · JE-${1000 + n}';
  }

  late final String _dateLabel;
  late final TextEditingController _memoCtrl;
  late final TextEditingController _amountCtrl;
  String? _expenseCode;
  ExpensePaymentMethod _paymentMethod = ExpensePaymentMethod.cash;
  bool _submitted = false;
  bool _defaultCategorySet = false;
  bool _isSubmitting = false;

  /// The memo this panel filled in for a tax or RSSB payment; replaced when
  /// the choice changes, but never once the user typed their own.
  String? _autoMemo;

  @override
  void initState() {
    super.initState();
    _dateLabel = DateFormat('d MMM y').format(DateTime.now());
    _memoCtrl = TextEditingController();
    _amountCtrl = TextEditingController();
  }

  @override
  void dispose() {
    _memoCtrl.dispose();
    _amountCtrl.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_defaultCategorySet) return;
    final accounts = ref.read(accountingAccountsProvider);
    if (accounts.isEmpty) return;
    _defaultCategorySet = true;
    final roles = ChartAccountResolver(accounts);
    _expenseCode ??=
        roles.operatingExpense ?? roles.expenseCategories.firstOrNull?.code;
  }

  int get _amount =>
      int.tryParse(_amountCtrl.text.replaceAll(RegExp(r'[^\d]'), '')) ?? 0;

  bool get _canSubmit =>
      _amount > 0 &&
      _expenseCode != null &&
      _expenseCode!.isNotEmpty &&
      _choiceAvailable;

  /// False when VAT is picked but the business turned out not to be
  /// registered for VAT (the choice is no longer offered).
  bool get _choiceAvailable =>
      _statutory != StatutoryPayment.vat ||
      ref.read(booksVatPositionProvider).value?.registered != false;

  /// The tax or RSSB payment picked, or null for an ordinary expense.
  StatutoryPayment? get _statutory => _statutoryValues[_expenseCode];

  /// PAYE and RSSB split by what is owed; VAT and expenses do not.
  bool get _needsOwed =>
      _statutory != null && _statutory != StatutoryPayment.vat;

  /// What is owed on the liability [payment] settles, as of today and net of
  /// payments still waiting for approval (see [statutoryOwed]). The preview
  /// and the submitted entry both use it, so they always split the same way.
  static int _owed(
    _OwedLedger ledger,
    ChartAccountResolver roles,
    StatutoryPayment payment,
  ) => statutoryOwed(
    chart: ledger.chart,
    throughPaymentDate: ledger.throughToday,
    pending: ledger.pending,
    liabilityCode: statutoryLiabilityCode(roles, payment),
  );

  /// The ledger [_owed] needs, once both reads have loaded.
  Future<_OwedLedger> _readLedger() async => (
    chart: ref.read(accountingCoaProvider),
    throughToday: await ref.read(journalEntriesThroughTodayProvider.future),
    pending: await ref.read(pendingJournalEntriesProvider.future),
  );

  List<JournalLine> _lines(List<Account> accounts, _OwedLedger ledger) {
    final roles = ChartAccountResolver(accounts);
    final fundingCode = fundingCodeForPaymentMethod(roles, _paymentMethod);
    final statutory = _statutory;
    if (statutory == null) {
      return buildExpenseJournalLines(
        expenseCode: _expenseCode!,
        fundingCode: fundingCode,
        amount: _amount,
      );
    }
    return buildStatutoryPaymentLines(
      payment: statutory,
      roles: roles,
      fundingCode: fundingCode,
      amount: _amount,
      owed: _owed(ledger, roles, statutory),
    );
  }

  String _statutoryLabel(StatutoryPayment p) {
    final l10n = context.flipperL10n;
    return switch (p) {
      StatutoryPayment.vat => l10n.booksPayVatRra,
      StatutoryPayment.paye => l10n.booksPayPayeRra,
      StatutoryPayment.rssb => l10n.booksPayRssb,
    };
  }

  void _select(String? value) {
    setState(() {
      _expenseCode = value;
      final statutory = _statutory;
      final memo = _memoCtrl.text.trim();
      if (memo.isNotEmpty && memo != _autoMemo) return;
      _autoMemo = statutory == null ? null : _statutoryLabel(statutory);
      _memoCtrl.text = _autoMemo ?? '';
    });
  }

  void _openAddExpenseAccount() {
    final accounts = ref.read(accountingAccountsProvider);
    ref
        .read(createAccountModalProvider.notifier)
        .state = CreateAccountModalRequest(
      lockType: AccountType.expense,
      suggestedCode: suggestNextExpenseCode(accounts),
      onCreated: (account) => setState(() => _expenseCode = account.code),
    );
  }

  Future<void> _submit() async {
    if (!_canSubmit || _isSubmitting) return;
    final businessId = ref.read(accountingBusinessIdProvider);
    if (businessId.isEmpty) return;

    setState(() => _isSubmitting = true);

    final accounts = ref.read(accountingAccountsProvider);
    final refText = _nextEntryRef();
    final statutory = _statutory;
    final memo = _memoCtrl.text.trim().isNotEmpty
        ? _memoCtrl.text.trim()
        : statutory != null
        ? _statutoryLabel(statutory)
        : 'Expense payment';

    try {
      final lines = _lines(
        accounts,
        _needsOwed ? await _readLedger() : _noLedger,
      );
      final entry = JournalEntry(
        id: refText,
        date: _dateLabel,
        memo: memo,
        ref: refText,
        status: JournalStatus.pending,
        src: 'Manual',
        lines: lines,
      );
      final repo = ref.read(accountingLedgerRepositoryProvider);
      // A chart seeded before PAYE / RSSB Payable existed gets them now, so
      // no leg of the entry points at a missing account.
      await ensureChartAccounts(
        repo,
        businessId: businessId,
        codes: lines.map((l) => l.ac),
        existingCodes: {for (final a in accounts) a.code},
      );
      await repo.createJournalEntry(
        businessId: businessId,
        entry: entry,
        journalCode: 'misc',
      );

      if (mounted) {
        setState(() {
          _isSubmitting = false;
          _submitted = true;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final reduceMotion = MediaQuery.disableAnimationsOf(context);

    return Stack(
      children: [
        GestureDetector(
          onTap: widget.onClose,
          child: Container(color: const Color(0x8C081216)),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: Material(
            elevation: 0,
            shadowColor: const Color(0x80080C16),
            child: AnimatedContainer(
              duration: reduceMotion
                  ? Duration.zero
                  : const Duration(milliseconds: 320),
              curve: const Cubic(0.22, 0.9, 0.3, 1),
              width: AccountingTokens.composerWidth.clamp(
                320,
                MediaQuery.sizeOf(context).width,
              ),
              height: double.infinity,
              decoration: const BoxDecoration(
                color: AccountingTokens.surface,
                boxShadow: [
                  BoxShadow(
                    color: Color(0x80080C16),
                    blurRadius: 60,
                    offset: Offset(-24, 0),
                    spreadRadius: -20,
                  ),
                ],
              ),
              child: _submitted ? _buildSuccess() : _buildForm(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSuccess() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 84,
              height: 84,
              decoration: BoxDecoration(
                color: AccountingTokens.gain,
                borderRadius: BorderRadius.circular(26),
                boxShadow: [
                  BoxShadow(
                    color: AccountingTokens.gain.withValues(alpha: 0.5),
                    blurRadius: 40,
                    offset: const Offset(0, 18),
                  ),
                ],
              ),
              child: const Icon(Icons.check, color: Colors.white, size: 40),
            ),
            const SizedBox(height: 20),
            Text(
              context.flipperL10n.booksSubmittedForApproval,
              style: AccountingTokens.sans(
                fontSize: 23,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.02 * 23,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              context.flipperL10n.booksSubmittedForApprovalBody,
              style: AccountingTokens.sans(
                fontSize: 14,
                color: AccountingTokens.ink3,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            AccountingButton(
              label: context.flipperL10n.done,
              primary: true,
              onPressed: widget.onClose,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildForm() {
    final l10n = context.flipperL10n;
    final accounts = ref.watch(accountingAccountsProvider);
    final roles = ChartAccountResolver(accounts);
    final categories = roles.expenseCategories;
    final currency = ref.watch(accountingCurrencyProvider);
    // Only a business known not to be VAT-registered loses the VAT choice;
    // an unknown position keeps it, as bills keep booking VAT to 2100.
    final vatRegistered =
        ref.watch(booksVatPositionProvider).value?.registered != false;
    // VAT picked while the position was still loading, and the business
    // turns out not to be registered: drop the choice, so no VAT entry is
    // built from a choice the dropdown no longer offers.
    ref.listen(booksVatPositionProvider, (_, next) {
      if (next.value?.registered == false &&
          _statutory == StatutoryPayment.vat) {
        _select(null);
      }
    });
    final _OwedLedger ledger = _needsOwed
        ? (
            chart: ref.watch(accountingCoaProvider),
            throughToday:
                ref.watch(journalEntriesThroughTodayProvider).value ?? const [],
            pending: ref.watch(pendingJournalEntriesProvider).value ?? const [],
          )
        : _noLedger;
    final statutoryChoices = [
      if (vatRegistered) StatutoryPayment.vat,
      StatutoryPayment.paye,
      StatutoryPayment.rssb,
    ];
    final statutory = _statutory;
    final owed = statutory == null
        ? 0
        : _owed(ledger, roles, statutory).clamp(0, _owedCap);
    final previewLines = _canSubmit
        ? _lines(accounts, ledger)
        : const <JournalLine>[];

    final dropdownValue =
        _expenseCode != null &&
            (categories.any((a) => a.code == _expenseCode) ||
                accounts.any((a) => a.code == _expenseCode) ||
                (statutory != null && statutoryChoices.contains(statutory)))
        ? _expenseCode
        : null;

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(24, 20, 16, 20),
          decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: AccountingTokens.line)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.booksRecordExpense,
                      style: AccountingTokens.sans(
                        fontSize: 19,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.02 * 19,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      l10n.booksRecordExpenseSubtitle,
                      style: AccountingTokens.sans(
                        fontSize: 13,
                        color: AccountingTokens.ink3,
                      ),
                    ),
                  ],
                ),
              ),
              Material(
                color: AccountingTokens.surface2,
                borderRadius: BorderRadius.circular(10),
                child: InkWell(
                  onTap: widget.onClose,
                  borderRadius: BorderRadius.circular(10),
                  child: const SizedBox(
                    width: 38,
                    height: 38,
                    child: Icon(
                      Icons.close,
                      size: 18,
                      color: AccountingTokens.ink2,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.sortCompactDate, style: _fieldLabel),
                const SizedBox(height: 7),
                Container(
                  height: 46,
                  padding: const EdgeInsets.symmetric(horizontal: 13),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(11),
                    border: Border.all(
                      color: AccountingTokens.line,
                      width: 1.5,
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.calendar_today_outlined,
                        size: 17,
                        color: AccountingTokens.ink3,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        _dateLabel,
                        style: AccountingTokens.sans(fontSize: 14.5),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Text(l10n.booksExpenseCategory, style: _fieldLabel),
                const SizedBox(height: 7),
                DropdownButtonFormField<String>(
                  key: ValueKey(_expenseCode),
                  initialValue: dropdownValue,
                  isExpanded: true,
                  decoration: _inputDecoration(icon: Icons.category_outlined),
                  items: [
                    for (final a in categories)
                      DropdownMenuItem(
                        value: a.code,
                        child: Text(
                          '${a.code} · ${a.name}',
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    DropdownMenuItem(
                      value: _addExpenseAccountValue,
                      child: Text(l10n.booksAddExpenseAccount),
                    ),
                    DropdownMenuItem(
                      enabled: false,
                      child: Text(
                        l10n.booksTaxesAndRssb.toUpperCase(),
                        style: AccountingTokens.sans(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w700,
                          color: AccountingTokens.ink3,
                          letterSpacing: 0.06 * 11.5,
                        ),
                      ),
                    ),
                    for (final p in statutoryChoices)
                      DropdownMenuItem(
                        value: _statutoryValue(p),
                        child: Text(
                          _statutoryLabel(p),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                  ],
                  onChanged: (v) {
                    if (v == _addExpenseAccountValue) {
                      _openAddExpenseAccount();
                      return;
                    }
                    _select(v);
                  },
                ),
                if (statutory != null) ...[
                  const SizedBox(height: 7),
                  Text(
                    statutory == StatutoryPayment.vat
                        ? l10n.booksPayVatHint
                        : l10n.booksPayStatutoryHint(
                            '$currency ${NumberFormat('#,###').format(owed)}',
                          ),
                    style: AccountingTokens.sans(
                      fontSize: 12.5,
                      color: AccountingTokens.ink3,
                    ),
                  ),
                ],
                const SizedBox(height: 16),
                Text(l10n.amount, style: _fieldLabel),
                const SizedBox(height: 7),
                TextField(
                  controller: _amountCtrl,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: _inputDecoration(
                    icon: Icons.payments_outlined,
                    prefix: '$currency ',
                  ),
                  onChanged: (_) => setState(() {}),
                ),
                const SizedBox(height: 16),
                Text(l10n.booksPaidVia, style: _fieldLabel),
                const SizedBox(height: 7),
                SegmentedButton<ExpensePaymentMethod>(
                  segments: [
                    ButtonSegment(
                      value: ExpensePaymentMethod.cash,
                      label: Text(l10n.cash),
                      icon: const Icon(Icons.payments_outlined, size: 16),
                    ),
                    ButtonSegment(
                      value: ExpensePaymentMethod.bank,
                      label: Text(l10n.booksBank),
                      icon: const Icon(
                        Icons.account_balance_outlined,
                        size: 16,
                      ),
                    ),
                    const ButtonSegment(
                      value: ExpensePaymentMethod.momo,
                      label: Text('MoMo'),
                      icon: Icon(Icons.phone_android_outlined, size: 16),
                    ),
                  ],
                  selected: {_paymentMethod},
                  onSelectionChanged: (s) =>
                      setState(() => _paymentMethod = s.first),
                ),
                const SizedBox(height: 16),
                Text(l10n.booksMemoDescription, style: _fieldLabel),
                const SizedBox(height: 7),
                TextField(
                  controller: _memoCtrl,
                  decoration: _inputDecoration(
                    icon: Icons.receipt_long_outlined,
                    hint: l10n.booksExpenseMemoHint,
                  ),
                ),
                if (_canSubmit) ...[
                  const SizedBox(height: 20),
                  _PostPreview(
                    lines: previewLines,
                    amount: _amount,
                    accountMap: {
                      for (final a in accounts) a.code: a,
                      // Accounts the chart gets when this entry is submitted.
                      for (final l in previewLines)
                        if (!accounts.any((a) => a.code == l.ac))
                          if (seedAccount(l.ac) case final seeded?)
                            l.ac: seeded,
                    },
                    currency: currency,
                  ),
                ],
              ],
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
          decoration: const BoxDecoration(
            border: Border(top: BorderSide(color: AccountingTokens.line)),
          ),
          child: Row(
            children: [
              Expanded(
                child: AccountingButton(
                  label: l10n.cancel,
                  onPressed: _isSubmitting ? null : widget.onClose,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: AccountingButton(
                  label: l10n.booksSubmitForApproval,
                  icon: Icons.check,
                  primary: true,
                  enabled: _canSubmit,
                  isLoading: _isSubmitting,
                  onPressed: _canSubmit && !_isSubmitting ? _submit : null,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  static InputDecoration _inputDecoration({
    IconData? icon,
    String? hint,
    String? prefix,
  }) {
    return InputDecoration(
      hintText: hint,
      prefixText: prefix,
      prefixIcon: icon != null ? Icon(icon, size: 18) : null,
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 13, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(11),
        borderSide: const BorderSide(color: AccountingTokens.line, width: 1.5),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(11),
        borderSide: const BorderSide(color: AccountingTokens.line, width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(11),
        borderSide: const BorderSide(
          color: AccountingTokens.accent,
          width: 1.5,
        ),
      ),
    );
  }
}

final _fieldLabel = AccountingTokens.sans(
  fontSize: 12.5,
  fontWeight: FontWeight.w700,
  color: AccountingTokens.ink2,
);

class _PostPreview extends StatelessWidget {
  const _PostPreview({
    required this.lines,
    required this.amount,
    required this.accountMap,
    required this.currency,
  });

  final List<JournalLine> lines;
  final int amount;
  final Map<String, Account> accountMap;
  final String currency;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AccountingTokens.gainTint,
        borderRadius: BorderRadius.circular(AccountingTokens.radiusMd),
        border: Border.all(color: const Color(0xFFBFE8CF)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.flipperL10n.booksJournalPreview,
            style: AccountingTokens.sans(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: AccountingTokens.ink3,
            ),
          ),
          const SizedBox(height: 8),
          for (final line in lines)
            _PreviewLine(
              side: line.dr > 0
                  ? context.flipperL10n.booksDrShort
                  : context.flipperL10n.booksCrShort,
              name: accountMap[line.ac]?.name ?? line.ac,
              amount: line.dr > 0 ? line.dr : line.cr,
              isDebit: line.dr > 0,
            ),
          const SizedBox(height: 6),
          Text(
            context.flipperL10n.booksBalancedAmount(
              '$currency ${NumberFormat('#,###').format(amount)}',
            ),
            style: AccountingTokens.sans(
              fontSize: 12,
              color: AccountingTokens.gainInk,
            ),
          ),
        ],
      ),
    );
  }
}

class _PreviewLine extends StatelessWidget {
  const _PreviewLine({
    required this.side,
    required this.name,
    required this.amount,
    required this.isDebit,
  });

  final String side;
  final String name;
  final int amount;
  final bool isDebit;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Text(
            side,
            style: AccountingTokens.mono(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: isDebit ? AccountingTokens.drInk : AccountingTokens.crInk,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(name, style: AccountingTokens.sans(fontSize: 13)),
          ),
          Text(
            NumberFormat('#,###').format(amount),
            style: AccountingTokens.mono(fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}

/// Slide-in expense panel host for the desktop shell.
class AccountingExpensePanelHost extends ConsumerWidget {
  const AccountingExpensePanelHost({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final open = ref.watch(expenseUiProvider);
    if (!open) return const SizedBox.shrink();

    return ExpenseEntryPanel(
      onClose: () => ref.read(expenseUiProvider.notifier).state = false,
    );
  }
}
