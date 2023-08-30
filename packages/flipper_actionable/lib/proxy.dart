import 'package:flipper_actionable/service.dart';

import 'api.dart';
import 'locator.dart' as loc;
import 'storage.dart';

final Storage _box = loc.locator<Storage>();
final Service _service = loc.locator<Service>();
final AB _api = loc.locator<AB>();

abstract class Proxy {
  static Storage get box => _box;
  static Service get service => _service;
  static AB get api => _api;
}
