part of 'sms_review_section.dart';

/// What an action left behind: the snackbar text, and how to take it back.
typedef _Outcome = ({String message, Future<void> Function()? undo});

/// One SMS: who and when, then what the money is. Add it to the Cash Book
/// under a category, record it as a transfer between own accounts, or
/// ignore it. Transfer and Ignore can be undone from the snackbar.
class SmsReviewDetail extends ConsumerStatefulWidget {
  const SmsReviewDetail({super.key, required this.item, this.messenger});

  final SmsReviewItem item;

  /// Where the result snackbar goes once this sheet closes: the queue's own
  /// messenger. Defaults to the nearest one.
  final ScaffoldMessengerState? messenger;

  @override
  ConsumerState<SmsReviewDetail> createState() => _SmsReviewDetailState();
}

class _SmsReviewDetailState extends ConsumerState<SmsReviewDetail> {
  SmsCategoryChoice? _category;

  /// Personal mode: the loan a "Loan repayment" SMS pays down.
  String? _loanId;

  /// The Cash Book transaction this SMS was already confirmed as, when the
  /// repayment write after it failed: a retry records only the repayment.
  String? _confirmedTxn;
  bool _initialApplied = false;
  bool _moreOpen = false;
  bool _transferOpen = false;
  String? _target;
  bool _busy = false;

  SmsReviewItem get item => widget.item;

  /// Pre-selects the connector's suggestion ("Bank charges" for a fee), else
  /// the category last used for this direction.
  void _applyInitial(SmsCategoryChoices choices) {
    if (_initialApplied) return;
    _initialApplied = true;
    final all = [...choices.suggested, ...choices.more];
    final wanted = item.suggestedCategory?.toLowerCase().trim();
    if (wanted != null && wanted.isNotEmpty) {
      _category = all.where((c) => c.name.toLowerCase() == wanted).firstOrNull;
      if (_category != null) return;
    }
    final last = ref
        .read(smsCategoryStoreProvider)
        .lastUsed(isIncome: item.isIncome);
    if (last != null) _category = all.where((c) => c.id == last).firstOrNull;
  }

