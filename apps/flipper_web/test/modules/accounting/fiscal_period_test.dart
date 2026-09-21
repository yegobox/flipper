import 'package:flipper_web/modules/accounting/data/fiscal_period_models.dart';
import 'package:flipper_web/modules/accounting/data/mapper/fiscal_period_row_mapper.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FiscalPeriod', () {
    test('keyFor pads the month so keys sort chronologically', () {
      // Sorting is lexicographic in the repository, so "2026-9" would sort
      // after "2026-10" and the period list would be wrong from September.
      expect(FiscalPeriod.keyFor(DateTime.utc(2026, 9, 21)), '2026-09');
      expect(FiscalPeriod.keyFor(DateTime.utc(2026, 12, 1)), '2026-12');
      final keys = ['2026-09', '2026-10', '2026-11']..sort();
      expect(keys, ['2026-09', '2026-10', '2026-11']);
    });

    test('openMonth spans the whole calendar month', () {
      final p = FiscalPeriod.openMonth(DateTime.utc(2026, 2, 14), name: 'Feb 2026');
      expect(p.startsOn, DateTime.utc(2026, 2, 1));
      expect(p.endsOn, DateTime.utc(2026, 2, 28), reason: '2026 is not a leap year');
      expect(p.status, FiscalPeriodStatus.open);
      expect(p.isClosed, isFalse);
    });

    test('openMonth handles December without rolling the year wrong', () {
      final p = FiscalPeriod.openMonth(DateTime.utc(2026, 12, 9), name: 'Dec 2026');
      expect(p.endsOn, DateTime.utc(2026, 12, 31));
    });

    test('covers is inclusive of both ends', () {
      final p = FiscalPeriod.openMonth(DateTime.utc(2026, 9, 10), name: 'Sep 2026');
      expect(p.covers(DateTime.utc(2026, 9, 1)), isTrue);
      expect(p.covers(DateTime.utc(2026, 9, 30)), isTrue);
      expect(p.covers(DateTime.utc(2026, 8, 31)), isFalse);
      expect(p.covers(DateTime.utc(2026, 10, 1)), isFalse);
    });

    test('closed and locked both block posting; open does not', () {
      expect(FiscalPeriodStatus.open.blocksPosting, isFalse);
      expect(FiscalPeriodStatus.closed.blocksPosting, isTrue);
      expect(FiscalPeriodStatus.locked.blocksPosting, isTrue);
    });

    test('an unknown status parses as open rather than blocking posting', () {
      // Failing closed on a typo would stop a business trading.
      expect(FiscalPeriodStatus.parse('nonsense'), FiscalPeriodStatus.open);
      expect(FiscalPeriodStatus.parse(null), FiscalPeriodStatus.open);
      expect(FiscalPeriodStatus.parse('CLOSED'), FiscalPeriodStatus.closed);
    });
  });

  group('FiscalPeriodRowMapper', () {
    test('writes both camelCase and snake_case for every field', () {
      // Flutter reads camelCase; data-connector maps snake_case onto the
      // Postgres columns. Dropping either half breaks one of the two.
      final row = FiscalPeriodRowMapper.toRow(
        businessId: 'biz-1',
        period: FiscalPeriod.openMonth(DateTime.utc(2026, 9, 3), name: 'Sep 2026')
            .copyWith(
          status: FiscalPeriodStatus.closed,
          closedAt: DateTime.utc(2026, 10, 1, 8, 30),
          closedBy: 'Ann',
        ),
        id: 'biz-1_2026-09',
      );

      expect(row['businessId'], 'biz-1');
      expect(row['business_id'], 'biz-1');
      expect(row['periodKey'], '2026-09');
      expect(row['period_key'], '2026-09');
      expect(row['startsOn'], '2026-09-01');
      expect(row['starts_on'], '2026-09-01');
      expect(row['endsOn'], '2026-09-30');
      expect(row['ends_on'], '2026-09-30');
      expect(row['status'], 'closed');
      expect(row['closedBy'], 'Ann');
      expect(row['closed_by'], 'Ann');
    });

    test('round-trips a closed period', () {
      final original = FiscalPeriod.openMonth(
        DateTime.utc(2026, 9, 3),
        name: 'Sep 2026',
      ).copyWith(
        status: FiscalPeriodStatus.closed,
        closedAt: DateTime.utc(2026, 10, 1, 8, 30),
        closedBy: 'Ann',
      );

      final back = FiscalPeriodRowMapper.fromRow(
        FiscalPeriodRowMapper.toRow(businessId: 'biz-1', period: original),
      );

      expect(back.key, original.key);
      expect(back.startsOn, original.startsOn);
      expect(back.endsOn, original.endsOn);
      expect(back.status, FiscalPeriodStatus.closed);
      expect(back.isClosed, isTrue);
      expect(back.closedBy, 'Ann');
      expect(back.closedAt, original.closedAt);
    });

    test('reads a snake_case-only row, as the Postgres mirror would write it', () {
      final back = FiscalPeriodRowMapper.fromRow({
        'period_key': '2026-09',
        'name': 'Sep 2026',
        'starts_on': '2026-09-01',
        'ends_on': '2026-09-30',
        'status': 'locked',
        'closed_by': 'Ann',
      });
      expect(back.status, FiscalPeriodStatus.locked);
      expect(back.isClosed, isTrue);
      expect(back.endsOn, DateTime.utc(2026, 9, 30));
    });

    test('a row with unusable dates degrades to that month, still open', () {
      // A malformed row must not throw inside a stream, and must not
      // accidentally read as closed.
      final back = FiscalPeriodRowMapper.fromRow({
        'period_key': '2026-09',
        'starts_on': 'not-a-date',
        'ends_on': '',
      });
      expect(back.key, '2026-09');
      expect(back.startsOn, DateTime.utc(2026, 9, 1));
      expect(back.endsOn, DateTime.utc(2026, 9, 30));
      expect(back.isClosed, isFalse);
    });

    test('a date-only column is read as UTC, not shifted by the local zone', () {
      // Regression: DateTime.parse('2026-09-01') is LOCAL, so .toUtc() moved
      // it to 2026-08-31T22:00Z in Kigali (+02:00) -- both period boundaries
      // slid a day earlier and covers() misjudged the first and last of the
      // month. starts_on/ends_on are Postgres `date` columns, always date-only.
      final p = FiscalPeriodRowMapper.fromRow({
        'period_key': '2026-09',
        'starts_on': '2026-09-01',
        'ends_on': '2026-09-30',
      });
      expect(p.startsOn, DateTime.utc(2026, 9, 1));
      expect(p.endsOn, DateTime.utc(2026, 9, 30));
      expect(p.covers(DateTime.utc(2026, 9, 1)), isTrue);
      expect(p.covers(DateTime.utc(2026, 9, 30)), isTrue);
    });

    test('reopening clears the closed state and records who did it', () {
      final closed = FiscalPeriod.openMonth(
        DateTime.utc(2026, 9, 3),
        name: 'Sep 2026',
      ).copyWith(
        status: FiscalPeriodStatus.closed,
        closedAt: DateTime.utc(2026, 10, 1),
        closedBy: 'Ann',
      );

      final reopened = closed.copyWith(
        status: FiscalPeriodStatus.open,
        reopenedAt: DateTime.utc(2026, 10, 2),
        reopenedBy: 'Bob',
        reopenReason: 'late invoice',
      );

      expect(reopened.isClosed, isFalse);
      // The close is still on the record, so a reopen is auditable rather than
      // indistinguishable from a period that was never closed.
      expect(reopened.closedBy, 'Ann');
      expect(reopened.reopenedBy, 'Bob');
      expect(reopened.reopenReason, 'late invoice');
    });
  });
}
