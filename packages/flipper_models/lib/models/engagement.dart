/// "Today's goal" documents, as Ditto holds them.
///
/// * `engagement_state` — written by data-connector (`src/engagement`), one
///   doc per branch, id = branch id. Read-only here.
/// * `engagement_settings` — written by the app, id = branch id; reaches
///   Supabase through the data-connector sync pipeline.
library;

int _int(Object? v, [int fallback = 0]) =>
    v is num ? v.toInt() : int.tryParse('$v') ?? fallback;

/// One closed day in the week strip.
class GoalWeekDay {
  const GoalWeekDay({
    required this.day,
    required this.goalMet,
    required this.points,
  });

  final DateTime day;
  final bool goalMet;
  final int points;

  static GoalWeekDay? fromMap(Object? raw) {
    if (raw is! Map) return null;
    final day = DateTime.tryParse('${raw['day']}');
    if (day == null) return null;
    return GoalWeekDay(
      day: day,
      goalMet: raw['goalMet'] == true,
      points: _int(raw['points']),
    );
  }
}

class EngagementState {
  const EngagementState({
    required this.branchId,
    this.streak = 0,
    this.bestStreak = 0,
    this.pointsTotal = 0,
    this.targetNext,
    this.lastDay,
    this.week = const [],
  });

  final String branchId;
  final int streak;
  final int bestStreak;
  final int pointsTotal;

  /// The adaptive target for today; null before the server's first close.
  final int? targetNext;
  final DateTime? lastDay;
  final List<GoalWeekDay> week;

  factory EngagementState.fromDitto(Map<String, dynamic> d) => EngagementState(
    branchId: '${d['branchId'] ?? d['_id'] ?? ''}',
    streak: _int(d['streak']),
    bestStreak: _int(d['bestStreak']),
    pointsTotal: _int(d['pointsTotal']),
    targetNext: d['targetNext'] == null ? null : _int(d['targetNext']),
    lastDay: DateTime.tryParse('${d['lastDay']}'),
    week: [
      for (final w in (d['week'] as List?) ?? const [])
        if (GoalWeekDay.fromMap(w) case final day?) day,
    ],
  );
}

class EngagementSettings {
  const EngagementSettings({
    required this.branchId,
    this.businessId,
    this.targetOverride,
    this.remindersEnabled = true,
    this.locale,
  });

  final String branchId;
  final String? businessId;

  /// The owner's own daily sales target; null means "adapt to my shop".
  final int? targetOverride;
  final bool remindersEnabled;

  /// Language for pushes (`en`, `fr`, `rw`, `sw`).
  final String? locale;

  factory EngagementSettings.fromDitto(Map<String, dynamic> d) =>
      EngagementSettings(
        branchId: '${d['branchId'] ?? d['_id'] ?? ''}',
        businessId: d['businessId']?.toString(),
        targetOverride: d['targetOverride'] == null
            ? null
            : _int(d['targetOverride']),
        remindersEnabled: d['remindersEnabled'] != false,
        locale: d['locale']?.toString(),
      );

  /// Every field written, nulls included: Ditto's upsert merges, so clearing
  /// the override must write an explicit null to take effect.
  Map<String, dynamic> toDitto({DateTime? now}) => {
    '_id': branchId,
    'id': branchId,
    'branchId': branchId,
    'businessId': businessId,
    'targetOverride': targetOverride,
    'remindersEnabled': remindersEnabled,
    'locale': locale,
    'updatedAt': (now ?? DateTime.now()).toUtc().toIso8601String(),
  };

  EngagementSettings copyWith({
    int? targetOverride,
    bool clearTargetOverride = false,
    bool? remindersEnabled,
    String? locale,
    String? businessId,
  }) => EngagementSettings(
    branchId: branchId,
    businessId: businessId ?? this.businessId,
    targetOverride: clearTargetOverride
        ? null
        : (targetOverride ?? this.targetOverride),
    remindersEnabled: remindersEnabled ?? this.remindersEnabled,
    locale: locale ?? this.locale,
  );
}
