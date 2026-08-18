/// Employment enums and the [Employee] DTO behind HR's people directory.
///
/// Deliberately plain Dart — no Supabase, Ditto or Flutter imports — so the
/// mapper, filter and validation tests run without a backend or a widget
/// binding. Persistence lives in `employee_row_mapper.dart` and
/// `supabase_employee_repository.dart`.
library;

/// Lowercases and strips separators so `on_leave`, `onLeave` and `On Leave`
/// all resolve to the same enum value.
String _normalizeWire(String value) =>
    value.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '');

T _fromWire<T>(
  List<T> values,
  String Function(T) wireOf,
  String? raw,
  T fallback,
) {
  if (raw == null) return fallback;
  final needle = _normalizeWire(raw);
  if (needle.isEmpty) return fallback;
  for (final v in values) {
    if (_normalizeWire(wireOf(v)) == needle) return v;
  }
  return fallback;
}

enum EmploymentType {
  fullTime('full_time', 'Full time'),
  partTime('part_time', 'Part time'),
  contract('contract', 'Contract'),
  intern('intern', 'Intern'),
  casual('casual', 'Casual');

  const EmploymentType(this.wire, this.label);

  final String wire;
  final String label;

  static EmploymentType fromWire(String? raw) =>
      _fromWire(values, (v) => v.wire, raw, EmploymentType.fullTime);
}

enum EmploymentStatus {
  active('active', 'Active'),
  onLeave('on_leave', 'On leave'),
  suspended('suspended', 'Suspended'),
  terminated('terminated', 'Terminated');

  const EmploymentStatus(this.wire, this.label);

  final String wire;
  final String label;

  /// Terminated people are kept for history but never paid or counted as staff.
  bool get isEmployed => this != EmploymentStatus.terminated;

  static EmploymentStatus fromWire(String? raw) =>
      _fromWire(values, (v) => v.wire, raw, EmploymentStatus.active);
}

enum PayFrequency {
  monthly('monthly', 'Monthly'),
  weekly('weekly', 'Weekly'),
  daily('daily', 'Daily'),
  hourly('hourly', 'Hourly');

  const PayFrequency(this.wire, this.label);

  final String wire;
  final String label;

  static PayFrequency fromWire(String? raw) =>
      _fromWire(values, (v) => v.wire, raw, PayFrequency.monthly);
}

enum PaymentMethod {
  mobileMoney('mobile_money', 'Mobile money'),
  bankTransfer('bank_transfer', 'Bank transfer'),
  cash('cash', 'Cash');

  const PaymentMethod(this.wire, this.label);

  final String wire;
  final String label;

  static PaymentMethod fromWire(String? raw) =>
      _fromWire(values, (v) => v.wire, raw, PaymentMethod.mobileMoney);
}

/// One person on a branch's roster.
///
/// [id] is empty for a record that has not been inserted yet — Postgres owns
/// employee ids (`gen_random_uuid()`), so the form builds a blank [Employee]
/// via [Employee.blank] and the insert reads the id back.
class Employee {
  const Employee({
    this.id = '',
    required this.businessId,
    required this.branchId,
    required this.firstName,
    required this.lastName,
    this.phone = '',
    this.email = '',
    this.jobTitle = '',
    this.department = '',
    this.type = EmploymentType.fullTime,
    this.status = EmploymentStatus.active,
    required this.hireDate,
    this.endDate,
    this.nationalId = '',
    this.rssbNumber = '',
    this.baseSalary = 0,
    this.currency = 'RWF',
    this.payFrequency = PayFrequency.monthly,
    this.paymentMethod = PaymentMethod.mobileMoney,
    this.momoPhone = '',
    this.bankName = '',
    this.bankAccount = '',
    this.userId,
    this.managerId,
    this.annualLeaveDays,
    this.notes = '',
    this.createdAt,
    this.updatedAt,
  });

  /// Empty record for the "add person" form, pre-scoped to the open branch.
  factory Employee.blank({
    required String businessId,
    required String branchId,
    required DateTime hireDate,
  }) => Employee(
    businessId: businessId,
    branchId: branchId,
    firstName: '',
    lastName: '',
    hireDate: hireDate,
  );

  final String id;
  final String businessId;
  final String branchId;
  final String firstName;
  final String lastName;
  final String phone;
  final String email;
  final String jobTitle;
  final String department;
  final EmploymentType type;
  final EmploymentStatus status;
  final DateTime hireDate;

  /// Last day worked. Required once [status] is [EmploymentStatus.terminated].
  final DateTime? endDate;
  final String nationalId;

  /// Rwanda Social Security Board member number, used by payroll later.
  final String rssbNumber;
  final double baseSalary;
  final String currency;
  final PayFrequency payFrequency;
  final PaymentMethod paymentMethod;
  final String momoPhone;
  final String bankName;
  final String bankAccount;

  /// Flipper account this person signs in with, when they have one. Written by
  /// the HR invite, and what ties this record to the leave the person books.
  final String? userId;

  /// The person this employee reports to — an [Employee.id] on the same roster.
  ///
  /// Null means nobody in particular, and that is a real state rather than an
  /// omission: the owner reports to no one, and a new hire is often added before
  /// the org chart catches up. Leave for someone with no manager falls back to
  /// whoever manages the business, which is how HR behaved before reporting lines
  /// existed. When it is set, that person is the one the request waits on — see
  /// `hr_my_report_ids()` in migration 0007.
  final String? managerId;

  /// Annual leave entitlement in working days, when their contract improves on
  /// the statutory minimum.
  ///
  /// Null means "the statutory default applies" (18 working days — see
  /// [LeaveType.annual]), NOT zero. `hr_employees.annual_leave_days` is nullable
  /// for the same reason: records that predate the column keep the legal minimum
  /// without a backfill.
  final double? annualLeaveDays;
  final String notes;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  bool get isPersisted => id.isNotEmpty;

