import 'package:flipper_accounting/bill_payments.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_web/features/business_selection/business_branch_selector.dart';
import 'package:flipper_web/modules/accounting/data/accounting_backend_config.dart';
import 'package:flipper_web/modules/accounting/data/accounting_derive.dart';
import 'package:flipper_web/modules/accounting/data/accounting_document_math.dart';
import 'package:flipper_web/modules/accounting/data/accounting_document_poster.dart';
import 'package:flipper_web/modules/accounting/data/accounting_models.dart';
import 'package:flipper_web/modules/accounting/data/accounting_providers.dart';
import 'package:flipper_web/modules/accounting/data/accounting_v3_models.dart';
import 'package:flipper_web/modules/accounting/data/accounting_v3_providers.dart';
import 'package:flipper_web/modules/accounting/data/books_bill_payment.dart';
import 'package:flipper_web/modules/accounting/data/chart_account_resolver.dart';
import 'package:flipper_web/modules/accounting/theme/accounting_tokens.dart';
import 'package:flipper_web/modules/accounting/widgets/accounting_page_header.dart';
import 'package:flipper_web/modules/accounting/widgets/accounting_toast.dart';
import 'package:flipper_web/modules/accounting/widgets/doc_status_pill.dart';
import 'package:flipper_web/services/ditto_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

const _payMethodCodes = ['1020', '1010', '1030'];

class DocEditorPanel extends ConsumerStatefulWidget {
  const DocEditorPanel({
    super.key,
    required this.kind,
    required this.doc,
    required this.newId,
    required this.onClose,
    required this.onSaved,
    this.initialWho,
  });

  final DocKind kind;
  final AccountingDocument? doc;
  final String newId;
  final VoidCallback onClose;
  final void Function(AccountingDocument doc, String mode) onSaved;
  final String? initialWho;

  @override
  ConsumerState<DocEditorPanel> createState() => _DocEditorPanelState();
}

class _DocEditorPanelState extends ConsumerState<DocEditorPanel> {
  late String _who;
  late String _date;
  late String _due;
  late List<DocLine> _lines;
  late final String _id;

  @override
  void initState() {
    super.initState();
    final doc = widget.doc;
    final now = DateTime.now();
    _id = doc?.id ?? widget.newId;
    _who = doc?.who ?? widget.initialWho ?? '';
    _date = doc?.date ?? DateFormat('d MMM y').format(now);
    _due =
        doc?.due ??
        DateFormat('d MMM y').format(now.add(const Duration(days: 30)));
    _lines =
        doc?.lines.map((l) => l.copyWith()).toList() ??
        [const DocLine(desc: '', qty: 1, price: 0)];
  }

  bool get _isInvoice => widget.kind == DocKind.invoice;

  bool get _valid =>
      _who.isNotEmpty && _lines.any((l) => l.desc.isNotEmpty && l.price > 0);

  DocTotals get _totals => docTotals(_lines);

  List<({String side, String ac, int amt})> _postPreview(
    ChartAccountResolver roles,
  ) {
    if (_isInvoice) {
      final ar = roles.receivable ?? '1100';
      final rev = roles.salesRevenue ?? '4010';
      final vat = roles.vatPayable ?? '2100';
      return [
        (side: 'dr', ac: ar, amt: _totals.total),
        (side: 'cr', ac: rev, amt: _totals.subtotal),
        (side: 'cr', ac: vat, amt: _totals.vat),
      ];
    }
    final inv = roles.inventory ?? roles.operatingExpense ?? '1200';
    final vat = roles.vatPayable ?? '2100';
    final ap = roles.payable ?? '2010';
    return [
      (side: 'dr', ac: inv, amt: _totals.subtotal),
      (side: 'dr', ac: vat, amt: _totals.vat),
      (side: 'cr', ac: ap, amt: _totals.total),
    ];
  }

  /// Recorded by a purchase or the cashbook (old purchase bills have only
  /// the purchase link): its own poster owns the ledger entry.
  bool get _postedElsewhere =>
      widget.doc?.source != null || widget.doc?.purchaseId != null;

  /// A waiting purchase's bill: it is recorded by approving the purchase.
  bool get _waitingPurchaseDraft =>
      _postedElsewhere && widget.doc?.status == DocStatus.draft;

