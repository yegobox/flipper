import 'package:flipper_web/modules/accounting/data/repository/accounting_repository.dart';

/// In-memory fake for use in unit and provider tests. Inject canned rows via
/// the constructor — no real Supabase or Ditto connection needed.
class FakeAccountingRepository implements AccountingRepository {
  FakeAccountingRepository({
    List<Map<String, dynamic>> transactions = const [],
    List<Map<String, dynamic>> items = const [],
  })  : _transactions = transactions,
        _items = items;

  final List<Map<String, dynamic>> _transactions;
  final List<Map<String, dynamic>> _items;

  @override
  Future<List<Map<String, dynamic>>> fetchTransactions({
    required String branchId,
    DateTime? startDate,
    DateTime? endDate,
  }) async => _transactions;

  @override
  Future<List<Map<String, dynamic>>> fetchTransactionItems({
    required List<String> transactionIds,
  }) async => _items;

  @override
  Stream<List<Map<String, dynamic>>> watchTransactions({
    required String branchId,
    DateTime? startDate,
    DateTime? endDate,
  }) => Stream.value(_transactions);
}