  Future<void> _run(Future<_Outcome> Function() action) async {
    final l10n = context.flipperL10n;
    final messenger = widget.messenger ?? ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    // Captured before the await: the sheet may be dismissed meanwhile, and
    // the Cash Book list must still refresh.
    final container = ProviderScope.containerOf(context, listen: false);
    setState(() => _busy = true);
    try {
      final outcome = await action();
      container.invalidate(cashbookRecentTransactionsProvider);
      // Once the sheet is gone, popping would close the screen beneath it.
      if (mounted) navigator.pop();
      final undo = outcome.undo;
      messenger.showSnackBar(
        SnackBar(
          content: Text(outcome.message),
          duration: const Duration(seconds: 6),
          persist: false,
          action: undo == null
              ? null
              : SnackBarAction(
                  key: const Key('sms_review_undo'),
                  label: l10n.smsReviewUndo,
                  onPressed: () async {
                    try {
                      await undo();
                      container.invalidate(cashbookRecentTransactionsProvider);
                      messenger.showSnackBar(
                        SnackBar(content: Text(l10n.smsReviewUndone)),
                      );
                    } catch (e) {
                      messenger.showSnackBar(
                        SnackBar(
                          content: Text(l10n.smsReviewFailed(e.toString())),
                        ),
                      );
                    }
                  },
                ),
        ),
      );
    } catch (e) {
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.smsReviewFailed(e.toString()))),
      );
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _newCategory(List<SmsCategoryChoice> existing) async {
    String? typed;
    final id = await showCashbookNewCategorySheet(
      context: context,
      isIncome: item.isIncome,
      existing: [
        for (final c in existing)
          if (c.id != null) (id: c.id!, name: c.name),
      ],
      onCreate: (name) {
        typed = name;
        return ref.read(smsCategoryStoreProvider).create(name, item.branchId);
      },
    );
    if (!mounted || id == null) return;
    final name =
        existing.where((c) => c.id == id).firstOrNull?.name ?? typed ?? '';
    setState(() => _category = (name: name, id: id));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.flipperL10n;
    final categoriesAsync = ref.watch(categoryProvider);
    final choices = smsCategoryChoices(
      isIncome: item.isIncome,
      branch: categoriesAsync.value ?? const <Category>[],
      personal: watchAccountMode(ref).isPersonal,
    );
    if (categoriesAsync.hasValue) _applyInitial(choices);
    // Personal mode: a money-out "Loan repayment" asks which loan it pays.
    final pickLoan =
        watchAccountMode(ref).isPersonal &&
        !item.isIncome &&
        _category?.name == kLoanRepaymentCategory;
    final service = ref.read(smsReviewServiceProvider);
    final sales = smsCanMatchSale(item)
        ? ref.watch(smsMatchingSalesProvider(item)).value ??
              const <SmsSaleCandidate>[]
        : const <SmsSaleCandidate>[];
    final debts = smsCanSettleDebt(item)
        ? ref.watch(smsMatchingDebtsProvider(item)).value ??
              const <SmsDebtCandidate>[]
        : const <SmsDebtCandidate>[];
    final pending =
        ref
            .watch(smsReviewItemsProvider(ref.watch(smsReviewBranchIdProvider)))
            .value ??
        const <SmsReviewItem>[];
    final counterpart = item.isFee
        ? null
        : findTransferCounterpart(item, pending);
    final targets = smsTransferTargets(
      item,
      chartCodes:
          ref.watch(smsMoneyAccountCodesProvider(item.businessId)).value ??
          const [],
      counterpart: counterpart,
    );
    final accountLabel = _accountLabeler([
      ...targets,
      item.bankAccountCode,
    ], l10n);
    final name = item.isFee ? null : item.counterpartyName;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        20,
        20,
        20,
        20 + MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                _ProviderAvatar(item: item),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.providerLabel,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        _when(item),
                        style: TextStyle(color: Colors.grey.shade700),
                      ),
                    ],
                  ),
                ),
                _Pill(
                  label: _directionLabel(item, l10n),
                  color: item.isIncome ? _kIn : _kOut,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              _amount(item),
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w800,
                color: item.isIncome ? _kIn : _kOut,
              ),
            ),
            if (name != null) ...[
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(
                    Icons.person_outline,
                    size: 18,
                    color: Colors.grey.shade700,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
            if (item.isLowConfidence) ...[
              const SizedBox(height: 10),
              Row(
                children: [
                  const Icon(Icons.warning_amber_rounded, color: _kWarn),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      l10n.smsReviewLowConfidence,
                      style: const TextStyle(color: _kWarn),
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 14),
            _InfoCard(
              rows: [
                (l10n.smsReviewDetailWhen, _when(item)),
                if (item.reference != null)
                  (l10n.smsReviewDetailReference, item.reference!),
                if (item.counterpartyAccount != null)
                  (l10n.smsReviewDetailAccount, item.counterpartyAccount!),
                if (item.fee > 0 && !item.isFee)
                  (l10n.smsReviewCharge, _money(item.fee, item.currency)),
              ],
            ),
            Theme(
              data: Theme.of(
                context,
              ).copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                key: const Key('sms_review_message_details'),
                tilePadding: EdgeInsets.zero,
                childrenPadding: const EdgeInsets.only(bottom: 8),
                expandedCrossAxisAlignment: CrossAxisAlignment.start,
                title: Text(
                  l10n.smsReviewMessageDetails,
                  style: TextStyle(color: Colors.grey.shade800, fontSize: 14),
                ),
                children: [
                  Text(
                    item.description,
                    style: TextStyle(color: Colors.grey.shade700),
                  ),
                ],
              ),
            ),
            if (sales.isNotEmpty) ...[
              const SizedBox(height: 8),
              _SaleMatches(
                sales: sales,
                busy: _busy,
                onLink: (sale) => _run(() async {
                  final linked = await service.linkToSale(
                    item,
                    sale.transactionId,
                  );
                  return (
                    message: linked
                        ? l10n.smsReviewLinked
                        : l10n.smsReviewTakenElsewhere,
                    undo: null,
                  );
                }),
              ),
            ],
            if (debts.isNotEmpty) ...[
              const SizedBox(height: 8),
              _DebtMatches(
                debts: debts,
                busy: _busy,
                onSettle: (debt) => _run(() async {
                  final name = debt.customerName ?? l10n.smsReviewDebtCustomer;
                  final settled = await service.settleDebt(item, debt);
                  return (
                    message: settled == null
                        ? l10n.smsReviewTakenElsewhere
                        : settled.remaining > 0
                        ? l10n.smsReviewDebtSettled(
                            _money(item.amount, item.currency),
                            name,
                            _money(settled.remaining.round(), item.currency),
                          )
                        : l10n.smsReviewDebtCleared(name),
                    undo: null,
                  );
                }),
              ),
            ],
            const SizedBox(height: 16),
            Text(
              l10n.smsReviewWhatIsIt,
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
            ),
            const SizedBox(height: 12),
            Text(
              l10n.smsReviewCategory,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            _CategoryChips(
              choices: choices,
              selected: _category,
              moreOpen: _moreOpen,
              enabled: !_busy,
              onSelected: (c) =>
                  setState(() => _category = c == _category ? null : c),
              onMore: () => setState(() => _moreOpen = true),
              onNew: () =>
                  _newCategory([...choices.suggested, ...choices.more]),
            ),
            if (pickLoan)
              LoanPicker(
                selected: _loanId,
                onChanged: (id) => setState(() => _loanId = id),
              ),
            const SizedBox(height: 16),
            _ConfirmButton(
              outlined: sales.isNotEmpty,
              // A repayment waits for the loans, so it can be linked to one.
              busy: _busy || (pickLoan && loanPickerPending(ref)),
              label: l10n.smsReviewConfirm,
              onPressed: () => _run(() async {
                // Read before the first await: the repayment must be written
                // even if the sheet closes while the SMS is confirmed.
                final choice = _category;
                final loanId = _loanId;
                final recordRepayment = loanRepaymentWriter(ref);
                final categories = ref.read(smsCategoryStoreProvider);
                var categoryId = choice?.id;
                if (choice != null && categoryId == null) {
                  categoryId = await categories.create(
                    choice.name,
                    item.branchId,
                  );
                }
                final txn =
                    _confirmedTxn ??
                    await service.confirm(
                      item,
                      categoryId: categoryId,
                      categoryName: choice?.name,
                    );
                _confirmedTxn = txn;
                if (txn != null && categoryId != null) {
                  await categories.remember(
                    categoryId,
                    isIncome: item.isIncome,
                  );
                }
                if (txn != null &&
                    loanId != null &&
                    choice?.name == kLoanRepaymentCategory) {
                  await recordRepayment(
                    loanId: loanId,
                    amount: item.amount.toDouble(),
                    paidAt: item.occurredAtDate ?? DateTime.now(),
                    transactionId: txn,
                    source: 'sms',
                  );
                }
                return (
                  message: txn == null
                      ? l10n.smsReviewTakenElsewhere
                      : l10n.smsReviewConfirmed,
                  undo: null,
                );
              }),
            ),
            _Hint(
              item.isIncome
                  ? l10n.smsReviewConfirmHintIn
                  : l10n.smsReviewConfirmHintOut,
            ),
            if (!item.isFee) ...[
              const SizedBox(height: 12),
              OutlinedButton.icon(
                key: const Key('sms_review_transfer'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: _kBlue,
                  side: const BorderSide(color: _kBlue),
                  minimumSize: const Size.fromHeight(44),
                ),
                onPressed: _busy
                    ? null
                    : () => setState(() {
                        _transferOpen = !_transferOpen;
                        final paired = counterpart?.bankAccountCode;
                        if (_target == null &&
                            paired != null &&
                            targets.contains(paired)) {
                          _target = paired;
                        }
                      }),
                icon: Icon(
                  _transferOpen ? Icons.expand_less : Icons.swap_horiz,
                ),
                label: Text(l10n.smsReviewTransfer),
              ),
              _Hint(l10n.smsReviewTransferHint),
              if (_transferOpen)
                _TransferPanel(
                  item: item,
                  targets: targets,
                  accountLabel: accountLabel,
                  target: _target,
                  counterpart: counterpart,
                  busy: _busy,
                  onTarget: (code) => setState(() => _target = code),
                  onRecord: () => _run(() async {
                    final target = _target!;
                    final result = await service.recordTransfer(
                      item,
                      otherAccountCode: target,
                      counterpart: counterpart,
                    );
                    if (result == null) {
                      return (
                        message: l10n.smsReviewTakenElsewhere,
                        undo: null,
                      );
                    }
                    final account = accountLabel(target);
                    return (
                      message: item.isIncome
                          ? l10n.smsReviewTransferDoneFrom(account)
                          : l10n.smsReviewTransferDoneTo(account),
                      undo: () => service.undoTransfer(result, item),
                    );
                  }),
                ),
            ],
            const SizedBox(height: 8),
            TextButton(
              key: const Key('sms_review_ignore'),
              style: TextButton.styleFrom(foregroundColor: _kBlue),
              onPressed: _busy
                  ? null
                  : () => _run(() async {
                      await service.ignore(item);
                      return (
                        message: l10n.smsReviewIgnored,
                        undo: () => service.reopen(item),
                      );
                    }),
              child: Text(l10n.smsReviewIgnore),
            ),
            _Hint(l10n.smsReviewIgnoreHint),
          ],
        ),
      ),
    );
  }
}

