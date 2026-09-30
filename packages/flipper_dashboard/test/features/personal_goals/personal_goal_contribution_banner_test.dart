import 'package:flipper_dashboard/features/personal_goals/personal_goal_contribution_banner.dart';
import 'package:flipper_models/models/personal_goal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

PersonalGoal _goal({
  String id = 'g1',
  String name = 'New truck',
  double saved = 45000,
  double target = 100000,
}) => PersonalGoal(
  id: id,
  branchId: 'b1',
  name: name,
  savedAmount: saved,
  targetAmount: target,
);

String _fmt(double v) => 'RWF ${v.toStringAsFixed(0)}';

PersonalGoalBannerData _data(List<PersonalGoalCredit> credits) =>
    PersonalGoalBannerData.fromCredits(credits, formatAmount: _fmt);

void main() {
  group('PersonalGoalBannerData.fromCredits', () {
    test('single credit shows amount, progress and percent', () {
      final d = _data([PersonalGoalCredit(goal: _goal(), amount: 5000)]);
      expect(d.headline, '+RWF 5000 saved to New truck');
      expect(d.detail, 'RWF 45000 of RWF 100000');
      expect(d.progress, closeTo(0.45, 1e-9));
      expect(d.percentLabel, '45%');
      expect(d.reached, isFalse);
      expect(d.displayDuration, const Duration(seconds: 5));
    });

    test('goal at target switches to the reached variant', () {
      final d = _data([
        PersonalGoalCredit(goal: _goal(saved: 100000), amount: 8000),
      ]);
      expect(d.headline, 'Goal reached: New truck');
      expect(d.detail, 'Target of RWF 100000 met');
      expect(d.progress, 1);
      expect(d.reached, isTrue);
      expect(d.displayDuration, const Duration(seconds: 8));
    });

    test('goal without a target omits progress', () {
      final d = _data([
        PersonalGoalCredit(goal: _goal(target: 0, saved: 3000), amount: 3000),
      ]);
      expect(d.detail, 'RWF 3000 saved so far');
      expect(d.progress, isNull);
      expect(d.percentLabel, isNull);
    });

    test('several goals collapse into one summary', () {
      final d = _data([
        PersonalGoalCredit(goal: _goal(), amount: 2000),
        PersonalGoalCredit(
          goal: _goal(id: 'g2', name: 'Rent'),
          amount: 1000,
        ),
      ]);
      expect(d.headline, '+RWF 3000 saved across 2 goals');
      expect(d.detail, 'New truck · Rent');
      expect(d.progress, isNull);
      expect(d.reached, isFalse);
    });

    test('repeat credits to one goal merge, latest snapshot wins', () {
      final d = _data([
        PersonalGoalCredit(goal: _goal(saved: 41000), amount: 1000),
        PersonalGoalCredit(goal: _goal(saved: 45000), amount: 4000),
      ]);
      expect(d.headline, '+RWF 5000 saved to New truck');
      expect(d.detail, 'RWF 45000 of RWF 100000');
    });

    test('multi-goal summary calls out a goal that hit its target', () {
      final d = _data([
        PersonalGoalCredit(goal: _goal(saved: 100000), amount: 2000),
        PersonalGoalCredit(
          goal: _goal(id: 'g2', name: 'Rent'),
          amount: 1000,
        ),
      ]);
      expect(d.detail, 'New truck reached its target');
      expect(d.reached, isTrue);
    });
  });

  group('PersonalGoalContributionBanner', () {
    Future<void> pump(
      WidgetTester tester,
      PersonalGoalBannerData data, {
      Size size = const Size(390, 844),
      Brightness brightness = Brightness.light,
      VoidCallback? onTap,
      VoidCallback? onDismiss,
    }) async {
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(brightness: brightness),
          home: Scaffold(
            body: Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: PersonalGoalContributionBanner(
                  data: data,
                  onTap: onTap ?? () {},
                  onDismiss: onDismiss ?? () {},
                ),
              ),
            ),
          ),
        ),
      );
    }

    testWidgets('renders headline, detail, percent and progress', (
      tester,
    ) async {
      await pump(
        tester,
        _data([PersonalGoalCredit(goal: _goal(), amount: 5000)]),
      );
      expect(find.text('PERSONAL GOAL  ·  now'), findsOneWidget);
      expect(find.text('+RWF 5000 saved to New truck'), findsOneWidget);
      expect(find.text('RWF 45000 of RWF 100000'), findsOneWidget);
      expect(find.text('45%'), findsOneWidget);
      expect(find.byType(LinearProgressIndicator), findsOneWidget);
      expect(find.byIcon(Icons.savings_outlined), findsOneWidget);
    });

    testWidgets('reached variant uses the trophy icon', (tester) async {
      await pump(
        tester,
        _data([PersonalGoalCredit(goal: _goal(saved: 100000), amount: 1)]),
        brightness: Brightness.dark,
      );
      expect(find.text('Goal reached: New truck'), findsOneWidget);
      expect(find.byIcon(Icons.emoji_events_outlined), findsOneWidget);
    });

    testWidgets('tap opens, close dismisses', (tester) async {
      var taps = 0;
      var dismisses = 0;
      await pump(
        tester,
        _data([PersonalGoalCredit(goal: _goal(), amount: 5000)]),
        onTap: () => taps++,
        onDismiss: () => dismisses++,
      );
      await tester.tap(find.byKey(const Key('personal_goal_banner_close')));
      expect(dismisses, 1);
      expect(taps, 0);
      await tester.tap(find.text('+RWF 5000 saved to New truck'));
      expect(taps, 1);
    });

    testWidgets('long goal names ellipsize at 320px without overflow', (
      tester,
    ) async {
      await pump(
        tester,
        _data([
          PersonalGoalCredit(
            goal: _goal(
              name: 'Replace the delivery motorbike and repaint the shop front',
              saved: 12345678,
              target: 98765432,
            ),
            amount: 1234567,
          ),
        ]),
        size: const Size(320, 640),
      );
      expect(tester.takeException(), isNull);
    });

    testWidgets('desktop width renders cleanly', (tester) async {
      await pump(
        tester,
        _data([
          PersonalGoalCredit(goal: _goal(), amount: 2000),
          PersonalGoalCredit(
            goal: _goal(id: 'g2', name: 'Rent'),
            amount: 1000,
          ),
        ]),
        size: const Size(1440, 900),
      );
      expect(find.text('+RWF 3000 saved across 2 goals'), findsOneWidget);
      expect(find.byType(LinearProgressIndicator), findsNothing);
      expect(tester.takeException(), isNull);
    });
  });
}
