import 'package:flipper_web/modules/accounting/theme/accounting_tokens.dart';
import 'package:flipper_web/modules/accounting/widgets/accounting_icon.dart';
import 'package:flipper_web/modules/accounting/widgets/accounting_kpi_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> _pump(WidgetTester tester, Widget card) => tester.pumpWidget(
  MaterialApp(
    home: Scaffold(
      body: SingleChildScrollView(child: SizedBox(width: 320, child: card)),
    ),
  ),
);

Color? _iconColor(WidgetTester tester, AccIcon icon) => tester
    .widget<AccountingIcon>(
      find.byWidgetPredicate((w) => w is AccountingIcon && w.icon == icon),
    )
    .color;

void main() {
  testWidgets('a detail sits under the value, above the delta chip', (
    tester,
  ) async {
    await _pump(
      tester,
      const AccountingKpiCard(
        label: 'Cash & bank',
        icon: AccIcon.wallet,
        tone: KpiTone.blue,
        value: 105300,
        detail: Text('Cash 105,000 · Bank 300'),
        delta: 12,
      ),
    );

    final value = tester
        .getTopLeft(find.textContaining('105,300', findRichText: true))
        .dy;
    final detail = tester.getTopLeft(find.text('Cash 105,000 · Bank 300')).dy;
    final delta = tester.getTopLeft(find.text('12%')).dy;
    expect(value, lessThan(detail));
    expect(detail, lessThan(delta));
    expect(_iconColor(tester, AccIcon.arrowUpRight), AccountingTokens.gainInk);
  });

  testWidgets('without a detail the card shows no extra row', (tester) async {
    await _pump(
      tester,
      const AccountingKpiCard(
        label: 'Revenue',
        icon: AccIcon.wallet,
        tone: KpiTone.green,
        value: 5000,
      ),
    );

    expect(find.textContaining('5,000', findRichText: true), findsOneWidget);
    expect(find.byType(Text), findsNWidgets(1));
  });

  testWidgets('a falling delta is drawn as a loss', (tester) async {
    await _pump(
      tester,
      const AccountingKpiCard(
        label: 'Net income',
        icon: AccIcon.wallet,
        tone: KpiTone.red,
        value: -15000,
        delta: -8,
      ),
    );

    expect(find.text('-8%'), findsOneWidget);
    expect(_iconColor(tester, AccIcon.arrowDown), AccountingTokens.lossInk);
    final text = tester.widget<Text>(find.text('-8%'));
    expect(text.style?.color, AccountingTokens.lossInk);
  });
}
