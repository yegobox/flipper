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
  }) =>
      AccountingDocument(
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

class DocTotals {
  const DocTotals({required this.subtotal, required this.vat, required this.total});

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
  }) =>
      AccountingContact(
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
    required this.accounts,
    required this.iconName,
    required this.active,
  });

  final String id;
  final String name;
  final String freq;
  final String day;
  final String next;
  final int amount;
  final String accounts;

  /// Handoff icon key (e.g. `Home`, `Users`, `Wallet`).
  final String iconName;
  final bool active;

  RecurringSchedule copyWith({bool? active}) => RecurringSchedule(
        id: id,
        name: name,
        freq: freq,
        day: day,
        next: next,
        amount: amount,
        accounts: accounts,
        iconName: iconName,
        active: active ?? this.active,
      );
}

/// Handoff `RECURRING` seed — schedules are local UI state until persisted.
const defaultRecurringSchedules = <RecurringSchedule>[
  RecurringSchedule(
    id: 'R-01',
    name: 'Monthly rent — Kigali branch',
    freq: 'Monthly',
    day: '1st',
    next: '01 Jun 2026',
    amount: 350000,
    accounts: 'Rent → Bank',
    iconName: 'Home',
    active: true,
  ),
  RecurringSchedule(
    id: 'R-02',
    name: 'Staff salaries',
    freq: 'Monthly',
    day: '26th',
    next: '26 Jun 2026',
    amount: 520000,
    accounts: 'Salaries → Wages payable / Bank',
    iconName: 'Users',
    active: true,
  ),
  RecurringSchedule(
    id: 'R-03',
    name: 'Internet & airtime',
    freq: 'Monthly',
    day: '5th',
    next: '05 Jun 2026',
    amount: 60000,
    accounts: 'Utilities → MoMo',
    iconName: 'Wallet',
    active: true,
  ),
  RecurringSchedule(
    id: 'R-04',
    name: 'Equipment depreciation',
    freq: 'Monthly',
    day: 'Last',
    next: '30 Jun 2026',
    amount: 75000,
    accounts: 'Depreciation → Accum. depreciation',
    iconName: 'Stack',
    active: true,
  ),
  RecurringSchedule(
    id: 'R-05',
    name: 'Quarterly insurance',
    freq: 'Quarterly',
    day: '1st',
    next: '01 Jul 2026',
    amount: 180000,
    accounts: 'Insurance → Bank',
    iconName: 'ShieldCheck',
    active: false,
  ),
];

/// Handoff `CUSTOMERS` seed — baseline when no contacts are persisted yet.
const defaultHandoffCustomers = <AccountingContact>[
  AccountingContact(
    id: 'C-01',
    name: 'Karake Retail Group',
    contact: 'Jean-Paul Karake',
    phone: '+250 788 120 440',
    email: 'accounts@karake.rw',
    tin: '102938471',
    since: 'Mar 2024',
    terms: 'Net 30',
    balance: 640000,
  ),
  AccountingContact(
    id: 'C-02',
    name: 'Mutoni Boutique',
    contact: 'Aline Mutoni',
    phone: '+250 788 304 119',
    email: 'aline@mutoni.rw',
    tin: '109284756',
    since: 'Jul 2024',
    terms: 'Net 15',
    balance: 380000,
  ),
  AccountingContact(
    id: 'C-03',
    name: 'Gisenyi Mini-Mart',
    contact: 'Eric Niyonzima',
    phone: '+250 788 551 202',
    email: 'gisenyi.mart@gmail.com',
    tin: '113847562',
    since: 'Jan 2024',
    terms: 'Net 30',
    balance: 410000,
  ),
  AccountingContact(
    id: 'C-04',
    name: 'Twesigye Hardware',
    contact: 'Robert Twesigye',
    phone: '+250 788 667 833',
    email: 'sales@twesigye.rw',
    tin: '118273645',
    since: 'Sep 2023',
    terms: 'Net 30',
    balance: 290000,
  ),
  AccountingContact(
    id: 'C-05',
    name: 'Umutara Traders',
    contact: 'Claudine Uwase',
    phone: '+250 788 712 909',
    email: 'umutara.traders@yahoo.com',
    tin: '120394857',
    since: 'Feb 2025',
    terms: 'Net 15',
    balance: 520000,
  ),
  AccountingContact(
    id: 'C-06',
    name: 'Kivu Fresh Foods',
    contact: 'Patrick Habineza',
    phone: '+250 788 845 661',
    email: 'finance@kivufresh.rw',
    tin: '124857390',
    since: 'Nov 2024',
    terms: 'Net 30',
    balance: 120000,
  ),
];

