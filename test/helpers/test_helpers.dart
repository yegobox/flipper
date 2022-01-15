import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:flipper_services/abstractions/location.dart';
import 'package:flipper_services/abstractions/remote.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_models/models/models.dart';
import 'package:flipper_services/abstractions/api.dart';
import 'package:flipper_services/abstractions/storage.dart';
import 'package:flipper_services/app_service.dart';
import 'package:flipper_services/keypad_service.dart';
import 'package:flipper_services/language_service.dart';
import 'package:flipper_services/product_service.dart';
import 'package:flipper_services/setting_service.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:stacked_services/stacked_services.dart';
import '../view_models/startup_viewmodel_test.dart';
import 'test_helpers.mocks.dart';
import 'package:flipper_services/locator.dart';

@GenerateMocks([], customMocks: [
  MockSpec<Api>(returnNullOnMissingStub: true),
  MockSpec<Language>(returnNullOnMissingStub: true),
  MockSpec<LanguageService>(returnNullOnMissingStub: true),
  MockSpec<Remote>(returnNullOnMissingStub: true),
  MockSpec<FirebaseMessaging>(returnNullOnMissingStub: true),
  MockSpec<ProductService>(returnNullOnMissingStub: true),
  MockSpec<KeyPadService>(returnNullOnMissingStub: true),
  MockSpec<SettingsService>(returnNullOnMissingStub: true),
  MockSpec<LocalStorage>(returnNullOnMissingStub: true),
  MockSpec<AppService>(returnNullOnMissingStub: true),
  MockSpec<FlipperLocation>(returnNullOnMissingStub: true),
  MockSpec<NavigationService>(returnNullOnMissingStub: true),
])
Api getAndRegisterApi(
    {bool hasLoggedInUser = false,
    List<BusinessSync>? businesses,
    Map? data,
    String? uri,
    List<VariantSync>? variations}) {
  _removeRegistrationIfExists<Api>();
  final service = MockApi();
  when(service.login()).thenAnswer(
    (_) async => SyncF(
      id: 1,
      phoneNumber: '0783054870',
      token: 't',
      channels: [],
    ),
  );

  when(service.getLocalOrOnlineBusiness(userId: '300'))
      .thenAnswer((_) async => [businessMockData]);
  when(service.addVariant(data: variations, retailPrice: 0.0, supplyPrice: 0.0))
      .thenAnswer((_) async => 200);
  when(service.getCustomProductVariant())
      .thenAnswer((_) async => variationMock);
  when(service.createOrder(
          customAmount: 0.0, variation: variationMock, price: 0.0, quantity: 1))
      .thenAnswer((_) async => Future.value(orderMock));
  when(service.orders()).thenAnswer((_) async => [orderMock!]);
  when(service.stockByVariantId(variantId: variationMock.id))
      .thenAnswer((_) async => stockMock);
  if (data != null) {
    when(service.update(data: data, endPoint: uri))
        .thenAnswer((_) async => 200);
  }
  when(service.branches(businessId: anyNamed('businessId')))
      .thenAnswer((_) async => [branchMock]);
  when(service.create(data: anyNamed('data'), endPoint: 'category'))
      .thenAnswer((realInvocation) async => 200);
  when(service.create(data: anyNamed('data'), endPoint: 'color'))
      .thenAnswer((_) async => 200);

  when(service.addUnits(data: anyNamed('data'))).thenAnswer((_) async => 200);
  when(service.createProduct(product: anyNamed('product')))
      .thenAnswer((_) async => customProductMock);
  when(service.signup(business: anyNamed('business')))
      .thenAnswer((_) async => 200);
  locator.registerSingleton<Api>(service);
  return service;
}

AppService getAndRegisterAppService(
    {bool hasLoggedInUser = false,
    int branchId = 11,
    String userid = 'UID',
    int businessId = 10}) {
  _removeRegistrationIfExists<AppService>();
  final service = MockAppService();
  when(service.hasLoggedInUser).thenReturn(hasLoggedInUser);
  when(service.branchId).thenReturn(branchId);
  when(service.userid).thenReturn(userid);
  when(service.businessId).thenReturn(businessId);
  when(service.currentColor).thenReturn('#ee5253');
  when(service.isLoggedIn()).thenAnswer((realInvocation) => hasLoggedInUser);
  locator.registerSingleton<AppService>(service);

  return service;
}

KeyPadService getAndRegisterKeyPadServiceUnmocked() {
  _removeRegistrationIfExists<KeyPadService>();
  final service = KeyPadService();
  locator.registerSingleton<KeyPadService>(service);
  return service;
}

KeyPadService getAndRegisterKeyPadService() {
  final service = MockKeyPadService();
  when(service.order).thenReturn(orderMock);

  return service;
}

