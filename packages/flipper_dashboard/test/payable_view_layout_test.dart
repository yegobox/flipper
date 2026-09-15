import 'package:flipper_dashboard/payable_view.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/providers/access_provider.dart';
import 'package:flipper_models/providers/tickets_provider.dart';
import 'package:flipper_models/providers/transactions_provider.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flutter/material.dart';
import 'package:flipper_dashboard/theme/pos_tokens.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';

import 'test_helpers/setup.dart';

/// [PayableView] stacked bar: Tickets row + 8px gap + Pay row.
const double _stackedBarHeight = PosTokens.payButtonHeight * 2 + 8;

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
    when(() => env.mockBox.getUserId()).thenReturn('test-user');
  });

  tearDown(() {
    env.restore();
  });

  Widget buildPayable({required double paneWidth, required double paneHeight}) {
    return ProviderScope(
      overrides: [
        transactionsProvider(
          forceRealData: true,
        ).overrideWith((ref) => Stream<List<ITransaction>>.value(const [])),
        // Show the Tickets button so the single-row and stacked layouts
        // produce different bar heights.
        featureAccessProvider(
          userId: 'test-user',
          featureName: AppFeature.Tickets,
        ).overrideWithValue(true),
        // Tickets badge reads a Ditto stream via ProxyService.getStrategy,
        // which the mock strategy does not wire; the layout under test does
        // not depend on the count.
        pendingTillTicketsCountProvider.overrideWithValue(0),
      ],
      child: MaterialApp(
        locale: const Locale('en'),
        localizationsDelegates: FlipperAppLocalizations.localizationsDelegates,
        supportedLocales: FlipperAppLocalizations.supportedLocales,
        home: Scaffold(
          body: Center(
            child: SizedBox(
              width: paneWidth,
              height: paneHeight,
              child: PayableView(
                ticketHandler: () {},
                model: CoreViewModel(),
                transactionId: 'txn-1',
                mode: SellingMode.forSelling,
                digitalPaymentEnabled: false,
              ),
            ),
          ),
        ),
      ),
    );
  }

  group('PayableView pane constraints', () {
    testWidgets('wide pane uses horizontal bar (single pay-height row)', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(1280, 720);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      // Same width the fixed desktop cart column gives the bar (400px column
      // minus PayableView.outerPadding) — must stay a single row.
      await tester.pumpWidget(buildPayable(paneWidth: 376, paneHeight: 700));
      await tester.pumpAndSettle();

      expect(find.byType(Row), findsWidgets);
      final barHeights = tester
          .widgetList<SizedBox>(find.byType(SizedBox))
          .map((s) => s.height)
          .whereType<double>();
      expect(barHeights.contains(PosTokens.payButtonHeight), isTrue);
      // Not the stacked variant (Tickets row + gap + Pay row).
      expect(barHeights.contains(_stackedBarHeight), isFalse);
    });

    testWidgets('narrow pane uses vertical stacked bar', (tester) async {
      tester.view.physicalSize = const Size(1280, 720);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(buildPayable(paneWidth: 340, paneHeight: 200));
      await tester.pumpAndSettle();

      // Vertical layout: fixed-height column, not a horizontal Row bar.
      final barHeights = tester
          .widgetList<SizedBox>(find.byType(SizedBox))
          .map((s) => s.height)
          .whereType<double>();
      expect(barHeights.contains(_stackedBarHeight), isTrue);
    });
  });
}
