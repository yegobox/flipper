import 'dart:async';

import 'package:flipper_dashboard/features/admin/widgets/sms_bridge_page.dart';
import 'package:flipper_dashboard/widgets/cashbook_new_category_sheet.dart';
import 'package:flipper_dashboard/widgets/sms_review/sms_review_categories.dart';
import 'package:flipper_dashboard/widgets/sms_review/sms_review_section.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_models/account_mode/account_mode.dart';
import 'package:flipper_models/account_mode/account_mode_providers.dart';
import 'package:flipper_models/db_model_export.dart'
    show Category, ITransaction;
import 'package:flipper_models/personal_loans/personal_loan.dart';
import 'package:flipper_models/personal_loans/personal_loans_store.dart';
import 'package:flipper_models/providers/category_provider.dart';
import 'package:flipper_models/providers/transactions_provider.dart'
    show cashbookRecentTransactionsProvider;
import 'package:flipper_models/sms_bridge_client.dart';
import 'package:flipper_models/sms_review/sms_debt_match.dart';
import 'package:flipper_models/sms_review/sms_review_item.dart';
import 'package:flipper_models/sms_review/sms_review_providers.dart';
import 'package:flipper_models/sms_review/sms_review_service.dart';
import 'package:flipper_models/sms_review/sms_sale_match.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class _Store implements SmsReviewStore {
  final statuses = <String, String>{};
  final matched = <String, String?>{};

  @override
  Future<bool> claim(String id) async {
    if (statuses[id] != null) return false;
    statuses[id] = SmsReviewItem.confirming;
    return true;
  }

  @override
  Future<void> setStatus(
    String id,
    String status, {
    Map<String, Object?> extra = const {},
  }) async => statuses[id] = status;

  @override
  Future<void> matchBankLine(String bankLineId, String? journalEntryId) async =>
      matched[bankLineId] = journalEntryId;
}

class _Cats implements SmsCategoryStore {
  final created = <String>[];
  final remembered = <(String, bool)>[];
  String? last;

  @override
  Future<String> create(String name, String branchId) async {
    created.add(name);
    return 'new-$name';
  }

  @override
  String? lastUsed({required bool isIncome}) => last;

  @override
  Future<void> remember(String id, {required bool isIncome}) async =>
      remembered.add((id, isIncome));
}

class _Loans implements PersonalLoansStore {
  final payments = <PersonalLoanPayment>[];

  /// How many payment writes throw before they succeed.
  int fail = 0;

  @override
  Future<void> addPayment(PersonalLoanPayment payment) async {
    if (fail > 0) {
      fail--;
      throw StateError('Ditto is not ready');
    }
    payments.add(payment);
  }

  @override
  Future<void> saveLoan(PersonalLoan loan) async {}

  @override
  Future<void> deleteLoan(PersonalLoan loan) async {}

  @override
  Future<void> deletePayment(PersonalLoanPayment payment) async {}
}

/// A personal account with one open loan.
List<Override> _personalLoanOverrides(_Loans loans) => [
  accountModeProvider.overrideWith(
    (ref, id) => Stream.value((mode: AccountMode.personal, fromServer: true)),
  ),
  personalLoansStoreProvider.overrideWithValue(loans),
  personalLoansBusinessIdProvider.overrideWithValue('biz'),
  personalLoansProvider.overrideWith(
    (ref) => Stream.value([
      PersonalLoan(
        id: 'loan-bk',
        businessId: 'biz',
        branchId: 'br',
        lender: 'BK',
        monthlyPayment: 2000,
        balance: 20000,
        balanceAt: DateTime(2026, 10),
        createdAt: DateTime(2026, 10),
      ),
    ]),
  ),
];

/// A phone-sized surface: the detail sheet scrolls, as on a real phone.
void _phoneView(WidgetTester tester) {
  tester.view.physicalSize = const Size(1170, 2532);
  tester.view.devicePixelRatio = 3;
  addTearDown(tester.view.reset);
}

/// The detail as the app shows it: a sheet over a screen, so the snackbar
/// it leaves on closing has somewhere to show.
Widget _detailLauncher(SmsReviewItem item) => Builder(
  builder: (context) => TextButton(
    onPressed: () => showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (_) => SmsReviewDetail(item: item),
    ),
    child: const Text('open'),
  ),
);

