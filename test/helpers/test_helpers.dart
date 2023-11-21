import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flipper_models/isar_api.dart';

import 'package:flipper_services/abstractions/location.dart';
import 'package:flipper_services/abstractions/remote.dart';
import 'package:flipper_services/billing_service.dart';
import 'package:flipper_models/isar_models.dart';
import 'package:flipper_services/abstractions/storage.dart';
import 'package:flipper_services/app_service.dart';
import 'package:flipper_services/keypad_service.dart';
import 'package:flipper_services/language_service.dart';
import 'package:flipper_services/product_service.dart';
import 'package:flipper_services/setting_service.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
// import '../view_models/common.dart';
import 'test_helpers.mocks.dart';
import 'package:flipper_services/locator.dart';

@GenerateNiceMocks([
  // MockSpec<Language>(),
  MockSpec<LanguageService>(),
  MockSpec<Remote>(),
  MockSpec<FirebaseMessaging>(),
  MockSpec<ProductService>(),
  MockSpec<KeyPadService>(),
  MockSpec<SettingsService>(),
  MockSpec<LocalStorage>(),
  MockSpec<AppService>(),
  MockSpec<FlipperLocation>(),
  MockSpec<BillingService>(),
])
BillingService getAndRegisterBillingService() {
  _removeRegistrationIfExists<BillingService>();
  final service = MockBillingService();
  getIt.registerSingleton<BillingService>(service);

  when(service.useVoucher(userId: 1, voucher: 2))
      .thenThrow(VoucherException(term: 'Voucher not found'));

  when(service.addPoints(userId: 1, points: 2))
      .thenThrow(VoucherException(term: 'Voucher not found'));

  return service;
}

// Future<IsarApiInterface> getAndRegisterApiService() async {
//   _removeRegistrationIfExists<IsarApiInterface>();
//   Isar isar = await openTempIsar([
//     TransactionSchema,
//     BusinessSchema,
//     BranchSchema,
//     TransactionItemSchema,
//     ProductSchema,
//     VariantSchema,
//     ProfileSchema,
//     SubscriptionSchema,
//     PointssSchema,
//     StockSchema,
//     FeatureSchema,
//     VoucherSchema,
//     PColorSchema,
//     CategorySchema,
//     IUnitSchema,
//     SettingSchema,
//     DiscountSchema,
//     CustomerSchema,
//     PinSchema,
//     ReceiptSchema,
//   ]);

//   final service = await IsarAPI().getInstance(iisar: isar);
//   getIt.registerSingleton<IsarApiInterface>(service);

//   return service;
// }

AppService getAndRegisterAppService(
    {bool hasLoggedInUser = false,
    int branchId = 11,
    String userid = 'UID',
    int businessId = 10}) {
  _removeRegistrationIfExists<AppService>();
  final service = MockAppService();
  // when(service.hasLoggedInUser).thenReturn(hasLoggedInUser);
  when(service.branchId).thenReturn(branchId);
  when(service.businessId).thenReturn(businessId);
  // when(service.currentColor).thenReturn('#ee5253');
  getIt.registerSingleton<AppService>(service);

  return service;
}

KeyPadService getAndRegisterKeyPadService() {
  _removeRegistrationIfExists<KeyPadService>();
  final service = KeyPadService();
  getIt.registerSingleton<KeyPadService>(service);
  return service;
}

ProductService getAndRegisterProductService() {
  _removeRegistrationIfExists<ProductService>();
  final service = MockProductService();
  when(service.currentUnit).thenReturn('kg');
  when(service.branchId).thenReturn(10);
  when(service.userId).thenReturn(300);
  getIt.registerSingleton<ProductService>(service);
  return service;
}

MockFirebaseMessaging getFirebaseMessaging() {
  _removeRegistrationIfExists<FirebaseMessaging>();
  final service = MockFirebaseMessaging();
  getIt.registerSingleton<FirebaseMessaging>(service);
  when(service.getToken()).thenAnswer((_) async => 'token');

  return service;
}

MockFlipperLocation getAndRegisterLocationService() {
  _removeRegistrationIfExists<FlipperLocation>();
  final service = MockFlipperLocation();
  // when(service.getLocation())
  //     .thenAnswer((_) async => {'longitude': "1.1", 'latitude': "1.1"});
  when(service.hasLocationPermission()).thenAnswer((_) async => false);
  getIt.registerSingleton<FlipperLocation>(service);
  return service;
}

LanguageService getAndRegisterLanguageService() {
  _removeRegistrationIfExists<LanguageService>();
  final service = LanguageService();
  getIt.registerSingleton<LanguageService>(service);
  return service;
}

MockRemote getAndRegisterRemoteConfig() {
  _removeRegistrationIfExists<Remote>();
  final service = MockRemote();
  //some mocking here
  when(service.isSubmitDeviceTokenEnabled()).thenAnswer((_) => false);
  when(service.isChatAvailable()).thenAnswer((_) => false);
  getIt.registerSingleton<Remote>(service);
  return service;
}

MockSettingsService getAndRegisterSettingsService() {
  _removeRegistrationIfExists<SettingsService>();
  final service = MockSettingsService();
  //some mocking here
  when(service.updateSettings(map: anyNamed("map")))
      .thenAnswer((realInvocation) => Future<bool>.value(true));
  getIt.registerSingleton<SettingsService>(service);
  return service;
}

MockLocalStorage getAndRegisterLocalStorage() {
  _removeRegistrationIfExists<LocalStorage>();
  final service = MockLocalStorage();
  when(service.getUserId()).thenAnswer((_) => 300);
  when(service.getBusinessId()).thenAnswer((_) => 10);
  when(service.getBranchId()).thenAnswer((_) => 11);
  when(service.readString(key: 'bearerToken')).thenAnswer((_) => 'TOKEN');
  when(service.readInt(key: 'branchId')).thenAnswer((_) => 11);
  when(service.readString(key: 'referralCode')).thenAnswer((_) => "11");
  when(service.readInt(key: 'businessId')).thenAnswer((_) => 10);

  // when(service.write(key: pageKey, value: 'key')).thenAnswer((_) => true);
  // when(service.write(key: 'branchId', value: anyNamed("value")))
  //     .thenAnswer((_) => true);
  // when(service.write(key: 'currentTransactionId', value: anyNamed("value")))
  //     .thenAnswer((_) => true);
  // when(service.write(key: 'businessId', value: anyNamed("value")))
  //     .thenAnswer((_) => true);
  // when(service.write(key: 'businessUrl', value: anyNamed("value")))
  //     .thenAnswer((_) => true);
  // when(service.write(key: 'userName', value: anyNamed("value")))
  //     .thenAnswer((_) => true);

  getIt.registerSingleton<LocalStorage>(service);
  return service;
}

void registerServices() {
  getAndRegisterLocationService();
  getAndRegisterSettingsService();
  getAndRegisterLocalStorage();
  getAndRegisterAppService();
  getAndRegisterProductService();
  getAndRegisterKeyPadService();
  getFirebaseMessaging();
  getAndRegisterRemoteConfig();
  getAndRegisterLanguageService();
  getAndRegisterBillingService();
  // getAndRegisterApiService();
}

void unregisterServices() {
  getIt.unregister<SettingsService>();
  getIt.unregister<LocalStorage>();
  getIt.unregister<LanguageService>();
  getIt.unregister<BillingService>();
  getIt.unregister<IsarApiInterface>();
}

void _removeRegistrationIfExists<T extends Object>() {
  if (getIt.isRegistered<T>()) {
    getIt.unregister<T>();
  }
}