/// "Money in" / "Money out" next to the provider.
class _Pill extends StatelessWidget {
  const _Pill({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w700,
          fontSize: 12,
        ),
      ),
    );
  }
}

/// Label / value rows: date, reference, account, charge.
class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.rows});

  final List<(String, String)> rows;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        children: [
          for (final (i, (label, value)) in rows.indexed) ...[
            if (i > 0) Divider(height: 1, color: Colors.grey.shade200),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: TextStyle(color: Colors.grey.shade700)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      value,
                      textAlign: TextAlign.end,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// One line under an action saying what it does.
class _Hint extends StatelessWidget {
  const _Hint(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
      ),
    );
  }
}

/// The direction's suggested categories, then "More" (the branch's other
/// categories) and "New".
class _CategoryChips extends StatelessWidget {
  const _CategoryChips({
    required this.choices,
    required this.selected,
    required this.moreOpen,
    required this.enabled,
    required this.onSelected,
    required this.onMore,
    required this.onNew,
  });

  final SmsCategoryChoices choices;
  final SmsCategoryChoice? selected;
  final bool moreOpen;
  final bool enabled;
  final ValueChanged<SmsCategoryChoice> onSelected;
  final VoidCallback onMore;
  final VoidCallback onNew;

  @override
  Widget build(BuildContext context) {
    final l10n = context.flipperL10n;
    // A picked "more" category stays visible while the rest are folded.
    final more = moreOpen
        ? choices.more
        : [
            for (final c in choices.more)
              if (c == selected) c,
          ];
    Widget action(String key, IconData icon, String label, VoidCallback tap) =>
        ActionChip(
          key: Key(key),
          avatar: Icon(icon, size: 18, color: _kBlue),
          label: Text(label),
          onPressed: enabled ? tap : null,
          side: BorderSide(color: _kBlue.withValues(alpha: 0.4)),
        );
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final c in [...choices.suggested, ...more])
          ChoiceChip(
            key: Key('sms_review_category_${c.name}'),
            label: Text(c.name),
            selected: c == selected,
            selectedColor: _kBlue.withValues(alpha: 0.15),
            onSelected: enabled ? (_) => onSelected(c) : null,
          ),
        if (!moreOpen && choices.more.length > more.length)
          action(
            'sms_review_category_more',
            Icons.expand_more,
            l10n.more,
            onMore,
          ),
        action(
          'sms_review_category_new',
          Icons.add,
          l10n.cashbookNewEntry,
          onNew,
        ),
      ],
    );
  }
}

