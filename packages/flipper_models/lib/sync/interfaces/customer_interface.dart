import 'package:flipper_models/realm_model_export.dart';

abstract class CustomerInterface {
  Future<Customer?> addCustomer({
    required Customer customer,
    String? transactionId,
  });
}
