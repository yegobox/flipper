import 'package:flipper_actionable/service.dart';

import 'api.dart';
import 'locator.dart' as loc;
import 'storage.dart';

abstract class Proxy {
  // These are now settable static fields, allowing them to be replaced by mocks in tests.
  // By default, they are initialized with the real instances from the locator.
  static Storage box = loc.locator<Storage>();
  static Service service = loc.locator<Service>();
  static AB api = loc.locator<AB>();
}
