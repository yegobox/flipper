/// A person, named but not detailed: enough to label a row, nothing more.
///
/// Exists because HR now has readers who may know WHO someone is without being
/// allowed to know what they earn. A line manager approving their team's leave is
/// exactly that reader: `hr_my_line()` (migration 0007) hands them names, job
/// titles and the reporting line, and no salary, national id or bank details —
/// the columns an [Employee] would carry.
///
/// So this is not a trimmed-down [Employee] for convenience; it is the shape of
/// what a non-roster reader is permitted to see. Building an [Employee] with
/// zeroed pay from the same rows would put a plausible-looking `RWF 0` on screen
/// and invite code to read it.
library;

import 'package:flipper_hr/features/people/data/employee.dart';

class PersonRef {
  const PersonRef({
    required this.id,
    required this.firstName,
    required this.lastName,
    this.jobTitle = '',
    this.department = '',
    this.branchId = '',
    this.businessId = '',
    this.status = EmploymentStatus.active,
    this.managerId,
  });

  /// Projects a full record down to what may be shown. Used where the roster IS
  /// readable, so one name lookup serves both audiences.
  factory PersonRef.fromEmployee(Employee e) => PersonRef(
    id: e.id,
    firstName: e.firstName,
    lastName: e.lastName,
    jobTitle: e.jobTitle,
    department: e.department,
    branchId: e.branchId,
    businessId: e.businessId,
    status: e.status,
    managerId: e.managerId,
  );

  /// One row of `hr_my_line()`. Column names must match migration 0007.
  factory PersonRef.fromRow(Map<String, dynamic> row) => PersonRef(
    id: _str(row['id']),
    firstName: _str(row['first_name']),
    lastName: _str(row['last_name']),
    jobTitle: _str(row['job_title']),
    department: _str(row['department']),
    branchId: _str(row['branch_id']),
    businessId: _str(row['business_id']),
    status: EmploymentStatus.fromWire(row['status'] as String?),
    managerId: _strOrNull(row['manager_id']),
  );

  final String id;
  final String firstName;
  final String lastName;
  final String jobTitle;
  final String department;
  final String branchId;
  final String businessId;
  final EmploymentStatus status;

  /// Who this person reports to, when the line says. Present so a queue can show
  /// whose decision a request is really waiting on.
  final String? managerId;

  String get fullName => [firstName.trim(), lastName.trim()]
      .where((p) => p.isNotEmpty)
      .join(' ');

  /// Up to two letters for an avatar; empty when the name is blank.
  String get initials {
    final parts = [firstName.trim(), lastName.trim()]
        .where((p) => p.isNotEmpty)
        .toList();
    if (parts.isEmpty) return '';
    if (parts.length == 1) {
      final only = parts.first;
      return only.substring(0, only.length >= 2 ? 2 : 1).toUpperCase();
    }
    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }

  @override
  bool operator ==(Object other) =>
      other is PersonRef &&
      other.id == id &&
      other.firstName == firstName &&
      other.lastName == lastName &&
      other.jobTitle == jobTitle &&
      other.department == department &&
      other.branchId == branchId &&
      other.businessId == businessId &&
      other.status == status &&
      other.managerId == managerId;

  @override
  int get hashCode => Object.hash(
    id,
    firstName,
    lastName,
    jobTitle,
    department,
    branchId,
    businessId,
    status,
    managerId,
  );

  @override
  String toString() => 'PersonRef($id, $fullName)';
}

String _str(Object? value) => value?.toString() ?? '';

String? _strOrNull(Object? value) {
  final s = value?.toString().trim();
  return (s == null || s.isEmpty) ? null : s;
}
