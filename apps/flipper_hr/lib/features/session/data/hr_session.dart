/// Who the signed-in person is, in HR's terms.
///
/// HR has two audiences and one login. Which one you are is not a setting — it
/// is what the database can prove about you, and the two proofs are independent:
///
///   * [businessIds] — businesses you OWN (`hr_user_business_ids()`). This is
///     what the roster and the approvals queue are scoped to.
///   * [employeeIds] — `hr_employees` rows that ARE you (`hr_my_employee_ids()`).
///     This is what your own leave is scoped to.
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
    this.identityKeys = const [],
  });

  /// Nobody: no ownership and no employee record. Also what a failed resolve
  /// degrades to, so a diagnostic-worthy state never reads as a permission.
  static const none = HrSession();

  /// Businesses the caller owns. Non-empty means the roster is theirs to manage.
  final List<String> businessIds;

  /// The caller's own employee rows — usually one, more if they are on the
  /// roster at more than one branch.
  final List<String> employeeIds;

  /// The `public.users` ids the server resolved for this session. Diagnostics
  /// only: an empty list is the signature of a session the database cannot tie
  /// to any Flipper account.
  final List<String> identityKeys;

  /// May see the branch roster, and approve other people's leave.
  bool get canManageRoster => businessIds.isNotEmpty;

  /// Has a record of their own, so they have leave to book and a balance to see.
  bool get hasOwnRecord => employeeIds.isNotEmpty;

  /// The record self-service reads. Multi-branch is rare enough that picking the
  /// first is the right default; the page names which branch it is showing.
  String? get primaryEmployeeId =>
      employeeIds.isEmpty ? null : employeeIds.first;

  /// Where this session belongs after sign-in.
  ///
  /// Someone who owns the business lands on the roster even when they also have
  /// an employee record: managing is why they signed in, and their own leave is
  /// one tap away. Someone with only a record lands on their leave, which is the
  /// whole of HR for them.
  HrLanding get landing {
    if (canManageRoster) return HrLanding.roster;
    if (hasOwnRecord) return HrLanding.myLeave;
    return HrLanding.unresolved;
  }

  @override
  String toString() =>
      'HrSession(${businessIds.length} owned, ${employeeIds.length} records)';
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
