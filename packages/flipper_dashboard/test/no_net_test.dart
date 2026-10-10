import 'dart:async';

import 'package:flipper_dashboard/no_net.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late Completer<bool> check;
  late int loginTaps;

  NoNetViewModel fakeModel({int? days = 6}) => NoNetViewModel(
    checkConnection: () => check.future,
    daysSinceLastConnection: () => days,
    goToLogin: () => loginTaps++,
  );

  Future<void> pumpScreen(
    WidgetTester tester, {
    Size size = const Size(412, 915),
    int? days = 6,
  }) async {
    check = Completer<bool>();
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: FlipperLocalizationDelegates.delegates,
        supportedLocales: FlipperLocalizationDelegates.supportedLocales,
        home: NoNet(viewModelBuilder: () => fakeModel(days: days)),
      ),
    );
    await tester.pump();
  }

  // The completer is made inside each test body, never in setUp: one created
  // outside the FakeAsync zone completes on the real event loop, which pumps
  // never flush.
  setUp(() => loginTaps = 0);

  for (final size in const [Size(412, 915), Size(1440, 900), Size(360, 560)]) {
    testWidgets('renders without overflow at ${size.width}x${size.height}', (
      tester,
    ) async {
      await pumpScreen(tester, size: size);

      expect(find.text('No internet'), findsOneWidget);
      expect(find.textContaining('every 5 days'), findsOneWidget);
      expect(find.text('Last online 6 days ago'), findsOneWidget);
      expect(find.text('Check Connection'), findsOneWidget);
      expect(find.text('Go to Login'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('hides the last-online chip on first run', (tester) async {
    await pumpScreen(tester, days: null);
    expect(find.textContaining('Last online'), findsNothing);
  });

  testWidgets('shows progress, then still-offline when the check fails', (
    tester,
  ) async {
    await pumpScreen(tester);

    await tester.tap(find.text('Check Connection'));
    await tester.pump();
    expect(find.text('Checking…'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    check.complete(false);
    await tester.pumpAndSettle();
    expect(find.text('Check Connection'), findsOneWidget);
    expect(find.textContaining('Still offline'), findsOneWidget);

    // A new attempt clears the old failure while it runs.
    check = Completer<bool>();
    await tester.tap(find.text('Check Connection'));
    // The spinner never settles while the check is pending, so step past the
    // switcher's fade-out by hand.
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('Checking…'), findsOneWidget);
    expect(find.textContaining('Still offline'), findsNothing);
    check.complete(true);
    await tester.pumpAndSettle();
    expect(find.textContaining('Still offline'), findsNothing);
  });

  testWidgets('Go to Login calls through', (tester) async {
    await pumpScreen(tester);
    await tester.tap(find.text('Go to Login'));
    expect(loginTaps, 1);
  });

  testWidgets('back does not leave the gate', (tester) async {
    await pumpScreen(tester);
    final navigator = tester.state<NavigatorState>(find.byType(Navigator));
    expect(await navigator.maybePop(), isTrue);
    await tester.pumpAndSettle();
    expect(find.text('No internet'), findsOneWidget);
  });
}
