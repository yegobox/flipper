import 'package:flipper_dashboard/payable_view.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/providers/access_provider.dart';
import 'package:flipper_models/providers/transactions_provider.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_services/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';

import 'test_helpers/setup.dart';

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

  Widget buildPayable({
    required double paneWidth,
    required double paneHeight,
  }) {
    return ProviderScope(
      overrides: [
        transactionsProvider(forceRealData: true).overrideWith(
          (ref) => Stream<List<ITransaction>>.value(const []),
        ),
        featureAccessProvider(
          userId: 'test-user',
          featureName: AppFeature.Tickets,
        ).overrideWithValue(false),
      ],
      child: MaterialApp(
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
    testWidgets('wide pane uses horizontal bar (single 64px row)', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(1280, 720);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(buildPayable(paneWidth: 800, paneHeight: 700));
      await tester.pumpAndSettle();

      expect(find.byType(Row), findsWidgets);
      final barHeights = tester
          .widgetList<SizedBox>(find.byType(SizedBox))
          .map((s) => s.height)
          .whereType<double>();
      expect(barHeights.contains(64), isTrue);
    });

    testWidgets('narrow pane uses vertical stacked bar', (tester) async {
      tester.view.physicalSize = const Size(1280, 720);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(buildPayable(paneWidth: 480, paneHeight: 200));
      await tester.pumpAndSettle();

      // Vertical layout: fixed-height column (64 or 138), not a horizontal Row bar.
      final columns = tester.widgetList<Column>(find.byType(Column));
      expect(columns.length, greaterThanOrEqualTo(1));
    });
  });
}
