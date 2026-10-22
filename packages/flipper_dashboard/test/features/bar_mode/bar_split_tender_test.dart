import 'package:flipper_dashboard/features/bar_mode/bar_split_tender.dart';
import 'package:flipper_dashboard/features/bar_mode/widgets/bar_split_tender_rows.dart';
import 'package:flipper_dashboard/utils/sale_receipt_settlement.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_models/DatabaseSyncInterface.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/helperModels/sale_completion_helpers.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/payment_methods.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mocktail/mocktail.dart';

// flutter test test/features/bar_mode/bar_split_tender_test.dart

class _MockSync extends Mock implements DatabaseSyncInterface {}

List<(String, double)> _rows(BarSplitSummary s) => [
  for (final line in s.paymentLines) (line.method, line.amount),
];

void main() {
  setUpAll(() => GoogleFonts.config.allowRuntimeFetching = false);

  group('barSplitSummary', () {
    test('cash alone gives change and records only the bill', () {
      final s = barSplitSummary([
        const BarTender(method: kBarCash, amount: 30000),
      ], 25000);
      expect(s.canConfirm, isTrue);
      expect(s.paid, 30000);
      expect(s.change, 5000);
      expect(s.primaryMethod, kBarCash);
      expect(_rows(s), [(kBarCash, 25000.0)]);
    });

    test('cash short of the bill cannot settle', () {
      final s = barSplitSummary([
        const BarTender(method: kBarCash, amount: 20000),
      ], 25000);
      expect(s.remaining, 5000);
      expect(s.canConfirm, isFalse);
    });

    test('a single MoMo or card tender pays the whole bill untyped', () {
      for (final method in [kMobileMoney, kBarCard]) {
        final s = barSplitSummary([BarTender(method: method)], 25000);
        expect(s.canConfirm, isTrue, reason: method);
        expect(s.change, 0);
        expect(_rows(s), [(method, 25000.0)]);
      }
    });

    test('cash + MoMo records one row each, filed under the first', () {
      final s = barSplitSummary([
        const BarTender(method: kBarCash, amount: 10000),
        const BarTender(method: kMobileMoney, amount: 15000),
      ], 25000);
      expect(s.canConfirm, isTrue);
      expect(s.change, 0);
      expect(s.primaryMethod, kBarCash);
      expect(_rows(s), [(kBarCash, 10000.0), (kMobileMoney, 15000.0)]);
    });

    test('change comes off the cash row so the rows add up to the bill', () {
      final s = barSplitSummary([
        const BarTender(method: kBarCash, amount: 20000),
        const BarTender(method: kBarCard, amount: 10000),
      ], 25000);
      expect(s.canConfirm, isTrue);
      expect(s.change, 5000);
      expect(_rows(s), [(kBarCash, 15000.0), (kBarCard, 10000.0)]);
    });

    test('MoMo and card above the bill are refused: they give no change', () {
      final s = barSplitSummary([
        const BarTender(method: kBarCash),
        const BarTender(method: kMobileMoney, amount: 30000),
      ], 25000);
      expect(s.nonCashOverTotal, isTrue);
      expect(s.canConfirm, isFalse);
    });

    test('the primary tender is the first that carries money', () {
      final s = barSplitSummary([
        const BarTender(method: kBarCash),
        const BarTender(method: kMobileMoney, amount: 25000),
      ], 25000);
      expect(s.primaryMethod, kMobileMoney);
      expect(_rows(s), [(kMobileMoney, 25000.0)]);
    });

    test('zero tenders on a real bill cannot settle', () {
      final s = barSplitSummary([
        const BarTender(method: kBarCash),
        const BarTender(method: kMobileMoney),
      ], 25000);
      expect(s.canConfirm, isFalse);
      expect(s.paymentLines, isEmpty);
    });
  });

  group('split editing', () {
    test('splitting typed cash adds MoMo for the rest', () {
      final next = barAddTender([
        const BarTender(method: kBarCash, amount: 10000),
      ], 25000)!;
      expect(
        [for (final t in next) (t.method, t.amount)],
        [(kBarCash, 10000.0), (kMobileMoney, 15000.0)],
      );
    });

    test('splitting a MoMo bill starts the MoMo part at zero', () {
      final next = barAddTender([
        const BarTender(method: kMobileMoney),
      ], 25000)!;
      expect(
        [for (final t in next) (t.method, t.amount)],
        [(kMobileMoney, 0.0), (kBarCash, 25000.0)],
      );
    });

    test('typing a row re-balances the last; typing the last re-balances '
        'the first', () {
      const tenders = [
        BarTender(method: kBarCash, amount: 8000),
        BarTender(method: kMobileMoney, amount: 0),
      ];
      final a = barRebalanceTenders(tenders, 25000, editedIndex: 0);
      expect(a.last.amount, 17000);
      final b = barRebalanceTenders(
        [a.first, a.last.copyWith(amount: 20000)],
        25000,
        editedIndex: 1,
      );
      expect(b.first.amount, 5000);
      expect(b.last.amount, 20000);
    });

    test('no more tenders once every method is on the bill', () {
      final all = [for (final m in barSettleMethods) BarTender(method: m)];
      expect(barAddTender(all, 25000), isNull);
    });

    test('removing a row re-balances what is left', () {
      final next = barRemoveTender(
        const [
          BarTender(method: kBarCash, amount: 5000),
          BarTender(method: kMobileMoney, amount: 10000),
          BarTender(method: kBarCard, amount: 10000),
        ],
        1,
        25000,
      );
      expect(
        [for (final t in next) (t.method, t.amount)],
        [(kBarCash, 5000.0), (kBarCard, 20000.0)],
      );
    });
  });

  group('recordSalePaymentAndScheduleStock', () {
    test(
      'writes one payment row per tender, clearing only on the first',
      () async {
        final sync = _MockSync();
        when(
          () => sync.savePaymentType(
            transactionId: any(named: 'transactionId'),
            amount: any(named: 'amount'),
            paymentMethod: any(named: 'paymentMethod'),
            payerName: any(named: 'payerName'),
            singlePaymentOnly: any(named: 'singlePaymentOnly'),
            saleCompletionFastPath: any(named: 'saleCompletionFastPath'),
          ),
        ).thenAnswer((_) async {});

        await recordSalePaymentAndScheduleStock(
          sync: sync,
          transaction: ITransaction(
            branchId: 'b1',
            agentId: 'a1',
            status: COMPLETE,
            transactionType: 'Sale',
            paymentType: kBarCash,
            cashReceived: 25000,
            customerChangeDue: 0,
            updatedAt: DateTime.now(),
            isIncome: true,
            isExpense: false,
          ),
          lines: const [],
          transactionId: 'tab-1',
          payments: const [
            PaymentLineForSaleCompletion(amount: 10000, method: kBarCash),
            PaymentLineForSaleCompletion(amount: 15000, method: kMobileMoney),
          ],
        );

        verifyInOrder([
          for (final (amount, method, clear) in [
            (10000.0, kBarCash, true),
            (15000.0, kMobileMoney, false),
          ])
            () => sync.savePaymentType(
              transactionId: 'tab-1',
              amount: amount,
              paymentMethod: method,
              payerName: any(named: 'payerName'),
              singlePaymentOnly: clear,
              saleCompletionFastPath: true,
            ),
        ]);
      },
    );
  });

  group('BarSplitTenderRows', () {
    Future<List<List<BarTender>>> pump(
      WidgetTester tester,
      List<BarTender> initial,
    ) async {
      final changes = <List<BarTender>>[];
      var tenders = initial;
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: FlipperLocalizationDelegates.delegates,
          supportedLocales: FlipperLocalizationDelegates.supportedLocales,
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) => BarSplitTenderRows(
                tenders: tenders,
                total: 25000,
                onChanged: (next) {
                  changes.add(next);
                  if (next.length > 1) setState(() => tenders = next);
                },
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      return changes;
    }

    testWidgets('typing cash fills MoMo with the rest', (tester) async {
      final changes = await pump(tester, const [
        BarTender(method: kBarCash, amount: 10000),
        BarTender(method: kMobileMoney, amount: 15000),
      ]);
      expect(find.text('15000'), findsOneWidget);

      await tester.enterText(find.byType(TextField).first, '8000');
      await tester.pumpAndSettle();

      expect(changes.last.last.amount, 17000);
      expect(find.text('17000'), findsOneWidget);
      expect(find.textContaining('Remaining RWF 0'), findsOneWidget);
    });

    testWidgets('adds a card row with nothing left to pay on it', (
      tester,
    ) async {
      final changes = await pump(tester, const [
        BarTender(method: kBarCash, amount: 10000),
        BarTender(method: kMobileMoney, amount: 15000),
      ]);
      await tester.tap(find.byKey(const Key('barSplitAddMethod')));
      await tester.pumpAndSettle();

      expect(
        [for (final t in changes.last) t.method],
        [kBarCash, kMobileMoney, kBarCard],
      );
      expect(changes.last.last.amount, 0);
      // Every method is on the bill now.
      expect(find.byKey(const Key('barSplitAddMethod')), findsNothing);
    });

    testWidgets('removing down to one tender hands back a single tender', (
      tester,
    ) async {
      final changes = await pump(tester, const [
        BarTender(method: kBarCash, amount: 10000),
        BarTender(method: kMobileMoney, amount: 15000),
      ]);
      await tester.tap(find.byIcon(Icons.close).last);
      await tester.pumpAndSettle();

      expect(changes.last.length, 1);
      expect(changes.last.single.method, kBarCash);
    });
  });

  test('settled toast names every tender', () async {
    final l10n = await FlipperAppLocalizations.delegate.load(
      const Locale('en'),
    );
    expect(
      barTendersLabel(l10n, const [
        PaymentLineForSaleCompletion(amount: 10000, method: kBarCash),
        PaymentLineForSaleCompletion(amount: 15000, method: kMobileMoney),
      ], kBarCash),
      'Cash + Mobile Money',
    );
  });
}
