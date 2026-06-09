import 'dart:async';

import 'package:flipper_models/sync/ditto_observer_utils.dart';
import 'package:flipper_web/modules/accounting/data/repository/accounting_repository.dart';
import 'package:flipper_web/services/ditto_service.dart';

/// Ditto DQL implementation — swap in via the [accountingRepositoryProvider]
/// override to read from the local Ditto store instead of Supabase.
///
/// Column names here are camelCase (Ditto document convention).
/// The mapper layer accepts both camelCase and snake_case, so switching
/// backends requires no mapper changes.
class DittoAccountingRepository implements AccountingRepository {
  const DittoAccountingRepository(this._dittoService);

  final DittoService _dittoService;

  @override
  Future<List<Map<String, dynamic>>> fetchTransactions({
    required String branchId,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final ditto = _dittoService.dittoInstance;
    if (ditto == null) return [];

    final args = <String, dynamic>{
      'branchId': branchId,
      'status': 'COMPLETE',
    };

    var query =
        'SELECT * FROM transactions '
        'WHERE branchId = :branchId AND status = :status AND subTotal > 0';

    if (startDate != null) {
      query += ' AND createdAt >= :start';
      args['start'] = startDate.toIso8601String();
    }
    if (endDate != null) {
      query += ' AND createdAt <= :end';
      args['end'] =
          DateTime(endDate.year, endDate.month, endDate.day, 23, 59, 59, 999)
              .toIso8601String();
    }

    query += ' ORDER BY createdAt DESC';

    final result = await ditto.store.execute(query, arguments: args);
    return result.items
        .map((i) => Map<String, dynamic>.from(i.value))
        .toList();
  }

  @override
  Future<List<Map<String, dynamic>>> fetchTransactionItems({
    required List<String> transactionIds,
  }) async {
    if (transactionIds.isEmpty) return [];

    final ditto = _dittoService.dittoInstance;
    if (ditto == null) return [];

    // Build positional placeholders: :id0, :id1, ...
    final placeholders =
        transactionIds.indexed.map((e) => ':id${e.$1}').join(', ');
    final args = <String, dynamic>{
      for (final (i, id) in transactionIds.indexed) 'id$i': id,
    };

    final result = await ditto.store.execute(
      'SELECT * FROM transaction_items WHERE transactionId IN ($placeholders)',
      arguments: args,
    );
    return result.items
        .map((i) => Map<String, dynamic>.from(i.value))
        .toList();
  }

  @override
  Stream<List<Map<String, dynamic>>> watchTransactions({
    required String branchId,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    final ditto = _dittoService.dittoInstance;
    if (ditto == null) return const Stream.empty();

    final args = <String, dynamic>{
      'branchId': branchId,
      'status': 'COMPLETE',
    };
    var query =
        'SELECT * FROM transactions '
        'WHERE branchId = :branchId AND status = :status AND subTotal > 0';
    if (startDate != null) {
      query += ' AND createdAt >= :start';
      args['start'] = startDate.toIso8601String();
    }
    if (endDate != null) {
      query += ' AND createdAt <= :end';
      args['end'] =
          DateTime(endDate.year, endDate.month, endDate.day, 23, 59, 59, 999)
              .toIso8601String();
    }
    query += ' ORDER BY createdAt DESC';

    final controller = StreamController<List<Map<String, dynamic>>>.broadcast();
    dynamic observer;

    observer = ditto.store.registerObserver(
      query,
      arguments: args,
      onChange: (queryResult) {
        if (controller.isClosed) return;
        final rows = queryResult.items
            .map((i) => Map<String, dynamic>.from(i.value))
            .toList();
        controller.add(rows);
      },
    );

    controller.onCancel = () async {
      await cancelDittoStoreObserver(observer);
      if (!controller.isClosed) await controller.close();
    };

    return controller.stream;
  }
}
