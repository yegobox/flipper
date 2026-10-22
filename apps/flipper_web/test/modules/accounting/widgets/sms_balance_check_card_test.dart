import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_web/modules/accounting/data/accounting_models.dart';
import 'package:flipper_web/modules/accounting/data/services/bank_balance_service.dart';
import 'package:flipper_web/modules/accounting/widgets/sms_balance_check_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

const _sms = BankLine(
  date: 'Oct 22',
  desc: 'BK · to Jane',
  amt: -2000,
  matched: false,
  source: 'sms',
);

void main() {
  test('unmatched SMS lines explain the gap; the rest is unexplained', () {
    final check = SmsBalanceCheck(
      bank: 8000,
      books: 10000,
      lines: [
        _sms,
        _sms.copyWith(matched: true),
        // A statement line is not money the SMS already counted.
        const BankLine(
          date: 'Oct 22',
          desc: 'Import',
          amt: 500,
          matched: false,
        ),
      ],
    );
    expect(check.pendingLines, hasLength(1));
    expect(check.pendingNet, -2000);
    expect(check.difference, -2000);
    expect(check.unexplained, 0);
  });

  testWidgets(
    'agreeing books show no adjustment, and a blank level is not saved',
    (tester) async {
      final saved = <int>[];
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: FlipperLocalizationDelegates.delegates,
          supportedLocales: FlipperLocalizationDelegates.supportedLocales,
          home: Scaffold(
            body: SingleChildScrollView(
              child: SmsBalanceCheckCard(
                total: SmsBalanceTotal(
                  bankAccountCode: '1020',
                  balance: 8000,
                  observedAt: DateTime(2026, 10, 22, 9, 5),
                ),
                accounts: const [],
                check: SmsBalanceCheck(bank: 8000, books: 10000, lines: [_sms]),
                onPostAdjustment: (_) => fail('nothing to adjust'),
                onSaveAlert: (t) async => saved.add(t),
              ),
            ),
          ),
        ),
      );
      expect(find.text('Books agree with your bank.'), findsOneWidget);
      expect(find.byKey(const Key('sms-balance-adjust')), findsNothing);
      expect(
        find.descendant(
          of: find.byKey(const Key('sms-balance-difference')),
          matching: find.text('(2,000)'),
        ),
        findsOneWidget,
      );

      await tester.tap(find.byKey(const Key('sms-balance-alert-save')));
      await tester.pump();
      expect(saved, isEmpty);
    },
  );
}
