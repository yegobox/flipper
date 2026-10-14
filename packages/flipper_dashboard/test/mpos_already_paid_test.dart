import 'package:flipper_dashboard/utils/mpos_helpers.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_services/constants.dart';
import 'package:flutter_test/flutter_test.dart';

ITransaction _ticket({bool loan = false, double cashReceived = 0}) =>
    ITransaction(
      id: 't1',
      branchId: 'b1',
      status: PENDING,
      transactionType: 'sale',
      paymentType: 'CASH',
      cashReceived: cashReceived,
      customerChangeDue: 0,
      updatedAt: DateTime.utc(2026, 1, 1),
      isIncome: true,
      isExpense: false,
      isLoan: loan,
      subTotal: 1000,
    );

void main() {
  test('an unread payment counts as nothing paid outside loans', () {
    expect(mposAlreadyPaid(_ticket(cashReceived: 400), null), 0);
  });

  test('a loan never drops below what was already received', () {
    final loan = _ticket(loan: true, cashReceived: 400);
    expect(mposAlreadyPaid(loan, null), 400);
    expect(mposAlreadyPaid(loan, 250), 400);
    expect(mposAlreadyPaid(loan, 600), 600);
  });
}
