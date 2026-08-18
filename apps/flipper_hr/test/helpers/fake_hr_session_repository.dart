import 'package:flipper_hr/features/session/data/hr_session.dart';
import 'package:flipper_hr/features/session/data/hr_session_repository.dart';

/// Returns a canned [HrSession], or throws.
class FakeHrSessionRepository implements HrSessionRepository {
  FakeHrSessionRepository({this.session = HrSession.none, this.failWith});

  HrSession session;
  Object? failWith;

  int resolveCount = 0;

  @override
  Future<HrSession> resolve() async {
    resolveCount++;
    final failure = failWith;
    if (failure != null) throw failure;
    return session;
  }
}

/// An owner-only session: the roster and approvals, no record of their own.
HrSession ownerSession({List<String> businessIds = const ['biz-1']}) =>
    HrSession(businessIds: businessIds, identityKeys: const ['user-owner']);

/// An invited employee: their own record, and nothing else.
HrSession staffSession({String employeeId = 'e-1'}) =>
    HrSession(employeeIds: [employeeId], identityKeys: const ['user-staff']);
