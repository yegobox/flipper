import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_web/modules/accounting/data/accounting_models.dart';
import 'package:flipper_web/modules/accounting/widgets/journal_approval_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

const _entry = JournalEntry(
  id: 'JE-1047',
  date: 'Nov 21',
  memo: 'Cash sale',
  ref: 'RCPT-9',
  status: JournalStatus.pending,
  src: 'Manual',
  lines: [
    JournalLine(ac: '1010', dr: 5000),
    JournalLine(ac: '4000', cr: 5000),
  ],
);

const _accounts = {
  '1010': Account(
    code: '1010',
    name: 'Cash',
    type: AccountType.asset,
    sub: 'Current assets',
    normal: AccountNormal.debit,
    bal: 0,
  ),
  '4000': Account(
    code: '4000',
    name: 'Sales',
    type: AccountType.income,
    sub: 'Revenue',
    normal: AccountNormal.credit,
    bal: 0,
  ),
};

Future<void> _pump(
  WidgetTester tester, {
  bool isApproving = false,
  Future<void> Function()? onApprove,
  VoidCallback? onReject,
}) {
  return tester.pumpWidget(
    MaterialApp(
      localizationsDelegates: FlipperLocalizationDelegates.delegates,
      supportedLocales: FlipperLocalizationDelegates.supportedLocales,
      home: Scaffold(
        body: SingleChildScrollView(
          child: SizedBox(
            width: 380,
            child: JournalApprovalCard(
              entry: _entry,
              action: null,
              accountMap: _accounts,
              onApprove: onApprove ?? () async {},
              onReject: onReject ?? () {},
              isApproving: isApproving,
            ),
          ),
        ),
      ),
    ),
  );
}

/// The decorated Container that paints the Approve button.
Finder _approveBackground(Finder inside) => find
    .ancestor(
      of: inside,
      matching: find.byWidgetPredicate(
        (w) =>
            w is Container &&
            w.decoration is BoxDecoration &&
            (w.decoration as BoxDecoration).gradient != null,
      ),
    )
    .first;

void main() {
  testWidgets('Approve paints its gradient with a Container, not Ink, and '
      'taps approve', (tester) async {
    var approvals = 0;
    var rejections = 0;
    await _pump(
      tester,
      onApprove: () async => approvals++,
      onReject: () => rejections++,
    );

    final approve = find.text('Approve');
    final bg = _approveBackground(approve);
    final decoration =
        tester.widget<Container>(bg).decoration! as BoxDecoration;
    final gradient = decoration.gradient! as LinearGradient;
    expect(gradient.colors, const [Color(0xFF2563EB), Color(0xFF1D4ED8)]);
    expect(decoration.boxShadow, isNotEmpty);
    expect(tester.getSize(bg).height, 46);

    // InkWell inside a transparent Material inside the Container, so the
    // press highlight draws over the gradient.
    final inkWell = find.descendant(of: bg, matching: find.byType(InkWell));
    expect(inkWell, findsOneWidget);
    expect(
      find.ancestor(
        of: inkWell,
        matching: find.byWidgetPredicate(
          (w) => w is Material && w.type == MaterialType.transparency,
        ),
      ),
      findsWidgets,
    );
    expect(find.byType(Ink), findsNothing);

    await tester.tap(approve);
    await tester.pump();
    expect(approvals, 1);

    await tester.tap(find.text('Reject'));
    await tester.pump();
    expect(rejections, 1);
  });

  testWidgets('while approving, Approve shows a spinner and ignores taps', (
    tester,
  ) async {
    var approvals = 0;
    await _pump(tester, isApproving: true, onApprove: () async => approvals++);

    expect(find.text('Approve'), findsNothing);
    final spinner = find.byType(CircularProgressIndicator);
    expect(spinner, findsOneWidget);
    final bg = _approveBackground(spinner);
    final inkWell = find.descendant(of: bg, matching: find.byType(InkWell));
    expect(tester.widget<InkWell>(inkWell).onTap, isNull);

    await tester.tap(inkWell);
    await tester.pump();
    expect(approvals, 0);
  });
}
