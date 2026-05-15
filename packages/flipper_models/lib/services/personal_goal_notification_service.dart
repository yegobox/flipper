import 'dart:async';

import 'package:ditto_live/ditto_live.dart';
import 'package:flipper_models/helperModels/extensions.dart';
import 'package:flipper_models/helpers/personal_goal_contribution_device_key.dart';
import 'package:flipper_models/models/personal_goal.dart';
import 'package:flipper_models/sync/dql_for_sync_subscription.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_web/services/ditto_service.dart';
import 'package:flutter/foundation.dart';

/// Singleton that watches the Ditto `personal_goals` collection outside the
/// widget tree and fires a system notification whenever another device credits
/// a goal. Works in both foreground and background because it does not depend
/// on any Flutter widget or Riverpod provider being alive.
class PersonalGoalNotificationService {
  PersonalGoalNotificationService._internal();

  static final PersonalGoalNotificationService instance =
      PersonalGoalNotificationService._internal();

  factory PersonalGoalNotificationService() => instance;

  Ditto? _ditto;
  dynamic _observer;
  bool _isInitialized = false;
  String? _localDeviceKey;

  /// Saved amounts at last snapshot — used to detect increases.
  final Map<String, double> _savedAmountBaseline = {};

  /// Throttle — do not notify the same goal more than once per 5 s.
  final Map<String, DateTime> _lastNotified = {};

  static const _query =
      'SELECT * FROM personal_goals WHERE branchId = :branchId';

  Future<void> initialize() async {
    if (_isInitialized) return;
    _localDeviceKey = await personalGoalContributionDeviceKey();
    DittoService.instance.addDittoListener(_onDittoChanged);
    final existing = DittoService.instance.dittoInstance;
    if (existing != null) {
      await _onDittoReady(existing);
    }
    _isInitialized = true;
    debugPrint('✅ PersonalGoalNotificationService initialized');
  }

  void _onDittoChanged(Ditto? ditto) {
    if (ditto != null && ditto != _ditto) {
      unawaited(_onDittoReady(ditto));
    }
  }

  Future<void> _onDittoReady(Ditto ditto) async {
    _ditto = ditto;
    await _reattachObserver();
  }

  Future<void> _reattachObserver() async {
    final ditto = _ditto;
    final branchId = ProxyService.box.getBranchId();
    if (ditto == null || branchId == null || branchId.isEmpty) return;

    // Cancel existing observer.
    try {
      await _observer?.cancel();
    } catch (_) {}
    _observer = null;
    _savedAmountBaseline.clear();

    // Register a broad subscription so replication is active.
    final prepared = prepareDqlSyncSubscription(_query, {'branchId': branchId});
    try {
      await ditto.sync.registerSubscription(
        prepared.dql,
        arguments: prepared.arguments,
      );
    } catch (e) {
      debugPrint('PersonalGoalNotificationService: subscription failed: $e');
    }

    bool primed = false;

    _observer = ditto.store.registerObserver(
      _query,
      arguments: {'branchId': branchId},
      onChange: (result) {
        final goals = <PersonalGoal>[];
        for (final item in result.items as Iterable<dynamic>) {
          try {
            goals.add(
              PersonalGoal.fromJson(
                Map<String, dynamic>.from(item.value as Map<dynamic, dynamic>),
              ),
            );
          } catch (_) {}
        }

        if (!primed) {
          for (final g in goals) {
            _savedAmountBaseline[g.id] = g.savedAmount;
          }
          primed = true;
          return;
        }

        for (final g in goals) {
          final prev = _savedAmountBaseline[g.id] ?? 0;
          final diff = g.savedAmount - prev;
          if (diff > 0.0001) {
            _savedAmountBaseline[g.id] = g.savedAmount;
            _maybeNotify(g, diff);
          } else if (diff <= 0) {
            _savedAmountBaseline[g.id] = g.savedAmount;
          }
        }
      },
    );

    debugPrint(
      'PersonalGoalNotificationService: observer attached for branch $branchId',
    );
  }

  void _maybeNotify(PersonalGoal goal, double amount) {
    final deviceKey = _localDeviceKey;
    // Only notify if the contribution came from another device.
    if (deviceKey != null &&
        deviceKey.isNotEmpty &&
        goal.lastContributionDeviceKey == deviceKey) {
      return;
    }

    final now = DateTime.now();
    final last = _lastNotified[goal.id];
    if (last != null && now.difference(last) < const Duration(seconds: 5)) {
      return;
    }
    _lastNotified[goal.id] = now;

    unawaited(_sendNotification(goal.name, amount));
  }

  Future<void> _sendNotification(String goalName, double amount) async {
    try {
      final symbol = ProxyService.box.defaultCurrency();
      final formatted = amount.toCurrencyFormatted(symbol: symbol);
      await ProxyService.notification.sendLocalNotification(
        body: '$goalName: +$formatted saved automatically',
      );
    } catch (e) {
      debugPrint('PersonalGoalNotificationService: notification error: $e');
    }
  }

  Future<void> dispose() async {
    try {
      await _observer?.cancel();
    } catch (_) {}
    _observer = null;
    _ditto = null;
    _isInitialized = false;
    _savedAmountBaseline.clear();
    _lastNotified.clear();
  }
}
