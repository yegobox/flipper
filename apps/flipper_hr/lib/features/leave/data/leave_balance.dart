import 'package:flipper_hr/features/leave/data/leave_request.dart';
import 'package:flipper_hr/features/leave/data/leave_type.dart';

/// What is left of one leave type for one year.
///
/// Pure value: built by [LeaveBalance.of] from an entitlement and a list of
/// requests, with no clock and no backend involved. The screen shows these; the
/// validator refuses a request that would push [remaining] below zero.
class LeaveBalance {
  const LeaveBalance({
    required this.type,
    required this.year,
    required this.entitlement,
    required this.approved,
    required this.pending,
  });

  /// Reduces [requests] to the balance for one [type] in one [year].
  ///
  /// Requests are filtered here rather than by the caller so the year rule
  /// ([LeaveRequest.accrualYear]) is applied in exactly one place.
  factory LeaveBalance.of({
    required LeaveType type,
    required int year,
    required Iterable<LeaveRequest> requests,
    double? annualOverride,
  }) {
    var approved = 0.0;
    var pending = 0.0;
    for (final r in requests) {
      if (r.type != type || r.accrualYear != year) continue;
      switch (r.status) {
        case LeaveStatus.approved:
          approved += r.days;
        case LeaveStatus.pending:
          pending += r.days;
        case LeaveStatus.rejected:
        case LeaveStatus.cancelled:
          break;
      }
    }
    return LeaveBalance(
      type: type,
      year: year,
      entitlement: entitlementFor(type, annualOverride: annualOverride),
      approved: approved,
      pending: pending,
    );
  }

  final LeaveType type;
  final int year;

  /// Days granted for the year, or null when the type is uncapped.
  final double? entitlement;

  /// Days already approved.
  final double approved;

  /// Days requested and not yet decided. Held against the balance so two
  /// overlapping requests cannot both look affordable — see
  /// [LeaveStatus.holdsBalance].
  final double pending;

  /// Approved plus pending: everything currently committed.
  double get committed => approved + pending;

  /// Days still bookable, or null when the type is uncapped.
  ///
  /// Can go negative if leave was approved past the entitlement (an owner may
  /// approve whatever they choose — the database does not stop them). Showing
  /// the overdraft is more useful than clamping it to zero and hiding it.
  double? get remaining {
    final total = entitlement;
    return total == null ? null : total - committed;
  }

  /// True when this type has a cap at all. [remaining] is null when false.
  bool get isCapped => entitlement != null;

  /// True when the balance is spent or overdrawn. Always false for an uncapped
  /// type.
  bool get isExhausted {
    final left = remaining;
    return left != null && left <= 0;
  }

  /// Committed share of the entitlement, 0–1, for a progress bar. Null when
  /// uncapped, and clamped so an overdraft does not overflow the bar.
  double? get usedFraction {
    final total = entitlement;
    if (total == null || total <= 0) return null;
    final fraction = committed / total;
    return fraction < 0 ? 0 : (fraction > 1 ? 1 : fraction);
  }

  /// The entitlement for [type], honouring a per-person annual override.
  ///
  /// The override applies to annual leave only: it is the one entitlement a
  /// contract negotiates, and `hr_employees.annual_leave_days` is named for it.
  /// A null override means "use the statutory default", not zero — so an
  /// employee record that predates the column keeps the legal minimum.
  static double? entitlementFor(LeaveType type, {double? annualOverride}) {
    if (type == LeaveType.annual && annualOverride != null) {
      return annualOverride;
    }
    return type.entitlementDays?.toDouble();
  }

  /// Every type's balance for the year, in [LeaveType.values] order, so the
  /// summary row is stable between builds.
  static List<LeaveBalance> allFor({
    required int year,
    required Iterable<LeaveRequest> requests,
    double? annualOverride,
  }) {
    // Materialised once: `of` walks the whole list per type, and requests may
    // be a lazy view over a larger collection.
    final all = requests.toList(growable: false);
    return [
      for (final type in LeaveType.values)
        LeaveBalance.of(
          type: type,
          year: year,
          requests: all,
          annualOverride: annualOverride,
        ),
    ];
  }

  @override
  String toString() =>
      'LeaveBalance(${type.wire} $year: $committed/${entitlement ?? '∞'})';
}
