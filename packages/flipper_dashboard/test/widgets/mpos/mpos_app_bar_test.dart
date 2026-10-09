import 'package:flipper_dashboard/maestro_semantics.dart';
import 'package:flipper_dashboard/widgets/mpos/mpos_catalog_header.dart';
import 'package:flipper_dashboard/widgets/mpos/mpos_checkout_header.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _app(Widget header) => MaterialApp(
  localizationsDelegates: FlipperLocalizationDelegates.delegates,
  supportedLocales: FlipperLocalizationDelegates.supportedLocales,
  home: Scaffold(body: Column(children: [header])),
);

void _phoneSurface(WidgetTester tester) {
  tester.view.physicalSize = const Size(390, 844);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);
}

void main() {
  testWidgets('New sale wears the round back button, title and subtitle', (
    tester,
  ) async {
    _phoneSurface(tester);
    var backs = 0;
    await tester.pumpWidget(
      _app(
        MposCatalogHeader(
          subtitle: 'Walk-in · 12:59',
          status: 'PENDING',
          searchField: const SizedBox(height: 50),
          onBack: () => backs++,
          onScan: () {},
        ),
      ),
    );

    expect(find.text('New sale'), findsOneWidget);
    expect(find.text('Walk-in · 12:59'), findsOneWidget);
    expect(find.byIcon(Icons.chevron_left_rounded), findsNothing);

    await tester.tap(find.byIcon(Icons.arrow_back));
    expect(backs, 1);
  });

  testWidgets('Checkout keeps its Maestro back id on the round button', (
    tester,
  ) async {
    _phoneSurface(tester);
    var backs = 0;
    await tester.pumpWidget(
      _app(
        MposCheckoutHeader(
          itemCount: 2,
          timeLabel: '12:59',
          status: 'PENDING',
          onBack: () => backs++,
        ),
      ),
    );

    expect(find.text('Checkout'), findsOneWidget);
    expect(
      find.descendant(
        of: find.byKey(const Key(MaestroIds.mposCheckoutBack)),
        matching: find.byIcon(Icons.arrow_back),
      ),
      findsOneWidget,
    );

    await tester.tap(find.byIcon(Icons.arrow_back));
    expect(backs, 1);
  });
}
