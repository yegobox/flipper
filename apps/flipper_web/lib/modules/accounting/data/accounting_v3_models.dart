import 'package:flutter/material.dart';

enum DocStatus { draft, sent, paid, overdue }

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

  AccountingDocument copyWith({
    String? id,
    String? who,
    String? date,
    String? due,
    DocStatus? status,
    List<DocLine>? lines,
    String? uuid,
  }) => AccountingDocument(
    id: id ?? this.id,
    who: who ?? this.who,
    date: date ?? this.date,
    due: due ?? this.due,
    status: status ?? this.status,
    lines: lines ?? this.lines,
    uuid: uuid ?? this.uuid,
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

const accountingRoles = <RoleDefinition>[
  RoleDefinition(
    role: 'Owner',
    desc: 'Full access — approve, post, file taxes, manage team',
    color: Color(0xFF2563EB),
  ),
  RoleDefinition(
    role: 'Bookkeeper',
    desc: 'Create & edit entries, invoices and bills; cannot approve or file',
    color: Color(0xFF0D9488),
  ),
  RoleDefinition(
    role: 'Cashier',
    desc: 'Record sales and receipts from POS only',
    color: Color(0xFFE08600),
  ),
  RoleDefinition(
    role: 'Viewer',
    desc: 'Read-only access to reports and statements',
    color: Color(0xFF7C3AED),
  ),
];

const accountingPermissions = <PermissionRow>[
  PermissionRow(
    cap: 'View reports & statements',
    owner: true,
    bookkeeper: true,
    cashier: false,
    viewer: true,
  ),
  PermissionRow(
    cap: 'Create invoices & bills',
    owner: true,
    bookkeeper: true,
    cashier: false,
    viewer: false,
  ),
  PermissionRow(
    cap: 'Record payments & receipts',
    owner: true,
    bookkeeper: true,
    cashier: true,
    viewer: false,
  ),
  PermissionRow(
    cap: 'Post & edit journal entries',
    owner: true,
    bookkeeper: true,
    cashier: false,
    viewer: false,
  ),
  PermissionRow(
    cap: 'Approve entries',
    owner: true,
    bookkeeper: false,
    cashier: false,
    viewer: false,
  ),
  PermissionRow(
    cap: 'File VAT with RRA',
    owner: true,
    bookkeeper: false,
    cashier: false,
    viewer: false,
  ),
  PermissionRow(
    cap: 'Close periods & manage team',
    owner: true,
    bookkeeper: false,
    cashier: false,
    viewer: false,
  ),
];
