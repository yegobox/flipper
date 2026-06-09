import 'package:flipper_web/modules/accounting/data/accounting_derive.dart';
import 'package:flipper_web/modules/accounting/data/accounting_document_math.dart';
import 'package:flipper_web/modules/accounting/data/accounting_document_poster.dart';
import 'package:flipper_web/modules/accounting/data/accounting_providers.dart';
import 'package:flipper_web/modules/accounting/data/accounting_v3_models.dart';
import 'package:flipper_web/modules/accounting/data/accounting_v3_providers.dart';
import 'package:flipper_web/modules/accounting/data/repository/accounting_documents_repository.dart';
import 'package:flipper_web/modules/accounting/theme/accounting_tokens.dart';
import 'package:flipper_web/modules/accounting/widgets/accounting_icon.dart';
import 'package:flipper_web/modules/accounting/widgets/accounting_kpi_card.dart';
import 'package:flipper_web/modules/accounting/widgets/accounting_page_header.dart';
import 'package:flipper_web/modules/accounting/widgets/accounting_toast.dart';
import 'package:flipper_web/modules/accounting/widgets/doc_status_pill.dart';
import 'package:flipper_web/modules/accounting/widgets/v3_doc_panels.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AccountingInvoicesView extends ConsumerWidget {
  const AccountingInvoicesView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AccountingDocListView(kind: DocKind.invoice);
  }
}

class AccountingBillsView extends ConsumerWidget {
  const AccountingBillsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AccountingDocListView(kind: DocKind.bill);
  }
}

class AccountingDocListView extends ConsumerStatefulWidget {
  const AccountingDocListView({super.key, required this.kind});

  final DocKind kind;

  @override
  ConsumerState<AccountingDocListView> createState() =>
      _AccountingDocListViewState();
}

class _AccountingDocListViewState extends ConsumerState<AccountingDocListView> {
  AccountingDocument? _editing;
  bool _editingNew = false;
  String? _initialWho;
  AccountingDocument? _paying;
  AccountingDocument? _preview;

  bool get _isInvoice => widget.kind == DocKind.invoice;

  List<AccountingDocument> get _docs => _isInvoice
      ? ref.watch(accountingInvoicesProvider)
      : ref.watch(accountingBillsProvider);

  AccountingDocumentsRepository get _repo =>
      ref.read(accountingDocumentsRepositoryProvider);