  bool get isActive => status == EmploymentStatus.active;

  /// True once this person can sign into HR and book their own leave.
  bool get hasFlipperAccount => (userId ?? '').trim().isNotEmpty;

  /// True when this person's leave has a named approver of its own.
  bool get hasManager => (managerId ?? '').trim().isNotEmpty;

  /// Contact the invite is addressed to. Phone first: the login PIN is confirmed
  /// with an OTP sent by SMS, so a record with only an email cannot complete a
  /// sign-in even though `/v2/api/user` accepts one.
  String get inviteContact {
    final p = phone.trim();
    return p.isNotEmpty ? p : email.trim();
  }

  String get fullName => [firstName.trim(), lastName.trim()]
      .where((p) => p.isNotEmpty)
      .join(' ');

  /// Up to two letters for the avatar; empty when the name is still blank.
  String get initials {
    final parts = [firstName.trim(), lastName.trim()]
        .where((p) => p.isNotEmpty)
        .toList();
    if (parts.isEmpty) return '';
    if (parts.length == 1) {
      final only = parts.first;
      return only.substring(0, only.length >= 2 ? 2 : 1).toUpperCase();
    }
    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }

  /// Whole days since [hireDate], floored at 0 for a future start date.
  int tenureDays({required DateTime asOf}) {
    final days = _dateOnly(asOf).difference(_dateOnly(hireDate)).inDays;
    return days < 0 ? 0 : days;
  }

  /// Working days a month is assumed to hold when converting daily pay.
  static const workingDaysPerMonth = 22;

  /// Hours a working day is assumed to hold when converting hourly pay.
  static const workingHoursPerDay = 8;

  /// Rough monthly cost of this person, used for the roster's payroll tile.
  ///
  /// An estimate, not a payslip: weekly pay is annualised over 52 weeks and
  /// daily/hourly pay uses the [workingDaysPerMonth] and [workingHoursPerDay]
  /// assumptions above. Terminated people cost nothing.
  double get monthlyCostEstimate {
    if (!status.isEmployed) return 0;
    return switch (payFrequency) {
      PayFrequency.monthly => baseSalary,
      PayFrequency.weekly => baseSalary * 52 / 12,
      PayFrequency.daily => baseSalary * workingDaysPerMonth,
      PayFrequency.hourly =>
        baseSalary * workingHoursPerDay * workingDaysPerMonth,
    };
  }

  Employee copyWith({
    String? id,
    String? businessId,
    String? branchId,
    String? firstName,
    String? lastName,
    String? phone,
    String? email,
    String? jobTitle,
    String? department,
    EmploymentType? type,
    EmploymentStatus? status,
    DateTime? hireDate,
    DateTime? endDate,
    bool clearEndDate = false,
    String? nationalId,
    String? rssbNumber,
    double? baseSalary,
    String? currency,
    PayFrequency? payFrequency,
    PaymentMethod? paymentMethod,
    String? momoPhone,
    String? bankName,
    String? bankAccount,
    String? userId,
    String? managerId,
    bool clearManagerId = false,
    double? annualLeaveDays,
    bool clearAnnualLeaveDays = false,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Employee(
    id: id ?? this.id,
    businessId: businessId ?? this.businessId,
    branchId: branchId ?? this.branchId,
    firstName: firstName ?? this.firstName,
    lastName: lastName ?? this.lastName,
    phone: phone ?? this.phone,
    email: email ?? this.email,
    jobTitle: jobTitle ?? this.jobTitle,
    department: department ?? this.department,
    type: type ?? this.type,
    status: status ?? this.status,
    hireDate: hireDate ?? this.hireDate,
    endDate: clearEndDate ? null : (endDate ?? this.endDate),
    nationalId: nationalId ?? this.nationalId,
    rssbNumber: rssbNumber ?? this.rssbNumber,
    baseSalary: baseSalary ?? this.baseSalary,
    currency: currency ?? this.currency,
    payFrequency: payFrequency ?? this.payFrequency,
    paymentMethod: paymentMethod ?? this.paymentMethod,
    momoPhone: momoPhone ?? this.momoPhone,
    bankName: bankName ?? this.bankName,
    bankAccount: bankAccount ?? this.bankAccount,
    userId: userId ?? this.userId,
    // Clearable for the same reason as the entitlement below: "reports to
    // nobody" is a choice the form has to be able to get back to.
    managerId: clearManagerId ? null : (managerId ?? this.managerId),
    // Clearable, because blank means "the statutory default" — a distinct value
    // from 0, and one the form must be able to get back to.
    annualLeaveDays: clearAnnualLeaveDays
        ? null
        : (annualLeaveDays ?? this.annualLeaveDays),
    notes: notes ?? this.notes,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );

  List<Object?> get _props => [
    id,
    businessId,
    branchId,
    firstName,
    lastName,
    phone,
    email,
    jobTitle,
    department,
    type,
    status,
    hireDate,
    endDate,
    nationalId,
    rssbNumber,
    baseSalary,
    currency,
    payFrequency,
    paymentMethod,
    momoPhone,
    bankName,
    bankAccount,
    userId,
    managerId,
    annualLeaveDays,
    notes,
    createdAt,
    updatedAt,
  ];

  @override
  bool operator ==(Object other) {
    if (other is! Employee) return false;
    final mine = _props;
    final theirs = other._props;
    for (var i = 0; i < mine.length; i++) {
      if (mine[i] != theirs[i]) return false;
    }
    return true;
  }

  @override
  int get hashCode => Object.hashAll(_props);

  @override
  String toString() => 'Employee($id, $fullName, ${status.wire})';
}

DateTime _dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);
