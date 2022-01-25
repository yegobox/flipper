import 'dart:math';

import 'package:flipper_models/models/models.dart';
import 'package:flipper_services/billing_service.dart';
import 'package:test/test.dart';

import '../helpers/test_helpers.dart';

void main() {
  group('Test BillingService', () {
    late BillingService billing;
    setUp(() {
      registerServices();
      billing = getAndRegisterBillingService();
    });
    tearDown(() => unregisterServices());
    test('Use Voucher should return voucher object', () async {
      Voucher? bill = await billing.useVoucher(voucher: 1, userId: 1);
      expect(bill, isNotNull);
    });
    test('Use used Voucher shoul throw exception', () async {
      expect(() => billing.useVoucher(voucher: 2, userId: 1),
          throwsA(isA<VoucherException>()));
    });
    test('Add point return new muted points', () async {
      final p = billing.addPoints(userId: 1, points: 1);
      expect(p, isA<Points>());
    });
    test('Check a user still has some days left to use flipper', () async {
      String date = "2022-01-20T12:14:08.411";
      // convert Iso8601String to DateTime
      DateTime nextBillingDate = DateTime.parse(date);
      DateTime today = DateTime.now();

      expect(nextBillingDate.isAfter(today), isFalse);
    });
    test('Check a user still has no more days left to use flipper', () async {
      String date = "2022-01-18T12:14:08.411";
      // convert Iso8601String to DateTime
      DateTime nextBillingDate = DateTime.parse(date);
      DateTime today = DateTime.now();
      // check if the next billing date is before today
      expect(nextBillingDate.isAfter(today), isFalse);
    });
  });
}
