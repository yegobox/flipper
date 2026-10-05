import 'package:flipper_dashboard/manual_purchase/manual_purchase_mobile_screen.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

Future<void> _pumpPhone(WidgetTester tester, Size size) async {
  // setSurfaceSize is a no-op here; the view size is what layout uses.
  tester.view.physicalSize = size * 3;
  tester.view.devicePixelRatio = 3;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    const ProviderScope(
      child: MaterialApp(
        localizationsDelegates: FlipperLocalizationDelegates.delegates,
        supportedLocales: FlipperLocalizationDelegates.supportedLocales,
        home: ManualPurchaseMobileScreen(),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

/// Scrolls [finder] to mid-screen, clear of the fixed save bar.
Future<void> _center(WidgetTester tester, Finder finder) async {
  await tester.scrollUntilVisible(
    finder,
    120,
    scrollable: find.byType(Scrollable).first,
  );
  await Scrollable.ensureVisible(tester.element(finder), alignment: 0.5);
  await tester.pumpAndSettle();
}

void main() {
  for (final size in const [Size(320, 640), Size(390, 844)]) {
    testWidgets('lays out without overflow at ${size.width.toInt()}pt', (
      tester,
    ) async {
      await _pumpPhone(tester, size);
      expect(find.text('Record purchase'), findsOneWidget);
      expect(find.text('Choose supplier'), findsOneWidget);
      expect(find.text('Save as waiting'), findsOneWidget);

      // Credit terms appear only for credit payment types.
      expect(find.text('Pay supplier by'), findsNothing);
      // Shares the POS payment label, "Cash / Credit".
      await _center(tester, find.text('Cash / Credit'));
      await tester.tap(find.text('Cash / Credit'));
      await tester.pumpAndSettle();
      await _center(tester, find.text('You will owe this supplier'));
      expect(find.text('Pay supplier by'), findsOneWidget);
      expect(find.text('Paid now'), findsOneWidget);
      expect(find.text('You will owe this supplier'), findsOneWidget);

      await _center(tester, find.text('Cash'));
      await tester.tap(find.text('Cash'));
      await tester.pumpAndSettle();
      expect(find.text('Pay supplier by'), findsNothing);
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('new item sheet adds a line with its total', (tester) async {
    await _pumpPhone(tester, const Size(390, 844));
    await _center(tester, find.text('New item'));
    await tester.tap(find.text('New item'));
    await tester.pumpAndSettle();

    final fields = find.descendant(
      of: find.byType(BottomSheet),
      matching: find.byType(TextField),
    );
    await tester.enterText(fields.at(0), 'Rice 25kg');
    await tester.enterText(fields.at(1), '4');
    await tester.enterText(fields.at(2), '29500');
    await tester.pump();
    await tester.tap(find.text('Add item'));
    await tester.pumpAndSettle();

    expect(find.text('Rice 25kg'), findsOneWidget);
    expect(find.text('118,000'), findsWidgets);
    expect(find.text('Approve · 118,000'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
