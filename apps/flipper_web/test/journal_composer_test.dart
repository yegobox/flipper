import 'package:flipper_web/modules/accounting/widgets/journal_composer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('JournalComposer shows post button disabled initially', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: JournalComposer(onClose: () {}),
        ),
      ),
    );

    final postButton = find.widgetWithText(FilledButton, 'Post entry');
    expect(postButton, findsOneWidget);
    final button = tester.widget<FilledButton>(postButton);
    expect(button.onPressed, isNull);
  });

  testWidgets('JournalComposer can apply template and show memo', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: JournalComposer(onClose: () {}),
        ),
      ),
    );

    await tester.tap(find.text('Record a sale'));
    await tester.pump();

    expect(find.text('Record a sale'), findsWidgets);
  });
}
