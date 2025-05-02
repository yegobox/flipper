import 'dart:async';

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
  FutureOr<List<Customer>> customers(
      {required int branchId, String? key, String? id}) async {
    if (id != null) {
      return repository.get<Customer>(
          policy: OfflineFirstGetPolicy.localOnly,
          query: Query(where: [
            Where('id', value: id, compare: Compare.exact),
          ]));
    }

    if (key != null) {
      final searchFields = ['custNm', 'email', 'telNo'];
      final queries = searchFields.map((field) => Query(where: [
            Where(field, value: key, compare: Compare.contains),
            Where('branchId', value: branchId, compare: Compare.exact),
          ]));

      final results =
          await Future.wait(queries.map((query) => repository.get<Customer>(
                policy: OfflineFirstGetPolicy.localOnly,
                query: query,
              )));

      return results.expand((customers) => customers).toList();
    }

    // If only branchId is provided, return all customers for that branch
    return repository.get<Customer>(
        policy: OfflineFirstGetPolicy.localOnly,
        query: Query(where: [
          Where('branchId', value: branchId, compare: Compare.exact),
        ]));
  }
}
