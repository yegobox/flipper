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

  /// Returns a list of customers filtered by [branchId], [key], and/or [id].
  ///
  /// - If [key] is provided and not empty:
  ///   - Searches across 'custNm', 'email', and 'telNo' fields using a contains match.
  ///   - Combines results from all fields, filters by [branchId] if provided.
  ///   - If [id] is provided, further filters results to only those with the matching id.
  ///   - Deduplicates the final list by customer id.
  /// - If [key] is not provided or empty:
  ///   - Filters by [id] and/or [branchId] if provided.
  ///   - If no filters are provided, returns an empty list.
  ///
  /// This method ensures efficient customer search and avoids duplicate entries in the results.
  @override
  FutureOr<List<Customer>> customers({
    int? branchId,
    String? key,
    String? id,
  }) async {
    if (key != null && key.isNotEmpty) {
      final searchFields = ['custNm', 'email', 'telNo'];

      final queries = searchFields.map((field) => Query(where: [
            Where(field, value: key, compare: Compare.contains),
            if (branchId != null)
              Where('branchId', value: branchId, compare: Compare.exact),
          ]));

      final results = await Future.wait(
        queries.map((query) => repository.get<Customer>(
              policy: OfflineFirstGetPolicy.alwaysHydrate,
              query: query,
            )),
      );

      var flattened = results.expand((c) => c);
      if (id != null) {
        flattened = flattened.where((c) => c.id == id);
      }

      // Remove duplicates by id
      return {for (final c in flattened) c.id: c}.values.toList();
    }

    final query = Query(where: [
      if (id != null) Where('id', value: id, compare: Compare.exact),
      if (branchId != null)
        Where('branchId', value: branchId, compare: Compare.exact),
    ]);

    if (query.where!.isEmpty && (key == null || key.isEmpty)) {
      return [];
    }

    return repository.get<Customer>(
      policy: OfflineFirstGetPolicy.alwaysHydrate,
      query: query,
    );
  }
}
