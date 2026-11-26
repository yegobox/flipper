import 'package:flipper_dashboard/features/production_output/providers/production_output_derived_providers.dart';
import 'package:flipper_dashboard/features/production_output/widgets/production_day_bar.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

// flutter test test/features/production_output/widgets/production_day_bar_test.dart --dart-define=FLUTTER_TEST_ENV=true

void main() {
  final today = localDay(DateTime.now());

  Future<ProviderContainer> pumpBar(
    WidgetTester tester, {
    DateTime? day,
  }) async {
    final container = ProviderContainer(
      overrides: [
        if (day != null) productionDayProvider.overrideWith((ref) => day),
      ],
    );
    addTearDown(container.dispose);
    // Keeps the autoDispose day alive between taps; dispose() closes it.
    container.listen(productionDayProvider, (_, _) {});
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          localizationsDelegates: FlipperLocalizationDelegates.delegates,
          supportedLocales: FlipperLocalizationDelegates.supportedLocales,
          home: const Scaffold(body: ProductionDayBar()),
        ),
      ),
    );
    return container;
  }

  IconButton arrow(WidgetTester tester, String tooltip) => tester.widget(
    find.ancestor(
      of: find.byTooltip(tooltip),
      matching: find.byType(IconButton),
    ),
  );

  testWidgets('the arrows step one calendar day, Today goes back', (
    tester,
  ) async {
    final container = await pumpBar(tester);

    await tester.tap(find.byTooltip('Previous day'));
    await tester.pump();
    await tester.tap(find.byTooltip('Previous day'));
    await tester.pump();
    expect(container.read(productionDayProvider), shiftDay(today, -2));

    await tester.tap(find.byTooltip('Next day'));
    await tester.pump();
    expect(container.read(productionDayProvider), shiftDay(today, -1));

    await tester.tap(find.widgetWithText(TextButton, 'Today').last);
    await tester.pump();
    expect(container.read(productionDayProvider), today);
  });

  testWidgets('the arrows stop where the date picker does', (tester) async {
    await pumpBar(tester, day: ProductionDayBar.firstDay);
    expect(arrow(tester, 'Previous day').onPressed, isNull);
    expect(arrow(tester, 'Next day').onPressed, isNotNull);

    await pumpBar(tester, day: ProductionDayBar.lastDay(today));
    expect(arrow(tester, 'Next day').onPressed, isNull);
    expect(arrow(tester, 'Previous day').onPressed, isNotNull);
  });

  testWidgets('the picker opens on the shown day and sets the pick', (
    tester,
  ) async {
    final container = await pumpBar(tester, day: DateTime(2026, 3, 10));

    await tester.tap(find.byIcon(Icons.calendar_today));
    await tester.pumpAndSettle();
    // One tap picks; there is no OK step.
    await tester.tap(find.text('12'));
    await tester.pumpAndSettle();

    expect(container.read(productionDayProvider), DateTime(2026, 3, 12));
  });

  test('shiftDay lands on local midnight across month and year ends', () {
    expect(shiftDay(DateTime(2026, 3, 1), -1), DateTime(2026, 2, 28));
    expect(shiftDay(DateTime(2026, 12, 31), 1), DateTime(2027, 1, 1));
    expect(shiftDay(DateTime(2026, 11, 23), 0), DateTime(2026, 11, 23));
  });
}
