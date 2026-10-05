import 'package:flipper_web/modules/accounting/data/accounting_models.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flutter/material.dart';

/// [partiallyPaid] is never stored (Supabase only accepts the other four);
/// readers derive it from a bill's amounts.
enum DocStatus { draft, sent, partiallyPaid, paid, overdue }

enum DocKind { invoice, bill }

enum DocTabFilter { all, draft, sent, overdue, paid }

enum AuditTone { green, blue, amber, slate }

class DocLine {
  const DocLine({required this.desc, required this.qty, required this.price});

  final String desc;
  final num qty;
  final num price;

  DocLine copyWith({String? desc, num? qty, num? price}) => DocLine(
    desc: desc ?? this.desc,
    qty: qty ?? this.qty,
    price: price ?? this.price,
  );
}

class AccountingDocument {
  const AccountingDocument({
    required this.id,
    required this.who,
    required this.date,
    required this.due,
    required this.status,
    required this.lines,
    this.uuid,
    this.total,
    this.amountPaid = 0,
    this.source,
    this.supplierId,
    this.purchaseId,
    this.paidUpfront = 0,
  });

  /// Human-readable number (e.g. INV-2210).
  final String id;
  final String who;
  final String date;
  final String due;
  final DocStatus status;
  final List<DocLine> lines;

  /// Backend document UUID when loaded from Ditto / Supabase.
  final String? uuid;

  /// Stored grand total. Purchase bills carry the real (VAT-inclusive)
  /// purchase total here; older documents leave it null and the total is
  /// derived from [lines].
  final int? total;

  /// Paid so far: upfront at purchase plus later payments (cached on the
  /// document by `BillPaymentPoster`).
  final int amountPaid;

  /// Where the bill came from: `purchase`, `cashbook`, or null for Books.
  final String? source;

  /// Canonical `suppliers` row id, when linked.
  final String? supplierId;

  /// The POS purchase this bill records, when it came from one.
  final String? purchaseId;

  /// Part of [total] settled when the purchase was made (Cash/Credit).
  final int paidUpfront;

  /// A purchase bill written before bills carried a total and a source. Its
  /// lines hold VAT-inclusive prices and its status says nothing about what
  /// was paid, so it is left out of what the business owes.
  bool get isLegacyPurchaseBill =>
      purchaseId != null && source == null && total == null;

  AccountingDocument copyWith({
    String? id,
    String? who,
    String? date,
    String? due,
    DocStatus? status,
    List<DocLine>? lines,
    String? uuid,
    int? total,
    int? amountPaid,
    String? source,
    String? supplierId,
    String? purchaseId,
    int? paidUpfront,
  }) => AccountingDocument(
    id: id ?? this.id,
    who: who ?? this.who,
    date: date ?? this.date,
    due: due ?? this.due,
    status: status ?? this.status,
    lines: lines ?? this.lines,
    uuid: uuid ?? this.uuid,
    total: total ?? this.total,
    amountPaid: amountPaid ?? this.amountPaid,
    source: source ?? this.source,
    supplierId: supplierId ?? this.supplierId,
    purchaseId: purchaseId ?? this.purchaseId,
    paidUpfront: paidUpfront ?? this.paidUpfront,
  );
}

/// Opens the invoice/bill editor from another view (e.g. contact drawer).
class PendingDocEditor {
  const PendingDocEditor({required this.kind, required this.who});

  final DocKind kind;
  final String who;
}

/// Customers/suppliers detail drawer or new-contact form (shell-level overlay).
class ContactsUiState {
  const ContactsUiState({
    required this.isCustomer,
    this.detailContact,
    this.showCreateForm = false,
  }) : assert(detailContact != null || showCreateForm);

  final bool isCustomer;
  final AccountingContact? detailContact;
  final bool showCreateForm;
}

/// Invoice/bill editor, preview, or payment panel (shell-level overlay).
class BillingUiState {
  const BillingUiState({
    required this.kind,
    this.editing,
    this.editingNew = false,
    this.initialWho,
    this.paying,
    this.preview,
  }) : assert(
         editing != null || editingNew || paying != null || preview != null,
       );

  final DocKind kind;
  final AccountingDocument? editing;
  final bool editingNew;
  final String? initialWho;
  final AccountingDocument? paying;
  final AccountingDocument? preview;
}

