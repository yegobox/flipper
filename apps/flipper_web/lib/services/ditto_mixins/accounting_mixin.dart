import 'dart:async';

import 'package:flipper_models/sync/ditto_observer_utils.dart';
import 'package:flipper_web/modules/accounting/data/accounting_models.dart';
import 'package:flipper_web/modules/accounting/data/mapper/ledger_row_mapper.dart';
import 'package:flutter/foundation.dart' hide Category;
import 'ditto_core_mixin.dart';

mixin AccountingMixin on DittoCore {
  Future<void> upsertChartOfAccount(
    String businessId,
    Account account, {
    String? id,
    int openingBalance = 0,
  }) async {
    if (dittoInstance == null)
      return handleNotInitialized('upsertChartOfAccount');
    final docId = id ?? '${businessId}_${account.code}';
    final data = LedgerRowMapper.accountToRow(
      account,
      businessId: businessId,
      id: docId,
      openingBalance: openingBalance,
    );
    await executeUpsert('chart_of_accounts', docId, data);
  }

  Future<void> upsertJournalEntryHeader(
    String businessId,
    Map<String, dynamic> header,
    String docId,
  ) async {
    if (dittoInstance == null)
      return handleNotInitialized('upsertJournalEntryHeader');
    await executeUpsert('journal_entries', docId, {
      ...header,
      'businessId': businessId,
      '_id': docId,
      'id': docId,
    });
  }

  Future<void> upsertJournalLine(
    String businessId,
    String journalEntryId,
    JournalLine line, {
    String? id,
  }) async {
    if (dittoInstance == null) return handleNotInitialized('upsertJournalLine');
    final docId = id ?? '${journalEntryId}_${line.ac}';
    final data = LedgerRowMapper.lineToRow(
      journalEntryId: journalEntryId,
      line: line,
      id: docId,
    );
    await executeUpsert('journal_lines', docId, {
      ...data,
      'businessId': businessId,
      'business_id': businessId,
    });
  }

  Future<void> upsertAccountingDocument(
    String businessId,
    Map<String, dynamic> data,
    String docId,
  ) async {
    if (dittoInstance == null)
      return handleNotInitialized('upsertAccountingDocument');
    await executeUpsert('accounting_documents', docId, {
      ...data,
      'businessId': businessId,
      '_id': docId,
      'id': docId,
    });
  }

  Future<void> deleteAccountingDocument(String docId) async {
    if (dittoInstance == null)
      return handleNotInitialized('deleteAccountingDocument');
    await executeRemove('accounting_documents', docId);
  }

  Future<void> upsertRecurringSchedule(
    String businessId,
    Map<String, dynamic> data,
    String docId,
  ) async {
    if (dittoInstance == null) {
      return handleNotInitialized('upsertRecurringSchedule');
    }
    await executeUpsert('accounting_recurring_schedules', docId, {
      ...data,
      'businessId': businessId,
      '_id': docId,
      'id': docId,
    });
  }

  Future<void> deleteRecurringSchedule(String docId) async {
    if (dittoInstance == null) {
      return handleNotInitialized('deleteRecurringSchedule');
    }
    await executeRemove('accounting_recurring_schedules', docId);
  }

  Future<void> upsertAccountingContact(
    String businessId,
    Map<String, dynamic> data,
    String docId,
  ) async {
    if (dittoInstance == null)
      return handleNotInitialized('upsertAccountingContact');
    await executeUpsert('accounting_contacts', docId, {
      ...data,
      'businessId': businessId,
      '_id': docId,
      'id': docId,
    });
  }

  Future<void> deleteAccountingContact(String docId) async {
    if (dittoInstance == null)
      return handleNotInitialized('deleteAccountingContact');
    await executeRemove('accounting_contacts', docId);
  }

  /// Upsert into a canonical party collection (`customers` / `suppliers`).
  /// Row must already carry the full Ditto document shape (see
  /// PartyRowMapper.toDittoRow); only `_id`/`id` are enforced here.
  Future<void> upsertPartyDoc(
    String collection,
    String docId,
    Map<String, dynamic> data,
  ) async {
    if (dittoInstance == null) return handleNotInitialized('upsertPartyDoc');
    await executeUpsert(collection, docId, {
      ...data,
      '_id': docId,
      'id': docId,
    });
  }

  Future<void> deletePartyDoc(String collection, String docId) async {
    if (dittoInstance == null) return handleNotInitialized('deletePartyDoc');
    await executeRemove(collection, docId);
  }

  Future<void> upsertAccountingAuditLog(
    String businessId,
    Map<String, dynamic> data,
    String docId,
  ) async {
    if (dittoInstance == null) {
      return handleNotInitialized('upsertAccountingAuditLog');
    }
    await executeUpsert('accounting_audit_logs', docId, {
      ...data,
      'businessId': businessId,
      '_id': docId,
      'id': docId,
    });
  }

  Future<void> upsertBankStatementLine(
    String businessId,
    BankLine line, {
    String? id,
    String bankAccountCode = '1020',
    String? matchedJournalEntryId,
    String? matchedEntryNumber,
  }) async {
    if (dittoInstance == null)
      return handleNotInitialized('upsertBankStatementLine');
    final docId =
        id ?? '${businessId}_${line.date}_${line.amt}_${line.desc.hashCode}';
    final data = LedgerRowMapper.bankLineToRow(
      businessId: businessId,
      line: line,
      bankAccountCode: bankAccountCode,
      id: docId,
      matchedJournalEntryId: matchedJournalEntryId,
      matchedEntryNumber: matchedEntryNumber,
    );
    await executeUpsert('bank_statement_lines', docId, data);
  }

  Future<List<Map<String, dynamic>>> queryCollection(
    String collection,
    String query,
    Map<String, dynamic> args,
  ) async {
    if (dittoInstance == null) {
      return handleNotInitializedAndReturn('queryCollection', []);
    }
    final result = await dittoInstance!.store.execute(query, arguments: args);
    return dittoQueryRows(result);
  }

  Stream<List<Map<String, dynamic>>> watchCollection(
    String collection,
    String query,
    Map<String, dynamic> args,
  ) {
    final ditto = dittoInstance;
    if (ditto == null) return const Stream.empty();

    final controller = StreamController<List<Map<String, dynamic>>>.broadcast();
    dynamic observer;

    void emitRows(dynamic queryResult) {
      if (controller.isClosed) return;
      controller.add(dittoQueryRows(queryResult));
    }

    Future<void> start() async {
      try {
        final initial = await ditto.store.execute(query, arguments: args);
        emitRows(initial);
      } catch (e) {
        debugPrint('watchCollection($collection) initial execute: $e');
      }

      observer = ditto.store.registerObserver(
        query,
        arguments: args,
        onChange: emitRows,
      );
    }

    unawaited(start());

    controller.onCancel = () async {
      await cancelDittoStoreObserver(observer);
      if (!controller.isClosed) await controller.close();
    };

    return controller.stream;
  }
}
