import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flipper_models/CoreSync.dart';
import 'package:flipper_models/Supabase.dart';
import 'package:flipper_models/SyncStrategy.dart';
import 'package:flipper_models/flipper_http_client.dart';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_models/marketing.dart';
import 'package:flipper_models/MockHttpClient.dart';
import 'package:flipper_models/RealmInterface.dart';
import 'package:flipper_models/tax_api.dart';
import 'package:flipper_models/rw_tax.dart';
import 'package:flipper_models/view_models/NotificationStream.dart';
import 'package:flipper_models/whatsapp.dart';
import 'package:flipper_services/Capella.dart';
import 'package:flipper_services/HttpApi.dart';
import 'package:flipper_services/PayStackService.dart';

import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as httP;
import 'package:flipper_services/FirebaseCrashlyticService.dart';
import 'package:flipper_services/abstractions/analytic.dart';
import 'package:flipper_services/abstractions/printer.dart';
import 'package:flipper_services/abstractions/system_time.dart';
import 'package:flipper_services/billing_service.dart';
import 'package:flipper_services/blue_thooth_service.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/event_interface.dart';
import 'package:flipper_services/firebase_analytics_service.dart';
import 'package:flipper_services/force_data_service.dart';
import 'package:flipper_services/in_app_review.dart';
import 'package:flipper_services/language_service.dart';
import 'package:flipper_services/event_service.dart';
import 'package:flipper_services/mobile_upload.dart';
import 'package:flipper_services/mocks/SharedPreferenceStorageMock.dart';
import 'package:flipper_services/product_service.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_services/remote_config_service.dart';
import 'package:flipper_services/cron_service.dart';
import 'package:flipper_services/sentry_service.dart';
import 'package:flipper_services/setting_service.dart';
import 'package:flipper_services/sharing_service.dart';
import 'package:flipper_services/status.dart';
import 'package:flipper_services/system_time_service.dart';
import 'package:injectable/injectable.dart';
import 'WindowLocationService.dart';
import 'WindowsBlueToothPrinterService.dart';
import 'abstractions/dynamic_link.dart';
import 'abstractions/location.dart';
import 'abstractions/remote.dart';
import 'abstractions/shareable.dart';
import 'abstractions/storage.dart';
import 'abstractions/upload.dart';
import 'app_service.dart';
import 'country_service.dart';
import 'dynamic_link_service.dart';
import 'firebase_messaging.dart';
import 'keypad_service.dart';
import 'local_notification_service.dart';
import 'local_storage.dart';
import 'location_service.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:flipper_services/DeviceIdService.dart' as dev;
import 'package:mockito/mockito.dart';

class MockFirebaseCrashlytics extends Mock implements FirebaseCrashlytics {}

@module
abstract class ServicesModule {
  @preResolve
  @LazySingleton()
  @Named('coresync')
  Future<RealmInterface> provideSyncInterface(LocalStorage box) async {
    return await CoreSync().configureLocal(
        useInMemory: bool.fromEnvironment('FLUTTER_TEST_ENV') == true,
        box: box);
  }

  @preResolve
  @Named('capella')
  @LazySingleton()
  Future<RealmInterface> capella(
    LocalStorage box,
  ) async {
    return await Capella().configureCapella(
      box: box,
      useInMemory: bool.fromEnvironment('FLUTTER_TEST_ENV') == true,
    );
  }

  // Add strategy registration
  @lazySingleton
  @Named('strategy')
  SyncStrategy provideStrategy(
    @Named('capella') RealmInterface capella,
    @Named('coresync') RealmInterface coresync,
  ) {
    return SyncStrategy(
      capella: capella as Capella,
      cloudSync: coresync as CoreSync,
    );
  }

