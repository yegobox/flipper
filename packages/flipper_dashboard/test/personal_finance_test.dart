import 'package:flipper_dashboard/customappbar.dart';
import 'package:flipper_dashboard/features/admin/mobile/settings_list.dart'
    show SettingsSubpage;
import 'package:flipper_dashboard/features/branch_location/branch_services.dart';
import 'package:flipper_dashboard/features/personal_finance/personal_add_money_sheet.dart';
import 'package:flipper_dashboard/features/personal_finance/personal_finance_data.dart';
import 'package:flipper_dashboard/features/personal_finance/personal_finance_providers.dart';
import 'package:flipper_dashboard/features/personal_finance/personal_home.dart';
import 'package:flipper_dashboard/features/personal_finance/personal_shell.dart';
import 'package:flipper_dashboard/widgets/sms_review/sms_review_categories.dart';
import 'package:flipper_dashboard/widgets/sms_review/sms_review_section.dart'
    show smsReviewBranchIdProvider;
import 'package:flipper_dashboard/widgets/dashboard_app_access.dart'
    show dashboardIsAdminProvider;
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_models/db_model_export.dart'
    show Category, ITransaction;
import 'package:flipper_models/providers/category_provider.dart';
import 'package:flipper_models/sms_review/sms_review_item.dart';
import 'package:flipper_models/sms_review/sms_review_providers.dart';
import 'package:flipper_services/payment_methods.dart';
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

ITransaction _txn({
  required String id,
  String? receiptType,
  String transactionType = 'Cash Out',
  bool isExpense = true,
  double subTotal = 1000,
  String paymentType = 'CASH',
  DateTime? at,
  String? note,
}) => ITransaction(
  id: id,
  branchId: 'br',
  status: 'completed',
  transactionType: transactionType,
  paymentType: paymentType,
  cashReceived: subTotal,
  customerChangeDue: 0,
  updatedAt: DateTime(2026, 10, 1),
  isIncome: !isExpense,
  isExpense: isExpense,
  agentId: 'a',
  subTotal: subTotal,
  receiptType: receiptType,
  createdAt: at ?? DateTime(2026, 10, 5, 9, 30),
  note: note,
);

PersonalMovement _m(
  String id, {
  bool income = false,
  double amount = 1000,
  String? category,
  PersonalMoneyAccount account = PersonalMoneyAccount.cash,
  DateTime? at,
}) => PersonalMovement(
  id: id,
  isIncome: income,
  amount: amount,
  category: category,
  account: account,
  at: at ?? DateTime(2026, 10, 5),
);

Widget _app(Widget child, List<Override> overrides) => ProviderScope(
  overrides: overrides,
  child: MaterialApp(
    locale: const Locale('en'),
    localizationsDelegates: FlipperAppLocalizations.localizationsDelegates,
    supportedLocales: FlipperAppLocalizations.supportedLocales,
    home: child,
  ),
);

SmsReviewItem _pendingSms() => SmsReviewItem.fromDitto({
  '_id': 'sms-1',
  'businessId': 'biz',
  'branchId': 'br',
  'kind': 'principal',
  'direction': 'credit',
  'amount': 5000,
  'description': 'MoMo · from Jane',
  'providerLabel': 'MTN',
  'paymentType': 'MOBILE MONEY',
  'bankAccountCode': '1030',
  'lineDate': '2026-10-22',
  'status': 'pending_review',
});

List<Override> _overrides(
  PersonalMonthSummary summary, {
  List<SmsReviewItem> sms = const [],
  Stream<List<SmsReviewItem>>? smsStream,
}) => [
  branchServicesProvider.overrideWithValue(_Services()),
  personalMonthSummaryProvider.overrideWith((ref) => Stream.value(summary)),
  smsReviewBranchIdProvider.overrideWithValue('br'),
  smsReviewItemsProvider(
    'br',
  ).overrideWith((ref) => smsStream ?? Stream.value(sms)),
  dashboardIsAdminProvider.overrideWithValue(true),
  categoryProvider.overrideWith((ref) => Stream.value(const <Category>[])),
];

