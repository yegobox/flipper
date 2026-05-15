import 'dart:async';

import 'package:flipper_dashboard/features/personal_goals/personal_goals_providers.dart';
import 'package:flipper_models/helperModels/extensions.dart';
import 'package:flipper_models/helpers/personal_goal_contribution_device_key.dart';
import 'package:flipper_models/models/personal_goal.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:overlay_support/overlay_support.dart';

/// Listens to Ditto-backed [personalGoalsStreamProvider] and notifies this device
/// when another device credits a goal ([lastContributionDeviceKey] differs).
///
/// Wrap high in the tree (e.g. under [MaterialApp.router]) so overlay toasts work.
class PersonalGoalRemoteContributionListener extends ConsumerStatefulWidget {
  const PersonalGoalRemoteContributionListener({required this.child, super.key});

  final Widget child;

  @override
  ConsumerState<PersonalGoalRemoteContributionListener> createState() =>
      _PersonalGoalRemoteContributionListenerState();
}

class _PersonalGoalRemoteContributionListenerState
    extends ConsumerState<PersonalGoalRemoteContributionListener> {
  String? _localDeviceKey;
  String? _attachedBranchId;
  ProviderSubscription<AsyncValue<List<PersonalGoal>>>? _subscription;
  final Map<String, double> _baselineSaved = {};
  bool _primed = false;
  final Map<String, DateTime> _lastNotified = {};

  @override
  void initState() {
    super.initState();
    unawaited(_ensureDeviceKey());
  }

  @override
  void dispose() {
    _subscription?.close();
    super.dispose();
  }

  Future<void> _ensureDeviceKey() async {
    final k = await personalGoalContributionDeviceKey();
    if (!mounted) return;
    setState(() => _localDeviceKey = k);
    _syncSubscription();
  }

  void _syncSubscription() {
    final branchId = ProxyService.box.getBranchId();
    final localKey = _localDeviceKey;
    if (branchId == null ||
        branchId.isEmpty ||
        localKey == null ||
        localKey.isEmpty) {
      return;
    }
    if (_attachedBranchId == branchId && _subscription != null) {
      return;
    }
    _subscription?.close();
    _subscription = null;
    _attachedBranchId = branchId;
    _primed = false;
    _baselineSaved.clear();
    _lastNotified.clear();

    _subscription = ref.listenManual<AsyncValue<List<PersonalGoal>>>(
      personalGoalsStreamProvider(branchId),
      (prev, next) => next.whenData(_onGoalsSnapshot),
      fireImmediately: true,
    );

    // Prime Ditto replication + branch cache before checkout (auto-sweep reads cache).
    unawaited(
      ref
          .read(personalGoalsDataSourceProvider)
          .personalGoalsStream(branchId: branchId)
          .first
          .then((_) {}, onError: (_) {}),
    );
  }

  void _maybeNotifyRemoteCredit(PersonalGoal goal) {
    final local = _localDeviceKey;
    if (local == null) return;

    final remoteKey = goal.lastContributionDeviceKey;
    if (remoteKey == null || remoteKey.isEmpty || remoteKey == local) {
      return;
    }

    final amount = goal.lastContributionAmount;
    if (amount == null || amount <= 0) return;

    final now = DateTime.now();
    final last = _lastNotified[goal.id];
    if (last != null && now.difference(last) < const Duration(seconds: 2)) {
      return;
    }
    _lastNotified[goal.id] = now;

    final symbol = ProxyService.box.defaultCurrency();
    final formatted = amount.toCurrencyFormatted(symbol: symbol);
    final body =
        '${goal.name}: +$formatted saved (auto or synced from another device)';

    unawaited(
      ProxyService.notification.sendLocalNotification(body: body),
    );

    showSimpleNotification(
      Text(body),
      background: const Color(0xFF059669),
      position: NotificationPosition.top,
      duration: const Duration(seconds: 4),
    );
  }

  void _onGoalsSnapshot(List<PersonalGoal> goals) {
    if (_localDeviceKey == null) return;

    if (!_primed) {
      for (final g in goals) {
        _baselineSaved[g.id] = g.savedAmount;
      }
      _primed = true;
      return;
    }

    for (final g in goals) {
      final prev = _baselineSaved[g.id];
      if (prev == null) {
        _baselineSaved[g.id] = g.savedAmount;
        continue;
      }
      if (g.savedAmount > prev + 0.0001) {
        _maybeNotifyRemoteCredit(g);
      }
      _baselineSaved[g.id] = g.savedAmount;
    }
  }

  @override
  Widget build(BuildContext context) {
    final branchId = ProxyService.box.getBranchId();
    if (branchId != null &&
        branchId.isNotEmpty &&
        _localDeviceKey != null &&
        _localDeviceKey!.isNotEmpty) {
      if (_attachedBranchId != branchId || _subscription == null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          _syncSubscription();
        });
      }
    }

    return widget.child;
  }
}
