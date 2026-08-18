import 'package:flipper_hr/features/invite/data/apihub_hr_invite_repository.dart';
import 'package:flipper_hr/features/invite/data/hr_invite.dart';
import 'package:flipper_hr/features/invite/data/hr_invite_repository.dart';
import 'package:flipper_hr/features/people/data/employee.dart';
import 'package:flipper_hr/features/people/data/employee_repository.dart';
import 'package:flipper_hr/features/people/data/people_query.dart';
import 'package:flipper_hr/features/people/data/supabase_employee_repository.dart';
import 'package:flipper_web/core/secrets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// The roster's store. Overridden with a fake in tests.
final employeeRepositoryProvider = Provider<EmployeeRepository>((ref) {
  return SupabaseEmployeeRepository(Supabase.instance.client);
});

/// The invite pipeline. Overridden with a fake in tests.
///
/// apihub's base URL and the public Basic-auth credentials come from
/// flipper_web's [AppSecrets], the same ones its PIN login uses — HR must talk to
/// the deployment its sessions were issued by.
final hrInviteRepositoryProvider = Provider<HrInviteRepository>((ref) {
  return ApiHubHrInviteRepository(
    client: Supabase.instance.client,
    apihubBaseUrl: AppSecrets.apihubProd,
    apiUsername: AppSecrets.publicUsername,
    apiPassword: AppSecrets.publicPassword,
  );
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

  /// Invites [employee] into HR and records the account on their row.
  ///
  /// Returns the invite — the caller shows the PIN, which is the only time it is
  /// visible. The record is linked as part of this call rather than left to the
  /// UI: an invite whose `user_id` never lands leaves someone able to sign in and
  /// unable to see their own leave, which is worse than no invite at all.
  ///
  /// A failure to link is surfaced, not swallowed, but the invite itself is not
  /// rolled back — the account and PIN are real by then, and destroying them
  /// would be the more damaging repair. Re-inviting is idempotent: apihub returns
  /// the existing account and `create_agent` updates the existing tenant.
  Future<HrInvite> invite({
    required Employee employee,
    required HrRole role,
  }) async {
    final invited = await _ref.read(hrInviteRepositoryProvider).invite(
      contact: employee.inviteContact,
      name: employee.fullName,
      businessId: employee.businessId,
      branchId: employee.branchId,
      role: role,
    );

    try {
      await _ref.read(employeeRepositoryProvider).linkAccount(
        id: employee.id,
        userId: invited.userId,
      );
    } on EmployeeRepositoryException catch (e) {
      throw HrInviteException(
        e.message,
        step: HrInviteStep.linkEmployee,
        cause: e,
      );
    } finally {
      _ref.invalidate(rosterProvider(employee.branchId));
    }

    return invited;
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
