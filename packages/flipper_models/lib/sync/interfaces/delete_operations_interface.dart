import 'package:flipper_models/flipper_http_client.dart';
import 'package:flipper_models/db_model_export.dart';

abstract class DeleteOperationsInterface {
  Future<void> deleteBranch({
    required int branchId,
    required HttpClientInterface flipperHttpClient,
  });

  Future<int> deleteFavoriteByIndex({required String favIndex});

  Future<void> deleteItemFromCart({
    required TransactionItem transactionItemId,
    String? transactionId,
  });

  Future<int> deleteTransactionByIndex({required String transactionIndex});
}
