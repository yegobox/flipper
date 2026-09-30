import 'dart:async';
import 'dart:io';

import 'package:flipper_dashboard/features/personal_goals/personal_goal_contribution_banner.dart';
import 'package:flipper_dashboard/features/personal_goals/personal_goals_providers.dart';
import 'package:flipper_dashboard/features/personal_goals/personal_goals_screen.dart';
import 'package:flipper_models/helperModels/extensions.dart';
import 'package:flipper_models/helpers/personal_goal_contribution_device_key.dart';
import 'package:flipper_models/models/personal_goal.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:stacked_services/stacked_services.dart';

/// Listens to Ditto-backed [personalGoalsStreamProvider] and notifies this device
/// when another device credits a goal ([lastContributionDeviceKey] differs).
///
/// The in-app card ([PersonalGoalContributionBanner]) sits top-center on
/// mobile/web and top-right on desktop, where OS notifications appear. Credits
/// landing within [_coalesceWindow] (one sale's auto-sweep across several
/// goals) collapse into one card, and a new card replaces the visible one.
///
/// Wrap high in the tree, **above** [DevicePreview] / [MaterialApp.builder]
/// [LayoutBuilder]s (those run during [performLayout]). Overlay toasts need
/// [OverlaySupport] as an ancestor; must not [setState] or insert overlays
/// during [build]/layout.
class PersonalGoalRemoteContributionListener extends ConsumerStatefulWidget {
  const PersonalGoalRemoteContributionListener({
    required this.child,
    super.key,
  });

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
  bool _syncScheduled = false;

  static const _coalesceWindow = Duration(milliseconds: 500);
  final List<PersonalGoalCredit> _pendingCredits = [];
  Timer? _coalesceTimer;
  OverlayEntry? _desktopEntry;
  ValueNotifier<bool>? _desktopVisible;
  OverlaySupportEntry? _mobileEntry;
  Timer? _dismissTimer;
  Duration _dismissAfter = Duration.zero;

  /// Bumped on every branch switch. Pending credits and deferred banner
  /// callbacks from an earlier generation are dropped, so one branch's goal
  /// balances never surface after switching to another.
  int _generation = 0;

  bool get _isDesktop =>
      !kIsWeb && (Platform.isMacOS || Platform.isWindows || Platform.isLinux);

  @override
  void initState() {
    super.initState();
    unawaited(_ensureDeviceKey());
  }

  @override
  void dispose() {
    _subscription?.close();
    _coalesceTimer?.cancel();
    _removeBannerNow();
    super.dispose();
  }

  Future<void> _ensureDeviceKey() async {
    final k = await personalGoalContributionDeviceKey();
    if (!mounted) return;
    // No setState: this host only returns [widget.child]. Rebuilding here can
    // attach render objects while an ancestor LayoutBuilder is in performLayout.
    _localDeviceKey = k;
    _scheduleSyncSubscription();
  }

