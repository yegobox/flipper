import 'package:flipper_models/helperModels/sale_completion_helpers.dart';
import 'package:flipper_services/payment_methods.dart';
import 'package:flutter_test/flutter_test.dart';

// flutter test test/momo_request_amount_test.dart

PaymentLineForSaleCompletion _line(String method, double amount) =>
    PaymentLineForSaleCompletion(amount: amount, method: method);

void main() {
  test('a split sale asks the phone for the MoMo part only', () {
    expect(
      momoRequestAmount([_line('CASH', 1000), _line(kMobileMoney, 600)], 1600),
      600,
    );
    expect(
      momoRequestAmount([
        _line('DEBIT&CREDIT CARD', 1000),
        _line('MTN MOMO', 400),
        _line(kAirtelMoney, 200),
      ], 1600),
      600,
    );
  });

  test('an unsplit sale keeps asking for the whole bill', () {
    expect(momoRequestAmount([_line(kMobileMoney, 1600)], 1600), 1600);
    expect(momoRequestAmount([_line('CASH', 1600)], 1600), 1600);
    expect(momoRequestAmount([], 1600), 1600);
    // A zero cash row left over from the picker is not a second tender.
    expect(
      momoRequestAmount([_line('CASH', 0), _line(kMobileMoney, 1600)], 1600),
      1600,
    );
  });
}