  @preResolve
  @LazySingleton()
  Future<RealmInterface> localRealm(
    LocalStorage box,
  ) async {
    if (!kIsWeb) {
      return await CoreSync().configureLocal(
        box: box,
        useInMemory: bool.fromEnvironment('FLUTTER_TEST_ENV') == true,
      );
    }
    throw Exception("This is not supported on web");
  }

  @singleton
  FirebaseCrashlytics get crashlytics {
    if (bool.fromEnvironment('FLUTTER_TEST_ENV') == true) {
      // Return a mock instance during tests
      return MockFirebaseCrashlytics();
    } else {
      // Return the real instance in production
      return FirebaseCrashlytics.instance;
    }
  }

  @lazySingleton
  SupabaseInterface get supa {
    return SupabaseImpl();
  }

  @lazySingleton
  Crash get crash {
    Crash crash;
    if (UniversalPlatform.isAndroid ||
        UniversalPlatform.isIOS ||
        UniversalPlatform.isMacOS) {
      crash = CrashlitycsTalkerObserver(crashlytics: crashlytics);
    } else {
      crash = CrashlitycsTalkerObserverUnsupported();
    }
    return crash;
  }

  @singleton
  FirebaseFirestore get firestore => FirebaseFirestore.instance;

  @preResolve
  @LazySingleton()
  Future<LocalStorage> box() async {
    const isTest =
        const bool.fromEnvironment('FLUTTER_TEST_ENV', defaultValue: false);
    talker.warning("running in test env: $isTest");

    if (isTest) {
      return await SharedPreferenceStorageMock().initializePreferences();
    } else {
      return await SharedPreferenceStorage().initializePreferences();
    }
  }

  @LazySingleton()
  dev.Device get device {
    return dev.DeviceIdService();
  }

  @LazySingleton()
  NotificationStream get notie {
    return NotificationStream();
  }

  @LazySingleton()
  UploadT get upload {
    UploadT upload;
    if (UniversalPlatform.isAndroid || UniversalPlatform.isIOS) {
      upload = MobileUpload();
    } else {
      upload = HttpUpload();
    }
    return upload;
  }

  @LazySingleton()
  Shareable get share {
    Shareable share;

    share = SharingService();

    return share;
  }

  @LazySingleton()
  Review get review {
    Review review;
    if (UniversalPlatform.isAndroid ||
        UniversalPlatform.isIOS ||
        UniversalPlatform.isMacOS) {
      review = InAppReviewService();
    } else {
      review = UnSupportedReview();
    }
    return review;
  }

  @LazySingleton()
  Messaging get messaging {
    Messaging messaging;
    if (UniversalPlatform.isAndroid ||
        UniversalPlatform.isIOS ||
        UniversalPlatform.isMacOS) {
      messaging = FirebaseMessagingService();
    } else {
      messaging = FirebaseMessagingDesktop();
    }
    return messaging;
  }

  @LazySingleton()
  DynamicLink get dynamicLink {
    DynamicLink dynamicLink;
    if (UniversalPlatform.isAndroid || UniversalPlatform.isIOS) {
      dynamicLink = DynamicLinkService();
    } else {
      dynamicLink = UnSupportedDynamicLink();
    }
    return dynamicLink;
  }

  @LazySingleton()
  HttpClientInterface http() {
    late HttpClientInterface https;
    if ((const bool.fromEnvironment('FLUTTER_TEST_ENV') == true)) {
      https = MockHttpClient();
    } else {
      https = FlipperHttpClient(httP.Client());
    }
    return https;
  }

  @LazySingleton()
  PayStackServiceInterface payStack() {
    late PayStackServiceInterface payStack;
    if ((const bool.fromEnvironment('FLUTTER_TEST_ENV') == true)) {
      payStack = PayStackServiceMock();
    } else {
      payStack = PayStackService();
    }
    return payStack;
  }

  @LazySingleton()
  RealmViaHttp realmHttp() {
    late RealmViaHttp realmHttp;
    if ((const bool.fromEnvironment('FLUTTER_TEST_ENV') == true)) {
      realmHttp = RealmViaHttpServiceMock();
    } else {
      realmHttp = HttpApi();
    }
    return realmHttp;
  }