Future<void> _openDetail(WidgetTester tester) async {
  await tester.tap(find.text('open'));
  await tester.pumpAndSettle();
}

Future<void> _tap(WidgetTester tester, Key key) async {
  await tester.ensureVisible(find.byKey(key));
  await tester.pumpAndSettle();
  await tester.tap(find.byKey(key));
  await tester.pumpAndSettle();
}

SmsReviewItem _item({
  String kind = 'principal',
  String? suggested,
  String direction = 'debit',
  String? id,
  String bankAccountCode = '1020',
  String providerLabel = 'BK',
  String? occurredAt = '2026-10-14T09:29:21',
  String lineDate = '2026-10-14',
  String? counterpartyName,
  String? currency,
}) => SmsReviewItem.fromDitto({
  '_id': id ?? (kind == 'fee' ? 'sms-fee' : 'sms-1'),
  'businessId': 'biz',
  'branchId': 'br',
  'kind': kind,
  'direction': direction,
  'amount': kind == 'fee' ? 20 : 2000,
  'description': kind == 'fee'
      ? 'BK · charge · FTCMTEST'
      : 'BK · to Jane DOE · FTCMTEST',
  'providerLabel': providerLabel,
  'paymentType': 'BANK TRANSFER',
  'bankAccountCode': bankAccountCode,
  'occurredAt': ?occurredAt,
  'lineDate': lineDate,
  'status': 'pending_review',
  'bankLineId': 'line-${id ?? kind}',
  'counterpartyName': ?counterpartyName,
  'currency': ?currency,
  if (suggested != null) 'suggestedCategory': suggested,
});

class _FakeBridge extends SmsBridgeClient {
  _FakeBridge() : super(baseUrl: () async => 'https://unused.test/');

  int pairings = 0;
  final revoked = <String>[];

  /// When set, the next revoke throws it.
  Object? revokeError;

  @override
  Future<SmsBridgePairing> createPairing({String? label}) async {
    pairings++;
    return SmsBridgePairing(
      code: '7K3QMZ9TXA',
      displayCode: '7K3QM-Z9TXA',
      expiresAt: DateTime.now().add(const Duration(minutes: 10)),
      qrPayload: smsBridgeQrPayload(
        baseUrl: 'https://unused.test/',
        code: '7K3QMZ9TXA',
      ),
    );
  }

  @override
  Future<List<SmsBridgeDevice>> listDevices() async => const [
    SmsBridgeDevice(deviceId: 'd1', label: 'Tecno Spark'),
  ];

  @override
  Future<void> revoke(String deviceId) async {
    final error = revokeError;
    revokeError = null;
    if (error != null) throw error;
    revoked.add(deviceId);
  }
}

/// The SMS Bridge page is one long scroll (install, pair, paired phones);
/// a phone-tall surface keeps the phone list built.
void _tallView(WidgetTester tester) {
  tester.view.physicalSize = const Size(1080, 6000);
  tester.view.devicePixelRatio = 3;
  addTearDown(tester.view.reset);
}

Widget _app(Widget child, List<Override> overrides) => ProviderScope(
  overrides: overrides,
  child: MaterialApp(
    locale: const Locale('en'),
    localizationsDelegates: FlipperAppLocalizations.localizationsDelegates,
    supportedLocales: FlipperAppLocalizations.supportedLocales,
    home: Scaffold(body: child),
  ),
);

