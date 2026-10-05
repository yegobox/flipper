import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_models/domain/party/party_draft.dart';
import 'package:flipper_models/domain/party/party_validation.dart';
import 'package:flipper_web/core/supabase_provider.dart';
import 'package:flipper_web/modules/accounting/data/accounting_derive.dart';
import 'package:flipper_web/modules/accounting/data/accounting_document_math.dart';
import 'package:flipper_web/modules/accounting/data/accounting_providers.dart';
import 'package:flipper_web/modules/accounting/data/accounting_v3_models.dart';
import 'package:flipper_web/modules/accounting/data/accounting_v3_providers.dart';
import 'package:flipper_web/modules/accounting/data/party_backfill.dart';
import 'package:flipper_web/modules/accounting/data/party_contact_service.dart';
import 'package:flipper_web/modules/accounting/data/party_models.dart';
import 'package:flipper_web/modules/accounting/routing/accounting_route.dart';
import 'package:flipper_web/modules/accounting/theme/accounting_tokens.dart';
import 'package:flipper_web/modules/accounting/widgets/accounting_data_table.dart';
import 'package:flipper_web/modules/accounting/widgets/accounting_icon.dart';
import 'package:flipper_web/modules/accounting/widgets/accounting_icon_button.dart';
import 'package:flipper_web/modules/accounting/widgets/accounting_inline_search.dart';
import 'package:flipper_web/modules/accounting/widgets/accounting_kpi_card.dart';
import 'package:flipper_web/modules/accounting/widgets/accounting_page_header.dart';
import 'package:flipper_web/modules/accounting/widgets/accounting_tag.dart';
import 'package:flipper_web/modules/accounting/widgets/accounting_toast.dart';
import 'package:flipper_web/modules/accounting/widgets/doc_status_pill.dart';
import 'package:flipper_web/services/ditto_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

/// Renders contact drawers flush to the main-column right edge (not content max-width).
class AccountingContactsDrawerHost extends ConsumerWidget {
  const AccountingContactsDrawerHost({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(accountingViewProvider, (_, view) {
      if (view != AccountingView.customers &&
          view != AccountingView.suppliers) {
        ref.read(contactsUiProvider.notifier).state = null;
      }
    });

    final ui = ref.watch(contactsUiProvider);
    if (ui == null) return const SizedBox.shrink();

    final docs = ui.isCustomer
        ? ref.watch(accountingInvoicesProvider)
        : ref.watch(accountingBillsProvider);
    final currency = ref.watch(accountingCurrencyProvider);

    void close() => ref.read(contactsUiProvider.notifier).state = null;

    Future<void> saveContact(AccountingContact contact) async {
      final businessId = ref.read(accountingBusinessIdProvider);
      if (businessId.isEmpty) return;
      final branchId = ref.read(partyBranchIdProvider);
      if (branchId.isEmpty) return;

      final saved = ui.isCustomer
          ? ref.read(customersStreamProvider).value ?? []
          : ref.read(suppliersStreamProvider).value ?? [];
      await savePartyContactWithBranch(
        partyRepository: ref.read(partyRepositoryProvider),
        documentsRepository: ref.read(accountingDocumentsRepositoryProvider),
        businessId: businessId,
        branchId: branchId,
        isCustomer: ui.isCustomer,
        contact: contact,
        existingContactCount: saved.length,
      );
      close();
      if (!context.mounted) return;
      showAccountingToast(
        context,
        ui.isCustomer
            ? context.flipperL10n.booksCustomerAdded
            : context.flipperL10n.booksSupplierAdded,
        subtitle: contact.name,
        accIcon: AccIcon.check,
        tone: AccountingToastTone.success,
      );
    }

    void openDocForContact(AccountingContact person) {
      close();
      ref.read(accountingViewProvider.notifier).state = ui.isCustomer
          ? AccountingView.invoices
          : AccountingView.bills;
      ref.read(pendingDocEditorProvider.notifier).state = PendingDocEditor(
        kind: ui.isCustomer ? DocKind.invoice : DocKind.bill,
        who: person.name,
      );
    }

    return Stack(
      clipBehavior: Clip.none,
      children: [
        if (ui.detailContact != null)
          Positioned(
            top: 0,
            right: 0,
            bottom: 0,
            child: _ContactDetailDrawer(
              isCustomer: ui.isCustomer,
              person: ui.detailContact!,
              docs: docs.where((d) => d.who == ui.detailContact!.name).toList(),
              currency: currency,
              onClose: close,
              onNewDoc: () => openDocForContact(ui.detailContact!),
            ),
          ),
        if (ui.showCreateForm)
          Positioned(
            top: 0,
            right: 0,
            bottom: 0,
            child: _ContactFormDrawer(
              isCustomer: ui.isCustomer,
              onClose: close,
              onSave: saveContact,
            ),
          ),
      ],
    );
  }
}

class AccountingCustomersView extends ConsumerWidget {
  const AccountingCustomersView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AccountingContactsView(isCustomer: true);
  }
}

