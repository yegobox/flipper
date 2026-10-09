/// The rules of "Today's goal" — missions, points, the target.
///
/// data-connector closes each day with the same numbers
/// (`src/engagement/model.rs`); the card uses these to show today's progress
/// before the day is closed. Change one, change both: each side has a test
/// pinning them.
library;

const int kGoalPointsSale = 10;
const int kGoalPointsExpense = 10;
const int kGoalPointsStock = 10;
const int kGoalPointsGoal = 50;
const int kGoalPointsStreakMilestone = 30;
const int kGoalStreakMilestoneDays = 7;
const int kGoalMinTarget = 3;
const int kGoalMaxTarget = 500;

enum GoalMission { sale, expense, stock, goal }

/// What a branch has done so far today.
class TodayActivity {
  const TodayActivity({
    this.sales = 0,
    this.expenses = 0,
    this.stockUpdates = 0,
  });

  final int sales;
  final int expenses;

  /// Deliberate stock movements: adjustments, received purchases, imports.
  final int stockUpdates;

  static const empty = TodayActivity();

  @override
  bool operator ==(Object other) =>
      other is TodayActivity &&
      other.sales == sales &&
      other.expenses == expenses &&
      other.stockUpdates == stockUpdates;

  @override
  int get hashCode => Object.hash(sales, expenses, stockUpdates);
}

Set<GoalMission> goalMissionsDone(TodayActivity a, int target) => {
  if (a.sales > 0) GoalMission.sale,
  if (a.expenses > 0) GoalMission.expense,
  if (a.stockUpdates > 0) GoalMission.stock,
  if (a.sales >= target) GoalMission.goal,
};

int goalMissionPoints(GoalMission m) => switch (m) {
  GoalMission.sale => kGoalPointsSale,
  GoalMission.expense => kGoalPointsExpense,
  GoalMission.stock => kGoalPointsStock,
  GoalMission.goal => kGoalPointsGoal,
};

int goalPoints(Iterable<GoalMission> done) =>
    done.fold(0, (sum, m) => sum + goalMissionPoints(m));

/// The owner's override when set, else the server's adaptive target, else the
/// minimum (a branch the server has not evaluated yet).
int effectiveGoalTarget({int? targetNext, int? targetOverride}) {
  final o = targetOverride;
  if (o != null && o > 0) return o;
  final t = targetNext;
  return (t == null || t <= 0) ? kGoalMinTarget : t;
}
