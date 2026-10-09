import 'package:flipper_models/helpers/daily_goal_rules.dart';
import 'package:flipper_models/models/engagement.dart';
import 'package:flipper_models/providers/active_branch_provider.dart';
import 'package:flipper_models/sync/utils/engagement_store.dart';
import 'package:flipper_web/services/ditto_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// "Now", overridable in tests.
final dailyGoalClockProvider = Provider<DateTime Function()>(
  (ref) => DateTime.now,
);

/// The open branch, re-read on a branch switch only.
final dailyGoalBranchProvider =
    Provider.autoDispose<({String id, String? businessId})?>((ref) {
      final branch = ref.watch(
        activeBranchProvider.select(
          (b) => b.value == null
              ? null
              : (id: b.value!.id, businessId: b.value!.businessId),
        ),
      );
      return (branch == null || branch.id.isEmpty) ? null : branch;
    });

/// Ditto access for the goal; null until Ditto is up.
final engagementStoreProvider = Provider<EngagementStore?>((ref) {
  final ditto = DittoService.instance.dittoInstance;
  return ditto == null ? null : EngagementStore(ditto);
});

final engagementStateProvider = StreamProvider.autoDispose
    .family<EngagementState?, String>((ref, branchId) {
      final store = ref.watch(engagementStoreProvider);
      return store?.state(branchId) ?? Stream.value(null);
    });

final engagementSettingsProvider = StreamProvider.autoDispose
    .family<EngagementSettings?, String>((ref, branchId) {
      final store = ref.watch(engagementStoreProvider);
      return store?.settings(branchId) ?? Stream.value(null);
    });

/// What the branch has recorded since local midnight.
final todayActivityProvider = StreamProvider.autoDispose
    .family<TodayActivity, String>((ref, branchId) {
      final store = ref.watch(engagementStoreProvider);
      if (store == null) return Stream.value(TodayActivity.empty);
      final now = ref.watch(dailyGoalClockProvider)();
      return store.today(branchId, DateTime(now.year, now.month, now.day));
    });

/// Everything the card and the sheet show.
class DailyGoalView {
  const DailyGoalView({
    required this.branchId,
    required this.businessId,
    required this.today,
    required this.target,
    required this.adaptiveTarget,
    required this.state,
    required this.settings,
  });

  final String branchId;
  final String? businessId;
  final TodayActivity today;
  final int target;

  /// What the server would set without the owner's override.
  final int adaptiveTarget;
  final EngagementState? state;
  final EngagementSettings? settings;

  Set<GoalMission> get done => goalMissionsDone(today, target);
  int get todayPoints => goalPoints(done);
  int get remaining => (target - today.sales).clamp(0, target);
  bool get goalReached => today.sales >= target;
  double get progress => target <= 0 ? 1 : (today.sales / target).clamp(0, 1);
  int get streak => state?.streak ?? 0;
  int get bestStreak => state?.bestStreak ?? 0;

  /// Closed days' points plus today's so far.
  int get points => (state?.pointsTotal ?? 0) + todayPoints;
  bool get remindersEnabled => settings?.remindersEnabled ?? true;
  int? get targetOverride => settings?.targetOverride;
}

/// The combined view, or null when there is no branch yet.
final dailyGoalProvider = Provider.autoDispose<AsyncValue<DailyGoalView>?>((
  ref,
) {
  final branch = ref.watch(dailyGoalBranchProvider);
  if (branch == null) return null;
  final today = ref.watch(todayActivityProvider(branch.id));
  final state = ref.watch(engagementStateProvider(branch.id));
  final settings = ref.watch(engagementSettingsProvider(branch.id));

  // The card waits for today's count only: state and settings arrive from
  // the server and may never exist for a new branch.
  return today.whenData((activity) {
    final s = state.value;
    final st = settings.value;
    final adaptive = effectiveGoalTarget(targetNext: s?.targetNext);
    return DailyGoalView(
      branchId: branch.id,
      businessId: branch.businessId,
      today: activity,
      target: effectiveGoalTarget(
        targetNext: s?.targetNext,
        targetOverride: st?.targetOverride,
      ),
      adaptiveTarget: adaptive,
      state: s,
      settings: st,
    );
  });
});

/// Saves the owner's goal preferences.
final dailyGoalActionsProvider = Provider<DailyGoalActions>(
  (ref) => DailyGoalActions(ref),
);

class DailyGoalActions {
  DailyGoalActions(this._ref);
  final Ref _ref;

  Future<void> save(
    DailyGoalView view, {
    int? targetOverride,
    bool clearTargetOverride = false,
    bool? remindersEnabled,
    String? locale,
  }) async {
    final store = _ref.read(engagementStoreProvider);
    if (store == null) return;
    final base =
        view.settings ??
        EngagementSettings(
          branchId: view.branchId,
          businessId: view.businessId,
        );
    await store.saveSettings(
      base.copyWith(
        targetOverride: targetOverride,
        clearTargetOverride: clearTargetOverride,
        remindersEnabled: remindersEnabled,
        locale: locale,
        businessId: view.businessId,
      ),
    );
  }
}
