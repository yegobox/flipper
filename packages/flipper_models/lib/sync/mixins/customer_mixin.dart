import 'dart:async';

import 'package:flipper_models/sync/interfaces/customer_interface.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:supabase_models/brick/repository.dart'
    show Repository, WherePhrase;
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

  /// Returns a list of customers filtered by [branchId], [key], and/or [id].
  ///
  /// - If [key] is provided and not empty:
  ///   - Performs case-insensitive search across 'custNm', 'email', and 'telNo' fields.
  ///   - Uses a single query with OR conditions for efficient searching.
  ///   - Filters by [branchId] and/or [id] if provided.
  /// - If [key] is not provided or empty:
  ///   - Filters by [id] and/or [branchId] if provided.
  ///   - If no filters are provided, returns an empty list.
  ///
  /// This method ensures efficient, case-insensitive customer search.
  @override
  FutureOr<List<Customer>> customers({
    String? branchId,
    String? key,
    String? id,
  }) async {
    if (key != null && key.isNotEmpty) {
      // Use a single query with OR conditions for all search fields
      // Convert search key to lowercase for case-insensitive matching
      final searchKey = key.toLowerCase();

      final query = Query(where: [
        // OR phrase for searching across multiple fields
        WherePhrase([
          Where('custNm', value: searchKey, compare: Compare.contains),
          Where('email', value: searchKey, compare: Compare.contains),
          Where('telNo', value: searchKey, compare: Compare.contains),
        ], isRequired: true),
        // AND conditions for filtering
        if (branchId != null && branchId.isNotEmpty)
          Where('branchId', value: branchId, compare: Compare.exact),
        if (id != null && id.isNotEmpty)
          Where('id', value: id, compare: Compare.exact),
      ]);

      final response = await repository.get<Customer>(
        policy: OfflineFirstGetPolicy.awaitRemoteWhenNoneExist,
        query: query,
      );
      return response;
    }

    final query = Query(where: [
      if (id != null && id.isNotEmpty)
        Where('id', value: id, compare: Compare.exact),
      if (branchId != null && branchId.isNotEmpty)
        Where('branchId', value: branchId, compare: Compare.exact),
    ]);

    if (query.where!.isEmpty && (key == null || key.isEmpty)) {
      return [];
    }

    final response = await repository.get<Customer>(
      policy: OfflineFirstGetPolicy.awaitRemoteWhenNoneExist,
      query: query,
    );
    return response;
  }

  /// Convenience method to fetch a single [Customer] by [id].
  ///
  /// Returns the matching [Customer] or `null` if not found.
  Future<Customer?> customerById(String id) async {
    final results = await repository.get<Customer>(
      policy: OfflineFirstGetPolicy.alwaysHydrate,
      query: Query(where: [Where('id', value: id, compare: Compare.exact)]),
    );
    if (results.isEmpty) return null;
    return results.first;
  }
}
