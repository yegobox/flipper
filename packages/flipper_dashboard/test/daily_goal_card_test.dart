import 'package:flipper_dashboard/features/daily_goal/daily_goal_card.dart';
import 'package:flipper_dashboard/features/daily_goal/daily_goal_providers.dart';
import 'package:flipper_dashboard/features/daily_goal/daily_goal_sheet.dart';
import 'package:flipper_dashboard/widgets/dashboard_app_access.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_models/helpers/daily_goal_rules.dart';
import 'package:flipper_models/models/engagement.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> _pump(
  WidgetTester tester, {
  TodayActivity today = TodayActivity.empty,
  EngagementState? state,
  EngagementSettings? settings,
}) async {
  tester.view.physicalSize = const Size(400, 860);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        dailyGoalBranchProvider.overrideWith(
          (ref) => (id: 'b1', businessId: 'biz'),
        ),
        engagementStoreProvider.overrideWithValue(null),
        dashboardIsAdminProvider.overrideWith((ref) => true),
        todayActivityProvider('b1').overrideWith((ref) => Stream.value(today)),
        engagementStateProvider(
          'b1',
        ).overrideWith((ref) => Stream.value(state)),
        engagementSettingsProvider(
          'b1',
        ).overrideWith((ref) => Stream.value(settings)),
      ],
      child: const MaterialApp(
        localizationsDelegates: FlipperLocalizationDelegates.delegates,
        supportedLocales: FlipperLocalizationDelegates.supportedLocales,
        home: Scaffold(
          body: Padding(padding: EdgeInsets.all(16), child: DailyGoalCard()),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('a new branch starts at the minimum target', (tester) async {
    await _pump(tester);

    expect(find.text("Today's goal · 0 of 3 sales"), findsOneWidget);
    expect(find.text('Log your first sale to start earning'), findsOneWidget);
    expect(find.byKey(const Key('daily-goal-streak')), findsNothing);
  });

  testWidgets('the server target, streak and points show', (tester) async {
    await _pump(
      tester,
      today: const TodayActivity(sales: 4, expenses: 1),
      state: const EngagementState(
        branchId: 'b1',
        streak: 3,
        pointsTotal: 200,
        targetNext: 6,
      ),
    );

    expect(find.text("Today's goal · 4 of 6 sales"), findsOneWidget);
    // 200 closed + 20 today (sale + expense).
    expect(find.text('220 pts'), findsOneWidget);
    expect(find.text('3-day streak'), findsOneWidget);
    expect(find.textContaining('Just 2 more to'), findsOneWidget);
  });

  testWidgets("the owner's override wins over the adaptive target", (
    tester,
  ) async {
    await _pump(
      tester,
      today: const TodayActivity(sales: 10),
      state: const EngagementState(branchId: 'b1', targetNext: 6),
      settings: const EngagementSettings(branchId: 'b1', targetOverride: 10),
    );

    expect(find.text("Today's goal · 10 of 10 sales"), findsOneWidget);
    expect(find.textContaining('Goal reached!'), findsOneWidget);
  });

  testWidgets('tapping opens the missions', (tester) async {
    await _pump(tester, today: const TodayActivity(sales: 1, stockUpdates: 1));

    await tester.tap(find.byKey(const Key('daily-goal-card')));
    await tester.pumpAndSettle();

    expect(find.byType(DailyGoalSheet), findsOneWidget);
    expect(find.text('Record a sale'), findsOneWidget);
    expect(find.text('Record an expense'), findsOneWidget);
    expect(find.text('Update your stock'), findsOneWidget);
    expect(find.text("Reach today's sales goal"), findsOneWidget);
    // Two missions done, two still to do.
    expect(find.text('Done'), findsNWidgets(2));
    expect(find.text('Do it'), findsNWidgets(2));
  });

  test('each mission opens the page that completes it', () {
    expect(dailyGoalMissionPage(GoalMission.sale), 'POS');
    expect(dailyGoalMissionPage(GoalMission.goal), 'POS');
    expect(dailyGoalMissionPage(GoalMission.expense), 'Cashbook');
    expect(dailyGoalMissionPage(GoalMission.stock), 'StockRecount');
  });
}
