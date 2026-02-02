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
    throw UnimplementedError(
      'deleteItemFromCart needs to be implemented for Capella',
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
        const query =
            "DELETE FROM transaction_items WHERE _id = :id OR id = :id";
        await ditto.store.execute(query, arguments: {'id': id});
        return true;
      } catch (e) {
        talker.error("Error deleting transaction item: $e");
        return false;
      }
    }
    return false;
  }
}
