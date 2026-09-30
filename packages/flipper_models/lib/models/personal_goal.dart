import 'dart:math';

import 'package:flipper_models/helpers/goal_recurrence.dart';

export 'package:flipper_models/helpers/goal_recurrence.dart';

/// One finished period of a recurring [PersonalGoal].
class GoalCycle {
  const GoalCycle({
    required this.periodKey,
    required this.savedAmount,
    required this.targetAmount,
    required this.reached,
  });

  /// See [GoalRecurrence.periodKey].
  final String periodKey;
  final double savedAmount;
  final double targetAmount;
  final bool reached;

  Map<String, dynamic> toJson() => {
        'periodKey': periodKey,
        'savedAmount': savedAmount,
        'targetAmount': targetAmount,
        'reached': reached,
      };

  static GoalCycle? fromJson(Object? raw) {
    if (raw is! Map) return null;
    final key = raw['periodKey']?.toString();
    if (key == null || key.isEmpty) return null;
    double toDouble(dynamic v) =>
        v is num ? v.toDouble() : double.tryParse('$v') ?? 0;
    return GoalCycle(
      periodKey: key,
      savedAmount: toDouble(raw['savedAmount']),
      targetAmount: toDouble(raw['targetAmount']),
      reached: raw['reached'] == true,
    );
  }
}

/// Branch-scoped savings goal persisted in Ditto (`personal_goals`) for Capella.
class PersonalGoal {
  const PersonalGoal({
    required this.id,
    required this.branchId,
    required this.name,
    required this.savedAmount,
    required this.targetAmount,
    this.isTopPriority = false,
    this.autoAllocationPercent,
    this.note,
    this.createdAt,
    this.updatedAt,
    this.lastContributionTransactionId,
    this.lastContributionDeviceKey,
    this.lastContributionAmount,
    this.recurrence = GoalRecurrence.none,
    this.periodKey,
    this.cycleHistory = const [],
  });

  final String id;
  final String branchId;
  final String name;
  final double savedAmount;
  final double targetAmount;
  final bool isTopPriority;

  /// When set (0–100), Capella credits this percent into the goal on completed flows:
  /// **product sales** use gross line profit (retail − supply); **cashbook utility cash-in**
  /// uses the recorded cash-in amount ([completeCashMovement]).
  final int? autoAllocationPercent;
  final String? note;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  /// Last credit metadata (Ditto); used for cross-device contribution toasts.
  final String? lastContributionTransactionId;
  final String? lastContributionDeviceKey;
  final double? lastContributionAmount;

  /// How often progress restarts at 0; [GoalRecurrence.none] for one-shot goals.
  final GoalRecurrence recurrence;

  /// Period [savedAmount] belongs to (recurring goals only). When it no longer
  /// matches the current period, the goal has rolled over — see [effectiveAt].
  final String? periodKey;

  /// Finished periods, newest first, at most [maxCycleHistory].
  final List<GoalCycle> cycleHistory;

  static const double targetReachedEpsilon = 0.0001;
  static const int maxCycleHistory = 12;

  bool get isRecurring => recurrence.isRecurring;

  /// This goal as of [now]. For a recurring goal whose [periodKey] is from an
  /// earlier period, returns the rolled-over state: saved back to 0, the old
  /// period pushed onto [cycleHistory], last-contribution metadata cleared.
  ///
  /// Rollover is lazy and deterministic: every reader computes the same result,
  /// and it is only persisted together with a real write (a credit or an edit),
  /// never as a standalone reset that could clobber another device's credit.
  PersonalGoal effectiveAt(DateTime now) {
    final current = recurrence.periodKey(now);
    if (current == null || periodKey == current) return this;
    // A recurring goal with no period yet (e.g. just switched on) adopts the
    // current one without resetting.
    if (periodKey == null) return copyWith(periodKey: current);
    final finished = GoalCycle(
      periodKey: periodKey!,
      savedAmount: savedAmount,
      targetAmount: targetAmount,
      reached: isAtOrAboveTarget,
    );
    return copyWith(
      savedAmount: 0,
      periodKey: current,
      cycleHistory: [finished, ...cycleHistory].take(maxCycleHistory).toList(),
      clearLastContributionMeta: true,
    );
  }

  /// Progress in 0..1
  double get progressRatio {
    if (targetAmount <= 0) return 0;
    return min(1, max(0, savedAmount / targetAmount));
  }

  /// Progress 0..100
  int get progressPercent => (progressRatio * 100).round();

  /// True when [savedAmount] has reached or exceeded [targetAmount].
  bool get isAtOrAboveTarget =>
      targetAmount > 0 &&
      savedAmount >= targetAmount - targetReachedEpsilon;

  /// Amount still needed to hit [targetAmount]; `0` when already at/above target.
  double get remainingToTarget {
    if (targetAmount <= 0) return double.infinity;
    final remaining = targetAmount - savedAmount;
    return remaining <= targetReachedEpsilon ? 0 : remaining;
  }

