import 'package:flipper_models/helpers/goal_recurrence.dart';
import 'package:test/test.dart';

void main() {
  group('GoalRecurrence.fromWire', () {
    test('round-trips every value', () {
      for (final r in GoalRecurrence.values) {
        expect(GoalRecurrence.fromWire(r.wire), r);
      }
    });

    test('null or unknown is none (legacy documents)', () {
      expect(GoalRecurrence.fromWire(null), GoalRecurrence.none);
      expect(GoalRecurrence.fromWire('fortnightly'), GoalRecurrence.none);
      expect(GoalRecurrence.fromWire('MONTHLY'), GoalRecurrence.monthly);
    });
  });

  group('periodKey', () {
    test('none has no period', () {
      expect(GoalRecurrence.none.periodKey(DateTime(2026, 9, 30)), isNull);
    });

    test('monthly / quarterly / yearly', () {
      final d = DateTime(2026, 9, 30, 23, 59);
      expect(GoalRecurrence.monthly.periodKey(d), '2026-09');
      expect(GoalRecurrence.quarterly.periodKey(d), '2026-Q3');
      expect(GoalRecurrence.yearly.periodKey(d), '2026');
      expect(
        GoalRecurrence.quarterly.periodKey(DateTime(2026, 10, 1)),
        '2026-Q4',
      );
      expect(
        GoalRecurrence.quarterly.periodKey(DateTime(2026, 1, 1)),
        '2026-Q1',
      );
    });

    test('month boundary changes the key', () {
      expect(
        GoalRecurrence.monthly.periodKey(DateTime(2026, 12, 31, 23, 59)),
        '2026-12',
      );
      expect(GoalRecurrence.monthly.periodKey(DateTime(2027, 1, 1)), '2027-01');
    });

    test('weekly uses ISO weeks, including across New Year', () {
      // Wed 30 Sep 2026 is in ISO week 40.
      expect(
        GoalRecurrence.weekly.periodKey(DateTime(2026, 9, 30)),
        '2026-W40',
      );
      // Monday and Sunday of the same week share a key.
      expect(
        GoalRecurrence.weekly.periodKey(DateTime(2026, 9, 28)),
        '2026-W40',
      );
      expect(
        GoalRecurrence.weekly.periodKey(DateTime(2026, 10, 4, 23)),
        '2026-W40',
      );
      expect(
        GoalRecurrence.weekly.periodKey(DateTime(2026, 10, 5)),
        '2026-W41',
      );
      // Fri 1 Jan 2027 still belongs to 2026-W53.
      expect(GoalRecurrence.weekly.periodKey(DateTime(2027, 1, 1)), '2026-W53');
      // Mon 29 Dec 2025 is 2026-W01.
      expect(
        GoalRecurrence.weekly.periodKey(DateTime(2025, 12, 29)),
        '2026-W01',
      );
    });
  });

  group('nextResetAt', () {
    final d = DateTime(2026, 9, 30, 15);

    test('per frequency', () {
      expect(GoalRecurrence.weekly.nextResetAt(d), DateTime(2026, 10, 5));
      expect(GoalRecurrence.monthly.nextResetAt(d), DateTime(2026, 10, 1));
      expect(GoalRecurrence.quarterly.nextResetAt(d), DateTime(2026, 10, 1));
      expect(GoalRecurrence.yearly.nextResetAt(d), DateTime(2027, 1, 1));
      expect(GoalRecurrence.none.nextResetAt(d), isNull);
    });

    test('December rolls into the next year', () {
      final dec = DateTime(2026, 12, 15);
      expect(GoalRecurrence.monthly.nextResetAt(dec), DateTime(2027, 1, 1));
      expect(GoalRecurrence.quarterly.nextResetAt(dec), DateTime(2027, 1, 1));
    });
  });

  group('labels', () {
    test('restartLabel', () {
      expect(
        GoalRecurrence.monthly.restartLabel(DateTime(2026, 9, 30)),
        'restarts tomorrow',
      );
      expect(
        GoalRecurrence.monthly.restartLabel(DateTime(2026, 9, 19)),
        'restarts in 12 days',
      );
      expect(
        GoalRecurrence.monthly.restartLabel(DateTime(2026, 9, 2)),
        'restarts 1 Oct',
      );
      expect(GoalRecurrence.none.restartLabel(DateTime(2026, 9, 2)), '');
    });

    test('restartDateLabel', () {
      expect(
        GoalRecurrence.monthly.restartDateLabel(DateTime(2026, 9, 20)),
        'restarts 1 Oct',
      );
    });

    test('goalPeriodName', () {
      expect(goalPeriodName('2026-09'), 'September');
      expect(goalPeriodName('2026-W40'), 'week of 28 Sep');
      expect(goalPeriodName('2026-W01'), 'week of 29 Dec');
      expect(goalPeriodName('2026-Q3'), 'Q3 2026');
      expect(goalPeriodName('2026'), '2026');
      expect(goalPeriodName('garbage'), 'garbage');
    });
  });
}
