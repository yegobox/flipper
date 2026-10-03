import 'package:flipper_dashboard/widgets/cashbook_new_category_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Opens the sheet and records what it resolved to.
Future<List<String?>> _open(
  WidgetTester tester, {
  required Future<String> Function(String) onCreate,
}) async {
  tester.view.physicalSize = const Size(1179, 2556);
  tester.view.devicePixelRatio = 3;
  addTearDown(tester.view.reset);
  final results = <String?>[];
  await tester.pumpWidget(
    MaterialApp(
      home: Builder(
        builder: (ctx) => Scaffold(
          body: TextButton(
            onPressed: () async => results.add(
              await showCashbookNewCategorySheet(
                context: ctx,
                isIncome: false,
                existing: const [(id: 'existing-1', name: 'Transport')],
                onCreate: onCreate,
              ),
            ),
            child: const Text('open'),
          ),
        ),
      ),
    ),
  );
  await tester.tap(find.text('open'));
  await tester.pumpAndSettle();
  return results;
}

void main() {
  testWidgets('create is disabled until a name is typed', (tester) async {
    await _open(tester, onCreate: (_) async => 'new');
    final button = tester.widget<FilledButton>(find.byType(FilledButton));
    expect(button.onPressed, isNull);
  });

  testWidgets('a duplicate name selects the existing category', (
    tester,
  ) async {
    var created = false;
    final results = await _open(
      tester,
      onCreate: (_) async {
        created = true;
        return 'new';
      },
    );
    await tester.enterText(find.byType(TextField), ' transport ');
    await tester.pump();
    expect(find.text('Use existing category'), findsOneWidget);
    await tester.tap(find.byType(FilledButton));
    await tester.pumpAndSettle();
    expect(results, ['existing-1']);
    expect(created, isFalse);
  });

  testWidgets('a quick pick fills the name and creates it', (tester) async {
    String? createdName;
    final results = await _open(
      tester,
      onCreate: (name) async {
        createdName = name;
        return 'new-id';
      },
    );
    expect(find.text('Transport'), findsNothing, reason: 'already exists');
    await tester.tap(find.text('Rent'));
    await tester.pump();
    await tester.tap(find.text('Create category'));
    await tester.pumpAndSettle();
    expect(createdName, 'Rent');
    expect(results, ['new-id']);
  });

  testWidgets('a failed save keeps the sheet open with an error', (
    tester,
  ) async {
    final results = await _open(
      tester,
      onCreate: (_) async => throw Exception('offline'),
    );
    await tester.enterText(find.byType(TextField), 'Fuel');
    await tester.pump();
    await tester.tap(find.text('Create category'));
    await tester.pumpAndSettle();
    expect(find.textContaining("Couldn't save"), findsOneWidget);
    expect(find.text('New category'), findsOneWidget);
    expect(results, isEmpty);
  });
}
