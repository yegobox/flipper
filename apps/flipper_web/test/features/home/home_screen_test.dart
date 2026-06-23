import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flipper_web/features/home/home_screen.dart';
import 'package:flipper_web/features/home/widgets/books_home_widgets.dart';

void main() {
  group('HomeScreen', () {
    tearDown(() {
      booksHomeShowDeviceMocks = true;
    });

    Future<void> pumpHomeScreen(WidgetTester tester) async {
      tester.view.physicalSize = const Size(1920, 4000);
      tester.view.devicePixelRatio = 1.0;
      booksHomeShowDeviceMocks = false;

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
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
  });
}
