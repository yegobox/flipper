import 'dart:async';

import 'package:ditto_live/ditto_live.dart';
import 'package:flipper_models/sync/dql_for_sync_subscription.dart';
import 'package:flutter/foundation.dart';

final Set<String> _accountingSubscriptionKeys = {};

/// Cloud pull subscriptions for GL + POS collections (mirrors
/// [ensureBranchCatalogCloudSubscriptions] for catalog data).
Future<void> ensureAccountingCloudSubscriptions({
  required Ditto ditto,
  required String businessId,
  String? branchId,
}) async {
  if (businessId.isEmpty) return;

  final entries = <({String key, String sql, Map<String, dynamic> args})>[
    (
      key: 'chart_of_accounts|$businessId',
      sql: 'SELECT * FROM chart_of_accounts WHERE businessId = :businessId',
      args: {'businessId': businessId},
    ),
    (
      key: 'journal_entries|$businessId',
      sql: 'SELECT * FROM journal_entries WHERE businessId = :businessId',
      args: {'businessId': businessId},
    ),
    // Lines lack businessId in Supabase; replicate all and join via entry id.
    (
      key: 'journal_lines|all',
      sql: 'SELECT * FROM journal_lines',
      args: const <String, dynamic>{},
    ),
    (
      key: 'bank_statement_lines|$businessId',
      sql:
          'SELECT * FROM bank_statement_lines WHERE businessId = :businessId',
      args: {'businessId': businessId},
    ),
    (
      key: 'accounting_settings|$businessId',
      sql: 'SELECT * FROM accounting_settings WHERE businessId = :businessId',
      args: {'businessId': businessId},
    ),
  ];

  if (branchId != null && branchId.isNotEmpty) {
    entries.add((
      key: 'transactions|$branchId',
      sql:
          'SELECT * FROM transactions WHERE branchId = :branchId AND status = :status',
      args: {'branchId': branchId, 'status': 'COMPLETE'},
    ));
    entries.add((
      key: 'transaction_items|$branchId',
      sql: 'SELECT * FROM transaction_items WHERE branchId = :branchId',
      args: {'branchId': branchId},
    ));
    // Canonical party stores shared with POS (Books contacts superset).
    entries.add((
      key: 'customers|$branchId',
      sql: 'SELECT * FROM customers WHERE branchId = :branchId',
      args: {'branchId': branchId},
    ));
    entries.add((
      key: 'suppliers|$branchId',
      sql: 'SELECT * FROM suppliers WHERE branchId = :branchId',
      args: {'branchId': branchId},
    ));
  }

  for (final entry in entries) {
    if (!_accountingSubscriptionKeys.add(entry.key)) continue;
    try {
      final prepared = prepareDqlSyncSubscription(entry.sql, entry.args);
      await ditto.sync.registerSubscription(
        prepared.dql,
        arguments: prepared.arguments,
      );
      debugPrint(
        '[Accounting] cloud subscription registered ${entry.key}',
      );
    } catch (e, st) {
      _accountingSubscriptionKeys.remove(entry.key);
      debugPrint(
        '[Accounting] cloud subscription failed ${entry.key}: $e\n'
        '${describeDqlSyncSubscriptionAttempt(entry.sql, entry.args)}\n'
        '$st',
      );
    }
  }
}

/// Poll until at least one journal entry exists (post-restart / post-sync).
Future<bool> waitForJournalEntriesInDitto({
  required Ditto ditto,
  required String businessId,
  Duration timeout = const Duration(seconds: 15),
}) async {
  if (businessId.isEmpty) return false;

  const pollInterval = Duration(milliseconds: 800);
  final deadline = DateTime.now().add(timeout);

  while (DateTime.now().isBefore(deadline)) {
    try {
      final result = await ditto.store.execute(
        'SELECT id FROM journal_entries WHERE businessId = :businessId LIMIT 1',
        arguments: {'businessId': businessId},
      );
      if (result.items.isNotEmpty) return true;
    } catch (e) {
      debugPrint('[Accounting] waitForJournalEntriesInDitto: $e');
    }
    await Future.delayed(pollInterval);
  }
  return false;
}
