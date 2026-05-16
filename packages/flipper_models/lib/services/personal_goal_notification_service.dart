import 'dart:async';

import 'package:ditto_live/ditto_live.dart';
import 'package:flipper_models/helperModels/extensions.dart';
import 'package:flipper_models/helpers/personal_goal_contribution_device_key.dart';
import 'package:flipper_models/helpers/personal_goal_contribution_events.dart';
import 'package:flipper_models/models/personal_goal.dart';
import 'package:flipper_models/sync/dql_for_sync_subscription.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_web/services/ditto_service.dart';
import 'package:flutter/widgets.dart';

/// Watches Ditto for personal-goal credits from other devices and shows system
/// notifications. Uses both `personal_goals` replication and `events` mesh
/// messages (events help when the app is backgrounded but still alive).
///
/// **Note:** When the app is force-stopped / swiped away, no client code runs.
/// Reliable alerts in that case require a server push (FCM) — see
/// [handlePersonalGoalFcmBackgroundMessage].
class PersonalGoalNotificationService with WidgetsBindingObserver {
  PersonalGoalNotificationService._internal();

  static final PersonalGoalNotificationService instance =
      PersonalGoalNotificationService._internal();

  factory PersonalGoalNotificationService() => instance;

  Ditto? _ditto;
  dynamic _goalsObserver;
  dynamic _eventsObserver;
  bool _isInitialized = false;
  bool _lifecycleObserverRegistered = false;
  String? _localDeviceKey;
  String? _attachedBranchId;

  final Map<String, double> _savedAmountBaseline = {};
  final Set<String> _processedContributionEvents = {};

  static const _goalsQuery =
      'SELECT * FROM personal_goals WHERE branchId = :branchId';
  static const _eventsQuery = 'SELECT * FROM events WHERE channel = :channel';

