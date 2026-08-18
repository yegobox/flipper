import 'package:flipper_hr/features/people/data/employee.dart';

/// How the roster is sorted.
enum PeopleSort {
  nameAsc('Name (A–Z)'),
  nameDesc('Name (Z–A)'),
  newestHire('Newest hire'),
  longestServing('Longest serving'),
  highestPaid('Highest paid');

  const PeopleSort(this.label);

  final String label;
}

/// Search / filter / sort state for the people directory.
///
/// A plain value object with no Flutter or Riverpod dependency so
/// [applyPeopleQuery] can be tested directly.
class PeopleQuery {
  const PeopleQuery({
    this.search = '',
    this.status,
    this.department,
    this.sort = PeopleSort.nameAsc,
  });

  /// Free text matched against name, job title, department, phone, email and
  /// national id.
  final String search;

  /// `null` means "every status except terminated" — see [applyPeopleQuery].
  final EmploymentStatus? status;

  /// `null` means every department.
  final String? department;

  final PeopleSort sort;

  bool get isFiltering =>
      search.trim().isNotEmpty || status != null || department != null;

  PeopleQuery copyWith({
    String? search,
    EmploymentStatus? status,
    bool clearStatus = false,
    String? department,
    bool clearDepartment = false,
    PeopleSort? sort,
  }) => PeopleQuery(
    search: search ?? this.search,
    status: clearStatus ? null : (status ?? this.status),
    department: clearDepartment ? null : (department ?? this.department),
    sort: sort ?? this.sort,
  );
}

/// Filters and sorts the roster for display.
///
/// With no status filter, terminated people are hidden: they stay in the table
/// for payroll history but are not part of "the team". Selecting
/// [EmploymentStatus.terminated] explicitly brings them back.
///
/// Search terms are AND-ed, so "sales kigali" matches a row only if both words
/// appear somewhere in it. Phone matching compares digits only, so `0788 123
/// 456`, `+250788123456` and `788123456` all match each other.
List<Employee> applyPeopleQuery(List<Employee> people, PeopleQuery query) {
  final terms = query.search
      .toLowerCase()
      .split(RegExp(r'\s+'))
      .where((t) => t.isNotEmpty)
      .toList();
  final digitTerms = [
    for (final t in terms)
      if (_digitsOf(t).length >= 3) _digitsOf(t),
  ];

  final result = people.where((e) {
    if (query.status == null) {
      if (!e.status.isEmployed) return false;
    } else if (e.status != query.status) {
      return false;
    }

    if (query.department != null &&
        e.department.trim().toLowerCase() !=
            query.department!.trim().toLowerCase()) {
      return false;
    }

    if (terms.isEmpty) return true;

    final haystack = [
      e.fullName,
      e.jobTitle,
      e.department,
      e.email,
      e.nationalId,
    ].join(' ').toLowerCase();
    final phoneDigits = '${_digitsOf(e.phone)} ${_digitsOf(e.momoPhone)}';

    return terms.every((term) {
      if (haystack.contains(term)) return true;
      final asDigits = _digitsOf(term);
      return digitTerms.contains(asDigits) && phoneDigits.contains(asDigits);
    });
  }).toList();

  result.sort(_comparatorFor(query.sort));
  return result;
}

/// Distinct departments present on the roster, for the department filter.
/// Blank departments are dropped; comparison is case-insensitive but the first
/// spelling encountered is the one shown.
List<String> departmentsOf(List<Employee> people) {
  final seen = <String, String>{};
  for (final e in people) {
    final name = e.department.trim();
    if (name.isEmpty) continue;
    seen.putIfAbsent(name.toLowerCase(), () => name);
  }
  final names = seen.values.toList()
    ..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
  return names;
}

int Function(Employee, Employee) _comparatorFor(PeopleSort sort) {
  switch (sort) {
    case PeopleSort.nameAsc:
      return _byName;
    case PeopleSort.nameDesc:
      return (a, b) => _byName(b, a);
    case PeopleSort.newestHire:
      return (a, b) {
        final c = b.hireDate.compareTo(a.hireDate);
        return c != 0 ? c : _byName(a, b);
      };
    case PeopleSort.longestServing:
      return (a, b) {
        final c = a.hireDate.compareTo(b.hireDate);
        return c != 0 ? c : _byName(a, b);
      };
    case PeopleSort.highestPaid:
      return (a, b) {
        final c = b.monthlyCostEstimate.compareTo(a.monthlyCostEstimate);
        return c != 0 ? c : _byName(a, b);
      };
  }
}

int _byName(Employee a, Employee b) {
  final c = a.fullName.toLowerCase().compareTo(b.fullName.toLowerCase());
  return c != 0 ? c : a.id.compareTo(b.id);
}

String _digitsOf(String value) => value.replaceAll(RegExp(r'\D'), '');

/// Headline numbers for the tiles above the roster.
class PeopleSummary {
  const PeopleSummary({
    required this.headcount,
    required this.active,
    required this.onLeave,
    required this.newThisMonth,
    required this.monthlyPayroll,
    required this.currency,
  });

  /// Derives the tiles from the full roster — always the unfiltered list, so the
  /// numbers describe the branch and not the current search.
  ///
  /// [asOf] is injected rather than read from the clock so the numbers are
  /// testable and stable within a build.
  factory PeopleSummary.from(List<Employee> people, {required DateTime asOf}) {
    var active = 0;
    var onLeave = 0;
    var newThisMonth = 0;
    var payroll = 0.0;
    String? currency;

    for (final e in people) {
      if (!e.status.isEmployed) continue;
      if (e.status == EmploymentStatus.active) active++;
      if (e.status == EmploymentStatus.onLeave) onLeave++;
      if (e.hireDate.year == asOf.year && e.hireDate.month == asOf.month) {
        newThisMonth++;
      }
      payroll += e.monthlyCostEstimate;
      currency ??= e.currency;
    }

    return PeopleSummary(
      headcount: people.where((e) => e.status.isEmployed).length,
      active: active,
      onLeave: onLeave,
      newThisMonth: newThisMonth,
      monthlyPayroll: payroll,
      currency: currency ?? 'RWF',
    );
  }

  /// Everyone still employed — suspended included, terminated excluded.
  final int headcount;
  final int active;
  final int onLeave;
  final int newThisMonth;

  /// Estimated monthly cost of everyone employed. See
  /// [Employee.monthlyCostEstimate] for the conversion assumptions.
  final double monthlyPayroll;
  final String currency;
}
