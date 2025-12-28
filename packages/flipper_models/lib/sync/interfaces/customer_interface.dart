import 'dart:async';

import 'package:flipper_models/db_model_export.dart';

abstract class CustomerInterface {
  Future<Customer?> addCustomer({
    required Customer customer,
    String? transactionId,
  });
  FutureOr<List<Customer>> customers(
      {String? branchId, String? key, String? id});

  /// Return a single [Customer] by [id] or null if not found.
  Future<Customer?> customerById(String id);
}
