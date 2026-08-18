import 'package:flipper_hr/features/people/data/employee.dart';

/// Fields the people form can complain about.
enum EmployeeField {
  firstName,
  lastName,
  phone,
  email,
  jobTitle,
  hireDate,
  endDate,
  nationalId,
  baseSalary,
  momoPhone,
  bankName,
  bankAccount,
}

/// Rwanda national IDs are 16 digits. Only checked when one is entered — the
/// field is optional because casual staff are often hired before they produce it.
const _nationalIdDigits = 16;

/// Shortest phone number worth accepting (a local Rwandan number without the
/// country code is 9 digits after the leading zero).
const _minPhoneDigits = 9;

/// A start date this far ahead is almost certainly a typo, not a future hire.
const _maxFutureHireDays = 365;

/// Validates one employee record for the add/edit form.
///
/// Returns a field → message map; an empty map means the record can be saved.
/// [today] is injected so the future-date rules are testable.
Map<EmployeeField, String> validateEmployee(
  Employee e, {
  required DateTime today,
}) {
  final errors = <EmployeeField, String>{};

  if (e.firstName.trim().isEmpty) {
    errors[EmployeeField.firstName] = 'First name is required';
  }
  if (e.lastName.trim().isEmpty) {
    errors[EmployeeField.lastName] = 'Last name is required';
  }
  if (e.jobTitle.trim().isEmpty) {
    errors[EmployeeField.jobTitle] = 'Job title is required';
  }

  final phoneDigits = _digits(e.phone);
  if (phoneDigits.isEmpty) {
    errors[EmployeeField.phone] = 'Phone number is required';
  } else if (phoneDigits.length < _minPhoneDigits) {
    errors[EmployeeField.phone] = 'Enter at least $_minPhoneDigits digits';
  }

  if (e.email.trim().isNotEmpty && !_looksLikeEmail(e.email.trim())) {
    errors[EmployeeField.email] = 'Enter a valid email address';
  }

  final nationalId = _digits(e.nationalId);
  if (e.nationalId.trim().isNotEmpty &&
      nationalId.length != _nationalIdDigits) {
    errors[EmployeeField.nationalId] =
        'A national ID has $_nationalIdDigits digits';
  }

  final hire = _dateOnly(e.hireDate);
  final now = _dateOnly(today);
  if (hire.isAfter(now.add(const Duration(days: _maxFutureHireDays)))) {
    errors[EmployeeField.hireDate] =
        'Start date cannot be more than a year ahead';
  }

  final end = e.endDate == null ? null : _dateOnly(e.endDate!);
  if (e.status == EmploymentStatus.terminated && end == null) {
    errors[EmployeeField.endDate] = 'A last day is required to terminate';
  }
  if (end != null && end.isBefore(hire)) {
    errors[EmployeeField.endDate] = 'Last day cannot be before the start date';
  }

  if (e.baseSalary < 0) {
    errors[EmployeeField.baseSalary] = 'Pay cannot be negative';
  }

  switch (e.paymentMethod) {
    case PaymentMethod.mobileMoney:
      final momo = _digits(e.momoPhone);
      // Falls back to the contact number, which is what payroll will charge.
      if (momo.isEmpty && phoneDigits.length < _minPhoneDigits) {
        errors[EmployeeField.momoPhone] = 'Mobile money number is required';
      } else if (momo.isNotEmpty && momo.length < _minPhoneDigits) {
        errors[EmployeeField.momoPhone] =
            'Enter at least $_minPhoneDigits digits';
      }
    case PaymentMethod.bankTransfer:
      if (e.bankName.trim().isEmpty) {
        errors[EmployeeField.bankName] = 'Bank name is required';
      }
      if (e.bankAccount.trim().isEmpty) {
        errors[EmployeeField.bankAccount] = 'Account number is required';
      }
    case PaymentMethod.cash:
      break;
  }

  return errors;
}

/// Deliberately permissive: one `@`, something either side, and a dot in the
/// domain. Anything stricter rejects addresses that exist.
bool _looksLikeEmail(String value) =>
    RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(value);

String _digits(String value) => value.replaceAll(RegExp(r'\D'), '');

DateTime _dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);