/// Handoff `SUPPLIERS` seed — baseline when no contacts are persisted yet.
const defaultHandoffSuppliers = <AccountingContact>[
  AccountingContact(
    id: 'S-01',
    name: 'Habimana Wholesalers',
    contact: 'Théogène Habimana',
    phone: '+250 788 201 553',
    email: 'orders@habimana.rw',
    tin: '130495761',
    since: 'Jan 2023',
    terms: 'Net 30',
    balance: 1200000,
  ),
  AccountingContact(
    id: 'S-02',
    name: 'Rwanda Beverage Co.',
    contact: 'Sales desk',
    phone: '+250 788 990 014',
    email: 'b2b@rwandabev.rw',
    tin: '133847562',
    since: 'May 2023',
    terms: 'Net 45',
    balance: 340000,
  ),
  AccountingContact(
    id: 'S-03',
    name: 'Kigali Packaging Ltd',
    contact: 'Yves Mugisha',
    phone: '+250 788 443 217',
    email: 'invoice@kpack.rw',
    tin: '137162849',
    since: 'Aug 2024',
    terms: 'Net 30',
    balance: 180000,
  ),
  AccountingContact(
    id: 'S-04',
    name: 'Akagera Logistics',
    contact: 'Dispatch',
    phone: '+250 788 118 776',
    email: 'billing@akageralog.rw',
    tin: '140382947',
    since: 'Oct 2024',
    terms: 'Net 15',
    balance: 260000,
  ),
];

/// Handoff `BILLS` seed — baseline when no bills are persisted yet.
const defaultHandoffBills = <AccountingDocument>[
  AccountingDocument(
    id: 'BILL-512',
    who: 'Habimana Wholesalers',
    date: '28 May 2026',
    due: '27 Jun 2026',
    status: DocStatus.sent,
    lines: [
      DocLine(desc: 'Inventory restock · dry goods', qty: 1, price: 1016949),
    ],
  ),
  AccountingDocument(
    id: 'BILL-498',
    who: 'Rwanda Beverage Co.',
    date: '20 May 2026',
    due: '04 Jul 2026',
    status: DocStatus.sent,
    lines: [DocLine(desc: 'Beverage supply · May', qty: 1, price: 288136)],
  ),
  AccountingDocument(
    id: 'BILL-491',
    who: 'Kigali Packaging Ltd',
    date: '14 May 2026',
    due: '13 Jun 2026',
    status: DocStatus.overdue,
    lines: [DocLine(desc: 'Branded packaging run', qty: 1, price: 152542)],
  ),
  AccountingDocument(
    id: 'BILL-487',
    who: 'Akagera Logistics',
    date: '10 May 2026',
    due: '25 May 2026',
    status: DocStatus.sent,
    lines: [DocLine(desc: 'Inter-city freight · May', qty: 1, price: 220339)],
  ),
  AccountingDocument(
    id: 'BILL-480',
    who: 'Habimana Wholesalers',
    date: '02 May 2026',
    due: '01 Jun 2026',
    status: DocStatus.paid,
    lines: [
      DocLine(desc: 'Inventory restock · April', qty: 1, price: 940000),
    ],
  ),
];

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
