library flipper_services;

import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'locator.config.dart';

final GetIt locator = GetIt.instance;

@injectableInit
Future<void> thirdPartyLocator() async {
  // Initialize injectable dependencies
  await $initGetIt(locator);
}
