import 'dart:convert';

import 'package:flipper_accounting/accounting_settings.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_web/modules/accounting/data/accounting_models.dart';
import 'package:flipper_web/modules/accounting/data/accounting_providers.dart';
import 'package:flipper_web/modules/accounting/data/services/vat_position_service.dart';
import 'package:flipper_web/modules/accounting/theme/accounting_tokens.dart';
import 'package:flipper_web/modules/accounting/widgets/accounting_switch.dart';
import 'package:flipper_web/modules/accounting/widgets/books_vat_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

import '../../../helpers/fake_accounting_ditto_store.dart';

/// Records the settings documents Books writes.
class _SettingsDitto extends FakeAccountingDittoStore {
  final writes = <String, Map<String, dynamic>>{};

  @override
  Future<void> upsertPartyDoc(
    String collection,
    String docId,
    Map<String, dynamic> data,
  ) async {
    writes['$collection/$docId'] = data;
  }
}

/// Counts reads, so a refresh after saving the setting shows.
class _CountingVatPositionService extends VatPositionService {
  _CountingVatPositionService()
    : super(client: MockClient((_) async => http.Response('', 500)));

  int reads = 0;

  @override
  Future<BooksVatPosition?> position() async {
    reads++;
    return null;
  }
}

/// Answers [position] with a canned value, or throws when [error] is set.
class _FakeVatPositionService extends VatPositionService {
  _FakeVatPositionService({this.value, this.error})
    : super(client: MockClient((_) async => http.Response('', 500)));

  final BooksVatPosition? value;
  final Object? error;

  @override
  Future<BooksVatPosition?> position() async {
    if (error != null) throw error!;
    return value;
  }
}

