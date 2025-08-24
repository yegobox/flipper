import 'package:flipper_services/proxy.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final customerPhoneNumberProvider = StateProvider<String?>((ref) {
  return ProxyService.box.currentSaleCustomerPhoneNumber();
});
