import 'package:flipper_hr/features/leave/data/leave_request.dart';
import 'package:flipper_hr/features/leave/data/leave_type.dart';
import 'package:flipper_hr/features/leave/data/leave_validation.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/fake_leave_repository.dart';

/// Fixed "today": a Tuesday, so weekday arithmetic in the tests is legible.
final _today = DateTime(2026, 8, 18);

LeaveRequest _draft({
  String id = '',
  LeaveType type = LeaveType.annual,
  DateTime? start,
  DateTime? end,
  double days = 5,
  String reason = '',
}) => LeaveRequest(
  id: id,
  employeeId: 'e-1',
  type: type,
  startDate: start ?? DateTime(2026, 9, 7),
  endDate: end ?? DateTime(2026, 9, 11),
  days: days,
  reason: reason,
);

void main() {
  group('validateLeaveDates', () {
    test('a normal future week is fine', () {
      expect(
        validateLeaveDates(
          start: DateTime(2026, 9, 7),
          end: DateTime(2026, 9, 11),
          today: _today,
        ),
        isNull,
      );
    });

    test('an inverted range is rejected', () {
      expect(
        validateLeaveDates(
          start: DateTime(2026, 9, 11),
          end: DateTime(2026, 9, 7),
          today: _today,
        ),
        contains('cannot be before'),
      );
    });

    test('missing dates say which one', () {
      expect(
        validateLeaveDates(start: null, end: _today, today: _today),
        contains('first day'),
      );
      expect(
        validateLeaveDates(start: _today, end: null, today: _today),
        contains('last day'),
      );
    });

    test('more than a year ahead reads as a mistyped year', () {
      expect(
        validateLeaveDates(
          start: DateTime(2028, 1, 4),
          end: DateTime(2028, 1, 8),
          today: _today,
        ),
        contains('more than a year ahead'),
      );
    });

    test('leave already under way can be filed late', () {
      expect(
        validateLeaveDates(
          start: _today.subtract(const Duration(days: 3)),
          end: _today,
          today: _today,
        ),
        isNull,
      );
    });

    test('very old leave is a records correction, not a request', () {
      expect(
        validateLeaveDates(
          start: _today.subtract(const Duration(days: 60)),
          end: _today.subtract(const Duration(days: 55)),
          today: _today,
        ),
        contains('manages the roster'),
      );
    });

    test('backdating can be refused outright', () {
      expect(
        validateLeaveDates(
          start: _today.subtract(const Duration(days: 1)),
          end: _today,
          today: _today,
          allowBackdated: false,
        ),
        contains('cannot start in the past'),
      );
    });

    test('starting today is not backdated', () {
      expect(
        validateLeaveDates(
          start: _today,
          end: _today,
          today: _today,
          allowBackdated: false,
        ),
        isNull,
      );
    });
  });

  group('validateLeaveReason', () {
    test('annual leave needs no justification', () {
      expect(
        validateLeaveReason(type: LeaveType.annual, reason: ''),
        isNull,
      );
    });

    test('every other type needs one', () {
      for (final type in LeaveType.values) {
        if (type == LeaveType.annual) continue;
        expect(
          validateLeaveReason(type: type, reason: ''),
          isNotNull,
          reason: '${type.wire} should require a reason',
        );
      }
    });

    test('whitespace is not a reason', () {
      expect(
        validateLeaveReason(type: LeaveType.sick, reason: '   '),
        isNotNull,
      );
    });

    test('a short real reason is accepted', () {
      expect(
        validateLeaveReason(type: LeaveType.sick, reason: 'Flu'),
        isNull,
      );
    });
  });

  group('validateLeaveRequest', () {
    test('a clean annual request has nothing wrong with it', () {
      expect(
        validateLeaveRequest(
          request: _draft(),
          today: _today,
          existing: const [],
        ),
        isEmpty,
      );
    });

    test('a weekend-only span is refused with the reason named', () {
      final problems = validateLeaveRequest(
        // Saturday to Sunday.
        request: _draft(
          start: DateTime(2026, 9, 12),
          end: DateTime(2026, 9, 13),
        ),
        today: _today,
        existing: const [],
      );

      expect(problems, contains(contains('all weekend')));
    });

    test('maternity leave over a weekend is fine, since it counts calendar days',
        () {
      expect(
        validateLeaveRequest(
          request: _draft(
            type: LeaveType.maternity,
            start: DateTime(2026, 9, 12),
            end: DateTime(2026, 9, 13),
            reason: 'Baby due',
          ),
          today: _today,
          existing: const [],
        ),
        isEmpty,
      );
    });

    test('overlapping an approved period is refused, naming the clash', () {
      final problems = validateLeaveRequest(
        request: _draft(
          start: DateTime(2026, 9, 9),
          end: DateTime(2026, 9, 15),
        ),
        today: _today,
        existing: [
          leaveRequest(
            id: 'existing',
            startDate: DateTime(2026, 9, 7),
            endDate: DateTime(2026, 9, 11),
            status: LeaveStatus.approved,
          ),
        ],
      );

      expect(problems, contains(contains('overlaps')));
      expect(problems, contains(contains('7 Sep 2026')));
    });

    test('overlapping a rejected period is allowed', () {
      expect(
        validateLeaveRequest(
          request: _draft(),
          today: _today,
          existing: [
            leaveRequest(
              id: 'existing',
              startDate: DateTime(2026, 9, 7),
              endDate: DateTime(2026, 9, 11),
              status: LeaveStatus.rejected,
            ),
          ],
        ),
        isEmpty,
      );
    });

    test('a request being edited does not clash with itself', () {
      final existing = leaveRequest(
        id: 'leave-1',
        startDate: DateTime(2026, 9, 7),
        endDate: DateTime(2026, 9, 11),
        status: LeaveStatus.pending,
      );

      expect(
        validateLeaveRequest(
          request: _draft(id: 'leave-1'),
          today: _today,
          existing: [existing],
        ),
        isEmpty,
      );
    });

    test('asking for more than the balance says how much is left', () {
      final problems = validateLeaveRequest(
        // 10 working days.
        request: _draft(
          start: DateTime(2026, 9, 7),
          end: DateTime(2026, 9, 18),
        ),
        today: _today,
        existing: [
          leaveRequest(
            id: 'spent',
            startDate: DateTime(2026, 3, 2),
            endDate: DateTime(2026, 3, 20),
            days: 15,
            status: LeaveStatus.approved,
          ),
        ],
      );

      expect(problems, contains(contains('Only 3 days')));
      expect(problems, contains(contains('10 days')));
    });

    test('an exhausted balance says so plainly', () {
      final problems = validateLeaveRequest(
        request: _draft(start: DateTime(2026, 9, 7), end: DateTime(2026, 9, 7)),
        today: _today,
        existing: [
          leaveRequest(
            id: 'spent',
            startDate: DateTime(2026, 3, 2),
            endDate: DateTime(2026, 3, 27),
            days: 18,
            status: LeaveStatus.approved,
          ),
        ],
      );

      expect(problems, contains(contains('No annual leave left for 2026')));
    });

    test('a pending request counts against the balance too', () {
      final problems = validateLeaveRequest(
        request: _draft(
          start: DateTime(2026, 9, 7),
          end: DateTime(2026, 9, 18),
        ),
        today: _today,
        existing: [
          leaveRequest(
            id: 'awaiting',
            startDate: DateTime(2026, 3, 2),
            endDate: DateTime(2026, 3, 20),
            days: 15,
            status: LeaveStatus.pending,
          ),
        ],
      );

      expect(problems, contains(contains('Only 3 days')));
    });

    test('a contract override raises what can be booked', () {
      expect(
        validateLeaveRequest(
          request: _draft(
            start: DateTime(2026, 9, 7),
            end: DateTime(2026, 9, 18),
          ),
          today: _today,
          existing: [
            leaveRequest(
              id: 'spent',
              startDate: DateTime(2026, 3, 2),
              endDate: DateTime(2026, 3, 20),
              days: 15,
              status: LeaveStatus.approved,
            ),
          ],
          annualOverride: 30,
        ),
        isEmpty,
      );
    });

    test('unpaid leave is never refused for lack of balance', () {
      expect(
        validateLeaveRequest(
          request: _draft(
            type: LeaveType.unpaid,
            start: DateTime(2026, 9, 7),
            end: DateTime(2026, 10, 30),
            reason: 'Family matter',
          ),
          today: _today,
          existing: const [],
        ),
        isEmpty,
      );
    });

    test('last year\'s leave does not consume this year\'s balance', () {
      expect(
        validateLeaveRequest(
          request: _draft(
            start: DateTime(2026, 9, 7),
            end: DateTime(2026, 9, 18),
          ),
          today: _today,
          existing: [
            leaveRequest(
              id: 'last-year',
              startDate: DateTime(2025, 3, 3),
              endDate: DateTime(2025, 3, 21),
              days: 15,
              status: LeaveStatus.approved,
            ),
          ],
        ),
        isEmpty,
      );
    });

    test('a bad date range suppresses the follow-on complaints', () {
      // An inverted range would otherwise also report "pick at least one day",
      // which is a symptom rather than the problem.
      final problems = validateLeaveRequest(
        request: _draft(
          start: DateTime(2026, 9, 11),
          end: DateTime(2026, 9, 7),
        ),
        today: _today,
        existing: const [],
      );

      expect(problems, hasLength(1));
      expect(problems.single, contains('cannot be before'));
    });

    test('a missing reason and a clash are both reported', () {
      final problems = validateLeaveRequest(
        request: _draft(type: LeaveType.sick, reason: ''),
        today: _today,
        existing: [
          leaveRequest(
            id: 'existing',
            type: LeaveType.sick,
            startDate: DateTime(2026, 9, 7),
            endDate: DateTime(2026, 9, 11),
            status: LeaveStatus.approved,
          ),
        ],
      );

      expect(problems, hasLength(2));
    });
  });

  group('findOverlap', () {
    test('sharing a single day counts as an overlap', () {
      final clash = findOverlap(
        request: _draft(
          start: DateTime(2026, 9, 11),
          end: DateTime(2026, 9, 15),
        ),
        existing: [
          leaveRequest(
            id: 'existing',
            startDate: DateTime(2026, 9, 7),
            endDate: DateTime(2026, 9, 11),
            status: LeaveStatus.approved,
          ),
        ],
      );

      expect(clash?.id, 'existing');
    });

    test('adjacent periods do not overlap', () {
      final clash = findOverlap(
        request: _draft(
          start: DateTime(2026, 9, 14),
          end: DateTime(2026, 9, 18),
        ),
        existing: [
          leaveRequest(
            id: 'existing',
            startDate: DateTime(2026, 9, 7),
            endDate: DateTime(2026, 9, 11),
            status: LeaveStatus.approved,
          ),
        ],
      );

      expect(clash, isNull);
    });

    test('an enclosing period is found', () {
      final clash = findOverlap(
        request: _draft(
          start: DateTime(2026, 9, 9),
          end: DateTime(2026, 9, 9),
        ),
        existing: [
          leaveRequest(
            id: 'existing',
            startDate: DateTime(2026, 9, 7),
            endDate: DateTime(2026, 9, 11),
            status: LeaveStatus.pending,
          ),
        ],
      );

      expect(clash?.id, 'existing');
    });

    test('overlap is checked across leave types', () {
      // You cannot be on sick leave and annual leave the same day, whatever the
      // balances say.
      final clash = findOverlap(
        request: _draft(type: LeaveType.sick),
        existing: [
          leaveRequest(
            id: 'existing',
            startDate: DateTime(2026, 9, 7),
            endDate: DateTime(2026, 9, 11),
            status: LeaveStatus.approved,
          ),
        ],
      );

      expect(clash?.id, 'existing');
    });
  });
}
