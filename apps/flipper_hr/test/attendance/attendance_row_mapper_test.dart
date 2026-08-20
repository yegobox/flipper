import 'package:flipper_hr/features/attendance/data/attendance_row_mapper.dart';
import 'package:flipper_hr/features/attendance/data/attendance_session.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Map<String, dynamic> row([Map<String, dynamic> overrides = const {}]) => {
    'id': 'sess-1',
    'employee_id': 'emp-1',
    'business_id': 'biz-1',
    'branch_id': 'branch-1',
    'work_date': '2026-08-18',
    'started_at': '2026-08-18T06:07:00.000Z',
    'ended_at': '2026-08-18T14:37:00.000Z',
    'minutes': 510,
    'source': 'self',
    'note': '',
    'created_at': '2026-08-18T06:07:00.000Z',
    'updated_at': '2026-08-18T14:37:00.000Z',
    ...overrides,
  };

  group('fromRow', () {
    test('reads a closed session', () {
      final s = AttendanceRowMapper.fromRow(row());

      expect(s.id, 'sess-1');
      expect(s.employeeId, 'emp-1');
      expect(s.branchId, 'branch-1');
      expect(s.workDate, DateTime(2026, 8, 18));
      expect(s.startedAt, DateTime.utc(2026, 8, 18, 6, 7));
      expect(s.endedAt, DateTime.utc(2026, 8, 18, 14, 37));
      expect(s.minutes, 510);
      expect(s.isOpen, isFalse);
      expect(s.source, AttendanceSource.self);
    });

    test('an open session keeps minutes null, not zero', () {
      final s = AttendanceRowMapper.fromRow(
        row({'ended_at': null, 'minutes': null}),
      );

      expect(s.isOpen, isTrue);
      expect(s.minutes, isNull, reason: '0 would read as "worked nothing"');
    });

    test('minutes arrives as int, numeric or string', () {
      expect(AttendanceRowMapper.fromRow(row({'minutes': 90})).minutes, 90);
      expect(AttendanceRowMapper.fromRow(row({'minutes': 90.4})).minutes, 90);
      expect(AttendanceRowMapper.fromRow(row({'minutes': '510'})).minutes, 510);
    });

    test('an unparseable minutes value reads as null, not as hours worked', () {
      expect(AttendanceRowMapper.fromRow(row({'minutes': 'n/a'})).minutes, isNull);
    });

    test('an unknown source falls back rather than throwing', () {
      expect(
        AttendanceRowMapper.fromRow(row({'source': 'turnstile'})).source,
        AttendanceSource.self,
      );
    });

    test('a timestamp in work_date still reads as a plain date', () {
      final s = AttendanceRowMapper.fromRow(
        row({'work_date': '2026-08-18T22:00:00.000Z'}),
      );
      expect(s.workDate.year, 2026);
      expect(s.workDate.hour, 0);
    });

    test('missing dates do not throw, so one bad row cannot hide the day', () {
      final s = AttendanceRowMapper.fromRow(
        row({'work_date': null, 'started_at': null}),
      );
      expect(s.workDate.year, 1970);
      expect(s.startedAt.year, 1970);
    });
  });

  group('toInsertRow', () {
    final open = AttendanceSession(
      employeeId: 'emp-1',
      workDate: DateTime(2026, 8, 18),
      startedAt: DateTime.utc(2026, 8, 18, 6),
      note: '  late bus  ',
    );

    test('omits everything the trigger owns', () {
      final insert = AttendanceRowMapper.toInsertRow(open);

      for (final derived in ['id', 'business_id', 'branch_id', 'work_date',
                             'minutes']) {
        expect(
          insert.containsKey(derived),
          isFalse,
          reason: '$derived is derived server-side',
        );
      }
      expect(insert['employee_id'], 'emp-1');
    });

    test('leaves started_at to the database by default', () {
      // The whole point: a device with a wrong clock must not be able to write
      // hours.
      expect(
        AttendanceRowMapper.toInsertRow(open).containsKey('started_at'),
        isFalse,
      );
      expect(
        AttendanceRowMapper.toInsertRow(open, useServerStart: false),
        containsPair('started_at', '2026-08-18T06:00:00.000Z'),
      );
    });

    test('trims the note', () {
      expect(AttendanceRowMapper.toInsertRow(open)['note'], 'late bus');
    });
  });

  group('toCorrectionRow', () {
    test('writes the timestamps and marks the entry as manager-recorded', () {
      final corrected = AttendanceSession(
        id: 'sess-1',
        employeeId: 'emp-1',
        workDate: DateTime(2026, 8, 18),
        startedAt: DateTime.utc(2026, 8, 18, 6),
        endedAt: DateTime.utc(2026, 8, 18, 15),
      );
      final update = AttendanceRowMapper.toCorrectionRow(corrected);

      expect(update['started_at'], '2026-08-18T06:00:00.000Z');
      expect(update['ended_at'], '2026-08-18T15:00:00.000Z');
      expect(update['source'], 'manager');
      // minutes is recomputed by the trigger; sending it invites disagreement.
      expect(update.containsKey('minutes'), isFalse);
      expect(update.containsKey('work_date'), isFalse);
    });

    test('reopening a session clears the clock-out', () {
      final reopened = AttendanceSession(
        id: 'sess-1',
        employeeId: 'emp-1',
        workDate: DateTime(2026, 8, 18),
        startedAt: DateTime.utc(2026, 8, 18, 6),
      );
      expect(AttendanceRowMapper.toCorrectionRow(reopened)['ended_at'], isNull);
    });
  });
}
