import 'package:flipper_hr/features/people/data/employee.dart';
import 'package:flipper_hr/features/people/data/employee_repository.dart';
import 'package:flipper_hr/features/people/data/people_query.dart';
import 'package:flipper_hr/features/people/data/supabase_employee_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// The roster's store. Overridden with a fake in tests.
final employeeRepositoryProvider = Provider<EmployeeRepository>((ref) {
  return SupabaseEmployeeRepository(Supabase.instance.client);
});

/// Today's date, injected so summary tiles and date validation are testable and
/// stable within a build.
final hrClockProvider = Provider<DateTime Function()>((ref) => DateTime.now);

/// Every person on a branch, terminated included. Filtering is client-side, so
/// switching status tabs never refetches; [PeopleActions] invalidates this after
/// a write.
final rosterProvider = FutureProvider.family<List<Employee>, String>(
  (ref, branchId) {
    return ref.watch(employeeRepositoryProvider).fetchEmployees(
      branchId: branchId,
    );
  },
  // Riverpod 3 retries a failed provider on a backoff by default. The page
  // shows the failure with a "Try again" button instead, so a load that fails
  // stays failed until someone asks again — no invisible fetch loop, and the
  // provider's future settles instead of hanging while retries continue.
  retry: (retryCount, error) => null,
);

/// Search / filter / sort state for the open branch's directory.
final peopleQueryProvider =
    NotifierProvider<PeopleQueryController, PeopleQuery>(
      PeopleQueryController.new,
    );

class PeopleQueryController extends Notifier<PeopleQuery> {
  @override
  PeopleQuery build() => const PeopleQuery();

  void setSearch(String value) => state = state.copyWith(search: value);

  void setStatus(EmploymentStatus? status) => state = status == null
      ? state.copyWith(clearStatus: true)
      : state.copyWith(status: status);

  void setDepartment(String? department) => department == null
      ? state = state.copyWith(clearDepartment: true)
      : state = state.copyWith(department: department);

  void setSort(PeopleSort sort) => state = state.copyWith(sort: sort);

  void clear() => state = PeopleQuery(sort: state.sort);
}

/// Writes to the roster. Every mutation invalidates [rosterProvider] for the
/// branch, so the list always reflects what Postgres stored rather than an
/// optimistic local copy.
final peopleActionsProvider = Provider<PeopleActions>(PeopleActions.new);

class PeopleActions {
  PeopleActions(this._ref);

  final Ref _ref;

  /// Inserts or updates depending on whether the record has an id yet.
  Future<Employee> save(Employee employee) async {
    final repository = _ref.read(employeeRepositoryProvider);
    final saved = employee.isPersisted
        ? await repository.updateEmployee(employee)
        : await repository.createEmployee(employee);
    _ref.invalidate(rosterProvider(employee.branchId));
    return saved;
  }

  Future<Employee> setStatus({
    required Employee employee,
    required EmploymentStatus status,
    DateTime? endDate,
  }) async {
    final saved = await _ref
        .read(employeeRepositoryProvider)
        .setStatus(id: employee.id, status: status, endDate: endDate);
    _ref.invalidate(rosterProvider(employee.branchId));
    return saved;
  }
}
