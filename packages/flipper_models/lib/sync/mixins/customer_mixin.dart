import 'package:flipper_models/sync/interfaces/customer_interface.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:supabase_models/brick/repository.dart';
import 'package:brick_offline_first/brick_offline_first.dart';

mixin CustomerMixin implements CustomerInterface {
  Repository get repository;

  @override
  Future<Customer?> addCustomer({
    required Customer customer,
    String? transactionId,
  }) async {
    return await repository.upsert(customer);
  }

  @override
  Future<List<Customer>> customers(
      {required String id, required int branchId}) async {
    return await repository.get<Customer>(
      query: Query(where: [
        Where('id').isExactly(id),
        Where('branchId').isExactly(branchId),
      ]),
      policy: OfflineFirstGetPolicy.awaitRemoteWhenNoneExist,
    );
  }
}
