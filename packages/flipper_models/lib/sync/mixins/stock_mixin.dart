import 'package:flipper_models/sync/interfaces/stock_interface.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:supabase_models/brick/repository.dart';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:brick_offline_first/brick_offline_first.dart';

mixin StockMixin implements StockInterface {
  Repository get repository;

  @override
  Future<Stock?> getStockById({required String id}) async {
    return (await repository.get<Stock>(
      query: Query(where: [Where('id').isExactly(id)]),
    ))
        .firstOrNull;
  }

  @override
  Future<void> updateStock({required Stock stock}) async {
    try {
      await repository.upsert<Stock>(stock);
    } catch (e, s) {
      talker.warning('Error in updateStock: $e $s');
      talker.error(s);
      rethrow;
    }
  }

  @override
  Future<List<InventoryRequest>> requests({required String requestId}) async {
    return await repository.get<InventoryRequest>(
      query: Query(where: [Where('id').isExactly(requestId)]),
      policy: OfflineFirstGetPolicy.awaitRemoteWhenNoneExist,
    );
  }
}
