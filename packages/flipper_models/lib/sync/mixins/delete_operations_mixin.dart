import 'package:flipper_models/sync/interfaces/delete_operations_interface.dart';
import 'package:flipper_models/flipper_http_client.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:supabase_models/brick/repository.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_models/helperModels/talker.dart';

mixin DeleteOperationsMixin implements DeleteOperationsInterface {
  Repository get repository;
  String get apihub;

  @override
  Future<void> deleteBranch({
    required int branchId,
    required HttpClientInterface flipperHttpClient,
  }) async {
    try {
      await flipperHttpClient
          .delete(Uri.parse('$apihub/v2/api/branch/$branchId'));

      Branch? branch = (await repository.get<Branch>(
        query: Query(where: [Where('serverId').isExactly(branchId)]),
      ))
          .firstOrNull;

      if (branch != null) {
        await repository.delete<Branch>(branch);
      }
    } catch (e, s) {
      talker.error(e);
      talker.error(s);
      rethrow;
    }
  }

  @override
  Future<int> deleteFavoriteByIndex({required String favIndex}) async {
    Favorite? favorite = (await repository.get<Favorite>(
      query: Query(where: [Where('favIndex').isExactly(favIndex)]),
    ))
        .firstOrNull;

    if (favorite != null) {
      await repository.delete(favorite);
    }
    return 200;
  }

  @override
  Future<void> deleteItemFromCart({
    required TransactionItem transactionItemId,
    String? transactionId,
  }) async {
    final items = await repository.get<TransactionItem>(
      query: Query(where: [
        Where('id').isExactly(transactionItemId.id),
        if (transactionId != null)
          Where('transactionId').isExactly(transactionId),
        Where('branchId').isExactly(ProxyService.box.getBranchId()!),
      ]),
    );

    if (items.isNotEmpty) {
      await repository.delete(items.first);
    }
  }

  @override
  Future<int> deleteTransactionByIndex(
      {required String transactionIndex}) async {
    final transactions = await repository.get<ITransaction>(
      query: Query(where: [Where('id').isExactly(transactionIndex)]),
    );

    if (transactions.isNotEmpty) {
      await repository.delete(transactions.first);
    }
    return 200;
  }
}
