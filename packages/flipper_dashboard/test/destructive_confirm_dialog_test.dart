import 'package:flipper_dashboard/widgets/destructive_confirm_dialog.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget host(void Function(BuildContext) onTap) => MaterialApp(
        locale: const Locale('en'),
        localizationsDelegates: FlipperAppLocalizations.localizationsDelegates,
        supportedLocales: FlipperAppLocalizations.supportedLocales,
        home: Builder(
          builder: (context) => Scaffold(
            body: Center(
              child: ElevatedButton(
                onPressed: () => onTap(context),
                child: const Text('open'),
              ),
            ),
          ),
        ),
      );

  testWidgets('renders lines, total and footnote without overflow',
      (tester) async {
    bool? result;
    await tester.pumpWidget(host((context) async {
      result = await showDestructiveConfirmDialog(
        context: context,
        title: 'Delete All Items',
        message: 'Are you sure you want to remove all 6 items?',
        confirmLabel: 'Delete All',
        footnote: 'This action cannot be undone.',
        lines: [
          for (var i = 0; i < 6; i++)
            DestructiveConfirmLine(
              label: 'A rather long product name FP007$i',
              meta: '1 × RWF 3,500.00',
              trailing: '3,500.00',
            ),
        ],
        totalLabel: 'Total Amount',
        totalValue: 'RWF 21,000.00',
      );
    }));

    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    expect(find.text('Delete All Items'), findsOneWidget);
    expect(find.text('+2 more'), findsOneWidget);
    expect(find.text('RWF 21,000.00'), findsOneWidget);
    expect(find.text('This action cannot be undone.'), findsOneWidget);

    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    expect(result, isFalse);
  });

  testWidgets('busy confirm keeps the dialog open until onConfirm resolves',
      (tester) async {
    var calls = 0;
    await tester.pumpWidget(host((context) {
      showDestructiveConfirmDialog(
        context: context,
        title: 'Delete',
        message: 'Remove it?',
        confirmLabel: 'Delete All',
        onConfirm: () async {
          calls++;
          await Future<void>.delayed(const Duration(milliseconds: 50));
          return true;
        },
      );
    }));

    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Delete All'));
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    // Second tap while busy must not fire a second delete.
    await tester.tap(find.byType(FilledButton));
    await tester.pump();
    expect(calls, 1);

    await tester.pumpAndSettle();
    expect(find.text('Remove it?'), findsNothing);
  });
}
