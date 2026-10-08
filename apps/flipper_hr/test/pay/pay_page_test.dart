import 'package:flipper_hr/features/pay/data/pay_models.dart';
import 'package:flipper_hr/features/pay/data/pay_providers.dart';
import 'package:flipper_hr/features/pay/pay_page.dart';
import 'package:flipper_hr/features/people/data/employee.dart';
import 'package:flipper_hr/features/people/data/people_providers.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/fake_employee_repository.dart';
import '../helpers/fake_pay_repository.dart';

final _today = DateTime(2026, 10, 26);

Employee _aline() => employee(
  id: 'e-1',
  firstName: 'Aline',
  lastName: 'Uwase',
  hireDate: DateTime(2026, 10, 1),
  paymentMethod: PaymentMethod.cash,
).copyWith(payDay: 25);

Employee _bosco() => employee(
  id: 'e-2',
  firstName: 'Bosco',
  lastName: 'Habimana',
  hireDate: DateTime(2026, 10, 1),
).copyWith(payDay: 28);

Advance _advance({double amount = 30000}) => Advance(
  id: 'adv-1',
  employeeId: 'e-1',
  amount: amount,
  currency: 'RWF',
  givenOn: DateTime(2026, 10, 3),
  method: PaymentMethod.cash,
  recovered: 0,
  status: AdvanceStatus.open,
  reason: 'School fees',
);

PayPayment _advancePayout({double amount = 30000}) => PayPayment(
  id: 'pay-adv-1',
  employeeId: 'e-1',
  kind: PaymentKind.advance,
  amount: amount,
  currency: 'RWF',
  paidOn: DateTime(2026, 10, 3),
  method: PaymentMethod.cash,
  advanceId: 'adv-1',
);

