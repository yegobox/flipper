import 'package:flipper_design_system/flipper_design_system.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';

Key _day(int y, int m, int d) => ValueKey('flipper-date-picker-day-$y-$m-$d');

const _panel = ValueKey('flipper-date-picker-panel');

/// Pumps a page with one button that opens the picker and records the result.
Future<List<DateTime?>> _pumpHost(
  WidgetTester tester, {
  required DateTime initial,
  required DateTime first,
  required DateTime last,
  List<FlipperDatePreset>? presets,
  Locale locale = const Locale('en'),
  Size size = const Size(1280, 800),
  bool anchored = true,
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  final results = <DateTime?>[];
  await tester.pumpWidget(
    MaterialApp(
      locale: locale,
      localizationsDelegates: FlipperLocalizationDelegates.delegates,
      supportedLocales: FlipperLocalizationDelegates.supportedLocales,
      home: Scaffold(
        body: Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Builder(
              builder: (context) => TextButton(
                key: const ValueKey('open'),
                onPressed: () async {
                  results.add(
                    await showFlipperDatePicker(
                      context: context,
                      anchorContext: anchored ? context : null,
                      initialDate: initial,
                      firstDate: first,
                      lastDate: last,
                      presets: presets,
                    ),
                  );
                },
                child: const Text('open'),
              ),
            ),
          ),
        ),
      ),
    ),
  );
  await tester.tap(find.byKey(const ValueKey('open')));
  await tester.pumpAndSettle();
  return results;
}

