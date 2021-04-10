library flipper_models;

import 'package:flipper_models/g_customer.dart';
import 'package:flipper_services/abstractions/api.dart';
import 'package:flipper_services/constant.dart';
import 'package:flipper_services/locator.dart';
import 'package:flipper_services/proxy.dart';
import 'package:uuid/uuid.dart';

import 'base_model.dart';

class CustomerViewModel extends BaseModel {
  final api = locator<Api>();
  List<GCustomer> customers = [];

  String _name;
  String _email;
  String _phoneNumber;
  // ignore: missing_return
  String setName({String name}) {
    _name = name;
    notifyListeners();
  }

  // ignore: missing_return
  String setEmail({String email}) {
    _email = email;
    notifyListeners();
  }

  // ignore: missing_return
  String setPhoneNumber({String phone}) {
    _phoneNumber = phone;
    notifyListeners();
  }

  void createCustomer() {
    //TODO: add real validation here
    assert(_name != null);
    assert(_email != null);
    assert(_phoneNumber != null);
    final id = Uuid().v1();
    final Map<dynamic, dynamic> customer = {
      'name': _name,
      'id': id,
      'email': _email,
      'phoneNumber': _phoneNumber,
      'totalPoints': 0.0,
      'totalVisit': 0,
      'firstVisit': 'null',
      'totalSpent': 0.0,
      'table': AppTables.customers,
      'channels': [ProxyService.sharedState.user.id.toString()]
    };
    ProxyService.api.create(customer: customer, id: id);
  }

  ///It sort by number for now todo: will add other fields later on
  void search({String phoneNumber}) {
    //todo: this is draft need to come up with proper algorithm
    customers
        .sort((a, b) => a.phoneNumber.length.compareTo(phoneNumber.length));
    notifyListeners();
  }

  void getCustomers() async {
    customers = await ProxyService.api.customers();
    notifyListeners();
  }
}