void _size(WidgetTester tester, Size logical) {
  tester.view.physicalSize = logical * 2;
  tester.view.devicePixelRatio = 2;
  addTearDown(tester.view.reset);
}

void main() {
  // CustomAppBar's title font: never fetch it over the network in tests.
  setUpAll(() => GoogleFonts.config.allowRuntimeFetching = false);

  group('personalMovementFrom', () {
    test('Cash Out and Cash In by receipt type, category from the record', () {
      final out = personalMovementFrom(
        _txn(id: 'o', receiptType: 'Cash Out', transactionType: 'Transport'),
      )!;
      expect(out.isIncome, isFalse);
      expect(out.category, 'Transport');
      expect(out.amount, 1000);

      final income = personalMovementFrom(
        _txn(
          id: 'i',
          receiptType: 'Cash In',
          transactionType: 'Salary',
          isExpense: false,
          paymentType: 'BANK TRANSFER',
        ),
      )!;
      expect(income.isIncome, isTrue);
      expect(income.account, PersonalMoneyAccount.bank);
    });

    test('rows saved before receipt types use the movement name', () {
      final legacy = personalMovementFrom(
        _txn(id: 'l', receiptType: 'NS', transactionType: 'Cash Out'),
      )!;
      expect(legacy.isIncome, isFalse);
      expect(legacy.category, isNull);
    });

    test('sales, refunds, purchase mirrors and empty rows are not money', () {
      expect(
        personalMovementFrom(
          _txn(
            id: 's',
            receiptType: 'NS',
            transactionType: 'Sale',
            isExpense: false,
          ),
        ),
        isNull,
      );
      expect(personalMovementFrom(_txn(id: 'r', receiptType: 'NR')), isNull);
      expect(
        personalMovementFrom(
          _txn(id: 'purchase_exp_1', receiptType: 'Cash Out'),
        ),
        isNull,
      );
      expect(
        personalMovementFrom(
          _txn(id: 'z', receiptType: 'Cash Out', subTotal: 0),
        ),
        isNull,
      );
    });

    test('mobile money in any spelling is the mobile money account', () {
      for (final p in [kMobileMoney, 'MTN MOMO', kAirtelMoney]) {
        expect(personalAccountFor(p), PersonalMoneyAccount.mobileMoney);
      }
      expect(personalAccountFor('CASH'), PersonalMoneyAccount.cash);
      expect(personalAccountFor(null), PersonalMoneyAccount.cash);
    });
  });

  group('summarizePersonalMonth', () {
    test('totals, categories biggest first, net per account, newest first', () {
      final s = summarizePersonalMonth([
        _m('a', amount: 3000, category: 'Transport', at: DateTime(2026, 10, 2)),
        _m('b', amount: 4000, category: 'Food', at: DateTime(2026, 10, 3)),
        _m('c', amount: 2000, category: 'Transport', at: DateTime(2026, 10, 4)),
        _m(
          'd',
          income: true,
          amount: 20000,
          category: 'Salary',
          account: PersonalMoneyAccount.bank,
          at: DateTime(2026, 10, 1),
        ),
        // The same row twice (two streams can both carry it): once.
        _m('a', amount: 3000, category: 'Transport', at: DateTime(2026, 10, 2)),
      ]);
      expect(s.income, 20000);
      expect(s.spent, 9000);
      expect(s.leftOver, 11000);
      expect(s.spentByCategory.map((c) => c.category), ['Transport', 'Food']);
      expect(s.spentByCategory.first.amount, 5000);
      expect(s.netByAccount[PersonalMoneyAccount.cash], -9000);
      expect(s.netByAccount[PersonalMoneyAccount.bank], 20000);
      expect(s.movements.map((m) => m.id), ['c', 'b', 'a', 'd']);
    });

    test('nothing recorded is empty', () {
      expect(summarizePersonalMonth(const []).isEmpty, isTrue);
    });

    test('month bounds cover the whole month', () {
      final m = DateTime(2026, 2, 17);
      expect(personalMonthStart(m), DateTime(2026, 2));
      expect(personalMonthEnd(m).day, 28);
      expect(personalMonthEnd(m).isBefore(DateTime(2026, 3)), isTrue);
    });
  });

  group('SMS review categories', () {
    test('business keeps its own suggestions', () {
      final business = smsCategoryChoices(isIncome: false, branch: const []);
      expect(business.suggested.map((c) => c.name), kSmsExpenseCategories);
      final income = smsCategoryChoices(isIncome: true, branch: const []);
      expect(income.suggested.map((c) => c.name), kSmsIncomeCategories);
    });

    test('personal suggests personal money categories', () {
      final out = smsCategoryChoices(
        isIncome: false,
        branch: const [],
        personal: true,
      );
      expect(out.suggested.map((c) => c.name), kPersonalExpenseCategories);
      final income = smsCategoryChoices(
        isIncome: true,
        branch: const [],
        personal: true,
      );
      expect(income.suggested.map((c) => c.name), kPersonalIncomeCategories);
    });
  });

  group('PersonalShell', () {
    testWidgets('phones get a bottom bar, the month totals and no POS', (
      tester,
    ) async {
      _size(tester, const Size(390, 844));
      final summary = summarizePersonalMonth([
        _m('a', amount: 3000, category: 'Transport'),
        _m('b', income: true, amount: 10000, category: 'Salary'),
      ]);
      await tester.pumpWidget(
        _app(
          PersonalShell(floBuilder: (_) => const Text('flo')),
          _overrides(summary),
        ),
      );
      await tester.pumpAndSettle();

      expect(
        find.byKey(const ValueKey('personal-shell-phone')),
        findsOneWidget,
      );
      expect(find.byType(NavigationBar), findsOneWidget);
      expect(find.text('My money'), findsOneWidget);
      expect(find.text('Where your money went'), findsOneWidget);
      expect(find.textContaining('Transport'), findsWidgets);
      // Nothing from the shop.
      expect(find.textContaining('New sale'), findsNothing);
      expect(find.textContaining('Stock'), findsNothing);
    });

    testWidgets('desktop gets a side rail', (tester) async {
      _size(tester, const Size(1280, 800));
      await tester.pumpWidget(
        _app(
          PersonalShell(floBuilder: (_) => const Text('flo')),
          _overrides(PersonalMonthSummary.empty),
        ),
      );
      await tester.pumpAndSettle();
      expect(
        find.byKey(const ValueKey('personal-shell-desktop')),
        findsOneWidget,
      );
      expect(find.byType(NavigationRail), findsOneWidget);
      // Empty month: the way in is the + button or the SMS Bridge.
      expect(find.text('Nothing recorded yet'), findsOneWidget);
      expect(find.text('Pair SMS Bridge'), findsOneWidget);
    });

    testWidgets('Flo is built only once opened', (tester) async {
      _size(tester, const Size(390, 844));
      await tester.pumpWidget(
        _app(
          PersonalShell(floBuilder: (_) => const Text('flo-screen')),
          _overrides(PersonalMonthSummary.empty),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('flo-screen'), findsNothing);
      await tester.tap(find.text('Flo'));
      await tester.pumpAndSettle();
      expect(find.text('flo-screen'), findsOneWidget);
      // No + button over the chat.
      expect(find.byKey(const ValueKey('personal-add-money')), findsNothing);
    });

    testWidgets('More offers SMS Bridge, goals and going back to business', (
      tester,
    ) async {
      _size(tester, const Size(390, 844));
      await tester.pumpWidget(
        _app(
          PersonalShell(floBuilder: (_) => const SizedBox()),
          _overrides(PersonalMonthSummary.empty),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('More'));
      await tester.pumpAndSettle();
      expect(find.text('SMS Bridge'), findsOneWidget);
      expect(find.text('Savings goals'), findsOneWidget);
      expect(
        find.byKey(const ValueKey('personal-switch-to-business')),
        findsOneWidget,
      );
    });
  });

  group('Month summary card', () {
    Text valueOf(WidgetTester tester, String key) =>
        tester.widget<Text>(find.byKey(ValueKey(key)));

    testWidgets('an overspent month fits a small phone and says so', (
      tester,
    ) async {
      _size(tester, const Size(360, 780));
      final summary = summarizePersonalMonth([
        _m('a', amount: 141860, category: 'Transport'),
        _m('b', income: true, amount: 15000, category: 'Salary'),
      ]);
      await tester.pumpWidget(_app(const PersonalHome(), _overrides(summary)));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text('Overspent'), findsOneWidget);
      expect(find.text('Left over'), findsNothing);
      // The label carries the sign, so the figure has none.
      expect(valueOf(tester, 'personal-left-over').data, 'RWF 126,860');
      expect(valueOf(tester, 'personal-income').data, 'RWF 15,000');
      expect(valueOf(tester, 'personal-spent').data, 'RWF 141,860');

      // Each figure keeps to its own space: none overlaps another.
      final rects = [
        for (final k in [
          'personal-left-over',
          'personal-income',
          'personal-spent',
        ])
          tester.getRect(find.byKey(ValueKey(k))),
      ];
      for (var i = 0; i < rects.length; i++) {
        for (var j = i + 1; j < rects.length; j++) {
          expect(rects[i].overlaps(rects[j]), isFalse, reason: '$i vs $j');
        }
      }
      // Money in sits left of money out, on the same line.
      expect(rects[1].right, lessThan(rects[2].left));
    });

    testWidgets('a month with money left says Left over', (tester) async {
      _size(tester, const Size(390, 844));
      final summary = summarizePersonalMonth([
        _m('a', amount: 3000, category: 'Transport'),
        _m('b', income: true, amount: 10000, category: 'Salary'),
      ]);
      await tester.pumpWidget(_app(const PersonalHome(), _overrides(summary)));
      await tester.pumpAndSettle();
      expect(find.text('Left over'), findsOneWidget);
      expect(find.text('Overspent'), findsNothing);
      expect(valueOf(tester, 'personal-left-over').data, 'RWF 7,000');
    });

    testWidgets('huge amounts shrink to fit instead of overflowing', (
      tester,
    ) async {
      _size(tester, const Size(320, 700));
      final summary = summarizePersonalMonth([
        _m('a', amount: 98765432109, category: 'Transport'),
        _m('b', income: true, amount: 12345678901, category: 'Salary'),
      ]);
      await tester.pumpWidget(_app(const PersonalHome(), _overrides(summary)));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      final card = tester.getRect(find.byKey(const ValueKey('personal-home')));
      for (final k in [
        'personal-left-over',
        'personal-income',
        'personal-spent',
      ]) {
        final r = tester.getRect(find.byKey(ValueKey(k)));
        expect(r.left, greaterThanOrEqualTo(card.left));
        expect(r.right, lessThanOrEqualTo(card.right));
      }
    });
  });

  group('Shared header', () {
    testWidgets('the shell wears CustomAppBar, with no back button on a tab', (
      tester,
    ) async {
      _size(tester, const Size(390, 844));
      await tester.pumpWidget(
        _app(
          PersonalShell(floBuilder: (_) => const SizedBox()),
          _overrides(PersonalMonthSummary.empty),
        ),
      );
      await tester.pumpAndSettle();
      final bar = find.byKey(const ValueKey('personal-app-bar'));
      expect(bar, findsOneWidget);
      expect(tester.widget(bar), isA<CustomAppBar>());
      expect(find.byType(AppBar), findsNothing);
      expect(
        find.descendant(of: bar, matching: find.byType(AppBarRoundIconButton)),
        findsNothing,
      );
      expect(
        find.descendant(of: bar, matching: find.text('My money')),
        findsOneWidget,
      );

      // The title follows the tab.
      await tester.tap(find.text('More'));
      await tester.pumpAndSettle();
      expect(
        find.descendant(of: bar, matching: find.text('More')),
        findsOneWidget,
      );

      // Flo draws its own header.
      await tester.tap(find.text('Flo'));
      await tester.pumpAndSettle();
      expect(bar, findsNothing);
    });

    testWidgets('a pushed settings page has the round back button', (
      tester,
    ) async {
      _size(tester, const Size(390, 844));
      await tester.pumpWidget(
        _app(
          Builder(
            builder: (context) => Scaffold(
              body: TextButton(
                onPressed: () => SettingsSubpage.push(
                  context,
                  title: 'Language',
                  child: const Text('page body'),
                ),
                child: const Text('open'),
              ),
            ),
          ),
          _overrides(PersonalMonthSummary.empty),
        ),
      );
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();
      expect(find.byType(CustomAppBar), findsOneWidget);
      expect(find.byType(AppBar), findsNothing);
      expect(find.text('Language'), findsOneWidget);
      await tester.tap(find.byType(AppBarRoundIconButton));
      await tester.pumpAndSettle();
      expect(find.text('page body'), findsNothing);
      expect(find.text('open'), findsOneWidget);
    });

    testWidgets('a settings page with nowhere to go back to has no button', (
      tester,
    ) async {
      _size(tester, const Size(390, 844));
      await tester.pumpWidget(
        _app(
          const SettingsSubpage(title: 'Language', child: Text('page body')),
          _overrides(PersonalMonthSummary.empty),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(CustomAppBar), findsOneWidget);
      expect(find.byType(AppBarRoundIconButton), findsNothing);
    });
  });

  group('PersonalShell back and SMS review', () {
    testWidgets('back on another tab goes Home, on Home it stays', (
      tester,
    ) async {
      _size(tester, const Size(390, 844));
      await tester.pumpWidget(
        _app(
          PersonalShell(floBuilder: (_) => const SizedBox()),
          _overrides(PersonalMonthSummary.empty),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('More'));
      await tester.pumpAndSettle();
      expect(find.byKey(const ValueKey('personal-more')), findsOneWidget);

      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();
      expect(find.text('My money'), findsOneWidget);

      // On Home, back is swallowed: the shell is still there.
      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();
      expect(find.byType(PersonalShell), findsOneWidget);
      expect(find.text('My money'), findsOneWidget);
    });

    testWidgets('an empty queue still says so on Home', (tester) async {
      _size(tester, const Size(390, 844));
      await tester.pumpWidget(
        _app(
          PersonalShell(floBuilder: (_) => const SizedBox()),
          _overrides(PersonalMonthSummary.empty),
        ),
      );
      await tester.pumpAndSettle();
      expect(
        find.byKey(const ValueKey('personal-nothing-to-review')),
        findsOneWidget,
      );
      expect(find.byKey(const Key('sms_review_count_badge')), findsNothing);
    });

    testWidgets('a queue still loading or failed is not called empty', (
      tester,
    ) async {
      _size(tester, const Size(390, 844));
      for (final queue in <Stream<List<SmsReviewItem>>>[
        const Stream.empty(),
        Stream.error(StateError('ditto down')),
      ]) {
        // A fresh scope: overrides can't change on a mounted ProviderScope.
        await tester.pumpWidget(const SizedBox());
        await tester.pumpWidget(
          _app(
            PersonalShell(floBuilder: (_) => const SizedBox()),
            _overrides(PersonalMonthSummary.empty, smsStream: queue),
          ),
        );
        await tester.pumpAndSettle();
        expect(find.text('My money'), findsOneWidget);
        expect(
          find.byKey(const ValueKey('personal-nothing-to-review')),
          findsNothing,
        );
      }
    });

    testWidgets('waiting SMS show on Home, the badge and More', (tester) async {
      _size(tester, const Size(390, 844));
      await tester.pumpWidget(
        _app(
          PersonalShell(floBuilder: (_) => const SizedBox()),
          _overrides(PersonalMonthSummary.empty, sms: [_pendingSms()]),
        ),
      );
      await tester.pumpAndSettle();
      expect(
        find.byKey(const ValueKey('personal-nothing-to-review')),
        findsNothing,
      );
      expect(find.byKey(const Key('sms_review_count_badge')), findsWidgets);

      await tester.tap(find.text('More'));
      await tester.pumpAndSettle();
      final row = find.byKey(const ValueKey('personal-sms-to-review'));
      expect(row, findsOneWidget);
      expect(
        find.descendant(of: row, matching: find.text('1')),
        findsOneWidget,
      );
    });
  });

  group('PersonalAddMoneySheet', () {
    testWidgets('records money out with the picked category and account', (
      tester,
    ) async {
      _size(tester, const Size(390, 1400));
      final written = <Map<String, Object?>>[];
      final overrides = [
        ..._overrides(PersonalMonthSummary.empty),
        smsCategoryStoreProvider.overrideWithValue(_Cats()),
        personalMovementWriterProvider.overrideWithValue(({
          required isIncome,
          required amount,
          required paymentType,
          required categoryName,
          required categoryId,
          required note,
        }) async {
          written.add({
            'isIncome': isIncome,
            'amount': amount,
            'paymentType': paymentType,
            'categoryName': categoryName,
            'categoryId': categoryId,
            'note': note,
          });
          return 'txn-1';
        }),
      ];
      await tester.pumpWidget(
        _app(const Scaffold(body: PersonalAddMoneySheet()), overrides),
      );
      await tester.pumpAndSettle();

      // No amount: an error, nothing written.
      await tester.tap(find.byKey(const ValueKey('personal-add-save')));
      await tester.pumpAndSettle();
      expect(find.text('Enter an amount'), findsOneWidget);
      expect(written, isEmpty);

      await tester.enterText(
        find.byKey(const ValueKey('personal-add-amount')),
        '2,500',
      );
      await tester.tap(find.text('Transport'));
      await tester.tap(find.text('MTN MoMo'));
      await tester.pump();
      await tester.tap(find.byKey(const ValueKey('personal-add-save')));
      await tester.pumpAndSettle();

      expect(written, hasLength(1));
      expect(written.single['isIncome'], false);
      expect(written.single['amount'], 2500);
      expect(written.single['paymentType'], kMobileMoney);
      expect(written.single['categoryName'], 'Transport');
      // A suggestion is created as a branch category first.
      expect(written.single['categoryId'], 'new-Transport');
    });
  });

  testWidgets('the month bar never goes past this month', (tester) async {
    await tester.pumpWidget(
      _app(
        const Scaffold(body: PersonalMonthBar()),
        _overrides(PersonalMonthSummary.empty),
      ),
    );
    await tester.pumpAndSettle();
    IconButton next() => tester.widget<IconButton>(
      find.ancestor(
        of: find.byIcon(Icons.chevron_right_rounded),
        matching: find.byType(IconButton),
      ),
    );
    expect(next().onPressed, isNull);
    await tester.tap(find.byIcon(Icons.chevron_left_rounded));
    await tester.pumpAndSettle();
    expect(next().onPressed, isNotNull);
  });
}

class _Cats implements SmsCategoryStore {
  @override
  Future<String> create(String name, String branchId) async => 'new-$name';

  @override
  String? lastUsed({required bool isIncome}) => null;

  @override
  Future<void> remember(String id, {required bool isIncome}) async {}
}