/// Names [codes]' accounts: a bank or wallet by its own name (BK, MTN MoMo),
/// and Bank / Mobile Money as "Other …" once one of [codes] is a named
/// account in that group, so "Bank" never sits beside "BK" as if different.
String Function(String code) _accountLabeler(
  List<String> codes,
  FlipperAppLocalizations l10n,
) {
  bool named(String group) =>
      codes.any((c) => c != group && liquidGroupOf(c) == group);
  final otherBank = named(kSmsBankAccount);
  final otherMomo = named(kSmsMobileMoneyAccount);
  return (code) => switch (code) {
    kSmsCashAccount => l10n.smsReviewAccountCash,
    kSmsBankAccount =>
      otherBank ? l10n.smsReviewAccountOtherBank : l10n.smsReviewAccountBank,
    kSmsMobileMoneyAccount =>
      otherMomo ? l10n.smsReviewAccountOtherMomo : l10n.smsReviewAccountMomo,
    _ => providerAccountFor(code)?.providerLabel ?? l10n.smsReviewAccountBank,
  };
}

IconData _accountIcon(String code) => switch (liquidGroupOf(code)) {
  kSmsCashAccount => Icons.payments_outlined,
  kSmsMobileMoneyAccount => Icons.phone_android_rounded,
  _ => Icons.account_balance_outlined,
};