  void _scheduleSyncSubscription() {
    if (_syncScheduled) return;
    _syncScheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _syncScheduled = false;
      if (!mounted) return;
      _syncSubscription();
    });
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
    _generation++;
    _coalesceTimer?.cancel();
    _coalesceTimer = null;
    _pendingCredits.clear();
    _removeBannerNow();

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

    unawaited(ProxyService.notification.sendLocalNotification(body: body));

    _pendingCredits.add(PersonalGoalCredit(goal: goal, amount: amount));
    _coalesceTimer?.cancel();
    _coalesceTimer = Timer(_coalesceWindow, _flushPendingCredits);
  }

  void _flushPendingCredits() {
    if (!mounted) return;
    final branchId = _attachedBranchId;
    // Belt and braces with the generation reset: only this branch's goals.
    final credits = _pendingCredits
        .where(
          (c) =>
              branchId != null &&
              c.goal.branchId.trim().toLowerCase() ==
                  branchId.trim().toLowerCase(),
        )
        .toList();
    _pendingCredits.clear();
    if (credits.isEmpty) return;
    final generation = _generation;
    final symbol = ProxyService.box.defaultCurrency();
    final data = PersonalGoalBannerData.fromCredits(
      credits,
      formatAmount: (v) => v.toCurrencyFormatted(
        symbol: symbol,
        decimalDigits: v == v.roundToDouble() ? 0 : 2,
      ),
    );

    // Overlay insert must not run during layout (stream can emit mid-frame).
    // addPostFrameCallback does not request a frame, and this timer fires
    // after the frame that delivered the credit, so ask for one or an idle
    // app would never show the card.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || generation != _generation) return;
      _removeBannerNow();
      if (_isDesktop && _showDesktopBanner(data)) return;
      _showMobileBanner(data);
    });
    WidgetsBinding.instance.scheduleFrame();
  }

  Widget _card(PersonalGoalBannerData data, {ValueChanged<bool>? onHover}) {
    return PersonalGoalContributionBanner(
      data: data,
      onTap: () {
        _dismissBanner();
        _openGoals();
      },
      onDismiss: _dismissBanner,
      onHoverChanged: onHover,
    );
  }

  void _showMobileBanner(PersonalGoalBannerData data) {
    final key = ValueKey(
      'personal-goal-${DateTime.now().microsecondsSinceEpoch}',
    );
    _mobileEntry = showOverlayNotification(
      (context) => SlideDismissible(
        key: key,
        direction: DismissDirection.up,
        child: SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 480),
                child: _card(data),
              ),
            ),
          ),
        ),
      ),
      duration: data.displayDuration,
      position: NotificationPosition.top,
    );
  }

  /// Inserts on the navigator [Overlay] so the card paints above dashboard
  /// chrome (the outer [OverlaySupport] sits behind it on desktop).
  bool _showDesktopBanner(PersonalGoalBannerData data) {
    final overlay = StackedService.navigatorKey?.currentState?.overlay;
    if (overlay == null) return false;

    final visible = ValueNotifier<bool>(true);
    late OverlayEntry entry;
    entry = OverlayEntry(
      builder: (context) {
        final top = MediaQuery.paddingOf(context).top;
        return Positioned(
          top: top + 16,
          right: 16,
          width: 360,
          child: ValueListenableBuilder<bool>(
            valueListenable: visible,
            builder: (context, shown, child) => TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: shown ? 1 : 0),
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeOutCubic,
              onEnd: () {
                if (!shown && identical(_desktopEntry, entry)) {
                  _removeBannerNow();
                }
              },
              builder: (context, t, child) => Opacity(
                opacity: t,
                child: Transform.translate(
                  offset: Offset(24 * (1 - t), 0),
                  child: child,
                ),
              ),
              child: child,
            ),
            child: _card(
              data,
              // Hovering pauses auto-dismiss, like a Windows toast.
              onHover: (hovering) {
                if (hovering) {
                  _dismissTimer?.cancel();
                } else {
                  _startDismissTimer();
                }
              },
            ),
          ),
        );
      },
    );
    _desktopEntry = entry;
    _desktopVisible = visible;
    overlay.insert(entry);
    _dismissAfter = data.displayDuration;
    _startDismissTimer();
    return true;
  }

  void _startDismissTimer() {
    _dismissTimer?.cancel();
    _dismissTimer = Timer(_dismissAfter, _dismissBanner);
  }

  /// Animated dismiss (desktop fades out; overlay_support slides up).
  void _dismissBanner() {
    _dismissTimer?.cancel();
    _dismissTimer = null;
    _mobileEntry?.dismiss();
    _mobileEntry = null;
    final visible = _desktopVisible;
    if (visible != null && visible.value) {
      visible.value = false;
    } else {
      _removeBannerNow();
    }
  }

  void _removeBannerNow() {
    _dismissTimer?.cancel();
    _dismissTimer = null;
    _mobileEntry?.dismiss(animate: false);
    _mobileEntry = null;
    _desktopEntry?.remove();
    _desktopEntry = null;
    _desktopVisible?.dispose();
    _desktopVisible = null;
  }

  void _openGoals() {
    StackedService.navigatorKey?.currentState?.push(
      MaterialPageRoute<void>(builder: (_) => const PersonalGoalsScreen()),
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
        _scheduleSyncSubscription();
      }
    }

    return widget.child;
  }
}
