import 'package:flipper_web/modules/accounting/data/accounting_models.dart';
import 'package:flipper_web/modules/accounting/data/accounting_providers.dart';
import 'package:flipper_web/modules/accounting/data/expense_entry_posting.dart';
import 'package:flipper_web/modules/accounting/theme/accounting_tokens.dart';
import 'package:flipper_web/modules/accounting/widgets/accounting_page_header.dart';
import 'package:flipper_web/modules/accounting/widgets/accounting_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

/// Opens the create-account modal; [lockType] hides the type picker when set.
class CreateAccountModalRequest {
  const CreateAccountModalRequest({
    this.lockType,
    this.suggestedCode,
    this.onCreated,
  });

  final AccountType? lockType;
  final String? suggestedCode;
  final void Function(Account account)? onCreated;
}

final createAccountModalProvider =
    StateProvider<CreateAccountModalRequest?>((ref) => null);

/// Shell-level host that renders [CreateAccountModal] when requested.
class CreateAccountModalHost extends ConsumerWidget {
  const CreateAccountModalHost({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final request = ref.watch(createAccountModalProvider);
    if (request == null) return const SizedBox.shrink();

    return CreateAccountModal(
      lockType: request.lockType,
      suggestedCode: request.suggestedCode,
      onClose: () => ref.read(createAccountModalProvider.notifier).state = null,
      onCreated: (account) {
        request.onCreated?.call(account);
        ref.read(createAccountModalProvider.notifier).state = null;
      },
    );
  }
}

class CreateAccountModal extends ConsumerStatefulWidget {
  const CreateAccountModal({
    super.key,
    required this.onClose,
    required this.onCreated,
    this.lockType,
    this.suggestedCode,
  });

  final VoidCallback onClose;
  final ValueChanged<Account> onCreated;
  final AccountType? lockType;
  final String? suggestedCode;

  @override
  ConsumerState<CreateAccountModal> createState() => _CreateAccountModalState();
}

class _CreateAccountModalState extends ConsumerState<CreateAccountModal> {
  static const _types = [
    (AccountType.asset, 'Asset'),
    (AccountType.liability, 'Liability'),
    (AccountType.equity, 'Equity'),
    (AccountType.income, 'Income'),
    (AccountType.expense, 'Expense'),
  ];

