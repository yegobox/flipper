import 'package:flipper_actionable/service.dart';

import 'api.dart';
import 'locator.dart';
import 'storage.dart';

final Storage _box = locator<Storage>();
final Service _service = locator<Service>();
final AB _api = locator<AB>();

abstract class Proxy {
  static Storage get box => _box;
  static Service get service => _service;
  static AB get api => _api;
}
