/// Org-chart questions answered over a roster already in memory.
///
/// Deliberately plain Dart, and deliberately client-side: the database is the
/// authority on what a reporting line *permits* (`hr_my_report_ids()` in
/// migration 0007), while these functions answer what to *show* — who reports to
/// whom, and which people a manager dropdown may offer without creating a loop.
/// Duplicating the walk here is on purpose: a form that offered a cyclic choice
/// and let the trigger reject it on save would be a worse form.
library;

import 'package:flipper_hr/features/people/data/employee.dart';

/// Everyone whose [Employee.managerId] is [managerId], in roster order.
List<Employee> directReportsOf(List<Employee> roster, String managerId) {
  if (managerId.isEmpty) return const [];
  return [
    for (final e in roster)
      if (e.managerId == managerId) e,
  ];
}

/// Every id at or below [id] in the line, excluding [id] itself.
///
/// Breadth-first with a seen-set, so a cycle that somehow reached the client —
/// a roster read mid-write, or data that predates the trigger — terminates
/// instead of hanging the page.
Set<String> descendantIdsOf(List<Employee> roster, String id) {
  if (id.isEmpty) return const {};

  final childrenOf = <String, List<String>>{};
  for (final e in roster) {
    final parent = e.managerId;
    if (parent == null || parent.isEmpty || e.id.isEmpty) continue;
    childrenOf.putIfAbsent(parent, () => []).add(e.id);
  }

  final found = <String>{};
  final queue = [...?childrenOf[id]];
  while (queue.isNotEmpty) {
    final next = queue.removeLast();
    if (next == id || !found.add(next)) continue;
    queue.addAll(childrenOf[next] ?? const []);
  }
  return found;
}

/// The chain of managers above [id], nearest first.
///
/// Stops at the first person with no manager, at anyone missing from [roster] —
/// a manager on another branch is not in a branch-scoped read — and at a repeat,
/// which is the same cycle guard as [descendantIdsOf].
List<Employee> managerChainOf(List<Employee> roster, String id) {
  final byId = {for (final e in roster) e.id: e};
  final chain = <Employee>[];
  final seen = <String>{id};

  var current = byId[id];
  while (current != null) {
    final parentId = current.managerId;
    if (parentId == null || parentId.isEmpty || !seen.add(parentId)) break;
    final parent = byId[parentId];
    if (parent == null) break;
    chain.add(parent);
    current = parent;
  }
  return chain;
}

/// The people [employee] may be set to report to.
///
/// Excluded, each for a reason:
///
///   * themselves — the `hr_employees_manager_not_self` CHECK refuses it;
///   * anyone below them — that is the loop the cycle trigger refuses, and the
///     one a manager dropdown would otherwise invite;
///   * terminated people — a leaver cannot approve leave, and pointing a team at
///     one would silently fall back to business-wide approval;
///   * unsaved records — a manager needs an id to be referenced by.
///
/// Suspended and on-leave people stay: both are temporary, the record is still
/// the right one, and the recursive approval path in 0007 means their own manager
/// can act while they are away.
List<Employee> managerCandidatesFor({
  required List<Employee> roster,
  required Employee employee,
}) {
  final below = employee.isPersisted
      ? descendantIdsOf(roster, employee.id)
      : const <String>{};

  return [
    for (final e in roster)
      if (e.isPersisted &&
          e.id != employee.id &&
          e.status.isEmployed &&
          !below.contains(e.id))
        e,
  ];
}

/// Who a request from [employee] waits on: their manager, or null when the
/// reporting line does not say.
///
/// Null is not an error — it means the request falls to whoever manages the
/// business, which is what happens for a record with no `manager_id` and how HR
/// behaved before reporting lines existed.
Employee? approverFor({
  required List<Employee> roster,
  required Employee employee,
}) {
  final managerId = employee.managerId;
  if (managerId == null || managerId.isEmpty) return null;
  for (final e in roster) {
    if (e.id == managerId) return e;
  }
  return null;
}
