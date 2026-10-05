import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_web/modules/accounting/data/accounting_backend_config.dart';
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

      // Edits carry the document id; only a new document is matched by
      // number, and a number already in use is refused rather than letting
      // the new bill overwrite (or merge into) another one.
      final AccountingDocument? existing;
      if (doc.uuid != null) {
        existing = docs.where((d) => d.uuid == doc.uuid).firstOrNull;
      } else {
        if (docs.any((d) => d.id == doc.id)) {
          if (context.mounted) {
            showAccountingToast(
              context,
              context.flipperL10n.booksDocAlreadyExists(doc.id),
              subtitle: context.flipperL10n.booksUseAnotherNumber,
              icon: Icons.error_outline,
            );
          }
          return;
        }
        existing = null;
      }
      final toSave = doc.copyWith(
        uuid: existing?.uuid,
        source: existing?.source,
        purchaseId: existing?.purchaseId,
      );
      await repo.upsertDocument(
        businessId: businessId,
        kind: ui.kind,
        doc: toSave,
      );

      final currency = ref.read(accountingCurrencyProvider);
      // Purchase and cashbook bills were posted by their own poster when they
      // were recorded; posting again here would book the debt twice.
      final postedElsewhere =
          toSave.source != null || toSave.purchaseId != null;
      if (mode == 'send' && !postedElsewhere) {
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

      final t = postedElsewhere
          ? docGrandTotal(toSave)
          : docTotals(doc.lines).total;
      close();
      if (!context.mounted) return;
      if (postedElsewhere) {
        // Its ledger entry belongs to the purchase/cashbook; nothing posted.
        showAccountingToast(
          context,
          context.flipperL10n.booksBillSaved,
          subtitle: '${doc.id} · ${doc.who} · $currency ${money(t)}',
          icon: Icons.check,
        );
      } else if (mode == 'draft') {
        showAccountingToast(
          context,
          context.flipperL10n.booksDraftSaved,
          subtitle: '${doc.id} · ${doc.who}',
        );
      } else if (isInvoice) {
        showAccountingToast(
          context,
          context.flipperL10n.booksInvoiceSentPosted,
          subtitle: '${doc.id} → ${doc.who} · $currency ${money(t)}',
          icon: Icons.mail_outline,
        );
      } else {
        showAccountingToast(
          context,
          context.flipperL10n.booksBillRecordedPosted,
          subtitle: '${doc.id} · ${doc.who} · $currency ${money(t)}',
          icon: Icons.check,
        );
      }
    }

    Future<void> markPaid(AccountingDocument doc) async {
      final businessId = ref.read(accountingBusinessIdProvider);
      if (businessId.isEmpty) return;
      // Ditto bills already updated their own paid/balance/status from the
      // payment record; overwriting the status here would hide a balance
      // still owed after a part payment.
      final paymentTracked =
          !isInvoice &&
          doc.uuid != null &&
          ref.read(accountingBackendStrategyProvider) ==
              AccountingBackendStrategy.ditto;
      if (paymentTracked) {
        close();
        return;
      }
      await repo.upsertDocument(
        businessId: businessId,
        kind: ui.kind,
        doc: doc.copyWith(status: DocStatus.paid),
      );
      close();
      if (!context.mounted) return;
      showAccountingToast(
        context,
        context.flipperL10n.booksPaymentRecorded,
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
              onEdit: () =>
                  open(BillingUiState(kind: ui.kind, editing: ui.preview)),
              onPay: () =>
                  open(BillingUiState(kind: ui.kind, paying: ui.preview)),
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
        DocTabFilter.sent =>
          d.status == DocStatus.sent || d.status == DocStatus.partiallyPaid,
        DocTabFilter.overdue => d.status == DocStatus.overdue,
        DocTabFilter.paid => d.status == DocStatus.paid,
      };
    }).toList();

    final outstanding = _docs
        .where(docIsOpen)
        .fold<int>(0, (s, d) => s + docBalance(d));
    final overdue = _docs
        .where((d) => docIsOpen(d) && d.status == DocStatus.overdue)
        .fold<int>(0, (s, d) => s + docBalance(d));
    final draftCount = _docs.where((d) => d.status == DocStatus.draft).length;
    final l10n = context.flipperL10n;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(28, 24, 28, 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AccountingPageHeader(
            eyebrow: _isInvoice ? l10n.sales : l10n.purchases,
            title: _isInvoice ? l10n.invoices : l10n.booksBills,
            subtitle: _isInvoice
                ? l10n.booksInvoicesSubtitle(currency)
                : l10n.booksBillsSubtitle(currency),
            actions: [
              PopupMenuButton<String>(
                offset: const Offset(0, 40),
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'xlsx',
                    child: Text(l10n.booksExcelWorkbook),
                  ),
                  PopupMenuItem(
                    value: 'pdf',
                    child: Text(l10n.booksPdfSummary),
                  ),
                ],
                onSelected: (v) => showAccountingToast(
                  context,
                  v == 'xlsx'
                      ? l10n.booksExportingExcel
                      : l10n.booksGeneratingPdf,
                  subtitle: _isInvoice
                      ? l10n.booksInvoicesCount(_docs.length)
                      : l10n.booksBillsCount(_docs.length),
                  icon: Icons.download_outlined,
                ),
                child: AccountingButton(
                  label: l10n.booksExport,
                  icon: Icons.download_outlined,
                ),
              ),
              AccountingButton(
                label: _isInvoice ? l10n.booksNewInvoice : l10n.booksNewBill,
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
                label: _isInvoice
                    ? l10n.booksOutstandingLabel
                    : l10n.booksOwedToSuppliers,
                value: outstanding,
                icon: AccIcon.receipt,
                tone: KpiTone.blue,
              ),
              AccountingKpiCard(
                label: l10n.booksStatusOverdue,
                value: overdue,
                icon: AccIcon.clock,
                tone: KpiTone.red,
              ),
              AccountingKpiCard(
                label: l10n.booksDrafts,
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
                        _docs.isEmpty
                            ? (_isInvoice
                                  ? l10n.booksNoInvoicesYet
                                  : l10n.booksNoBillsYet)
                            : (_isInvoice
                                  ? l10n.booksNoInvoicesInTab(_tabLabel(tab))
                                  : l10n.booksNoBillsInTab(_tabLabel(tab))),
                        style: AccountingTokens.sans(
                          color: AccountingTokens.ink3,
                        ),
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
                          label: Text(
                            _isInvoice ? l10n.invoice : l10n.booksBill,
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            _isInvoice ? l10n.customer : l10n.booksSupplier,
                          ),
                        ),
                        DataColumn(label: Text(l10n.sortCompactDate)),
                        DataColumn(label: Text(l10n.booksDue)),
                        DataColumn(label: Text(l10n.booksStatus)),
                        DataColumn(
                          label: Align(
                            alignment: Alignment.centerRight,
                            child: Text(l10n.amount),
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
                              DataCell(
                                Text(d.id, style: AccountingTokens.mono()),
                              ),
                              DataCell(Text(d.who)),
                              DataCell(
                                Text(
                                  d.date,
                                  style: AccountingTokens.sans(
                                    color: AccountingTokens.ink3,
                                  ),
                                ),
                              ),
                              DataCell(
                                Text(
                                  d.due,
                                  style: AccountingTokens.sans(
                                    color: AccountingTokens.ink3,
                                  ),
                                ),
                              ),
                              DataCell(DocStatusPill(status: d.status)),
                              DataCell(
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    money(docGrandTotal(d)),
                                    style: AccountingTokens.mono(
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ),
                              DataCell(
                                PopupMenuButton<String>(
                                  onSelected: (action) =>
                                      _onRowAction(action, d),
                                  itemBuilder: (context) => [
                                    PopupMenuItem(
                                      value: 'preview',
                                      child: Text(l10n.booksOpenPreview),
                                    ),
                                    PopupMenuItem(
                                      value: 'edit',
                                      child: Text(l10n.edit),
                                    ),
                                    if (_isInvoice
                                        ? d.status != DocStatus.paid
                                        : billCanBePaid(d))
                                      PopupMenuItem(
                                        value: 'pay',
                                        child: Text(
                                          _isInvoice
                                              ? l10n.booksRecordPayment
                                              : l10n.booksPayThisBill,
                                        ),
                                      ),
                                    if (_isInvoice &&
                                        d.status != DocStatus.paid)
                                      PopupMenuItem(
                                        value: 'remind',
                                        child: Text(l10n.booksSendReminder),
                                      ),
                                    PopupMenuItem(
                                      value: 'delete',
                                      child: Text(l10n.delete),
                                    ),
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
    DocTabFilter.all => context.flipperL10n.booksFilterAll,
    DocTabFilter.draft => context.flipperL10n.booksDraft,
    DocTabFilter.sent => context.flipperL10n.booksStatusSent,
    DocTabFilter.overdue => context.flipperL10n.booksStatusOverdue,
    DocTabFilter.paid => context.flipperL10n.booksStatusPaid,
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
          context.flipperL10n.booksReminderSent,
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
      docId: doc.uuid,
    );
    if (!mounted) return;
    showAccountingToast(
      context,
      context.flipperL10n.booksDeleted,
      subtitle: doc.id,
      icon: Icons.delete_outline,
    );
  }
}
