import 'package:flipper_dashboard/widgets/startup_progress_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Reads the percentage the screen is currently showing.
int _shownPercent(WidgetTester tester) {
  final label = tester
      .widgetList<Text>(find.byType(Text))
      .map((text) => text.data)
      .whereType<String>()
      .firstWhere((data) => data.endsWith('%'));
  return int.parse(label.substring(0, label.length - 1));
}

Future<void> _pumpScreen(WidgetTester tester, double progress) {
  return tester.pumpWidget(
    MaterialApp(home: StartupProgressScreen(progress: progress)),
  );
}

void main() {
  testWidgets('creeps up one percent at a time while a stage runs', (
    tester,
  ) async {
    await _pumpScreen(tester, 0.0);

    final seen = <int>[];
    for (var i = 0; i < 20; i++) {
      await tester.pump(const Duration(milliseconds: 100));
      seen.add(_shownPercent(tester));
    }

    for (var i = 1; i < seen.length; i++) {
      expect(seen[i], greaterThanOrEqualTo(seen[i - 1]));
      expect(seen[i] - seen[i - 1], lessThanOrEqualTo(2));
    }
    // About a percent a second: moving, but not pretending to finish.
    expect(seen.last, inInclusiveRange(1, 4));
  });

  testWidgets('walks up to a new milestone instead of jumping to it', (
    tester,
  ) async {
    await _pumpScreen(tester, 0.0);
    await tester.pump(const Duration(milliseconds: 500));
    final before = _shownPercent(tester);

    // The old screen went straight from 0% to 20% in a single frame.
    final seen = <int>[];
    await _pumpScreen(tester, 0.2);
    for (var i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 100));
      seen.add(_shownPercent(tester));
    }

    expect(seen.last, greaterThanOrEqualTo(20));
    expect(
      seen.where((percent) => percent > before && percent < 20).toSet().length,
      greaterThan(3),
      reason: 'should be visibly counting through the gap',
    );
    for (var i = 1; i < seen.length; i++) {
      expect(seen[i] - seen[i - 1], lessThanOrEqualTo(4));
    }
  });

  testWidgets('never claims more progress than the next milestone', (
    tester,
  ) async {
    await _pumpScreen(tester, 0.0);
    // Long enough for the creep to run out of room several times over.
    await tester.pump(const Duration(seconds: 30));
    expect(_shownPercent(tester), lessThanOrEqualTo(16));

    await _pumpScreen(tester, 0.4);
    await tester.pump(const Duration(seconds: 30));
    expect(_shownPercent(tester), lessThanOrEqualTo(56));
  });

  testWidgets('reaches exactly 100% when startup completes', (tester) async {
    await _pumpScreen(tester, 1.0);
    await tester.pumpAndSettle();
    expect(_shownPercent(tester), 100);
  });

  testWidgets('holds instead of rewinding when startup retries', (
    tester,
  ) async {
    await _pumpScreen(tester, 0.6);
    await tester.pump(const Duration(seconds: 3));
    final before = _shownPercent(tester);
    expect(before, greaterThan(50));

    // runStartupLogic resets progress to 0 when it retries after a timeout.
    await _pumpScreen(tester, 0.0);
    await tester.pump(const Duration(seconds: 2));
    expect(_shownPercent(tester), greaterThanOrEqualTo(before));
  });

  testWidgets('settles rather than animating forever', (tester) async {
    await _pumpScreen(tester, 0.2);
    // Would time out if the screen kept scheduling frames indefinitely.
    await tester.pumpAndSettle();
    expect(find.text('Checking your workspace'), findsOneWidget);
  });

  test('names the stage the startup logic is running', () {
    expect(startupStageLabel(0.0), 'Connecting');
    expect(startupStageLabel(0.2), 'Checking your workspace');
    expect(startupStageLabel(0.4), 'Starting services');
    expect(startupStageLabel(0.6), 'Syncing your data');
    expect(startupStageLabel(0.8), 'Confirming your plan');
    expect(startupStageLabel(1.0), 'Finishing up');
  });

  testWidgets('says Ready only once the counter reaches 100%', (tester) async {
    await _pumpScreen(tester, 1.0);
    await tester.pump(const Duration(milliseconds: 500));
    expect(_shownPercent(tester), lessThan(100));
    expect(find.text('Finishing up'), findsOneWidget);

    await tester.pumpAndSettle();
    expect(find.text('Ready'), findsOneWidget);
  });

  testWidgets('keeps the tagline the smoke test looks for', (tester) async {
    await _pumpScreen(tester, 0.0);
    expect(find.text('A revolutionary business software...'), findsOneWidget);
    expect(find.text('Flipper'), findsOneWidget);
  });

  testWidgets('lays out without overflow on a short window', (tester) async {
    tester.view.physicalSize = const Size(400, 320);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await _pumpScreen(tester, 0.4);
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });
}
