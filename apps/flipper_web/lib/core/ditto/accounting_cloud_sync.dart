import 'dart:async';

import 'package:ditto_live/ditto_live.dart';
import 'package:flipper_models/sync/dql_for_sync_subscription.dart';
import 'package:flutter/foundation.dart';

final Set<String> _accountingSubscriptionKeys = {};

/// Clears dedupe cache so the next bootstrap re-registers cloud subscriptions.
void resetAccountingCloudSubscriptionKeys() {
  _accountingSubscriptionKeys.clear();
  debugPrint('[Accounting] cloud subscription keys cleared');
}

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
      sql:
          'SELECT * FROM chart_of_accounts '
          'WHERE businessId = :businessId OR business_id = :businessId',
      args: {'businessId': businessId},
    ),
    (
      key: 'journal_entries|$businessId',
      sql:
          'SELECT * FROM journal_entries '
          'WHERE businessId = :businessId OR business_id = :businessId',
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
      sql: 'SELECT * FROM bank_statement_lines WHERE businessId = :businessId',
      args: {'businessId': businessId},
    ),
    (
      key: 'accounting_settings|$businessId',
      sql: 'SELECT * FROM accounting_settings WHERE businessId = :businessId',
      args: {'businessId': businessId},
    ),
    (
      key: 'accounting_audit_logs|$businessId',
      sql: 'SELECT * FROM accounting_audit_logs WHERE businessId = :businessId',
      args: {'businessId': businessId},
    ),
    (
      key: 'accounting_recurring_schedules|$businessId',
      sql:
          'SELECT * FROM accounting_recurring_schedules '
          'WHERE businessId = :businessId',
      args: {'businessId': businessId},
    ),
  ];

  if (branchId != null && branchId.isNotEmpty) {
    // POS uses lowercase `completed` / `parked` (flipper_services/constants.dart).
    entries.add((
      key: 'transactions|$branchId',
      sql:
          'SELECT * FROM transactions WHERE branchId = :branchId '
          'AND (status = :completed OR status = :parked) '
          'AND subTotal > 0',
      args: {
        'branchId': branchId,
        'completed': 'completed',
        'parked': 'parked',
      },
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
      debugPrint('[Accounting] cloud subscription registered ${entry.key}');
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

/// Waits until chart of accounts rows replicate for [businessId] (or times out).
///
/// Books gates the shell on COA presence — journals and transactions can stream
/// in after the shell is visible.
Future<bool> waitForChartOfAccountsReplication({
  required Ditto ditto,
  required String businessId,
  Duration? timeout,
}) async {
  if (businessId.isEmpty) return false;

  final effectiveTimeout = timeout ?? const Duration(seconds: 15);

  const pollInterval = Duration(milliseconds: 500);
  final deadline = DateTime.now().add(effectiveTimeout);
  debugPrint(
    '[Accounting] waiting for COA replication businessId=$businessId '
    'timeout=${effectiveTimeout.inSeconds}s',
  );

  while (DateTime.now().isBefore(deadline)) {
    try {
      final coa = await ditto.store.execute(
        'SELECT _id FROM chart_of_accounts '
        'WHERE businessId = :businessId OR business_id = :businessId LIMIT 1',
        arguments: {'businessId': businessId},
      );
      if (coa.items.isNotEmpty) {
        debugPrint('[Accounting] replication: chart_of_accounts present');
        return true;
      }
    } catch (e) {
      debugPrint('[Accounting] waitForChartOfAccountsReplication poll: $e');
    }
    await Future.delayed(pollInterval);
  }

  debugPrint('[Accounting] COA replication wait timed out');
  return false;
}

/// Waits for cloud replication to deliver GL/POS rows (or times out).
///
/// Returns `true` when at least one subscribed row is visible via DQL.
///
/// Books registers subscriptions then must not seed/read until the first
/// replication cycle completes — otherwise local seed races empty cloud state.
Future<bool> waitForAccountingReplication({
  required Ditto ditto,
  required String businessId,
  String? branchId,
  Duration? timeout,
}) async {
  if (businessId.isEmpty) return false;

  final effectiveTimeout = timeout ?? const Duration(seconds: 15);

  const pollInterval = Duration(milliseconds: 500);
  final deadline = DateTime.now().add(effectiveTimeout);
  debugPrint(
    '[Accounting] waiting for replication businessId=$businessId '
    'branchId=${branchId ?? "(none)"} timeout=${effectiveTimeout.inSeconds}s',
  );

  while (DateTime.now().isBefore(deadline)) {
    try {
      final coa = await ditto.store.execute(
        'SELECT _id FROM chart_of_accounts '
        'WHERE businessId = :businessId OR business_id = :businessId LIMIT 1',
        arguments: {'businessId': businessId},
      );
      if (coa.items.isNotEmpty) {
        debugPrint('[Accounting] replication: chart_of_accounts present');
        return true;
      }

      final journal = await ditto.store.execute(
        'SELECT _id FROM journal_entries '
        'WHERE businessId = :businessId OR business_id = :businessId LIMIT 1',
        arguments: {'businessId': businessId},
      );
      if (journal.items.isNotEmpty) {
        debugPrint('[Accounting] replication: journal_entries present');
        return true;
      }

      if (branchId != null && branchId.isNotEmpty) {
        final txns = await ditto.store.execute(
          'SELECT _id FROM transactions WHERE branchId = :branchId LIMIT 1',
          arguments: {'branchId': branchId},
        );
        if (txns.items.isNotEmpty) {
          debugPrint('[Accounting] replication: transactions present');
          return true;
        }
      }
    } catch (e) {
      debugPrint('[Accounting] waitForAccountingReplication poll: $e');
    }
    await Future.delayed(pollInterval);
  }

  debugPrint('[Accounting] replication wait timed out');
  return false;
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
        'SELECT id FROM journal_entries '
        'WHERE businessId = :businessId OR business_id = :businessId LIMIT 1',
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
