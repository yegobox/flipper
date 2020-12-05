
import 'package:couchbase_lite_dart/couchbase_lite_dart.dart';
import 'package:flipper/locator.dart';
import 'package:flipper/model/business.dart';
import 'package:flipper/services/database_service.dart';
import 'package:flipper/services/shared_preference_service.dart';
import 'package:flipper/services/shared_state_service.dart';
import 'package:mockito/mockito.dart';


// import 'package:stacked_services/stacked_services.dart';

class SharedPreferenceServiceMock extends Mock
    implements SharedPreferenceService {}

    class ShareStateServiceMock extends Mock implements SharedStateService{}

// class NavigationServiceMock extends Mock implements NavigationService {}

class DatabaseServiceMock extends Mock implements DatabaseService {}

SharedPreferenceService getAndRegisterSharedPreferencesMock(
    {bool hasUser = true}) {
  _removeRegistrationIfExists<SharedPreferenceService>();
  final service = SharedPreferenceServiceMock();
  final _state = ShareStateServiceMock();
  // stubbing
  when(service.isAppConstantsInitialized()).thenAnswer( (_) async => true);
  when(_state.business).thenAnswer((_)=>Business.fromMap({'name':'richie'}));
  locator.registerSingleton<SharedPreferenceService>(service);
  return service;
}

// NavigationService getAndRegisterNavigationServiceMock() {
//   _removeRegistrationIfExists<NavigationService>();
//   final service = NavigationServiceMock();
//   locator.registerSingleton<NavigationService>(service);
//   return service;
// }

// DatabaseService getAndRegisterDatabaseMock({bool returnAddress = true}) {
//   _removeRegistrationIfExists<DatabaseService>();
//   final database = DatabaseServiceMock();
//
//   when(database.getById(id:'id')).thenAnswer((realInvocation) {
//     if (returnAddress) return ;
//     return null;
//   });
//
//   locator.registerSingleton<DatabaseService>(database);
//   return database;
// }

void registerServices() {
  getAndRegisterSharedPreferencesMock();
  // getAndRegisterNavigationServiceMock();
  // getAndRegisterDatabaseMock();
}

void unregisterServices() {
  locator.unregister<SharedPreferenceService>();
  // locator.unregister<NavigationService>();
  // locator.unregister<DatabaseService>();
}

void _removeRegistrationIfExists<T>() {
  if (locator.isRegistered<T>()) {
    locator.unregister<T>();
  }
}