void main() {
  setUpAll(() => GoogleFonts.config.allowRuntimeFetching = false);

  testWidgets('tapping a day returns it and closes the panel', (tester) async {
    final results = await _pumpHost(
      tester,
      initial: DateTime(2026, 11, 26),
      first: DateTime(2026, 11, 1),
      last: DateTime(2026, 12, 31),
      presets: const [],
    );
    expect(find.byKey(_panel), findsOneWidget);
    expect(find.text('November 2026'), findsOneWidget);

    await tester.tap(find.byKey(_day(2026, 11, 28)));
    await tester.pumpAndSettle();

    expect(results, [DateTime(2026, 11, 28)]);
    expect(find.byKey(_panel), findsNothing);
  });

  testWidgets('opens under its anchor, not centred', (tester) async {
    await _pumpHost(
      tester,
      initial: DateTime(2026, 11, 26),
      first: DateTime(2026, 1, 1),
      last: DateTime(2026, 12, 31),
    );
    final anchor = tester.getRect(find.byKey(const ValueKey('open')));
    final panel = tester.getRect(find.byKey(_panel));
    expect(panel.top, greaterThanOrEqualTo(anchor.bottom));
    expect(panel.left, anchor.left);
    expect(panel.width, kFlipperDatePickerPanelWidth);
  });

  testWidgets('is centred without an anchor', (tester) async {
    await _pumpHost(
      tester,
      initial: DateTime(2026, 11, 26),
      first: DateTime(2026, 1, 1),
      last: DateTime(2026, 12, 31),
      anchored: false,
    );
    final panel = tester.getRect(find.byKey(_panel));
    expect(panel.center.dx, closeTo(640, 1));
  });

  testWidgets('days outside the range cannot be picked', (tester) async {
    final results = await _pumpHost(
      tester,
      initial: DateTime(2026, 11, 20),
      first: DateTime(2026, 11, 10),
      last: DateTime(2026, 11, 25),
      presets: const [],
    );
    await tester.tap(find.byKey(_day(2026, 11, 5)));
    await tester.pumpAndSettle();
    expect(results, isEmpty);
    expect(find.byKey(_panel), findsOneWidget);

    // Range fits in one month: both arrows are disabled.
    final arrows = tester.widgetList<IconButton>(find.byType(IconButton));
    expect(arrows.every((b) => b.onPressed == null), isTrue);
  });

  testWidgets('initial date outside the range is clamped', (tester) async {
    await _pumpHost(
      tester,
      initial: DateTime(2030, 1, 1),
      first: DateTime(2026, 1, 1),
      last: DateTime(2026, 3, 31),
      presets: const [],
    );
    expect(find.text('March 2026'), findsOneWidget);
  });

  testWidgets('month arrows move between months', (tester) async {
    await _pumpHost(
      tester,
      initial: DateTime(2026, 11, 26),
      first: DateTime(2026, 1, 1),
      last: DateTime(2027, 12, 31),
      presets: const [],
    );
    await tester.tap(find.byTooltip('Next month'));
    await tester.pumpAndSettle();
    expect(find.text('December 2026'), findsOneWidget);
    await tester.tap(find.byTooltip('Previous month'));
    await tester.tap(find.byTooltip('Previous month'));
    await tester.pumpAndSettle();
    expect(find.text('October 2026'), findsOneWidget);
  });

  testWidgets('presets pick in one tap; out-of-range ones are hidden', (
    tester,
  ) async {
    final results = await _pumpHost(
      tester,
      initial: DateTime(2026, 11, 26),
      first: DateTime(2026, 11, 1),
      last: DateTime(2026, 11, 27),
      presets: [
        FlipperDatePreset(label: 'Soon', date: DateTime(2026, 11, 27)),
        FlipperDatePreset(label: 'Later', date: DateTime(2026, 12, 15)),
      ],
    );
    expect(find.text('Soon'), findsOneWidget);
    expect(find.text('Later'), findsNothing);

    await tester.tap(find.text('Soon'));
    await tester.pumpAndSettle();
    expect(results, [DateTime(2026, 11, 27)]);
  });

  test('default presets: today, tomorrow and the coming Monday', () {
    // FlipperDatePreset.defaults needs a context only for strings; check the
    // date maths through a Wednesday and a Monday.
    DateTime nextMonday(DateTime now) {
      final today = DateUtils.dateOnly(now);
      final d = (DateTime.monday - today.weekday + 7) % 7;
      return DateUtils.addDaysToDate(today, d == 0 ? 7 : d);
    }

    expect(nextMonday(DateTime(2026, 11, 25)), DateTime(2026, 11, 30));
    expect(nextMonday(DateTime(2026, 11, 30)), DateTime(2026, 12, 7));
  });

  testWidgets('default presets are localized and dated from today', (
    tester,
  ) async {
    late List<FlipperDatePreset> presets;
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('fr'),
        localizationsDelegates: FlipperLocalizationDelegates.delegates,
        supportedLocales: FlipperLocalizationDelegates.supportedLocales,
        home: Builder(
          builder: (context) {
            presets = FlipperDatePreset.defaults(
              context,
              now: DateTime(2026, 11, 30, 15),
            );
            return const SizedBox();
          },
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(presets.map((p) => p.label), [
      "Aujourd'hui",
      'Demain',
      'Lundi prochain',
    ]);
    expect(presets.map((p) => p.date), [
      DateTime(2026, 11, 30),
      DateTime(2026, 12, 1),
      DateTime(2026, 12, 7),
    ]);
  });

  testWidgets('keyboard: arrows move, Enter picks', (tester) async {
    final results = await _pumpHost(
      tester,
      initial: DateTime(2026, 11, 26),
      first: DateTime(2026, 1, 1),
      last: DateTime(2026, 12, 31),
      presets: const [],
    );
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.pump();
    // 26 + 1 + 7 = Dec 4: the month follows the focus.
    expect(find.text('December 2026'), findsOneWidget);
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pumpAndSettle();
    expect(results, [DateTime(2026, 12, 4)]);
  });

  testWidgets('keyboard: Escape closes without a date', (tester) async {
    final results = await _pumpHost(
      tester,
      initial: DateTime(2026, 11, 26),
      first: DateTime(2026, 1, 1),
      last: DateTime(2026, 12, 31),
    );
    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pumpAndSettle();
    expect(find.byKey(_panel), findsNothing);
    expect(results, [null]);
  });

  testWidgets('tapping outside dismisses with null', (tester) async {
    final results = await _pumpHost(
      tester,
      initial: DateTime(2026, 11, 26),
      first: DateTime(2026, 1, 1),
      last: DateTime(2026, 12, 31),
    );
    await tester.tapAt(const Offset(1200, 700));
    await tester.pumpAndSettle();
    expect(results, [null]);
  });

  testWidgets('phones get a bottom sheet', (tester) async {
    final results = await _pumpHost(
      tester,
      initial: DateTime(2026, 11, 26),
      first: DateTime(2026, 1, 1),
      last: DateTime(2026, 12, 31),
      presets: const [],
      size: const Size(390, 844),
    );
    expect(find.byType(BottomSheet), findsOneWidget);
    expect(find.byKey(_panel), findsNothing); // no floating card
    await tester.tap(find.byKey(_day(2026, 11, 3)));
    await tester.pumpAndSettle();
    expect(results, [DateTime(2026, 11, 3)]);
  });

  testWidgets('French locale: French month and Monday-first weekdays', (
    tester,
  ) async {
    await _pumpHost(
      tester,
      initial: DateTime(2026, 11, 26),
      first: DateTime(2026, 1, 1),
      last: DateTime(2026, 12, 31),
      presets: const [],
      locale: const Locale('fr'),
    );
    expect(find.text('novembre 2026'), findsOneWidget);
    final first = tester.getTopLeft(find.text('L'));
    final last = tester.getTopLeft(find.text('D'));
    expect(first.dx, lessThan(last.dx)); // lundi … dimanche
  });

  testWidgets('FlipperDateField shows the locale date and updates', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1280, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    DateTime value = DateTime(2026, 11, 26);
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: FlipperLocalizationDelegates.delegates,
        supportedLocales: FlipperLocalizationDelegates.supportedLocales,
        home: Scaffold(
          body: StatefulBuilder(
            builder: (context, setState) => SizedBox(
              width: 260,
              child: FlipperDateField(
                label: 'Target date',
                value: value,
                firstDate: DateTime(2026, 1, 1),
                lastDate: DateTime(2026, 12, 31),
                presets: const [],
                onChanged: (d) => setState(() => value = d),
              ),
            ),
          ),
        ),
      ),
    );
    expect(find.text('Thu, Nov 26, 2026'), findsOneWidget);
    await tester.tap(find.byType(FlipperDateField));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(_day(2026, 11, 2)));
    await tester.pumpAndSettle();
    expect(find.text('Mon, Nov 2, 2026'), findsOneWidget);
  });

  testWidgets('works without the Flipper delegate (English fallback)', (
    tester,
  ) async {
    late List<FlipperDatePreset> presets;
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) {
            presets = FlipperDatePreset.defaults(context);
            return const SizedBox();
          },
        ),
      ),
    );
    expect(presets.first.label, 'Today');
  });

  testWidgets('flipperFormatDate: intl locales and the rw fallback', (
    tester,
  ) async {
    final seen = <String, String>{};
    for (final tag in ['en', 'fr', 'rw']) {
      await tester.pumpWidget(
        MaterialApp(
          locale: Locale(tag),
          localizationsDelegates: FlipperLocalizationDelegates.delegates,
          supportedLocales: FlipperLocalizationDelegates.supportedLocales,
          home: Builder(
            builder: (context) {
              seen[tag] = flipperFormatDate(context, DateTime(2026, 11, 26));
              return const SizedBox();
            },
          ),
        ),
      );
      await tester.pumpAndSettle();
    }
    expect(seen['en'], 'Thu, Nov 26, 2026');
    expect(seen['fr'], contains('2026'));
    expect(seen['fr'], contains('nov'));
    expect(seen['rw'], contains('2026'));
  });

  testWidgets(
    'month title opens the year grid; picking a year returns to days',
    (tester) async {
      final results = await _pumpHost(
        tester,
        initial: DateTime(2026, 11, 26),
        first: DateTime(1990, 1, 1),
        last: DateTime(2066, 12, 31),
        presets: const [],
      );
      await tester.tap(
        find.byKey(const ValueKey('flipper-date-picker-year-toggle')),
      );
      await tester.pumpAndSettle();
      expect(
        find.byKey(const ValueKey('flipper-date-picker-year-2026')),
        findsOneWidget,
      );
      // Month arrows are off while the years show.
      final arrows = tester.widgetList<IconButton>(find.byType(IconButton));
      expect(arrows.every((b) => b.onPressed == null), isTrue);

      await tester.scrollUntilVisible(
        find.byKey(const ValueKey('flipper-date-picker-year-2040')),
        100,
        scrollable: find.byType(Scrollable).last,
      );
      await tester.tap(
        find.byKey(const ValueKey('flipper-date-picker-year-2040')),
      );
      await tester.pumpAndSettle();
      expect(find.text('November 2040'), findsOneWidget);
      await tester.tap(find.byKey(_day(2040, 11, 5)));
      await tester.pumpAndSettle();
      expect(results, [DateTime(2040, 11, 5)]);
    },
  );

  testWidgets(
    'initialYearMode opens on the years; a year is clamped into range',
    (tester) async {
      tester.view.physicalSize = const Size(1280, 800);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => TextButton(
                onPressed: () => showFlipperDatePicker(
                  context: context,
                  initialDate: DateTime(2026, 2, 10),
                  firstDate: DateTime(2025, 6, 1),
                  lastDate: DateTime(2030, 1, 31),
                  presets: const [],
                  initialYearMode: true,
                ),
                child: const Text('open'),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();
      expect(
        find.byKey(const ValueKey('flipper-date-picker-year-2025')),
        findsOneWidget,
      );
      await tester.tap(
        find.byKey(const ValueKey('flipper-date-picker-year-2025')),
      );
      await tester.pumpAndSettle();
      // February 2025 is before the range: lands on June 2025.
      expect(find.text('June 2025'), findsOneWidget);
    },
  );

  testWidgets('one-year range has no year toggle', (tester) async {
    await _pumpHost(
      tester,
      initial: DateTime(2026, 11, 26),
      first: DateTime(2026, 1, 1),
      last: DateTime(2026, 12, 31),
      presets: const [],
    );
    expect(
      find.byKey(const ValueKey('flipper-date-picker-year-toggle')),
      findsNothing,
    );
  });
}
