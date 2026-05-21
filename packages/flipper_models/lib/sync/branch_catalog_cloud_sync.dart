import 'dart:async';

import 'package:ditto_live/ditto_live.dart';
import 'package:flipper_models/sync/dql_for_sync_subscription.dart';
import 'package:flutter/foundation.dart';

/// Ditto cloud subscriptions for catalog collections (data-connector bulk writes).
final Set<String> _branchCatalogSubscriptionKeys = {};

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