class DocTotals {
  const DocTotals({
    required this.subtotal,
    required this.vat,
    required this.total,
  });

  final int subtotal;
  final int vat;
  final int total;
}

class AccountingContact {
  const AccountingContact({
    required this.id,
    required this.name,
    required this.contact,
    required this.phone,
    required this.email,
    required this.tin,
    required this.since,
    required this.terms,
    required this.balance,
    this.fromAging = false,
    this.uuid,
    this.partyId,
  });

  final String id;
  final String name;
  final String contact;
  final String phone;
  final String email;
  final String tin;
  final String since;
  final String terms;
  final int balance;
  final bool fromAging;

  /// Backend contact UUID when persisted (not aging-derived).
  final String? uuid;

  /// Canonical party id in the shared `customers`/`suppliers` store (POS
  /// customers). Null for aging-derived rows and legacy extension-only rows.
  final String? partyId;

  AccountingContact copyWith({
    String? id,
    String? name,
    String? contact,
    String? phone,
    String? email,
    String? tin,
    String? since,
    String? terms,
    int? balance,
    bool? fromAging,
    String? uuid,
    String? partyId,
  }) => AccountingContact(
    id: id ?? this.id,
    name: name ?? this.name,
    contact: contact ?? this.contact,
    phone: phone ?? this.phone,
    email: email ?? this.email,
    tin: tin ?? this.tin,
    since: since ?? this.since,
    terms: terms ?? this.terms,
    balance: balance ?? this.balance,
    fromAging: fromAging ?? this.fromAging,
    uuid: uuid ?? this.uuid,
    partyId: partyId ?? this.partyId,
  );
}

class RecurringSchedule {
  const RecurringSchedule({
    required this.id,
    required this.name,
    required this.freq,
    required this.day,
    required this.next,
    required this.amount,
    required this.debitCode,
    required this.creditCode,
    required this.iconName,
    required this.active,
    this.uuid,
  });

  /// Human-readable schedule number (e.g. R-01).
  final String id;
  final String name;
  final String freq;
  final String day;
  final String next;
  final int amount;

  /// Chart-of-accounts code debited when the schedule posts (the expense/asset).
  final String debitCode;

  /// Chart-of-accounts code credited when the schedule posts (the funding side).
  final String creditCode;

  /// Handoff icon key (e.g. `Home`, `Users`, `Wallet`).
  final String iconName;
  final bool active;

  /// Backend document UUID when loaded from Ditto / Supabase.
  final String? uuid;

  RecurringSchedule copyWith({
    String? id,
    String? name,
    String? freq,
    String? day,
    String? next,
    int? amount,
    String? debitCode,
    String? creditCode,
    String? iconName,
    bool? active,
    String? uuid,
  }) => RecurringSchedule(
    id: id ?? this.id,
    name: name ?? this.name,
    freq: freq ?? this.freq,
    day: day ?? this.day,
    next: next ?? this.next,
    amount: amount ?? this.amount,
    debitCode: debitCode ?? this.debitCode,
    creditCode: creditCode ?? this.creditCode,
    iconName: iconName ?? this.iconName,
    active: active ?? this.active,
    uuid: uuid ?? this.uuid,
  );
}

/// Recurring-schedule editor panel (shell-level overlay), mirroring
/// [BillingUiState].
class RecurringUiState {
  const RecurringUiState({this.editing, this.editingNew = false})
    : assert(editing != null || editingNew);

  final RecurringSchedule? editing;
  final bool editingNew;
}

// NOTE: contact handoff seeds were removed — Books contacts now read the
// canonical customers/suppliers stores shared with the POS app, so demo
// contacts would actively mislead.

class AuditEntry {
  const AuditEntry({
    required this.id,
    required this.ts,
    required this.user,
    required this.role,
    required this.action,
    required this.target,
    required this.detail,
    required this.iconName,
    required this.tone,
  });

  final String id;
  final String ts;
  final String user;
  final String role;
  final String action;
  final String target;
  final String detail;
  final String iconName;
  final AuditTone tone;
}

class TeamMember {
  const TeamMember({
    required this.id,
    required this.name,
    required this.initials,
    required this.color,
    required this.email,
    required this.role,
    required this.last,
    this.you = false,
  });

  final String id;
  final String name;
  final String initials;
  final Color color;
  final String email;
  final String role;
  final String last;
  final bool you;
}