ProductService getAndRegisterProductService(
    {String currentUnit = 'kg', int branchId = 11, String userId = 'UID'}) {
  _removeRegistrationIfExists<ProductService>();
  final service = MockProductService();
  when(service.currentUnit).thenReturn(currentUnit);
  when(service.branchId).thenReturn(branchId);
  when(service.userId).thenReturn(userId);
  when(service.product).thenReturn(productMock);
  locator.registerSingleton<ProductService>(service);
  return service;
}

MockFirebaseMessaging getFirebaseMessaging() {
  _removeRegistrationIfExists<FirebaseMessaging>();
  final service = MockFirebaseMessaging();
  locator.registerSingleton<FirebaseMessaging>(service);
  when(service.getToken()).thenAnswer((_) async => 'token');

  return service;
}

NavigationService getAndRegisterNavigationService() {
  _removeRegistrationIfExists<NavigationService>();
  final service = MockNavigationService();
  locator.registerSingleton<NavigationService>(service);
  return service;
}

MockFlipperLocation getAndRegisterLocationService() {
  _removeRegistrationIfExists<FlipperLocation>();
  final service = MockFlipperLocation();
  when(service.getLocation())
      .thenAnswer((_) async => {'longitude': "1.1", 'latitude': "1.1"});
  when(service.doWeHaveLocationPermission()).thenAnswer((_) async => false);
  locator.registerSingleton<FlipperLocation>(service);
  return service;
}

MockLanguage getAndRegisterLanguageService() {
  _removeRegistrationIfExists<Language>();
  final service = MockLanguage();
  locator.registerSingleton<Language>(service);
  return service;
}

MockLanguageService getAndRegisterLanguageServiceMock() {
  _removeRegistrationIfExists<LanguageService>();
  final service = MockLanguageService();
  locator.registerSingleton<LanguageService>(service);
  return service;
}

MockRemote getAndRegisterRemoteConfig() {
  _removeRegistrationIfExists<Remote>();
  final service = MockRemote();
  //some mocking here
  when(service.isSubmitDeviceTokenEnabled()).thenAnswer((_) => false);
  when(service.isChatAvailable()).thenAnswer((_) => false);
  locator.registerSingleton<Remote>(service);
  return service;
}

MockSettingsService getAndRegisterSettingsService() {
  _removeRegistrationIfExists<SettingsService>();
  final service = MockSettingsService();
  //some mocking here
  when(service.updateSettings(map: anyNamed("map")))
      .thenAnswer((realInvocation) => Future<bool>.value(true));
  locator.registerSingleton<SettingsService>(service);
  return service;
}

MockLocalStorage getAndRegisterLocalStorage() {
  _removeRegistrationIfExists<LocalStorage>();
  final service = MockLocalStorage();
  when(service.getUserId()).thenAnswer((_) => '300');
  when(service.getBusinessId()).thenAnswer((_) => 10);
  when(service.getBranchId()).thenAnswer((_) => 11);
  //TODOrepace TOKEN   here
  when(service.read(key: 'bearerToken')).thenAnswer((_) => 'TOKEN');
  when(service.read(key: 'branchId')).thenAnswer((_) => 11);
  when(service.read(key: 'referralCode')).thenAnswer((_) => "11");
  when(service.read(key: 'businessId')).thenAnswer((_) => 10);
  when(service.read(key: pageKey)).thenAnswer((_) => 'XXX');
  when(service.write(key: pageKey, value: 'key')).thenAnswer((_) => true);
  when(service.write(key: 'branchId', value: anyNamed("value")))
      .thenAnswer((_) => true);
  when(service.write(key: 'businessId', value: anyNamed("value")))
      .thenAnswer((_) => true);
  when(service.write(key: 'businessUrl', value: anyNamed("value")))
      .thenAnswer((_) => true);
  when(service.write(key: 'userName', value: anyNamed("value")))
      .thenAnswer((_) => true);

  locator.registerSingleton<LocalStorage>(service);
  return service;
}

void registerServices() {
  getAndRegisterApi();
  getAndRegisterLocationService();
  getAndRegisterNavigationService();
  getAndRegisterSettingsService();
  getAndRegisterLocalStorage();
  getAndRegisterAppService();
  getAndRegisterProductService();
  getAndRegisterKeyPadServiceUnmocked();
  getAndRegisterKeyPadService();
  getFirebaseMessaging();
  getAndRegisterRemoteConfig();
  getAndRegisterLanguageService();
  getAndRegisterLanguageServiceMock();
}

void unregisterServices() {
  locator.unregister<Api>();
  locator.unregister<Language>();
  locator.unregister<NavigationService>();
  locator.unregister<SettingsService>();
  locator.unregister<LocalStorage>();
  locator.unregister<LanguageService>();
}

void _removeRegistrationIfExists<T extends Object>() {
  if (locator.isRegistered<T>()) {
    locator.unregister<T>();
  }
}
