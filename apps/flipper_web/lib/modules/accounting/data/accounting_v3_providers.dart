import 'package:flipper_web/core/supabase_provider.dart';
import 'package:flipper_web/features/business_selection/business_branch_selector.dart';
import 'package:flipper_web/modules/accounting/data/accounting_backend_config.dart';
import 'package:flipper_web/modules/accounting/data/accounting_derive.dart';
import 'package:flipper_web/modules/accounting/data/accounting_models.dart';
import 'package:flipper_web/modules/accounting/data/accounting_providers.dart';
import 'package:flipper_web/modules/accounting/data/accounting_v3_models.dart';
import 'package:flipper_web/modules/accounting/data/party_models.dart';
import 'package:flipper_web/modules/accounting/data/repository/accounting_documents_repository.dart';
import 'package:flipper_web/modules/accounting/data/repository/ditto_accounting_documents_repository.dart';
import 'package:flipper_web/modules/accounting/data/repository/ditto_party_repository.dart';
import 'package:flipper_web/modules/accounting/data/repository/party_repository.dart';
import 'package:flipper_web/modules/accounting/data/repository/supabase_accounting_documents_repository.dart';
import 'package:flipper_web/modules/accounting/data/repository/supabase_party_repository.dart';
import 'package:flipper_web/modules/accounting/routing/accounting_route.dart';
import 'package:flipper_web/modules/accounting/theme/accounting_tokens.dart';
import 'package:flipper_web/services/ditto_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:intl/intl.dart';

// ─── Documents repository ────────────────────────────────────────────────────

final accountingDocumentsRepositoryProvider =
    Provider<AccountingDocumentsRepository>((ref) {
  final strategy = ref.watch(accountingBackendStrategyProvider);
  if (strategy == AccountingBackendStrategy.ditto) {
    return DittoAccountingDocumentsRepository(ref.watch(dittoServiceProvider));
  }
  return SupabaseAccountingDocumentsRepository(ref.watch(supabaseProvider));
});

final invoicesStreamProvider = StreamProvider<List<AccountingDocument>>((ref) {
  final businessId = ref.watch(accountingBusinessIdProvider);
  if (businessId.isEmpty) return const Stream.empty();
  return ref.watch(accountingDocumentsRepositoryProvider).watchDocuments(
        businessId: businessId,
        kind: DocKind.invoice,
      );
});

final billsStreamProvider = StreamProvider<List<AccountingDocument>>((ref) {
  final businessId = ref.watch(accountingBusinessIdProvider);
  if (businessId.isEmpty) return const Stream.empty();
  return ref.watch(accountingDocumentsRepositoryProvider).watchDocuments(
        businessId: businessId,
        kind: DocKind.bill,
      );
});

/// Extension records only (terms / contact person / since-label) from
/// accounting_contacts. Identity now lives on the canonical party row —
/// see [customerPartiesStreamProvider].
final customersStreamProvider = StreamProvider<List<AccountingContact>>((ref) {
  final businessId = ref.watch(accountingBusinessIdProvider);
  if (businessId.isEmpty) return const Stream.empty();
  return ref.watch(accountingDocumentsRepositoryProvider).watchContacts(
        businessId: businessId,
        isCustomer: true,
      );
});

final suppliersStreamProvider = StreamProvider<List<AccountingContact>>((ref) {
  final businessId = ref.watch(accountingBusinessIdProvider);
  if (businessId.isEmpty) return const Stream.empty();
  return ref.watch(accountingDocumentsRepositoryProvider).watchContacts(
        businessId: businessId,
        isCustomer: false,
      );
});

// ─── Canonical party store (shared with POS) ─────────────────────────────────

/// Branch key for the canonical `customers`/`suppliers` stores.
///
/// Single chokepoint by design: BOTH backends key parties on the branch UUID
/// (`customers.branch_id` references branches(id); POS writes
/// `branchId = getBranchId()` which is the same uuid) — unlike transactions,
/// which use serverId on Supabase.
final partyBranchIdProvider = Provider<String>((ref) {
  return ref.watch(selectedBranchProvider)?.id ?? '';
});

final partyRepositoryProvider = Provider<PartyRepository>((ref) {
  final strategy = ref.watch(accountingBackendStrategyProvider);
  if (strategy == AccountingBackendStrategy.ditto) {
    return DittoPartyRepository(
      ref.watch(dittoServiceProvider),
      ref.watch(supabaseProvider),
    );
  }
  return SupabasePartyRepository(
    ref.watch(supabaseProvider),
    ref.watch(dittoServiceProvider),
  );
});

final customerPartiesStreamProvider = StreamProvider<List<Party>>((ref) {
  final branchId = ref.watch(partyBranchIdProvider);
  if (branchId.isEmpty) return const Stream.empty();
  return ref
      .watch(partyRepositoryProvider)
      .watchParties(branchId: branchId, kind: PartyKind.customer);
});

final supplierPartiesStreamProvider = StreamProvider<List<Party>>((ref) {
  final branchId = ref.watch(partyBranchIdProvider);
  if (branchId.isEmpty) return const Stream.empty();
  return ref
      .watch(partyRepositoryProvider)
      .watchParties(branchId: branchId, kind: PartyKind.supplier);
});

