import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_web/modules/accounting/data/accounting_models.dart';
import 'package:flipper_web/modules/accounting/data/services/bank_balance_service.dart';
import 'package:flipper_web/modules/accounting/widgets/sms_balance_check_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

const _sms = BankLine(
  date: 'Oct 21',
  desc: 'BK · to Jane',
  amt: -2000,
  matched: false,
  source: 'sms',
  isoDate: '2026-10-21',
);

/// When the bank's balance SMS arrived.
final _asOf = DateTime(2026, 10, 22, 9, 5);

BankLine _smsOn(String isoDate, int amt) => BankLine(
  date: isoDate,
  desc: 'BK · $isoDate',
  amt: amt,
  matched: false,
  source: 'sms',
  isoDate: isoDate,
);

void main() {
  test('unmatched SMS lines explain the gap; the rest is unexplained', () {
    final check = SmsBalanceCheck(
      bank: 8000,
      books: 10000,
      asOf: _asOf,
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

  test('only lines the balance can include explain the gap', () {
    final check = SmsBalanceCheck(
      bank: 8000,
      books: 10000,
      asOf: _asOf,
      lines: [
        // The day before the balance SMS: already in the balance.
        _smsOn('2026-10-21', -2000),
        // Same day, no time: it may have come after the balance SMS.
        _smsOn('2026-10-22', -300),
        // After the balance SMS.
        _smsOn('2026-10-23', -700),
        // No date: its place is unknown.
        const BankLine(
          date: '',
          desc: 'undated',
          amt: -50,
          matched: false,
          source: 'sms',
        ),
      ],
    );
    expect(check.pendingLines.map((l) => l.isoDate), ['2026-10-21']);
    expect(check.pendingNet, -2000);
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
                  observedAt: _asOf,
                ),
                accounts: const [],
                check: SmsBalanceCheck(
                  bank: 8000,
                  books: 10000,
                  asOf: _asOf,
                  lines: [_sms],
                ),
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

  testWidgets('money that moved without an SMS is pointed out', (tester) async {
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
                observedAt: DateTime(2026, 10, 22, 12),
              ),
              accounts: const [],
              check: SmsBalanceCheck(
                bank: 8000,
                books: 8000,
                lines: const [],
                asOf: DateTime(2026, 10, 22, 12),
              ),
              gaps: [
                SmsBalanceGap(
                  bankAccountCode: '1020',
                  amount: -1000,
                  after: DateTime(2026, 10, 22, 9),
                  before: DateTime(2026, 10, 22, 12),
                ),
                SmsBalanceGap(
                  bankAccountCode: '1020',
                  amount: 500,
                  after: DateTime(2026, 10, 21, 8),
                  before: DateTime(2026, 10, 21, 9),
                ),
              ],
              onPostAdjustment: (_) {},
              onSaveAlert: (_) async {},
            ),
          ),
        ),
      ),
    );
    expect(
      find.text(
        '1,000 went out between 22 Oct, 09:00 and 22 Oct, 12:00 with no SMS Flipper received.',
      ),
      findsOneWidget,
    );
    expect(
      find.text(
        '500 came in between 21 Oct, 08:00 and 21 Oct, 09:00 with no SMS Flipper received.',
      ),
      findsOneWidget,
    );
    expect(find.byKey(const Key('sms-balance-gap-hint')), findsOneWidget);
  });
}
