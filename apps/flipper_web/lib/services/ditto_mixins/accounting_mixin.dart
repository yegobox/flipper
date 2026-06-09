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
    if (dittoInstance == null) return handleNotInitialized('upsertChartOfAccount');
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
    if (dittoInstance == null) return handleNotInitialized('upsertJournalEntryHeader');
    await executeUpsert('journal_entries', docId, {
      ...header,
      'businessId': businessId,
      '_id': docId,
      'id': docId,
    });
  }

  Future<void> upsertJournalLine(
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
    await executeUpsert('journal_lines', docId, data);
  }

  Future<void> upsertBankStatementLine(
    String businessId,
    BankLine line, {
    String? id,
    String bankAccountCode = '1020',
    String? matchedJournalEntryId,
  }) async {
    if (dittoInstance == null) return handleNotInitialized('upsertBankStatementLine');
    final docId = id ?? '${businessId}_${line.date}_${line.amt}_${line.desc.hashCode}';
    final data = LedgerRowMapper.bankLineToRow(
      businessId: businessId,
      line: line,
      bankAccountCode: bankAccountCode,
      id: docId,
      matchedJournalEntryId: matchedJournalEntryId,
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
    return result.items.map((i) => Map<String, dynamic>.from(i.value)).toList();
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

    observer = ditto.store.registerObserver(
      query,
      arguments: args,
      onChange: (queryResult) {
        if (controller.isClosed) return;
        final rows = queryResult.items
            .map((i) => Map<String, dynamic>.from(i.value))
            .toList();
        controller.add(rows);
      },
    );

    controller.onCancel = () async {
      await cancelDittoStoreObserver(observer);
      if (!controller.isClosed) await controller.close();
    };

    return controller.stream;
  }
}
