import 'package:flipper_models/models/business.dart';
import 'package:flipper_models/models/login.dart';
import 'package:flipper_models/models/product_mock.dart';
import 'package:flipper_models/models/variation.dart';
import 'package:flipper_services/abstractions/api.dart';
import 'package:flipper_services/abstractions/storage.dart';
import 'package:flipper_services/app_service.dart';
import 'package:flipper_services/keypad_service.dart';
import 'package:flipper_services/product_service.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:stacked_services/stacked_services.dart';
import 'test_helpers.mocks.dart';
import 'package:flipper_services/locator.dart';

@GenerateMocks([], customMocks: [
  MockSpec<Api>(returnNullOnMissingStub: true),
  MockSpec<ProductService>(returnNullOnMissingStub: true),
  MockSpec<LocalStorage>(returnNullOnMissingStub: true),
  MockSpec<AppService>(returnNullOnMissingStub: true),
  MockSpec<NavigationService>(returnNullOnMissingStub: true),
])
Api getAndRegisterApi(
    {bool hasLoggedInUser = false,
    List<Business>? businesses,
    Map? data,
    String? uri,
    List<Variation>? variations}) {
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

  when(service.businesses()).thenAnswer((_) async => businesses!);
<<<<<<< HEAD
  when(service.addVariant(data: variations)).thenAnswer((_) async => 200);
=======
  when(service.addVariant(data: variations, retailPrice: 0.0, supplyPrice: 0.0))
      .thenAnswer((_) async => 200);
>>>>>>> mobile
  if (data != null) {
    when(service.update(data: data, endPoint: uri))
        .thenAnswer((_) async => 200);
  }

  locator.registerSingleton<Api>(service);
  return service;
}

AppService getAndRegisterAppService(
    {bool hasLoggedInUser = false,
    String branchId = 'BID',
    String userid = 'BID',
    String businessId = "BID"}) {
  _removeRegistrationIfExists<AppService>();
  final service = MockAppService();
  when(service.hasLoggedInUser).thenReturn(hasLoggedInUser);
  when(service.branchId).thenReturn(branchId);
  when(service.userid).thenReturn(userid);
  when(service.businessId).thenReturn(businessId);
  when(service.isLoggedIn()).thenAnswer((realInvocation) => hasLoggedInUser);
  locator.registerSingleton<AppService>(service);

  return service;
}

KeyPadService getAndRegisterKeyPadService() {
  _removeRegistrationIfExists<KeyPadService>();
  final service = KeyPadService();
  locator.registerSingleton<KeyPadService>(service);
  return service;
}

ProductService getAndRegisterProductService(
    {String currentUnit = 'kg',
    String branchId = 'BID',
    String userId = 'UID'}) {
  _removeRegistrationIfExists<ProductService>();
  final service = MockProductService();
  when(service.currentUnit).thenReturn(currentUnit);
  when(service.branchId).thenReturn(branchId);
  when(service.userId).thenReturn(userId);
  when(service.product).thenReturn(productMock);
  locator.registerSingleton<ProductService>(service);
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
  when(service.read(key: 'userId')).thenAnswer((_) => true);
  locator.registerSingleton<LocalStorage>(service);
  return service;
}

void registerServices() {
  getAndRegisterApi();
  getAndRegisterNavigationService();
  getAndRegisterLocalStorage();
  getAndRegisterAppService();
  getAndRegisterProductService();
  getAndRegisterKeyPadService();
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