  // @preResolve
  @LazySingleton()
  Remote remote() {
    late Remote remote;
    if (UniversalPlatform.isAndroid) {
      remote = RemoteConfigService();
    } else {
      remote = RemoteConfigWindows();
    }
    return remote;
  }

  @LazySingleton()
  Printer get printService {
    late Printer printService;
    if (UniversalPlatform.isAndroid) {
      printService = BlueToothPrinterService();
    } else {
      printService = WindowsBlueToothPrinterService();
    }
    return printService;
  }

  @LazySingleton()
  Analytic get appAnalytic {
    late Analytic appAnalytic;
    if (UniversalPlatform.isAndroid) {
      appAnalytic = FirebaseAnalyticsService();
    } else {
      appAnalytic = UnSupportedAnalyticPlatform();
    }
    return appAnalytic;
  }

  @LazySingleton()
  Country get country {
    late Country country;
    if (UniversalPlatform.isAndroid ||
        UniversalPlatform.isIOS ||
        UniversalPlatform.isMacOS) {
      country = CountryService();
    } else {
      country = UnSupportedCountry();
    }
    return country;
  }

  @LazySingleton()
  SystemTime get systemTime {
    late SystemTime systemTime;
    if (UniversalPlatform.isAndroid) {
      systemTime = SystemTimeService();
    } else {
      systemTime = UnSupportedSystemTime();
    }
    return systemTime;
  }

  @LazySingleton()
  WhatsApp get whatsApp {
    late WhatsApp whatsApp;
    whatsApp = Marketing();
    return whatsApp;
  }

  @LazySingleton()
  KeyPadService get keypadService;

  @LazySingleton()
  Status get status {
    late Status status;
    if (isAndroid || isIos) {
      status = StatusAppBarForAndroidAndIos();
    } else {
      status = StatusAppBarForWindowsAndWeb();
    }
    return status;
  }

  @LazySingleton()
  EventInterface get event {
    final userId = ProxyService.box.getUserId()?.toString();
    return EventService(userId: userId ?? 'NULL');
  }

  @LazySingleton()
  SentryServiceInterface sentry() {
    return SentryService();
  }

  //TODOcheck if code from LanguageService can work fully on windows
  @LazySingleton()
  Language get languageService {
    late Language languageService;
    if (UniversalPlatform.isAndroid ||
        UniversalPlatform.isMacOS ||
        UniversalPlatform.isIOS) {
      languageService = LanguageService();
    } else {
      languageService = UnImplementedLanguage();
    }
    return languageService;
  }

  @LazySingleton()
  TaxApi get taxApiService {
    late TaxApi taxApiService;

    taxApiService = RWTax();
    return taxApiService;
  }

  @LazySingleton()
  LNotification get notification {
    late LNotification notificationService;
    if (UniversalPlatform.isAndroid ||
        UniversalPlatform.isMacOS ||
        UniversalPlatform.isIOS) {
      notificationService = LocalNotificationService();
    } else {
      notificationService = UnSupportedLocalNotification();
    }
    return notificationService;
  }

  @LazySingleton()
  FlipperLocation get location {
    FlipperLocation location;
    if (isWindows) {
      location = WindowsLocationService();
    } else {
      location = LocationService();
    }
    return location;
  }

  @LazySingleton()
  AppService appService() {
    return AppService();
  }

  @LazySingleton()
  ProductService productService() {
    return ProductService();
  }

  SettingsService get settingsService;

  @LazySingleton()
  CronService cron() {
    return CronService();
  }

  @LazySingleton()
  ForceDataEntryService forcedataEntry() {
    return ForceDataEntryService();
  }

  @LazySingleton()
  BillingService billing() {
    return BillingService();
  }
}
