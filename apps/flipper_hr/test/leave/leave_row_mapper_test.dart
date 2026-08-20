import 'package:flipper_hr/features/leave/data/leave_request.dart';
import 'package:flipper_hr/features/leave/data/leave_row_mapper.dart';
import 'package:flipper_hr/features/leave/data/leave_type.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/fake_leave_repository.dart';

void main() {
  group('fromRow', () {
    test('reads a full row', () {
      final request = LeaveRowMapper.fromRow({
        'id': 'leave-1',
        'employee_id': 'e-1',
        'business_id': 'biz-1',
        'branch_id': 'branch-1',
        'leave_type': 'sick',
        'start_date': '2026-09-07',
        'end_date': '2026-09-11',
        'days': 5,
        'reason': 'Flu',
        'status': 'approved',
        'requested_by': 'user-staff',
        'decided_by': 'user-owner',
        'decided_at': '2026-08-18T09:30:00Z',
        'decision_note': 'Get well',
        'created_at': '2026-08-17T10:00:00Z',
        'updated_at': '2026-08-18T09:30:00Z',
      });

      expect(request.id, 'leave-1');
      expect(request.type, LeaveType.sick);
      expect(request.status, LeaveStatus.approved);
      expect(request.startDate, DateTime(2026, 9, 7));
      expect(request.endDate, DateTime(2026, 9, 11));
      expect(request.days, 5);
      expect(request.reason, 'Flu');
      expect(request.decidedBy, 'user-owner');
      expect(request.decidedAt, DateTime.utc(2026, 8, 18, 9, 30));
      expect(request.decisionNote, 'Get well');
    });

    test('accepts numeric days as int, double or string', () {
      for (final raw in <Object>[5, 5.0, '5', '5.0']) {
        expect(
          LeaveRowMapper.fromRow({'days': raw}).days,
          5,
          reason: 'days as ${raw.runtimeType}',
        );
      }
    });

    test('keeps a half day', () {
      expect(LeaveRowMapper.fromRow({'days': '0.5'}).days, 0.5);
    });

    test('dates are read date-only, so no timezone shifts the day', () {
      final request = LeaveRowMapper.fromRow({
        'start_date': '2026-09-07',
        'end_date': '2026-09-07',
      });

      expect(request.startDate, DateTime(2026, 9, 7));
      expect(request.startDate.hour, 0);
    });

    test('a pending row has no decision', () {
      final request = LeaveRowMapper.fromRow({
        'status': 'pending',
        'decided_by': null,
        'decided_at': null,
        'decision_note': '',
      });

      expect(request.status, LeaveStatus.pending);
      expect(request.decidedBy, isNull);
      expect(request.decidedAt, isNull);
    });

    test('an unrecognised type or status falls back rather than throwing', () {
      final request = LeaveRowMapper.fromRow({
        'leave_type': 'study',
        'status': 'escalated',
      });

      expect(request.type, LeaveType.annual);
      expect(request.status, LeaveStatus.pending);
    });

    test('missing dates read as the epoch instead of breaking the list', () {
      final request = LeaveRowMapper.fromRow(const {});

      expect(request.startDate, DateTime.utc(1970));
      expect(request.endDate, DateTime.utc(1970));
    });
  });

  group('toInsertRow', () {
    test('sends the wire values and forces pending', () {
      final row = LeaveRowMapper.toInsertRow(
        leaveRequest(
          type: LeaveType.compassionate,
          startDate: DateTime(2026, 9, 7),
          endDate: DateTime(2026, 9, 9),
          days: 3,
          reason: '  Funeral  ',
          // Even if the caller asks for approved, the insert must not.
          status: LeaveStatus.approved,
          requestedBy: 'user-staff',
        ),
      );

      expect(row['leave_type'], 'compassionate');
      expect(row['status'], 'pending');
      expect(row['start_date'], '2026-09-07');
      expect(row['end_date'], '2026-09-09');
      expect(row['days'], 3);
      expect(row['reason'], 'Funeral');
      expect(row['requested_by'], 'user-staff');
    });

    test('never sends an id — Postgres owns it', () {
      final row = LeaveRowMapper.toInsertRow(leaveRequest(id: 'leave-9'));

      expect(row.containsKey('id'), isFalse);
    });

    test('a blank requester is null, not an empty string', () {
      final row = LeaveRowMapper.toInsertRow(leaveRequest(requestedBy: ''));

      expect(row['requested_by'], isNull);
    });

    test('carries the scope columns, since they are NOT NULL', () {
      final row = LeaveRowMapper.toInsertRow(leaveRequest());

      expect(row['business_id'], 'biz-1');
      expect(row['branch_id'], 'branch-1');
    });
  });

  group('toDecisionRow', () {
    test('an approval records who decided and when', () {
      final row = LeaveRowMapper.toDecisionRow(
        status: LeaveStatus.approved,
        decidedBy: 'user-owner',
        note: '  Fine  ',
        decidedAt: DateTime.utc(2026, 8, 18, 9),
      );

      expect(row['status'], 'approved');
      expect(row['decided_by'], 'user-owner');
      expect(row['decided_at'], '2026-08-18T09:00:00.000Z');
      expect(row['decision_note'], 'Fine');
    });

    test('a rejection keeps the note, which the person will read', () {
      final row = LeaveRowMapper.toDecisionRow(
        status: LeaveStatus.rejected,
        decidedBy: 'user-owner',
        note: 'Too many people out that week',
      );

      expect(row['status'], 'rejected');
      expect(row['decision_note'], 'Too many people out that week');
      expect(row['decided_at'], isNotNull);
    });

    test('a cancellation records no decision at all', () {
      // hr_leave_decision_is_complete requires decided_at to be null for a
      // cancelled row, so this is a constraint, not a preference.
      final row = LeaveRowMapper.toDecisionRow(
        status: LeaveStatus.cancelled,
        decidedBy: 'user-staff',
        note: 'Changed my mind',
      );

      expect(row['status'], 'cancelled');
      expect(row['decided_by'], isNull);
      expect(row['decided_at'], isNull);
      expect(row['decision_note'], '');
    });

    test('always stamps updated_at', () {
      final row = LeaveRowMapper.toDecisionRow(status: LeaveStatus.cancelled);

      expect(row['updated_at'], isA<String>());
    });
  });
}