  Future<void> initialize() async {
    if (_isInitialized) return;
    _localDeviceKey = await personalGoalContributionDeviceKey();
    DittoService.instance.addDittoListener(_onDittoChanged);
    if (!_lifecycleObserverRegistered) {
      WidgetsBinding.instance.addObserver(this);
      _lifecycleObserverRegistered = true;
    }
    final existing = DittoService.instance.dittoInstance;
    if (existing != null) {
      await _onDittoReady(existing);
    }
    _isInitialized = true;
    debugPrint('✅ PersonalGoalNotificationService initialized');
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      unawaited(_onAppResumed());
    }
  }

  Future<void> _onAppResumed() async {
    final ditto = DittoService.instance.dittoInstance ?? _ditto;
    if (ditto == null) return;
    try {
      DittoService.instance.startSync();
    } catch (e) {
      debugPrint('PersonalGoalNotificationService: sync.start on resume: $e');
    }
    await _onDittoReady(ditto);
  }

  void _onDittoChanged(Ditto? ditto) {
    if (ditto != null && ditto != _ditto) {
      unawaited(_onDittoReady(ditto));
    }
  }

  Future<void> _onDittoReady(Ditto ditto) async {
    _ditto = ditto;
    await _reattachObservers();
  }

  Future<void> _reattachObservers() async {
    final ditto = _ditto;
    final branchId = ProxyService.box.getBranchId();
    if (ditto == null || branchId == null || branchId.isEmpty) return;

    if (_attachedBranchId == branchId && _goalsObserver != null) {
      return;
    }

    _attachedBranchId = branchId;
    await _cancelObservers();
    _savedAmountBaseline.clear();

    await _registerPersonalGoalsBranchSubscription(ditto, branchId);

    final eventChannel = personalGoalsEventChannel(branchId);
    try {
      final prepared = prepareDqlSyncSubscription(_eventsQuery, {
        'channel': eventChannel,
      });
      await ditto.sync.registerSubscription(
        prepared.dql,
        arguments: prepared.arguments,
      );
    } catch (e) {
      debugPrint(
        'PersonalGoalNotificationService: events subscription failed: $e',
      );
    }

    var goalsPrimed = false;

    _goalsObserver = ditto.store.registerObserver(
      _goalsQuery,
      arguments: {'branchId': branchId},
      onChange: (result) {
        final goals = _mapGoals(result);
        if (!goalsPrimed) {
          for (final g in goals) {
            _savedAmountBaseline[g.id] = g.savedAmount;
          }
          goalsPrimed = true;
          return;
        }
        for (final g in goals) {
          final prev = _savedAmountBaseline[g.id] ?? 0;
          final diff = g.savedAmount - prev;
          if (diff > 0.0001) {
            _savedAmountBaseline[g.id] = g.savedAmount;
            _maybeNotifyFromGoal(g, diff);
          } else {
            _savedAmountBaseline[g.id] = g.savedAmount;
          }
        }
      },
    );

    _eventsObserver = ditto.store.registerObserver(
      _eventsQuery,
      arguments: {'channel': eventChannel},
      onChange: (result) {
        for (final item in result.items as Iterable<dynamic>) {
          try {
            final doc = Map<String, dynamic>.from(
              item.value as Map<dynamic, dynamic>,
            );
            _handleContributionEvent(doc);
          } catch (_) {}
        }
      },
    );

    debugPrint(
      'PersonalGoalNotificationService: observers attached for branch $branchId',
    );
  }

  Future<void> _registerPersonalGoalsBranchSubscription(
    Ditto ditto,
    String branchId,
  ) async {
    const allSql = 'SELECT * FROM personal_goals';
    try {
      final preparedAll = prepareDqlSyncSubscription(allSql, null);
      await ditto.sync.registerSubscription(
        preparedAll.dql,
        arguments: preparedAll.arguments,
      );
    } catch (_) {}

    final prepared = prepareDqlSyncSubscription(_goalsQuery, {
      'branchId': branchId,
    });
    try {
      await ditto.sync.registerSubscription(
        prepared.dql,
        arguments: prepared.arguments,
      );
    } catch (e) {
      debugPrint(
        'PersonalGoalNotificationService: goals subscription failed: $e',
      );
    }
  }

  List<PersonalGoal> _mapGoals(dynamic queryResult) {
    final list = <PersonalGoal>[];
    for (final item in queryResult.items as Iterable<dynamic>) {
      try {
        list.add(
          PersonalGoal.fromJson(
            Map<String, dynamic>.from(item.value as Map<dynamic, dynamic>),
          ),
        );
      } catch (_) {}
    }
    return list;
  }

  void _handleContributionEvent(Map<String, dynamic> doc) {
    if (!PersonalGoalContributionEvent.isContributionEvent(doc)) return;

    final dedupe = PersonalGoalContributionEvent.eventDedupeKey(doc);
    if (_processedContributionEvents.contains(dedupe)) return;

    final source = PersonalGoalContributionEvent.sourceDeviceKey(doc);
    final local = _localDeviceKey;
    if (local != null &&
        local.isNotEmpty &&
        source != null &&
        source.isNotEmpty &&
        source == local) {
      return;
    }

    final amount = PersonalGoalContributionEvent.amount(doc);
    if (amount <= 0) return;

    _processedContributionEvents.add(dedupe);
    if (_processedContributionEvents.length > 200) {
      _processedContributionEvents.remove(_processedContributionEvents.first);
    }

    unawaited(
      _sendNotification(PersonalGoalContributionEvent.goalName(doc), amount),
    );
  }

  void _maybeNotifyFromGoal(PersonalGoal goal, double amount) {
    final local = _localDeviceKey;
    final remoteKey = goal.lastContributionDeviceKey;
    if (remoteKey == null || remoteKey.isEmpty || remoteKey == local) {
      return;
    }
    if (amount <= 0) return;
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

  Future<void> _cancelObservers() async {
    try {
      await _goalsObserver?.cancel();
    } catch (_) {}
    try {
      await _eventsObserver?.cancel();
    } catch (_) {}
    _goalsObserver = null;
    _eventsObserver = null;
  }

  Future<void> dispose() async {
    if (_lifecycleObserverRegistered) {
      WidgetsBinding.instance.removeObserver(this);
      _lifecycleObserverRegistered = false;
    }
    await _cancelObservers();
    _ditto = null;
    _isInitialized = false;
    _attachedBranchId = null;
    _savedAmountBaseline.clear();
    _processedContributionEvents.clear();
  }
}
