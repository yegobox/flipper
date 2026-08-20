/// Field-level and whole-request checks for booking leave.
///
/// Pure functions over values, mirroring `employee_validation.dart`: the form
/// calls them per field, and [validateLeaveRequest] runs the checks that need
/// more than one field (or the rest of the person's year) before submitting.
///
/// Every rule here is also enforced or implied by the database — the CHECK
/// constraints and the RLS policies in `0004_hr_leave.sql` — except the balance
/// check, which Postgres cannot make because it does not know the working-week.
/// These messages exist to say *why* in the form rather than as a 400 afterwards.
library;

import 'package:flipper_hr/features/leave/data/leave_balance.dart';
import 'package:flipper_hr/features/leave/data/leave_request.dart';
import 'package:flipper_hr/features/leave/data/leave_type.dart';
import 'package:flipper_hr/features/leave/data/leave_working_days.dart';
import 'package:flipper_hr/features/people/data/money_format.dart';

/// How far ahead leave may be booked. A year is generous for a real request and
/// still catches a mistyped year, which is the actual failure mode (2027 for
/// 2026 reads as plausible and silently reserves next year's balance).
const maxLeaveNoticeDays = 366;

/// Leave already under way can be filed late — someone taken ill does not fill
/// in a form first. Anything older than this is a records correction, and should
/// be entered by whoever manages the roster, not booked as a request.
const maxBackdatedLeaveDays = 30;

String? validateLeaveDates({
  required DateTime? start,
  required DateTime? end,
  required DateTime today,
  bool allowBackdated = true,
}) {
  if (start == null) return 'Pick the first day of leave.';
  if (end == null) return 'Pick the last day of leave.';

  final from = _dateOnly(start);
  final to = _dateOnly(end);
  final now = _dateOnly(today);

  if (to.isBefore(from)) return 'The last day cannot be before the first day.';

  final notice = to.difference(now).inDays;
  if (notice > maxLeaveNoticeDays) {
    return 'Leave cannot be booked more than a year ahead. '
        'Check the year on these dates.';
  }

  final backdated = now.difference(from).inDays;
  if (backdated > 0 && !allowBackdated) {
    return 'Leave cannot start in the past.';
  }
  if (backdated > maxBackdatedLeaveDays) {
    return 'This started more than $maxBackdatedLeaveDays days ago. Ask '
        'whoever manages the roster to record it instead.';
  }

  return null;
}

/// A reason is required for everything except annual leave.
///
/// Annual leave needs no justification — it is an entitlement. The others are
/// granted on a circumstance, and an approver with no idea what the circumstance
/// is cannot decide.
String? validateLeaveReason({required LeaveType type, required String reason}) {
  if (type == LeaveType.annual) return null;
  if (reason.trim().length < 3) {
    return 'Say briefly why you need ${type.label.toLowerCase()}.';
  }
  return null;
}

/// Everything wrong with a request, in the order the form shows the fields.
///
/// [existing] is the person's other requests — used for the overlap check and,
/// through [balance], for the entitlement check. The request being edited is
/// excluded by id, so re-saving it does not clash with itself.
List<String> validateLeaveRequest({
  required LeaveRequest request,
  required DateTime today,
  required Iterable<LeaveRequest> existing,
  double? annualOverride,
  bool allowBackdated = true,
}) {
  final problems = <String>[];

  final dateProblem = validateLeaveDates(
    start: request.startDate,
    end: request.endDate,
    today: today,
    allowBackdated: allowBackdated,
  );
  if (dateProblem != null) problems.add(dateProblem);

  final reasonProblem = validateLeaveReason(
    type: request.type,
    reason: request.reason,
  );
  if (reasonProblem != null) problems.add(reasonProblem);

  // Only worth computing once the dates make sense; a 0-day span from an
  // inverted range would otherwise produce a second, confusing complaint.
  if (dateProblem == null) {
    final days = leaveDaysFor(
      type: request.type,
      start: request.startDate,
      end: request.endDate,
    );
    if (days <= 0) {
      problems.add(
        request.type.countsCalendarDays
            ? 'Pick at least one day.'
            : 'That period is all weekend — pick at least one working day.',
      );
    }

    final clash = findOverlap(request: request, existing: existing);
    if (clash != null) {
      problems.add(
        'This overlaps leave you already have from '
        '${formatShortDate(clash.startDate)} to '
        '${formatShortDate(clash.endDate)} '
        '(${clash.status.label.toLowerCase()}).',
      );
    }

    if (days > 0 && request.type.hasEntitlement) {
      final balance = LeaveBalance.of(
        type: request.type,
        year: request.accrualYear,
        // The request under edit must not count against itself.
        requests: _without(existing, request.id),
        annualOverride: annualOverride,
      );
      final left = balance.remaining;
      if (left != null && days > left) {
        problems.add(
          left <= 0
              ? 'No ${request.type.label.toLowerCase()} left for '
                    '${request.accrualYear}.'
              : 'Only ${formatLeaveDays(left)} of ${request.type.label.toLowerCase()} '
                    'left for ${request.accrualYear}; this asks for '
                    '${formatLeaveDays(days)}.',
        );
      }
    }
  }

  return problems;
}

/// The first of [existing] whose period touches [request]'s, or null.
///
/// Only requests that still hold the days count: a rejected or cancelled period
/// is not leave, so booking over it is fine.
LeaveRequest? findOverlap({
  required LeaveRequest request,
  required Iterable<LeaveRequest> existing,
}) {
  final from = _dateOnly(request.startDate);
  final to = _dateOnly(request.endDate);
  for (final other in _without(existing, request.id)) {
    if (!other.status.holdsBalance) continue;
    final otherFrom = _dateOnly(other.startDate);
    final otherTo = _dateOnly(other.endDate);
    // Inclusive on both ends: sharing a single day is an overlap.
    if (!otherTo.isBefore(from) && !otherFrom.isAfter(to)) return other;
  }
  return null;
}

/// Drops the row with [id], when there is one. A blank id (an unsaved request)
/// excludes nothing.
Iterable<LeaveRequest> _without(Iterable<LeaveRequest> requests, String id) =>
    id.isEmpty ? requests : requests.where((r) => r.id != id);

DateTime _dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);
