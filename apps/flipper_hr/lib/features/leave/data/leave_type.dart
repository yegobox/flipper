/// Leave types and the entitlement each one carries.
///
/// Plain Dart, no imports: the balance maths and the validation rules are the
/// part most worth testing, and they should not need a backend or a widget
/// binding to run.
library;

/// A kind of leave, with the statutory entitlement Rwanda's Law N° 66/2018
/// attaches to it.
///
/// The figures below are the legal minimum, in the unit the law states them in —
/// which is not the same unit for every type, hence [countsCalendarDays].
/// A contract may be more generous; that is what
/// `hr_employees.annual_leave_days` overrides (annual only, which is the one
/// employers actually negotiate).
///
/// Not modelled here, deliberately: the "sick leave beyond 15 days at half pay"
/// tier, and carry-over of unused annual leave. Both change what someone is
/// *paid*, not how many days they may book, so they belong with payroll rather
/// than in a booking screen.
enum LeaveType {
  /// Art. 63: 18 working days a year, accruing 1.5 days a month.
  annual('annual', 'Annual leave', entitlementDays: 18),

  /// Art. 70: 15 days a year at full pay.
  sick('sick', 'Sick leave', entitlementDays: 15),

  /// Art. 66: 12 weeks. Stated in weeks, so counted in calendar days.
  maternity(
    'maternity',
    'Maternity leave',
    entitlementDays: 84,
    countsCalendarDays: true,
  ),

  /// Art. 67: 4 working days.
  paternity('paternity', 'Paternity leave', entitlementDays: 4),

  /// Art. 65 circumstantial leave: 6 working days a year, for a bereavement,
  /// a wedding, and the like.
  compassionate('compassionate', 'Compassionate leave', entitlementDays: 6),

  /// Agreed with the employer, unpaid. No cap, because there is no entitlement
  /// to run out of — every day still needs approving.
  unpaid('unpaid', 'Unpaid leave');

  const LeaveType(
    this.wire,
    this.label, {
    this.entitlementDays,
    this.countsCalendarDays = false,
  });

  /// Value stored in `hr_leave_requests.leave_type`. Must match the CHECK in
  /// `supabase/migrations/0004_hr_leave.sql`.
  final String wire;

  final String label;

  /// Days granted per year, or null when the type is uncapped ([unpaid]).
  final double? entitlementDays;

  /// True when the law states this type in calendar time, so weekends inside the
  /// period are consumed too. Maternity leave runs continuously; annual leave
  /// does not.
  final bool countsCalendarDays;

  /// False for [unpaid]: there is no balance to show, only a request to approve.
  bool get hasEntitlement => entitlementDays != null;

  static LeaveType fromWire(String? raw) {
    if (raw == null) return LeaveType.annual;
    final needle = raw.toLowerCase().replaceAll(RegExp(r'[^a-z]'), '');
    if (needle.isEmpty) return LeaveType.annual;
    for (final t in values) {
      if (t.wire == needle) return t;
    }
    return LeaveType.annual;
  }

  /// Types offered on the request form, in the order they appear.
  static const bookable = values;
}
