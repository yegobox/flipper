import 'dart:async';

import 'package:ditto_live/ditto_live.dart';
import 'package:flipper_models/models/daily_report_file.dart';
import 'package:flipper_models/sync/dql_for_sync_subscription.dart';
import 'package:flutter/foundation.dart';

/// Ditto cloud subscriptions for catalog collections (data-connector bulk writes).
final Set<String> _branchCatalogSubscriptionKeys = {};

/// Ditto cloud/P2P pull for receipt counters (Capella-owned; not Brick-seeded).
final Set<String> _branchCounterSubscriptionKeys = {};

/// Ditto cloud/P2P pull for stock-activity SAR rows (data-connector / peers).
final Set<String> _branchSarSubscriptionKeys = {};

/// Ditto cloud/P2P pull for delegated receipt jobs between POS stations.
final Set<String> _branchDelegationSubscriptionKeys = {};

/// Registers a branch-scoped counter subscription once per branch.
/// Pulls fresh `counters` rows from Ditto mesh/cloud without pushing SQLite.
Future<void> ensureBranchCounterCloudSubscription({
  required Ditto ditto,
  required String branchId,
}) async {
  if (branchId.isEmpty) return;

  final key = 'counters|$branchId';
  if (!_branchCounterSubscriptionKeys.add(key)) {
    return;
  }

  const sql = 'SELECT * FROM counters WHERE branchId = :branchId';
  final args = <String, dynamic>{'branchId': branchId};

  try {
    final prepared = prepareDqlSyncSubscription(sql, args);
    await ditto.sync.registerSubscription(
      prepared.dql,
      arguments: prepared.arguments,
    );
    if (kDebugMode) {
      debugPrint(
        'ensureBranchCounterCloudSubscription: registered $key',
      );
    }
  } catch (e, st) {
    _branchCounterSubscriptionKeys.remove(key);
    debugPrint(
      'ensureBranchCounterCloudSubscription: failed $key: $e\n'
      '${describeDqlSyncSubscriptionAttempt(sql, args)}\n'
      '$st',
    );
  }
}

/// Registers a branch-scoped SAR subscription once per branch.
/// Pulls fresh `sars` rows from Ditto mesh/cloud (e.g. data-connector bulk-add).
Future<void> ensureBranchSarCloudSubscription({
  required Ditto ditto,
  required String branchId,
}) async {
  if (branchId.isEmpty) return;

  final key = 'sars|$branchId';
  if (!_branchSarSubscriptionKeys.add(key)) {
    return;
  }

  const sql = 'SELECT * FROM sars WHERE branchId = :branchId';
  final args = <String, dynamic>{'branchId': branchId};

  try {
    final prepared = prepareDqlSyncSubscription(sql, args);
    await ditto.sync.registerSubscription(
      prepared.dql,
      arguments: prepared.arguments,
    );
    if (kDebugMode) {
      debugPrint(
        'ensureBranchSarCloudSubscription: registered $key',
      );
    }
  } catch (e, st) {
    _branchSarSubscriptionKeys.remove(key);
    debugPrint(
      'ensureBranchSarCloudSubscription: failed $key: $e\n'
      '${describeDqlSyncSubscriptionAttempt(sql, args)}\n'
      '$st',
    );
  }
}

/// Registers a branch-scoped delegation subscription once per branch.
/// Ensures `transaction_delegations` rows replicate across the Ditto mesh;
/// each desktop filters locally by [selectedDelegationDeviceId].
Future<void> ensureBranchDelegationCloudSubscription({
  required Ditto ditto,
  required String branchId,
}) async {
  if (branchId.isEmpty) return;

  final key = 'transaction_delegations|$branchId';
  if (!_branchDelegationSubscriptionKeys.add(key)) {
    return;
  }

  const sql =
      'SELECT * FROM transaction_delegations WHERE branchId = :branchId';
  final args = <String, dynamic>{'branchId': branchId};

  try {
    final prepared = prepareDqlSyncSubscription(sql, args);
    await ditto.sync.registerSubscription(
      prepared.dql,
      arguments: prepared.arguments,
    );
    if (kDebugMode) {
      debugPrint(
        'ensureBranchDelegationCloudSubscription: registered $key',
      );
    }
  } catch (e, st) {
    _branchDelegationSubscriptionKeys.remove(key);
    debugPrint(
      'ensureBranchDelegationCloudSubscription: failed $key: $e\n'
      '${describeDqlSyncSubscriptionAttempt(sql, args)}\n'
      '$st',
    );
  }
}

