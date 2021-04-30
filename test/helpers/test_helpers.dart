import 'package:flipper_models/models/login.dart';
import 'package:flipper_services/abstractions/api.dart';
import 'package:flipper_services/abstractions/storage.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:stacked_services/stacked_services.dart';
import 'test_helpers.mocks.dart';
import 'package:flipper_services/locator.dart';

@GenerateMocks([], customMocks: [
  MockSpec<Api>(returnNullOnMissingStub: true),
  MockSpec<LocalStorage>(returnNullOnMissingStub: true),
  MockSpec<NavigationService>(returnNullOnMissingStub: true),
])
Api getAndRegisterApi({bool hasLoggedInUser = false}) {
  _removeRegistrationIfExists<Api>();
  final service = MockApi();
  when(service.login()).thenAnswer(
    (_) async => Login(
      id: 1,
      email: 'email',
      synced: 1,
      name: 'ric',
      newUser: false,
      token: 't',
    ),
  );
  locator.registerSingleton<Api>(service);
  return service;
}

NavigationService getAndRegisterNavigationService() {
  _removeRegistrationIfExists<NavigationService>();
  final service = MockNavigationService();
  locator.registerSingleton<NavigationService>(service);
  return service;
}

MockLocalStorage getAndRegisterLocalStorage() {
  _removeRegistrationIfExists<LocalStorage>();
  final service = MockLocalStorage();
  locator.registerSingleton<LocalStorage>(service);
  return service;
}

void registerServices() {
  getAndRegisterApi();
  getAndRegisterNavigationService();
  getAndRegisterLocalStorage();
}

void unregisterServices() {
  locator.unregister<Api>();
  locator.unregister<NavigationService>();
  locator.unregister<LocalStorage>();
}

void _removeRegistrationIfExists<T extends Object>() {
  if (locator.isRegistered<T>()) {
    locator.unregister<T>();
  }
}