class RoleDefinition {
  const RoleDefinition({
    required this.role,
    required this.desc,
    required this.color,
  });

  final String role;
  final String desc;
  final Color color;
}

class PermissionRow {
  const PermissionRow({
    required this.cap,
    required this.owner,
    required this.bookkeeper,
    required this.cashier,
    required this.viewer,
  });

  final String cap;
  final bool owner;
  final bool bookkeeper;
  final bool cashier;
  final bool viewer;
}

class CloseTask {
  const CloseTask({
    required this.id,
    required this.label,
    required this.detail,
    required this.done,
    required this.goView,
    required this.iconName,
  });

  final String id;
  final String label;
  final String detail;
  final bool done;
  final String goView;
  final String iconName;

  CloseTask copyWith({bool? done}) => CloseTask(
    id: id,
    label: label,
    detail: detail,
    done: done ?? this.done,
    goView: goView,
    iconName: iconName,
  );
}

/// Display text for a stored recurring-schedule frequency value
/// (`Monthly`, `Weekly`, …). Unknown values are shown as stored.
String booksFrequencyLabel(String freq, FlipperAppLocalizations l10n) =>
    switch (freq) {
      'Monthly' => l10n.booksFreqMonthly,
      'Weekly' => l10n.booksFreqWeekly,
      'Quarterly' => l10n.booksFreqQuarterly,
      'Yearly' => l10n.booksFreqYearly,
      _ => freq,
    };

/// Display name for an account type (pills, pickers).
String booksAccountTypeLabel(AccountType type, FlipperAppLocalizations l10n) =>
    switch (type) {
      AccountType.asset => l10n.booksTypeAsset,
      AccountType.liability => l10n.booksTypeLiability,
      AccountType.equity => l10n.booksTypeEquity,
      AccountType.income => l10n.booksTypeIncome,
      AccountType.expense => l10n.booksTypeExpense,
    };

/// Display text for a stored payment-terms value (`Net 30` …).
String booksTermsLabel(String terms, FlipperAppLocalizations l10n) {
  final m = RegExp(r'^Net (\d+)$').firstMatch(terms.trim());
  return m == null ? terms : l10n.booksNetDays(m.group(1)!);
}

List<RoleDefinition> accountingRoles(FlipperAppLocalizations l10n) => [
  RoleDefinition(
    role: l10n.booksRoleOwner,
    desc: l10n.booksRoleOwnerDesc,
    color: const Color(0xFF2563EB),
  ),
  RoleDefinition(
    role: l10n.booksRoleBookkeeper,
    desc: l10n.booksRoleBookkeeperDesc,
    color: const Color(0xFF0D9488),
  ),
  RoleDefinition(
    role: l10n.booksRoleCashier,
    desc: l10n.booksRoleCashierDesc,
    color: const Color(0xFFE08600),
  ),
  RoleDefinition(
    role: l10n.booksRoleViewer,
    desc: l10n.booksRoleViewerDesc,
    color: const Color(0xFF7C3AED),
  ),
];

List<PermissionRow> accountingPermissions(FlipperAppLocalizations l10n) => [
  PermissionRow(
    cap: l10n.booksCapViewReports,
    owner: true,
    bookkeeper: true,
    cashier: false,
    viewer: true,
  ),
  PermissionRow(
    cap: l10n.booksCapCreateInvoicesBills,
    owner: true,
    bookkeeper: true,
    cashier: false,
    viewer: false,
  ),
  PermissionRow(
    cap: l10n.booksCapRecordPayments,
    owner: true,
    bookkeeper: true,
    cashier: true,
    viewer: false,
  ),
  PermissionRow(
    cap: l10n.booksCapPostJournal,
    owner: true,
    bookkeeper: true,
    cashier: false,
    viewer: false,
  ),
  PermissionRow(
    cap: l10n.booksCapApproveEntries,
    owner: true,
    bookkeeper: false,
    cashier: false,
    viewer: false,
  ),
  PermissionRow(
    cap: l10n.booksCapFileVat,
    owner: true,
    bookkeeper: false,
    cashier: false,
    viewer: false,
  ),
  PermissionRow(
    cap: l10n.booksCapClosePeriods,
    owner: true,
    bookkeeper: false,
    cashier: false,
    viewer: false,
  ),
];