Future<void> _pump(
  WidgetTester tester,
  Widget child, {
  List<Override> overrides = const [],
}) async {
  tester.view.physicalSize = const Size(1200, 1600);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        accountingBusinessIdProvider.overrideWithValue('biz'),
        ...overrides,
      ],
      child: MaterialApp(
        localizationsDelegates: FlipperLocalizationDelegates.delegates,
        supportedLocales: FlipperLocalizationDelegates.supportedLocales,
        home: Scaffold(body: SingleChildScrollView(child: child)),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

Future<void> _pumpCard(
  WidgetTester tester,
  BooksVatPosition? position, {
  List<Override> overrides = const [],
}) => _pump(
  tester,
  const BooksVatCard(),
  overrides: [
    booksVatPositionProvider.overrideWith((ref) async => position),
    ...overrides,
  ],
);

const _notRegistered = BooksVatPosition(
  registered: false,
  hasEbmBranch: false,
  settingRegistered: false,
  monthEstimatedOutputVat: 180000,
  monthPurchaseVat: 90000,
  turnover12m: 17000000,
  threshold: VatThreshold.near,
  hasEstimate: true,
);

Account _loan(int bal) => Account(
  code: '2200',
  name: 'Bank Loan',
  type: AccountType.liability,
  sub: 'Long-term liabilities',
  normal: AccountNormal.credit,
  bal: bal,
);

void main() {
  group('BooksVatCard', () {
    testWidgets('shows nothing while the position cannot be read', (
      tester,
    ) async {
      await _pumpCard(tester, null);
      expect(find.text('VAT'), findsNothing);
      expect(find.byType(AccountingSwitch), findsNothing);
    });

    testWidgets('EBM branch: VAT payable from the ledger, no setting', (
      tester,
    ) async {
      await _pumpCard(
        tester,
        const BooksVatPosition(
          registered: true,
          hasEbmBranch: true,
          settingRegistered: false,
          vatOwed: 54000,
          hasEstimate: true,
        ),
      );
      expect(find.text('VAT payable (from your ledger)'), findsOneWidget);
      expect(find.text('RWF 54,000', findRichText: true), findsOneWidget);
      expect(find.text('Registered'), findsOneWidget);
      expect(find.byType(AccountingSwitch), findsNothing);
      expect(
        find.text('Not registered for VAT: your sales carry no VAT.'),
        findsNothing,
      );
    });

    testWidgets('registered, ledger figure unavailable: no made-up zero', (
      tester,
    ) async {
      await _pumpCard(
        tester,
        const BooksVatPosition(
          registered: true,
          hasEbmBranch: true,
          settingRegistered: false,
        ),
      );
      expect(
        find.text('VAT payable could not be read from your ledger right now.'),
        findsOneWidget,
      );
      expect(find.text('VAT payable (from your ledger)'), findsNothing);
      expect(find.text('0'), findsNothing);
    });

    testWidgets('registered by the setting with a credit: credit, switch on', (
      tester,
    ) async {
      await _pumpCard(
        tester,
        const BooksVatPosition(
          registered: true,
          hasEbmBranch: false,
          settingRegistered: true,
          vatOwed: -1200,
          hasEstimate: true,
        ),
      );
      expect(find.text('VAT credit (from your ledger)'), findsOneWidget);
      final amount = tester.widget<Text>(
        find.byWidgetPredicate(
          (w) => w is Text && w.textSpan?.toPlainText() == 'RWF 1,200',
        ),
      );
      expect(amount.style?.color, AccountingTokens.gainInk);
      expect(
        tester.widget<AccountingSwitch>(find.byType(AccountingSwitch)).value,
        isTrue,
      );
    });

    testWidgets(
      'not registered, near the threshold: estimate, warning, switch off',
      (tester) async {
        await _pumpCard(tester, _notRegistered);
        expect(
          find.text('Not registered for VAT: your sales carry no VAT.'),
          findsOneWidget,
        );
        expect(
          find.text("VAT in this month's sales (estimate)"),
          findsOneWidget,
        );
        expect(find.text('Not registered'), findsOneWidget);
        expect(find.text('RWF 180,000', findRichText: true), findsOneWidget);
        expect(find.text('RWF 90,000', findRichText: true), findsOneWidget);
        expect(find.text('85%'), findsOneWidget);
        expect(
          find.text(
            'Sales in the last 12 months: RWF 17,000,000 of the RWF 20,000,000 registration threshold',
          ),
          findsOneWidget,
        );
        expect(
          find.text(
            "You are getting close to RRA's VAT registration threshold.",
          ),
          findsOneWidget,
        );
        final bar = tester.widget<LinearProgressIndicator>(
          find.byType(LinearProgressIndicator),
        );
        expect(bar.value, closeTo(0.85, 1e-9));
        expect(bar.color, AccountingTokens.warnAmber);
        expect(
          tester.widget<AccountingSwitch>(find.byType(AccountingSwitch)).value,
          isFalse,
        );
      },
    );

    testWidgets('past the threshold: the bar is full and says so', (
      tester,
    ) async {
      await _pumpCard(
        tester,
        const BooksVatPosition(
          registered: false,
          hasEbmBranch: false,
          settingRegistered: false,
          turnover12m: 26000000,
          threshold: VatThreshold.crossed,
          hasEstimate: true,
        ),
      );
      expect(
        find.textContaining("You are past RRA's VAT registration threshold."),
        findsOneWidget,
      );
      final bar = tester.widget<LinearProgressIndicator>(
        find.byType(LinearProgressIndicator),
      );
      expect(bar.value, 1.0);
      expect(bar.color, AccountingTokens.loss);
      // The chip says how far past it is; only the bar stops at full.
      expect(find.text('130%'), findsOneWidget);
    });

    testWidgets('well under the threshold: no warning', (tester) async {
      await _pumpCard(
        tester,
        const BooksVatPosition(
          registered: false,
          hasEbmBranch: false,
          settingRegistered: false,
          turnover12m: 2000000,
          hasEstimate: true,
        ),
      );
      expect(find.textContaining('threshold.'), findsNothing);
      expect(
        tester
            .widget<LinearProgressIndicator>(
              find.byType(LinearProgressIndicator),
            )
            .color,
        AccountingTokens.accent,
      );
    });

    testWidgets('not registered without figures: only the status', (
      tester,
    ) async {
      await _pumpCard(
        tester,
        const BooksVatPosition(
          registered: false,
          hasEbmBranch: false,
          settingRegistered: false,
        ),
      );
      expect(
        find.text('Not registered for VAT: your sales carry no VAT.'),
        findsOneWidget,
      );
      expect(find.byType(LinearProgressIndicator), findsNothing);
      expect(find.text("VAT in this month's sales (estimate)"), findsNothing);
    });

    testWidgets('amounts carry the business currency', (tester) async {
      await _pumpCard(
        tester,
        _notRegistered,
        overrides: [accountingCurrencyProvider.overrideWithValue('USD')],
      );
      expect(find.text('USD 180,000', findRichText: true), findsOneWidget);
      expect(
        find.textContaining('USD 17,000,000 of the USD 20,000,000'),
        findsOneWidget,
      );
      expect(find.textContaining('RWF'), findsNothing);
    });

    testWidgets('turning the setting on saves it and confirms', (tester) async {
      final saved = <bool>[];
      await _pumpCard(
        tester,
        _notRegistered,
        overrides: [
          setBooksVatRegisteredProvider.overrideWithValue((registered) async {
            saved.add(registered);
          }),
        ],
      );
      tester
          .widget<AccountingSwitch>(find.byType(AccountingSwitch))
          .onChanged(true);
      await tester.pump();
      await tester.pump();
      expect(saved, [true]);
      expect(find.text('VAT setting saved'), findsOneWidget);
      await tester.pump(const Duration(seconds: 10));
      await tester.pumpAndSettle();
    });
  });

  testWidgets('a setting that cannot be saved says so and can be retried', (
    tester,
  ) async {
    var calls = 0;
    await _pumpCard(
      tester,
      _notRegistered,
      overrides: [
        setBooksVatRegisteredProvider.overrideWithValue((registered) async {
          calls++;
          throw StateError('not ready');
        }),
      ],
    );
    final toggle = find.byType(AccountingSwitch);
    tester.widget<AccountingSwitch>(toggle).onChanged(true);
    await tester.pump();
    await tester.pump();
    expect(
      find.text('Could not save the VAT setting. Try again.'),
      findsOneWidget,
    );
    expect(find.text('VAT setting saved'), findsNothing);
    await tester.pump(const Duration(seconds: 10));
    await tester.pumpAndSettle();
    // Not stuck saving: a second try goes through to the provider.
    tester.widget<AccountingSwitch>(toggle).onChanged(true);
    await tester.pump();
    await tester.pump();
    expect(calls, 2);
    await tester.pump(const Duration(seconds: 10));
    await tester.pumpAndSettle();
  });

  group('BooksLoanOpeningPrompt', () {
    test('overRepaid is the Bank Loan debit balance only', () {
      expect(
        BooksLoanOpeningPrompt.overRepaid([(code: '2200', bal: -50000)]),
        50000,
      );
      expect(
        BooksLoanOpeningPrompt.overRepaid([(code: '2200', bal: 50000)]),
        0,
      );
      expect(
        BooksLoanOpeningPrompt.overRepaid([(code: '1010', bal: -50000)]),
        0,
      );
      expect(BooksLoanOpeningPrompt.overRepaid(const []), 0);
    });

    testWidgets('repaid more than received: prompt opens the composer', (
      tester,
    ) async {
      var opened = 0;
      await _pump(
        tester,
        BooksLoanOpeningPrompt(onRecord: () => opened++),
        overrides: [
          accountingAccountsProvider.overrideWithValue([_loan(-50000)]),
        ],
      );
      expect(find.text("Record your loan's opening balance"), findsOneWidget);
      expect(find.textContaining('50,000'), findsOneWidget);
      await tester.tap(find.text('Record opening balance'));
      expect(opened, 1);
    });

    testWidgets('a loan still owed shows no prompt', (tester) async {
      await _pump(
        tester,
        BooksLoanOpeningPrompt(onRecord: () {}),
        overrides: [
          accountingAccountsProvider.overrideWithValue([_loan(120000)]),
        ],
      );
      expect(find.text("Record your loan's opening balance"), findsNothing);
    });
  });

  group('booksVatPositionProvider', () {
    test('passes the service answer through', () async {
      final container = ProviderContainer(
        overrides: [
          accountingBusinessIdProvider.overrideWithValue('biz'),
          vatPositionServiceProvider.overrideWithValue(
            _FakeVatPositionService(value: _notRegistered),
          ),
        ],
      );
      addTearDown(container.dispose);
      final sub = container.listen(booksVatPositionProvider, (_, _) {});
      addTearDown(sub.close);
      expect(
        await container.read(booksVatPositionProvider.future),
        same(_notRegistered),
      );
    });

    test(
      'a failure reads as unknown, so bills keep booking VAT as before',
      () async {
        final container = ProviderContainer(
          overrides: [
            accountingBusinessIdProvider.overrideWithValue('biz'),
            vatPositionServiceProvider.overrideWithValue(
              _FakeVatPositionService(error: Exception('offline')),
            ),
          ],
        );
        addTearDown(container.dispose);
        final sub = container.listen(booksVatPositionProvider, (_, _) {});
        addTearDown(sub.close);
        expect(await container.read(booksVatPositionProvider.future), isNull);
      },
    );
  });

  group('setBooksVatRegisteredProvider', () {
    test(
      'writes the setting to as_<businessId> and re-reads the position',
      () async {
        final ditto = _SettingsDitto();
        final service = _CountingVatPositionService();
        final container = ProviderContainer(
          overrides: [
            accountingBusinessIdProvider.overrideWithValue('biz'),
            accountingSettingsStoreProvider.overrideWithValue(
              AccountingSettingsStore(ditto),
            ),
            vatPositionServiceProvider.overrideWithValue(service),
          ],
        );
        addTearDown(container.dispose);
        final sub = container.listen(booksVatPositionProvider, (_, _) {});
        addTearDown(sub.close);
        await container.read(booksVatPositionProvider.future);
        expect(service.reads, 1);

        await container.read(setBooksVatRegisteredProvider)(true);

        final doc = ditto.writes['accounting_settings/as_biz']!;
        expect(doc['vatRegistered'], isTrue);
        expect(doc['businessId'], 'biz');
        await container.read(booksVatPositionProvider.future);
        expect(service.reads, 2);
      },
    );

    test(
      'a failed save leaves the position alone and reaches the caller',
      () async {
        final service = _CountingVatPositionService();
        final container = ProviderContainer(
          overrides: [
            accountingBusinessIdProvider.overrideWithValue('biz'),
            accountingSettingsStoreProvider.overrideWithValue(
              AccountingSettingsStore(FakeAccountingDittoStore(ready: false)),
            ),
            vatPositionServiceProvider.overrideWithValue(service),
          ],
        );
        addTearDown(container.dispose);
        final sub = container.listen(booksVatPositionProvider, (_, _) {});
        addTearDown(sub.close);
        await container.read(booksVatPositionProvider.future);
        await expectLater(
          container.read(setBooksVatRegisteredProvider)(true),
          throwsStateError,
        );
        await container.read(booksVatPositionProvider.future);
        expect(service.reads, 1);
      },
    );

    test('the default store is backed by the app Ditto service', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      expect(
        container.read(accountingSettingsStoreProvider),
        isA<AccountingSettingsStore>(),
      );
    });
  });

  group('VatPositionService', () {
    test('reads the position from the connector', () async {
      late Uri asked;
      final service = VatPositionService(
        baseUrl: 'http://connector.test',
        client: MockClient((request) async {
          asked = request.url;
          return http.Response(
            jsonEncode({
              'registered': false,
              'hasEbmBranch': false,
              'settingRegistered': false,
              'annualThreshold': 20000000,
              'quarterThreshold': 5000000,
              'position': {'turnover12m': 17000000, 'threshold': 'near'},
            }),
            200,
          );
        }),
      );
      final p = await service.position();
      expect(
        asked.toString(),
        'http://connector.test/api/accounting/vat-position',
      );
      expect(p?.threshold, VatThreshold.near);
      expect(p?.turnover12m, 17000000);
    });

    test('the app provider builds the connector-backed service', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      expect(
        container.read(vatPositionServiceProvider),
        isA<VatPositionService>(),
      );
    });

    test('any other status reads as unknown', () async {
      final service = VatPositionService(
        baseUrl: 'http://connector.test',
        client: MockClient((_) async => http.Response('nope', 401)),
      );
      expect(await service.position(), isNull);
    });
  });
}
