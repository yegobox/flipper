import 'package:flipper_hr/features/people/data/employee.dart';
import 'package:flipper_models/helperModels/signup_countries.dart';

/// Fields the people form can complain about.
enum EmployeeField {
  firstName,
  lastName,
  phone,
  email,
  jobTitle,
  hireDate,
  endDate,
  managerId,
  nationalId,
  baseSalary,
  annualLeaveDays,
  momoPhone,
  bankName,
  bankAccount,
}

/// National ID formats differ by country — 16 digits in Rwanda, 8 in Kenya, 14
/// for a Ugandan NIN, letters and all in the UK — so the only rule that holds
/// everywhere is a length range. Only checked when one is entered: the field is
/// optional because casual staff are often hired before they produce it.
const _minNationalIdChars = 5;
const _maxNationalIdChars = 20;

/// Working days in a year (52 weeks x 5, less a fortnight of public holidays).
/// An annual leave entitlement past this is a units mistake, not generosity.
const _maxAnnualLeaveDays = 261;

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
  } else if (!isPlausiblePhoneNumber(e.phone)) {
    errors[EmployeeField.phone] = 'Enter a valid phone number';
  }

  if (e.email.trim().isNotEmpty && !_looksLikeEmail(e.email.trim())) {
    errors[EmployeeField.email] = 'Enter a valid email address';
  }

  // Counted over the whole value, not just its digits: plenty of countries
  // put letters in an ID number.
  final nationalId = e.nationalId.replaceAll(RegExp(r'\s'), '');
  if (nationalId.isNotEmpty &&
      (nationalId.length < _minNationalIdChars ||
          nationalId.length > _maxNationalIdChars)) {
    errors[EmployeeField.nationalId] =
        'A national ID is $_minNationalIdChars to $_maxNationalIdChars characters';
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

  // The database refuses this twice over (the hr_employees_manager_not_self
  // CHECK and the cycle trigger), but a dropdown that let it be chosen and a
  // save that then failed would be a worse form than one that says so here.
  // Deeper loops are the dropdown's job — see managerCandidatesFor.
  if (e.managerId != null && e.managerId == e.id && e.id.isNotEmpty) {
    errors[EmployeeField.managerId] = 'Someone cannot report to themselves';
  }

  if (e.baseSalary < 0) {
    errors[EmployeeField.baseSalary] = 'Pay cannot be negative';
  }

  // Only checked when set. Blank leaves the statutory 18 working days in force
  // (see LeaveType.annual), so an empty field is the normal case, not an
  // omission. The upper bound catches a figure typed in hours or a stray digit —
  // a year has 261 working days, so anything past that cannot be leave.
  final annualLeave = e.annualLeaveDays;
  if (annualLeave != null) {
    if (annualLeave < 0) {
      errors[EmployeeField.annualLeaveDays] = 'Leave days cannot be negative';
    } else if (annualLeave > _maxAnnualLeaveDays) {
      errors[EmployeeField.annualLeaveDays] =
          'That is more than a working year — enter days, not hours';
    }
  }

  switch (e.paymentMethod) {
    case PaymentMethod.mobileMoney:
      final momo = _digits(e.momoPhone);
      // Falls back to the contact number, which is what payroll will charge.
      if (momo.isEmpty && !isPlausiblePhoneNumber(e.phone)) {
        errors[EmployeeField.momoPhone] = 'Mobile money number is required';
      } else if (momo.isNotEmpty && !isPlausiblePhoneNumber(e.momoPhone)) {
        errors[EmployeeField.momoPhone] = 'Enter a valid mobile money number';
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
