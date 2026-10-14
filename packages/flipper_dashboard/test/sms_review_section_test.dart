import 'dart:async';

import 'package:flipper_dashboard/features/admin/widgets/sms_bridge_page.dart';
import 'package:flipper_dashboard/widgets/sms_review/sms_review_section.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_models/db_model_export.dart'
    show Category, ITransaction;
import 'package:flipper_models/providers/category_provider.dart';
import 'package:flipper_models/providers/transactions_provider.dart'
    show cashbookRecentTransactionsProvider;
import 'package:flipper_models/sms_bridge_client.dart';
import 'package:flipper_models/sms_review/sms_review_item.dart';
import 'package:flipper_models/sms_review/sms_review_providers.dart';
import 'package:flipper_models/sms_review/sms_review_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class _Store implements SmsReviewStore {
  final statuses = <String, String>{};
  final matched = <String, String>{};

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
  Future<void> matchBankLine(String bankLineId, String journalEntryId) async =>
      matched[bankLineId] = journalEntryId;
}

SmsReviewItem _item({String kind = 'principal', String? suggested}) =>
    SmsReviewItem.fromDitto({
      '_id': kind == 'fee' ? 'sms-fee' : 'sms-1',
      'businessId': 'biz',
      'branchId': 'br',
      'kind': kind,
      'direction': 'debit',
      'amount': kind == 'fee' ? 20 : 2000,
      'description': kind == 'fee'
          ? 'BK · charge · FTCMTEST'
          : 'BK · to Jane DOE · FTCMTEST',
      'providerLabel': 'BK',
      'paymentType': 'BANK TRANSFER',
      'bankAccountCode': '1020',
      'occurredAt': '2026-10-14T09:29:21',
      'lineDate': '2026-10-14',
      'status': 'pending_review',
      'bankLineId': 'line-$kind',
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
  late List<(SmsReviewItem, String?)> recorded;

  List<Override> reviewOverrides(
    List<SmsReviewItem> items, {
    List<Category>? cats,
  }) {
    store = _Store();
    recorded = [];
    return [
      smsReviewBranchIdProvider.overrideWithValue('br'),
      smsReviewItemsProvider('br').overrideWith((ref) => Stream.value(items)),
      categoryProvider.overrideWith(
        (ref) => Stream.value(cats ?? const <Category>[]),
      ),
      smsReviewServiceProvider.overrideWithValue(
        SmsReviewService(
          store: store,
          journalEntryId: (b, t) => 'je_${b}_${t}_sale',
          recordMovement:
              ({
                required item,
                required categoryId,
                required categoryName,
              }) async {
                recorded.add((item, categoryId));
                return 'txn-1';
              },
        ),
      ),
    ];
  }

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
    await tester.tap(find.byKey(const Key('sms_review_confirm')));
    await tester.pumpAndSettle();

    expect(recorded, hasLength(1));
    expect(recorded.single.$1.amount, 2000);
    expect(store.statuses['sms-1'], SmsReviewItem.confirmed);
    expect(store.matched, {'line-principal': 'je_biz_txn-1_sale'});
    expect(find.text('Added to the Cash Book'), findsOneWidget);
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

    await tester.tap(find.byKey(const Key('sms_review_confirm')));
    await tester.pumpAndSettle();
    expect(recorded.single.$2, 'cat-fees');
  });

  testWidgets('ignore closes the item without recording', (tester) async {
    await tester.pumpWidget(
      _app(SmsReviewDetail(item: _item()), reviewOverrides(const [])),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('sms_review_ignore')));
    await tester.pumpAndSettle();
    expect(recorded, isEmpty);
    expect(store.statuses['sms-1'], SmsReviewItem.ignored);
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
}
