import 'dart:async';

import 'package:flipper_dashboard/features/branch_location/branch_services.dart';
import 'package:flipper_dashboard/features/personal_finance/loans/loan_affordability_screen.dart';
import 'package:flipper_dashboard/features/personal_finance/loans/loan_detail_screen.dart';
import 'package:flipper_dashboard/features/personal_finance/loans/loan_form_sheet.dart';
import 'package:flipper_dashboard/features/personal_finance/loans/loan_picker.dart';
import 'package:flipper_dashboard/features/personal_finance/loans/loans_screen.dart';
import 'package:flipper_dashboard/features/personal_finance/personal_add_money_sheet.dart';
import 'package:flipper_dashboard/features/personal_finance/personal_finance_data.dart';
import 'package:flipper_dashboard/widgets/sms_review/sms_review_categories.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_models/db_model_export.dart' show Category;
import 'package:flipper_models/personal_loans/personal_loan.dart';
import 'package:flipper_models/personal_loans/personal_loans_store.dart';
import 'package:flipper_models/providers/category_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:supabase_models/brick/repository/storage.dart';

class _Box extends Fake implements LocalStorage {
  @override
  String? branchIdString() => 'br';

  @override
  String? getBranchId() => 'br';

  @override
  String defaultCurrency() => 'RWF';
}

class _Services extends BranchServices {
  _Services();

  final _box = _Box();

  @override
  LocalStorage get box => _box;
}

class _Store implements PersonalLoansStore {
  final saved = <PersonalLoan>[];
  final payments = <PersonalLoanPayment>[];
  final deleted = <PersonalLoan>[];

  /// Every loan write throws (Ditto not ready).
  bool failLoans = false;

  /// How many payment writes throw before they succeed.
  int failPayments = 0;

  /// When set, a loan save waits for it.
  Completer<void>? saveGate;

  @override
  Future<void> saveLoan(PersonalLoan loan) async {
    if (failLoans) throw StateError('Ditto is not ready');
    await saveGate?.future;
    saved.add(loan);
  }

  @override
  Future<void> deleteLoan(PersonalLoan loan) async {
    if (failLoans) throw StateError('Ditto is not ready');
    deleted.add(loan);
  }

  @override
  Future<void> addPayment(PersonalLoanPayment payment) async {
    if (failPayments > 0) {
      failPayments--;
      throw StateError('Ditto is not ready');
    }
    payments.add(payment);
  }

  @override
  Future<void> deletePayment(PersonalLoanPayment payment) async {}
}

class _Cats implements SmsCategoryStore {
  @override
  Future<String> create(String name, String branchId) async => 'cat-$name';

  @override
  String? lastUsed({required bool isIncome}) => null;

  @override
  Future<void> remember(String id, {required bool isIncome}) async {}
}

final _now = DateTime.now();

PersonalLoan _bk({DateTime? closedAt}) => PersonalLoan(
  id: 'loan-bk',
  businessId: 'biz',
  branchId: 'br',
  lender: 'BK',
  principal: 1200000,
  startDate: DateTime(_now.year, _now.month, 1),
  monthlyPayment: 100000,
  createdAt: DateTime(_now.year, _now.month, 1),
  closedAt: closedAt,
);

typedef _Movement = ({
  bool isIncome,
  double amount,
  String? categoryName,
  String? note,
});

/// A movement writer that records what it wrote; [fail] calls throw first,
/// and each call waits for [gate] when one is given.
PersonalMovementWriter _writer(
  List<_Movement> written, {
  int fail = 0,
  Completer<void>? gate,
}) {
  var failures = fail;
  return ({
    required isIncome,
    required amount,
    required paymentType,
    required categoryName,
    required categoryId,
    required note,
  }) async {
    await gate?.future;
    if (failures > 0) {
      failures--;
      throw StateError('offline');
    }
    written.add((
      isIncome: isIncome,
      amount: amount,
      categoryName: categoryName,
      note: note,
    ));
    return 'txn-${written.length}';
  };
}

