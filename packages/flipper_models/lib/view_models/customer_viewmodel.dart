library flipper_models;

import 'package:flipper_models/customer.dart';
import 'package:flipper_services/abstractions/api.dart';
import 'package:flipper_services/locator.dart';

import 'base_model.dart';

class CustomerViewModel extends BaseModel {
  final api = locator<Api>();
  List<Customer> customers;
  List<Customer> loadCustomers() {
    customers = api.customers();
    return customers;
  }
}
