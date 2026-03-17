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
        await _recalculateTransactionSubTotal(ditto, txnId);
      }
    } catch (e) {
      talker.error('Error deleting item from cart in Capella: $e');
    }
  }

  Future<void> _recalculateTransactionSubTotal(
      dynamic ditto, String transactionId) async {
    final itemsResult = await ditto.store.execute(
      "SELECT * FROM transaction_items WHERE transactionId = :tid AND active = :active",
      arguments: {'tid': transactionId, 'active': true},
    );

    double newSubTotal = 0.0;
    for (final item in itemsResult.items) {
      final data = Map<String, dynamic>.from(item.value);
      final qty = (data['qty'] as num?)?.toDouble() ?? 0.0;
      final price = (data['price'] as num?)?.toDouble() ?? 0.0;
      newSubTotal += price * qty;
    }

    await ditto.store.execute(
      "UPDATE transactions SET subTotal = :subTotal, updatedAt = :updatedAt WHERE _id = :id OR id = :id",
      arguments: {
        'subTotal': newSubTotal,
        'updatedAt': DateTime.now().toIso8601String(),
        'id': transactionId,
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
        // Fetch the item first to get transactionId for subtotal recalculation
        final fetchResult = await ditto.store.execute(
          "SELECT * FROM transaction_items WHERE _id = :id OR id = :id",
          arguments: {'id': id},
        );
        String? transactionId;
        if (fetchResult.items.isNotEmpty) {
          final data = Map<String, dynamic>.from(fetchResult.items.first.value);
          transactionId = data['transactionId'] as String?;
        }

        const query =
            "DELETE FROM transaction_items WHERE _id = :id OR id = :id";
        await ditto.store.execute(query, arguments: {'id': id});

        if (transactionId != null) {
          await _recalculateTransactionSubTotal(ditto, transactionId);
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
