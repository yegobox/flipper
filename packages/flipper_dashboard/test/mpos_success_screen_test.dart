import 'package:flipper_dashboard/screens/mpos_success_screen.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> _pump(
  WidgetTester tester,
  MposSaleCompleteSnapshot data, {
  VoidCallback? onPrintReceipt,
  VoidCallback? onNewSale,
}) async {
  tester.view.physicalSize = const Size(390, 844);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    MaterialApp(
      localizationsDelegates: FlipperLocalizationDelegates.delegates,
      supportedLocales: FlipperLocalizationDelegates.supportedLocales,
      home: MposSuccessScreen(
        data: data,
        onNewSale: onNewSale ?? () {},
        onPrintReceipt: onPrintReceipt,
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('a cash sale shows what was tendered and the change', (
    tester,
  ) async {
    await _pump(
      tester,
      const MposSaleCompleteSnapshot(
        total: 200,
        itemCount: 1,
        methodLabel: 'Cash',
        customerName: 'mura',
        tendered: 500,
        change: 300,
      ),
    );

    expect(find.text('Sale complete'), findsOneWidget);
    expect(find.textContaining('Cash'), findsOneWidget);
    expect(find.textContaining('mura'), findsOneWidget);
    expect(find.text('RWF 200'), findsOneWidget);
    expect(find.text('RWF 500'), findsOneWidget);
    expect(find.text('RWF 300'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('a non-cash sale has no tendered or change rows', (tester) async {
    await _pump(
      tester,
      const MposSaleCompleteSnapshot(
        total: 200,
        itemCount: 2,
        methodLabel: 'MoMo',
      ),
    );

    expect(find.text('RWF 200'), findsOneWidget);
    expect(find.text('Tendered'), findsNothing);
    expect(find.text('Change'), findsNothing);
  });

  testWidgets('Print receipt prints, and is hidden with nothing to call', (
    tester,
  ) async {
    var printed = 0;
    var newSale = 0;
    await _pump(
      tester,
      const MposSaleCompleteSnapshot(
        total: 200,
        itemCount: 1,
        methodLabel: 'Cash',
      ),
      onPrintReceipt: () => printed++,
      onNewSale: () => newSale++,
    );

    await tester.tap(find.text('Print receipt'));
    expect(printed, 1);
    expect(newSale, 0);

    await tester.tap(find.text('New sale'));
    expect(newSale, 1);

    await _pump(
      tester,
      const MposSaleCompleteSnapshot(
        total: 200,
        itemCount: 1,
        methodLabel: 'Cash',
      ),
    );
    expect(find.text('Print receipt'), findsNothing);
  });
}
