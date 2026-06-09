import 'package:flipper_web/modules/accounting/data/accounting_derive.dart';
import 'package:flipper_web/modules/accounting/data/accounting_document_math.dart';
import 'package:flipper_web/modules/accounting/data/accounting_providers.dart';
import 'package:flipper_web/modules/accounting/data/accounting_v3_models.dart';
import 'package:flipper_web/modules/accounting/data/accounting_v3_providers.dart';
import 'package:flipper_web/modules/accounting/routing/accounting_route.dart';
import 'package:flipper_web/modules/accounting/theme/accounting_tokens.dart';
import 'package:flipper_web/modules/accounting/widgets/accounting_icon.dart';
import 'package:flipper_web/modules/accounting/widgets/accounting_kpi_card.dart';
import 'package:flipper_web/modules/accounting/widgets/accounting_page_header.dart';
import 'package:flipper_web/modules/accounting/widgets/accounting_toast.dart';
import 'package:flipper_web/modules/accounting/widgets/doc_status_pill.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

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

class _AccountingContactsViewState extends ConsumerState<AccountingContactsView> {
  String _query = '';
  AccountingContact? _open;
  bool _adding = false;

  @override
  Widget build(BuildContext context) {
    final people = widget.isCustomer
        ? ref.watch(accountingCustomersProvider)
        : ref.watch(accountingSuppliersProvider);
    final docs = widget.isCustomer
        ? ref.watch(accountingInvoicesProvider)
        : ref.watch(accountingBillsProvider);
    final currency = ref.watch(accountingCurrencyProvider);
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

    return Stack(
      children: [
        SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(28, 24, 28, 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AccountingPageHeader(
                eyebrow: widget.isCustomer ? 'Sales' : 'Purchases',
                title: widget.isCustomer ? 'Customers' : 'Suppliers',
                subtitle:
                    '${widget.isCustomer ? 'People and businesses you sell to' : 'Vendors you buy from'} · ${people.length} records',
                actions: [
                  SizedBox(
                    width: 240,
                    child: TextField(
                      decoration: InputDecoration(
                        hintText:
                            'Search ${widget.isCustomer ? 'customers' : 'suppliers'}…',
                        prefixIcon: const Icon(Icons.search, size: 18),
                        filled: true,
                        fillColor: AccountingTokens.surface,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: AccountingTokens.line),
                        ),
                      ),
                      onChanged: (v) => setState(() => _query = v),
                    ),
                  ),
                  AccountingButton(
                    label: widget.isCustomer ? 'New customer' : 'New supplier',
                    icon: Icons.add,
                    primary: true,
                    onPressed: () => setState(() => _adding = true),
                  ),
                ],
              ),
              AccountingKpiGrid(
                maxColumns: 3,
                children: [
                  AccountingKpiCard(
                    label: 'Total ${widget.isCustomer ? 'customers' : 'suppliers'}',
                    value: people.length,
                    icon: AccIcon.users,
                    tone: KpiTone.blue,
                    currencyPrefix: false,
                  ),
                  AccountingKpiCard(
                    label: widget.isCustomer ? 'With open balance' : 'With bills due',
                    value: owing,
                    icon: AccIcon.receipt,
                    tone: KpiTone.amber,
                    currencyPrefix: false,
                  ),
                  AccountingKpiCard(
                    label: widget.isCustomer ? 'Total receivable' : 'Total payable',
                    value: totalBal,
                    icon: AccIcon.wallet,
                    tone: KpiTone.green,
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
                            ql.isEmpty
                                ? 'No ${widget.isCustomer ? 'customers' : 'suppliers'} yet.'
                                : 'No matches for "$_query".',
                            style: AccountingTokens.sans(color: AccountingTokens.ink3),
                          ),
                        ),
                      )
                    : SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          columns: [
                            DataColumn(label: Text(widget.isCustomer ? 'Customer' : 'Supplier')),
                            const DataColumn(label: Text('Contact')),
                            const DataColumn(label: Text('Phone')),
                            const DataColumn(label: Text('Terms')),
                            DataColumn(
                              label: Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  widget.isCustomer ? 'Owes you' : 'You owe',
                                ),
                              ),
                            ),
                            const DataColumn(label: Text('')),
                          ],
                          rows: [
                            for (final p in list)
                              DataRow(
                                onSelectChanged: (_) => setState(() => _open = p),
                                cells: [
                                  DataCell(_ContactCell(person: p, isCustomer: widget.isCustomer)),
                                  DataCell(
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(p.contact),
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
                                  ),
                                  DataCell(Text(p.phone.isEmpty ? '—' : p.phone)),
                                  DataCell(_Tag(text: p.terms)),
                                  DataCell(
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        p.balance > 0 ? money(p.balance) : '—',
                                        style: AccountingTokens.mono(
                                          fontWeight: FontWeight.w700,
                                          color: p.balance > 0
                                              ? AccountingTokens.ink1
                                              : AccountingTokens.ink4,
                                        ),
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    PopupMenuButton<String>(
                                      onSelected: (a) => _onMenu(a, p),
                                      itemBuilder: (context) => [
                                        const PopupMenuItem(value: 'view', child: Text('View record')),
                                        const PopupMenuItem(value: 'statement', child: Text('Send statement')),
                                        const PopupMenuItem(value: 'call', child: Text('Call contact')),
                                        if (!p.fromAging)
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
        if (_open != null)
          _ContactDetailDrawer(
            isCustomer: widget.isCustomer,
            person: _open!,
            docs: docs.where((d) => d.who == _open!.name).toList(),
            currency: currency,
            onClose: () => setState(() => _open = null),
            onNewDoc: () => _openDocForContact(_open!),
          ),
        if (_adding)
          _ContactFormDialog(
            isCustomer: widget.isCustomer,
            onClose: () => setState(() => _adding = false),
            onSave: _saveContact,
          ),
      ],
    );
  }

  void _onMenu(String action, AccountingContact p) {
    switch (action) {
      case 'view':
        setState(() => _open = p);
      case 'statement':
        showAccountingToast(
          context,
          'Statement sent',
          subtitle: '${p.name} · ${p.email.isNotEmpty ? p.email : p.phone}',
          icon: Icons.mail_outline,
        );
      case 'call':
        showAccountingToast(
          context,
          p.contact,
          subtitle: p.phone.isNotEmpty ? p.phone : 'No phone on file',
          icon: Icons.phone_outlined,
        );
      case 'delete':
        _deleteContact(p);
    }
  }

  Future<void> _deleteContact(AccountingContact contact) async {
    if (contact.fromAging || contact.uuid == null) return;
    final businessId = ref.read(accountingBusinessIdProvider);
    if (businessId.isEmpty) return;
    await ref.read(accountingDocumentsRepositoryProvider).deleteContact(
          businessId: businessId,
          contactId: contact.uuid!,
        );
    if (!mounted) return;
    showAccountingToast(context, 'Deleted', subtitle: contact.name);
  }

  Future<void> _saveContact(AccountingContact contact) async {
    final businessId = ref.read(accountingBusinessIdProvider);
    if (businessId.isEmpty) return;
    final saved = widget.isCustomer
        ? ref.read(customersStreamProvider).value ?? []
        : ref.read(suppliersStreamProvider).value ?? [];
    final prefix = widget.isCustomer ? 'C' : 'S';
    final id = '$prefix-${saved.length + 1}';
    await ref.read(accountingDocumentsRepositoryProvider).upsertContact(
          businessId: businessId,
          isCustomer: widget.isCustomer,
          contact: contact.copyWith(id: id),
        );
    if (!mounted) return;
    setState(() => _adding = false);
    showAccountingToast(
      context,
      widget.isCustomer ? 'Customer added' : 'Supplier added',
      subtitle: contact.name,
      icon: Icons.check,
    );
  }

  void _openDocForContact(AccountingContact person) {
    setState(() => _open = null);
    ref.read(accountingViewProvider.notifier).state = widget.isCustomer
        ? AccountingView.invoices
        : AccountingView.bills;
    ref.read(pendingDocEditorProvider.notifier).state = PendingDocEditor(
      kind: widget.isCustomer ? DocKind.invoice : DocKind.bill,
      who: person.name,
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
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            gradient: isCustomer
                ? AccountingTokens.brandGradient
                : const LinearGradient(
                    colors: [Color(0xFF0D9488), Color(0xFF0F766E)],
                  ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            initials,
            style: AccountingTokens.sans(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(person.name, style: AccountingTokens.sans(fontWeight: FontWeight.w600)),
            Text(
              'Since ${person.since}',
              style: AccountingTokens.sans(fontSize: 11.5, color: AccountingTokens.ink3),
            ),
          ],
        ),
      ],
    );
  }
}

class _Tag extends StatelessWidget {
  const _Tag({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AccountingTokens.surface2,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AccountingTokens.line),
      ),
      child: Text(text, style: AccountingTokens.sans(fontSize: 12)),
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
              width: 480,
              height: MediaQuery.sizeOf(context).height,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 20, 16, 12),
                    child: Row(
                      children: [
                        _ContactCell(person: person, isCustomer: isCustomer),
                        const Spacer(),
                        IconButton(onPressed: onClose, icon: const Icon(Icons.close)),
                      ],
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: _MiniStat(
                                  label: isCustomer ? 'Outstanding balance' : 'Amount payable',
                                  value: '$currency ${money(person.balance)}',
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _MiniStat(
                                  label: isCustomer ? 'Lifetime billed' : 'Lifetime purchased',
                                  value: '$currency ${money(lifetime)}',
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Text(
                            'Contact details',
                            style: AccountingTokens.sans(fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 10),
                          _DetailRow(label: 'Primary contact', value: person.contact),
                          _DetailRow(label: 'Email', value: person.email.isEmpty ? '—' : person.email),
                          _DetailRow(label: 'Phone', value: person.phone.isEmpty ? '—' : person.phone),
                          _DetailRow(label: 'TIN', value: person.tin.isEmpty ? '—' : person.tin),
                          const SizedBox(height: 20),
                          Text(
                            '${isCustomer ? 'Invoices' : 'Bills'} (${docs.length})',
                            style: AccountingTokens.sans(fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 10),
                          if (docs.isEmpty)
                            Text(
                              'No documents yet.',
                              style: AccountingTokens.sans(color: AccountingTokens.ink3),
                            )
                          else
                            for (final d in docs)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: Row(
                                  children: [
                                    Text(d.id, style: AccountingTokens.mono(fontSize: 12)),
                                    const SizedBox(width: 8),
                                    DocStatusPill(status: d.status),
                                    const Spacer(),
                                    Text(
                                      money(docTotals(d.lines).total),
                                      style: AccountingTokens.mono(fontWeight: FontWeight.w700),
                                    ),
                                  ],
                                ),
                              ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        AccountingButton(
                          label: 'Send statement',
                          icon: Icons.mail_outline,
                          onPressed: () => showAccountingToast(
                            context,
                            'Statement sent',
                            subtitle: person.name,
                            icon: Icons.mail_outline,
                          ),
                        ),
                        const Spacer(),
                        AccountingButton(
                          label: isCustomer ? 'New invoice' : 'New bill',
                          icon: Icons.add,
                          primary: true,
                          onPressed: onNewDoc,
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
          Text(label, style: AccountingTokens.sans(fontSize: 11, color: AccountingTokens.ink3)),
          const SizedBox(height: 4),
          Text(value, style: AccountingTokens.mono(fontWeight: FontWeight.w800)),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(label, style: AccountingTokens.sans(fontSize: 12, color: AccountingTokens.ink3)),
          ),
          Expanded(child: Text(value, style: AccountingTokens.sans(fontSize: 13))),
        ],
      ),
    );
  }
}

class _ContactFormDialog extends StatefulWidget {
  const _ContactFormDialog({
    required this.isCustomer,
    required this.onClose,
    required this.onSave,
  });

  final bool isCustomer;
  final VoidCallback onClose;
  final void Function(AccountingContact contact) onSave;

  @override
  State<_ContactFormDialog> createState() => _ContactFormDialogState();
}

class _ContactFormDialogState extends State<_ContactFormDialog> {
  final _name = TextEditingController();
  final _contact = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  final _tin = TextEditingController();
  String _terms = 'Net 30';

  @override
  void dispose() {
    _name.dispose();
    _contact.dispose();
    _email.dispose();
    _phone.dispose();
    _tin.dispose();
    super.dispose();
  }

  bool get _ok => _name.text.trim().isNotEmpty && _contact.text.trim().isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(onTap: widget.onClose, child: Container(color: const Color(0x8C081216))),
        Center(
          child: Material(
            borderRadius: BorderRadius.circular(AccountingTokens.radiusLg),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      widget.isCustomer ? 'New customer' : 'New supplier',
                      style: AccountingTokens.sans(fontSize: 18, fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 16),
                    _FormField(label: 'Business name', controller: _name),
                    _FormField(label: 'Primary contact', controller: _contact),
                    _FormField(label: 'Email', controller: _email),
                    _FormField(label: 'Phone', controller: _phone),
                    _FormField(label: 'TIN', controller: _tin),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      value: _terms,
                      decoration: const InputDecoration(labelText: 'Payment terms'),
                      items: const [
                        DropdownMenuItem(value: 'Net 15', child: Text('Net 15')),
                        DropdownMenuItem(value: 'Net 30', child: Text('Net 30')),
                        DropdownMenuItem(value: 'Net 45', child: Text('Net 45')),
                      ],
                      onChanged: (v) => setState(() => _terms = v ?? 'Net 30'),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        AccountingButton(label: 'Cancel', onPressed: widget.onClose),
                        const SizedBox(width: 8),
                        AccountingButton(
                          label: 'Save',
                          primary: true,
                          enabled: _ok,
                          onPressed: _ok
                              ? () => widget.onSave(
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
                                  )
                              : null,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _FormField extends StatelessWidget {
  const _FormField({required this.label, required this.controller});

  final String label;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(labelText: label),
      ),
    );
  }
}
