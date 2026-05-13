import 'dart:async';

import 'package:flipper_models/models/personal_goal.dart';
import 'package:flipper_models/sync/dql_for_sync_subscription.dart';
import 'package:flipper_web/services/ditto_service.dart';
import 'package:talker/talker.dart';

mixin CapellaPersonalGoalsMixin {
  DittoService get dittoService;
  Talker get talker;

  Stream<List<PersonalGoal>> personalGoalsStream({required String branchId}) {
    try {
      final ditto = dittoService.dittoInstance;
      if (ditto == null) {
        talker.error('Ditto not initialized (personalGoalsStream)');
        return Stream.value(<PersonalGoal>[]);
      }

      final prepared = prepareDqlSyncSubscription(
        'SELECT * FROM personal_goals WHERE branchId = :branchId',
        {'branchId': branchId},
      );
      ditto.sync.registerSubscription(
        prepared.dql,
        arguments: prepared.arguments,
      );

      const query =
          'SELECT * FROM personal_goals WHERE branchId = :branchId ORDER BY isTopPriority DESC, updatedAt DESC';
      final controller = StreamController<List<PersonalGoal>>.broadcast();
      dynamic observer;

      observer = ditto.store.registerObserver(
        query,
        arguments: {'branchId': branchId},
        onChange: (queryResult) {
          if (controller.isClosed) return;
          final list = <PersonalGoal>[];
          for (final item in queryResult.items) {
            try {
              list.add(
                PersonalGoal.fromJson(Map<String, dynamic>.from(item.value)),
              );
            } catch (e) {
              talker.error('Error mapping personal goal: $e');
            }
          }
          controller.add(list);
        },
      );

      controller.onCancel = () async {
        await observer?.cancel();
        await controller.close();
      };

      return controller.stream;
    } catch (e) {
      talker.error('Error in personalGoalsStream: $e');
      return Stream.value(<PersonalGoal>[]);
    }
  }

  Future<void> upsertPersonalGoal(PersonalGoal goal) async {
    final ditto = dittoService.dittoInstance;
    if (ditto == null) {
      talker.error('Ditto not initialized (upsertPersonalGoal)');
      throw StateError('Ditto not initialized');
    }

    final now = DateTime.now();
    final doc = goal
        .copyWith(
          updatedAt: now,
          createdAt: goal.createdAt ?? now,
        )
        .toJson();

    await ditto.store.execute(
      'INSERT INTO personal_goals DOCUMENTS (:doc) ON ID CONFLICT DO UPDATE',
      arguments: {'doc': doc},
    );
  }

  Future<void> deletePersonalGoal({
    required String id,
    required String branchId,
  }) async {
    final ditto = dittoService.dittoInstance;
    if (ditto == null) {
      talker.error('Ditto not initialized (deletePersonalGoal)');
      throw StateError('Ditto not initialized');
    }

    await ditto.store.execute(
      'DELETE FROM personal_goals WHERE (_id = :id OR id = :id) AND branchId = :branchId',
      arguments: {'id': id, 'branchId': branchId},
    );
  }

  Future<void> addToGoalSavedAmount({
    required String goalId,
    required String branchId,
    required double amount,
    String? transactionId,
  }) async {
    if (amount == 0) return;

    final ditto = dittoService.dittoInstance;
    if (ditto == null) {
      talker.error('Ditto not initialized (addToGoalSavedAmount)');
      throw StateError('Ditto not initialized');
    }

    final result = await ditto.store.execute(
      'SELECT * FROM personal_goals WHERE (_id = :id OR id = :id) AND branchId = :branchId LIMIT 1',
      arguments: {'id': goalId, 'branchId': branchId},
    );

    if (result.items.isEmpty) {
      talker.warning('addToGoalSavedAmount: goal not found $goalId');
      return;
    }

    final raw = Map<String, dynamic>.from(result.items.first.value);
    final existing = PersonalGoal.fromJson(raw);
    double toDouble(dynamic v) {
      if (v == null) return 0;
      if (v is num) return v.toDouble();
      return double.tryParse(v.toString()) ?? 0;
    }

    final newSaved = toDouble(raw['savedAmount']) + amount;
    final now = DateTime.now();
    final doc = existing
        .copyWith(
          savedAmount: newSaved,
          updatedAt: now,
        )
        .toJson();
    if (transactionId != null && transactionId.isNotEmpty) {
      doc['lastContributionTransactionId'] = transactionId;
    }

    await ditto.store.execute(
      'INSERT INTO personal_goals DOCUMENTS (:doc) ON ID CONFLICT DO UPDATE',
      arguments: {'doc': doc},
    );
  }
}