// ─── UI state ────────────────────────────────────────────────────────────────

final pendingDocEditorProvider = StateProvider<PendingDocEditor?>((ref) => null);

/// Detail / new-contact panels render in [AccountingContactsDrawerHost] at shell edge.
final contactsUiProvider = StateProvider<ContactsUiState?>((ref) => null);

/// Invoice/bill panels render in [AccountingBillingPanelHost] at shell edge.
final billingUiProvider = StateProvider<BillingUiState?>((ref) => null);

final recurringSchedulesProvider =
    StateProvider<List<RecurringSchedule>>((ref) => defaultRecurringSchedules);

final auditLogProvider = StateProvider<List<AuditEntry>>((ref) => []);

final teamExtraProvider = StateProvider<List<TeamMember>>((ref) => []);

final periodCloseLockedProvider = StateProvider<bool>((ref) => false);

final periodCloseTaskOverridesProvider =
    StateProvider<Map<String, bool>>((ref) => {});

final docTabFilterProvider = StateProvider<DocTabFilter>(
  (ref) => DocTabFilter.all,
);

// ─── Derived contacts (canonical parties + extensions + aging) ───────────────

/// Canonical parties joined with their accounting extension records.
///
/// Identity (name/phone/email/tin) comes from the shared party row; the
/// accounting extras (contact person, terms, since-label) overlay from the
/// matching accounting_contacts extension (joined by partyId). Legacy
/// extension rows without a partyId are kept as standalone contacts.
List<AccountingContact> _joinPartiesWithExtensions({
  required List<Party> parties,
  required List<AccountingContact> extensions,
}) {
  final extByPartyId = <String, AccountingContact>{
    for (final e in extensions)
      if (e.partyId != null) e.partyId!: e,
  };

  return [
    for (final p in parties)
      AccountingContact(
        id: extByPartyId[p.id]?.id ?? p.id,
        partyId: p.id,
        uuid: extByPartyId[p.id]?.uuid,
        name: p.name,
        contact: extByPartyId[p.id]?.contact ?? '',
        phone: p.phone,
        email: p.email,
        tin: p.tin,
        since: extByPartyId[p.id]?.since ?? '—',
        terms: extByPartyId[p.id]?.terms ?? 'Net 30',
        balance: 0,
      ),
    // Legacy extension-only rows (no canonical party linked).
    ...extensions.where((e) => e.partyId == null),
  ];
}

List<AccountingContact> _mergeContacts({
  required List<AgingRow> aging,
  required List<AccountingContact> saved,
  required String idPrefix,
}) {
  final byName = <String, AccountingContact>{};

  for (final row in aging) {
    if (row.name.isEmpty) continue;
    final existing = byName[row.name];
    if (existing != null) {
      byName[row.name] = existing.copyWith(balance: row.total, fromAging: true);
    } else {
      byName[row.name] = AccountingContact(
        id: '$idPrefix-${row.name.hashCode.abs()}',
        name: row.name,
        contact: row.name,
        phone: '',
        email: '',
        tin: '',
        since: '—',
        terms: 'Net 30',
        balance: row.total,
        fromAging: true,
      );
    }
  }

  for (final c in saved) {
    final existing = byName[c.name];
    if (existing != null && existing.fromAging) {
      byName[c.name] = c.copyWith(balance: existing.balance);
    } else {
      byName[c.name] = c;
    }
  }

  return byName.values.toList()..sort((a, b) => a.name.compareTo(b.name));
}

final accountingCustomersProvider = Provider<List<AccountingContact>>((ref) {
  return _mergeContacts(
    aging: ref.watch(accountingArAgingProvider),
    saved: _joinPartiesWithExtensions(
      parties: ref.watch(customerPartiesStreamProvider).value ?? [],
      extensions: ref.watch(customersStreamProvider).value ?? [],
    ),
    idPrefix: 'C',
  );
});

final accountingSuppliersProvider = Provider<List<AccountingContact>>((ref) {
  return _mergeContacts(
    aging: ref.watch(accountingApAgingProvider),
    saved: _joinPartiesWithExtensions(
      parties: ref.watch(supplierPartiesStreamProvider).value ?? [],
      extensions: ref.watch(suppliersStreamProvider).value ?? [],
    ),
    idPrefix: 'S',
  );
});

// ─── Documents with overdue refresh ───────────────────────────────────────────

DocStatus _effectiveStatus(AccountingDocument doc) {
  if (doc.status == DocStatus.sent) {
    try {
      final due = DateFormat('d MMM y').parseLoose(doc.due);
      if (DateTime.now().isAfter(due)) return DocStatus.overdue;
    } catch (_) {}
  }
  return doc.status;
}

List<AccountingDocument> _withOverdue(List<AccountingDocument> docs) {
  return [for (final d in docs) d.copyWith(status: _effectiveStatus(d))];
}

final accountingInvoicesProvider = Provider<List<AccountingDocument>>((ref) {
  return _withOverdue(ref.watch(invoicesStreamProvider).value ?? []);
});