class AccountingSuppliersView extends ConsumerWidget {
  const AccountingSuppliersView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AccountingContactsView(isCustomer: false);
  }
}

class AccountingContactsView extends ConsumerStatefulWidget {
  const AccountingContactsView({super.key, required this.isCustomer});

  final bool isCustomer;

  @override
  ConsumerState<AccountingContactsView> createState() =>
      _AccountingContactsViewState();
}

class _AccountingContactsViewState
    extends ConsumerState<AccountingContactsView> {
  String _query = '';

  @override
  void initState() {
    super.initState();
    // One-time reconciler: push canonical Supabase party rows missing from
    // Ditto (migrated rows / failed dual-writes) so POS live lists see them.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final branchId = ref.read(partyBranchIdProvider);
      if (branchId.isEmpty) return;
      PartyBackfill(
        ref.read(supabaseProvider),
        ref.read(dittoServiceProvider),
      ).run(branchId: branchId);
    });
  }

  void _openDetail(AccountingContact contact) {
    ref.read(contactsUiProvider.notifier).state = ContactsUiState(
      isCustomer: widget.isCustomer,
      detailContact: contact,
    );
  }

  void _openCreate() {
    ref.read(contactsUiProvider.notifier).state = ContactsUiState(
      isCustomer: widget.isCustomer,
      showCreateForm: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    final people = widget.isCustomer
        ? ref.watch(accountingCustomersProvider)
        : ref.watch(accountingSuppliersProvider);
    final ql = _query.trim().toLowerCase();
    final list = people
        .where(
          (p) =>
              ql.isEmpty ||
              '${p.name} ${p.contact} ${p.email}'.toLowerCase().contains(ql),
        )
        .toList();
    final totalBal = people.fold<int>(0, (s, p) => s + p.balance);
    final owing = people.where((p) => p.balance > 0).length;
    final l10n = context.flipperL10n;
    final isCustomer = widget.isCustomer;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(28, 24, 28, 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AccountingPageHeader(
            eyebrow: isCustomer ? l10n.sales : l10n.purchases,
            title: isCustomer ? l10n.customers : l10n.booksSuppliers,
            subtitle: isCustomer
                ? l10n.booksCustomersSubtitle('${people.length}')
                : l10n.booksSuppliersSubtitle('${people.length}'),
            actions: [
              AccountingInlineSearch(
                hintText: isCustomer
                    ? l10n.booksSearchCustomers
                    : l10n.booksSearchSuppliers,
                onChanged: (v) => setState(() => _query = v),
              ),
              AccountingButton(
                label: isCustomer
                    ? l10n.booksNewCustomer
                    : l10n.booksNewSupplier,
                accIcon: AccIcon.plus,
                primary: true,
                onPressed: _openCreate,
              ),
            ],
          ),
          AccountingKpiGrid(
            maxColumns: 3,
            children: [
              AccountingKpiCard(
                label: isCustomer
                    ? l10n.booksTotalCustomers
                    : l10n.booksTotalSuppliers,
                textValue: '${people.length}',
                icon: AccIcon.users,
                tone: KpiTone.blue,
                currencyPrefix: false,
              ),
              AccountingKpiCard(
                label: isCustomer
                    ? l10n.booksWithOpenBalance
                    : l10n.booksWithBillsDue,
                textValue: '$owing',
                icon: AccIcon.receipt,
                tone: KpiTone.amber,
                currencyPrefix: false,
              ),
              AccountingKpiCard(
                label: isCustomer
                    ? l10n.booksTotalReceivable
                    : l10n.booksTotalPayable,
                value: totalBal,
                icon: AccIcon.wallet,
                tone: KpiTone.green,
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (list.isEmpty)
            AccountingCard(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Center(
                  child: Text(
                    ql.isEmpty
                        ? (isCustomer
                              ? l10n.booksNoCustomersYet
                              : l10n.booksNoSuppliersYet)
                        : l10n.booksNoMatchesFor(_query),
                    style: AccountingTokens.sans(color: AccountingTokens.ink3),
                  ),
                ),
              ),
            )
          else
            AccountingDataTable(
              columns: [
                AccountingTableColumn(
                  label: isCustomer ? l10n.customer : l10n.booksSupplier,
                ),
                AccountingTableColumn(label: l10n.booksContact),
                AccountingTableColumn(label: l10n.phone),
                AccountingTableColumn(label: l10n.booksTerms),
                AccountingTableColumn(
                  label: isCustomer ? l10n.booksOwesYou : l10n.booksYouOwe,
                  align: TextAlign.right,
                ),
                const AccountingTableColumn(label: '', width: 52),
              ],
              onRowTap: (i) => _openDetail(list[i]),
              rowTapExcludeTrailingColumns: 1,
              rows: [
                for (final p in list)
                  [
                    _ContactCell(person: p, isCustomer: widget.isCustomer),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          p.contact,
                          style: AccountingTokens.sans(fontSize: 13),
                        ),
                        if (p.email.isNotEmpty)
                          Text(
                            p.email,
                            style: AccountingTokens.sans(
                              fontSize: 11.5,
                              color: AccountingTokens.ink3,
                            ),
                          ),
                      ],
                    ),
                    Text(
                      p.phone.isEmpty ? '—' : p.phone,
                      style: AccountingTokens.mono(
                        fontSize: 13.5,
                        color: AccountingTokens.ink3,
                      ),
                    ),
                    AccountingTag(label: p.terms),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        p.balance > 0 ? money(p.balance) : '—',
                        style: AccountingTokens.mono(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w700,
                          color: p.balance > 0
                              ? AccountingTokens.ink1
                              : AccountingTokens.ink4,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: PopupMenuButton<String>(
                        padding: EdgeInsets.zero,
                        offset: const Offset(0, 36),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        onSelected: (a) => _onMenu(a, p),
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            value: 'view',
                            child: Text(l10n.booksViewRecord),
                          ),
                          PopupMenuItem(
                            value: 'statement',
                            child: Text(l10n.booksSendStatement),
                          ),
                          PopupMenuItem(
                            value: 'call',
                            child: Text(l10n.booksCallContact),
                          ),
                          if (!p.fromAging)
                            PopupMenuItem(
                              value: 'delete',
                              child: Text(l10n.delete),
                            ),
                        ],
                        child: AccountingIconButton(
                          small: true,
                          icon: AccIcon.more,
                        ),
                      ),
                    ),
                  ],
              ],
            ),
        ],
      ),
    );
  }

  void _onMenu(String action, AccountingContact p) {
    switch (action) {
      case 'view':
        _openDetail(p);
      case 'statement':
        showAccountingToast(
          context,
          context.flipperL10n.booksStatementSent,
          subtitle: '${p.name} · ${p.email.isNotEmpty ? p.email : p.phone}',
          accIcon: AccIcon.mail,
          tone: AccountingToastTone.success,
        );
      case 'call':
        showAccountingToast(
          context,
          p.contact,
          subtitle: p.phone.isNotEmpty
              ? p.phone
              : context.flipperL10n.booksNoPhoneOnFile,
          accIcon: AccIcon.phone,
        );
      case 'delete':
        _deleteContact(p);
    }
  }

  Future<void> _deleteContact(AccountingContact contact) async {
    if (contact.fromAging) return;
    if (contact.uuid == null && contact.partyId == null) return;
    final businessId = ref.read(accountingBusinessIdProvider);
    if (businessId.isEmpty) return;

    // Canonical party rows are shared with the POS app (transactions
    // reference them via customerId) — deleting one needs explicit consent.
    var deleteParty = false;
    if (contact.partyId != null) {
      deleteParty =
          await showDialog<bool>(
            context: context,
            builder: (ctx) => AlertDialog(
              title: Text(ctx.flipperL10n.booksDeleteNamed(contact.name)),
              content: Text(ctx.flipperL10n.booksDeleteSharedContactBody),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(false),
                  child: Text(ctx.flipperL10n.cancel),
                ),
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(true),
                  child: Text(ctx.flipperL10n.booksDeleteEverywhere),
                ),
              ],
            ),
          ) ??
          false;
      if (!deleteParty) return;
    }

    if (contact.uuid != null) {
      await ref
          .read(accountingDocumentsRepositoryProvider)
          .deleteContact(businessId: businessId, contactId: contact.uuid!);
    }
    if (deleteParty && contact.partyId != null) {
      await ref
          .read(partyRepositoryProvider)
          .deleteParty(
            id: contact.partyId!,
            kind: widget.isCustomer ? PartyKind.customer : PartyKind.supplier,
          );
    }
    if (!mounted) return;
    showAccountingToast(
      context,
      context.flipperL10n.booksDeleted,
      subtitle: contact.name,
    );
  }
}

