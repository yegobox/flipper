import 'package:flipper_services/proxy.dart';
import 'package:flutter_riverpod/legacy.dart';

final customerPhoneNumberProvider = StateProvider<String?>((ref) {
  return ProxyService.box.currentSaleCustomerPhoneNumber();
});
