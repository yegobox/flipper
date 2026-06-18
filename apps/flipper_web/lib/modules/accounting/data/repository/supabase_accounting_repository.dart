import 'package:flipper_web/modules/accounting/data/mapper/accounting_transaction_semantics.dart';
import 'package:flipper_web/modules/accounting/data/repository/accounting_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Supabase REST implementation. Column names are snake_case (PostgreSQL
/// convention after the data-connector's camelCase→snake_case transform).
///
/// The [watchTransactions] stream uses Supabase's `.stream()` with a
/// branch-ID equality filter, then applies date/status filtering in Dart.
/// This is intentional: `.stream()` only supports a single `.eq()` server-side;
/// the volume per branch is small enough for client-side filtering.
class SupabaseAccountingRepository implements AccountingRepository {
  const SupabaseAccountingRepository(this._client);

  final SupabaseClient _client;

  static const _txTable = 'transactions';
  static const _itemTable = 'transaction_items';

  @override
  Future<List<Map<String, dynamic>>> fetchTransactions({
    required String branchId,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    var query = _client
        .from(_txTable)
        .select()
        .eq('branch_id', branchId)
        .inFilter('status', [
          accountingSaleStatusCompleted,
          accountingSaleStatusParked,
        ])
        .gt('sub_total', 0);

    if (startDate != null) {
      query = query.gte('created_at', startDate.toIso8601String());
    }
    if (endDate != null) {
      query = query.lte('created_at', _endOfDay(endDate).toIso8601String());
    }

    final rows = await query.order('created_at', ascending: false);
    return List<Map<String, dynamic>>.from(rows);
  }

  @override
  Future<List<Map<String, dynamic>>> fetchTransactionItems({
    required List<String> transactionIds,
  }) async {
    if (transactionIds.isEmpty) return [];

    final rows = await _client
        .from(_itemTable)
        .select()
        .inFilter('transaction_id', transactionIds);

    return List<Map<String, dynamic>>.from(rows);
  }

  @override
  Stream<List<Map<String, dynamic>>> watchTransactions({
    required String branchId,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return _client
        .from(_txTable)
        .stream(primaryKey: ['id'])
        .eq('branch_id', branchId)
        .map((rows) {
          return rows.cast<Map<String, dynamic>>().where((r) {
            if (!isAccountingRecognizedTransaction(r)) return false;
            final sub = (r['sub_total'] as num? ?? 0);
            if (sub <= 0) return false;
            if (startDate != null) {
              final dt = _parseDate(r['created_at']);
              if (dt != null && dt.isBefore(startDate)) return false;
            }
            if (endDate != null) {
              final dt = _parseDate(r['created_at']);
              if (dt != null && dt.isAfter(_endOfDay(endDate))) return false;
            }
            return true;
          }).toList();
        });
  }

  static DateTime _endOfDay(DateTime d) =>
      DateTime(d.year, d.month, d.day, 23, 59, 59, 999);

  static DateTime? _parseDate(dynamic raw) {
    if (raw is String) return DateTime.tryParse(raw);
    return null;
  }
}
