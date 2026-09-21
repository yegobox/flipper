import 'package:flipper_web/modules/accounting/data/fiscal_period_models.dart';

/// Ditto row <-> [FiscalPeriod].
///
/// Every field is written under BOTH camelCase and snake_case, matching the
/// rest of the accounting collections: Flutter reads camelCase, and
/// data-connector maps snake_case straight onto the Postgres columns.
class FiscalPeriodRowMapper {
  const FiscalPeriodRowMapper._();

  static String? _str(Map<String, dynamic> row, String camel, String snake) {
    final v = row[camel] ?? row[snake];
    if (v == null) return null;
    final s = v.toString().trim();
    return s.isEmpty ? null : s;
  }

  /// Matches a bare `YYYY-MM-DD` with no time or zone.
  static final _dateOnly = RegExp(r'^(\d{4})-(\d{2})-(\d{2})$');

  static DateTime? _date(Map<String, dynamic> row, String camel, String snake) {
    final raw = _str(row, camel, snake);
    if (raw == null) return null;

    // `starts_on` / `ends_on` are Postgres `date` columns, so they arrive
    // date-only. `DateTime.parse` reads those as LOCAL time, and `.toUtc()`
    // then shifts them by the offset -- in Kigali (+02:00) `2026-09-01` became
    // `2026-08-31T22:00Z`, moving both period boundaries a day earlier and
    // making `covers()` wrong for entries on the first and last of the month.
    final m = _dateOnly.firstMatch(raw);
    if (m != null) {
      return DateTime.utc(
        int.parse(m.group(1)!),
        int.parse(m.group(2)!),
        int.parse(m.group(3)!),
      );
    }
    // Full timestamps carry their own zone, so parsing then converting is right.
    return DateTime.tryParse(raw)?.toUtc();
  }

  static String _isoDate(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-'
      '${d.month.toString().padLeft(2, '0')}-'
      '${d.day.toString().padLeft(2, '0')}';

  static FiscalPeriod fromRow(Map<String, dynamic> row) {
    final startsOn = _date(row, 'startsOn', 'starts_on');
    final endsOn = _date(row, 'endsOn', 'ends_on');
    // A row with no usable dates still has a key; fall back to that month so a
    // malformed row degrades to "open" rather than throwing in a stream.
    final key = _str(row, 'periodKey', 'period_key') ?? '';
    final fallback = _monthFromKey(key) ?? DateTime.now().toUtc();

    return FiscalPeriod(
      key: key.isNotEmpty ? key : FiscalPeriod.keyFor(fallback),
      name: _str(row, 'name', 'name') ?? key,
      startsOn: startsOn ?? DateTime.utc(fallback.year, fallback.month, 1),
      endsOn: endsOn ?? DateTime.utc(fallback.year, fallback.month + 1, 0),
      status: FiscalPeriodStatus.parse(_str(row, 'status', 'status')),
      closedAt: _date(row, 'closedAt', 'closed_at'),
      closedBy: _str(row, 'closedBy', 'closed_by'),
      reopenedAt: _date(row, 'reopenedAt', 'reopened_at'),
      reopenedBy: _str(row, 'reopenedBy', 'reopened_by'),
      reopenReason: _str(row, 'reopenReason', 'reopen_reason'),
    );
  }

  static Map<String, dynamic> toRow({
    required String businessId,
    required FiscalPeriod period,
    String? id,
  }) {
    return {
      if (id != null) 'id': id,
      'business_id': businessId,
      'businessId': businessId,
      'period_key': period.key,
      'periodKey': period.key,
      'name': period.name,
      'starts_on': _isoDate(period.startsOn),
      'startsOn': _isoDate(period.startsOn),
      'ends_on': _isoDate(period.endsOn),
      'endsOn': _isoDate(period.endsOn),
      'status': period.status.name,
      'closed_at': period.closedAt?.toIso8601String(),
      'closedAt': period.closedAt?.toIso8601String(),
      'closed_by': period.closedBy,
      'closedBy': period.closedBy,
      'reopened_at': period.reopenedAt?.toIso8601String(),
      'reopenedAt': period.reopenedAt?.toIso8601String(),
      'reopened_by': period.reopenedBy,
      'reopenedBy': period.reopenedBy,
      'reopen_reason': period.reopenReason,
      'reopenReason': period.reopenReason,
    };
  }

  static DateTime? _monthFromKey(String key) {
    final parts = key.split('-');
    if (parts.length != 2) return null;
    final y = int.tryParse(parts[0]);
    final m = int.tryParse(parts[1]);
    if (y == null || m == null || m < 1 || m > 12) return null;
    return DateTime.utc(y, m, 1);
  }
}
