import 'package:flipper_hr/features/people/data/employee.dart';
import 'package:flipper_hr/features/people/data/hr_line_repository.dart';
import 'package:flipper_hr/features/people/data/person_ref.dart';

/// Returns a canned reporting line, or throws.
///
/// Seeded with [PersonRef]s rather than [Employee]s on purpose: `hr_my_line()`
/// hands back a projection with no salary in it, and a fake that carried one
/// would let a test pass that the real RPC could not satisfy.
class FakeHrLineRepository implements HrLineRepository {
  FakeHrLineRepository({List<PersonRef>? seed, this.failWith})
    : line = [...?seed];

  List<PersonRef> line;
  Object? failWith;

  int fetchCount = 0;

  @override
  Future<List<PersonRef>> fetchMyLine() async {
    fetchCount++;
    final failure = failWith;
    if (failure != null) throw failure;
    return List.unmodifiable(line);
  }
}

/// Convenience builder — only the fields a test cares about need naming.
PersonRef personRef({
  String id = 'e-1',
  String firstName = 'Aline',
  String lastName = 'Uwase',
  String jobTitle = 'Cashier',
  String department = 'Retail',
  String branchId = 'branch-1',
  String businessId = 'biz-1',
  EmploymentStatus status = EmploymentStatus.active,
  String? managerId,
}) => PersonRef(
  id: id,
  firstName: firstName,
  lastName: lastName,
  jobTitle: jobTitle,
  department: department,
  branchId: branchId,
  businessId: businessId,
  status: status,
  managerId: managerId,
);
