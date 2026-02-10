import 'package:flipper_models/flipper_http_client.dart';
import 'package:flipper_models/db_model_export.dart';

abstract class DeleteOperationsInterface {
  Future<void> deleteBranch({
    required String branchId,
    required HttpClientInterface flipperHttpClient,
  });

  Future<int> deleteFavoriteByIndex({required String favIndex});

  Future<void> deleteItemFromCart({
    required TransactionItem transactionItemId,
    String? transactionId,
  });

  Future<int> deleteTransactionByIndex({required String transactionIndex});

  Future<bool> flipperDelete({
    required String id,
    String? endPoint,
    HttpClientInterface? flipperHttpClient,
  });
}