class _ContactCell extends StatelessWidget {
  const _ContactCell({required this.person, required this.isCustomer});

  final AccountingContact person;
  final bool isCustomer;

  @override
  Widget build(BuildContext context) {
    final initials = person.name.length >= 2
        ? person.name.substring(0, 2).toUpperCase()
        : person.name.toUpperCase();
    final sinceText = isCustomer
        ? context.flipperL10n.booksCustomerSince(person.since)
        : context.flipperL10n.booksSupplierSince(person.since);
    return Row(
      children: [
        _ContactAvatar(initials: initials, isCustomer: isCustomer),
        const SizedBox(width: 11),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                person.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AccountingTokens.sans(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                sinceText,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AccountingTokens.sans(
                  fontSize: 11.5,
                  color: AccountingTokens.ink3,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ContactDetailDrawer extends StatelessWidget {
  const _ContactDetailDrawer({
    required this.isCustomer,
    required this.person,
    required this.docs,
    required this.currency,
    required this.onClose,
    required this.onNewDoc,
  });

  final bool isCustomer;
  final AccountingContact person;
  final List<AccountingDocument> docs;
  final String currency;
  final VoidCallback onClose;
  final VoidCallback onNewDoc;

  @override
  Widget build(BuildContext context) {
    final lifetime = docs.fold<int>(0, (s, d) => s + docTotals(d.lines).total);
    final l10n = context.flipperL10n;
    final sinceText = isCustomer
        ? l10n.booksCustomerSince(person.since)
        : l10n.booksSupplierSince(person.since);
    final initials = person.name.length >= 2
        ? person.name.substring(0, 2).toUpperCase()
        : person.name.toUpperCase();

    return Container(
      width: 540,
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 22, 16, 22),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _ContactAvatar(
                  initials: initials,
                  isCustomer: isCustomer,
                  large: true,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        person.name,
                        style: AccountingTokens.sans(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.02,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        '$sinceText · ${booksTermsLabel(person.terms, l10n)}',
                        style: AccountingTokens.sans(
                          fontSize: 12.5,
                          color: AccountingTokens.ink3,
                        ),
                      ),
                    ],
                  ),
                ),
                AccountingIconButton(icon: AccIcon.x, onPressed: onClose),
              ],
            ),
          ),
          const Divider(height: 1, color: AccountingTokens.line),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 22, 24, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _MiniStat(
                          label: isCustomer
                              ? l10n.booksOutstandingBalance
                              : l10n.booksAmountPayable,
                          value: '$currency ${money(person.balance)}',
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _MiniStat(
                          label: isCustomer
                              ? l10n.booksLifetimeBilled
                              : l10n.booksLifetimePurchased,
                          value: '$currency ${money(lifetime)}',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 22),
                  Text(
                    l10n.booksContactDetails,
                    style: AccountingTokens.sans(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.7,
                      color: AccountingTokens.ink4,
                    ),
                  ),
                  const SizedBox(height: 10),
                  _IconDetailRow(
                    icon: AccIcon.user,
                    label: l10n.booksPrimaryContact,
                    value: person.contact,
                  ),
                  _IconDetailRow(
                    icon: AccIcon.mail,
                    label: l10n.email,
                    value: person.email.isEmpty ? '—' : person.email,
                  ),
                  _IconDetailRow(
                    icon: AccIcon.phone,
                    label: l10n.phone,
                    value: person.phone.isEmpty ? '—' : person.phone,
                    mono: true,
                  ),
                  _IconDetailRow(
                    icon: AccIcon.shieldCheck,
                    label: l10n.tin,
                    value: person.tin.isEmpty ? '—' : person.tin,
                    mono: true,
                  ),
                  const SizedBox(height: 22),
                  Text(
                    isCustomer
                        ? l10n.booksInvoicesHeader('${docs.length}')
                        : l10n.booksBillsHeader('${docs.length}'),
                    style: AccountingTokens.sans(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.7,
                      color: AccountingTokens.ink4,
                    ),
                  ),
                  const SizedBox(height: 10),
                  if (docs.isEmpty)
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: AccountingTokens.surface2,
                        borderRadius: BorderRadius.circular(
                          AccountingTokens.radiusMd,
                        ),
                      ),
                      child: Text(
                        l10n.booksNoDocumentsYet,
                        style: AccountingTokens.sans(
                          color: AccountingTokens.ink3,
                        ),
                      ),
                    )
                  else
                    _DrawerDocsTable(isCustomer: isCustomer, docs: docs),
                ],
              ),
            ),
          ),
          const Divider(height: 1, color: AccountingTokens.line),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
            child: Row(
              children: [
                Expanded(
                  child: AccountingButton(
                    label: l10n.booksSendStatement,
                    accIcon: AccIcon.mail,
                    onPressed: () => showAccountingToast(
                      context,
                      l10n.booksStatementSent,
                      subtitle:
                          '${person.name} · ${person.email.isNotEmpty ? person.email : person.phone}',
                      accIcon: AccIcon.mail,
                      tone: AccountingToastTone.success,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: AccountingButton(
                    label: isCustomer
                        ? l10n.booksNewInvoice
                        : l10n.booksNewBill,
                    accIcon: AccIcon.plus,
                    primary: true,
                    onPressed: onNewDoc,
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

class _ContactAvatar extends StatelessWidget {
  const _ContactAvatar({
    required this.initials,
    required this.isCustomer,
    this.large = false,
  });

  final String initials;
  final bool isCustomer;
  final bool large;

  @override
  Widget build(BuildContext context) {
    final size = large ? 50.0 : 36.0;
    final radius = large ? 14.0 : 10.0;
    final fontSize = large ? 16.0 : 12.5;
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        gradient: isCustomer
            ? AccountingTokens.brandGradient
            : const LinearGradient(
                colors: [Color(0xFF0D9488), Color(0xFF0F766E)],
              ),
        borderRadius: BorderRadius.circular(radius),
      ),
      child: Text(
        initials,
        style: AccountingTokens.mono(
          fontSize: fontSize,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
    );
  }
}

class _IconDetailRow extends StatelessWidget {
  const _IconDetailRow({
    required this.icon,
    required this.label,
    required this.value,
    this.mono = false,
  });

  final AccIcon icon;
  final String label;
  final String value;
  final bool mono;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 9),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AccountingTokens.line)),
      ),
      child: Row(
        children: [
          AccountingIcon(icon: icon, size: 16, color: AccountingTokens.ink3),
          const SizedBox(width: 12),
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: AccountingTokens.sans(
                fontSize: 13,
                color: AccountingTokens.ink3,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: (mono ? AccountingTokens.mono : AccountingTokens.sans)(
                fontSize: 13.5,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  const _MiniStat({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AccountingTokens.surface2,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AccountingTokens.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AccountingTokens.sans(
              fontSize: 11,
              color: AccountingTokens.ink3,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: AccountingTokens.mono(fontWeight: FontWeight.w800),
          ),
        ],
      ),
    );
  }
}

class _DrawerDocsTable extends StatelessWidget {
  const _DrawerDocsTable({required this.isCustomer, required this.docs});

  final bool isCustomer;
  final List<AccountingDocument> docs;

  @override
  Widget build(BuildContext context) {
    return Table(
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      columnWidths: const {
        0: FlexColumnWidth(1.2),
        1: FlexColumnWidth(1.1),
        2: FlexColumnWidth(0.9),
        3: FlexColumnWidth(0.8),
      },
      children: [
        TableRow(
          decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: AccountingTokens.line)),
          ),
          children: [
            for (final label in [
              isCustomer
                  ? context.flipperL10n.invoice
                  : context.flipperL10n.booksBill,
              context.flipperL10n.sortCompactDate,
              context.flipperL10n.booksStatus,
              context.flipperL10n.amount,
            ])
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 8, 8, 8),
                child: Text(
                  label.toUpperCase(),
                  style: AccountingTokens.tableHead,
                ),
              ),
          ],
        ),
        for (final d in docs)
          TableRow(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 8, 10),
                child: Text(d.id, style: AccountingTokens.mono(fontSize: 12)),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 8, 10),
                child: Text(
                  d.date,
                  style: AccountingTokens.sans(
                    fontSize: 13,
                    color: AccountingTokens.ink3,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 8, 10),
                child: DocStatusPill(status: d.status),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    money(docTotals(d.lines).total),
                    style: AccountingTokens.mono(fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ],
          ),
      ],
    );
  }
}

