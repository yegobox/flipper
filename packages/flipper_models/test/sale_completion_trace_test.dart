import 'package:flipper_models/helpers/sale_completion_trace.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  tearDown(SaleCompletionTrace.end);

  test('summary lists stages in the order they finished', () {
    final trace = SaleCompletionTrace.begin();
    trace.record('cart_settle', 1200);
    trace.record('rra_sign', 9800);
    trace.record('present_receipt', 400);

    expect(
      trace.summary(),
      'cart_settle=1200 rra_sign=9800 present_receipt=400',
    );
  });

  test('summary drops stages too small to explain an overrun', () {
    final trace = SaleCompletionTrace.begin();
    trace.record('cashier_lookup', 3);
    trace.record('rra_sign', 9800);

    expect(trace.summary(), 'rra_sign=9800');
    expect(trace.summary(minMs: 0), 'cashier_lookup=3 rra_sign=9800');
  });

  test('stages recorded outside a flow are dropped, not attributed', () {
    SaleCompletionTrace.begin();
    SaleCompletionTrace.end();

    // The deferred stock/receipt work logs after the operator is free.
    logSaleCompletionStage('deferred_stock_deduction', 4000);

    expect(SaleCompletionTrace.current, isNull);
  });

  test('a new sale does not inherit the stages of one that threw', () {
    SaleCompletionTrace.begin().record('rra_sign', 9800);

    final next = SaleCompletionTrace.begin();

    expect(next.summary(), isEmpty);
    expect(SaleCompletionTrace.current, same(next));
  });

  test('logSaleCompletionStage records onto the active trace', () {
    final trace = SaleCompletionTrace.begin();

    logSaleCompletionStage('present_receipt', 10000, extra: 'copies=1');

    expect(trace.summary(), 'present_receipt=10000');
  });

  test('a runaway flow cannot grow the trace without bound', () {
    final trace = SaleCompletionTrace.begin();
    for (var i = 0; i < 200; i++) {
      trace.record('stage$i', 1000);
    }

    expect(trace.summary().split(' ').length, 64);
  });
}
