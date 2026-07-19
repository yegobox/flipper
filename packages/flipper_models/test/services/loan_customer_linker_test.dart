import 'package:flipper_models/services/loan_customer_linker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_models/brick/models/customer.model.dart';

Customer _customer({
  required String id,
  required String name,
  required String phone,
}) {
  return Customer(
    id: id,
    custNm: name,
    telNo: phone,
    branchId: 'branch-1',
    customerType: 'Individual',
  );
}

void main() {
  setUp(LoanCustomerLinker.clearInflightForTest);
  tearDown(LoanCustomerLinker.clearInflightForTest);

  group('pickMatchingCustomer', () {
    test('matches phone+name and picks oldest id among same person', () {
      final older = _customer(
        id: 'aaa-1',
        name: 'Auriella',
        phone: '0783054874',
      );
      final newer = _customer(
        id: 'zzz-2',
        name: 'Auriella',
        phone: '+250783054874',
      );

      final picked = LoanCustomerLinker.pickMatchingCustomer(
        candidates: [newer, older],
        phone: '783054874',
        name: 'Auriella',
      );

      expect(picked?.id, 'aaa-1');
    });

    test('prefers name+phone over older different person on same phone', () {
      final mura = _customer(
        id: 'aaa-mura',
        name: 'mura',
        phone: '783054874',
      );
      final auriella = _customer(
        id: 'zzz-auriella',
        name: 'Auriella',
        phone: '783054874',
      );

      final picked = LoanCustomerLinker.pickMatchingCustomer(
        candidates: [mura, auriella],
        phone: '783054874',
        name: 'Auriella',
      );

      expect(picked?.id, 'zzz-auriella');
    });

    test('does not hijack phone-only match when typed name differs', () {
      final mura = _customer(
        id: 'aaa-mura',
        name: 'mura',
        phone: '783054874',
      );

      final picked = LoanCustomerLinker.pickMatchingCustomer(
        candidates: [mura],
        phone: '783054874',
        name: 'Auriella',
      );

      expect(picked, isNull);
    });

    test('phone-only match when name empty picks oldest', () {
      final mura = _customer(
        id: 'aaa-mura',
        name: 'mura',
        phone: '783054874',
      );
      final auriella = _customer(
        id: 'zzz-auriella',
        name: 'Auriella',
        phone: '783054874',
      );

      final picked = LoanCustomerLinker.pickMatchingCustomer(
        candidates: [mura, auriella],
        phone: '783054874',
        name: '',
      );

      expect(picked?.id, 'aaa-mura');
    });

    test('falls back to case-insensitive name when phone empty', () {
      final match = _customer(
        id: 'n-1',
        name: 'Auriella',
        phone: '0999',
      );
      final other = _customer(
        id: 'n-2',
        name: 'Other',
        phone: '0888',
      );

      final picked = LoanCustomerLinker.pickMatchingCustomer(
        candidates: [other, match],
        phone: '',
        name: 'auriella',
      );

      expect(picked?.id, 'n-1');
    });

    test('returns null when nothing matches', () {
      final picked = LoanCustomerLinker.pickMatchingCustomer(
        candidates: [
          _customer(id: 'x', name: 'Other', phone: '0111'),
        ],
        phone: '783054874',
        name: 'Auriella',
      );
      expect(picked, isNull);
    });
  });

  group('resolveWithDepsForTest', () {
    test('reuses existing match and does not create', () async {
      var createCalls = 0;
      final existing = _customer(
        id: 'existing',
        name: 'Auriella',
        phone: '0783054874',
      );

      final result = await LoanCustomerLinker.resolveWithDepsForTest(
        branchId: 'branch-1',
        phone: '783054874',
        name: 'Auriella',
        transactionId: 'txn-1',
        lookup: () async => [existing],
        create: () async {
          createCalls++;
          return _customer(
            id: 'new',
            name: 'Auriella',
            phone: '783054874',
          );
        },
      );

      expect(result?.id, 'existing');
      expect(createCalls, 0);
    });

    test('creates when phone match exists but name differs', () async {
      var createCalls = 0;
      final mura = _customer(
        id: 'mura',
        name: 'mura',
        phone: '783054874',
      );
      final created = _customer(
        id: 'auriella-new',
        name: 'Auriella',
        phone: '783054874',
      );

      final result = await LoanCustomerLinker.resolveWithDepsForTest(
        branchId: 'branch-1',
        phone: '783054874',
        name: 'Auriella',
        transactionId: 'txn-3',
        lookup: () async => [mura],
        create: () async {
          createCalls++;
          return created;
        },
      );

      expect(result?.id, 'auriella-new');
      expect(result?.custNm, 'Auriella');
      expect(createCalls, 1);
    });

    test('creates when lookup empty', () async {
      var createCalls = 0;
      final created = _customer(
        id: 'created',
        name: 'Auriella',
        phone: '783054874',
      );

      final result = await LoanCustomerLinker.resolveWithDepsForTest(
        branchId: 'branch-1',
        phone: '783054874',
        name: 'Auriella',
        transactionId: 'txn-2',
        lookup: () async => [],
        create: () async {
          createCalls++;
          return created;
        },
      );

      expect(result?.id, 'created');
      expect(createCalls, 1);
    });

    test('concurrent resolves share one create', () async {
      var createCalls = 0;
      final created = _customer(
        id: 'once',
        name: 'Auriella',
        phone: '783054874',
      );

      Future<Customer> slowCreate() async {
        createCalls++;
        await Future<void>.delayed(const Duration(milliseconds: 80));
        return created;
      }

      final a = LoanCustomerLinker.resolveWithDepsForTest(
        branchId: 'branch-1',
        phone: '0783054874',
        name: 'Auriella',
        transactionId: 'txn-a',
        lookup: () async => [],
        create: slowCreate,
      );
      final b = LoanCustomerLinker.resolveWithDepsForTest(
        branchId: 'branch-1',
        phone: '+250783054874',
        name: 'Auriella',
        transactionId: 'txn-b',
        lookup: () async => [],
        create: slowCreate,
      );

      final results = await Future.wait([a, b]);
      expect(results[0]?.id, 'once');
      expect(results[1]?.id, 'once');
      expect(createCalls, 1);
    });
  });
}