class _ContactFormDrawer extends StatefulWidget {
  const _ContactFormDrawer({
    required this.isCustomer,
    required this.onClose,
    required this.onSave,
  });

  final bool isCustomer;
  final VoidCallback onClose;
  final void Function(AccountingContact contact) onSave;

  @override
  State<_ContactFormDrawer> createState() => _ContactFormDrawerState();
}

class _ContactFormDrawerState extends State<_ContactFormDrawer> {
  final _name = TextEditingController();
  final _contact = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  final _tin = TextEditingController();
  String _terms = 'Net 30';

  @override
  void initState() {
    super.initState();
    for (final c in [_name, _contact, _email, _phone, _tin]) {
      c.addListener(_onFieldChanged);
    }
  }

  void _onFieldChanged() => setState(() {});

  @override
  void dispose() {
    for (final c in [_name, _contact, _email, _phone, _tin]) {
      c
        ..removeListener(_onFieldChanged)
        ..dispose();
    }
    super.dispose();
  }

  /// First failing shared-domain validation (same rules/messages as the POS
  /// AddCustomer form), or null when the canonical fields are valid.
  String? get _validationError =>
      validatePartyName(_name.text, isBusiness: true) ??
      validatePartyPhone(_phone.text) ??
      validatePartyEmail(_email.text.trim()) ??
      validatePartyTin(_tin.text);

