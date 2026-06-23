import 'package:flipper_web/modules/accounting/data/accounting_models.dart';
import 'package:flipper_web/modules/accounting/data/default_chart_of_accounts_seed.dart';
import 'package:flipper_web/modules/accounting/data/repository/accounting_ledger_repository.dart';

class FakeAccountingLedgerRepository implements AccountingLedgerRepository {
  FakeAccountingLedgerRepository({
    List<Account>? coa,
    List<JournalEntry>? entries,
    List<BankLine>? bankLines,
  })  : _coa = coa ?? List<Account>.from(defaultChartOfAccountsSeed),
        _entries = entries ?? [],
        _bankLines = bankLines ?? [];

  final List<Account> _coa;
  final List<JournalEntry> _entries;
  final List<BankLine> _bankLines;
  final Map<String, String> _txnToEntryId = {};

  /// Entries created so far (read-only view for assertions).
  List<JournalEntry> get entries => List.unmodifiable(_entries);

  /// transactionId -> created entry uuid (read-only view for assertions).
  Map<String, String> get txnToEntryId => Map.unmodifiable(_txnToEntryId);

  Account? lastCreatedAccount;

  @override
  Future<void> ensureSeeded({required String businessId}) async {}

  @override
  Future<void> createChartOfAccount({
    required String businessId,
    required Account account,
  }) async {
    if (_coa.any((a) => a.code == account.code)) {
      throw StateError('Account code ${account.code} already exists');
    }
    _coa.add(account);
    lastCreatedAccount = account;
  }

  @override
  Stream<List<Account>> watchChartOfAccounts({required String businessId}) {
    return Stream.value(List<Account>.from(_coa)).asBroadcastStream();
  }

  @override
  Stream<List<JournalEntry>> watchJournalEntries({
    required String businessId,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return Stream.value(List<JournalEntry>.from(_entries)).asBroadcastStream();
  }

  @override
  Future<String?> findEntryIdByTransactionId({
    required String businessId,
    required String transactionId,
  }) async {
    return _txnToEntryId[transactionId];
  }

  @override
  Future<bool> entryExists({
    required String businessId,
    required String entryId,
  }) async {
    return _entries.any((e) => e.uuid == entryId);
  }

  @override
  Future<String> createJournalEntry({
    required String businessId,
    required JournalEntry entry,
    String? transactionId,
    String? journalCode,
    String? entryId,
  }) async {
    final id = entryId ?? 'uuid-${_entries.length}';
    _entries.add(JournalEntry(
      id: entry.id,
      date: entry.date,
      memo: entry.memo,
      ref: entry.ref,
      status: entry.status,
      src: entry.src,
      lines: entry.lines,
      uuid: id,
    ));
    if (transactionId != null) {
      _txnToEntryId[transactionId] = id;
    }
    return id;
  }

  @override
  Future<void> updateJournalEntry({
    required String businessId,
    required String entryId,
    required JournalEntry entry,
  }) async {}

  @override
  Future<bool> postJournalEntry({
    required String businessId,
    required String entryId,
    bool onlyIfPending = false,
  }) async {
    final idx = _entries.indexWhere((e) => e.uuid == entryId);
    if (idx < 0) return false;
    final current = _entries[idx];
    if (onlyIfPending && current.status != JournalStatus.pending) {
      return false;
    }
    _entries[idx] = JournalEntry(
      id: current.id,
      date: current.date,
      memo: current.memo,
      ref: current.ref,
      status: JournalStatus.posted,
      src: current.src,
      lines: current.lines,
      uuid: current.uuid,
    );
    return true;
  }

  @override
  Stream<List<BankLine>> watchBankLines({
    required String businessId,
    String bankAccountCode = '1020',
  }) {
    return Stream.value(List<BankLine>.from(_bankLines));
  }

  @override
  Future<void> upsertBankLine({
    required String businessId,
    required BankLine line,
    String bankAccountCode = '1020',
    String? id,
    String? matchedJournalEntryId,
    String? matchedEntryNumber,
  }) async {}

  @override
  Future<void> clearBankStatementLines({
    required String businessId,
    String bankAccountCode = '1020',
  }) async {
    _bankLines.clear();
  }

  @override
  Future<Map<String, dynamic>?> fetchSettings({required String businessId}) async {
    return {'default_vat_rate': 0.18, 'vat_due_day': 15};
  }

  @override
  Future<int> fetchInventoryValue({required String branchId}) async => 0;
}
