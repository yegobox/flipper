import 'package:flipper_accounting/payroll_journal_poster.dart';
import 'package:flipper_hr/features/pay/data/pay_models.dart';
import 'package:flipper_hr/features/pay/data/pay_providers.dart';
import 'package:flipper_hr/features/pay/data/payroll_ledger_sync.dart';
import 'package:flipper_hr/features/pay/pay_page.dart';
import 'package:flipper_hr/features/people/data/employee.dart';
import 'package:flipper_hr/features/people/data/people_providers.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_web/features/business_selection/business_branch_selector.dart';
import 'package:flipper_web/models/user_profile.dart';
import 'package:flipper_web/services/ditto_service.dart';
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
  List overrides = const [],
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
        ...overrides,
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

  testWidgets('paying sends the new payslip and payment to Books', (
    tester,
  ) async {
    final posted =
        <
          ({List<PayrollPayslipRecord> slips, List<PayrollPaymentRecord> pays})
        >[];
    final pay = FakePayRepository(
      advances: [_advance()],
      payments: [_advancePayout()],
    );
    await _pump(
      tester,
      pay: pay,
      overrides: [
        // Another business is selected: the pay book still posts to the
        // business that owns it (the employee's and the page's), never to
        // whatever happens to be selected when the book finishes loading.
        selectedBusinessProvider.overrideWithValue(
          Business.fromJson({'id': 'biz-2', 'name': 'Other Shop'}),
        ),
        dittoReadyProvider.overrideWith((ref) => true),
        payrollLedgerPosterProvider.overrideWithValue(({
          required businessId,
          required payslips,
          required payments,
          required writeOffs,
        }) async {
          expect(businessId, 'biz-1');
          posted.add((slips: payslips, pays: payments));
          return 0;
        }),
      ],
    );
    // Opening the page catches Books up once.
    expect(posted, hasLength(1));
    expect(posted.single.pays.single.kind, PayrollPaymentKind.advance);

    await tester.ensureVisible(find.byKey(const Key('hr-pay-person-e-1')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('hr-pay-person-e-1')));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.byKey(const Key('hr-pay-confirm')));
    await tester.tap(find.byKey(const Key('hr-pay-confirm')));
    await tester.pumpAndSettle();

    final last = posted.last;
    final slip = last.slips.single;
    expect(slip.gross, 200000);
    expect(slip.advanceRecovery, 30000);
    expect(
      PayrollJournalPoster.payslipLines(
        slip,
      ).where((l) => l.ac == '2300').single.cr,
      132583,
      reason: 'net pay owed matches the payslip',
    );
    expect(
      last.pays.where((p) => p.kind == PayrollPaymentKind.salary).single.amount,
      132583,
    );
  });

  testWidgets('the page-load catch-up waits for Ditto, then runs once', (
    tester,
  ) async {
    var posts = 0;
    await _pump(
      tester,
      pay: FakePayRepository(
        advances: [_advance()],
        payments: [_advancePayout()],
      ),
      overrides: [
        payrollLedgerPosterProvider.overrideWithValue(({
          required businessId,
          required payslips,
          required payments,
          required writeOffs,
        }) async {
          posts++;
          return 0;
        }),
      ],
    );
    // The book is loaded but Ditto is not up: nothing would be written, so
    // the visit has not caught up yet.
    expect(posts, 0);

    final container = ProviderScope.containerOf(
      tester.element(find.byType(PayPage)),
    );
    container.read(dittoReadyProvider.notifier).state = true;
    await tester.pumpAndSettle();
    expect(posts, 1);

    // Once done, the visit does not post again on its own.
    container.read(dittoReadyProvider.notifier).state = false;
    await tester.pumpAndSettle();
    container.read(dittoReadyProvider.notifier).state = true;
    await tester.pumpAndSettle();
    expect(posts, 1);
  });

  testWidgets('picking another branch catches that branch up too', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(400, 860);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    final pay = FakePayRepository(advances: [_advance()]);
    final scope = ValueNotifier(('biz-1', 'branch-1'));
    addTearDown(scope.dispose);
    final postedTo = <String>[];
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          employeeRepositoryProvider.overrideWithValue(
            FakeEmployeeRepository(seed: [_aline()]),
          ),
          payRepositoryProvider.overrideWithValue(pay),
          hrClockProvider.overrideWithValue(() => _today),
          dittoReadyProvider.overrideWith((ref) => true),
          payrollLedgerPosterProvider.overrideWithValue(({
            required businessId,
            required payslips,
            required payments,
            required writeOffs,
          }) async {
            postedTo.add(businessId);
            return 0;
          }),
        ],
        child: MaterialApp(
          localizationsDelegates: FlipperLocalizationDelegates.delegates,
          supportedLocales: FlipperLocalizationDelegates.supportedLocales,
          home: Scaffold(
            // The router rebuilds the same, unkeyed page for a new branch.
            body: ValueListenableBuilder<(String, String)>(
              valueListenable: scope,
              builder: (_, s, _) => PayPage(businessId: s.$1, branchId: s.$2),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(pay.ledgerReads, ['branch-1']);

    scope.value = ('biz-1', 'branch-2');
    await tester.pumpAndSettle();
    expect(pay.ledgerReads, ['branch-1', 'branch-2']);
    expect(postedTo, ['biz-1', 'biz-1']);

    // Another business with the same branch id is a new scope too.
    scope.value = ('biz-2', 'branch-2');
    await tester.pumpAndSettle();
    expect(postedTo, ['biz-1', 'biz-1', 'biz-2']);
  });

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
    // Payroll reaches Books on its own: no one should enter salaries twice.
    expect(find.byKey(const Key('hr-returns-books-note')), findsOneWidget);
    // It says which payroll Books gets: from the start date on.
    expect(
      find.textContaining(
        'Payroll created on or after 17 Nov 2026 (Rwanda time)',
      ),
      findsOneWidget,
    );
  });

  testWidgets('a load failure offers to try again', (tester) async {
    await _pump(tester, pay: FakePayRepository(failWith: Exception('offline')));
    expect(find.text('Could not load pay records.'), findsOneWidget);
    expect(find.text('Retry'), findsOneWidget);
  });
}
