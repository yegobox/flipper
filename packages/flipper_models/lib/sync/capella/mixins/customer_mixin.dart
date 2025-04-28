import 'dart:async';

import 'package:flipper_models/sync/interfaces/customer_interface.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:supabase_models/brick/repository.dart';
import 'package:talker/talker.dart';

mixin CapellaCustomerMixin implements CustomerInterface {
  Repository get repository;
  Talker get talker;

  @override
  Future<Customer?> addCustomer({
    required Customer customer,
    String? transactionId,
  }) async {
    throw UnimplementedError('addCustomer needs to be implemented for Capella');
  }

  FutureOr<List<Customer>> customers(
      {required int branchId, String? key, String? id}) {
    throw UnimplementedError('addCustomer needs to be implemented for Capella');
  }
}
