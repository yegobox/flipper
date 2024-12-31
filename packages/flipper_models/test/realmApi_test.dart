import 'package:flipper_rw/dependencyInitializer.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter_test/flutter_test.dart';

// flutter test test/realmApi_test.dart --dart-define=FLUTTER_TEST_ENV=true
void main() {
  group('RealmApi Test', () {
    setUpAll(() async {
      // Initialize dependencies for test environment
      await initializeDependenciesForTest();

      // CreateMockdata().mockBusiness(local: ProxyService.strategy.realm!);
      // CreateMockdata().mockTransactions(realm: ProxyService.strategy.realm!);
    });

    test('Test Query Test Query Transaction By Date', () async {
      final result = await ProxyService.strategy.transactions(
        isExpense: false,
        branchId: 1,
        status: COMPLETE,
        startDate: DateTime(2023, 10, 28),
      );
      expect(result.length, 1000);
    });
    test('Test Query Transactions Without Dates', () async {
      final result =await ProxyService.strategy.transactions(
        isExpense: false,
        branchId: 1,
        status: COMPLETE,
      );
      expect(result.length, 1000);
    });
    test('Test Query Transactions With Start Date Only', () async {
      final result = await ProxyService.strategy.transactions(
        isExpense: false,
        branchId: 1,
        status: COMPLETE,
        startDate: DateTime(2023, 10, 28),
      );
      expect(result.length, 1000);
    });
    test('Test Query Transactions With End Date Only', () async {
      final result =await ProxyService.strategy.transactions(
        isExpense: false,
        branchId: 1,
        status: COMPLETE,
        endDate: DateTime(2023, 10, 28),
      );
      expect(result.length, 1000);
    });
    test('Test Query Transactions With Date Range', () async {
      final result =await ProxyService.strategy.transactions(
        isExpense: false,
        branchId: 1,
        status: COMPLETE,
        startDate: DateTime(2023, 10, 28),
        endDate: DateTime(2023, 10, 28),
      );
      expect(result.length, 1000);
    });

    test('Test Query Transactions With isExpense True', () async {
      final result =await ProxyService.strategy.transactions(
        isExpense: true,
        branchId: 1,
        status: COMPLETE,
      );
      expect(result.length, 0);
    });
    test('Test Query Transactions With Date Range and isExpense True', () async {
      final result =await ProxyService.strategy.transactions(
        isExpense: true,
        branchId: 1,
        status: COMPLETE,
        startDate: DateTime(2023, 10, 28),
        endDate: DateTime(2023, 10, 28),
      );
      expect(result.length, 0);
    });
    test('Test Query Transactions With No Matching Criteria', () async {
      final result =await ProxyService.strategy.transactions(
        isExpense: false,
        branchId: 2,
        status: COMPLETE,
      );
      expect(result.isEmpty, true);
    });
    test('Test Query Transactions With Different Status', () async {
      final result =await ProxyService.strategy.transactions(
        isExpense: false,
        branchId: 1,
        status: PENDING,
      );
      expect(result.length, 0);
    });
    test('Test Query Transactions Including Pending', () async {
      final result =await ProxyService.strategy.transactions(
        isExpense: false,
        branchId: 1,
        status: COMPLETE,
        includePending: true,
      );
      expect(result.length, 1000);
    });
    test('Test Query Transactions With Empty Parameters', () async {
      final result =await ProxyService.strategy.transactions();
      expect(result.length, 0);
    });
  });
}
