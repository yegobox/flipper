
import 'package:flipper/services/analytics_service.dart';
import 'package:flipper/services/bluethooth_service.dart';
import 'package:flipper/services/firestore_service.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:get_it/get_it.dart';

GetIt locator = GetIt.instance;
void setupLocator() {
  locator.registerLazySingleton(() => NavigationService());
  locator.registerLazySingleton(() => DialogService());
  // locator.registerLazySingleton(() => AuthenticationService());
  locator.registerLazySingleton(() => SnackbarService());
  locator.registerLazySingleton(() => FirestoreService());
  locator.registerLazySingleton(() => AnalyticsService());
  locator.registerLazySingleton(() => BlueToothService());
}
