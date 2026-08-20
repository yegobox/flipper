import 'package:flipper_hr/features/people/data/employee.dart';
import 'package:flipper_hr/features/people/data/people_providers.dart';
import 'package:flipper_hr/features/people/data/people_query.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/fake_employee_repository.dart';

void main() {
  ProviderContainer containerWith(FakeEmployeeRepository repository) {
    final container = ProviderContainer(
      overrides: [employeeRepositoryProvider.overrideWithValue(repository)],
    );
    addTearDown(container.dispose);
    return container;
  }

  group('rosterProvider', () {
    test('loads the people on the requested branch only', () async {
      final repository = FakeEmployeeRepository(
        seed: [
          employee(id: 'a', branchId: 'branch-1'),
          employee(id: 'b', branchId: 'branch-2'),
        ],
      );
      final container = containerWith(repository);

      final people = await container.read(rosterProvider('branch-1').future);

      expect([for (final e in people) e.id], ['a']);
    });

    test('surfaces a repository failure as an error state', () async {
      final repository = FakeEmployeeRepository(failWith: Exception('offline'));
      final container = containerWith(repository);
      // A listener is what makes the failure observable: without one the
      // provider's future stays pending until the container is disposed.
      final subscription = container.listen(
        rosterProvider('branch-1'),
        (_, __) {},
        onError: (_, __) {},
      );
      addTearDown(subscription.close);

      await expectLater(
        container.read(rosterProvider('branch-1').future),
        throwsA(isA<Exception>()),
      );
      expect(container.read(rosterProvider('branch-1')).hasError, isTrue);
    });
  });

  group('PeopleActions.save', () {
    test('inserts a record with no id and refreshes the roster', () async {
      final repository = FakeEmployeeRepository();
      final container = containerWith(repository);
      // Prime the roster so the invalidation is observable.
      await container.read(rosterProvider('branch-1').future);
      expect(repository.fetchCount, 1);

      final saved = await container.read(peopleActionsProvider).save(
        Employee.blank(
          businessId: 'biz-1',
          branchId: 'branch-1',
          hireDate: DateTime(2026, 8, 17),
        ).copyWith(firstName: 'Aline', lastName: 'Uwase'),
      );

      expect(saved.isPersisted, isTrue);
      expect(repository.people.single.fullName, 'Aline Uwase');

      final refreshed = await container.read(rosterProvider('branch-1').future);
      expect(refreshed.length, 1);
      expect(repository.fetchCount, 2, reason: 'roster should have refetched');
    });

    test('updates a record that already has an id', () async {
      final repository = FakeEmployeeRepository(
        seed: [employee(id: 'e-1', jobTitle: 'Cashier')],
      );
      final container = containerWith(repository);

      final saved = await container.read(peopleActionsProvider).save(
        employee(id: 'e-1', jobTitle: 'Supervisor'),
      );

      expect(saved.jobTitle, 'Supervisor');
      expect(repository.people.single.jobTitle, 'Supervisor');
      expect(repository.people.length, 1, reason: 'must not insert a duplicate');
    });

    test('a failing write throws and leaves the store untouched', () async {
      final repository = FakeEmployeeRepository(seed: [employee(id: 'e-1')]);
      final container = containerWith(repository);
      repository.failWith = Exception('denied');

      await expectLater(
        container.read(peopleActionsProvider).save(employee(id: 'e-1')),
        throwsA(isA<Exception>()),
      );
      expect(repository.people.single.jobTitle, 'Cashier');
    });
  });

  group('PeopleActions.setStatus', () {
    test('terminating records the last day', () async {
      final repository = FakeEmployeeRepository(seed: [employee(id: 'e-1')]);
      final container = containerWith(repository);

      final saved = await container.read(peopleActionsProvider).setStatus(
        employee: employee(id: 'e-1'),
        status: EmploymentStatus.terminated,
        endDate: DateTime(2026, 8, 17),
      );

      expect(saved.status, EmploymentStatus.terminated);
      expect(saved.endDate, DateTime(2026, 8, 17));
    });

    test('reactivating clears a stale last day', () async {
      final repository = FakeEmployeeRepository(
        seed: [
          employee(
            id: 'e-1',
            status: EmploymentStatus.terminated,
            endDate: DateTime(2026, 3, 1),
          ),
        ],
      );
      final container = containerWith(repository);

      final saved = await container.read(peopleActionsProvider).setStatus(
        employee: employee(id: 'e-1'),
        status: EmploymentStatus.active,
      );

      expect(saved.status, EmploymentStatus.active);
      expect(saved.endDate, isNull);
    });
  });

  group('PeopleQueryController', () {
    test('starts unfiltered', () {
      final container = containerWith(FakeEmployeeRepository());
      expect(container.read(peopleQueryProvider).isFiltering, isFalse);
    });

    test('updates search, status, department and sort', () {
      final container = containerWith(FakeEmployeeRepository());
      final controller = container.read(peopleQueryProvider.notifier);

      controller.setSearch('aline');
      controller.setStatus(EmploymentStatus.onLeave);
      controller.setDepartment('Retail');
      controller.setSort(PeopleSort.newestHire);

      final query = container.read(peopleQueryProvider);
      expect(query.search, 'aline');
      expect(query.status, EmploymentStatus.onLeave);
      expect(query.department, 'Retail');
      expect(query.sort, PeopleSort.newestHire);
    });

    test('passing null resets a filter rather than being ignored', () {
      final container = containerWith(FakeEmployeeRepository());
      final controller = container.read(peopleQueryProvider.notifier);

      controller.setStatus(EmploymentStatus.onLeave);
      controller.setStatus(null);
      controller.setDepartment('Retail');
      controller.setDepartment(null);

      expect(container.read(peopleQueryProvider).status, isNull);
      expect(container.read(peopleQueryProvider).department, isNull);
    });

    test('clear resets the filters but keeps the chosen sort', () {
      final container = containerWith(FakeEmployeeRepository());
      final controller = container.read(peopleQueryProvider.notifier);

      controller.setSearch('aline');
      controller.setStatus(EmploymentStatus.suspended);
      controller.setSort(PeopleSort.highestPaid);
      controller.clear();

      final query = container.read(peopleQueryProvider);
      expect(query.search, '');
      expect(query.status, isNull);
      expect(query.sort, PeopleSort.highestPaid);
    });
  });
}