  @override
  Widget build(BuildContext context) {
    ref.listen<PendingDocEditor?>(pendingDocEditorProvider, (prev, next) {
      if (next == null || next.kind != widget.kind) return;
      setState(() {
        _editingNew = true;
        _editing = null;
        _initialWho = next.who;
      });
      ref.read(pendingDocEditorProvider.notifier).state = null;
    });
    final tab = ref.watch(docTabFilterProvider);
    final currency = ref.watch(accountingCurrencyProvider);
    final list = _docs.where((d) {
      return switch (tab) {
        DocTabFilter.all => true,
        DocTabFilter.draft => d.status == DocStatus.draft,
        DocTabFilter.sent => d.status == DocStatus.sent,
        DocTabFilter.overdue => d.status == DocStatus.overdue,
        DocTabFilter.paid => d.status == DocStatus.paid,
      };
    }).toList();

    final outstanding = _docs
        .where((d) => d.status == DocStatus.sent || d.status == DocStatus.overdue)
        .fold<int>(0, (s, d) => s + docTotals(d.lines).total);
    final overdue = _docs
        .where((d) => d.status == DocStatus.overdue)
        .fold<int>(0, (s, d) => s + docTotals(d.lines).total);
    final draftCount = _docs.where((d) => d.status == DocStatus.draft).length;

    return Stack(
      children: [
        SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(28, 24, 28, 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AccountingPageHeader(
                eyebrow: _isInvoice ? 'Sales' : 'Purchases',
                title: _isInvoice ? 'Invoices' : 'Bills',
                subtitle: _isInvoice
                    ? 'Bill your customers and get paid · $currency'
                    : 'Track what you owe your suppliers · $currency',
                actions: [
                  PopupMenuButton<String>(
                    offset: const Offset(0, 40),
                    itemBuilder: (context) => const [
                      PopupMenuItem(value: 'xlsx', child: Text('Excel workbook (.xlsx)')),
                      PopupMenuItem(value: 'pdf', child: Text('PDF summary')),
                    ],
                    onSelected: (v) => showAccountingToast(
                      context,
                      v == 'xlsx' ? 'Exporting to Excel' : 'Generating PDF',
                      subtitle: '${_docs.length} ${_isInvoice ? 'invoices' : 'bills'}',
                      icon: Icons.download_outlined,
                    ),
                    child: const AccountingButton(
                      label: 'Export',
                      icon: Icons.download_outlined,
                    ),
                  ),
                  AccountingButton(
                    label: _isInvoice ? 'New invoice' : 'New bill',
                    icon: Icons.add,
                    primary: true,
                    onPressed: () => setState(() {
                      _editingNew = true;
                      _editing = null;
                    }),
                  ),
                ],
              ),
              AccountingKpiGrid(
                maxColumns: 3,
                children: [
                  AccountingKpiCard(
                    label: _isInvoice ? 'Outstanding' : 'Owed to suppliers',
                    value: outstanding,
                    icon: AccIcon.receipt,
                    tone: KpiTone.blue,
                  ),
                  AccountingKpiCard(
                    label: 'Overdue',
                    value: overdue,
                    icon: AccIcon.clock,
                    tone: KpiTone.red,
                  ),
                  AccountingKpiCard(
                    label: 'Drafts',
                    value: draftCount,
                    icon: AccIcon.receipt,
                    tone: KpiTone.amber,
                    currencyPrefix: false,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 6,
                children: [
                  for (final f in DocTabFilter.values)
                    ChoiceChip(
                      label: Text(_tabLabel(f)),
                      selected: tab == f,
                      onSelected: (_) =>
                          ref.read(docTabFilterProvider.notifier).state = f,
                    ),
                ],
              ),
              const SizedBox(height: 16),
              AccountingCard(
                child: list.isEmpty
                    ? Padding(
                        padding: const EdgeInsets.all(32),
                        child: Center(
                          child: Text(
                            'No ${_isInvoice ? 'invoices' : 'bills'} in "${_tabLabel(tab)}".',
                            style: AccountingTokens.sans(color: AccountingTokens.ink3),
                          ),
                        ),
                      )
                    : SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          headingRowHeight: 44,
                          dataRowMinHeight: 48,
                          columns: [
                            DataColumn(
                              label: Text(_isInvoice ? 'Invoice' : 'Bill'),
                            ),
                            DataColumn(label: Text(_isInvoice ? 'Customer' : 'Supplier')),
                            const DataColumn(label: Text('Date')),
                            const DataColumn(label: Text('Due')),
                            const DataColumn(label: Text('Status')),
                            const DataColumn(
                              label: Align(
                                alignment: Alignment.centerRight,
                                child: Text('Amount'),
                              ),
                            ),
                            const DataColumn(label: Text('')),
                          ],
                          rows: [
                            for (final d in list)
                              DataRow(
                                onSelectChanged: (_) => setState(() => _preview = d),
                                cells: [
                                  DataCell(Text(d.id, style: AccountingTokens.mono())),
                                  DataCell(Text(d.who)),
                                  DataCell(Text(d.date, style: AccountingTokens.sans(color: AccountingTokens.ink3))),
                                  DataCell(Text(d.due, style: AccountingTokens.sans(color: AccountingTokens.ink3))),
                                  DataCell(DocStatusPill(status: d.status)),
                                  DataCell(
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        money(docTotals(d.lines).total),
                                        style: AccountingTokens.mono(fontWeight: FontWeight.w700),
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    PopupMenuButton<String>(
                                      onSelected: (action) => _onRowAction(action, d),
                                      itemBuilder: (context) => [
                                        const PopupMenuItem(
                                          value: 'preview',
                                          child: Text('Open & preview'),
                                        ),
                                        const PopupMenuItem(value: 'edit', child: Text('Edit')),
                                        if (d.status != DocStatus.paid)
                                          PopupMenuItem(
                                            value: 'pay',
                                            child: Text(
                                              _isInvoice ? 'Record payment' : 'Pay this bill',
                                            ),
                                          ),
                                        if (_isInvoice && d.status != DocStatus.paid)
                                          const PopupMenuItem(
                                            value: 'remind',
                                            child: Text('Send reminder'),
                                          ),
                                        const PopupMenuItem(value: 'delete', child: Text('Delete')),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
              ),
            ],
          ),
        ),
        if (_editing != null || _editingNew)
          DocEditorPanel(
            kind: widget.kind,
            doc: _editing,
            newId: nextDocumentId(widget.kind, _docs),
            initialWho: _initialWho,
            onClose: () => setState(() {
              _editing = null;
              _editingNew = false;
              _initialWho = null;
            }),
            onSaved: _saveDoc,
          ),
        if (_paying != null)
          PaymentModalPanel(
            kind: widget.kind,
            doc: _paying!,
            onClose: () => setState(() => _paying = null),
            onPaid: _markPaid,
          ),
        if (_preview != null)
          DocPreviewPanel(
            kind: widget.kind,
            doc: _preview!,
            onClose: () => setState(() => _preview = null),
            onEdit: () => setState(() {
              _editing = _preview;
              _editingNew = false;
              _preview = null;
            }),
            onPay: () => setState(() {
              _paying = _preview;
              _preview = null;
            }),
          ),
      ],
    );
  }

  String _tabLabel(DocTabFilter f) => switch (f) {
        DocTabFilter.all => 'All',
        DocTabFilter.draft => 'Draft',
        DocTabFilter.sent => 'Sent',
        DocTabFilter.overdue => 'Overdue',
        DocTabFilter.paid => 'Paid',
      };

  void _onRowAction(String action, AccountingDocument d) {
    switch (action) {
      case 'preview':
        setState(() => _preview = d);
      case 'edit':
        setState(() {
          _editing = d;
          _editingNew = false;
        });
      case 'pay':
        setState(() => _paying = d);
      case 'remind':
        showAccountingToast(
          context,
          'Reminder sent',
          subtitle: '${d.who} · ${d.id}',
          icon: Icons.mail_outline,
        );
      case 'delete':
        _deleteDoc(d);
    }
  }

  Future<void> _deleteDoc(AccountingDocument doc) async {
    final businessId = ref.read(accountingBusinessIdProvider);
    if (businessId.isEmpty) return;
    await _repo.deleteDocument(
      businessId: businessId,
      kind: widget.kind,
      docNumber: doc.id,
    );
    if (!mounted) return;
    showAccountingToast(context, 'Deleted', subtitle: doc.id, icon: Icons.delete_outline);
  }

  Future<void> _saveDoc(AccountingDocument doc, String mode) async {
    final businessId = ref.read(accountingBusinessIdProvider);
    if (businessId.isEmpty) return;

    final existing = _docs.where((d) => d.id == doc.id).firstOrNull;
    final toSave = doc.copyWith(uuid: existing?.uuid);
    await _repo.upsertDocument(
      businessId: businessId,
      kind: widget.kind,
      doc: toSave,
    );

    final currency = ref.read(accountingCurrencyProvider);
    if (mode == 'send') {
      final businessId = ref.read(accountingBusinessIdProvider);
      final accounts = ref.read(accountingAccountsProvider);
      final poster = DocumentJournalPoster(
        ref.read(accountingLedgerRepositoryProvider),
        accounts,
      );
      if (_isInvoice) {
        await poster.postInvoiceSent(businessId: businessId, doc: doc);
      } else {
        await poster.postBillRecorded(businessId: businessId, doc: doc);
      }
      appendAuditLog(
        ref,
        action: 'created',
        target: doc.id,
        detail: _isInvoice
            ? 'Invoice to ${doc.who} ($currency ${money(docTotals(doc.lines).total)})'
            : 'Bill from ${doc.who}',
        iconName: 'Receipt',
        tone: AuditTone.blue,
      );
    }

    final t = docTotals(doc.lines).total;
    if (!mounted) return;
    if (mode == 'draft') {
      showAccountingToast(context, 'Draft saved', subtitle: '${doc.id} · ${doc.who}');
    } else if (_isInvoice) {
      showAccountingToast(
        context,
        'Invoice sent & posted',
        subtitle: '${doc.id} → ${doc.who} · $currency ${money(t)}',
        icon: Icons.mail_outline,
      );
    } else {
      showAccountingToast(
        context,
        'Bill recorded & posted',
        subtitle: '${doc.id} · ${doc.who} · $currency ${money(t)}',
        icon: Icons.check,
      );
    }
    setState(() {
      _editing = null;
      _editingNew = false;
      _initialWho = null;
    });
  }

  Future<void> _markPaid(AccountingDocument doc) async {
    final businessId = ref.read(accountingBusinessIdProvider);
    if (businessId.isEmpty) return;
    await _repo.upsertDocument(
      businessId: businessId,
      kind: widget.kind,
      doc: doc.copyWith(status: DocStatus.paid),
    );
    if (!mounted) return;
    setState(() => _paying = null);
    showAccountingToast(
      context,
      'Payment recorded',
      subtitle: doc.id,
      icon: Icons.check,
    );
  }
}