  bool get _ok => _validationError == null && _contact.text.trim().isNotEmpty;

  /// Show the error only once the user has started typing.
  bool get _showError =>
      _validationError != null &&
      (_name.text.isNotEmpty ||
          _phone.text.isNotEmpty ||
          _email.text.isNotEmpty ||
          _tin.text.isNotEmpty);

  void _submit() {
    if (!_ok) return;
    widget.onSave(
      AccountingContact(
        id: 'new',
        name: _name.text.trim(),
        contact: _contact.text.trim(),
        email: _email.text.trim(),
        phone: _phone.text.trim(),
        tin: _tin.text.trim(),
        since: DateFormat('MMM y').format(DateTime.now()),
        terms: _terms,
        balance: 0,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.flipperL10n;
    final isCustomer = widget.isCustomer;
    final nameLabel = isCustomer
        ? l10n.booksBusinessCustomerName
        : l10n.booksSupplierName;

    return Container(
      width: 540,
      decoration: BoxDecoration(
        color: AccountingTokens.surface,
        border: const Border(left: BorderSide(color: AccountingTokens.line)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x33081216),
            blurRadius: 60,
            offset: Offset(-24, 0),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 22, 16, 22),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isCustomer
                            ? l10n.booksNewCustomer
                            : l10n.booksNewSupplier,
                        style: AccountingTokens.sans(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.02,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        isCustomer
                            ? l10n.booksAddCustomerToContacts
                            : l10n.booksAddSupplierToContacts,
                        style: AccountingTokens.sans(
                          fontSize: 12.5,
                          color: AccountingTokens.ink3,
                        ),
                      ),
                    ],
                  ),
                ),
                AccountingIconButton(
                  icon: AccIcon.x,
                  onPressed: widget.onClose,
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: AccountingTokens.line),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 22, 24, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _ContactFormField(
                    label: nameLabel,
                    icon: AccIcon.building,
                    controller: _name,
                    placeholder: l10n.booksExampleBusinessName,
                    autofocus: true,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: _ContactFormField(
                          label: l10n.booksPrimaryContact,
                          icon: AccIcon.user,
                          controller: _contact,
                          placeholder: l10n.booksFullName,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: _ContactFormField(
                          label: l10n.phone,
                          icon: AccIcon.phone,
                          controller: _phone,
                          placeholder: '+250 …',
                          mono: true,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: _ContactFormField(
                          label: l10n.email,
                          icon: AccIcon.mail,
                          controller: _email,
                          placeholder: l10n.booksEmailPlaceholder,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: _ContactFormField(
                          label: l10n.tin,
                          icon: AccIcon.hash,
                          controller: _tin,
                          placeholder: l10n.booksTaxId,
                          mono: true,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    l10n.booksPaymentTerms,
                    style: AccountingTokens.sans(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w700,
                      color: AccountingTokens.ink2,
                    ),
                  ),
                  const SizedBox(height: 7),
                  _TermsSegment(
                    value: _terms,
                    onChanged: (v) => setState(() => _terms = v),
                  ),
                ],
              ),
            ),
          ),
          const Divider(height: 1, color: AccountingTokens.line),
          if (_showError)
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 0),
              child: Text(
                _validationError!,
                style: AccountingTokens.sans(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                  color: AccountingTokens.loss,
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
            child: Row(
              children: [
                Expanded(
                  child: AccountingButton(
                    label: l10n.cancel,
                    onPressed: widget.onClose,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: AccountingButton(
                    label: isCustomer
                        ? l10n.addCustomer
                        : l10n.booksAddSupplier,
                    accIcon: AccIcon.plus,
                    primary: true,
                    enabled: _ok,
                    onPressed: _ok ? _submit : null,
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

class _ContactFormField extends StatefulWidget {
  const _ContactFormField({
    required this.label,
    required this.controller,
    this.icon,
    this.placeholder,
    this.autofocus = false,
    this.mono = false,
  });

  final String label;
  final TextEditingController controller;
  final AccIcon? icon;
  final String? placeholder;
  final bool autofocus;
  final bool mono;

  @override
  State<_ContactFormField> createState() => _ContactFormFieldState();
}

class _ContactFormFieldState extends State<_ContactFormField> {
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final focused = _focusNode.hasFocus;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          widget.label,
          style: AccountingTokens.sans(
            fontSize: 12.5,
            fontWeight: FontWeight.w700,
            color: AccountingTokens.ink2,
          ),
        ),
        const SizedBox(height: 7),
        AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          height: 46,
          padding: const EdgeInsets.symmetric(horizontal: 13),
          decoration: BoxDecoration(
            color: AccountingTokens.surface,
            borderRadius: BorderRadius.circular(11),
            border: Border.all(
              color: focused ? AccountingTokens.accent : AccountingTokens.line,
              width: 1.5,
            ),
            boxShadow: focused
                ? [
                    BoxShadow(
                      color: AccountingTokens.accentTint,
                      blurRadius: 0,
                      spreadRadius: 4,
                    ),
                  ]
                : null,
          ),
          child: Row(
            children: [
              if (widget.icon != null) ...[
                AccountingIcon(
                  icon: widget.icon!,
                  size: 16,
                  color: AccountingTokens.ink3,
                ),
                const SizedBox(width: 10),
              ],
              Expanded(
                child: TextField(
                  controller: widget.controller,
                  focusNode: _focusNode,
                  autofocus: widget.autofocus,
                  style:
                      (widget.mono
                      ? AccountingTokens.mono
                      : AccountingTokens.sans)(
                        fontSize: 14.5,
                        color: AccountingTokens.ink1,
                      ),
                  decoration: InputDecoration(
                    isDense: true,
                    border: InputBorder.none,
                    hintText: widget.placeholder,
                    hintStyle: AccountingTokens.sans(
                      fontSize: 14.5,
                      color: AccountingTokens.ink3,
                    ),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _TermsSegment extends StatelessWidget {
  const _TermsSegment({required this.value, required this.onChanged});

  final String value;
  final ValueChanged<String> onChanged;

  static const _options = ['Net 15', 'Net 30', 'Net 45'];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AccountingTokens.surface2,
        borderRadius: BorderRadius.circular(11),
        border: Border.all(color: AccountingTokens.line),
      ),
      child: Row(
        children: [
          for (var i = 0; i < _options.length; i++) ...[
            if (i > 0) const SizedBox(width: 4),
            Expanded(
              child: _SegButton(
                label: booksTermsLabel(_options[i], context.flipperL10n),
                selected: value == _options[i],
                onTap: () => onChanged(_options[i]),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _SegButton extends StatelessWidget {
  const _SegButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? AccountingTokens.surface : Colors.transparent,
      borderRadius: BorderRadius.circular(8),
      elevation: selected ? 1 : 0,
      shadowColor: const Color(0x0A0B1220),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Center(
            child: Text(
              label,
              style: AccountingTokens.sans(
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
                color: selected ? AccountingTokens.ink1 : AccountingTokens.ink2,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
