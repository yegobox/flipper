import 'package:flipper_dashboard/features/kitchen_display/providers/transaction_items_provider.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flutter_test/flutter_test.dart';

ITransaction _ticket({
  DateTime? updatedAt,
  DateTime? lastTouched,
  double? subTotal,
}) => ITransaction(
  id: 't1',
  branchId: 'b1',
  agentId: 'a1',
  status: 'parked',
  transactionType: 'Sale',
  paymentType: 'Cash',
  cashReceived: 0,
  customerChangeDue: 0,
  updatedAt: updatedAt,
  lastTouched: lastTouched,
  subTotal: subTotal,
  isIncome: true,
  isExpense: false,
);

void main() {
  final t0 = DateTime.utc(2026, 9, 25, 12);

  test(
    'same ticket state gives the same key (the cached lines are reused)',
    () {
      expect(
        kitchenTicketItemsKey(
          't1',
          _ticket(updatedAt: t0, lastTouched: t0, subTotal: 5000),
        ),
        kitchenTicketItemsKey(
          't1',
          _ticket(updatedAt: t0, lastTouched: t0, subTotal: 5000),
        ),
      );
    },
  );

  test('a park, a cart delta or a new total each change the key', () {
    final base = kitchenTicketItemsKey(
      't1',
      _ticket(updatedAt: t0, lastTouched: t0, subTotal: 5000),
    );
    final later = t0.add(const Duration(minutes: 1));
    for (final changed in [
      _ticket(updatedAt: later, lastTouched: t0, subTotal: 5000),
      _ticket(updatedAt: t0, lastTouched: later, subTotal: 5000),
      _ticket(updatedAt: t0, lastTouched: t0, subTotal: 8000),
    ]) {
      expect(kitchenTicketItemsKey('t1', changed), isNot(base));
    }
  });

  test('no ticket loaded yet keys on the id alone', () {
    expect(kitchenTicketItemsKey('t1', null), (id: 't1', rev: null));
  });
}
