library flipper_models;

import 'package:flipper/routes.locator.dart';
import 'package:flipper_models/models/business.dart';
import 'package:flipper_models/models/product.dart';
import 'package:stacked/stacked.dart';
import 'package:flipper_services/keypad_service.dart';
import 'package:flipper_services/proxy.dart';

class BusinessHomeViewModel extends ReactiveViewModel {
  final KeyPadService _keypad = locator<KeyPadService>();
  String get key => _keypad.key;
  // keypad service
  get keyPad => null;

  get keypadValue => null;

  void addKey(String key) {
    if (key == 'C') {
      ProxyService.keypad.reset();
    } else {
      ProxyService.keypad.addKey(key);
    }
  }

  // products methods
  Future<List<Product>> products() async {
    return await ProxyService.api.products();
  }

  List<Business> _businesses = [];
  List<Business> get businesses => _businesses;
  void loadBusinesses() async {
    List<Business>? response = await ProxyService.api.businesses();
    _businesses = response!;
    notifyListeners();
  }

  void reset() {
    ProxyService.keypad.reset();
  }

  @override
  List<ReactiveServiceMixin> get reactiveServices => [_keypad];
}
