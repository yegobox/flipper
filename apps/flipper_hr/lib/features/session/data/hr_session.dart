/// Who the signed-in person is, in HR's terms.
///
/// HR has two audiences and one login. Which one you are is not a setting — it
/// is what the database can prove about you, and the two proofs are independent:
///
///   * [businessIds] — businesses you may act in as HR (`hr_user_business_ids()`):
///     owned outright, or held through a live HR/admin grant in `accesses`, which
///     is what an invited manager has (see migration 0006). This is what the
///     roster, the approvals queue and the attendance board are scoped to.
///   * [employeeIds] — `hr_employees` rows that ARE you (`hr_my_employee_ids()`).
///     This is what your own leave is scoped to.
///   * [reportIds] — `hr_employees` rows at or below you in the reporting line
///     (`hr_my_report_ids()`, migration 0007). This is a third, independent
///     proof: a shift supervisor with no business grant at all may still decide
///     their own team's leave, and only theirs.
///
/// Both can be non-empty at once: an owner who is also on their own payroll gets
/// the roster and a leave page. Both empty means the session resolved to nobody —
/// see the diagnostics on the people page.
///
/// Plain Dart on purpose: the routing decision this drives is worth testing
/// without a Supabase client in the room.
library;

class HrSession {
  const HrSession({
    this.businessIds = const [],
    this.employeeIds = const [],
    this.reportIds = const [],
    this.managerIds = const [],
    this.identityKeys = const [],
  });

  /// Nobody: no ownership and no employee record. Also what a failed resolve
  /// degrades to, so a diagnostic-worthy state never reads as a permission.
  static const none = HrSession();

  /// Businesses the caller may manage HR for — owned, or granted. Non-empty
  /// means the roster is theirs to manage; the two routes are indistinguishable
  /// from here on purpose, since they confer the same thing.
  final List<String> businessIds;

  /// The caller's own employee rows — usually one, more if they are on the
  /// roster at more than one branch.
  final List<String> employeeIds;

  /// Employee rows below the caller in the reporting line — their team, and any
  /// team under that. Non-empty means they have leave to decide, whether or not
  /// they manage a business.
  final List<String> reportIds;

  /// The caller's own direct managers. Display only: it is who their own requests
  /// wait on.
  final List<String> managerIds;

  /// The `public.users` ids the server resolved for this session. Diagnostics
  /// only: an empty list is the signature of a session the database cannot tie
  /// to any Flipper account.
  final List<String> identityKeys;

  /// May see the branch roster, and approve other people's leave.
  bool get canManageRoster => businessIds.isNotEmpty;

  /// Has a record of their own, so they have leave to book and a balance to see.
  bool get hasOwnRecord => employeeIds.isNotEmpty;

  /// Has people reporting to them, so leave is theirs to decide.
  ///
  /// Independent of [canManageRoster]: a team lead has this and not that, an
  /// owner not on the roster has that and not this, and an owner who also manages
  /// a team has both. Anything that gates the approvals queue must test the pair.
  bool get hasReports => reportIds.isNotEmpty;

  /// May decide somebody's leave, by either route.
  bool get canApproveLeave => canManageRoster || hasReports;

  /// The record self-service reads. Multi-branch is rare enough that picking the
  /// first is the right default; the page names which branch it is showing.
  String? get primaryEmployeeId =>
      employeeIds.isEmpty ? null : employeeIds.first;

  /// Where this session belongs after sign-in.
  ///
  /// Someone who manages the business lands on the roster even when they also
  /// have an employee record: managing is why they signed in, and their own leave
  /// is one tap away. Someone with only a record lands on their leave, which is
  /// the whole of HR for them — including a line manager, whose own leave is
  /// still the page they open most; their team's queue is a tab away and carries
  /// a count when something is waiting.
  HrLanding get landing {
    if (canManageRoster) return HrLanding.roster;
    if (hasOwnRecord) return HrLanding.myLeave;
    return HrLanding.unresolved;
  }

  @override
  String toString() =>
      'HrSession(${businessIds.length} owned, ${employeeIds.length} records, '
      '${reportIds.length} reports)';
}

/// The three ways a resolved session can end up.
enum HrLanding {
  /// Owns a business: the people directory.
  roster,

  /// Only an employee record: their own leave.
  myLeave,

  /// Neither. Signed in, but the database cannot tie the session to anything —
  /// a real state, and one that needs explaining rather than an empty list.
  unresolved,
}
