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
    _expenseCode ??= roles.operatingExpense ?? roles.expenseCategories.firstOrNull?.code;
  }

  int get _amount => int.tryParse(_amountCtrl.text.replaceAll(RegExp(r'[^\d]'), '')) ?? 0;

  bool get _canSubmit =>
      _amount > 0 && _expenseCode != null && _expenseCode!.isNotEmpty;

  void _openAddExpenseAccount() {
    final accounts = ref.read(accountingAccountsProvider);
    ref.read(createAccountModalProvider.notifier).state = CreateAccountModalRequest(
      lockType: AccountType.expense,
      suggestedCode: suggestNextExpenseCode(accounts),
      onCreated: (account) => setState(() => _expenseCode = account.code),
    );
  }

  Future<void> _submit() async {
    if (!_canSubmit) return;
    final businessId = ref.read(accountingBusinessIdProvider);
    if (businessId.isEmpty) return;

    final accounts = ref.read(accountingAccountsProvider);
    final roles = ChartAccountResolver(accounts);
    final fundingCode = fundingCodeForPaymentMethod(roles, _paymentMethod);
    final refText = _nextEntryRef();
    final memo = _memoCtrl.text.trim().isEmpty
        ? 'Expense payment'
        : _memoCtrl.text.trim();

    final entry = JournalEntry(
      id: refText,
      date: _dateLabel,
      memo: memo,
      ref: refText,
      status: JournalStatus.pending,
      src: 'Manual',
      lines: buildExpenseJournalLines(
        expenseCode: _expenseCode!,
        fundingCode: fundingCode,
        amount: _amount,
      ),
    );

    await ref.read(accountingLedgerRepositoryProvider).createJournalEntry(
          businessId: businessId,
          entry: entry,
          journalCode: 'misc',
        );

    if (mounted) setState(() => _submitted = true);
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
              'Submitted for approval',
              style: AccountingTokens.sans(
                fontSize: 23,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.02 * 23,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Debits equal credits. Review and approve from the Approvals tab to post to the ledger.',
              style: AccountingTokens.sans(
                fontSize: 14,
                color: AccountingTokens.ink3,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            AccountingButton(
              label: 'Done',
              primary: true,
              onPressed: widget.onClose,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildForm() {
    final accounts = ref.watch(accountingAccountsProvider);
    final roles = ChartAccountResolver(accounts);
    final categories = roles.expenseCategories;
    final currency = ref.watch(accountingCurrencyProvider);

    final dropdownValue = _expenseCode != null &&
            (categories.any((a) => a.code == _expenseCode) ||
                accounts.any((a) => a.code == _expenseCode))
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
                      'Record expense',
                      style: AccountingTokens.sans(
                        fontSize: 19,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.02 * 19,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      'Pick a category and how you paid — Flipper posts a balanced entry.',
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
                Text('Date', style: _fieldLabel),
                const SizedBox(height: 7),
                Container(
                  height: 46,
                  padding: const EdgeInsets.symmetric(horizontal: 13),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(11),
                    border: Border.all(color: AccountingTokens.line, width: 1.5),
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
                Text('Expense category', style: _fieldLabel),
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
                    const DropdownMenuItem(
                      value: _addExpenseAccountValue,
                      child: Text('+ Add expense account'),
                    ),
                  ],
                  onChanged: (v) {
                    if (v == _addExpenseAccountValue) {
                      _openAddExpenseAccount();
                      return;
                    }
                    setState(() => _expenseCode = v);
                  },
                ),
                const SizedBox(height: 16),
                Text('Amount', style: _fieldLabel),
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
                Text('Paid via', style: _fieldLabel),
                const SizedBox(height: 7),
                SegmentedButton<ExpensePaymentMethod>(
                  segments: const [
                    ButtonSegment(
                      value: ExpensePaymentMethod.cash,
                      label: Text('Cash'),
                      icon: Icon(Icons.payments_outlined, size: 16),
                    ),
                    ButtonSegment(
                      value: ExpensePaymentMethod.bank,
                      label: Text('Bank'),
                      icon: Icon(Icons.account_balance_outlined, size: 16),
                    ),
                    ButtonSegment(
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
                Text('Memo / description', style: _fieldLabel),
                const SizedBox(height: 7),
                TextField(
                  controller: _memoCtrl,
                  decoration: _inputDecoration(
                    icon: Icons.receipt_long_outlined,
                    hint: 'What was this expense for?',
                  ),
                ),
                if (_canSubmit) ...[
                  const SizedBox(height: 20),
                  _PostPreview(
                    expenseCode: _expenseCode!,
                    fundingCode: fundingCodeForPaymentMethod(roles, _paymentMethod),
                    amount: _amount,
                    accountMap: {for (final a in accounts) a.code: a},
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
                child: AccountingButton(label: 'Cancel', onPressed: widget.onClose),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: AccountingButton(
                  label: 'Submit for approval',
                  icon: Icons.check,
                  primary: true,
                  enabled: _canSubmit,
                  onPressed: _canSubmit ? _submit : null,
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
        borderSide: const BorderSide(color: AccountingTokens.accent, width: 1.5),
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
    required this.expenseCode,
    required this.fundingCode,
    required this.amount,
    required this.accountMap,
    required this.currency,
  });

  final String expenseCode;
  final String fundingCode;
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
            'Journal preview',
            style: AccountingTokens.sans(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: AccountingTokens.ink3,
            ),
          ),
          const SizedBox(height: 8),
          _PreviewLine(
            side: 'Dr',
            name: accountMap[expenseCode]?.name ?? expenseCode,
            amount: amount,
            isDebit: true,
          ),
          _PreviewLine(
            side: 'Cr',
            name: accountMap[fundingCode]?.name ?? fundingCode,
            amount: amount,
            isDebit: false,
          ),
          const SizedBox(height: 6),
          Text(
            'Balanced · $currency ${NumberFormat('#,###').format(amount)}',
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
