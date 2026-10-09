import 'package:flipper_ai_feature/src/widgets/flo/flo_composer.dart';
import 'package:flipper_ai_feature/src/widgets/flo/flo_header.dart';
import 'package:flipper_ai_feature/src/widgets/flo/flo_home_view.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _app(Widget body) => MaterialApp(
      localizationsDelegates: FlipperLocalizationDelegates.delegates,
      supportedLocales: FlipperLocalizationDelegates.supportedLocales,
      home: Scaffold(body: body),
    );

void _phoneSurface(WidgetTester tester) {
  tester.view.physicalSize = const Size(390, 844);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);
}

void main() {
  testWidgets('with actions in the app bar, the mode switch spans the row', (
    tester,
  ) async {
    _phoneSurface(tester);
    await tester.pumpWidget(_app(FloHeader(
      mode: FloPanelMode.askFlo,
      onModeChanged: (_) {},
      isMobile: true,
      actionsInAppBar: true,
    )));

    final l10n = tester.element(find.byType(FloHeader)).flipperL10n;
    InkWell tabOf(String label) => tester.widget<InkWell>(find.ancestor(
          of: find.text(label),
          matching: find.byType(InkWell),
        ));
    final askWidth = tester.getSize(find.byWidget(tabOf(l10n.floAskFlo))).width;
    final messagesWidth =
        tester.getSize(find.byWidget(tabOf(l10n.floMessages))).width;

    expect(askWidth, messagesWidth);
    // Both tabs together fill the row bar its padding and the pill's inset.
    expect(askWidth + messagesWidth, greaterThan(390 - 40));
  });

  testWidgets('phone suggestions stack at natural height, not a fixed grid', (
    tester,
  ) async {
    _phoneSurface(tester);
    await tester.pumpWidget(_app(SingleChildScrollView(
      child: FloHomeView(
        shopName: 'Shop',
        isMobile: true,
        onSuggestionTap: (_) {},
      ),
    )));

    expect(find.byType(GridView), findsNothing);
  });

  testWidgets('desktop suggestions keep the two-column grid', (tester) async {
    tester.view.physicalSize = const Size(1280, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(_app(SingleChildScrollView(
      child: FloHomeView(shopName: 'Shop', onSuggestionTap: (_) {}),
    )));

    expect(find.byType(GridView), findsOneWidget);
  });

  testWidgets('the source chip lines up with the "+" button below it', (
    tester,
  ) async {
    _phoneSurface(tester);
    final controller = TextEditingController();
    addTearDown(controller.dispose);
    await tester.pumpWidget(_app(Align(
      alignment: Alignment.bottomCenter,
      child: FloComposer(controller: controller, onSend: () {}, isMobile: true),
    )));

    final chip = find
        .ancestor(of: find.text('MiniData'), matching: find.byType(Container))
        .first;
    // No quick prompts, so the composer's first ink well is "+".
    final plus = find.byType(InkWell).first;

    expect(tester.getTopLeft(chip).dx, tester.getTopLeft(plus).dx);
    expect(tester.getBottomLeft(chip).dy,
        lessThanOrEqualTo(tester.getTopLeft(plus).dy));
  });
}