final accountingBillsProvider = Provider<List<AccountingDocument>>((ref) {
  final persisted = ref.watch(billsStreamProvider).value ?? [];
  if (persisted.isEmpty) return _withOverdue(defaultHandoffBills);
  return _withOverdue(persisted);
});

// ─── Team (current user + invited) ───────────────────────────────────────────

String _initials(String name) {
  final parts = name.trim().split(RegExp(r'\s+'));
  if (parts.isEmpty) return '?';
  if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
  return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
}

final accountingTeamProvider = Provider<List<TeamMember>>((ref) {
  final userName = ref.watch(accountingUserNameProvider);
  final role = ref.watch(accountingUserRoleProvider);
  final extra = ref.watch(teamExtraProvider);
  final members = <TeamMember>[];
  if (userName.isNotEmpty) {
    members.add(
      TeamMember(
        id: 'U-you',
        name: userName,
        initials: _initials(userName),
        color: AccountingTokens.accent,
        email: '',
        role: role.isNotEmpty ? role : 'Owner',
        last: 'Active now',
        you: true,
      ),
    );
  }
  members.addAll(extra);
  return members;
});

// ─── Period close checklist (derived + overrides) ────────────────────────────

final periodCloseTasksProvider = Provider<List<CloseTask>>((ref) {
  final pending = ref.watch(pendingCountProvider);
  final bankLines = ref.watch(accountingBankLinesProvider);
  final unmatched = bankLines.where((l) => !l.matched).length;
  final ar = ref.watch(accountingArAgingProvider);
  final invoices = ref.watch(accountingInvoicesProvider);
  final overdueInv = invoices.where((d) => d.status == DocStatus.overdue).length;
  final ap = ref.watch(accountingApAgingProvider);
  final bills = ref.watch(accountingBillsProvider);
  final vat = ref.watch(accountingVatProvider);
  final overrides = ref.watch(periodCloseTaskOverridesProvider);
  final currency = ref.watch(accountingCurrencyProvider);

  bool done(String id, bool derived) => overrides[id] ?? derived;

  return [
    CloseTask(
      id: 'ct1',
      label: 'All journal entries posted',
      detail: pending > 0
          ? '$pending entries still pending approval'
          : 'No pending entries',
      done: done('ct1', pending == 0),
      goView: 'journal',
      iconName: 'Receipt',
    ),
    CloseTask(
      id: 'ct2',
      label: 'Bank accounts reconciled',
      detail: unmatched > 0
          ? '$unmatched statement lines unmatched'
          : 'All lines matched',
      done: done('ct2', unmatched == 0),
      goView: 'bankrec',
      iconName: 'Refresh',
    ),
    CloseTask(
      id: 'ct3',
      label: 'Receivables reviewed',
      detail: ar.isEmpty
          ? 'No open receivables'
          : overdueInv > 0
              ? 'Aging confirmed · $overdueInv overdue invoices'
              : 'Aging confirmed · ${ar.length} balances',
      done: done('ct3', ar.isNotEmpty || invoices.isNotEmpty),
      goView: 'ar',
      iconName: 'ArrowUpRight',
    ),
    CloseTask(
      id: 'ct4',
      label: 'Payables reviewed',
      detail: ap.isEmpty ? 'No open payables' : 'All supplier bills entered',
      done: done('ct4', ap.isNotEmpty || bills.isNotEmpty),
      goView: 'ap',
      iconName: 'ArrowDown',
    ),
    CloseTask(
      id: 'ct5',
      label: 'VAT return prepared',
      detail: vat == null
          ? 'No VAT activity in period'
          : 'Net payable $currency ${money(vat.netPayable)} · due ${vat.dueDate}',
      done: done('ct5', vat != null),
      goView: 'tax',
      iconName: 'ShieldCheck',
    ),
    CloseTask(
      id: 'ct6',
      label: 'Depreciation posted',
      detail: pending > 0
          ? 'Pending entries may include depreciation'
          : 'Depreciation up to date',
      done: done('ct6', pending == 0),
      goView: 'journal',
      iconName: 'Stack',
    ),
  ];
});

// ─── Audit helpers ───────────────────────────────────────────────────────────

void appendAuditLog(
  WidgetRef ref, {
  required String action,
  required String target,
  required String detail,
  String iconName = 'Check',
  AuditTone tone = AuditTone.green,
}) {
  final user = ref.read(accountingUserNameProvider);
  final role = ref.read(accountingUserRoleProvider);
  final ts = DateFormat('d MMM y · HH:mm').format(DateTime.now());
  final id = 'A-${DateTime.now().millisecondsSinceEpoch % 10000}';
  final entry = AuditEntry(
    id: id,
    ts: ts,
    user: user.isNotEmpty ? user : '—',
    role: role.isNotEmpty ? role : 'User',
    action: action,
    target: target,
    detail: detail,
    iconName: iconName,
    tone: tone,
  );
  ref.read(auditLogProvider.notifier).update((log) => [entry, ...log]);
}

AccountingView? closeTaskView(String goView) => AccountingViewX.fromKey(goView);
