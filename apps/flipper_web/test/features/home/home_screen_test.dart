import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flipper_web/features/home/home_screen.dart';
import 'package:flipper_web/features/home/sections/books_home_sections.dart';
import 'package:flipper_web/features/home/theme/books_home_theme.dart';
import 'package:flipper_web/features/home/widgets/books_home_widgets.dart';

void main() {
  group('HomeScreen', () {
    Future<void> pumpHomeScreen(
      WidgetTester tester, {
      ThemeMode themeMode = ThemeMode.light,
    }) async {
      tester.view.physicalSize = const Size(1920, 4000);
      tester.view.devicePixelRatio = 1.0;

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
      // Flipper OS is the product; Books is its accounting app.
      expect(find.text('OS'), findsWidgets);
      expect(find.text('FLIPPER OS · POWERED BY FLOW AI'), findsOneWidget);
      expect(find.text('FLIPPER OS'), findsOneWidget);
      expect(find.text('Flipper Books'), findsWidgets);
      expect(find.text('Start free'), findsWidgets);
      expect(find.text('See how it works'), findsOneWidget);
      expect(find.text('RRA / EBM-READY'), findsOneWidget);
      // Headlines are one rich text with a serif-italic accent span.
      // The rotating headline also lays out every line, hidden, for its height.
      expect(find.textContaining('does itself.'), findsWidgets);
      expect(find.textContaining('Point of sale that'), findsWidgets);
      expect(find.textContaining('Accounting'), findsWidgets);

      // The marquee repeats its run so it can loop.
      expect(find.textContaining('Real-time ledger'), findsWidgets);
      expect(find.textContaining('12,400+'), findsWidgets);

      expect(find.text('01'), findsWidgets);
      expect(find.textContaining('Zero double-entry.'), findsOneWidget);
      expect(find.text('MEET FLOW AI'), findsOneWidget);
      expect(find.text('INSIDE BOOKS'), findsOneWidget);

      expect(find.textContaining('No surprises.'), findsOneWidget);
      expect(find.text('MOBILE'), findsOneWidget);
      expect(find.text('MOBILE + DESKTOP'), findsOneWidget);
      expect(find.text('ENTERPRISE'), findsOneWidget);
      expect(find.text('5,000'), findsOneWidget);
      expect(find.text('120,000'), findsOneWidget);
      expect(find.text('1.5M+'), findsOneWidget);
      expect(find.text('★ MOST POPULAR'), findsOneWidget);

      expect(find.textContaining('counting.'), findsOneWidget);
      expect(find.text('12,400+'), findsOneWidget);
      expect(find.text('RWF 1.2B'), findsOneWidget);
      expect(find.text('99.9%'), findsOneWidget);
    });

    testWidgets('renders light by default', (WidgetTester tester) async {
      await pumpHomeScreen(tester);

      expect(AppColors.palette, BooksPalette.light);
      expect(AppColors.bg, BooksPalette.light.bg);
      expect(BooksPalette.light.bg, const Color(0xFFFFFFFF));

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

    testWidgets('holds the marquee still under reduced motion', (
      WidgetTester tester,
    ) async {
      await pumpHomeScreen(tester);

      // A running ticker would never let the page settle.
      await tester.pumpAndSettle();
      expect(find.byType(MarqueeTicker), findsOneWidget);
    });

    testWidgets('lays out on a phone without overflowing', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(390, 9000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: MediaQuery(
              data: MediaQueryData(
                size: Size(390, 9000),
                disableAnimations: true,
              ),
              child: HomeScreen(),
            ),
          ),
        ),
      );
      await tester.pump();

      expect(tester.takeException(), isNull);
      expect(find.byIcon(Icons.menu_rounded), findsOneWidget);
      expect(find.text('99.9%'), findsOneWidget);
    });

    testWidgets('the nav sheet closes when the theme is switched from it', (
      WidgetTester tester,
    ) async {
      // A modal sheet keeps the background colour it opened with, and its
      // other rows watch nothing, so they keep the colours they were built
      // with. Leaving it open would show this row alone in the new palette.
      //
      // The header is pumped on its own so the sheet is the only overlay.
      tester.view.physicalSize = const Size(700, 1400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: BooksHomeHeader(
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
      expect(find.text('DARK MODE'), findsOneWidget);

      await tester.tap(find.text('DARK MODE'));
      await tester.pumpAndSettle();
      expect(
        find.text('DARK MODE'),
        findsNothing,
        reason: 'the sheet dismisses instead of half-repainting',
      );

      // Reopening proves the toggle took effect rather than being swallowed.
      await tester.tap(find.byIcon(Icons.menu_rounded));
      await tester.pumpAndSettle();
      expect(find.text('LIGHT MODE'), findsOneWidget);
    });
  });
}
