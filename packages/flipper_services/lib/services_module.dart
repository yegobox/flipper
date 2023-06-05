import 'dart:developer';

import 'package:flipper_models/marketing.dart';
import 'package:flipper_models/remote_service.dart';
import 'package:flipper_models/tax_api.dart';
import 'package:flipper_models/rw_tax.dart';
import 'package:flipper_models/whatsapp.dart';
import 'package:flipper_services/FirebaseCrashlyticService.dart';
import 'package:flipper_services/abstractions/analytic.dart';
import 'package:flipper_services/abstractions/printer.dart';
import 'package:flipper_models/sync.dart';
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
import 'package:flipper_services/product_service.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_services/remote_config_service.dart';
import 'package:flipper_services/cron_service.dart';
import 'package:flipper_services/setting_service.dart';
import 'package:flipper_services/sharing_service.dart';
import 'package:flipper_services/status.dart';
import 'package:flipper_services/system_time_service.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:flipper_models/isar_models.dart';
import 'abstractions/dynamic_link.dart';
import 'abstractions/location.dart';
import 'abstractions/remote.dart';
import 'abstractions/shareable.dart';
import 'abstractions/storage.dart';
import 'abstractions/upload.dart';
import 'abstracts.dart';
import 'app_service.dart';
import 'country_service.dart';
import 'dynamic_link_service.dart';
import 'firebase_messaging.dart';
import 'keypad_service.dart';
import 'local_notification_service.dart';
import 'local_storage.dart';
import 'location_service.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:flipper_models/isar_api.dart';

@module
abstract class ServicesModule {
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
  Crash get crash {
    Crash crash;
    if (UniversalPlatform.isAndroid ||
        UniversalPlatform.isIOS ||
        UniversalPlatform.isMacOS) {
      crash = FirebaseCrashlyticService();
    } else {
      crash = FirebaseCrashlyticServiceUnsupportedDevice();
    }
    return crash;
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
  Remote get remote {
    late Remote remote;
    if (UniversalPlatform.isAndroid || UniversalPlatform.isMacOS) {
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

  @preResolve
  Future<RemoteInterface> get remoteApi async {
    return await RemoteService().getInstance();
  }

  // @LazySingleton()
  @preResolve
  Future<LocalStorage>  get box async {
    //late LocalStorage box;
    log("loading a box");
    return await SharedPreferenceStorage().initializePreferences();
    //box = LocalStorageImpl();
    // return box;
  }

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
  EventInterface get event => EventService();

  @preResolve
  @LazySingleton()
  Future<IsarApiInterface> isarApi() async {
    //first check if we are in testing mode.
    if ((const bool.fromEnvironment('Test', defaultValue: false) == false) &&
        !kDebugMode) {
      log('in prod mode');
      return await IsarAPI().getInstance();
    } else {
      log("in test mode");
      // late Isar isar;
      // isar = await openTempIsar([
      //   OrderSchema,
      //   BusinessSchema,
      //   BranchSchema,
      //   OrderItemSchema,
      //   ProductSchema,
      //   VariantSchema,
      //   ProfileSchema,
      //   SubscriptionSchema,
      //   IPointSchema,
      //   StockSchema,
      //   FeatureSchema,
      //   VoucherSchema,
      //   PColorSchema,
      //   CategorySchema,
      //   IUnitSchema,
      //   SettingSchema,
      //   DiscountSchema,
      //   CustomerSchema,
      //   PinSchema,
      //   ReceiptSchema,
      //   DrawersSchema,
      //   ITenantSchema,
      //   PermissionSchema,
      //   CounterSchema,
      //   TokenSchema
      // ]);

      /// removed iisar: isar bellow will add it back when we have a test relying on isar database
      // return await FakeApi().getInstance();
      return await IsarAPI().getInstance();
    }
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

    /// TODOwhen we support more country we can switch
    /// based on the business location.
    String? serverUrl = ProxyService.box.getServerUrl();
    taxApiService = RWTax(apihub: serverUrl ?? "https://turbo.yegobox.com");
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
  SyncApiInterface sync() {
    return SyncApiInterface.create();
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
