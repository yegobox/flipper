import 'package:flipper/couchbase.dart';
import 'package:flipper/services/analytics_service.dart';
import 'package:flipper/services/bluethooth_service.dart';
import 'package:flipper/services/dialog_service.dart';
import 'package:flipper/services/firestore_service.dart';
import 'package:flipper/services/flipperNavigation_service.dart';

import 'package:get_it/get_it.dart';
import 'package:stacked_services/stacked_services.dart';


GetIt locator = GetIt.instance;
void setupLocator() {

  locator.registerLazySingleton(() => FlipperDialogService());
  locator.registerLazySingleton(() => FlipperNavigationService());
  locator.registerLazySingleton(() => SnackbarService ());
  locator.registerLazySingleton(() => FirestoreService());
  locator.registerLazySingleton(() => AnalyticsService());
  locator.registerLazySingleton(() => BlueToothService());
  locator.registerLazySingleton(() => AppDatabase());
}
