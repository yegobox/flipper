library flipper_services;

import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:stacked_services/src/dialog/dialog_service.dart';
import 'package:stacked_services/src/bottom_sheet/bottom_sheet_service.dart';
import 'locator.config.dart';
// import 'package:stacked_services/src/navigation/router_service.dart';

final GetIt locator = GetIt.instance;

@injectableInit
Future<void> setupLocator() async {
  // Initialize injectable dependencies
  await $initGetIt(locator);

  // Register the BottomSheetService
  locator.registerLazySingleton<BottomSheetService>(() => BottomSheetService());

  // Register the DialogService
  locator.registerLazySingleton<DialogService>(() => DialogService());
  // locator.registerLazySingleton<RouterService>(() => RouterService());
}
