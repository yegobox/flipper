import 'package:flipper_models/helperModels/sale_completion_helpers.dart';
import 'package:test/test.dart';

void main() {
  group('resolveSaleCustomerFieldsForCompletion', () {
    test('keeps ticket customer when box and controller are empty', () {
      final resolved = resolveSaleCustomerFieldsForCompletion(
        boxName: '',
        boxPhone: null,
        controllerName: '   ',
        transactionName: 'Till Customer',
        transactionPhone: '783054874',
        transactionSalePhone: null,
      );
      expect(resolved.name, 'Till Customer');
      expect(resolved.phone, '783054874');
    });

    test('typed box customer wins over ticket fields (normal edit)', () {
      final resolved = resolveSaleCustomerFieldsForCompletion(
        boxName: 'Cashier Edit',
        boxPhone: '788888888',
        controllerName: 'Controller Name',
        transactionName: 'Till Customer',
        transactionPhone: '783054874',
        transactionSalePhone: null,
      );
      expect(resolved.name, 'Cashier Edit');
      expect(resolved.phone, '788888888');
    });

    test('controller name is used when box name empty', () {
      final resolved = resolveSaleCustomerFieldsForCompletion(
        boxName: null,
        boxPhone: null,
        controllerName: 'Typed Name',
        transactionName: 'Ticket Name',
        transactionPhone: null,
        transactionSalePhone: '250783054874',
      );
      expect(resolved.name, 'Typed Name');
      expect(resolved.phone, '250783054874');
    });

    test('returns nulls when every source is empty (walk-in)', () {
      final resolved = resolveSaleCustomerFieldsForCompletion(
        boxName: '',
        boxPhone: '  ',
        controllerName: null,
        transactionName: null,
        transactionPhone: '',
        transactionSalePhone: null,
      );
      expect(resolved.name, isNull);
      expect(resolved.phone, isNull);
    });
  });
}
