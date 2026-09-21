/// Fiscal periods — the durable replacement for the in-memory close flag.
///
/// `periodCloseLockedProvider` used to be a `StateProvider<bool>`: closing a
/// period survived neither a reload nor a second device, and no other user ever
/// saw it. The Postgres table `fiscal_periods` (Flipper-Database #2) is the
/// system of record's shape; Books writes periods to **Ditto**, which is the
/// authoritative store for accounting, and data-connector mirrors them into
/// Postgres like the rest of the ledger.
library;

/// Whether a period still accepts postings.
enum FiscalPeriodStatus {
  /// Postable.
  open,

  /// Soft close — Books refuses new entries; a supervisor may reopen.
  closed,

  /// Hard close, e.g. after a tax filing. Reopening is an explicit act.
  locked;

  static FiscalPeriodStatus parse(String? raw) {
    switch ((raw ?? '').trim().toLowerCase()) {
      case 'closed':
        return FiscalPeriodStatus.closed;
      case 'locked':
        return FiscalPeriodStatus.locked;
      default:
        return FiscalPeriodStatus.open;
    }
  }

  /// `closed` and `locked` both stop posting; only the reopen path differs.
  bool get blocksPosting => this != FiscalPeriodStatus.open;
}

class FiscalPeriod {
  const FiscalPeriod({
    required this.key,
    required this.name,
    required this.startsOn,
    required this.endsOn,
    required this.status,
    this.closedAt,
    this.closedBy,
    this.reopenedAt,
    this.reopenedBy,
    this.reopenReason,
  });

  /// Stable per-business key, `YYYY-MM`. Books closes a calendar month, which
  /// is what the period-close screen has always shown.
  final String key;

  /// Display label, e.g. `Sep 2026`.
  final String name;
  final DateTime startsOn;
  final DateTime endsOn;
  final FiscalPeriodStatus status;
  final DateTime? closedAt;
  final String? closedBy;
  final DateTime? reopenedAt;
  final String? reopenedBy;
  final String? reopenReason;

  bool get isClosed => status.blocksPosting;

  /// Whether [date] falls inside this period, inclusive of both ends.
  bool covers(DateTime date) {
    final d = DateTime.utc(date.year, date.month, date.day);
    return !d.isBefore(startsOn) && !d.isAfter(endsOn);
  }

  FiscalPeriod copyWith({
    FiscalPeriodStatus? status,
    DateTime? closedAt,
    String? closedBy,
    DateTime? reopenedAt,
    String? reopenedBy,
    String? reopenReason,
  }) {
    return FiscalPeriod(
      key: key,
      name: name,
      startsOn: startsOn,
      endsOn: endsOn,
      status: status ?? this.status,
      closedAt: closedAt ?? this.closedAt,
      closedBy: closedBy ?? this.closedBy,
      reopenedAt: reopenedAt ?? this.reopenedAt,
      reopenedBy: reopenedBy ?? this.reopenedBy,
      reopenReason: reopenReason ?? this.reopenReason,
    );
  }

  /// The `YYYY-MM` key for the month [date] falls in.
  static String keyFor(DateTime date) =>
      '${date.year.toString().padLeft(4, '0')}-'
      '${date.month.toString().padLeft(2, '0')}';

  /// An open period covering the calendar month of [date].
  ///
  /// Used when no row exists yet: a month nobody has closed is open, so Books
  /// shows the same state a missing row implies rather than failing closed.
  static FiscalPeriod openMonth(DateTime date, {required String name}) {
    final start = DateTime.utc(date.year, date.month, 1);
    // Day 0 of the next month is the last day of this one.
    final end = DateTime.utc(date.year, date.month + 1, 0);
    return FiscalPeriod(
      key: keyFor(date),
      name: name,
      startsOn: start,
      endsOn: end,
      status: FiscalPeriodStatus.open,
    );
  }
}
