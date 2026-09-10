import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flipper_web/features/home/home_screen.dart';
import 'package:flipper_web/features/home/sections/books_home_sections.dart';
import 'package:flipper_web/features/home/theme/books_home_theme.dart';
import 'package:flipper_web/features/home/widgets/books_home_widgets.dart';

void main() {
  group('HomeScreen', () {
    tearDown(() {
      booksHomeShowDeviceMocks = true;
    });

    Future<void> pumpHomeScreen(
      WidgetTester tester, {
      ThemeMode themeMode = ThemeMode.light,
    }) async {
      tester.view.physicalSize = const Size(1920, 4000);
      tester.view.devicePixelRatio = 1.0;
      booksHomeShowDeviceMocks = false;

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            theme: ThemeData(brightness: Brightness.light),
            darkTheme: ThemeData(brightness: Brightness.dark),
            themeMode: themeMode,
            home: MediaQuery(
              data: const MediaQueryData(disableAnimations: true),
              child: const HomeScreen(),
            ),
          ),
        ),
      );
      await tester.pump();
    }

    testWidgets('renders Flipper Books marketing sections', (
      WidgetTester tester,
    ) async {
      await pumpHomeScreen(tester);

      expect(find.text('Flipper'), findsWidgets);
      expect(find.text('BOOKS'), findsWidgets);
      expect(find.text('Start free'), findsWidgets);
      expect(find.text('does itself.'), findsOneWidget);
      expect(find.text('Accounting'), findsOneWidget);
      expect(find.text('that '), findsOneWidget);
      expect(find.text('See how it works'), findsOneWidget);
      expect(find.text('RRA / EBM-ready'), findsOneWidget);

      expect(find.textContaining('Built for Rwandan businesses'), findsOneWidget);
      expect(find.textContaining('Real-time'), findsWidgets);
      expect(find.textContaining('12,400+'), findsWidgets);

      expect(find.text('Three apps. One ledger. Zero double-entry.'), findsOneWidget);
      expect(find.text('MEET FLOW AI'), findsOneWidget);
      expect(find.text('INSIDE BOOKS'), findsOneWidget);

      expect(find.text('Simple, transparent pricing'), findsOneWidget);
      expect(find.text('Mobile'), findsOneWidget);
      expect(find.text('Mobile + Desktop'), findsOneWidget);
      expect(find.text('Enterprise'), findsOneWidget);
      expect(find.text('5,000'), findsOneWidget);
      expect(find.text('120,000'), findsOneWidget);
      expect(find.text('1.5M+'), findsOneWidget);
      expect(find.text('Most Popular'), findsOneWidget);

      expect(find.text('12,400+'), findsWidgets);
      expect(find.text('RWF 1.2B'), findsOneWidget);
      expect(find.text('99.9%'), findsOneWidget);
    });

    testWidgets('renders light by default', (WidgetTester tester) async {
      await pumpHomeScreen(tester);

      expect(AppColors.palette, BooksPalette.light);
      expect(AppColors.bg, BooksPalette.light.bg);

      final scaffold = tester.widget<Scaffold>(
        find.descendant(
          of: find.byType(HomeScreen),
          matching: find.byType(Scaffold),
        ),
      );
      expect(scaffold.backgroundColor, BooksPalette.light.bg);
    });

    testWidgets('follows the app theme mode into dark', (
      WidgetTester tester,
    ) async {
      await pumpHomeScreen(tester, themeMode: ThemeMode.dark);

      expect(AppColors.palette, BooksPalette.dark);

      final scaffold = tester.widget<Scaffold>(
        find.descendant(
          of: find.byType(HomeScreen),
          matching: find.byType(Scaffold),
        ),
      );
      expect(scaffold.backgroundColor, BooksPalette.dark.bg);
    });

    testWidgets('the nav sheet closes when the theme is switched from it', (
      WidgetTester tester,
    ) async {
      // A modal sheet keeps the background colour it opened with, and its
      // other rows watch nothing, so they keep the colours they were built
      // with. Leaving it open would show this row alone in the new palette.
      //
      // The header is pumped on its own rather than the whole page: the
      // pricing section puts Flexible children in a vertical Flex under
      // unbounded height, so rendering the page below 860px throws before the
      // menu can be opened. That is a separate, pre-existing bug.
      tester.view.physicalSize = const Size(700, 1400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: BooksHomeHeader(
                scrolled: false,
                onStartFree: () {},
                onSignIn: () {},
                onNavTap: (_) {},
              ),
            ),
          ),
        ),
      );
      await tester.pump();

      await tester.tap(find.byIcon(Icons.menu_rounded));
      await tester.pumpAndSettle();
      expect(find.text('Dark mode'), findsOneWidget);

      await tester.tap(find.text('Dark mode'));
      await tester.pumpAndSettle();
      expect(
        find.text('Dark mode'),
        findsNothing,
        reason: 'the sheet dismisses instead of half-repainting',
      );

      // Reopening proves the toggle took effect rather than being swallowed.
      await tester.tap(find.byIcon(Icons.menu_rounded));
      await tester.pumpAndSettle();
      expect(find.text('Light mode'), findsOneWidget);
    });
  });
}