/// Registers branch-scoped cloud pull subscriptions once per key.
/// Safe to call repeatedly; duplicate keys are skipped.
Future<void> ensureBranchCatalogCloudSubscriptions({
  required Ditto ditto,
  required String branchId,
  String? businessId,
}) async {
  if (branchId.isEmpty) return;

  final entries = <({String key, String sql, Map<String, dynamic> args})>[
    (
      key: 'variants|$branchId',
      sql: 'SELECT * FROM variants WHERE branchId = :branchId',
      args: {'branchId': branchId},
    ),
    (
      key: 'stocks|$branchId',
      sql: 'SELECT * FROM stocks WHERE branchId = :branchId',
      args: {'branchId': branchId},
    ),
    (
      key: 'products|$branchId',
      sql: 'SELECT * FROM products WHERE branchId = :branchId',
      args: {'branchId': branchId},
    ),
    (
      key: 'codes|$branchId',
      sql: 'SELECT * FROM codes WHERE branchId = :branchId',
      args: {'branchId': branchId},
    ),
  ];

  if (businessId != null && businessId.isNotEmpty) {
    entries.add((
      key: 'skus|$branchId|$businessId',
      sql:
          'SELECT * FROM skus WHERE branchId = :branchId AND businessId = :businessId',
      args: {'branchId': branchId, 'businessId': businessId},
    ));
  }

  for (final entry in entries) {
    if (!_branchCatalogSubscriptionKeys.add(entry.key)) {
      continue;
    }
    try {
      final prepared = prepareDqlSyncSubscription(entry.sql, entry.args);
      await ditto.sync.registerSubscription(
        prepared.dql,
        arguments: prepared.arguments,
      );
      if (kDebugMode) {
        debugPrint(
          'ensureBranchCatalogCloudSubscriptions: registered ${entry.key}',
        );
      }
    } catch (e, st) {
      _branchCatalogSubscriptionKeys.remove(entry.key);
      debugPrint(
        'ensureBranchCatalogCloudSubscriptions: failed ${entry.key}: $e\n'
        '${describeDqlSyncSubscriptionAttempt(entry.sql, entry.args)}\n'
        '$st',
      );
    }
  }
}

/// After server-side catalog writes, poll until every non-empty [names] entry
/// exists in Ditto for [branchId] (case-insensitive name match).
Future<bool> waitForVariantNamesInDitto({
  required Ditto ditto,
  required String branchId,
  required List<String> names,
  Duration timeout = const Duration(seconds: 25),
}) async {
  final wanted = names
      .map((n) => n.trim())
      .where((n) => n.isNotEmpty)
      .toSet();
  if (branchId.isEmpty || wanted.isEmpty) return true;

  const pollInterval = Duration(milliseconds: 800);
  final deadline = DateTime.now().add(timeout);

  while (DateTime.now().isBefore(deadline)) {
    try {
      final found = <String>{};
      for (final name in wanted) {
        final result = await ditto.store.execute(
          'SELECT id FROM variants WHERE branchId = :branchId '
          'AND LOWER(COALESCE(name, \'\')) = :name LIMIT 1',
          arguments: {
            'branchId': branchId,
            'name': name.toLowerCase(),
          },
        );
        if (result.items.isNotEmpty) {
          found.add(name);
        }
      }
      if (found.length == wanted.length) {
        return true;
      }
    } catch (e) {
      debugPrint('waitForVariantNamesInDitto: $e');
    }
    await Future.delayed(pollInterval);
  }

  return false;
}

/// Ditto cloud pull for server-generated daily report catalogue rows.
Future<void> ensureDailyReportFilesCloudSubscription({
  required Ditto ditto,
  required String branchId,
}) async {
  if (branchId.isEmpty) return;

  const type = DailyReportFile.dailyDetailedTransactionsXlsxType;
  final key = 'daily_report_files|$branchId|$type';
  if (!_branchCatalogSubscriptionKeys.add(key)) {
    return;
  }

  const sql =
      'SELECT * FROM daily_report_files WHERE branchId = :branchId AND type = :type';
  final args = <String, dynamic>{'branchId': branchId, 'type': type};

  try {
    final prepared = prepareDqlSyncSubscription(sql, args);
    await ditto.sync.registerSubscription(
      prepared.dql,
      arguments: prepared.arguments,
    );
    if (kDebugMode) {
      debugPrint(
        'ensureDailyReportFilesCloudSubscription: registered $key',
      );
    }
  } catch (e, st) {
    _branchCatalogSubscriptionKeys.remove(key);
    debugPrint(
      'ensureDailyReportFilesCloudSubscription: failed $key: $e\n'
      '${describeDqlSyncSubscriptionAttempt(sql, args)}\n'
      '$st',
    );
  }
}
