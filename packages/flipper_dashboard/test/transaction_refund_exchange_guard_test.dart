import 'package:flipper_dashboard/services/sale_exchange_service.dart';
import 'package:flipper_dashboard/services/transaction_refund_service.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:talker_flutter/talker_flutter.dart';

class _Exchanges extends SaleExchangeService {
  _Exchanges(this.answer);

  /// What [hasExchanges] answers; an [Exception] is thrown instead.
  final Object answer;

  @override
  Future<bool> hasExchanges(ITransaction original) async {
    final a = answer;
    if (a is bool) return a;
    throw a;
  }
}

ITransaction _sale() => ITransaction(
  branchId: 'b1',
  status: 'completed',
  transactionType: 'Sale',
  receiptType: 'NS',
  paymentType: 'CASH',
  subTotal: 1000,
  cashReceived: 1000,
  customerChangeDue: 0,
  updatedAt: DateTime.utc(2026, 10, 18),
  isIncome: true,
  isExpense: false,
  agentId: 'a1',
);

TransactionRefundService _service(Object answer) =>
    TransactionRefundService(talker: Talker(), exchange: _Exchanges(answer));

Matcher _blockedWith(String message) => throwsA(
  isA<TransactionRefundException>().having(
    (e) => e.message,
    'message',
    message,
  ),
);

void main() {
  final l10n = FlipperL10n.current;

  test('a sale without exchanges can be refunded', () async {
    await _service(false).rejectIfExchanged(_sale());
  });

  test('a sale with exchanges cannot be refunded', () {
    expect(
      _service(true).rejectIfExchanged(_sale()),
      _blockedWith(l10n.refundBlockedAfterExchange),
    );
  });

  test('a failed exchange lookup blocks the refund', () {
    expect(
      _service(StateError('ditto down')).rejectIfExchanged(_sale()),
      _blockedWith(l10n.refundExchangeCheckFailed),
    );
  });
}
