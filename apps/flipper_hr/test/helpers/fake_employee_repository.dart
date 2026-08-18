import 'package:flipper_hr/features/people/data/employee.dart';
import 'package:flipper_hr/features/people/data/employee_repository.dart';

/// In-memory [EmployeeRepository] for provider and widget tests.
///
/// Mirrors the real repository's contract closely enough to be useful: ids are
/// assigned on insert, updates fail for unknown ids, and [failWith] makes any
/// call throw so error paths can be exercised.
class FakeEmployeeRepository implements EmployeeRepository {
  FakeEmployeeRepository({List<Employee>? seed, this.failWith})
    : _people = [...?seed];

  final List<Employee> _people;

  /// When set, every method throws this instead of doing any work.
  Object? failWith;

  int fetchCount = 0;
  int _nextId = 1;

  List<Employee> get people => List.unmodifiable(_people);

  @override
  Future<List<Employee>> fetchEmployees({required String branchId}) async {
    _maybeFail();
    fetchCount++;
    return _people.where((e) => e.branchId == branchId).toList()
      ..sort((a, b) => a.firstName.compareTo(b.firstName));
  }

  @override
  Future<Employee?> fetchEmployee({required String id}) async {
    _maybeFail();
    fetchCount++;
    return _people.where((e) => e.id == id).firstOrNull;
  }

  @override
  Future<Employee> createEmployee(Employee employee) async {
    _maybeFail();
    final stored = employee.copyWith(
      id: 'fake-${_nextId++}',
      createdAt: DateTime.utc(2026, 1, 1),
      updatedAt: DateTime.utc(2026, 1, 1),
    );
    _people.add(stored);
    return stored;
  }

  @override
  Future<Employee> updateEmployee(Employee employee) async {
    _maybeFail();
    final index = _people.indexWhere((e) => e.id == employee.id);
    if (index < 0) {
      throw EmployeeRepositoryException('No such person: ${employee.id}');
    }
    _people[index] = employee;
    return employee;
  }

  @override
  Future<Employee> linkAccount({
    required String id,
    required String userId,
  }) async {
    _maybeFail();
    final index = _people.indexWhere((e) => e.id == id);
    if (index < 0) {
      throw EmployeeRepositoryException('No such person: $id');
    }
    final updated = _people[index].copyWith(userId: userId);
    _people[index] = updated;
    return updated;
  }

  @override
  Future<Employee> setStatus({
    required String id,
    required EmploymentStatus status,
    DateTime? endDate,
  }) async {
    _maybeFail();
    final index = _people.indexWhere((e) => e.id == id);
    if (index < 0) {
      throw EmployeeRepositoryException('No such person: $id');
    }
    final updated = status == EmploymentStatus.terminated
        ? _people[index].copyWith(status: status, endDate: endDate)
        : _people[index].copyWith(status: status, clearEndDate: true);
    _people[index] = updated;
    return updated;
  }

  void _maybeFail() {
    final failure = failWith;
    if (failure != null) throw failure;
  }
}

/// Convenience builder for test rosters — only the fields a test cares about
/// need naming.
Employee employee({
  String id = 'e-1',
  String branchId = 'branch-1',
  String businessId = 'biz-1',
  String firstName = 'Aline',
  String lastName = 'Uwase',
  String phone = '0788123456',
  String email = '',
  String jobTitle = 'Cashier',
  String department = 'Retail',
  EmploymentType type = EmploymentType.fullTime,
  EmploymentStatus status = EmploymentStatus.active,
  DateTime? hireDate,
  DateTime? endDate,
  String nationalId = '',
  double baseSalary = 200000,
  PayFrequency payFrequency = PayFrequency.monthly,
  PaymentMethod paymentMethod = PaymentMethod.mobileMoney,
  String momoPhone = '',
  String currency = 'RWF',
  String? userId,
  double? annualLeaveDays,
}) => Employee(
  id: id,
  businessId: businessId,
  branchId: branchId,
  firstName: firstName,
  lastName: lastName,
  phone: phone,
  email: email,
  jobTitle: jobTitle,
  department: department,
  type: type,
  status: status,
  hireDate: hireDate ?? DateTime(2025, 1, 15),
  endDate: endDate,
  nationalId: nationalId,
  baseSalary: baseSalary,
  currency: currency,
  payFrequency: payFrequency,
  paymentMethod: paymentMethod,
  momoPhone: momoPhone,
  userId: userId,
  annualLeaveDays: annualLeaveDays,
);
