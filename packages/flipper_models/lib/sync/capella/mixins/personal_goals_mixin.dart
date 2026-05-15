import 'dart:async';

import 'package:flipper_models/helpers/personal_goal_contribution_device_key.dart';
import 'package:flipper_models/helpers/sale_personal_goal_auto_allocation.dart';
import 'package:flipper_models/models/personal_goal.dart';
import 'package:flipper_models/sync/dql_for_sync_subscription.dart';
import 'package:flipper_web/services/ditto_service.dart';
import 'package:supabase_models/brick/models/transactionItem.model.dart';
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

      const broadSql =
          'SELECT * FROM personal_goals WHERE branchId = :branchId';
      const orderedQuery =
          'SELECT * FROM personal_goals WHERE branchId = :branchId ORDER BY isTopPriority DESC, updatedAt DESC';
      final arguments = {'branchId': branchId};

      List<PersonalGoal> mapQueryResult(dynamic queryResult) {
        final list = <PersonalGoal>[];
        for (final item in queryResult.items as Iterable<dynamic>) {
          try {
            list.add(
              PersonalGoal.fromJson(
                Map<String, dynamic>.from(item.value as Map<dynamic, dynamic>),
              ),
            );
          } catch (e) {
            talker.error('Error mapping personal goal: $e');
          }
        }
        return list;
      }

      dynamic observer;
      var cancelled = false;
      var listenStarted = false;

      Future<void> registerBroadBranchSubscription() async {
        final prepared = prepareDqlSyncSubscription(broadSql, arguments);
        try {
          await ditto.sync.registerSubscription(
            prepared.dql,
            arguments: prepared.arguments,
          );
          talker.debug(
            'personal_goals: registered broad branch subscription for sync',
          );
        } catch (e, st) {
          talker.warning(
            'personal_goals: broad registerSubscription failed: $e\n'
            '${describeDqlSyncSubscriptionAttempt(broadSql, arguments)}\n'
            '$st',
          );
        }
      }

      late final StreamController<List<PersonalGoal>> controller;

      controller = StreamController<List<PersonalGoal>>(
        onListen: () {
          if (listenStarted) return;
          listenStarted = true;
          unawaited(() async {
            try {
              await registerBroadBranchSubscription();

              Future<void> emitIfOpen(dynamic queryResult) async {
                if (cancelled || controller.isClosed) return;
                controller.add(mapQueryResult(queryResult));
              }

              /// Returns number of goals emitted (0 while store still empty).
              Future<int> executeAndEmit() async {
                if (cancelled || controller.isClosed) return -1;
                final r = await ditto.store.execute(
                  orderedQuery,
                  arguments: arguments,
                );
                if (cancelled || controller.isClosed) return -1;
                final list = mapQueryResult(r);
                controller.add(list);
                return list.length;
              }

              if (cancelled || controller.isClosed) return;

              // Register the observer before any retry sleeps so replication that
              // lands during cold-start backoff still pushes updates (otherwise
              // the UI can stay empty until pull-to-refresh recreates the stream).
              observer = ditto.store.registerObserver(
                orderedQuery,
                arguments: arguments,
                onChange: (queryResult) {
                  unawaited(emitIfOpen(queryResult));
                },
              );

              var count = await executeAndEmit();

              // [CapellaVariantMixin]-style short waits when the first read is empty
              // while Ditto / cloud sync is still landing.
              if (count == 0) {
                for (final d in const [
                  Duration(milliseconds: 600),
                  Duration(milliseconds: 1200),
                ]) {
                  if (cancelled || controller.isClosed) break;
                  await Future<void>.delayed(d);
                  if (cancelled || controller.isClosed) break;
                  count = await executeAndEmit();
                  if (count > 0) break;
                }
              }
              // One longer read for slow mesh / cold devices; avoid the full
              // [OuterVariants] multi-second chain so an empty branch is not
              // blocked for ~10s+ on every open.
              if (count == 0) {
                if (!cancelled && !controller.isClosed) {
                  await Future<void>.delayed(
                    const Duration(milliseconds: 2000),
                  );
                  if (!cancelled && !controller.isClosed) {
                    await executeAndEmit();
                  }
                }
              }
            } catch (e, s) {
              talker.error('Error in personalGoalsStream setup: $e\n$s');
              if (!cancelled && !controller.isClosed) {
                controller.add(<PersonalGoal>[]);
              }
            }
          }());
        },
        onCancel: () async {
          cancelled = true;
          try {
            await observer?.cancel();
          } catch (e) {
            talker.warning('personalGoalsStream: observer cancel failed: $e');
          }
          if (!controller.isClosed) {
            await controller.close();
          }
        },
      );

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
        .copyWith(updatedAt: now, createdAt: goal.createdAt ?? now)
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
    final deviceKey = await personalGoalContributionDeviceKey();
    final now = DateTime.now();
    final doc = existing
        .copyWith(savedAmount: newSaved, updatedAt: now)
        .toJson();
    doc['lastContributionDeviceKey'] = deviceKey;
    doc['lastContributionAmount'] = amount;
    if (transactionId != null && transactionId.isNotEmpty) {
      doc['lastContributionTransactionId'] = transactionId;
    } else {
      doc.remove('lastContributionTransactionId');
    }

    await ditto.store.execute(
      'INSERT INTO personal_goals DOCUMENTS (:doc) ON ID CONFLICT DO UPDATE',
      arguments: {'doc': doc},
    );
  }

  /// After a completed Capella payment, move a slice into goals that have
  /// [PersonalGoal.autoAllocationPercent] set: **sales** use gross line profit;
  /// **utility cash book cash-in** ([completeCashMovement]) uses the movement total.
  /// Idempotent per transaction via `personalGoalSweepApplied` on the transaction
  /// document in Ditto.
  Future<void> applyPersonalGoalAutoSweepIfEligible({
    required String branchId,
    required String transactionId,
    required String? completionStatus,
    required bool isIncome,
    required bool isProformaMode,
    required bool isTrainingMode,
    required String? transactionType,
    required List<TransactionItem> items,
    bool isUtilityCashbookMovement = false,
    bool skipPersonalGoalAutoSweep = false,
  }) async {
    final movementSubtotal = items.fold<double>(
      0.0,
      (a, b) => a + b.price.toDouble() * b.qty.toDouble(),
    );

    final utilityCashInEligible =
        !skipPersonalGoalAutoSweep &&
        shouldAttemptPersonalGoalUtilityCashInSweep(
          completionStatus: completionStatus,
          isIncome: isIncome,
          isProformaMode: isProformaMode,
          isTrainingMode: isTrainingMode,
          isUtilityCashbookMovement: isUtilityCashbookMovement,
          movementSubTotal: movementSubtotal,
        );

    final saleEligible =
        !skipPersonalGoalAutoSweep &&
        !isUtilityCashbookMovement &&
        shouldAttemptPersonalGoalSaleSweep(
          completionStatus: completionStatus,
          isIncome: isIncome,
          isProformaMode: isProformaMode,
          isTrainingMode: isTrainingMode,
          transactionType: transactionType,
          hasProductLineItems: items.isNotEmpty,
        );

    if (!saleEligible && !utilityCashInEligible) {
      return;
    }

    final ditto = dittoService.dittoInstance;
    if (ditto == null) {
      talker.warning('applyPersonalGoalAutoSweepIfEligible: Ditto not ready');
      return;
    }

    if (await _transactionPersonalGoalSweepApplied(transactionId)) {
      return;
    }

    final double allocationBase;
    if (utilityCashInEligible) {
      allocationBase = movementSubtotal;
    } else {
      allocationBase = computeSaleGrossProfitFromSaleLines(
        items
            .map(
              (item) => SaleLineForProfit(
                price: item.price.toDouble(),
                qty: item.qty.toDouble(),
                supplyPriceAtSale: item.supplyPriceAtSale?.toDouble(),
                supplyPrice: item.supplyPrice?.toDouble(),
                ignoreForReport: item.ignoreForReport == true,
                partOfComposite: item.partOfComposite == true,
              ),
            )
            .toList(),
      );
    }

    if (allocationBase <= 0) {
      return;
    }

    List<PersonalGoal> goals;
    try {
      final result = await ditto.store.execute(
        'SELECT * FROM personal_goals WHERE branchId = :branchId',
        arguments: {'branchId': branchId},
      );
      goals = <PersonalGoal>[];
      for (final row in result.items) {
        try {
          goals.add(
            PersonalGoal.fromJson(Map<String, dynamic>.from(row.value)),
          );
        } catch (e) {
          talker.warning(
            'applyPersonalGoalAutoSweepIfEligible: bad goal row $e',
          );
        }
      }
    } catch (e, s) {
      talker.error('applyPersonalGoalAutoSweepIfEligible: load goals $e\n$s');
      return;
    }

    final contributions = computeAutoAllocationContributions(
      allocationBase: allocationBase,
      goals: goals,
    );
    if (contributions.isEmpty) {
      return;
    }

    try {
      for (final c in contributions) {
        await addToGoalSavedAmount(
          goalId: c.goalId,
          branchId: branchId,
          amount: c.amount,
          transactionId: transactionId,
        );
      }
      await _markTransactionPersonalGoalSweepApplied(transactionId);
    } catch (e, s) {
      talker.error('applyPersonalGoalAutoSweepIfEligible: sweep failed $e\n$s');
    }
  }

  Future<bool> _transactionPersonalGoalSweepApplied(
    String transactionId,
  ) async {
    final ditto = dittoService.dittoInstance;
    if (ditto == null) return false;
    try {
      final result = await ditto.store.execute(
        'SELECT * FROM transactions WHERE (_id = :id OR id = :id) LIMIT 1',
        arguments: {'id': transactionId},
      );
      if (result.items.isEmpty) return false;
      final doc = Map<String, dynamic>.from(result.items.first.value);
      final v = doc['personalGoalSweepApplied'];
      if (v is bool) return v;
      if (v is num) return v != 0;
      if (v is String) {
        final lower = v.toLowerCase();
        return lower == 'true' || lower == '1';
      }
      return false;
    } catch (e) {
      talker.warning('_transactionPersonalGoalSweepApplied: $e');
      return false;
    }
  }

  Future<void> _markTransactionPersonalGoalSweepApplied(
    String transactionId,
  ) async {
    final ditto = dittoService.dittoInstance;
    if (ditto == null) return;
    try {
      await ditto.store.execute(
        'UPDATE transactions SET personalGoalSweepApplied = :applied, '
        'personalGoalSweepAt = :ts WHERE (_id = :id OR id = :id)',
        arguments: {
          'id': transactionId,
          'applied': true,
          'ts': DateTime.now().toUtc().toIso8601String(),
        },
      );
    } catch (e) {
      talker.warning(
        'Could not stamp personalGoalSweepApplied on transaction '
        '$transactionId (idempotency may be weaker): $e',
      );
    }
  }
}
