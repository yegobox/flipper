import 'package:flipper_models/helpers/daily_goal_rules.dart';
import 'package:flipper_models/models/engagement.dart';
import 'package:flipper_models/sync/utils/engagement_store.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('points pin the table shared with data-connector', () {
    // Mirrored in data-connector src/engagement/model.rs — keep both in step.
    expect(
      [
        kGoalPointsSale,
        kGoalPointsExpense,
        kGoalPointsStock,
        kGoalPointsGoal,
        kGoalPointsStreakMilestone,
      ],
      [10, 10, 10, 50, 30],
    );
    expect(
      [kGoalMinTarget, kGoalMaxTarget, kGoalStreakMilestoneDays],
      [3, 500, 7],
    );
  });

  test('missions and points for a day', () {
    const a = TodayActivity(sales: 5, expenses: 1, stockUpdates: 0);
    final done = goalMissionsDone(a, 4);
    expect(done, {GoalMission.sale, GoalMission.expense, GoalMission.goal});
    expect(goalPoints(done), 70);
    expect(goalMissionsDone(TodayActivity.empty, 3), isEmpty);
  });

  test('the override wins, then the server target, then the minimum', () {
    expect(effectiveGoalTarget(), kGoalMinTarget);
    expect(effectiveGoalTarget(targetNext: 12), 12);
    expect(effectiveGoalTarget(targetNext: 12, targetOverride: 20), 20);
    expect(effectiveGoalTarget(targetNext: 12, targetOverride: 0), 12);
  });

  test('today is counted the way the server counts a day', () {
    final a = EngagementStore.countToday([
      {'status': 'completed', 'isExpense': false},
      {'status': 'completed', 'isExpense': false},
      {'status': 'pending', 'isExpense': false}, // a cart, not a sale
      {'status': 'completed', 'isExpense': true},
      // Adding a product with stock: an adjustment, flagged as an expense.
      {
        'status': 'completed',
        'isExpense': true,
        'receiptType': 'adjustment',
        'transactionType': 'adjustment',
      },
      // A recorded supplier purchase.
      {
        'status': 'completed',
        'isExpense': true,
        'receiptType': 'Purchase',
        'transactionType': 'Supplier purchase',
      },
    ]);
    expect(a, const TodayActivity(sales: 2, expenses: 1, stockUpdates: 2));
  });

  test('an expense is not a stock update, whatever its category', () {
    // A cash-out's transactionType is the category the user picked.
    final a = EngagementStore.countToday([
      {
        'status': 'completed',
        'isExpense': true,
        'receiptType': 'Cash Out',
        'transactionType': 'Purchase',
      },
      // Paying a supplier's bill: receipt type Purchase, but no stock moved.
      {
        'status': 'completed',
        'isExpense': true,
        'receiptType': 'Purchase',
        'transactionType': 'Supplier payment',
      },
    ]);
    expect(a, const TodayActivity(expenses: 2));
  });

  test('state reads the document data-connector writes', () {
    final s = EngagementState.fromDitto({
      '_id': 'b1',
      'branchId': 'b1',
      'streak': 3,
      'bestStreak': 5,
      'pointsTotal': 240,
      'targetNext': 7,
      'lastDay': '2026-10-08',
      'week': [
        {'day': '2026-10-08', 'goalMet': true, 'points': 80},
        {'day': 'bad'},
      ],
    });
    expect(s.streak, 3);
    expect(s.targetNext, 7);
    expect(s.week, hasLength(1));
    expect(s.week.single.goalMet, isTrue);
  });

  test('settings write every field, so clearing the override sticks', () {
    final doc = const EngagementSettings(
      branchId: 'b1',
      targetOverride: 9,
    ).copyWith(clearTargetOverride: true).toDitto(now: DateTime.utc(2026));
    expect(doc['_id'], 'b1');
    expect(doc.containsKey('targetOverride'), isTrue);
    expect(doc['targetOverride'], isNull);
    expect(doc['remindersEnabled'], isTrue);
  });
}
