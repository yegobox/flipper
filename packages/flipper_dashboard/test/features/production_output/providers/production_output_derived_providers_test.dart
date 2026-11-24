import 'package:flipper_dashboard/features/production_output/providers/production_output_derived_providers.dart';
import 'package:flipper_models/providers/production_output_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_models/brick/models/actual_output.model.dart';
import 'package:supabase_models/brick/models/work_order.model.dart';

// flutter test test/features/production_output/providers/production_output_derived_providers_test.dart --dart-define=FLUTTER_TEST_ENV=true
//
// The cards counted every order ever while the list showed only today's, and
// an order's output total was whatever the last till wrote.

final _today = localDay(DateTime.now());

WorkOrder _order(
  String id, {
  required DateTime target,
  double planned = 10,
  double actual = 0,
  String status = 'planned',
}) => WorkOrder(
  id: id,
  branchId: 'b1',
  businessId: 'biz1',
  variantId: 'v-$id',
  variantName: id,
  plannedQuantity: planned,
  actualQuantity: actual,
  targetDate: target.add(const Duration(hours: 9)),
  status: status,
);

ActualOutput _output(
  String workOrderId,
  double qty, {
  String? reason,
  DateTime? recordedAt,
}) => ActualOutput(
  workOrderId: workOrderId,
  branchId: 'b1',
  actualQuantity: qty,
  userId: 'u1',
  varianceReason: reason,
  recordedAt: recordedAt,
);

void main() {
  final yesterday = _today.subtract(const Duration(days: 1));
  final tomorrow = _today.add(const Duration(days: 1));

  group('withOutputTotals', () {
    test('two tills overwrote each other: the records win', () {
      // Till A saved 5, till B saved 7 without seeing A's: the order says 7.
      final orders = [_order('a', target: _today, actual: 7)];
      final result = withOutputTotals(orders, [
        _output('a', 5),
        _output('a', 7),
      ]);
      expect(result.single.actualQuantity, 12);
    });

    test('records not synced yet: the saved total wins', () {
      final orders = [_order('a', target: _today, actual: 20)];
      final result = withOutputTotals(orders, [_output('a', 5)]);
      expect(result.single.actualQuantity, 20);
    });

    test('an order with no records keeps its saved total', () {
      final orders = [_order('a', target: _today, actual: 3)];
      expect(
        withOutputTotals(orders, [_output('b', 9)]).single.actualQuantity,
        3,
      );
      expect(withOutputTotals(orders, const []), same(orders));
    });
  });

  group('ordersForDay', () {
    final orders = [
      _order('due-today', target: _today),
      _order('late-open', target: yesterday, status: 'in_progress'),
      _order('older-open', target: yesterday.subtract(const Duration(days: 3))),
      _order('late-done', target: yesterday, status: 'completed'),
      _order('late-cancelled', target: yesterday, status: 'cancelled'),
      _order('tomorrow', target: tomorrow),
    ];

    test('today: due today, plus earlier unfinished orders oldest first', () {
      final day = ordersForDay(orders, day: _today, today: _today);
      expect(day.due.map((o) => o.id), ['due-today']);
      expect(day.carriedOver.map((o) => o.id), ['older-open', 'late-open']);
    });

    test('another day shows only its own orders', () {
      final next = ordersForDay(orders, day: tomorrow, today: _today);
      expect(next.due.map((o) => o.id), ['tomorrow']);
      expect(next.carriedOver, isEmpty);

      final past = ordersForDay(orders, day: yesterday, today: _today);
      expect(past.due.map((o) => o.id), [
        'late-open',
        'late-done',
        'late-cancelled',
      ]);
      expect(past.carriedOver, isEmpty);
    });
  });

  group('providers', () {
    ProviderContainer container({
      required List<WorkOrder> orders,
      required List<ActualOutput> outputs,
    }) {
      final c = ProviderContainer(
        overrides: [
          workOrdersStreamProvider.overrideWith((ref) => Stream.value(orders)),
          actualOutputsStreamProvider.overrideWith(
            (ref) => Stream.value(outputs),
          ),
        ],
      );
      addTearDown(c.dispose);
      return c;
    }

    Future<void> settle(ProviderContainer c) async {
      await c.read(workOrdersStreamProvider.future);
      await c.read(actualOutputsStreamProvider.future);
    }

    test('the cards count only the day\'s orders, with record totals', () async {
      final c = container(
        orders: [
          _order('today', target: _today, planned: 10, actual: 4),
          _order('late', target: yesterday, planned: 50, status: 'in_progress'),
          _order(
            'old',
            target: yesterday,
            planned: 99,
            actual: 99,
            status: 'completed',
          ),
        ],
        outputs: [
          _output('today', 4, reason: 'machine'),
          _output('today', 3),
          // Reasons follow the day the output was recorded, as the email does.
          _output('late', 8, reason: 'labor'),
          _output(
            'old',
            99,
            reason: 'quality',
            recordedAt: yesterday.add(const Duration(hours: 10)),
          ),
        ],
      );
      c.listen(productionSummaryProvider, (_, _) {});
      await settle(c);

      final summary = c.read(productionSummaryProvider).requireValue;
      expect(summary.totalOrders, 1);
      expect(summary.totalPlanned, 10);
      expect(summary.totalActual, 7);
      expect(summary.varianceByReason['machine'], 1);
      expect(summary.varianceByReason['labor'], 1);
      expect(summary.varianceByReason['quality'], 0);

      final day = c.read(productionDayOrdersProvider).requireValue;
      expect(day.due.map((o) => o.id), ['today']);
      expect(day.carriedOver.map((o) => o.id), ['late']);
    });

    test('moving the day moves the cards and the chart with it', () async {
      final c = container(
        orders: [
          _order('today', target: _today, planned: 10),
          _order('tomorrow', target: tomorrow, planned: 30),
        ],
        outputs: const [],
      );
      c.listen(productionSummaryProvider, (_, _) {});
      c.listen(varianceChartDataProvider, (_, _) {});
      await settle(c);

      c.read(productionDayProvider.notifier).state = tomorrow;

      expect(c.read(productionSummaryProvider).requireValue.totalPlanned, 30);
      final chart = c.read(varianceChartDataProvider).requireValue;
      expect(chart.last.date, tomorrow);
      expect(chart.last.planned, 30);
    });
  });
}
