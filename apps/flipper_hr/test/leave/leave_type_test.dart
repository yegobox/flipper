import 'package:flipper_hr/features/leave/data/leave_request.dart';
import 'package:flipper_hr/features/leave/data/leave_type.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('LeaveType', () {
    test('carries the statutory Rwandan entitlements', () {
      expect(LeaveType.annual.entitlementDays, 18);
      expect(LeaveType.sick.entitlementDays, 15);
      expect(LeaveType.maternity.entitlementDays, 84);
      expect(LeaveType.paternity.entitlementDays, 4);
      expect(LeaveType.compassionate.entitlementDays, 6);
    });

    test('unpaid leave is uncapped', () {
      expect(LeaveType.unpaid.entitlementDays, isNull);
      expect(LeaveType.unpaid.hasEntitlement, isFalse);
    });

    test('only maternity leave runs in calendar days', () {
      for (final type in LeaveType.values) {
        expect(
          type.countsCalendarDays,
          type == LeaveType.maternity,
          reason: '${type.wire} counts the wrong unit',
        );
      }
    });

    test('wire values are the ones the CHECK constraint allows', () {
      // Must match supabase/migrations/0004_hr_leave.sql. A mismatch here is a
      // 400 on every insert of that type, so it is worth pinning.
      expect(
        {for (final t in LeaveType.values) t.wire},
        {'annual', 'sick', 'maternity', 'paternity', 'compassionate', 'unpaid'},
      );
    });

    test('fromWire is tolerant of casing and separators', () {
      expect(LeaveType.fromWire('SICK'), LeaveType.sick);
      expect(LeaveType.fromWire('compassionate'), LeaveType.compassionate);
      expect(LeaveType.fromWire('un-paid'), LeaveType.unpaid);
    });

    test('fromWire falls back to annual for anything unknown', () {
      expect(LeaveType.fromWire(null), LeaveType.annual);
      expect(LeaveType.fromWire(''), LeaveType.annual);
      expect(LeaveType.fromWire('sabbatical'), LeaveType.annual);
    });
  });

  group('LeaveStatus', () {
    test('approved and rejected count as decided', () {
      expect(LeaveStatus.approved.isDecided, isTrue);
      expect(LeaveStatus.rejected.isDecided, isTrue);
      expect(LeaveStatus.pending.isDecided, isFalse);
      expect(LeaveStatus.cancelled.isDecided, isFalse);
    });

    test('approved and pending days are held against the balance', () {
      expect(LeaveStatus.approved.holdsBalance, isTrue);
      expect(LeaveStatus.pending.holdsBalance, isTrue);
      expect(LeaveStatus.rejected.holdsBalance, isFalse);
      expect(LeaveStatus.cancelled.holdsBalance, isFalse);
    });

    test('wire values match the CHECK constraint', () {
      expect(
        {for (final s in LeaveStatus.values) s.wire},
        {'pending', 'approved', 'rejected', 'cancelled'},
      );
    });

    test('fromWire falls back to pending', () {
      expect(LeaveStatus.fromWire('APPROVED'), LeaveStatus.approved);
      expect(LeaveStatus.fromWire('nonsense'), LeaveStatus.pending);
      expect(LeaveStatus.fromWire(null), LeaveStatus.pending);
    });
  });

  group('LeaveRequest', () {
    test('is charged to the year it starts in', () {
      final straddling = LeaveRequest(
        employeeId: 'e-1',
        type: LeaveType.annual,
        startDate: DateTime(2026, 12, 28),
        endDate: DateTime(2027, 1, 8),
        days: 8,
      );
      expect(straddling.accrualYear, 2026);
    });

    test('isUpcoming ignores the time of day', () {
      final request = LeaveRequest(
        employeeId: 'e-1',
        type: LeaveType.annual,
        startDate: DateTime(2026, 8, 18),
        endDate: DateTime(2026, 8, 18),
        days: 1,
      );
      expect(request.isUpcoming(asOf: DateTime(2026, 8, 17, 23, 59)), isTrue);
      expect(request.isUpcoming(asOf: DateTime(2026, 8, 18, 0, 1)), isFalse);
    });

    test('an unsaved request is not persisted', () {
      final request = LeaveRequest(
        employeeId: 'e-1',
        type: LeaveType.annual,
        startDate: DateTime(2026, 9, 7),
        endDate: DateTime(2026, 9, 7),
        days: 1,
      );
      expect(request.isPersisted, isFalse);
      expect(request.copyWith(id: 'leave-1').isPersisted, isTrue);
    });

    test('clearDecision wipes the whole decision, not just the status', () {
      final decided = LeaveRequest(
        id: 'leave-1',
        employeeId: 'e-1',
        type: LeaveType.annual,
        startDate: DateTime(2026, 9, 7),
        endDate: DateTime(2026, 9, 7),
        days: 1,
        status: LeaveStatus.approved,
        decidedBy: 'user-owner',
        decidedAt: DateTime.utc(2026, 8, 1),
        decisionNote: 'Fine by me',
      );

      final cleared = decided.copyWith(
        status: LeaveStatus.cancelled,
        clearDecision: true,
      );

      expect(cleared.decidedBy, isNull);
      expect(cleared.decidedAt, isNull);
      expect(cleared.decisionNote, isEmpty);
    });
  });
}
