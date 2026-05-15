import 'dart:async';

import 'package:flipper_models/helpers/personal_goal_contribution_device_key.dart';
import 'package:flipper_models/helpers/personal_goals_branch_cache.dart';
import 'package:flipper_models/helpers/sale_personal_goal_auto_allocation.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_models/models/personal_goal.dart';
import 'package:flipper_models/sync/dql_for_sync_subscription.dart';
import 'package:flipper_web/services/ditto_service.dart';
import 'package:supabase_models/brick/models/transactionItem.model.dart';
import 'package:talker/talker.dart';

mixin CapellaPersonalGoalsMixin {
  DittoService get dittoService;
  Talker get talker;

  static const _personalGoalsBroadSql =
      'SELECT * FROM personal_goals WHERE branchId = :branchId';
  static const _personalGoalsAllSql = 'SELECT * FROM personal_goals';

  static bool _collectionWideSubscriptionRegistered = false;

  List<PersonalGoal> _personalGoalsFromQueryResult(dynamic queryResult) {
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

  static bool _branchIdsMatch(String a, String b) =>
      a.trim().toLowerCase() == b.trim().toLowerCase();

  List<PersonalGoal> _goalsForBranchFromAllRows(
    List<PersonalGoal> all,
    String branchId,
  ) =>
      all.where((g) => _branchIdsMatch(g.branchId, branchId)).toList();

  void _cacheBranchGoals(String branchId, List<PersonalGoal> goals) {
    if (branchId.isEmpty || goals.isEmpty) return;
    PersonalGoalsBranchCache.putBranchGoals(branchId, goals);
  }

  Future<void> _registerPersonalGoalsCollectionSubscription(
    dynamic ditto,
  ) async {
    if (_collectionWideSubscriptionRegistered) return;
    final prepared = prepareDqlSyncSubscription(_personalGoalsAllSql, null);
    try {
      await ditto.sync.registerSubscription(
        prepared.dql,
        arguments: prepared.arguments,
      );
      _collectionWideSubscriptionRegistered = true;
      talker.debug(
        'personal_goals: registered collection-wide subscription for sync',
      );
    } catch (e, st) {
      talker.warning(
        'personal_goals: collection-wide registerSubscription failed: $e\n'
        '${describeDqlSyncSubscriptionAttempt(_personalGoalsAllSql, null)}\n'
        '$st',
      );
    }
  }

  Future<void> _registerPersonalGoalsBranchSubscription(
    dynamic ditto,
    String branchId,
  ) async {
    await _registerPersonalGoalsCollectionSubscription(ditto);
    final arguments = {'branchId': branchId};
    final prepared = prepareDqlSyncSubscription(_personalGoalsBroadSql, arguments);
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
        '${describeDqlSyncSubscriptionAttempt(_personalGoalsBroadSql, arguments)}\n'
        '$st',
      );
    }
  }

  /// Loads branch goals: memory cache → Ditto (branch query) → unfiltered scan.
  Future<List<PersonalGoal>> _loadPersonalGoalsForBranch(
    dynamic ditto,
    String branchId, {
    bool retryWhenEmpty = true,
  }) async {
    final cached = PersonalGoalsBranchCache.goalsForBranch(branchId);
    if (cached != null && cached.isNotEmpty) {
      talker.debug(
        'personal_goals: using ${cached.length} cached goals for branch $branchId',
      );
      return cached;
    }

    await _registerPersonalGoalsBranchSubscription(ditto, branchId);
    final arguments = {'branchId': branchId};

    Future<List<PersonalGoal>> executeBranchQuery() async {
      final result = await ditto.store.execute(
        _personalGoalsBroadSql,
        arguments: arguments,
      );
      return _personalGoalsFromQueryResult(result);
    }

    Future<List<PersonalGoal>> executeUnfilteredScan() async {
      final result = await ditto.store.execute(_personalGoalsAllSql);
      final all = _personalGoalsFromQueryResult(result);
      return _goalsForBranchFromAllRows(all, branchId);
    }

    Future<List<PersonalGoal>> loadOnce() async {
      var goals = await executeBranchQuery();
      if (goals.isEmpty) {
        goals = await executeUnfilteredScan();
        if (goals.isNotEmpty) {
          talker.info(
            'personal_goals: branch query empty; found ${goals.length} via '
            'collection scan for $branchId',
          );
        }
      }
      if (goals.isNotEmpty) {
        _cacheBranchGoals(branchId, goals);
      }
      return goals;
    }

    var goals = await loadOnce();
    if (!retryWhenEmpty || goals.isNotEmpty) return goals;

    const delays = <Duration>[
      Duration(milliseconds: 600),
      Duration(milliseconds: 1200),
      Duration(milliseconds: 2000),
      Duration(milliseconds: 3500),
      Duration(milliseconds: 5000),
    ];
    for (final d in delays) {
      await Future<void>.delayed(d);
      goals = await loadOnce();
      if (goals.isNotEmpty) return goals;
    }

    final boxBranchId = ProxyService.box.getBranchId();
    if (boxBranchId != null &&
        boxBranchId.isNotEmpty &&
        !_branchIdsMatch(boxBranchId, branchId)) {
      talker.warning(
        'personal_goals: still empty for branchId=$branchId '
        '(box branchId=$boxBranchId)',
      );
    }
    return goals;
  }

  Stream<List<PersonalGoal>> personalGoalsStream({required String branchId}) {
    try {
      final ditto = dittoService.dittoInstance;
      if (ditto == null) {
        talker.error('Ditto not initialized (personalGoalsStream)');
        return Stream.value(<PersonalGoal>[]);
      }

      const orderedQuery =
          'SELECT * FROM personal_goals WHERE branchId = :branchId ORDER BY isTopPriority DESC, updatedAt DESC';
      final arguments = {'branchId': branchId};

      dynamic observer;
      var cancelled = false;
      var listenStarted = false;

      late final StreamController<List<PersonalGoal>> controller;

      controller = StreamController<List<PersonalGoal>>(
        onListen: () {
          if (listenStarted) return;
          listenStarted = true;
          unawaited(() async {
            try {
              await _registerPersonalGoalsBranchSubscription(ditto, branchId);

              Future<void> emitIfOpen(dynamic queryResult) async {
                if (cancelled || controller.isClosed) return;
                final list = _personalGoalsFromQueryResult(queryResult);
                _cacheBranchGoals(branchId, list);
                controller.add(list);
              }

              /// Returns number of goals emitted (0 while store still empty).
              Future<int> executeAndEmit() async {
                if (cancelled || controller.isClosed) return -1;
                final r = await ditto.store.execute(
                  orderedQuery,
                  arguments: arguments,
                );
                if (cancelled || controller.isClosed) return -1;
                final list = _personalGoalsFromQueryResult(r);
                _cacheBranchGoals(branchId, list);
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
    PersonalGoalsBranchCache.upsertGoal(
      goal.copyWith(
        updatedAt: now,
        createdAt: goal.createdAt ?? now,
      ),
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
    PersonalGoalsBranchCache.removeGoal(branchId: branchId, goalId: id);
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
    PersonalGoalsBranchCache.upsertGoal(
      existing.copyWith(
        savedAmount: newSaved,
        updatedAt: now,
        lastContributionDeviceKey: deviceKey,
        lastContributionAmount: amount,
        lastContributionTransactionId: transactionId,
      ),
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

    final saleLines = items
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
        .toList();

    final double allocationBase;
    if (utilityCashInEligible) {
      allocationBase = movementSubtotal;
    } else {
      final gross = computeSaleGrossProfitFromSaleLines(saleLines);
      if (gross > 0) {
        allocationBase = gross;
      } else {
        // Gross profit 0 is common when supply equals retail or COGS tracks sale price.
        allocationBase = computeSaleLineRevenueForPersonalGoals(saleLines);
        if (allocationBase > 0) {
          talker.info(
            'applyPersonalGoalAutoSweepIfEligible: gross profit <= 0 '
            'for txn $transactionId; using line revenue $allocationBase as base',
          );
        }
      }
    }

    if (allocationBase <= 0) {
      talker.debug(
        'applyPersonalGoalAutoSweepIfEligible: skip txn $transactionId — '
        'allocationBase=$allocationBase (no gross profit / revenue after filters)',
      );
      return;
    }

    List<PersonalGoal> goals;
    try {
      goals = await _loadPersonalGoalsForBranch(ditto, branchId);
    } catch (e, s) {
      talker.error('applyPersonalGoalAutoSweepIfEligible: load goals $e\n$s');
      return;
    }

    final contributions = computeAutoAllocationContributions(
      allocationBase: allocationBase,
      goals: goals,
    );
    if (contributions.isEmpty) {
      talker.debug(
        'applyPersonalGoalAutoSweepIfEligible: skip txn $transactionId — '
        '${goals.length} goals loaded, no positive autoAllocationPercent contributions '
        '(base=$allocationBase)',
      );
      if (goals.isEmpty) {
        unawaited(
          _retryPersonalGoalSweepWhenGoalsArrive(
            branchId: branchId,
            transactionId: transactionId,
            allocationBase: allocationBase,
            completionStatus: completionStatus,
            isIncome: isIncome,
            isProformaMode: isProformaMode,
            isTrainingMode: isTrainingMode,
            transactionType: transactionType,
            items: items,
            isUtilityCashbookMovement: isUtilityCashbookMovement,
            skipPersonalGoalAutoSweep: skipPersonalGoalAutoSweep,
            utilityCashInEligible: utilityCashInEligible,
            saleEligible: saleEligible,
          ),
        );
      }
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

  /// If goals were not replicated yet at payment time, try again once after a
  /// short delay (does not block [collectPayment]).
  Future<void> _retryPersonalGoalSweepWhenGoalsArrive({
    required String branchId,
    required String transactionId,
    required double allocationBase,
    required String? completionStatus,
    required bool isIncome,
    required bool isProformaMode,
    required bool isTrainingMode,
    required String? transactionType,
    required List<TransactionItem> items,
    required bool isUtilityCashbookMovement,
    required bool skipPersonalGoalAutoSweep,
    required bool utilityCashInEligible,
    required bool saleEligible,
  }) async {
    if (!saleEligible && !utilityCashInEligible) return;
    if (await _transactionPersonalGoalSweepApplied(transactionId)) return;

    const delays = <Duration>[
      Duration(seconds: 3),
      Duration(seconds: 8),
    ];
    for (final d in delays) {
      await Future<void>.delayed(d);
      if (await _transactionPersonalGoalSweepApplied(transactionId)) return;

      final ditto = dittoService.dittoInstance;
      if (ditto == null) return;

      final goals = await _loadPersonalGoalsForBranch(ditto, branchId);
      final contributions = computeAutoAllocationContributions(
        allocationBase: allocationBase,
        goals: goals,
      );
      if (contributions.isEmpty) continue;

      talker.info(
        'applyPersonalGoalAutoSweepIfEligible: deferred sweep applying '
        '${contributions.length} contribution(s) for txn $transactionId',
      );
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
        talker.error(
          'applyPersonalGoalAutoSweepIfEligible: deferred sweep failed $e\n$s',
        );
      }
      return;
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