void main() {
  late _Store store;
  late _Cats categories;
  late List<(SmsReviewItem, String?)> recorded;
  late List<(String, String)> posted;
  late List<String> voided;

  List<Override> reviewOverrides(
    List<SmsReviewItem> items, {
    List<Category>? cats,
    SmsDebtRepaymentRecorder? recordRepayment,
    Completer<void>? movementGate,
  }) {
    store = _Store();
    categories = _Cats();
    recorded = [];
    posted = [];
    voided = [];
    return [
      smsCategoryStoreProvider.overrideWithValue(categories),
      smsReviewBranchIdProvider.overrideWithValue('br'),
      smsReviewItemsProvider('br').overrideWith((ref) => Stream.value(items)),
      categoryProvider.overrideWith(
        (ref) => Stream.value(cats ?? const <Category>[]),
      ),
      smsReviewServiceProvider.overrideWithValue(
        SmsReviewService(
          store: store,
          journalEntryId: (b, t) => 'je_${b}_${t}_sale',
          postTransfer:
              ({
                required entryId,
                required item,
                required otherAccountCode,
              }) async => posted.add((entryId, otherAccountCode)),
          voidTransfer: ({required entryId, required item}) async =>
              voided.add(entryId),
          recordMovement:
              ({
                required item,
                required categoryId,
                required categoryName,
              }) async {
                await movementGate?.future;
                recorded.add((item, categoryId));
                return 'txn-1';
              },
          recordRepayment: recordRepayment,
        ),
      ),
    ];
  }

  testWidgets('the home card stays hidden until something is waiting', (
    tester,
  ) async {
    await tester.pumpWidget(
      _app(const SmsReviewHomeCard(), reviewOverrides(const [])),
    );
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('sms_review_home_card')), findsNothing);
  });

  testWidgets('the home card counts, totals and opens the queue', (
    tester,
  ) async {
    final items = [_item(), _item(id: 'sms-2', direction: 'credit')];
    await tester.pumpWidget(
      _app(const SmsReviewHomeCard(), reviewOverrides(items)),
    );
    await tester.pumpAndSettle();
    expect(find.text('2 bank & MoMo SMS to approve'), findsOneWidget);
    expect(find.textContaining('in · '), findsOneWidget);

    await tester.tap(find.byKey(const Key('sms_review_home_card')));
    await tester.pumpAndSettle();
    expect(find.text('Bank & MoMo SMS'), findsOneWidget);
    expect(find.byKey(const Key('sms_review_row_sms-2')), findsOneWidget);
  });

  testWidgets('SMS in two currencies are never added up', (tester) async {
    final items = [
      _item(direction: 'credit'),
      _item(id: 'sms-2', direction: 'credit', currency: 'USD'),
    ];
    await tester.pumpWidget(
      _app(const SmsReviewHomeCard(), reviewOverrides(items)),
    );
    await tester.pumpAndSettle();
    expect(find.text('2 bank & MoMo SMS to approve'), findsOneWidget);
    expect(find.textContaining('4,000'), findsNothing);
    expect(find.textContaining('RWF'), findsNothing);

    await tester.tap(find.byKey(const Key('sms_review_home_card')));
    await tester.pumpAndSettle();
    expect(find.text('Money in'), findsNothing);
  });

  testWidgets('one foreign currency labels its totals with it', (tester) async {
    final items = [_item(currency: 'USD'), _item(id: 'sms-2', currency: 'USD')];
    await tester.pumpWidget(
      _app(const SmsReviewHomeCard(), reviewOverrides(items)),
    );
    await tester.pumpAndSettle();
    expect(find.textContaining('USD'), findsOneWidget);

    await tester.tap(find.byKey(const Key('sms_review_home_card')));
    await tester.pumpAndSettle();
    expect(find.text('Money out'), findsOneWidget);
    expect(find.textContaining('USD 4,000'), findsWidgets);
  });

  testWidgets('the count badge shows only while SMS are waiting', (
    tester,
  ) async {
    const icon = SmsReviewCountBadge(child: Icon(Icons.grid_view));
    await tester.pumpWidget(_app(icon, reviewOverrides(const [])));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('sms_review_count_badge')), findsNothing);

    // A fresh scope: overrides can't change on a mounted ProviderScope.
    await tester.pumpWidget(const SizedBox());
    await tester.pumpWidget(
      _app(icon, reviewOverrides([_item(), _item(id: 'sms-2')])),
    );
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('sms_review_count_badge')), findsOneWidget);
    expect(find.text('2'), findsOneWidget);
  });

  testWidgets('an empty queue says so instead of showing a blank sheet', (
    tester,
  ) async {
    await tester.pumpWidget(
      _app(const SmsReviewSheet(), reviewOverrides(const [])),
    );
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('sms_review_empty')), findsOneWidget);
  });

  testWidgets('money in for a rung-up sale links to it and records nothing', (
    tester,
  ) async {
    final item = _item(direction: 'credit');
    await tester.pumpWidget(
      _app(SmsReviewDetail(item: item), [
        ...reviewOverrides(const []),
        smsMatchingSalesProvider(item).overrideWith(
          (ref) async => [
            SmsSaleCandidate(
              transactionId: 'sale-9',
              amount: 2000,
              paymentType: 'BANK TRANSFER',
              createdAt: DateTime(2026, 10, 14, 9, 25),
            ),
          ],
        ),
      ]),
    );
    await tester.pumpAndSettle();
    expect(find.text('Already recorded as a sale?'), findsOneWidget);

    await tester.tap(find.byKey(const Key('sms_review_link_sale-9')));
    await tester.pumpAndSettle();
    expect(recorded, isEmpty);
    expect(store.statuses['sms-1'], SmsReviewItem.matched);
    expect(store.matched, {'line-principal': 'je_biz_sale-9_sale'});
  });

  testWidgets('money in from a customer who owes settles their debt', (
    tester,
  ) async {
    final item = _item(direction: 'credit');
    final settled = <String>[];
    Future<void> settle(double remaining) async {
      // A fresh app each time, so an earlier snackbar is not queued ahead.
      await tester.pumpWidget(const SizedBox());
      await tester.pumpWidget(
        _app(_detailLauncher(item), [
          ...reviewOverrides(
            const [],
            recordRepayment: ({required item, required debt}) async {
              settled.add(debt.transactionId);
              return (
                transactionId: debt.transactionId,
                remaining: remaining,
                journalEntryId: 'je_biz_${debt.transactionId}_pay_1',
              );
            },
          ),
          smsMatchingDebtsProvider(item).overrideWith(
            (ref) async => const [
              SmsDebtCandidate(
                transactionId: 'loan-7',
                remainingBalance: 5000,
                customerName: 'Jane DOE',
                customerPhone: '0780000123',
              ),
              SmsDebtCandidate(transactionId: 'loan-8', remainingBalance: 9000),
            ],
          ),
        ]),
      );
      await tester.pumpAndSettle();
      await _openDetail(tester);
      expect(find.text('Is a customer paying off a debt?'), findsOneWidget);
      expect(find.textContaining('****0123'), findsOneWidget);
      expect(find.textContaining('Customer · owes'), findsOneWidget);
      await _tap(tester, const Key('sms_review_settle_loan-7'));
    }

    await settle(3000);
    expect(settled, ['loan-7']);
    expect(recorded, isEmpty);
    expect(store.statuses['sms-1'], SmsReviewItem.matched);
    expect(store.matched, {'line-principal': 'je_biz_loan-7_pay_1'});
    expect(find.textContaining('Still owes'), findsOneWidget);

    await settle(0);
    expect(find.text("Jane DOE's debt is fully paid."), findsOneWidget);
  });

  testWidgets('money in with no matching sale offers no link', (tester) async {
    final item = _item(direction: 'credit');
    await tester.pumpWidget(
      _app(SmsReviewDetail(item: item), [
        ...reviewOverrides(const []),
        smsMatchingSalesProvider(item).overrideWith((ref) async => const []),
      ]),
    );
    await tester.pumpAndSettle();
    expect(find.text('Already recorded as a sale?'), findsNothing);
    expect(find.byKey(const Key('sms_review_confirm')), findsOneWidget);
  });

  testWidgets('no banner when nothing is waiting', (tester) async {
    await tester.pumpWidget(
      _app(const SmsReviewBanner(), reviewOverrides(const [])),
    );
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('sms_review_banner')), findsNothing);
  });

  testWidgets('confirming an SMS records it and matches its bank line', (
    tester,
  ) async {
    await tester.pumpWidget(
      _app(const SmsReviewBanner(), reviewOverrides([_item()])),
    );
    await tester.pumpAndSettle();
    expect(find.text('Bank & MoMo SMS to review: 1'), findsOneWidget);

    await tester.tap(find.byKey(const Key('sms_review_banner')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('sms_review_row_sms-1')));
    await tester.pumpAndSettle();
    await _tap(tester, const Key('sms_review_confirm'));

    expect(recorded, hasLength(1));
    expect(recorded.single.$1.amount, 2000);
    expect(store.statuses['sms-1'], SmsReviewItem.confirmed);
    expect(store.matched, {'line-principal': 'je_biz_txn-1_sale'});
    // On the queue sheet, not on the screen it covers.
    expect(
      find.descendant(
        of: find.byType(FractionallySizedBox),
        matching: find.text('Added to the Cash Book'),
      ),
      findsOneWidget,
    );
  });

  testWidgets('a fee preselects the suggested category and has no transfer', (
    tester,
  ) async {
    final bankCharges = Category(id: 'cat-fees', name: 'Bank charges');
    await tester.pumpWidget(
      _app(
        SmsReviewDetail(
          item: _item(kind: 'fee', suggested: 'Bank charges'),
        ),
        reviewOverrides(const [], cats: [bankCharges]),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('sms_review_transfer')), findsNothing);

    await _tap(tester, const Key('sms_review_confirm'));
    expect(recorded.single.$2, 'cat-fees');
    expect(categories.created, isEmpty);
  });

  testWidgets('ignore closes the item without recording', (tester) async {
    await tester.pumpWidget(
      _app(_detailLauncher(_item()), reviewOverrides(const [])),
    );
    await tester.pumpAndSettle();
    await _openDetail(tester);
    await _tap(tester, const Key('sms_review_ignore'));
    expect(recorded, isEmpty);
    expect(store.statuses['sms-1'], SmsReviewItem.ignored);
    expect(find.text('Ignored'), findsOneWidget);

    await tester.tap(find.byKey(const Key('sms_review_undo')));
    await tester.pumpAndSettle();
    expect(store.statuses['sms-1'], SmsReviewItem.pending);
    expect(find.text('Back in the list'), findsOneWidget);
  });

  testWidgets(
    'money out suggests expense categories; a new one is created on confirm',
    (tester) async {
      _phoneView(tester);
      await tester.pumpWidget(
        _app(
          SmsReviewDetail(item: _item()),
          reviewOverrides(
            const [],
            cats: [
              Category(id: 'p1', name: 'main'),
              Category(id: 'p2', name: 'UnCategorized'),
              Category(id: 'c-rent', name: 'rent'),
            ],
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Salary'), findsOneWidget);
      expect(find.text('Sales'), findsNothing);
      expect(find.text('main'), findsNothing);
      expect(find.text('UnCategorized'), findsNothing);
      // An existing category stands in for its suggestion, in its own spelling.
      expect(find.text('rent'), findsOneWidget);

      await _tap(tester, const Key('sms_review_category_Salary'));
      await _tap(tester, const Key('sms_review_confirm'));
      expect(categories.created, ['Salary']);
      expect(recorded.single.$2, 'new-Salary');
      expect(categories.remembered, [('new-Salary', false)]);
    },
  );

  testWidgets('money in suggests income; More shows the branch\'s others', (
    tester,
  ) async {
    _phoneView(tester);
    await tester.pumpWidget(
      _app(
        SmsReviewDetail(item: _item(direction: 'credit')),
        reviewOverrides(
          const [],
          cats: [Category(id: 'c-t', name: 'Transport')],
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Sales'), findsOneWidget);
    expect(find.text('Transport'), findsNothing);

    await _tap(tester, const Key('sms_review_category_more'));
    expect(find.text('Transport'), findsOneWidget);
    expect(find.byKey(const Key('sms_review_category_more')), findsNothing);

    await _tap(tester, const Key('sms_review_category_Transport'));
    await _tap(tester, const Key('sms_review_confirm'));
    expect(recorded.single.$2, 'c-t');
    expect(categories.created, isEmpty);
  });

  testWidgets('the last category used for the direction is preselected', (
    tester,
  ) async {
    _phoneView(tester);
    final overrides = reviewOverrides(
      const [],
      cats: [Category(id: 'c-rent', name: 'Rent')],
    );
    categories.last = 'c-rent';
    await tester.pumpWidget(_app(SmsReviewDetail(item: _item()), overrides));
    await tester.pumpAndSettle();
    await _tap(tester, const Key('sms_review_confirm'));
    expect(recorded.single.$2, 'c-rent');
  });

  testWidgets('New opens the new-category sheet for the direction', (
    tester,
  ) async {
    _phoneView(tester);
    await tester.pumpWidget(
      _app(SmsReviewDetail(item: _item()), reviewOverrides(const [])),
    );
    await tester.pumpAndSettle();
    await _tap(tester, const Key('sms_review_category_new'));
    final sheet = tester.widget<CashbookNewCategorySheet>(
      find.byType(CashbookNewCategorySheet),
    );
    expect(sheet.isIncome, isFalse);
    expect(await sheet.onCreate('Fuel'), 'new-Fuel');
    expect(categories.created, ['Fuel']);
  });

  testWidgets(
    'a transfer asks where, closes the other account\'s SMS, and undoes',
    (tester) async {
      _phoneView(tester);
      final bankOut = _item(counterpartyName: 'Own MoMo');
      final momoIn = _item(
        id: 'sms-2',
        direction: 'credit',
        bankAccountCode: '1030',
        providerLabel: 'MTN MoMo',
        occurredAt: '2026-10-14T09:31:00',
      );
      await tester.pumpWidget(
        _app(_detailLauncher(bankOut), reviewOverrides([bankOut, momoIn])),
      );
      await tester.pumpAndSettle();
      await _openDetail(tester);
      expect(find.text('Where did the money go?'), findsNothing);

      await _tap(tester, const Key('sms_review_transfer'));
      expect(find.text('Where did the money go?'), findsOneWidget);
      expect(
        find.byKey(const Key('sms_review_transfer_target_1010')),
        findsOneWidget,
      );
      // Its own account is not a choice.
      expect(
        find.byKey(const Key('sms_review_transfer_target_1020')),
        findsNothing,
      );
      // The waiting MoMo SMS for the same move picks the target.
      expect(
        find.byKey(const Key('sms_review_transfer_paired')),
        findsOneWidget,
      );
      expect(find.textContaining('MTN MoMo +RWF'), findsOneWidget);

      await _tap(tester, const Key('sms_review_transfer_record'));
      expect(posted, [('je_smsxfer_sms-1', '1030')]);
      expect(recorded, isEmpty);
      expect(store.statuses['sms-1'], SmsReviewItem.transfer);
      expect(store.statuses['sms-2'], SmsReviewItem.transfer);
      expect(store.matched, {
        'line-principal': 'je_smsxfer_sms-1',
        'line-sms-2': 'je_smsxfer_sms-1',
      });
      expect(
        find.text('Recorded as a transfer to Mobile Money'),
        findsOneWidget,
      );

      await tester.tap(find.byKey(const Key('sms_review_undo')));
      await tester.pumpAndSettle();
      expect(voided, ['je_smsxfer_sms-1']);
      expect(store.statuses['sms-1'], SmsReviewItem.pending);
      expect(store.statuses['sms-2'], SmsReviewItem.pending);
      expect(store.matched.values, everyElement(isNull));
    },
  );

  testWidgets('a transfer with no other SMS waits for a target', (
    tester,
  ) async {
    _phoneView(tester);
    final moneyIn = _item(direction: 'credit');
    await tester.pumpWidget(
      _app(_detailLauncher(moneyIn), reviewOverrides([moneyIn])),
    );
    await tester.pumpAndSettle();
    await _openDetail(tester);
    await _tap(tester, const Key('sms_review_transfer'));
    expect(find.text('Where did the money come from?'), findsOneWidget);
    expect(find.byKey(const Key('sms_review_transfer_paired')), findsNothing);
    final record = find.byKey(const Key('sms_review_transfer_record'));
    expect(tester.widget<FilledButton>(record).onPressed, isNull);

    await _tap(tester, const Key('sms_review_transfer_target_1010'));
    await _tap(tester, const Key('sms_review_transfer_record'));
    expect(posted, [('je_smsxfer_sms-1', '1010')]);
    expect(find.text('Recorded as a transfer from Cash'), findsOneWidget);
  });

  testWidgets('rows group by day and never show a made-up 00:00', (
    tester,
  ) async {
    _phoneView(tester);
    await tester.pumpWidget(
      _app(
        const SmsReviewSheet(),
        reviewOverrides([
          _item(id: 'a', occurredAt: null, lineDate: '2025-01-06'),
          _item(
            id: 'b',
            occurredAt: '2025-01-07T00:00:00',
            lineDate: '2025-01-07',
            counterpartyName: 'JANE DOE',
          ),
          _item(id: 'c', occurredAt: '2025-01-07T14:05:00'),
        ]),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Mon 6 Jan'), findsOneWidget);
    expect(find.text('Tue 7 Jan'), findsOneWidget);
    expect(find.textContaining('00:00'), findsNothing);
    expect(find.text('Money out · 14:05'), findsOneWidget);
    // A named counterparty is the title; the provider moves to the line below.
    expect(find.text('JANE DOE'), findsOneWidget);
    expect(find.text('BK · Money out'), findsOneWidget);
    // The undated-time row, and the money-out total above the list.
    expect(find.text('Money out'), findsNWidgets(2));
    expect(find.textContaining('−RWF'), findsWidgets);
  });

  testWidgets('the SMS Bridge page pairs a phone and unpairs one', (
    tester,
  ) async {
    _tallView(tester);
    final fake = _FakeBridge();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [smsBridgeClientProvider.overrideWithValue(fake)],
        child: MaterialApp(
          locale: const Locale('en'),
          localizationsDelegates:
              FlipperAppLocalizations.localizationsDelegates,
          supportedLocales: FlipperAppLocalizations.supportedLocales,
          home: const SmsBridgePage(),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Tecno Spark'), findsOneWidget);

    await tester.tap(find.byKey(const Key('sms_bridge_pair')));
    await tester.pumpAndSettle();
    expect(fake.pairings, 1);
    expect(find.byKey(const Key('sms_bridge_qr')), findsOneWidget);
    expect(find.text('7K3QM-Z9TXA'), findsOneWidget);

    // The QR card pushes the phone list below the fold.
    await tester.scrollUntilVisible(
      find.text('Unpair'),
      200,
      // SelectableText brings its own Scrollable; scroll the page's list.
      scrollable: find
          .descendant(
            of: find.byType(ListView),
            matching: find.byType(Scrollable),
          )
          .first,
    );
    await tester.tap(find.text('Unpair').first);
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Unpair'));
    await tester.pumpAndSettle();
    expect(fake.revoked, ['d1']);
  });
  testWidgets('a sheet closed mid-confirm leaves the screen beneath open', (
    tester,
  ) async {
    final done = Completer<void>();
    var cashBookBuilds = 0;
    final container = ProviderContainer(
      overrides: [
        smsCategoryStoreProvider.overrideWithValue(_Cats()),
        smsReviewBranchIdProvider.overrideWithValue(''),
        categoryProvider.overrideWith(
          (ref) => Stream.value(const <Category>[]),
        ),
        cashbookRecentTransactionsProvider.overrideWith((ref) {
          cashBookBuilds++;
          return Stream.value(const <ITransaction>[]);
        }),
        smsReviewServiceProvider.overrideWithValue(
          SmsReviewService(
            store: _Store(),
            journalEntryId: (b, t) => 'je_$t',
            postTransfer:
                ({
                  required entryId,
                  required item,
                  required otherAccountCode,
                }) async {},
            voidTransfer: ({required entryId, required item}) async {},
            recordMovement:
                ({
                  required item,
                  required categoryId,
                  required categoryName,
                }) async {
                  await done.future;
                  return 'txn-1';
                },
          ),
        ),
      ],
    );
    addTearDown(container.dispose);
    // Stands in for the Cash Book list, which stays subscribed underneath.
    container.listen(cashbookRecentTransactionsProvider, (_, _) {});
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          locale: const Locale('en'),
          localizationsDelegates:
              FlipperAppLocalizations.localizationsDelegates,
          supportedLocales: FlipperAppLocalizations.supportedLocales,
          home: const Scaffold(body: Text('home')),
        ),
      ),
    );
    await tester.pumpAndSettle();
    final navigator = tester.state<NavigatorState>(find.byType(Navigator));
    navigator.push(
      MaterialPageRoute<void>(
        builder: (_) => const Scaffold(body: Text('cash book')),
      ),
    );
    await tester.pumpAndSettle();
    navigator.push(
      MaterialPageRoute<void>(
        builder: (_) => Scaffold(body: SmsReviewDetail(item: _item())),
      ),
    );
    await tester.pumpAndSettle();
    expect(cashBookBuilds, 1);

    await tester.tap(find.byKey(const Key('sms_review_confirm')));
    await tester.pump();
    // The user swipes the sheet away while the movement is being recorded.
    navigator.pop();
    await tester.pumpAndSettle();
    done.complete();
    await tester.pumpAndSettle();

    expect(find.text('cash book'), findsOneWidget);
    expect(find.text('Added to the Cash Book'), findsOneWidget);
    // The Cash Book list still refreshed.
    expect(cashBookBuilds, 2);
  });

  testWidgets('a failed unpair shows why, and the next one clears it', (
    tester,
  ) async {
    _tallView(tester);
    final fake = _FakeBridge()
      ..revokeError = const SmsBridgeException('connector down');
    await tester.pumpWidget(
      ProviderScope(
        overrides: [smsBridgeClientProvider.overrideWithValue(fake)],
        child: MaterialApp(
          locale: const Locale('en'),
          localizationsDelegates:
              FlipperAppLocalizations.localizationsDelegates,
          supportedLocales: FlipperAppLocalizations.supportedLocales,
          home: const SmsBridgePage(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    Future<void> unpair() async {
      await tester.tap(find.text('Unpair').first);
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(FilledButton, 'Unpair'));
      await tester.pumpAndSettle();
    }

    await unpair();
    expect(fake.revoked, isEmpty);
    expect(find.textContaining('connector down'), findsOneWidget);

    await unpair();
    expect(fake.revoked, ['d1']);
    expect(find.textContaining('connector down'), findsNothing);
  });

  testWidgets('a failed loan repayment retries without confirming twice', (
    tester,
  ) async {
    _phoneView(tester);
    final loans = _Loans()..fail = 1;
    await tester.pumpWidget(
      _app(_detailLauncher(_item(suggested: kLoanRepaymentCategory)), [
        ...reviewOverrides(const []),
        ..._personalLoanOverrides(loans),
      ]),
    );
    await _openDetail(tester);
    // The only loan is picked for the repayment.
    expect(
      tester
          .widget<ChoiceChip>(find.byKey(const ValueKey('loan-pick-loan-bk')))
          .selected,
      isTrue,
    );

    await _tap(tester, const Key('sms_review_confirm'));
    expect(recorded, hasLength(1));
    expect(loans.payments, isEmpty);
    expect(find.byType(SmsReviewDetail), findsOneWidget);

    await _tap(tester, const Key('sms_review_confirm'));
    expect(recorded, hasLength(1), reason: 'the SMS is confirmed once');
    final p = loans.payments.single;
    expect(p.loanId, 'loan-bk');
    expect(p.transactionId, 'txn-1');
    expect(p.amount, 2000);
    expect(p.source, 'sms');
    expect(find.byType(SmsReviewDetail), findsNothing);
  });

  testWidgets('a loan repayment is written even if the sheet closes', (
    tester,
  ) async {
    _phoneView(tester);
    final loans = _Loans();
    final gate = Completer<void>();
    await tester.pumpWidget(
      _app(_detailLauncher(_item(suggested: kLoanRepaymentCategory)), [
        ...reviewOverrides(const [], movementGate: gate),
        ..._personalLoanOverrides(loans),
      ]),
    );
    await _openDetail(tester);
    await tester.ensureVisible(find.byKey(const Key('sms_review_confirm')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('sms_review_confirm')));
    await tester.pump();

    Navigator.of(tester.element(find.byType(SmsReviewDetail))).pop();
    await tester.pumpAndSettle();
    expect(find.byType(SmsReviewDetail), findsNothing);

    gate.complete();
    await tester.pumpAndSettle();
    expect(recorded, hasLength(1));
    expect(loans.payments.single.transactionId, 'txn-1');
  });
}