Future<void> _pump(
  WidgetTester tester, {
  required FakePayRepository pay,
  List<Employee>? people,
  Size size = const Size(400, 860),
  PayTab tab = PayTab.people,
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        employeeRepositoryProvider.overrideWithValue(
          FakeEmployeeRepository(seed: people ?? [_aline(), _bosco()]),
        ),
        payRepositoryProvider.overrideWithValue(pay),
        hrClockProvider.overrideWithValue(() => _today),
      ],
      child: MaterialApp(
        localizationsDelegates: FlipperLocalizationDelegates.delegates,
        supportedLocales: FlipperLocalizationDelegates.supportedLocales,
        home: Scaffold(
          body: PayPage(
            businessId: 'biz-1',
            branchId: 'branch-1',
            branchName: 'Kigali Main',
            initialTab: tab,
          ),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('who is due comes first, with what they owe back', (
    tester,
  ) async {
    await _pump(
      tester,
      pay: FakePayRepository(
        advances: [_advance()],
        payments: [_advancePayout()],
      ),
    );

    // Aline's pay day (25th) has passed; Bosco's (28th) has not.
    final aline = tester.getTopLeft(find.byKey(const Key('hr-pay-person-e-1')));
    final bosco = tester.getTopLeft(find.byKey(const Key('hr-pay-person-e-2')));
    expect(aline.dy, lessThan(bosco.dy));
    expect(find.text('Overdue since 25 Oct 2026'), findsOneWidget);
    expect(find.text('Owes RWF 30K'), findsOneWidget);
    expect(find.text('Last paid RWF 30,000 on 3 Oct 2026'), findsOneWidget);
  });

  testWidgets(
    'paying reminds what was already handed over and takes the advance back',
    (tester) async {
      final pay = FakePayRepository(
        advances: [_advance()],
        payments: [_advancePayout()],
      );
      await _pump(tester, pay: pay);

      await tester.ensureVisible(find.byKey(const Key('hr-pay-person-e-1')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('hr-pay-person-e-1')));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('hr-pay-period')), findsOneWidget);
      expect(find.text('October 2026'), findsOneWidget);
      expect(
        find.byKey(const Key('hr-pay-already-paid')),
        findsOneWidget,
        reason: 'the advance given on 3 Oct is in this period',
      );
      // 200,000 gross − 37,417 statutory − 30,000 advance.
      expect(
        tester.widget<Text>(find.byKey(const Key('hr-pay-net'))).data,
        'RWF 132,583',
      );

      await tester.ensureVisible(find.byKey(const Key('hr-pay-confirm')));
      await tester.tap(find.byKey(const Key('hr-pay-confirm')));
      await tester.pumpAndSettle();

      expect(pay.createCount, 1);
      final slip = pay.payslips.single;
      expect(slip.advanceRecovery, 30000);
      expect(slip.netPay, 132583);
      expect(slip.status, PayslipStatus.paid);
      expect(pay.advances.single.status, AdvanceStatus.recovered);
      expect(
        pay.payments.where((p) => p.kind == PaymentKind.salary).single.amount,
        132583,
      );
      expect(find.text('Paid Aline Uwase for October 2026'), findsOneWidget);
    },
  );

  testWidgets('recovery is capped at half of pay after tax and RSSB', (
    tester,
  ) async {
    final pay = FakePayRepository(
      advances: [_advance(amount: 150000)],
      payments: [_advancePayout(amount: 150000)],
    );
    await _pump(tester, pay: pay);

    await tester.ensureVisible(find.byKey(const Key('hr-pay-person-e-1')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('hr-pay-person-e-1')));
    await tester.pumpAndSettle();

    // Pre-filled with the most the law allows, not the whole 150,000.
    final field = tester.widget<TextField>(
      find.byKey(const Key('hr-pay-recover-adv-1')),
    );
    expect(field.controller!.text, '81,291');

    await tester.enterText(
      find.byKey(const Key('hr-pay-recover-adv-1')),
      '100000',
    );
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.byKey(const Key('hr-pay-confirm')));
    await tester.tap(find.byKey(const Key('hr-pay-confirm')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('hr-pay-error')), findsOneWidget);
    expect(pay.createCount, 0);
  });

  testWidgets('saving a payslip without paying leaves it unpaid', (
    tester,
  ) async {
    final pay = FakePayRepository();
    await _pump(tester, pay: pay);

    await tester.ensureVisible(find.byKey(const Key('hr-pay-person-e-1')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('hr-pay-person-e-1')));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.byKey(const Key('hr-pay-now')));
    await tester.tap(find.byKey(const Key('hr-pay-now')));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.byKey(const Key('hr-pay-confirm')));
    await tester.tap(find.byKey(const Key('hr-pay-confirm')));
    await tester.pumpAndSettle();

    expect(pay.payslips.single.status, PayslipStatus.unpaid);
    expect(pay.payments, isEmpty);
  });

  testWidgets('giving an advance records it and its payout', (tester) async {
    final pay = FakePayRepository();
    await _pump(tester, pay: pay);

    await tester.ensureVisible(find.byKey(const Key('hr-pay-advance-e-2')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('hr-pay-advance-e-2')));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('hr-advance-amount')), '20000');
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('hr-advance-confirm')));
    await tester.pumpAndSettle();

    expect(pay.advances.single.amount, 20000);
    expect(pay.advances.single.employeeId, 'e-2');
    expect(pay.payments.single.kind, PaymentKind.advance);
    expect(find.text('Owes RWF 20K'), findsOneWidget);
  });

  testWidgets('an employee request is approved into an advance', (
    tester,
  ) async {
    final pay = FakePayRepository(
      requests: [
        AdvanceRequest(
          id: 'req-1',
          employeeId: 'e-2',
          amount: 15000,
          status: AdvanceRequestStatus.pending,
          createdAt: DateTime(2026, 10, 20),
          reason: 'Rent',
        ),
      ],
    );
    await _pump(tester, pay: pay, tab: PayTab.requests);

    expect(find.text('Requests · 1'), findsOneWidget);
    await tester.ensureVisible(
      find.byKey(const Key('hr-request-approve-req-1')),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('hr-request-approve-req-1')));
    await tester.pumpAndSettle();

    expect(pay.requests.single.status, AdvanceRequestStatus.approved);
    expect(pay.advances.single.amount, 15000);
  });

  testWidgets('returns total the month for RRA and RSSB', (tester) async {
    final pay = FakePayRepository(
      advances: [_advance()],
      payments: [_advancePayout()],
    );
    await _pump(tester, pay: pay, size: const Size(1300, 1000));

    await tester.ensureVisible(find.byKey(const Key('hr-pay-person-e-1')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('hr-pay-person-e-1')));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.byKey(const Key('hr-pay-confirm')));
    await tester.tap(find.byKey(const Key('hr-pay-confirm')));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('hr-pay-tab-returns')));
    await tester.pumpAndSettle();

    expect(
      find.text('Declare and pay PAYE and RSSB contributions by 15 Nov 2026.'),
      findsOneWidget,
    );
    // PAYE 24,000; RSSB = 12,000 + 12,000 + 600 + 600 + 4,000 + 817.
    expect(find.text('RWF 24,000'), findsWidgets);
    expect(find.text('RWF 30,017'), findsOneWidget);
  });

  testWidgets('a load failure offers to try again', (tester) async {
    await _pump(tester, pay: FakePayRepository(failWith: Exception('offline')));
    expect(find.text('Could not load pay records.'), findsOneWidget);
    expect(find.text('Retry'), findsOneWidget);
  });
}
