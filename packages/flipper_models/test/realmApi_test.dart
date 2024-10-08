import 'dart:convert';

import 'package:flipper_models/LocalRealmApiMocked.dart';
import 'package:flipper_models/helperModels/iuser.dart';
import 'package:flipper_rw/dependencyInitializer.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flipper_mocks/flipper_mocks.dart';

// flutter test test/realmApi_test.dart --dart-define=FLUTTER_TEST_ENV=true
void main() {
  group('RealmApi Test', () {
    setUpAll(() async {
      // Initialize dependencies for test environment
      await initializeDependenciesForTest();
      ProxyService.local.configureLocal(useInMemory: true);
      ProxyService.local.configureRemoteRealm(
        "+250783054871",
        IUser.fromJson(
          json.decode(userResponse),
        ),
        localRealm: ProxyService.local.localRealm,
      );
      await ProxyService.realm.configure(
        useInMemoryDb: false,
        useFallBack: false,
        localRealm: ProxyService.local.localRealm,
        branchId: ProxyService.box.getBranchId()!,
        userId: ProxyService.box.getUserId()!,
        businessId: ProxyService.box.getBusinessId()!,
        encryptionKey: ProxyService.box.encryptionKey(),
      );
      CreateMockdata().mockBusiness(local: ProxyService.local.localRealm!);
      CreateMockdata().mockTransactions(realm: ProxyService.realm.realm!);
    });

    test('Test Query Test Query Transaction By Date', () {
      final result = ProxyService.realm.transactions(
        isExpense: false,
        branchId: 1,
        status: COMPLETE,
        startDate: DateTime(2023, 10, 28),
      );
      expect(result.length, 1000);
    });
    test('Test Query Transactions Without Dates', () {
      final result = ProxyService.realm.transactions(
        isExpense: false,
        branchId: 1,
        status: COMPLETE,
      );
      expect(result.length, 1000);
    });
    test('Test Query Transactions With Start Date Only', () {
      final result = ProxyService.realm.transactions(
        isExpense: false,
        branchId: 1,
        status: COMPLETE,
        startDate: DateTime(2023, 10, 28),
      );
      expect(result.length, 1000);
    });
    test('Test Query Transactions With End Date Only', () {
      final result = ProxyService.realm.transactions(
        isExpense: false,
        branchId: 1,
        status: COMPLETE,
        endDate: DateTime(2023, 10, 28),
      );
      expect(result.length, 1000);
    });
    test('Test Query Transactions With Date Range', () {
      final result = ProxyService.realm.transactions(
        isExpense: false,
        branchId: 1,
        status: COMPLETE,
        startDate: DateTime(2023, 10, 28),
        endDate: DateTime(2023, 10, 28),
      );
      expect(result.length, 1000);
    });

    test('Test Query Transactions With isExpense True', () {
      final result = ProxyService.realm.transactions(
        isExpense: true,
        branchId: 1,
        status: COMPLETE,
      );
      expect(result.length, 0);
    });
    test('Test Query Transactions With Date Range and isExpense True', () {
      final result = ProxyService.realm.transactions(
        isExpense: true,
        branchId: 1,
        status: COMPLETE,
        startDate: DateTime(2023, 10, 28),
        endDate: DateTime(2023, 10, 28),
      );
      expect(result.length, 0);
    });
    test('Test Query Transactions With No Matching Criteria', () {
      final result = ProxyService.realm.transactions(
        isExpense: false,
        branchId: 2,
        status: COMPLETE,
      );
      expect(result.isEmpty, true);
    });
    test('Test Query Transactions With Different Status', () {
      final result = ProxyService.realm.transactions(
        isExpense: false,
        branchId: 1,
        status: PENDING,
      );
      expect(result.length, 0);
    });
    test('Test Query Transactions Including Pending', () {
      final result = ProxyService.realm.transactions(
        isExpense: false,
        branchId: 1,
        status: COMPLETE,
        includePending: true,
      );
      expect(result.length, 1000);
    });
    test('Test Query Transactions With Empty Parameters', () {
      final result = ProxyService.realm.transactions();
      expect(result.length, 0);
    });
  });
}
