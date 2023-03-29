library flipper_services;

import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:stacked_services/stacked_services.dart';
import 'locator.config.dart';

final GetIt locator = GetIt.instance;

@injectableInit
Future<void> setupLocator() async {
  // Initialize injectable dependencies
  await $initGetIt(locator);

  // Register the BottomSheetService
  locator.registerLazySingleton<BottomSheetService>(() => BottomSheetService());

  // Register the DialogService
  locator.registerLazySingleton<DialogService>(() => DialogService());
}
