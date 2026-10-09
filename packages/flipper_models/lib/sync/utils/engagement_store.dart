import 'dart:async';

import 'package:flipper_models/helpers/daily_goal_rules.dart';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_models/models/engagement.dart';
import 'package:flipper_models/sync/ditto_observer_registry.dart';
import 'package:flipper_services/constants.dart';

/// Ditto reads and writes for "Today's goal".
///
/// One observer per stream, opened on listen and cancelled with it, so the
/// card costs nothing when it is off screen.
class EngagementStore {
  EngagementStore(this.ditto);

  /// A `Ditto` instance (dynamic, as elsewhere in Capella code).
  final dynamic ditto;

  static const stateCollection = 'engagement_state';
  static const settingsCollection = 'engagement_settings';

  Stream<T> _observe<T>({
    required String name,
    required String collection,
    required String query,
    required Map<String, dynamic> arguments,
    required T Function(List<Map<String, dynamic>> rows) map,
    bool subscribe = true,
  }) {
    late final StreamController<T> controller;
    TrackedDittoObserver? observer;
    controller = StreamController<T>(
      onListen: () {
        try {
          if (subscribe) {
            ditto.sync.registerSubscription(query, arguments: arguments);
          }
          observer = registerTrackedObserver(
            ditto: ditto,
            name: name,
            collection: collection,
            query: query,
            arguments: arguments,
            onChange: (result) {
              if (controller.isClosed) return;
              final rows = <Map<String, dynamic>>[
                for (final item in result.items)
                  Map<String, dynamic>.from(item.value as Map),
              ];
              controller.add(map(rows));
            },
          );
        } catch (e, s) {
          talker.error('EngagementStore.$name: $e', s);
          controller.addError(e, s);
        }
      },
      onCancel: () async {
        await observer?.cancel();
        observer = null;
      },
    );
    return controller.stream;
  }

  /// The server's view of the branch: streak, points, today's target.
  Stream<EngagementState?> state(String branchId) => _observe(
    name: 'engagementState',
    collection: stateCollection,
    query: 'SELECT * FROM $stateCollection WHERE _id = :id',
    arguments: {'id': branchId},
    map: (rows) => rows.isEmpty ? null : EngagementState.fromDitto(rows.first),
  );

  Stream<EngagementSettings?> settings(String branchId) => _observe(
    name: 'engagementSettings',
    collection: settingsCollection,
    query: 'SELECT * FROM $settingsCollection WHERE _id = :id',
    arguments: {'id': branchId},
    map: (rows) =>
        rows.isEmpty ? null : EngagementSettings.fromDitto(rows.first),
  );

  Future<void> saveSettings(EngagementSettings settings) async {
    await ditto.store.execute(
      'INSERT INTO $settingsCollection DOCUMENTS (:doc) ON ID CONFLICT DO UPDATE',
      arguments: {'doc': settings.toDitto()},
    );
  }

  /// What the branch has recorded since [since] (local midnight), counted the
  /// way the server counts a day: completed sales, expenses, and deliberate
  /// stock movements (see [isStockMovement]).
  Stream<TodayActivity> today(String branchId, DateTime since) => _observe(
    name: 'engagementToday',
    collection: 'transactions',
    query:
        'SELECT status, isExpense, receiptType, transactionType FROM transactions '
        'WHERE branchId = :branchId AND createdAt >= :since',
    arguments: {'branchId': branchId, 'since': since.toIso8601String()},
    // The POS already subscribes to the branch's transactions.
    subscribe: false,
    map: countToday,
  );

  /// A stock adjustment (adding or adjusting stock), or a recorded supplier
  /// purchase.
  ///
  /// Decided by `receiptType` and the purchase recorder's own
  /// `transactionType` only. A cash-out's `transactionType` is whatever
  /// category the user picked (`cashMovementClassification`), so an expense
  /// filed under "Purchase" must not count as stock; nor does paying a
  /// supplier's bill ('Supplier payment', also receipt type 'Purchase').
  /// Mirrored in the supabase `engagement_activity` function.
  static bool isStockMovement(Map<String, dynamic> r) =>
      r['receiptType'] == TransactionType.adjustment ||
      (r['receiptType'] == 'Purchase' &&
          r['transactionType'] == 'Supplier purchase');

  static TodayActivity countToday(List<Map<String, dynamic>> rows) {
    var sales = 0, expenses = 0, stock = 0;
    for (final r in rows) {
      final isStock = isStockMovement(r);
      final isExpense = r['isExpense'] == true;
      if (isStock) {
        stock++;
      } else if (isExpense) {
        expenses++;
      } else if (r['status'] == COMPLETE) {
        sales++;
      }
    }
    return TodayActivity(sales: sales, expenses: expenses, stockUpdates: stock);
  }
}
