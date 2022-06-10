import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:flipper_services/abstractions/location.dart';
import 'package:flipper_services/abstractions/remote.dart';
import 'package:flipper_services/billing_service.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_models/isar_models.dart';
import 'package:flipper_services/abstractions/storage.dart';
import 'package:flipper_services/app_service.dart';
import 'package:flipper_services/keypad_service.dart';
import 'package:flipper_services/language_service.dart';
import 'package:flipper_services/product_service.dart';
import 'package:flipper_services/setting_service.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'test_helpers.mocks.dart';
import 'package:flipper_services/locator.dart';

@GenerateMocks([], customMocks: [
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
  MockSpec<BillingService>(returnNullOnMissingStub: true),
])
BillingService getAndRegisterBillingService() {
  _removeRegistrationIfExists<BillingService>();
  final service = MockBillingService();
  locator.registerSingleton<BillingService>(service);

  when(service.useVoucher(userId: 1, voucher: 2))
      .thenThrow(VoucherException(term: 'Voucher not found'));

  when(service.addPoints(userId: 1, points: 2))
      .thenThrow(VoucherException(term: 'Voucher not found'));

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

  return service;
}

ProductService getAndRegisterProductService() {
  _removeRegistrationIfExists<ProductService>();
  final service = MockProductService();
  when(service.currentUnit).thenReturn('kg');
  when(service.branchId).thenReturn(10);
  when(service.userId).thenReturn("300");
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
  getAndRegisterLocationService();
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
  getAndRegisterBillingService();
}

void unregisterServices() {
  locator.unregister<Language>();
  locator.unregister<SettingsService>();
  locator.unregister<LocalStorage>();
  locator.unregister<LanguageService>();
  locator.unregister<BillingService>();
}

void _removeRegistrationIfExists<T extends Object>() {
  if (locator.isRegistered<T>()) {
    locator.unregister<T>();
  }
}
