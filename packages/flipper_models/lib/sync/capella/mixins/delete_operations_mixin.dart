import 'package:flipper_models/sync/interfaces/delete_operations_interface.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/flipper_http_client.dart';
import 'package:supabase_models/brick/repository.dart';
import 'package:talker/talker.dart';

mixin CapellaDeleteOperationsMixin implements DeleteOperationsInterface {
  Repository get repository;
  Talker get talker;

  @override
  Future<void> deleteBranch({
    required int branchId,
    required HttpClientInterface flipperHttpClient,
  }) async {
    throw UnimplementedError(
        'deleteBranch needs to be implemented for Capella');
  }

  @override
  Future<int> deleteFavoriteByIndex({required String favIndex}) async {
    throw UnimplementedError(
        'deleteFavoriteByIndex needs to be implemented for Capella');
  }

  @override
  Future<void> deleteItemFromCart({
    required TransactionItem transactionItemId,
    String? transactionId,
  }) async {
    throw UnimplementedError(
        'deleteItemFromCart needs to be implemented for Capella');
  }

  @override
  Future<int> deleteTransactionByIndex(
      {required String transactionIndex}) async {
    throw UnimplementedError(
        'deleteTransactionByIndex needs to be implemented for Capella');
  }
}
