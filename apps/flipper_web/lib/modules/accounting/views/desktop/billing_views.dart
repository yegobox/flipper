import 'package:flipper_web/modules/accounting/data/accounting_derive.dart';
import 'package:flipper_web/modules/accounting/data/accounting_document_math.dart';
import 'package:flipper_web/modules/accounting/data/accounting_document_poster.dart';
import 'package:flipper_web/modules/accounting/data/accounting_providers.dart';
import 'package:flipper_web/modules/accounting/data/accounting_v3_models.dart';
import 'package:flipper_web/modules/accounting/data/accounting_v3_providers.dart';
import 'package:flipper_web/modules/accounting/data/repository/accounting_documents_repository.dart';
import 'package:flipper_web/modules/accounting/routing/accounting_route.dart';
import 'package:flipper_web/modules/accounting/theme/accounting_tokens.dart';
import 'package:flipper_web/modules/accounting/widgets/accounting_icon.dart';
import 'package:flipper_web/modules/accounting/widgets/accounting_kpi_card.dart';
import 'package:flipper_web/modules/accounting/widgets/accounting_page_header.dart';
import 'package:flipper_web/modules/accounting/widgets/accounting_toast.dart';
import 'package:flipper_web/modules/accounting/widgets/doc_status_pill.dart';
import 'package:flipper_web/modules/accounting/widgets/v3_doc_panels.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Invoice/bill editor, preview, and payment panels at the shell right edge.
class AccountingBillingPanelHost extends ConsumerWidget {
  const AccountingBillingPanelHost({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(accountingViewProvider, (_, view) {
      if (view != AccountingView.invoices && view != AccountingView.bills) {
        ref.read(billingUiProvider.notifier).state = null;
      }
    });

    final ui = ref.watch(billingUiProvider);
    if (ui == null) return const SizedBox.shrink();

    final docs = ui.kind == DocKind.invoice
        ? ref.watch(accountingInvoicesProvider)
        : ref.watch(accountingBillsProvider);
    final repo = ref.read(accountingDocumentsRepositoryProvider);
    final isInvoice = ui.kind == DocKind.invoice;

    void close() => ref.read(billingUiProvider.notifier).state = null;

    void open(BillingUiState state) =>
        ref.read(billingUiProvider.notifier).state = state;

    Future<void> saveDoc(AccountingDocument doc, String mode) async {
      final businessId = ref.read(accountingBusinessIdProvider);
      if (businessId.isEmpty) return;

      final existing = docs.where((d) => d.id == doc.id).firstOrNull;
      final toSave = doc.copyWith(uuid: existing?.uuid);
      await repo.upsertDocument(
        businessId: businessId,
        kind: ui.kind,
        doc: toSave,
      );

      final currency = ref.read(accountingCurrencyProvider);
      if (mode == 'send') {
        final accounts = ref.read(accountingAccountsProvider);
        final poster = DocumentJournalPoster(
          ref.read(accountingLedgerRepositoryProvider),
          accounts,
        );
        if (isInvoice) {
          await poster.postInvoiceSent(businessId: businessId, doc: doc);
        } else {
          await poster.postBillRecorded(businessId: businessId, doc: doc);
        }
        appendAuditLog(
          ref,
          action: 'created',
          target: doc.id,
          detail: isInvoice
              ? 'Invoice to ${doc.who} ($currency ${money(docTotals(doc.lines).total)})'
              : 'Bill from ${doc.who}',
          iconName: 'Receipt',
          tone: AuditTone.blue,
        );
      }

      final t = docTotals(doc.lines).total;
      close();
      if (!context.mounted) return;
      if (mode == 'draft') {
        showAccountingToast(context, 'Draft saved', subtitle: '${doc.id} · ${doc.who}');
      } else if (isInvoice) {
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
    }

    Future<void> markPaid(AccountingDocument doc) async {
      final businessId = ref.read(accountingBusinessIdProvider);
      if (businessId.isEmpty) return;
      await repo.upsertDocument(
        businessId: businessId,
        kind: ui.kind,
        doc: doc.copyWith(status: DocStatus.paid),
      );
      close();
      if (!context.mounted) return;
      showAccountingToast(
        context,
        'Payment recorded',
        subtitle: doc.id,
        icon: Icons.check,
      );
    }

    return Stack(
      clipBehavior: Clip.none,
      children: [
        if (ui.editing != null || ui.editingNew)
          Positioned(
            top: 0,
            right: 0,
            bottom: 0,
            child: DocEditorPanel(
              kind: ui.kind,
              doc: ui.editing,
              newId: nextDocumentId(ui.kind, docs),
              initialWho: ui.initialWho,
              onClose: close,
              onSaved: saveDoc,
            ),
          ),
        if (ui.paying != null)
          Positioned(
            top: 0,
            right: 0,
            bottom: 0,
            child: PaymentModalPanel(
              kind: ui.kind,
              doc: ui.paying!,
              onClose: close,
              onPaid: markPaid,
            ),
          ),
        if (ui.preview != null)
          Positioned(
            top: 0,
            right: 0,
            bottom: 0,
            child: DocPreviewPanel(
              kind: ui.kind,
              doc: ui.preview!,
              onClose: close,
              onEdit: () => open(
                BillingUiState(kind: ui.kind, editing: ui.preview),
              ),
              onPay: () => open(
                BillingUiState(kind: ui.kind, paying: ui.preview),
              ),
            ),
          ),
      ],
    );
  }
}

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
  bool get _isInvoice => widget.kind == DocKind.invoice;

  List<AccountingDocument> get _docs => _isInvoice
      ? ref.watch(accountingInvoicesProvider)
      : ref.watch(accountingBillsProvider);

  AccountingDocumentsRepository get _repo =>
      ref.read(accountingDocumentsRepositoryProvider);

  void _openBilling(BillingUiState state) {
    ref.read(billingUiProvider.notifier).state = state;
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<PendingDocEditor?>(pendingDocEditorProvider, (prev, next) {
      if (next == null || next.kind != widget.kind) return;
      _openBilling(
        BillingUiState(
          kind: widget.kind,
          editingNew: true,
          initialWho: next.who,
        ),
      );
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

    return SingleChildScrollView(
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
                    onPressed: () => _openBilling(
                      BillingUiState(kind: widget.kind, editingNew: true),
                    ),
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
                                onSelectChanged: (_) => _openBilling(
                                  BillingUiState(kind: widget.kind, preview: d),
                                ),
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
        _openBilling(BillingUiState(kind: widget.kind, preview: d));
      case 'edit':
        _openBilling(BillingUiState(kind: widget.kind, editing: d));
      case 'pay':
        _openBilling(BillingUiState(kind: widget.kind, paying: d));
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

}