  AccountingDocument _build(DocStatus status) {
    final filtered = _lines
        .where((l) => l.desc.isNotEmpty || l.price > 0)
        .map((l) => DocLine(desc: l.desc, qty: l.qty, price: l.price))
        .toList();
    final lines = filtered.isEmpty ? _lines : filtered;
    final original = widget.doc;
    // Purchase and cashbook bills were posted by their own poster: the ledger
    // will not follow an edit here, so their total and status stay as they
    // are (a waiting purchase's draft cannot be recorded from Books either).
    final postedElsewhere = _postedElsewhere;
    return AccountingDocument(
      // Bill numbers repeat (two suppliers' invoice 42): the document id,
      // not the number, says which bill this is.
      uuid: original?.uuid,
      id: _id,
      who: _who,
      date: _date,
      due: _due,
      status: postedElsewhere ? _storedStatus(original!.status) : status,
      lines: lines,
      total:
          postedElsewhere ||
              (original != null && _sameLines(original.lines, lines))
          ? original?.total
          : null,
      amountPaid: original?.amountPaid ?? 0,
      source: original?.source,
      supplierId: original?.supplierId,
      purchaseId: original?.purchaseId,
      paidUpfront: original?.paidUpfront ?? 0,
    );
  }

  /// Overdue and part paid are derived on read; the stored status is sent.
  static DocStatus _storedStatus(DocStatus s) =>
      s == DocStatus.overdue || s == DocStatus.partiallyPaid
      ? DocStatus.sent
      : s;

