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
      matches(
        RegExp(
          r'^cart_settle=1200@\d+ rra_sign=9800@\d+ present_receipt=400@\d+$',
        ),
      ),
    );
  });

  test('every stage carries when it finished, so a gap is visible', () async {
    final trace = SaleCompletionTrace.begin();
    trace.record('cart_settle', 5);
    await Future<void>.delayed(const Duration(milliseconds: 40));
    trace.record('mark_completed_tx', 5);

    final at = RegExp(r'@(\d+)')
        .allMatches(trace.summary(minMs: 0))
        .map((m) => int.parse(m.group(1)!))
        .toList();

    expect(at, hasLength(2));
    // The second stage took 5ms but landed ~40ms later: the flow spent that
    // time somewhere nobody has timed yet.
    expect(at[1] - at[0], greaterThanOrEqualTo(30));
  });

  test('summary drops stages too small to explain an overrun', () {
    final trace = SaleCompletionTrace.begin();
    trace.record('cashier_lookup', 3);
    trace.record('rra_sign', 9800);

    expect(trace.summary(), matches(RegExp(r'^rra_sign=9800@\d+$')));
    expect(trace.summary(minMs: 0), contains('cashier_lookup=3@'));
  });

  test('notes name the branch the sale took, once each', () {
    final trace = SaleCompletionTrace.begin();
    trace.record('rra_sign', 9800);
    trace.note('branch=defer_for_review');
    trace.note('branch=defer_for_review');

    expect(trace.summary(), endsWith('branch=defer_for_review'));
    expect(
      'branch=defer_for_review'.allMatches(trace.summary()).length,
      1,
    );
  });

  test('stages recorded outside a flow are dropped, not attributed', () {
    SaleCompletionTrace.begin();
    SaleCompletionTrace.end();

    // The deferred stock/receipt work logs after the operator is free.
    logSaleCompletionStage('deferred_stock_deduction', 4000);

    expect(SaleCompletionTrace.current, isNull);
  });

  test('a new sale does not inherit the stages of one that threw', () {
    SaleCompletionTrace.begin()
      ..record('rra_sign', 9800)
      ..note('branch=tax_receipt');

    final next = SaleCompletionTrace.begin();

    expect(next.summary(), isEmpty);
    expect(SaleCompletionTrace.current, same(next));
  });

  test('logSaleCompletionStage records onto the active trace', () {
    final trace = SaleCompletionTrace.begin();

    logSaleCompletionStage('present_receipt', 10000, extra: 'copies=1');

    expect(trace.summary(), startsWith('present_receipt=10000@'));
  });

  test('a runaway flow cannot grow the trace without bound', () {
    final trace = SaleCompletionTrace.begin();
    for (var i = 0; i < 200; i++) {
      trace.record('stage$i', 1000);
    }
    for (var i = 0; i < 40; i++) {
      trace.note('note$i');
    }

    expect(trace.summary().split(' ').length, 64 + 8);
  });
}
