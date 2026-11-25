import 'package:flipper_analytics/flipper_analytics.dart';
import 'package:flipper_dashboard/cashbook.dart';
import 'package:flipper_dashboard/cashbook_form_rules.dart';
import 'package:flipper_dashboard/widgets/sms_review/sms_review_section.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/providers/category_provider.dart';
import 'package:flipper_models/providers/transactions_provider.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_web/core/analytics/analytics_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';

import 'test_helpers/setup.dart';

/// Keeps each tracked event's name and properties.
class _Tracked implements ProductAnalytics {
  final events = <(String, Map<String, Object?>)>[];

  @override
  Future<void> track(
    String eventName, {
    Map<String, Object?> properties = const {},
  }) async => events.add((eventName, properties));

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

/// Saving a Cash Out in the Cash Book is the app's main way to record an
/// expense; PostHog's funnels need it as `expense_recorded`.
void main() {
  late TestEnvironment env;
  late _Tracked analytics;
  late bool saveFails;

  final rent = Category(id: 'cat-rent', name: 'Rent', branchId: '1');

  setUpAll(() async {
    env = TestEnvironment();
    await env.init();
  });

  tearDownAll(() async {
    await env.dispose();
  });

  setUp(() {
    env.injectMocks();
    env.stubCommonMethods();
    analytics = _Tracked();
    saveFails = false;
    final box = env.mockBox;
    when(() => box.isProformaMode()).thenReturn(false);
    when(() => box.isTrainingMode()).thenReturn(false);
    when(() => box.readString(key: any(named: 'key'))).thenReturn(null);
    // The last Cash Out category is preselected on the form.
    when(
      () => box.readString(key: cashbookLastCategoryOutKey),
    ).thenReturn(rent.id);
    when(
      () => box.writeString(
        key: any(named: 'key'),
        value: any(named: 'value'),
      ),
    ).thenAnswer((_) async {});
    when(
      () => env.mockDbSync.completeCashMovement(
        branchId: any(named: 'branchId'),
        bhfId: any(named: 'bhfId'),
        cashReceived: any(named: 'cashReceived'),
        isIncome: any(named: 'isIncome'),
        utilityVariantName: any(named: 'utilityVariantName'),
        paymentType: any(named: 'paymentType'),
        discount: any(named: 'discount'),
        countryCode: any(named: 'countryCode'),
        isProformaMode: any(named: 'isProformaMode'),
        isTrainingMode: any(named: 'isTrainingMode'),
        transactionTypeForRecord: any(named: 'transactionTypeForRecord'),
        categoryId: any(named: 'categoryId'),
        note: any(named: 'note'),
        skipPersonalGoalAutoSweep: any(named: 'skipPersonalGoalAutoSweep'),
      ),
    ).thenAnswer((inv) async {
      if (saveFails) throw StateError('Ditto unavailable');
      return ITransaction(
        id: 'cash-out-1',
        agentId: 'agent-1',
        branchId: '1',
        status: COMPLETE,
        transactionType: rent.name!,
        paymentType: inv.namedArguments[#paymentType] as String,
        cashReceived: inv.namedArguments[#cashReceived] as double,
        customerChangeDue: 0,
        updatedAt: DateTime.utc(2026),
        isIncome: false,
        isExpense: true,
      );
    });
  });

  tearDown(() => env.restore());

  Future<void> saveCashOut(WidgetTester tester) async {
    // Phone width: wider screens squeeze the success toast between big margins.
    tester.view.physicalSize = const Size(500, 1400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          optionalProductAnalyticsProvider.overrideWithValue(analytics),
          cashbookRecentTransactionsProvider.overrideWith(
            (ref) => Stream.value(const <ITransaction>[]),
          ),
          categoryProvider.overrideWith((ref) => Stream.value([rent])),
          // No SMS Bridge paired: the review banner stays hidden.
          smsReviewBranchIdProvider.overrideWithValue(''),
        ],
        child: MaterialApp(
          locale: const Locale('en'),
          localizationsDelegates: FlipperLocalizationDelegates.delegates,
          supportedLocales: FlipperLocalizationDelegates.supportedLocales,
          home: const Cashbook(isBigScreen: false),
        ),
      ),
    );
    await tester.pump();
    await tester.pump();

    await tester.tap(find.text('Cash out').last);
    await tester.pump();
    await tester.pump();

    await tester.enterText(find.byType(TextFormField).first, '15000');
    await tester.pump();

    await tester.tap(find.text('Save cash out'));
    // The save, its success toast and the post-frame refreshes.
    for (var i = 0; i < 5; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }
    // Let the toast time out so no timer is left pending.
    await tester.pump(const Duration(seconds: 5));
  }

  testWidgets('a saved Cash Out sends expense_recorded, with no amount or '
      'category name', (tester) async {
    await saveCashOut(tester);

    expect(analytics.events, hasLength(1));
    expect(analytics.events.single.$1, AnalyticsEvents.expenseRecorded);
    expect(analytics.events.single.$2, {
      'source': 'cashbook',
      'surface': 'cashbook',
      'category_type': 'suggested',
      'payment_method': cashbookMethodCash,
    });
  });

  testWidgets('a Cash Out that failed to save sends nothing', (tester) async {
    saveFails = true;

    await saveCashOut(tester);

    expect(analytics.events, isEmpty);
  });
}