/// A button that opens [open], like the screens that show these sheets.
Widget _launcher(void Function(BuildContext) open) => Scaffold(
  body: Builder(
    builder: (context) =>
        TextButton(onPressed: () => open(context), child: const Text('open')),
  ),
);

Future<void> _tapKey(WidgetTester tester, String key) async {
  await tester.ensureVisible(find.byKey(ValueKey(key)));
  await tester.pumpAndSettle();
  await tester.tap(find.byKey(ValueKey(key)));
}

List<Override> _overrides(
  _Store store, {
  List<PersonalLoan> loans = const [],
  Stream<List<PersonalLoan>>? loansStream,
  List<PersonalLoanPayment> payments = const [],
  PersonalMonthlyFlow flow = (income: 0, spending: 0),
}) => [
  branchServicesProvider.overrideWithValue(_Services()),
  personalLoansStoreProvider.overrideWithValue(store),
  personalLoansBusinessIdProvider.overrideWithValue('biz'),
  personalLoansProvider.overrideWith(
    (ref) => loansStream ?? Stream.value(loans),
  ),
  personalLoanPaymentsProvider.overrideWith((ref) => Stream.value(payments)),
  personalLast30DaysFlowProvider.overrideWith((ref) => Stream.value(flow)),
  categoryProvider.overrideWith((ref) => Stream.value(const <Category>[])),
  smsCategoryStoreProvider.overrideWithValue(_Cats()),
];

Widget _app(Widget child, List<Override> overrides) => ProviderScope(
  overrides: overrides,
  child: MaterialApp(
    locale: const Locale('en'),
    localizationsDelegates: FlipperAppLocalizations.localizationsDelegates,
    supportedLocales: FlipperAppLocalizations.supportedLocales,
    home: child,
  ),
);

void _size(WidgetTester tester, Size logical) {
  tester.view.physicalSize = logical * 2;
  tester.view.devicePixelRatio = 2;
  addTearDown(tester.view.reset);
}

