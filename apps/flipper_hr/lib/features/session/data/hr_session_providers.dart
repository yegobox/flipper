import 'package:flipper_hr/features/people/data/employee.dart';
import 'package:flipper_hr/features/people/data/people_providers.dart';
import 'package:flipper_hr/features/session/data/hr_session.dart';
import 'package:flipper_hr/features/session/data/hr_session_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Resolves the session's HR identity. Overridden with a fake in tests.
final hrSessionRepositoryProvider = Provider<HrSessionRepository>((ref) {
  return SupabaseHrSessionRepository(Supabase.instance.client);
});

/// What the signed-in person may do, as the database sees it.
///
/// Read once per sign-in and cached: it is a round trip that gates the whole
/// shell, and nothing short of a new session changes the answer. Invalidate it
/// after an invite, since inviting yourself is how a session gains an employee
/// record.
final hrSessionProvider = FutureProvider<HrSession>((ref) {
  return ref.watch(hrSessionRepositoryProvider).resolve();
}, retry: (retryCount, error) => null);

/// The signed-in person's own employee record, or null when they have none.
///
/// Null is a normal outcome, not an error: an owner who is not on their own
/// payroll has no record, and neither does anyone whose row was never linked. It
/// is what the leave page tests to decide between "book leave" and "you have no
/// record here yet".
final myEmployeeProvider = FutureProvider<Employee?>((ref) async {
  final session = await ref.watch(hrSessionProvider.future);
  final id = session.primaryEmployeeId;
  if (id == null) return null;
  return ref.watch(employeeRepositoryProvider).fetchEmployee(id: id);
}, retry: (retryCount, error) => null);
