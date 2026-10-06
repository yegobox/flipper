import 'dart:async';

import 'package:flipper_dashboard/widgets/dashboard_mobile_bottom_nav.dart';
import 'package:flipper_dashboard/widgets/pos_shift_gate.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_models/providers/pos_payment_role_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

Widget _app(Widget home, {List<dynamic> overrides = const []}) {
  return ProviderScope(
    overrides: [...overrides],
    child: MaterialApp(
      localizationsDelegates: FlipperLocalizationDelegates.delegates,
      supportedLocales: FlipperLocalizationDelegates.supportedLocales,
      home: home,
    ),
  );
}

void _phoneSurface(WidgetTester tester) {
  tester.view.physicalSize = const Size(390, 844);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);
}

void main() {
  group('DashboardMobileBottomNav', () {
    testWidgets('the top half of the raised New sale button is tappable', (
      tester,
    ) async {
      _phoneSurface(tester);
      await tester.pumpWidget(
        _app(
          Scaffold(
            body: const SizedBox.expand(),
            bottomNavigationBar: DashboardMobileBottomNav(
              activeTab: DashboardMobileTab.home,
              onTabSelected: (_) {},
            ),
          ),
        ),
      );
      await tester.pump();

      final fab = find.ancestor(
        of: find.byIcon(Icons.add),
        matching: find.byType(InkWell),
      );
      expect(fab, findsOneWidget);
      final fabBox = tester.renderObject<RenderBox>(fab);
      // A point near the top edge — this used to sit outside the bar's Stack
      // and was never hit-tested.
      final topOfButton =
          tester.getTopLeft(fab) + Offset(fabBox.size.width / 2, 4);

      final result = tester.hitTestOnBinding(topOfButton);
      expect(
        result.path.any((entry) => identical(entry.target, fabBox)),
        isTrue,
        reason: 'tap near the top of "+" must reach its InkWell',
      );
    });
  });

  group('PosShiftGate', () {
    const posKey = Key('pos-body');

    testWidgets('shows the POS while the shift lookups are loading', (
      tester,
    ) async {
      final never = Completer<bool>();
      await tester.pumpWidget(
        _app(
          const PosShiftGate(child: SizedBox(key: posKey)),
          overrides: [
            canSellProvider.overrideWithValue(true),
            requiresOpenShiftProvider.overrideWith((ref) => never.future),
          ],
        ),
      );
      await tester.pump();

      expect(find.byKey(posKey), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('a cashier without an open shift gets the CTA on a surface', (
      tester,
    ) async {
      await tester.pumpWidget(
        _app(
          const PosShiftGate(child: SizedBox(key: posKey)),
          overrides: [
            canSellProvider.overrideWithValue(true),
            requiresOpenShiftProvider.overrideWith((ref) async => true),
            currentOpenShiftProvider.overrideWith((ref) async => null),
          ],
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byKey(posKey), findsNothing);
      final cta = find.byIcon(Icons.play_arrow_rounded);
      expect(cta, findsOneWidget);
      expect(
        find.ancestor(of: cta, matching: find.byType(ColoredBox)),
        findsWidgets,
      );
    });
  });
}
