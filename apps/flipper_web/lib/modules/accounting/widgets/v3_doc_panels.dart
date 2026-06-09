import 'package:flipper_web/features/business_selection/business_branch_selector.dart';
import 'package:flipper_web/modules/accounting/data/accounting_derive.dart';
import 'package:flipper_web/modules/accounting/data/accounting_document_math.dart';
import 'package:flipper_web/modules/accounting/data/accounting_document_poster.dart';
import 'package:flipper_web/modules/accounting/data/accounting_models.dart';
import 'package:flipper_web/modules/accounting/data/accounting_providers.dart';
import 'package:flipper_web/modules/accounting/data/accounting_v3_models.dart';
import 'package:flipper_web/modules/accounting/data/accounting_v3_providers.dart';
import 'package:flipper_web/modules/accounting/data/chart_account_resolver.dart';
import 'package:flipper_web/modules/accounting/theme/accounting_tokens.dart';
import 'package:flipper_web/modules/accounting/widgets/accounting_page_header.dart';
import 'package:flipper_web/modules/accounting/widgets/accounting_toast.dart';
import 'package:flipper_web/modules/accounting/widgets/doc_status_pill.dart';
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
    _due = doc?.due ?? DateFormat('d MMM y').format(now.add(const Duration(days: 30)));
    _lines = doc?.lines.map((l) => l.copyWith()).toList() ??
        [const DocLine(desc: '', qty: 1, price: 0)];
  }

  bool get _isInvoice => widget.kind == DocKind.invoice;

  bool get _valid =>
      _who.isNotEmpty && _lines.any((l) => l.desc.isNotEmpty && l.price > 0);

  DocTotals get _totals => docTotals(_lines);

  List<({String side, String ac, int amt})> _postPreview(ChartAccountResolver roles) {
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

  AccountingDocument _build(DocStatus status) {
    final filtered = _lines
        .where((l) => l.desc.isNotEmpty || l.price > 0)
        .map((l) => DocLine(desc: l.desc, qty: l.qty, price: l.price))
        .toList();
    return AccountingDocument(
      id: _id,
      who: _who,
      date: _date,
      due: _due,
      status: status,
      lines: filtered.isEmpty ? _lines : filtered,
    );
  }

  @override
  Widget build(BuildContext context) {
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
            title:
                '${widget.doc == null ? 'New' : 'Edit'} ${_isInvoice ? 'invoice' : 'bill'} · $_id',
            subtitle: _isInvoice
                ? 'Bill a customer — Flipper posts the sale and VAT automatically.'
                : 'Record a supplier bill — Flipper posts the expense and input VAT.',
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
                          label: _isInvoice ? 'Customer' : 'Supplier',
                          child: DropdownButtonFormField<String>(
                            value: _who.isEmpty ? null : _who,
                            decoration: _inputDecoration(
                              icon: Icons.business_outlined,
                              hint: 'Select ${_isInvoice ? 'customer' : 'supplier'}…',
                            ),
                            items: [
                              for (final p in parties)
                                DropdownMenuItem(value: p.name, child: Text(p.name)),
                            ],
                            onChanged: (v) => setState(() => _who = v ?? ''),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _FieldLabel(
                          label: _isInvoice ? 'Issue date' : 'Bill date',
                          child: TextFormField(
                            initialValue: _date,
                            decoration: _inputDecoration(icon: Icons.calendar_today_outlined),
                            onChanged: (v) => _date = v,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _FieldLabel(
                          label: 'Due date',
                          child: TextFormField(
                            initialValue: _due,
                            decoration: _inputDecoration(icon: Icons.schedule_outlined),
                            onChanged: (v) => _due = v,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Line items',
                    style: AccountingTokens.sans(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AccountingTokens.ink3,
                    ),
                  ),
                  const SizedBox(height: 10),
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
                      () => _lines.add(const DocLine(desc: '', qty: 1, price: 0)),
                    ),
                    icon: const Icon(Icons.add, size: 16),
                    label: const Text('Add line'),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: _PostPreviewBox(
                          title: 'This ${_isInvoice ? 'invoice' : 'bill'} will post',
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
                label: 'Save draft',
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
                    label: 'Save & send',
                    icon: Icons.mail_outline,
                    primary: true,
                    enabled: _valid,
                  ),
                  itemBuilder: (context) => const [
                    PopupMenuItem(value: 'email', child: Text('Email')),
                    PopupMenuItem(value: 'whatsapp', child: Text('WhatsApp')),
                    PopupMenuItem(value: 'pdf', child: Text('Download PDF only')),
                  ],
                  onSelected: (_) =>
                      widget.onSaved(_build(DocStatus.sent), 'send'),
                )
              else
                AccountingButton(
                  label: 'Record bill',
                  icon: Icons.check,
                  primary: true,
                  enabled: _valid,
                  onPressed: _valid
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

  @override
  void initState() {
    super.initState();
    _method = '1020';
    _amount = docTotals(widget.doc.lines).total;
  }

  bool get _isInvoice => widget.kind == DocKind.invoice;

  @override
  Widget build(BuildContext context) {
    final accounts = ref.watch(accountingAccountsProvider);
    final accountMap = {for (final a in accounts) a.code: a};
    final currency = ref.watch(accountingCurrencyProvider);
    final total = docTotals(widget.doc.lines).total;

    final postLines = _isInvoice
        ? [(side: 'dr', ac: _method), (side: 'cr', ac: '1100')]
        : [(side: 'dr', ac: '2010'), (side: 'cr', ac: _method)];

    if (_done) {
      return _ModalScrim(
        onClose: widget.onClose,
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
                child: const Icon(Icons.check, color: Colors.white, size: 36),
              ),
              const SizedBox(height: 16),
              Text(
                'Payment recorded',
                style: AccountingTokens.sans(fontSize: 21, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 8),
              Text(
                _isInvoice
                    ? '${widget.doc.who} paid $currency ${money(_amount)}. The invoice is marked paid.'
                    : 'Paid $currency ${money(_amount)} to ${widget.doc.who}. The bill is settled.',
                textAlign: TextAlign.center,
                style: AccountingTokens.sans(fontSize: 13.5, color: AccountingTokens.ink3),
              ),
              const SizedBox(height: 20),
              AccountingButton(
                label: 'Done',
                primary: true,
                onPressed: () => widget.onPaid(widget.doc),
              ),
            ],
          ),
        ),
      );
    }

    return _ModalScrim(
      onClose: widget.onClose,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _PanelHeader(
            title: _isInvoice ? 'Record payment' : 'Pay bill',
            subtitle: '${widget.doc.id} · ${widget.doc.who} · ${money(total)} due',
            onClose: widget.onClose,
            compact: true,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _FieldLabel(
                  label: _isInvoice ? 'Deposit to' : 'Pay from',
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
                  label: 'Amount received',
                  child: TextFormField(
                    initialValue: money(_amount),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: _inputDecoration(prefix: currency),
                    onChanged: (v) {
                      final n = int.tryParse(v.replaceAll(RegExp(r'[^\d]'), '')) ?? 0;
                      setState(() => _amount = n);
                    },
                  ),
                ),
                const SizedBox(height: 16),
                _PostPreviewBox(
                  title: 'Posts as',
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
          _PanelFooter(
            children: [
              AccountingButton(label: 'Cancel', onPressed: widget.onClose),
              AccountingButton(
                label: _isInvoice ? 'Record payment' : 'Pay bill',
                icon: Icons.check,
                primary: true,
                enabled: _amount > 0,
                onPressed: _amount > 0
                    ? () async {
                        final businessId = ref.read(accountingBusinessIdProvider);
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
                        appendAuditLog(
                          ref,
                          action: 'recorded',
                          target: widget.doc.id,
                          detail: _isInvoice
                              ? 'Customer payment — ${widget.doc.who} ($currency ${money(_amount)})'
                              : 'Paid ${widget.doc.who} ($currency ${money(_amount)})',
                          iconName: 'ArrowDown',
                        );
                        setState(() => _done = true);
                      }
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
    final isInv = kind == DocKind.invoice;
    final totals = docTotals(doc.lines);
    final currency = ref.watch(accountingCurrencyProvider);
    final parties = isInv
        ? ref.watch(accountingCustomersProvider)
        : ref.watch(accountingSuppliersProvider);
    final party = parties.where((p) => p.name == doc.who).firstOrNull;
    final business = ref.watch(selectedBusinessProvider);

    return _ModalScrim(
      onClose: onClose,
      wide: true,
      child: Column(
        mainAxisSize: MainAxisSize.min,
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
          Padding(
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
                              business?.name ?? 'Business',
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
                        isInv ? 'INVOICE' : 'BILL',
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
                              isInv ? 'Bill to' : 'From',
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
                            label: isInv ? 'Issued' : 'Bill date',
                            value: doc.date,
                          ),
                          _PaperRow(label: 'Due', value: doc.due),
                          if (party != null)
                            _PaperRow(label: 'Terms', value: party.terms),
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
                          _Th('Description'),
                          _Th('Qty', right: true),
                          _Th('Unit price', right: true),
                          _Th('Amount', right: true),
                        ],
                      ),
                      for (final l in doc.lines)
                        TableRow(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Text(l.desc),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Text(
                                '${l.qty}',
                                textAlign: TextAlign.right,
                                style: AccountingTokens.mono(),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Text(
                                money((l.qty * l.price).round()),
                                textAlign: TextAlign.right,
                                style: AccountingTokens.mono(),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Text(
                                money((l.qty * l.price).round()),
                                textAlign: TextAlign.right,
                                style: AccountingTokens.mono(fontWeight: FontWeight.w700),
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
          _PanelFooter(
            children: [
              AccountingButton(
                label: 'PDF',
                icon: Icons.download_outlined,
                onPressed: () => showAccountingToast(
                  context,
                  'Generating PDF',
                  subtitle: '${doc.id} · ${doc.who}',
                  icon: Icons.download_outlined,
                ),
              ),
              AccountingButton(
                label: 'Edit',
                icon: Icons.receipt_long_outlined,
                onPressed: onEdit,
              ),
              if (doc.status != DocStatus.paid)
                AccountingButton(
                  label: isInv ? 'Record payment' : 'Pay bill',
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

class _PanelScrim extends StatelessWidget {
  const _PanelScrim({
    required this.onClose,
    required this.child,
    this.width,
  });

  final VoidCallback onClose;
  final Widget child;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: onClose,
          child: Container(color: const Color(0x8C081216)),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: Material(
            color: AccountingTokens.surface,
            child: SizedBox(
              width: (width ?? AccountingTokens.composerWidth).clamp(
                320,
                MediaQuery.sizeOf(context).width,
              ),
              height: MediaQuery.sizeOf(context).height,
              child: child,
            ),
          ),
        ),
      ],
    );
  }
}

class _ModalScrim extends StatelessWidget {
  const _ModalScrim({
    required this.onClose,
    required this.child,
    this.wide = false,
  });

  final VoidCallback onClose;
  final Widget child;
  final bool wide;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: onClose,
          child: Container(color: const Color(0x8C081216)),
        ),
        Center(
          child: Material(
            color: AccountingTokens.surface,
            borderRadius: BorderRadius.circular(AccountingTokens.radiusLg),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: wide ? 720 : 480,
                maxHeight: MediaQuery.sizeOf(context).height * 0.9,
              ),
              child: child,
            ),
          ),
        ),
      ],
    );
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
                  style: AccountingTokens.sans(fontSize: 18, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: AccountingTokens.sans(fontSize: 13, color: AccountingTokens.ink3),
                ),
              ],
            ),
          ),
          IconButton(onPressed: onClose, icon: const Icon(Icons.close, size: 18)),
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

InputDecoration _inputDecoration({IconData? icon, String? hint, String? prefix}) {
  return InputDecoration(
    hintText: hint,
    prefixText: prefix,
    prefixIcon: icon != null ? Icon(icon, size: 18, color: AccountingTokens.ink3) : null,
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
            decoration: _inputDecoration(hint: 'Item or service…'),
            onChanged: (v) => onChanged(line.copyWith(desc: v)),
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(
          width: 64,
          child: TextFormField(
            initialValue: '${line.qty}',
            keyboardType: TextInputType.number,
            decoration: _inputDecoration(),
            onChanged: (v) => onChanged(
              line.copyWith(qty: num.tryParse(v) ?? line.qty),
            ),
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(
          width: 110,
          child: TextFormField(
            initialValue: line.price > 0 ? money(line.price.round()) : '',
            keyboardType: TextInputType.number,
            decoration: _inputDecoration(),
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
              Text(title, style: AccountingTokens.sans(fontWeight: FontWeight.w700)),
            ],
          ),
          const SizedBox(height: 10),
          for (final p in lines)
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: p.side == 'dr'
                          ? AccountingTokens.accentTint
                          : AccountingTokens.gainTint,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      p.side.toUpperCase(),
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
              'Balanced · $currency ${money(total)} = ${money(total)}',
              style: AccountingTokens.sans(fontSize: 12, color: AccountingTokens.gainInk),
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
        _TotalRow(label: 'Subtotal', value: money(totals.subtotal)),
        _TotalRow(label: 'VAT (18%)', value: money(totals.vat)),
        const Divider(),
        _TotalRow(
          label: 'Total',
          value: '$currency ${money(totals.total)}',
          bold: true,
        ),
      ],
    );
  }
}

class _TotalRow extends StatelessWidget {
  const _TotalRow({required this.label, required this.value, this.bold = false});

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
          Text(label, style: AccountingTokens.sans(fontSize: 13, color: AccountingTokens.ink3)),
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
          Text('$label  ', style: AccountingTokens.sans(fontSize: 12, color: AccountingTokens.ink3)),
          Text(value, style: AccountingTokens.sans(fontSize: 12, fontWeight: FontWeight.w700)),
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
