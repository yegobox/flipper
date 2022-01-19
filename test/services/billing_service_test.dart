import 'package:flipper_models/models/models.dart';
import 'package:flipper_services/billing_service.dart';
import 'package:test/test.dart';

import '../helpers/test_helpers.dart';

void main() {
  group('Test BillingService', () {
    late BillingService billing;
    setUp(() {
      registerServices();
    });
    tearDown(() => unregisterServices());
    test('Use Voucher should return voucher object', () async {
      billing = getAndRegisterBillingService();
      Voucher? bill = await billing.useVoucher(voucher: 1, userId: 1);
      expect(bill, isNotNull);
    });
    test('Use used Voucher shoul throw exception', () async {
      billing = getAndRegisterBillingService();

      expect(() => billing.useVoucher(voucher: 2, userId: 1),
          throwsA(isA<VoucherException>()));
    });
  });
}
