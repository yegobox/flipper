import 'package:flipper_dashboard/utils/mpos_customer_match.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flutter_test/flutter_test.dart';

Customer _c(String name, String phone, int minutesAgo) => Customer(
  custNm: name,
  telNo: phone,
  branchId: 'b1',
  updatedAt: DateTime.utc(2026, 10, 10).subtract(Duration(minutes: minutesAgo)),
);

void main() {
  final jean = _c('Jean Mugabo', '0788123456', 30);
  final aline = _c('Aline Keza', '0722555010', 5);
  final eric = _c('Eric Jean', '0788999000', 60);
  final all = [jean, aline, eric];

  group('mposCustomerMatches', () {
    test('lists the most recently updated first when nothing is typed', () {
      expect(mposCustomerMatches(all), [aline, jean, eric]);
    });

    test('caps the list at the limit', () {
      expect(mposCustomerMatches(all, limit: 2), [aline, jean]);
    });

    test('matches phones whatever the prefix', () {
      for (final typed in ['0788123456', '+250788123456', '788123456']) {
        expect(mposCustomerMatches(all, phone: typed), [jean], reason: typed);
      }
    });

    test('a partial phone narrows the list', () {
      expect(mposCustomerMatches(all, phone: '0788'), [jean, eric]);
    });

    test('matches names case-insensitively', () {
      expect(mposCustomerMatches(all, name: 'jean'), [jean, eric]);
    });

    test('phone and name together must both match', () {
      expect(mposCustomerMatches(all, phone: '0788', name: 'eric'), [eric]);
    });
  });

  group('mposExactPhoneMatch', () {
    test('finds the customer behind a complete number', () {
      expect(mposExactPhoneMatch(all, '+250 788 123 456'), jean);
    });

    test('stays null until the number is complete', () {
      expect(mposExactPhoneMatch(all, '07881'), isNull);
    });

    test('is null for a new number', () {
      expect(mposExactPhoneMatch(all, '0733000111'), isNull);
    });
  });
}
