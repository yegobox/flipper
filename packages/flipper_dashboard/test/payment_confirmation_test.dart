import 'package:flipper_dashboard/payment_confirmation.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:flipper_services/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stacked_services/stacked_services.dart';

import 'test_helpers/setup.dart';

class _MockRouterService extends Mock implements RouterService {}

final _sale = ITransaction(
  id: 'txn-1',
  branchId: 'branch-1',
  status: COMPLETE,
  transactionType: 'sale',
  paymentType: 'MTN MOMO',
  cashReceived: 1500,
  customerChangeDue: 0,
  updatedAt: DateTime.utc(2026, 11, 13),
  isIncome: true,
  isExpense: false,
  agentId: 'agent-test',
  subTotal: 1500,
);

void main() {
  late TestEnvironment env;

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
    if (locator.isRegistered<RouterService>()) {
      locator.unregister<RouterService>();
    }
    locator.registerSingleton<RouterService>(_MockRouterService());
  });

  tearDown(() {
    if (locator.isRegistered<RouterService>()) {
      locator.unregister<RouterService>();
    }
  });

  testWidgets('the app bar names how the sale was paid', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          // A historical sale: the live stream is empty, so the screen falls
          // back to the transaction it was opened with.
          currentTransactionsByIdStream(
            _sale.id,
          ).overrideWith((ref) => Stream<List<ITransaction>>.value(const [])),
        ],
        child: MaterialApp(
          locale: const Locale('en'),
          localizationsDelegates:
              FlipperAppLocalizations.localizationsDelegates,
          supportedLocales: FlipperAppLocalizations.supportedLocales,
          home: PaymentConfirmation(transaction: _sale),
        ),
      ),
    );
    await tester.pump();

    expect(find.text('Payment: MTN MOMO'), findsOneWidget);
  });
}