  late AccountType _type;
  late final TextEditingController _codeCtrl;
  late final TextEditingController _subCtrl;
  late final TextEditingController _nameCtrl;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _type = widget.lockType ?? AccountType.expense;
    _codeCtrl = TextEditingController(text: widget.suggestedCode ?? '');
    _subCtrl = TextEditingController(
      text: _type == AccountType.expense
          ? defaultExpenseSubcategory
          : 'Current assets',
    );
    _nameCtrl = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_codeCtrl.text.isEmpty) {
      final accounts = ref.read(accountingAccountsProvider);
      _codeCtrl.text = suggestNextExpenseCode(accounts);
    }
  }

  @override
  void dispose() {
    _codeCtrl.dispose();
    _subCtrl.dispose();
    _nameCtrl.dispose();
    super.dispose();
  }

  bool get _valid {
    final code = _codeCtrl.text.trim();
    final name = _nameCtrl.text.trim();
    return code.length == 4 && RegExp(r'^\d{4}$').hasMatch(code) && name.isNotEmpty;
  }

  AccountNormal _defaultNormal(AccountType type) {
    return switch (type) {
      AccountType.asset || AccountType.expense => AccountNormal.debit,
      AccountType.liability ||
      AccountType.equity ||
      AccountType.income =>
        AccountNormal.credit,
    };
  }

  Future<void> _save() async {
    if (!_valid || _saving) return;
    final businessId = ref.read(accountingBusinessIdProvider);
    if (businessId.isEmpty) return;

    final code = _codeCtrl.text.trim();
    final name = _nameCtrl.text.trim();
    final accounts = ref.read(accountingAccountsProvider);
    if (accounts.any((a) => a.code == code)) {
      if (mounted) {
        showAccountingToast(
          context,
          'Code already in use',
          subtitle: 'Pick a different account code',
          icon: Icons.warning_amber_rounded,
          tone: AccountingToastTone.warn,
        );
      }
      return;
    }

    setState(() => _saving = true);
    final account = Account(
      code: code,
      name: name,
      type: _type,
      sub: _subCtrl.text.trim().isEmpty ? defaultExpenseSubcategory : _subCtrl.text.trim(),
      normal: _defaultNormal(_type),
      bal: 0,
    );

    try {
      await ref
          .read(accountingLedgerRepositoryProvider)
          .createChartOfAccount(businessId: businessId, account: account);
      if (mounted) {
        showAccountingToast(
          context,
          'Account created',
          subtitle: '$code · $name',
          icon: Icons.check,
          tone: AccountingToastTone.success,
        );
        widget.onCreated(account);
      }
    } on StateError catch (e) {
      if (mounted) {
        showAccountingToast(
          context,
          'Could not create account',
          subtitle: e.message,
          icon: Icons.warning_amber_rounded,
          tone: AccountingToastTone.warn,
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final lockType = widget.lockType != null;

    return Stack(
      children: [
        GestureDetector(
          onTap: widget.onClose,
          child: Container(color: const Color(0x8C081216)),
        ),
        Center(
          child: Material(
            color: AccountingTokens.surface,
            elevation: 24,
            shadowColor: const Color(0x400B1220),
            borderRadius: BorderRadius.circular(AccountingTokens.radiusLg),
            clipBehavior: Clip.antiAlias,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 20, 16, 16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'New account',
                                style: AccountingTokens.sans(
                                  fontSize: 19,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Add a line to the chart of accounts',
                                style: AccountingTokens.sans(
                                  fontSize: 13,
                                  color: AccountingTokens.ink3,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: widget.onClose,
                          icon: const Icon(Icons.close, size: 18),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (!lockType) ...[
                          Text('Account type', style: _label),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 6,
                            runSpacing: 6,
                            children: [
                              for (final (type, label) in _types)
                                ChoiceChip(
                                  label: Text(label),
                                  selected: _type == type,
                                  onSelected: (_) => setState(() {
                                    _type = type;
                                    if (type == AccountType.expense &&
                                        _subCtrl.text == 'Current assets') {
                                      _subCtrl.text = defaultExpenseSubcategory;
                                    }
                                  }),
                                ),
                            ],
                          ),
                          const SizedBox(height: 16),
                        ],
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Code', style: _label),
                                  const SizedBox(height: 7),
                                  TextField(
                                    controller: _codeCtrl,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                      LengthLimitingTextInputFormatter(4),
                                    ],
                                    decoration: _inputDecoration(hint: 'e.g. 6060'),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Category', style: _label),
                                  const SizedBox(height: 7),
                                  TextField(
                                    controller: _subCtrl,
                                    decoration: _inputDecoration(
                                      hint: 'e.g. Operating expenses',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text('Account name', style: _label),
                        const SizedBox(height: 7),
                        TextField(
                          controller: _nameCtrl,
                          autofocus: true,
                          decoration: _inputDecoration(hint: 'e.g. Office supplies'),
                          onSubmitted: (_) => _save(),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(24, 14, 24, 20),
                    decoration: const BoxDecoration(
                      border: Border(top: BorderSide(color: AccountingTokens.line)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        AccountingButton(label: 'Cancel', onPressed: widget.onClose),
                        const SizedBox(width: 10),
                        AccountingButton(
                          label: _saving ? 'Creating…' : 'Create account',
                          icon: Icons.add,
                          primary: true,
                          enabled: _valid && !_saving,
                          onPressed: _valid && !_saving ? _save : null,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  static final _label = AccountingTokens.sans(
    fontSize: 12.5,
    fontWeight: FontWeight.w700,
    color: AccountingTokens.ink2,
  );

  static InputDecoration _inputDecoration({String? hint}) {
    return InputDecoration(
      hintText: hint,
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
