import 'package:flipper_models/sync/interfaces/delete_operations_interface.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/flipper_http_client.dart';
import 'package:supabase_models/brick/repository.dart';
import 'package:talker/talker.dart';

import 'package:flipper_web/services/ditto_service.dart';

mixin CapellaDeleteOperationsMixin implements DeleteOperationsInterface {
  Repository get repository;
  Talker get talker;
  DittoService get dittoService => DittoService.instance;

  @override
  Future<void> deleteBranch({
    required String branchId,
    required HttpClientInterface flipperHttpClient,
  }) async {
    throw UnimplementedError(
      'deleteBranch needs to be implemented for Capella',
    );
  }

  @override
  Future<int> deleteFavoriteByIndex({required String favIndex}) async {
    throw UnimplementedError(
      'deleteFavoriteByIndex needs to be implemented for Capella',
    );
  }

  @override
  Future<void> deleteItemFromCart({
    required TransactionItem transactionItemId,
    String? transactionId,
  }) async {
    final ditto = dittoService.dittoInstance;
    if (ditto == null) {
      talker.error('Ditto not initialized for deleteItemFromCart');
      return;
    }

    try {
      final id = transactionItemId.id;
      const query =
          "DELETE FROM transaction_items WHERE _id = :id OR id = :id";
      await ditto.store.execute(query, arguments: {'id': id});
      talker.info('Deleted transaction item $id from Ditto');

      final txnId = transactionId ?? transactionItemId.transactionId;
      if (txnId != null) {
        final contrib =
            transactionItemId.price.toDouble() * transactionItemId.qty.toDouble();
        await _adjustTransactionSubtotalByDelta(ditto, txnId, -contrib);
      }
    } catch (e) {
      talker.error('Error deleting item from cart in Capella: $e');
    }
  }

  Future<void> _adjustTransactionSubtotalByDelta(
    dynamic ditto,
    String transactionId,
    double delta,
  ) async {
    if (delta == 0) return;

    final tid = transactionId;
    final row = await ditto.store.execute(
      'SELECT subTotal FROM transactions WHERE _id = :tid OR id = :tid LIMIT 1',
      arguments: {'tid': tid},
    );
    if (row.items.isEmpty) return;

    final current = (Map<String, dynamic>.from(row.items.first.value)['subTotal']
            as num?)
        ?.toDouble() ??
        0.0;
    final newSubTotal = current + delta;

    final now = DateTime.now().toIso8601String();
    await ditto.store.execute(
      'UPDATE transactions SET subTotal = :subTotal, updatedAt = :ua, lastTouched = :lt WHERE _id = :tid OR id = :tid',
      arguments: {
        'subTotal': newSubTotal,
        'ua': now,
        'lt': now,
        'tid': tid,
      },
    );
  }

  @override
  Future<int> deleteTransactionByIndex({
    required String transactionIndex,
  }) async {
    throw UnimplementedError(
      'deleteTransactionByIndex needs to be implemented for Capella',
    );
  }

  @override
  Future<bool> flipperDelete({
    required String id,
    String? endPoint,
    HttpClientInterface? flipperHttpClient,
  }) async {
    final ditto = dittoService.dittoInstance;
    if (ditto == null) {
      talker.error("Ditto not initialized");
      return false;
    }

    if (endPoint == 'transactionItem') {
      try {
        // Fetch the item first to get transactionId and line total for subTotal delta
        final fetchResult = await ditto.store.execute(
          "SELECT * FROM transaction_items WHERE _id = :id OR id = :id",
          arguments: {'id': id},
        );
        String? transactionId;
        double subtotalDelta = 0;
        if (fetchResult.items.isNotEmpty) {
          final data = Map<String, dynamic>.from(fetchResult.items.first.value);
          transactionId = data['transactionId'] as String?;
          final qty = (data['qty'] as num?)?.toDouble() ?? 0.0;
          final price = (data['price'] as num?)?.toDouble() ?? 0.0;
          subtotalDelta = -(price * qty);
        }

        const query =
            "DELETE FROM transaction_items WHERE _id = :id OR id = :id";
        await ditto.store.execute(query, arguments: {'id': id});

        if (transactionId != null) {
          await _adjustTransactionSubtotalByDelta(
            ditto,
            transactionId,
            subtotalDelta,
          );
        }
        return true;
      } catch (e) {
        talker.error("Error deleting transaction item: $e");
        return false;
      }
    }
    return false;
  }
}