void main() {
  setUpAll(() => GoogleFonts.config.allowRuntimeFetching = false);

  group('rules', () {
    test('a loan needs enough to give a balance', () {
      bool ok({
        double? amount,
        double? payment,
        int? term,
        DateTime? end,
        double? balance,
      }) => loanFormIsComplete(
        amount: amount,
        payment: payment,
        term: term,
        end: end,
        balanceToday: balance,
      );
      final end = DateTime(2027, 12);
      // "I pay 150k until Dec 2027" is enough.
      expect(ok(payment: 150000, end: end), isTrue);
      expect(ok(payment: 150000, balance: 900000), isTrue);
      expect(ok(amount: 1000000, term: 12), isTrue);
      expect(ok(amount: 1000000, payment: 90000), isTrue);
      expect(ok(payment: 150000), isFalse);
      expect(ok(end: end), isFalse);
      expect(ok(), isFalse);
    });

    test('loans are left out of monthly income and spending', () {
      PersonalMovement m(bool income, double amount, String? cat) =>
          PersonalMovement(
            id: '$income$amount$cat',
            isIncome: income,
            amount: amount,
            category: cat,
            account: PersonalMoneyAccount.cash,
            at: _now,
          );
      final flow = monthlyFlowWithoutLoans([
        m(true, 500000, 'Salary'),
        m(true, 2000000, kLoanReceivedCategory),
        m(false, 100000, 'Food'),
        m(false, 150000, kLoanRepaymentCategory),
      ]);
      expect(flow.income, 500000);
      expect(flow.spending, 100000);
    });
  });

  testWidgets('the loans screen sums what is owed and lists each loan', (
    tester,
  ) async {
    _size(tester, const Size(390, 1000));
    await tester.pumpWidget(
      _app(const LoansScreen(), _overrides(_Store(), loans: [_bk()])),
    );
    await tester.pumpAndSettle();
    expect(
      tester
          .widget<Text>(find.byKey(const ValueKey('personal-loans-owed')))
          .data,
      contains('1,200,000'),
    );
    expect(
      tester
          .widget<Text>(find.byKey(const ValueKey('personal-loans-monthly')))
          .data,
      contains('100,000'),
    );
    expect(find.byKey(const ValueKey('loan-tile-loan-bk')), findsOneWidget);
    expect(find.textContaining('12 months left'), findsOneWidget);
  });

  testWidgets('a loan with no repayment this month asks for one', (
    tester,
  ) async {
    _size(tester, const Size(390, 1200));
    await tester.pumpWidget(
      _app(
        const LoanDetailScreen(loanId: 'loan-bk'),
        _overrides(_Store(), loans: [_bk()]),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('No repayment recorded this month'), findsOneWidget);
    expect(find.byKey(const ValueKey('loan-detail-record')), findsOneWidget);
    expect(
      tester
          .widget<Text>(find.byKey(const ValueKey('loan-detail-months')))
          .data,
      '12 months left',
    );
  });

  testWidgets('"I know the details" saves amount, term and payment', (
    tester,
  ) async {
    _size(tester, const Size(390, 1400));
    final store = _Store();
    await tester.pumpWidget(
      _app(const Scaffold(body: LoanFormSheet()), _overrides(store)),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const ValueKey('loan-form-save')));
    await tester.pumpAndSettle();
    expect(store.saved, isEmpty, reason: 'no lender');

    await tester.enterText(
      find.byKey(const ValueKey('loan-form-lender')),
      'Umurenge SACCO',
    );
    await tester.enterText(
      find.byKey(const ValueKey('loan-form-amount')),
      '600000',
    );
    await tester.enterText(find.byKey(const ValueKey('loan-form-term')), '6');
    // A decimal comma in the rate is 16.5%, not 165%.
    await tester.enterText(
      find.byKey(const ValueKey('loan-form-rate')),
      '16,5',
    );
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('loan-form-preview')), findsOneWidget);
    await tester.ensureVisible(find.byKey(const ValueKey('loan-form-save')));
    await tester.tap(find.byKey(const ValueKey('loan-form-save')));
    await tester.pumpAndSettle();

    expect(store.saved, hasLength(1));
    final loan = store.saved.single;
    expect(loan.lender, 'Umurenge SACCO');
    expect(loan.principal, 600000);
    expect(loan.termMonths, 6);
    expect(loan.annualRatePct, 16.5);
    expect(loan.businessId, 'biz');
    expect(loan.startDate, isNotNull);
  });

  testWidgets('a repayment from the money-out form is linked to its loan', (
    tester,
  ) async {
    _size(tester, const Size(390, 1400));
    final store = _Store();
    final overrides = [
      ..._overrides(store, loans: [_bk()]),
      personalMovementWriterProvider.overrideWithValue(({
        required isIncome,
        required amount,
        required paymentType,
        required categoryName,
        required categoryId,
        required note,
      }) async {
        expect(categoryName, kLoanRepaymentCategory);
        return 'txn-42';
      }),
    ];
    await tester.pumpWidget(
      _app(
        const Scaffold(
          body: PersonalAddMoneySheet(
            initialCategoryName: kLoanRepaymentCategory,
            initialAmount: 100000,
          ),
        ),
        overrides,
      ),
    );
    await tester.pumpAndSettle();
    // One open loan: picked without a tap.
    final chip = tester.widget<ChoiceChip>(
      find.byKey(const ValueKey('loan-pick-loan-bk')),
    );
    expect(chip.selected, isTrue);

    await tester.ensureVisible(find.byKey(const ValueKey('personal-add-save')));
    await tester.tap(find.byKey(const ValueKey('personal-add-save')));
    await tester.pumpAndSettle();

    expect(store.payments, hasLength(1));
    final p = store.payments.single;
    expect(p.loanId, 'loan-bk');
    expect(p.amount, 100000);
    expect(p.transactionId, 'txn-42');
    expect(p.source, 'form');
  });

  testWidgets('what-if shows the new payment and judges it against income', (
    tester,
  ) async {
    _size(tester, const Size(390, 1400));
    await tester.pumpWidget(
      _app(
        const LoanAffordabilityScreen(),
        _overrides(
          _Store(),
          loans: [_bk()],
          flow: (income: 1000000, spending: 400000),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const ValueKey('what-if-amount')),
      '1200000',
    );
    await tester.enterText(find.byKey(const ValueKey('what-if-rate')), '0');
    await tester.pumpAndSettle();
    // 1.2M over 12 months at 0% is 100k; with BK's 100k: 20% of income.
    expect(
      tester
          .widget<Text>(find.byKey(const ValueKey('what-if-installment')))
          .data,
      contains('100,000'),
    );
    expect(
      tester.widget<Text>(find.byKey(const ValueKey('what-if-left'))).data,
      contains('400,000'),
    );
    expect(
      find.byKey(const ValueKey('what-if-verdict-comfortable')),
      findsOneWidget,
    );

    // Thousands commas read as thousands, a rate comma as a decimal.
    await tester.enterText(
      find.byKey(const ValueKey('what-if-amount')),
      '1,200,000',
    );
    await tester.enterText(find.byKey(const ValueKey('what-if-rate')), '0,0');
    await tester.pumpAndSettle();
    expect(
      tester
          .widget<Text>(find.byKey(const ValueKey('what-if-installment')))
          .data,
      contains('100,000'),
    );
  });

  testWidgets('a failed clear or delete says so and keeps the loan', (
    tester,
  ) async {
    _size(tester, const Size(390, 1200));
    final store = _Store()..failLoans = true;
    await tester.pumpWidget(
      _app(
        const LoanDetailScreen(loanId: 'loan-bk'),
        _overrides(store, loans: [_bk()]),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byType(PopupMenuButton<String>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Mark as cleared'));
    await tester.pumpAndSettle();
    expect(find.text('Could not save. Try again.'), findsOneWidget);

    await tester.tap(find.byType(PopupMenuButton<String>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Delete loan'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(TextButton, 'Delete loan'));
    await tester.pumpAndSettle();
    expect(store.deleted, isEmpty);
    expect(find.byKey(const ValueKey('personal-loan-detail')), findsOneWidget);
  });

  testWidgets('deleting a loan closes its screen', (tester) async {
    _size(tester, const Size(390, 1200));
    final store = _Store();
    await tester.pumpWidget(
      _app(
        _launcher(
          (context) => Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) => const LoanDetailScreen(loanId: 'loan-bk'),
            ),
          ),
        ),
        _overrides(store, loans: [_bk()]),
      ),
    );
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    // Cancelling the confirmation deletes nothing.
    await tester.tap(find.byType(PopupMenuButton<String>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Delete loan'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(TextButton, 'Cancel'));
    await tester.pumpAndSettle();
    expect(store.deleted, isEmpty);

    await tester.tap(find.byType(PopupMenuButton<String>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Delete loan'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(TextButton, 'Delete loan'));
    await tester.pumpAndSettle();
    expect(store.deleted.single.id, 'loan-bk');
    expect(find.byKey(const ValueKey('personal-loan-detail')), findsNothing);
  });

  testWidgets('an end date before last year still opens the picker', (
    tester,
  ) async {
    _size(tester, const Size(390, 1400));
    final old = PersonalLoan(
      id: 'loan-old',
      businessId: 'biz',
      branchId: 'br',
      lender: 'SACCO',
      monthlyPayment: 50000,
      endDate: DateTime(2015, 6),
      createdAt: DateTime(2014, 1),
    );
    await tester.pumpWidget(
      _app(Scaffold(body: LoanFormSheet(loan: old)), _overrides(_Store())),
    );
    await tester.pumpAndSettle();
    await _tapKey(tester, 'loan-form-end');
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(find.byType(DatePickerDialog), findsOneWidget);
  });

  Future<void> fillReceivedLoan(WidgetTester tester) async {
    await tester.enterText(
      find.byKey(const ValueKey('loan-form-lender')),
      'Umurenge SACCO',
    );
    await tester.enterText(
      find.byKey(const ValueKey('loan-form-amount')),
      '600,000',
    );
    await tester.enterText(find.byKey(const ValueKey('loan-form-term')), '6');
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.byType(CheckboxListTile));
    await tester.tap(find.byType(CheckboxListTile));
    await tester.pumpAndSettle();
  }

  testWidgets('a retried save after "loan received" failed keeps one loan', (
    tester,
  ) async {
    _size(tester, const Size(390, 1400));
    final store = _Store();
    final written = <_Movement>[];
    await tester.pumpWidget(
      _app(const Scaffold(body: LoanFormSheet()), [
        ..._overrides(store),
        personalMovementWriterProvider.overrideWithValue(
          _writer(written, fail: 1),
        ),
      ]),
    );
    await tester.pumpAndSettle();
    await fillReceivedLoan(tester);

    await _tapKey(tester, 'loan-form-save');
    await tester.pumpAndSettle();
    expect(find.text('Could not save. Try again.'), findsOneWidget);
    expect(written, isEmpty);

    await _tapKey(tester, 'loan-form-save');
    await tester.pumpAndSettle();
    expect(store.saved, hasLength(2));
    expect(store.saved.map((l) => l.id).toSet(), hasLength(1));
    expect(written, hasLength(1));
    expect(written.single.isIncome, isTrue);
    expect(written.single.amount, 600000);
  });

  testWidgets('the money received is recorded even if the sheet closes', (
    tester,
  ) async {
    _size(tester, const Size(390, 1400));
    final store = _Store()..saveGate = Completer<void>();
    final written = <_Movement>[];
    await tester.pumpWidget(
      _app(_launcher((context) => showLoanFormSheet(context)), [
        ..._overrides(store),
        personalMovementWriterProvider.overrideWithValue(_writer(written)),
      ]),
    );
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    await fillReceivedLoan(tester);
    await _tapKey(tester, 'loan-form-save');
    await tester.pump();

    Navigator.of(tester.element(find.byType(LoanFormSheet))).pop();
    await tester.pumpAndSettle();
    expect(find.byType(LoanFormSheet), findsNothing);

    store.saveGate!.complete();
    await tester.pumpAndSettle();
    expect(store.saved, hasLength(1));
    expect(written, hasLength(1));
    expect(written.single.categoryName, kLoanReceivedCategory);
    expect(written.single.note, 'Umurenge SACCO');
    expect(written.single.amount, 600000);
  });

  Widget repaymentSheet() => const Scaffold(
    body: PersonalAddMoneySheet(
      initialCategoryName: kLoanRepaymentCategory,
      initialAmount: 100000,
    ),
  );

  testWidgets('a repayment waits for the loans before it can be saved', (
    tester,
  ) async {
    _size(tester, const Size(390, 1400));
    final loans = StreamController<List<PersonalLoan>>();
    await tester.pumpWidget(
      _app(repaymentSheet(), _overrides(_Store(), loansStream: loans.stream)),
    );
    await tester.pump();
    expect(find.byKey(const ValueKey('loan-pick-loading')), findsOneWidget);
    FilledButton save() => tester.widget<FilledButton>(
      find.byKey(const ValueKey('personal-add-save')),
    );
    expect(save().onPressed, isNull);

    loans.add([_bk()]);
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('loan-pick-loading')), findsNothing);
    expect(save().onPressed, isNotNull);
  });

  testWidgets('a deselected sole loan stays deselected', (tester) async {
    _size(tester, const Size(390, 1400));
    final store = _Store();
    final written = <_Movement>[];
    await tester.pumpWidget(
      _app(repaymentSheet(), [
        ..._overrides(store, loans: [_bk()]),
        personalMovementWriterProvider.overrideWithValue(_writer(written)),
      ]),
    );
    await tester.pumpAndSettle();
    ChoiceChip chip() => tester.widget<ChoiceChip>(
      find.byKey(const ValueKey('loan-pick-loan-bk')),
    );
    expect(chip().selected, isTrue);

    await tester.tap(find.byKey(const ValueKey('loan-pick-loan-bk')));
    await tester.pumpAndSettle();
    await tester.pump();
    expect(chip().selected, isFalse);

    await _tapKey(tester, 'personal-add-save');
    await tester.pumpAndSettle();
    expect(written, hasLength(1));
    expect(store.payments, isEmpty);
  });

  testWidgets('a retried repayment reuses the Cash Out already written', (
    tester,
  ) async {
    _size(tester, const Size(390, 1400));
    final store = _Store()..failPayments = 1;
    final written = <_Movement>[];
    await tester.pumpWidget(
      _app(repaymentSheet(), [
        ..._overrides(store, loans: [_bk()]),
        personalMovementWriterProvider.overrideWithValue(_writer(written)),
      ]),
    );
    await tester.pumpAndSettle();

    await _tapKey(tester, 'personal-add-save');
    await tester.pumpAndSettle();
    expect(find.text('Could not save. Try again.'), findsOneWidget);
    expect(written, hasLength(1));
    expect(store.payments, isEmpty);

    await _tapKey(tester, 'personal-add-save');
    await tester.pumpAndSettle();
    expect(written, hasLength(1), reason: 'no second Cash Out');
    final p = store.payments.single;
    expect(p.transactionId, 'txn-1');
    expect(p.id, loanPaymentIdFor('txn-1'));
    expect(p.amount, 100000);
  });

  testWidgets('a repayment is linked even if the sheet closes mid-save', (
    tester,
  ) async {
    _size(tester, const Size(390, 1400));
    final store = _Store();
    final written = <_Movement>[];
    final gate = Completer<void>();
    await tester.pumpWidget(
      _app(
        _launcher(
          (context) => showPersonalAddMoneySheet(
            context,
            categoryName: kLoanRepaymentCategory,
            amount: 100000,
            loanId: 'loan-bk',
          ),
        ),
        [
          ..._overrides(store, loans: [_bk()]),
          personalMovementWriterProvider.overrideWithValue(
            _writer(written, gate: gate),
          ),
        ],
      ),
    );
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    await _tapKey(tester, 'personal-add-save');
    await tester.pump();

    Navigator.of(tester.element(find.byType(PersonalAddMoneySheet))).pop();
    await tester.pumpAndSettle();
    expect(find.byType(PersonalAddMoneySheet), findsNothing);

    gate.complete();
    await tester.pumpAndSettle();
    expect(written, hasLength(1));
    expect(store.payments.single.loanId, 'loan-bk');
    expect(store.payments.single.transactionId, 'txn-1');
  });

  testWidgets('a repayment without a business is not written', (tester) async {
    final store = _Store();
    LoanRepaymentWriter? write;
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          personalLoansStoreProvider.overrideWithValue(store),
          personalLoansBusinessIdProvider.overrideWithValue(null),
        ],
        child: Consumer(
          builder: (context, ref, _) {
            write ??= loanRepaymentWriter(ref);
            return const SizedBox();
          },
        ),
      ),
    );
    await write!(
      loanId: 'loan-bk',
      amount: 100000,
      paidAt: _now,
      transactionId: 'txn-1',
      source: 'form',
    );
    expect(store.payments, isEmpty);
  });
}
