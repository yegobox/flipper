import 'package:flipper_dashboard/features/production_output/models/production_output_models.dart';
import 'package:flipper_dashboard/features/production_output/providers/production_output_derived_providers.dart';
import 'package:flipper_dashboard/features/production_output/screens/production_output_screen.dart';
import 'package:flipper_dashboard/features/production_output/services/production_output_service.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_models/brick/models/actual_output.model.dart';
import 'package:supabase_models/brick/models/work_order.model.dart';

// flutter test test/features/production_output/screens/production_output_screen_test.dart --dart-define=FLUTTER_TEST_ENV=true
//
// The screen passes the tapped order to the service and tells the cashier
// what happened after the output is saved: a stock failure is an error (do
// not record again), an RRA failure only a warning.

/// Records what the screen asked for; answers with the given messages.
class _FakeService extends ProductionOutputService {
  _FakeService({this.stockError, this.rraMessage});

  final String? stockError;
  final String? rraMessage;
  final List<WorkOrder> started = [];
  final List<double> recorded = [];

  @override
  Future<void> startWorkOrder(WorkOrder workOrder) async =>
      started.add(workOrder);

  @override
  Future<({ActualOutput? output, String? rraMessage, String? stockError})>
  recordActualOutput({
    required WorkOrder workOrder,
    required double actualQuantity,
    String? varianceReason,
    String? notes,
  }) async {
    recorded.add(actualQuantity);
    return (
      output: ActualOutput(
        workOrderId: workOrder.id,
        branchId: workOrder.branchId,
        actualQuantity: actualQuantity,
        userId: 'u1',
      ),
      rraMessage: rraMessage,
      stockError: stockError,
    );
  }
}

WorkOrder _order() => WorkOrder(
  // UUID-length: the table shows the first 8 characters.
  id: 'a1b2c3d4-0000-4000-8000-000000000001',
  branchId: 'b1',
  businessId: 'biz1',
  variantId: 'bread-v',
  variantName: 'Bread',
  plannedQuantity: 20,
  targetDate: DateTime(2026, 11, 23),
  status: 'planned',
);

void main() {
  Future<void> pumpScreen(WidgetTester tester, _FakeService service) async {
    tester.view.physicalSize = const Size(1600, 1200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          productionDayOrdersProvider.overrideWithValue(
            AsyncData(ProductionDayOrders(due: [_order()], carriedOver: [])),
          ),
          productionSummaryProvider.overrideWithValue(
            const AsyncData(ProductionSummary.empty),
          ),
          varianceChartDataProvider.overrideWithValue(
            const AsyncData(<VarianceDataPoint>[]),
          ),
        ],
        child: MaterialApp(
          localizationsDelegates: FlipperLocalizationDelegates.delegates,
          supportedLocales: FlipperLocalizationDelegates.supportedLocales,
          home: ProductionOutputScreen(service: service),
        ),
      ),
    );
    await tester.pump();
  }

  Future<void> recordTwenty(WidgetTester tester) async {
    await tester.tap(find.byTooltip('Record Output'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), '20');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Record'));
    await tester.pumpAndSettle();
  }

  testWidgets('Start passes the tapped order once confirmed', (tester) async {
    final service = _FakeService();
    await pumpScreen(tester, service);

    await tester.tap(find.byTooltip('Start'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ElevatedButton, 'Start'));
    await tester.pumpAndSettle();

    expect(service.started.single.variantId, 'bread-v');
  });

  testWidgets('a stock failure after saving is shown as an error', (
    tester,
  ) async {
    const stockError = 'Output saved, but stock was not updated';
    final service = _FakeService(stockError: stockError, rraMessage: 'RRA');
    await pumpScreen(tester, service);

    await recordTwenty(tester);

    expect(service.recorded, [20]);
    expect(find.text(stockError), findsOneWidget);
    expect(find.text('RRA'), findsNothing);
  });

  testWidgets('an RRA failure is shown as a warning', (tester) async {
    final service = _FakeService(rraMessage: 'tax server down');
    await pumpScreen(tester, service);

    await recordTwenty(tester);

    expect(service.recorded, [20]);
    expect(find.text('tax server down'), findsOneWidget);
  });
}
