import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:flipper_services/abstractions/location.dart';
import 'package:flipper_services/abstractions/remote.dart';
import 'package:flipper_services/billing_service.dart';
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
  MockSpec<BillingService>(returnNullOnMissingStub: true),
])
Api getAndRegisterApi() {
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

  when(service.getVariantByProductId(productId: anyNamed('productId')))
      .thenAnswer((_) => [variationMock]);

  when(service.update(data: anyNamed('data'), endPoint: anyNamed('endPoint')))
      .thenAnswer((_) => Future.value(1));

  when(service.getLocalOrOnlineBusiness(userId: '300'))
      .thenAnswer((_) async => [businessMockData]);

  when(service.addVariant(
          data: [variationMock], retailPrice: 0.0, supplyPrice: 0.0))
      .thenAnswer((_) async => 200);
  when(service.getCustomProductVariant())
      .thenAnswer((_) async => variationMock);

  when(service.orders()).thenAnswer((_) async => [orderMock!]);

  when(service.stockByVariantId(variantId: variationMock.id))
      .thenAnswer((_) async => stockMock);

  when(service.update(
          data: variationMock.toJson(), endPoint: anyNamed('endPoint')))
      .thenAnswer((_) async => 200);

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

  when(service.consumeVoucher(voucherCode: 1)).thenAnswer(
    (_) async => Voucher(
      id: DateTime.now().millisecondsSinceEpoch,
      value: 1,
      interval: 1,
      used: false,
      createdAt: 111,
      usedAt: 111,
      descriptor: 'Daily',
    ),
  );

  when(service.createOrder(
          customAmount: 0.0, variation: variationMock, price: 0.0, quantity: 1))
      .thenAnswer((_) async => Future.value(orderMock));

  locator.registerSingleton<Api>(service);
  return service;
}

BillingService getAndRegisterBillingService() {
  _removeRegistrationIfExists<BillingService>();
  final service = MockBillingService();
  locator.registerSingleton<BillingService>(service);
  when(service.useVoucher(userId: 1, voucher: 1)).thenAnswer(
    (_) async => Future.value(
      Voucher(
        id: DateTime.now().millisecondsSinceEpoch,
        value: 1,
        interval: 1,
        used: false,
        createdAt: 111,
        usedAt: 111,
        descriptor: 'Daily',
      ),
    ),
  );

  when(service.useVoucher(userId: 1, voucher: 2))
      .thenThrow(VoucherException(term: 'Voucher not found'));

  when(service.addPoints(userId: 1, points: 2))
      .thenThrow(VoucherException(term: 'Voucher not found'));

  when(service.addPoints(
          points: anyNamed('points'), userId: anyNamed('userId')))
      .thenAnswer((_) => Points(
            id: DateTime.now().millisecondsSinceEpoch,
            value: 2,
            userId: 1,
          ));
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

ProductService getAndRegisterProductService() {
  _removeRegistrationIfExists<ProductService>();
  final service = MockProductService();
  when(service.currentUnit).thenReturn('kg');
  when(service.branchId).thenReturn(10);
  when(service.userId).thenReturn("300");
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
  locator.unregister<Api>();
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