/// Where the money went (or came from), then Record. When the other
/// account's SMS for the same move is waiting, says that it closes too.
class _TransferPanel extends StatelessWidget {
  const _TransferPanel({
    required this.item,
    required this.targets,
    required this.accountLabel,
    required this.target,
    required this.counterpart,
    required this.busy,
    required this.onTarget,
    required this.onRecord,
  });

  final SmsReviewItem item;
  final List<String> targets;
  final String Function(String code) accountLabel;
  final String? target;
  final SmsReviewItem? counterpart;
  final bool busy;
  final ValueChanged<String> onTarget;
  final VoidCallback onRecord;

  @override
  Widget build(BuildContext context) {
    final l10n = context.flipperL10n;
    final paired = counterpart;
    final pairedTime = paired == null ? null : _clockTime(paired);
    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _kBlue.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _kBlue.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            item.isIncome
                ? l10n.smsReviewTransferWhereFrom
                : l10n.smsReviewTransferWhereTo,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final code in targets)
                ChoiceChip(
                  key: Key('sms_review_transfer_target_$code'),
                  avatar: Icon(_accountIcon(code), size: 18),
                  label: Text(accountLabel(code)),
                  selected: target == code,
                  selectedColor: _kBlue.withValues(alpha: 0.15),
                  onSelected: busy ? null : (_) => onTarget(code),
                ),
            ],
          ),
          if (paired != null && paired.bankAccountCode == target) ...[
            const SizedBox(height: 10),
            Row(
              key: const Key('sms_review_transfer_paired'),
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.link, size: 18, color: _kBlue),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    l10n.smsReviewTransferPaired(
                      paired.providerLabel,
                      _amount(paired),
                      pairedTime == null
                          ? _when(paired)
                          : DateFormat('HH:mm').format(pairedTime),
                    ),
                    style: TextStyle(color: Colors.grey.shade800),
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(height: 12),
          FilledButton(
            key: const Key('sms_review_transfer_record'),
            style: FilledButton.styleFrom(
              backgroundColor: _kBlue,
              minimumSize: const Size.fromHeight(44),
            ),
            onPressed: busy || target == null ? null : onRecord,
            child: busy
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : Text(l10n.smsReviewTransferRecord),
          ),
        ],
      ),
    );
  }
}

