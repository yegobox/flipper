import 'package:couchbase_lite/couchbase_lite.dart';
import 'package:flipper/locator.dart';
import 'package:flipper/services/database_service.dart';
import 'package:flipper/services/shared_preference_service.dart';
import 'package:mockito/mockito.dart';


import 'package:stacked_services/stacked_services.dart';

class SharedPreferenceServiceMock extends Mock
    implements SharedPreferenceService {}

class NavigationServiceMock extends Mock implements NavigationService {}

class DatabaseServiceMock extends Mock implements DatabaseService {}

SharedPreferenceService getAndRegisterSharedPreferencesMock(
    {bool hasUser = true}) {
  _removeRegistrationIfExists<SharedPreferenceService>();
  final service = SharedPreferenceServiceMock();

  // stubbing
  when(service.isAppConstantsInitialized()).thenReturn(Future.delayed(const Duration(microseconds: 2000)));

  locator.registerSingleton<SharedPreferenceService>(service);
  return service;
}

NavigationService getAndRegisterNavigationServiceMock() {
  _removeRegistrationIfExists<NavigationService>();
  final service = NavigationServiceMock();
  locator.registerSingleton<NavigationService>(service);
  return service;
}

DatabaseService getAndRegisterDatabaseMock({bool returnAddress = true}) {
  _removeRegistrationIfExists<DatabaseService>();
  final database = DatabaseServiceMock();

  when(database.getById(id:'id')).thenAnswer((realInvocation) {
    if (returnAddress) return Future.value(MutableDocument());
    return null;
  });

  locator.registerSingleton<DatabaseService>(database);
  return database;
}

void registerServices() {
  getAndRegisterSharedPreferencesMock();
  getAndRegisterNavigationServiceMock();
  getAndRegisterDatabaseMock();
}

void unregisterServices() {
  locator.unregister<SharedPreferenceService>();
  locator.unregister<NavigationService>();
  locator.unregister<DatabaseService>();
}

void _removeRegistrationIfExists<T>() {
  if (locator.isRegistered<T>()) {
    locator.unregister<T>();
  }
}
