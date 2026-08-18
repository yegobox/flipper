import 'package:flipper_hr/features/people/data/employee.dart';

/// Maps `hr_employees` rows to and from [Employee].
///
/// PostgREST is loose about types — `numeric` arrives as `int`, `double` or
/// `String` depending on the value, and `date` arrives as `YYYY-MM-DD` while
/// `timestamptz` arrives as a full ISO string. Every read goes through here so
/// the rest of the app only ever sees a normalised [Employee].
///
/// Column names must match `supabase/migrations/0001_hr_employees.sql`.
class EmployeeRowMapper {
  EmployeeRowMapper._();

  static Employee fromRow(Map<String, dynamic> row) {
    return Employee(
      id: _str(row['id']),
      businessId: _str(row['business_id']),
      branchId: _str(row['branch_id']),
      firstName: _str(row['first_name']),
      lastName: _str(row['last_name']),
      phone: _str(row['phone']),
      email: _str(row['email']),
      jobTitle: _str(row['job_title']),
      department: _str(row['department']),
      type: EmploymentType.fromWire(row['employment_type'] as String?),
      status: EmploymentStatus.fromWire(row['status'] as String?),
      // A row with no hire_date should still list; the epoch reads as
      // obviously-unset rather than crashing the whole roster.
      hireDate: parseDate(row['hire_date']) ?? DateTime.utc(1970),
      endDate: parseDate(row['end_date']),
      nationalId: _str(row['national_id']),
      rssbNumber: _str(row['rssb_number']),
      baseSalary: parseAmount(row['base_salary']),
      currency: _str(row['currency'], fallback: 'RWF'),
      payFrequency: PayFrequency.fromWire(row['pay_frequency'] as String?),
      paymentMethod: PaymentMethod.fromWire(row['payment_method'] as String?),
      momoPhone: _str(row['momo_phone']),
      bankName: _str(row['bank_name']),
      bankAccount: _str(row['bank_account']),
      userId: _strOrNull(row['user_id']),
      // Nullable on purpose: null is "statutory default", so it must survive the
      // round trip rather than collapsing to 0 the way parseAmount would.
      annualLeaveDays: parseOptionalAmount(row['annual_leave_days']),
      notes: _str(row['notes']),
      createdAt: parseTimestamp(row['created_at']),
      updatedAt: parseTimestamp(row['updated_at']),
    );
  }

  /// Row for an INSERT: no `id`, no `created_at` — Postgres owns both.
  static Map<String, dynamic> toInsertRow(Employee e, {DateTime? now}) {
    final row = _writableColumns(e);
    row['updated_at'] = (now ?? DateTime.now()).toUtc().toIso8601String();
    return row;
  }

  /// Row for an UPDATE. `business_id` is intentionally included so a record can
  /// follow a branch transfer, but `id` and `created_at` are never rewritten.
  static Map<String, dynamic> toUpdateRow(Employee e, {DateTime? now}) {
    final row = _writableColumns(e);
    row['updated_at'] = (now ?? DateTime.now()).toUtc().toIso8601String();
    return row;
  }

  static Map<String, dynamic> _writableColumns(Employee e) => {
    'business_id': e.businessId,
    'branch_id': e.branchId,
    'first_name': e.firstName.trim(),
    'last_name': e.lastName.trim(),
    'phone': e.phone.trim(),
    'email': _nullIfBlank(e.email),
    'job_title': e.jobTitle.trim(),
    'department': e.department.trim(),
    'employment_type': e.type.wire,
    'status': e.status.wire,
    'hire_date': formatDate(e.hireDate),
    'end_date': e.endDate == null ? null : formatDate(e.endDate!),
    'national_id': _nullIfBlank(e.nationalId),
    'rssb_number': _nullIfBlank(e.rssbNumber),
    'base_salary': e.baseSalary,
    'currency': e.currency,
    'pay_frequency': e.payFrequency.wire,
    'payment_method': e.paymentMethod.wire,
    'momo_phone': _nullIfBlank(e.momoPhone),
    'bank_name': _nullIfBlank(e.bankName),
    'bank_account': _nullIfBlank(e.bankAccount),
    'user_id': _nullIfBlank(e.userId ?? ''),
    'annual_leave_days': e.annualLeaveDays,
    'notes': _nullIfBlank(e.notes),
  };

  /// `date` columns are written date-only so Postgres never shifts the day
  /// across a timezone boundary.
  static String formatDate(DateTime d) {
    final m = d.month.toString().padLeft(2, '0');
    final day = d.day.toString().padLeft(2, '0');
    return '${d.year.toString().padLeft(4, '0')}-$m-$day';
  }

  /// Accepts `YYYY-MM-DD`, a full ISO timestamp, or a [DateTime]. The result is
  /// always local midnight, so date comparisons never straddle a day.
  static DateTime? parseDate(Object? value) {
    final parsed = _parseAnyDate(value);
    if (parsed == null) return null;
    return DateTime(parsed.year, parsed.month, parsed.day);
  }

  /// Timestamps keep their time component and are normalised to UTC.
  static DateTime? parseTimestamp(Object? value) =>
      _parseAnyDate(value)?.toUtc();

  static DateTime? _parseAnyDate(Object? value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    final raw = value.toString().trim();
    if (raw.isEmpty) return null;
    return DateTime.tryParse(raw);
  }

  /// `numeric` reaches Dart as int, double or String. Anything unparseable is
  /// 0 rather than an exception — a bad salary must not hide the whole roster.
  static double parseAmount(Object? value) {
    if (value == null) return 0;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString().trim()) ?? 0;
  }

  /// Like [parseAmount] but keeps null as null. For columns where null and 0
  /// mean different things — `annual_leave_days` null is "the statutory 18",
  /// while 0 is "no annual leave at all".
  static double? parseOptionalAmount(Object? value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    final raw = value.toString().trim();
    if (raw.isEmpty) return null;
    return double.tryParse(raw);
  }

  static String _str(Object? value, {String fallback = ''}) {
    if (value == null) return fallback;
    final s = value.toString();
    return s.isEmpty ? fallback : s;
  }

  static String? _strOrNull(Object? value) {
    final s = value?.toString().trim();
    return (s == null || s.isEmpty) ? null : s;
  }

  static String? _nullIfBlank(String value) {
    final trimmed = value.trim();
    return trimmed.isEmpty ? null : trimmed;
  }
}