  /// How much was credited between [previous] (an earlier snapshot of this
  /// goal) and this one. A change of [periodKey] means the goal rolled over,
  /// so the whole new [savedAmount] is the credit even though it went down.
  /// Zero or negative when nothing was added.
  double creditSince(PersonalGoal previous) {
    if (previous.periodKey != periodKey) return savedAmount;
    return savedAmount - previous.savedAmount;
  }

  PersonalGoal copyWith({
    String? id,
    String? branchId,
    String? name,
    double? savedAmount,
    double? targetAmount,
    bool? isTopPriority,
    int? autoAllocationPercent,
    String? note,
    bool clearAutoAllocationPercent = false,
    bool clearNote = false,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? lastContributionTransactionId,
    String? lastContributionDeviceKey,
    double? lastContributionAmount,
    bool clearLastContributionMeta = false,
    GoalRecurrence? recurrence,
    String? periodKey,
    bool clearPeriodKey = false,
    List<GoalCycle>? cycleHistory,
  }) {
    return PersonalGoal(
      id: id ?? this.id,
      branchId: branchId ?? this.branchId,
      name: name ?? this.name,
      savedAmount: savedAmount ?? this.savedAmount,
      targetAmount: targetAmount ?? this.targetAmount,
      isTopPriority: isTopPriority ?? this.isTopPriority,
      autoAllocationPercent: clearAutoAllocationPercent
          ? null
          : (autoAllocationPercent ?? this.autoAllocationPercent),
      note: clearNote ? null : (note ?? this.note),
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      lastContributionTransactionId: clearLastContributionMeta
          ? null
          : (lastContributionTransactionId ??
              this.lastContributionTransactionId),
      lastContributionDeviceKey: clearLastContributionMeta
          ? null
          : (lastContributionDeviceKey ?? this.lastContributionDeviceKey),
      lastContributionAmount: clearLastContributionMeta
          ? null
          : (lastContributionAmount ?? this.lastContributionAmount),
      recurrence: recurrence ?? this.recurrence,
      periodKey: clearPeriodKey ? null : (periodKey ?? this.periodKey),
      cycleHistory: cycleHistory ?? this.cycleHistory,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'id': id,
      'branchId': branchId,
      'name': name,
      'savedAmount': savedAmount,
      'targetAmount': targetAmount,
      'isTopPriority': isTopPriority,
      if (autoAllocationPercent != null)
        'autoAllocationPercent': autoAllocationPercent,
      if (note != null && note!.isNotEmpty) 'note': note,
      if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
      'updatedAt': (updatedAt ?? DateTime.now()).toIso8601String(),
      if (lastContributionTransactionId != null)
        'lastContributionTransactionId': lastContributionTransactionId,
      if (lastContributionDeviceKey != null)
        'lastContributionDeviceKey': lastContributionDeviceKey,
      if (lastContributionAmount != null)
        'lastContributionAmount': lastContributionAmount,
      // Always written (even when off/empty): the Ditto upsert must be able to
      // clear a previous value when recurrence is switched off.
      'recurrence': recurrence.wire,
      'periodKey': periodKey,
      'cycleHistory': cycleHistory.map((c) => c.toJson()).toList(),
    };
  }

  static PersonalGoal fromJson(Map<String, dynamic> raw) {
    double toDouble(dynamic v) {
      if (v == null) return 0;
      if (v is num) return v.toDouble();
      return double.tryParse(v.toString()) ?? 0;
    }

    DateTime? parseDt(dynamic v) {
      if (v == null) return null;
      if (v is DateTime) return v;
      return DateTime.tryParse(v.toString());
    }

    final id =
        raw['_id']?.toString() ?? raw['id']?.toString() ?? '';
    return PersonalGoal(
      id: id,
      branchId: raw['branchId']?.toString() ?? '',
      name: raw['name']?.toString() ?? '',
      savedAmount: toDouble(raw['savedAmount']),
      targetAmount: toDouble(raw['targetAmount']),
      isTopPriority: raw['isTopPriority'] == true,
      autoAllocationPercent: (raw['autoAllocationPercent'] as num?)?.toInt(),
      note: raw['note']?.toString(),
      createdAt: parseDt(raw['createdAt']),
      updatedAt: parseDt(raw['updatedAt']),
      lastContributionTransactionId:
          raw['lastContributionTransactionId']?.toString(),
      lastContributionDeviceKey: raw['lastContributionDeviceKey']?.toString(),
      lastContributionAmount: raw['lastContributionAmount'] == null
          ? null
          : toDouble(raw['lastContributionAmount']),
      recurrence: GoalRecurrence.fromWire(raw['recurrence']),
      periodKey: raw['periodKey']?.toString(),
      cycleHistory: raw['cycleHistory'] is List
          ? (raw['cycleHistory'] as List)
              .map(GoalCycle.fromJson)
              .whereType<GoalCycle>()
              .toList()
          : const [],
    );
  }
}
