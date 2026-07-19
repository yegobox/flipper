import 'dart:async';

import 'package:flipper_models/db_model_export.dart';

abstract class CustomerInterface {
  Future<Customer?> addCustomer({
    required Customer customer,
    String? transactionId,
  });
  FutureOr<List<Customer>> customers(
      {String? branchId, String? key, String? id});

  /// One-shot phone lookup for auto-register / sale linking.
  ///
  /// Prefer this over [customers] with a search key when matching by phone:
  /// Capella's observer-based [customers] can complete on an empty first fire
  /// and miss an existing row (causing duplicate auto-creates).
  Future<List<Customer>> findCustomersByPhone({
    required String branchId,
    required String phone,
  });

  /// Return a single [Customer] by [id] or null if not found.
  Future<Customer?> customerById(String id);
}