  static bool _sameLines(List<DocLine> a, List<DocLine> b) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i].desc != b[i].desc ||
          a[i].qty != b[i].qty ||
          a[i].price != b[i].price) {
        return false;
      }
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.flipperL10n;
    final accounts = ref.watch(accountingAccountsProvider);
    final accountMap = {for (final a in accounts) a.code: a};
    final roles = ChartAccountResolver(accounts);
    final parties = _isInvoice
        ? ref.watch(accountingCustomersProvider)
        : ref.watch(accountingSuppliersProvider);
    final currency = ref.watch(accountingCurrencyProvider);
    final postLines = _postPreview(roles);

    return _PanelScrim(
      onClose: widget.onClose,
      width: AccountingTokens.composerWidthWide,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _PanelHeader(
            title: _isInvoice
                ? (widget.doc == null
                      ? l10n.booksNewInvoiceTitle(_id)
                      : l10n.booksEditInvoiceTitle(_id))
                : (widget.doc == null
                      ? l10n.booksNewBillTitle(_id)
                      : l10n.booksEditBillTitle(_id)),
            subtitle: _isInvoice
                ? l10n.booksInvoiceEditorSubtitle
                : l10n.booksBillEditorSubtitle,
            onClose: widget.onClose,
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 14,
                        child: _FieldLabel(
                          label: _isInvoice
                              ? l10n.customer
                              : l10n.booksSupplier,
                          child: DropdownButtonFormField<String>(
                            initialValue: _who.isEmpty ? null : _who,
                            decoration: _inputDecoration(
                              icon: Icons.business_outlined,
                              hint: _isInvoice
                                  ? l10n.booksSelectCustomer
                                  : l10n.booksSelectSupplier,
                            ),
                            items: [
                              for (final p in parties)
                                DropdownMenuItem(
                                  value: p.name,
                                  child: Text(p.name),
                                ),
                            ],
                            onChanged: (v) => setState(() => _who = v ?? ''),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _FieldLabel(
                          label: _isInvoice
                              ? l10n.booksIssueDate
                              : l10n.booksBillDate,
                          child: TextFormField(
                            initialValue: _date,
                            decoration: _inputDecoration(
                              icon: Icons.calendar_today_outlined,
                            ),
                            onChanged: (v) => _date = v,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _FieldLabel(
                          label: l10n.booksDueDateLabel,
                          child: TextFormField(
                            initialValue: _due,
                            decoration: _inputDecoration(
                              icon: Icons.schedule_outlined,
                            ),
                            onChanged: (v) => _due = v,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    l10n.booksLineItems,
                    style: AccountingTokens.sans(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AccountingTokens.ink3,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const _LineHeader(),
                  const SizedBox(height: 6),
                  for (var i = 0; i < _lines.length; i++) ...[
                    _LineRow(
                      line: _lines[i],
                      currency: currency,
                      onChanged: (patch) => setState(() {
                        _lines[i] = _lines[i].copyWith(
                          desc: patch.desc,
                          qty: patch.qty,
                          price: patch.price,
                        );
                      }),
                      onDelete: _lines.length > 1
                          ? () => setState(() => _lines.removeAt(i))
                          : null,
                    ),
                    const SizedBox(height: 8),
                  ],
                  TextButton.icon(
                    onPressed: () => setState(
                      () =>
                          _lines.add(const DocLine(desc: '', qty: 1, price: 0)),
                    ),
                    icon: const Icon(Icons.add, size: 16),
                    label: Text(l10n.booksAddLine),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: _PostPreviewBox(
                          title: _isInvoice
                              ? l10n.booksInvoiceWillPost
                              : l10n.booksBillWillPost,
                          lines: postLines,
                          accountMap: accountMap,
                          currency: currency,
                          total: _totals.total,
                        ),
                      ),
                      const SizedBox(width: 16),
                      SizedBox(
                        width: 220,
                        child: _TotalsBox(totals: _totals, currency: currency),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          _PanelFooter(
            children: [
              AccountingButton(
                label: l10n.booksSaveDraft,
                enabled: _who.isNotEmpty,
                onPressed: _who.isEmpty
                    ? null
                    : () => widget.onSaved(_build(DocStatus.draft), 'draft'),
              ),
              if (_isInvoice)
                PopupMenuButton<String>(
                  offset: const Offset(0, -8),
                  padding: EdgeInsets.zero,
                  enabled: _valid,
                  child: AccountingButton(
                    label: l10n.booksSaveAndSend,
                    icon: Icons.mail_outline,
                    primary: true,
                    enabled: _valid,
                  ),
                  itemBuilder: (context) => [
                    PopupMenuItem(value: 'email', child: Text(l10n.email)),
                    const PopupMenuItem(
                      value: 'whatsapp',
                      child: Text('WhatsApp'),
                    ),
                    PopupMenuItem(
                      value: 'pdf',
                      child: Text(l10n.booksDownloadPdfOnly),
                    ),
                  ],
                  onSelected: (_) =>
                      widget.onSaved(_build(DocStatus.sent), 'send'),
                )
              else
                AccountingButton(
                  label: _waitingPurchaseDraft
                      ? l10n.booksApproveInPurchases
                      : l10n.booksRecordBill,
                  icon: Icons.check,
                  primary: true,
                  enabled: _valid && !_waitingPurchaseDraft,
                  onPressed: _valid && !_waitingPurchaseDraft
                      ? () => widget.onSaved(_build(DocStatus.sent), 'send')
                      : null,
                ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Create/edit panel for a [RecurringSchedule] — name, cadence, amount, and the
/// two chart-of-accounts codes the schedule debits/credits when it posts.
class RecurringEditorPanel extends ConsumerStatefulWidget {
  const RecurringEditorPanel({
    super.key,
    required this.schedule,
    required this.newId,
    required this.onClose,
    required this.onSaved,
  });

  final RecurringSchedule? schedule;
  final String newId;
  final VoidCallback onClose;
  final void Function(RecurringSchedule schedule) onSaved;

  @override
  ConsumerState<RecurringEditorPanel> createState() =>
      _RecurringEditorPanelState();
}

class _RecurringEditorPanelState extends ConsumerState<RecurringEditorPanel> {
  static const _freqs = ['Monthly', 'Weekly', 'Quarterly', 'Yearly'];

  late final String _id;
  late String _name;
  late String _freq;
  late String _day;
  late int _amount;
  late String _debitCode;
  late String _creditCode;
  late bool _active;

  @override
  void initState() {
    super.initState();
    final s = widget.schedule;
    _id = s?.id ?? widget.newId;
    _name = s?.name ?? '';
    _freq = s != null && _freqs.contains(s.freq) ? s.freq : 'Monthly';
    _day = s?.day ?? '1st';
    _amount = s?.amount ?? 0;
    _debitCode = s?.debitCode ?? '';
    _creditCode = s?.creditCode ?? '';
    _active = s?.active ?? true;
  }

  bool get _valid =>
      _name.trim().isNotEmpty &&
      _amount > 0 &&
      _debitCode.isNotEmpty &&
      _creditCode.isNotEmpty &&
      _debitCode != _creditCode;

  RecurringSchedule _build() => RecurringSchedule(
    id: _id,
    name: _name.trim(),
    freq: _freq,
    day: _day.trim().isEmpty ? '1st' : _day.trim(),
    next: widget.schedule?.next ?? DateFormat('d MMM y').format(DateTime.now()),
    amount: _amount,
    debitCode: _debitCode,
    creditCode: _creditCode,
    iconName: widget.schedule?.iconName ?? 'Refresh',
    active: _active,
    uuid: widget.schedule?.uuid,
  );

  @override
  Widget build(BuildContext context) {
    final l10n = context.flipperL10n;
    final accounts = ref.watch(accountingAccountsProvider);
    final currency = ref.watch(accountingCurrencyProvider);

    List<DropdownMenuItem<String>> accountItems() => [
      for (final a in accounts)
        DropdownMenuItem(
          value: a.code,
          child: Text('${a.code} · ${a.name}', overflow: TextOverflow.ellipsis),
        ),
    ];

    String? validValue(String code) =>
        accounts.any((a) => a.code == code) ? code : null;

    return _PanelScrim(
      onClose: widget.onClose,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _PanelHeader(
            title: widget.schedule == null
                ? l10n.booksNewScheduleTitle(_id)
                : l10n.booksEditScheduleTitle(_id),
            subtitle: l10n.booksScheduleEditorSubtitle,
            onClose: widget.onClose,
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _FieldLabel(
                    label: l10n.booksScheduleName,
                    child: TextFormField(
                      initialValue: _name,
                      decoration: _inputDecoration(
                        icon: Icons.label_outline,
                        hint: l10n.booksScheduleNameHint,
                      ),
                      onChanged: (v) => _name = v,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: _FieldLabel(
                          label: l10n.booksFrequency,
                          child: DropdownButtonFormField<String>(
                            initialValue: _freq,
                            decoration: _inputDecoration(icon: Icons.repeat),
                            items: [
                              for (final f in _freqs)
                                DropdownMenuItem(
                                  value: f,
                                  child: Text(booksFrequencyLabel(f, l10n)),
                                ),
                            ],
                            onChanged: (v) =>
                                setState(() => _freq = v ?? 'Monthly'),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _FieldLabel(
                          label: l10n.booksDay,
                          child: TextFormField(
                            initialValue: _day,
                            decoration: _inputDecoration(
                              icon: Icons.calendar_today_outlined,
                              hint: l10n.booksDayHint,
                            ),
                            onChanged: (v) => _day = v,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _FieldLabel(
                    label: l10n.amount,
                    child: TextFormField(
                      initialValue: _amount > 0 ? '$_amount' : '',
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: _inputDecoration(prefix: '$currency '),
                      onChanged: (v) =>
                          setState(() => _amount = int.tryParse(v) ?? 0),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _FieldLabel(
                    label: l10n.booksDebitAccountLabel,
                    child: DropdownButtonFormField<String>(
                      initialValue: validValue(_debitCode),
                      isExpanded: true,
                      decoration: _inputDecoration(
                        icon: Icons.arrow_downward,
                        hint: l10n.booksSelectAccount,
                      ),
                      items: accountItems(),
                      onChanged: (v) => setState(() => _debitCode = v ?? ''),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _FieldLabel(
                    label: l10n.booksCreditAccountLabel,
                    child: DropdownButtonFormField<String>(
                      initialValue: validValue(_creditCode),
                      isExpanded: true,
                      decoration: _inputDecoration(
                        icon: Icons.arrow_upward,
                        hint: l10n.booksSelectAccount,
                      ),
                      items: accountItems(),
                      onChanged: (v) => setState(() => _creditCode = v ?? ''),
                    ),
                  ),
                  if (_debitCode.isNotEmpty && _debitCode == _creditCode) ...[
                    const SizedBox(height: 8),
                    Text(
                      l10n.booksAccountsMustDiffer,
                      style: AccountingTokens.sans(
                        fontSize: 12,
                        color: AccountingTokens.lossInk,
                      ),
                    ),
                  ],
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Switch(
                        value: _active,
                        onChanged: (v) => setState(() => _active = v),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _active ? l10n.booksActive : l10n.booksPausedLabel,
                        style: AccountingTokens.sans(fontSize: 13.5),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          _PanelFooter(
            children: [
              AccountingButton(label: l10n.cancel, onPressed: widget.onClose),
              AccountingButton(
                label: l10n.booksSaveSchedule,
                icon: Icons.check,
                primary: true,
                enabled: _valid,
                onPressed: _valid ? () => widget.onSaved(_build()) : null,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class PaymentModalPanel extends ConsumerStatefulWidget {
  const PaymentModalPanel({
    super.key,
    required this.kind,
    required this.doc,
    required this.onClose,
    required this.onPaid,
  });

  final DocKind kind;
  final AccountingDocument doc;
  final VoidCallback onClose;
  final void Function(AccountingDocument doc) onPaid;

  @override
  ConsumerState<PaymentModalPanel> createState() => _PaymentModalPanelState();
}

class _PaymentModalPanelState extends ConsumerState<PaymentModalPanel> {
  late String _method;
  late int _amount;
  bool _done = false;
  bool _saving = false;

  /// Bill balance after this payment; null until a bill payment is recorded.
  BillBalance? _after;

  @override
  void initState() {
    super.initState();
    _method = '1020';
    _amount = _isInvoice ? docGrandTotal(widget.doc) : docBalance(widget.doc);
  }

  bool get _isInvoice => widget.kind == DocKind.invoice;

  /// Bills in Ditto get real part payments (one `bill_payments` row each).
  /// Invoices, and bills on the Supabase backend, keep the old one-shot post.
  bool get _tracksPayments =>
      !_isInvoice &&
      widget.doc.uuid != null &&
      ref.read(accountingBackendStrategyProvider) ==
          AccountingBackendStrategy.ditto;

  Future<void> _pay(List<Account> accounts, String currency) async {
    if (_saving) return;
    setState(() => _saving = true);
    try {
      final businessId = ref.read(accountingBusinessIdProvider);
      if (_tracksPayments) {
        _after = await BillPaymentPoster(ref.read(dittoServiceProvider))
            .recordPayment(
              businessId: businessId,
              billDocId: widget.doc.uuid!,
              amount: _amount,
              paymentAccount: _method,
              accounts: accounts,
              fallbackTotal: docGrandTotal(widget.doc),
              cashOut: await ref.read(booksBillCashOutProvider)(
                widget.doc.uuid!,
              ),
            );
      } else {
        final poster = DocumentJournalPoster(
          ref.read(accountingLedgerRepositoryProvider),
          accounts,
        );
        if (_isInvoice) {
          await poster.postInvoicePayment(
            businessId: businessId,
            doc: widget.doc,
            paymentAccount: _method,
            amount: _amount,
          );
        } else {
          await poster.postBillPayment(
            businessId: businessId,
            doc: widget.doc,
            paymentAccount: _method,
            amount: _amount,
          );
        }
      }
      appendAuditLog(
        ref,
        action: 'recorded',
        target: widget.doc.id,
        detail: _isInvoice
            ? 'Customer payment — ${widget.doc.who} ($currency ${money(_amount)})'
            : 'Paid ${widget.doc.who} ($currency ${money(_amount)})',
        iconName: 'ArrowDown',
      );
      if (mounted) setState(() => _done = true);
    } catch (e) {
      if (mounted) {
        showAccountingToast(
          context,
          context.flipperL10n.booksPaymentFailed,
          subtitle: '$e',
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  String _doneMessage(String currency) {
    final l10n = context.flipperL10n;
    final paid = '$currency ${money(_amount)}';
    if (_isInvoice) {
      return l10n.booksInvoicePaidMessage(paid, widget.doc.who);
    }
    final after = _after;
    if (after != null && !after.isSettled) {
      return l10n.booksBillPartPaidMessage(
        paid,
        '$currency ${money(after.balance)}',
        widget.doc.who,
      );
    }
    return l10n.booksBillSettledMessage(paid, widget.doc.who);
  }

  @override
  Widget build(BuildContext context) {
    final accounts = ref.watch(accountingAccountsProvider);
    final accountMap = {for (final a in accounts) a.code: a};
    final currency = ref.watch(accountingCurrencyProvider);
    final total = _isInvoice
        ? docGrandTotal(widget.doc)
        : docBalance(widget.doc);

    final l10n = context.flipperL10n;
    final postLines = _isInvoice
        ? [(side: 'dr', ac: _method), (side: 'cr', ac: '1100')]
        : [(side: 'dr', ac: '2010'), (side: 'cr', ac: _method)];

    if (_done) {
      return _EdgePanel(
        width: 480,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _PanelHeader(
              title: l10n.booksPaymentRecorded,
              subtitle: widget.doc.id,
              onClose: widget.onClose,
              compact: true,
            ),
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(38),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 76,
                        height: 76,
                        decoration: BoxDecoration(
                          color: AccountingTokens.gain,
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: const Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 36,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        l10n.booksPaymentRecorded,
                        style: AccountingTokens.sans(
                          fontSize: 21,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _doneMessage(currency),
                        textAlign: TextAlign.center,
                        style: AccountingTokens.sans(
                          fontSize: 13.5,
                          color: AccountingTokens.ink3,
                        ),
                      ),
                      const SizedBox(height: 20),
                      AccountingButton(
                        label: l10n.done,
                        primary: true,
                        onPressed: () => widget.onPaid(widget.doc),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return _EdgePanel(
      width: 480,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _PanelHeader(
            title: _isInvoice ? l10n.booksRecordPayment : l10n.booksPayBill,
            subtitle: l10n.booksAmountDue(
              money(total),
              widget.doc.id,
              widget.doc.who,
            ),
            onClose: widget.onClose,
            compact: true,
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _FieldLabel(
                    label: _isInvoice ? l10n.booksDepositTo : l10n.booksPayFrom,
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (final code in _payMethodCodes)
                          ChoiceChip(
                            label: Text(
                              accountMap[code]?.name ?? code,
                              style: AccountingTokens.sans(fontSize: 12),
                            ),
                            selected: _method == code,
                            onSelected: (_) => setState(() => _method = code),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  _FieldLabel(
                    label: l10n.booksAmountReceived,
                    child: TextFormField(
                      initialValue: money(_amount),
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: _inputDecoration(prefix: currency),
                      onChanged: (v) {
                        final n =
                            int.tryParse(v.replaceAll(RegExp(r'[^\d]'), '')) ??
                            0;
                        setState(() => _amount = n);
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  _PostPreviewBox(
                    title: l10n.booksPostsAs,
                    lines: [
                      for (final p in postLines)
                        (side: p.side, ac: p.ac, amt: _amount),
                    ],
                    accountMap: accountMap,
                    currency: currency,
                    total: _amount,
                    showBalanced: false,
                  ),
                ],
              ),
            ),
          ),
          _PanelFooter(
            children: [
              AccountingButton(label: l10n.cancel, onPressed: widget.onClose),
              AccountingButton(
                label: _isInvoice ? l10n.booksRecordPayment : l10n.booksPayBill,
                icon: Icons.check,
                primary: true,
                enabled: _amount > 0 && !_saving,
                onPressed: _amount > 0 && !_saving
                    ? () => _pay(accounts, currency)
                    : null,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class DocPreviewPanel extends ConsumerWidget {
  const DocPreviewPanel({
    super.key,
    required this.kind,
    required this.doc,
    required this.onClose,
    required this.onEdit,
    required this.onPay,
  });

  final DocKind kind;
  final AccountingDocument doc;
  final VoidCallback onClose;
  final VoidCallback onEdit;
  final VoidCallback onPay;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.flipperL10n;
    final isInv = kind == DocKind.invoice;
    final totals = docTotals(doc.lines);
    final currency = ref.watch(accountingCurrencyProvider);
    final parties = isInv
        ? ref.watch(accountingCustomersProvider)
        : ref.watch(accountingSuppliersProvider);
    final party = parties.where((p) => p.name == doc.who).firstOrNull;
    final business = ref.watch(selectedBusinessProvider);

    return _EdgePanel(
      width: AccountingTokens.composerWidthWide,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 20, 16, 0),
            child: Row(
              children: [
                Text(doc.id, style: AccountingTokens.mono(fontSize: 15)),
                const SizedBox(width: 10),
                DocStatusPill(status: doc.status),
                const Spacer(),
                IconButton(
                  onPressed: onClose,
                  icon: const Icon(Icons.close, size: 18),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AccountingTokens.surface2,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AccountingTokens.line),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                business?.name ?? l10n.booksBusinessFallback,
                                style: AccountingTokens.sans(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              Text(
                                'Kigali · Rwanda',
                                style: AccountingTokens.sans(
                                  fontSize: 12,
                                  color: AccountingTokens.ink3,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          isInv ? l10n.booksInvoiceUpper : l10n.booksBillUpper,
                          style: AccountingTokens.sans(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: AccountingTokens.ink3,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                isInv ? l10n.booksBillTo : l10n.booksFrom,
                                style: AccountingTokens.sans(
                                  fontSize: 11,
                                  color: AccountingTokens.ink3,
                                ),
                              ),
                              Text(
                                doc.who,
                                style: AccountingTokens.sans(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              if (party != null && party.email.isNotEmpty)
                                Text(
                                  '${party.contact}\n${party.email}',
                                  style: AccountingTokens.sans(
                                    fontSize: 12,
                                    color: AccountingTokens.ink3,
                                  ),
                                ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            _PaperRow(
                              label: isInv
                                  ? l10n.booksIssued
                                  : l10n.booksBillDate,
                              value: doc.date,
                            ),
                            _PaperRow(label: l10n.booksDue, value: doc.due),
                            if (party != null)
                              _PaperRow(
                                label: l10n.booksTerms,
                                value: booksTermsLabel(party.terms, l10n),
                              ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Table(
                      columnWidths: const {
                        0: FlexColumnWidth(3),
                        1: FlexColumnWidth(1),
                        2: FlexColumnWidth(1),
                        3: FlexColumnWidth(1),
                      },
                      children: [
                        TableRow(
                          children: [
                            _Th(l10n.booksDescription),
                            _Th(l10n.booksQty, right: true),
                            _Th(l10n.unitPrice, right: true),
                            _Th(l10n.amount, right: true),
                          ],
                        ),
                        for (final l in doc.lines)
                          TableRow(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8,
                                ),
                                child: Text(l.desc),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8,
                                ),
                                child: Text(
                                  '${l.qty}',
                                  textAlign: TextAlign.right,
                                  style: AccountingTokens.mono(),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8,
                                ),
                                child: Text(
                                  money((l.qty * l.price).round()),
                                  textAlign: TextAlign.right,
                                  style: AccountingTokens.mono(),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8,
                                ),
                                child: Text(
                                  money((l.qty * l.price).round()),
                                  textAlign: TextAlign.right,
                                  style: AccountingTokens.mono(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Align(
                      alignment: Alignment.centerRight,
                      child: SizedBox(
                        width: 220,
                        child: _TotalsBox(totals: totals, currency: currency),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          _PanelFooter(
            children: [
              AccountingButton(
                label: 'PDF',
                icon: Icons.download_outlined,
                onPressed: () => showAccountingToast(
                  context,
                  l10n.booksGeneratingPdf,
                  subtitle: '${doc.id} · ${doc.who}',
                  icon: Icons.download_outlined,
                ),
              ),
              AccountingButton(
                label: l10n.edit,
                icon: Icons.receipt_long_outlined,
                onPressed: onEdit,
              ),
              if (isInv ? doc.status != DocStatus.paid : billCanBePaid(doc))
                AccountingButton(
                  label: isInv ? l10n.booksRecordPayment : l10n.booksPayBill,
                  icon: Icons.account_balance_wallet_outlined,
                  primary: true,
                  onPressed: onPay,
                ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Shared panel chrome ─────────────────────────────────────────────────────

/// Right-edge slide-in panel — no dimming scrim; list stays interactive at left.
class _EdgePanel extends StatelessWidget {
  const _EdgePanel({required this.child, this.width});

  final Widget child;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? AccountingTokens.composerWidth,
      decoration: const BoxDecoration(
        color: AccountingTokens.surface,
        border: Border(left: BorderSide(color: AccountingTokens.line)),
        boxShadow: [
          BoxShadow(
            color: Color(0x33081216),
            blurRadius: 60,
            offset: Offset(-24, 0),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _PanelScrim extends StatelessWidget {
  const _PanelScrim({required this.onClose, required this.child, this.width});

  final VoidCallback onClose;
  final Widget child;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return _EdgePanel(width: width, child: child);
  }
}

class _PanelHeader extends StatelessWidget {
  const _PanelHeader({
    required this.title,
    required this.subtitle,
    required this.onClose,
    this.compact = false,
  });

  final String title;
  final String subtitle;
  final VoidCallback onClose;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(24, compact ? 16 : 22, 16, compact ? 8 : 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AccountingTokens.sans(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: AccountingTokens.sans(
                    fontSize: 13,
                    color: AccountingTokens.ink3,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onClose,
            icon: const Icon(Icons.close, size: 18),
          ),
        ],
      ),
    );
  }
}

class _PanelFooter extends StatelessWidget {
  const _PanelFooter({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 20),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AccountingTokens.line)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          for (var i = 0; i < children.length; i++) ...[
            if (i > 0) const SizedBox(width: 8),
            children[i],
          ],
        ],
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel({required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AccountingTokens.sans(
            fontSize: 11.5,
            fontWeight: FontWeight.w700,
            color: AccountingTokens.ink3,
          ),
        ),
        const SizedBox(height: 6),
        child,
      ],
    );
  }
}

InputDecoration _inputDecoration({
  IconData? icon,
  String? hint,
  String? prefix,
}) {
  return InputDecoration(
    hintText: hint,
    prefixText: prefix,
    prefixIcon: icon != null
        ? Icon(icon, size: 18, color: AccountingTokens.ink3)
        : null,
    filled: true,
    fillColor: AccountingTokens.surface2,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: AccountingTokens.line),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: AccountingTokens.line),
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
  );
}

class _LineHeader extends StatelessWidget {
  const _LineHeader();

  // Mirrors the 12px horizontal content padding of the fields below, so each
  // header label lines up with its field's text.
  static Widget _label(String text, {TextAlign align = TextAlign.left}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Text(
        text,
        textAlign: align,
        style: AccountingTokens.sans(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: AccountingTokens.ink3,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Column widths mirror _LineRow so headers line up with each field.
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: _label(context.flipperL10n.booksItemOrService),
        ),
        const SizedBox(width: 8),
        SizedBox(
          width: 64,
          child: _label(context.flipperL10n.booksQty, align: TextAlign.center),
        ),
        const SizedBox(width: 8),
        SizedBox(width: 110, child: _label(context.flipperL10n.unitPrice)),
        const SizedBox(width: 8),
        SizedBox(
          width: 90,
          child: _label(context.flipperL10n.amount, align: TextAlign.right),
        ),
        // Reserve space for the per-row delete icon.
        const SizedBox(width: 48),
      ],
    );
  }
}

class _LineRow extends StatelessWidget {
  const _LineRow({
    required this.line,
    required this.currency,
    required this.onChanged,
    this.onDelete,
  });

  final DocLine line;
  final String currency;
  final void Function(DocLine patch) onChanged;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final amt = (line.qty * line.price).round();
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: TextFormField(
            initialValue: line.desc,
            decoration: _inputDecoration(
              hint: context.flipperL10n.booksItemOrServiceHint,
            ),
            onChanged: (v) => onChanged(line.copyWith(desc: v)),
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(
          width: 64,
          child: TextFormField(
            initialValue: '${line.qty}',
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            decoration: _inputDecoration(hint: context.flipperL10n.booksQty),
            onChanged: (v) =>
                onChanged(line.copyWith(qty: num.tryParse(v) ?? line.qty)),
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(
          width: 110,
          child: TextFormField(
            initialValue: line.price > 0 ? money(line.price.round()) : '',
            keyboardType: TextInputType.number,
            decoration: _inputDecoration(hint: context.flipperL10n.unitPrice),
            onChanged: (v) {
              final n = int.tryParse(v.replaceAll(RegExp(r'[^\d]'), '')) ?? 0;
              onChanged(line.copyWith(price: n));
            },
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(
          width: 90,
          child: Text(
            money(amt),
            textAlign: TextAlign.right,
            style: AccountingTokens.mono(fontWeight: FontWeight.w700),
          ),
        ),
        if (onDelete != null)
          IconButton(
            onPressed: onDelete,
            icon: const Icon(Icons.delete_outline, size: 18),
          ),
      ],
    );
  }
}

class _PostPreviewBox extends StatelessWidget {
  const _PostPreviewBox({
    required this.title,
    required this.lines,
    required this.accountMap,
    required this.currency,
    required this.total,
    this.showBalanced = true,
  });

  final String title;
  final List<({String side, String ac, int amt})> lines;
  final Map<String, Account> accountMap;
  final String currency;
  final int total;
  final bool showBalanced;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AccountingTokens.surface2,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AccountingTokens.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.layers_outlined, size: 15),
              const SizedBox(width: 6),
              Text(
                title,
                style: AccountingTokens.sans(fontWeight: FontWeight.w700),
              ),
            ],
          ),
          const SizedBox(height: 10),
          for (final p in lines)
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: p.side == 'dr'
                          ? AccountingTokens.accentTint
                          : AccountingTokens.gainTint,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      (p.side == 'dr'
                              ? context.flipperL10n.booksDrShort
                              : context.flipperL10n.booksCrShort)
                          .toUpperCase(),
                      style: AccountingTokens.mono(
                        fontSize: 10,
                        color: p.side == 'dr'
                            ? AccountingTokens.drInk
                            : AccountingTokens.crInk,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      accountMap[p.ac]?.name ?? p.ac,
                      style: AccountingTokens.sans(fontSize: 13),
                    ),
                  ),
                  Text(
                    money(p.amt),
                    style: AccountingTokens.mono(fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),
          if (showBalanced)
            Text(
              context.flipperL10n.booksBalancedEquation(
                money(total),
                '$currency ${money(total)}',
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

class _TotalsBox extends StatelessWidget {
  const _TotalsBox({required this.totals, required this.currency});

  final DocTotals totals;
  final String currency;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _TotalRow(
          label: context.flipperL10n.subtotal,
          value: money(totals.subtotal),
        ),
        _TotalRow(
          label: context.flipperL10n.booksVat18,
          value: money(totals.vat),
        ),
        const Divider(),
        _TotalRow(
          label: context.flipperL10n.booksTotal,
          value: '$currency ${money(totals.total)}',
          bold: true,
        ),
      ],
    );
  }
}

class _TotalRow extends StatelessWidget {
  const _TotalRow({
    required this.label,
    required this.value,
    this.bold = false,
  });

  final String label;
  final String value;
  final bool bold;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AccountingTokens.sans(
              fontSize: 13,
              color: AccountingTokens.ink3,
            ),
          ),
          Text(
            value,
            style: AccountingTokens.mono(
              fontSize: 13,
              fontWeight: bold ? FontWeight.w800 : FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _PaperRow extends StatelessWidget {
  const _PaperRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$label  ',
            style: AccountingTokens.sans(
              fontSize: 12,
              color: AccountingTokens.ink3,
            ),
          ),
          Text(
            value,
            style: AccountingTokens.sans(
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _Th extends StatelessWidget {
  const _Th(this.label, {this.right = false});

  final String label;
  final bool right;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        label,
        textAlign: right ? TextAlign.right : TextAlign.left,
        style: AccountingTokens.sans(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: AccountingTokens.ink3,
        ),
      ),
    );
  }
}