/// "Add to Cash Book": the main action, or outlined when a matching sale
/// makes Link the likelier one.
class _ConfirmButton extends StatelessWidget {
  const _ConfirmButton({
    required this.outlined,
    required this.busy,
    required this.label,
    required this.onPressed,
  });

  final bool outlined;
  final bool busy;
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    const key = Key('sms_review_confirm');
    final child = busy
        ? SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: outlined ? _kBlue : Colors.white,
            ),
          )
        : Text(label);
    if (outlined) {
      return OutlinedButton(
        key: key,
        style: OutlinedButton.styleFrom(
          foregroundColor: _kBlue,
          side: const BorderSide(color: _kBlue),
          minimumSize: const Size.fromHeight(48),
        ),
        onPressed: busy ? null : onPressed,
        child: child,
      );
    }
    return FilledButton(
      key: key,
      style: FilledButton.styleFrom(
        backgroundColor: _kBlue,
        minimumSize: const Size.fromHeight(48),
      ),
      onPressed: busy ? null : onPressed,
      child: child,
    );
  }
}

/// "Already recorded as a sale?": the till sales this SMS may be paying for,
/// each with a Link that closes the SMS without adding anything.
class _SaleMatches extends StatelessWidget {
  const _SaleMatches({
    required this.sales,
    required this.busy,
    required this.onLink,
  });

  final List<SmsSaleCandidate> sales;
  final bool busy;
  final void Function(SmsSaleCandidate sale) onLink;

  @override
  Widget build(BuildContext context) {
    final l10n = context.flipperL10n;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _kBlue.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _kBlue.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l10n.smsReviewMatchTitle,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 2),
          Text(
            l10n.smsReviewMatchBody,
            style: TextStyle(color: Colors.grey.shade700),
          ),
          for (final sale in sales.take(3)) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Text(
                    [
                      l10n.smsReviewMatchSale(
                        sale.createdAt == null
                            ? ''
                            : DateFormat('HH:mm').format(sale.createdAt!),
                        sale.amount.toCurrencyFormatted(
                          symbol: 'RWF',
                          decimalDigits: 0,
                        ),
                      ),
                      if (sale.customerName?.isNotEmpty ?? false)
                        sale.customerName!,
                    ].join(' · '),
                  ),
                ),
                const SizedBox(width: 8),
                FilledButton(
                  key: Key('sms_review_link_${sale.transactionId}'),
                  style: FilledButton.styleFrom(backgroundColor: _kBlue),
                  onPressed: busy ? null : () => onLink(sale),
                  child: Text(l10n.smsReviewLink),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

/// Customers who owe money and look like the payer: settling records the SMS
/// as an installment on their credit sale.
class _DebtMatches extends StatelessWidget {
  const _DebtMatches({
    required this.debts,
    required this.busy,
    required this.onSettle,
  });

  final List<SmsDebtCandidate> debts;
  final bool busy;
  final void Function(SmsDebtCandidate debt) onSettle;

  @override
  Widget build(BuildContext context) {
    final l10n = context.flipperL10n;
    return Container(
      key: const Key('sms_review_debts'),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _kBlue.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _kBlue.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l10n.smsReviewDebtTitle,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 2),
          Text(
            l10n.smsReviewDebtBody,
            style: TextStyle(color: Colors.grey.shade700),
          ),
          for (final debt in debts.take(3)) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Text(
                    [
                      l10n.smsReviewDebtOwes(
                        debt.customerName ?? l10n.smsReviewDebtCustomer,
                        _money(debt.remainingBalance.round(), 'RWF'),
                      ),
                      ?debt.phoneHint,
                    ].join(' · '),
                  ),
                ),
                const SizedBox(width: 8),
                FilledButton(
                  key: Key('sms_review_settle_${debt.transactionId}'),
                  style: FilledButton.styleFrom(backgroundColor: _kBlue),
                  onPressed: busy ? null : () => onSettle(debt),
                  child: Text(l10n.smsReviewSettle),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
