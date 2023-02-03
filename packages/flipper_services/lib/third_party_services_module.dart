import 'dart:developer';

import 'package:flipper_models/marketing.dart';
import 'package:flipper_models/remote_service.dart';
import 'package:flipper_models/tax_api.dart';
import 'package:flipper_models/rw_tax.dart';
import 'package:flipper_models/whatsapp.dart';
import 'package:flipper_services/FirebaseCrashlyticService.dart';
import 'package:flipper_services/abstractions/analytic.dart';
import 'package:flipper_services/abstractions/printer.dart';
import 'package:flipper_services/abstractions/system_time.dart';
import 'package:flipper_services/billing_service.dart';
import 'package:flipper_services/blue_thooth_service.dart';
import 'package:flipper_services/common.dart';
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
import 'package:flipper_services/share_implementation.dart';
import 'package:flipper_services/system_time_service.dart';
import 'package:injectable/injectable.dart';
import 'package:flipper_models/isar_models.dart';
import 'abstractions/dynamic_link.dart';
import 'abstractions/location.dart';
import 'abstractions/remote.dart';
import 'abstractions/share.dart';
import 'abstractions/storage.dart';
import 'abstractions/upload.dart';
import 'app_service.dart';
import 'country_service.dart';
import 'dynamic_link_service.dart';
import 'keypad_service.dart';
import 'local_notification_service.dart';
import 'local_storage.dart';
import 'location_service.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:flipper_models/isar_api.dart';

final isWindows = UniversalPlatform.isWindows;

final String platform = (!isWindows) ? 'mobile' : 'windows';

@module
abstract class ThirdPartyServicesModule {
  @lazySingleton
  UploadT get upload {
    UploadT upload;
    if (UniversalPlatform.isAndroid || UniversalPlatform.isIOS) {
      upload = MobileUpload();
    } else {
      upload = HttpUpload();
    }
    return upload;
  }

  @lazySingleton
  Shareble get share {
    Shareble share;

    share = ShareImplementation();

    return share;
  }

  @lazySingleton
  Review get review {
    Review crash;
    if (UniversalPlatform.isAndroid ||
        UniversalPlatform.isIOS ||
        UniversalPlatform.isMacOS) {
      crash = InAppReviewService();
    } else {
      crash = UnSupportedReview();
    }
    return crash;
  }

  @lazySingleton
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

  @lazySingleton
  DynamicLink get dynamicLink {
    DynamicLink dynamicLink;
    if (UniversalPlatform.isAndroid || UniversalPlatform.isIOS) {
      dynamicLink = DynamicLinkService();
    } else {
      dynamicLink = UnSupportedDynamicLink();
    }
    return dynamicLink;
  }

  @lazySingleton
  Remote get remote {
    late Remote remote;
    if (UniversalPlatform.isAndroid || UniversalPlatform.isMacOS) {
      remote = RemoteConfigService();
    } else {
      remote = RemoteConfigWindows();
    }
    return remote;
  }

  @lazySingleton
  Printer get printService {
    late Printer printService;
    if (
        // UniversalPlatform.isWindows ||
        UniversalPlatform.isAndroid || UniversalPlatform.isMacOS) {
      printService = BlueToothPrinterService();
    } else {
      printService = WindowsBlueToothPrinterService();
    }
    return printService;
  }

  @lazySingleton
  Analytic get appAnalytic {
    late Analytic appAnalytic;
    if (UniversalPlatform.isAndroid) {
      appAnalytic = FirebaseAnalyticsService();
    } else {
      appAnalytic = UnSupportedAnalyticPlatform();
    }
    return appAnalytic;
  }

  @lazySingleton
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

  @lazySingleton
  SystemTime get systemTime {
    late SystemTime systemTime;
    if (UniversalPlatform.isAndroid) {
      systemTime = SystemTimeService();
    } else {
      systemTime = UnSupportedSystemTime();
    }
    return systemTime;
  }

  @lazySingleton
  WhatsApp get whatsApp {
    late WhatsApp whatsApp;
    whatsApp = Marketing();
    return whatsApp;
  }

  @lazySingleton
  KeyPadService get keypadService;

  @preResolve
  Future<RemoteInterface> get remoteApi async {
    return await RemoteService().getInstance();
  }

  @preResolve
  Future<IsarApiInterface> get isarApi async {
    //first check if we are in testing mode.
    if (const bool.fromEnvironment('Test', defaultValue: false) == false) {
      log('in prod mode');
      return await IsarAPI().getInstance();
    } else {
      log("in test mode");
      late Isar isar;
      isar = await openTempIsar([
        OrderSchema,
        BusinessSchema,
        BranchSchema,
        OrderItemSchema,
        ProductSchema,
        VariantSchema,
        ProfileSchema,
        SubscriptionSchema,
        IPointSchema,
        StockSchema,
        FeatureSchema,
        VoucherSchema,
        PColorSchema,
        CategorySchema,
        IUnitSchema,
        SettingSchema,
        DiscountSchema,
        CustomerSchema,
        PinSchema,
        ReceiptSchema,
        DrawersSchema,
        ITenantSchema,
        PermissionSchema,
        CounterSchema,
        TokenSchema
      ]);
      return await IsarAPI().getInstance(iisar: isar);
    }
  }

  //TODOcheck if code from LanguageService can work fully on windows
  @lazySingleton
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

  @lazySingleton
  TaxApi get taxApiService {
    late TaxApi taxApiService;

    /// TODOwhen we support more country we can switch
    /// based on the business location.
    String? serverUrl = ProxyService.box.getServerUrl();
    taxApiService = RWTax(apihub: serverUrl ?? "https://turbo.yegobox.com");
    return taxApiService;
  }

  @lazySingleton
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

  @lazySingleton
  FlipperLocation get location {
    FlipperLocation location;
    switch (platform) {
      case "windows":
        location = WindowsLocationService();
        break;
      default:
        location = LocationService();
    }
    return location;
  }

  // @lazySingleton
  // NavigationService get nav;
  @lazySingleton
  LocalStorage get box {
    LocalStorage box;
    switch (platform) {
      case "windows":
        box = LocalStorageImpl();
        break;
      default:
        box = LocalStorageImpl();
    }
    return box;
  }

  @lazySingleton
  AppService get appService;

  @lazySingleton
  EventService get loginService;

  @lazySingleton
  ProductService get productService;

  @lazySingleton
  SettingsService get settings;

  @lazySingleton
  CronService get cron;

  // @lazySingleton
  // PdfInvoiceApi get pdfInvoice;

  // @lazySingleton
  // PdfApi get pdfApi;

  @lazySingleton
  ForceDataEntryService get forcedataEntry;

  @lazySingleton
  BillingService get billing;
}

class WindowsBlueToothPrinterService implements Printer {
  @override
  Future<bool> connect() async {
    // TODO: implement connect
    // throw UnimplementedError();
    return false;
  }

  @override
  Future<List?> blueTooths() async {
    return null;

    // TODO: implement getBluetooths
    // throw UnimplementedError();
  }

  @override
  Future sendToPrinter() async {
    // TODO: implement sendToPrinter
    // throw UnimplementedError();
  }
}

class WindowsLocationService implements FlipperLocation {
  @override
  Future<Map<String, String>> getLocation() async {
    return {
      "longitude": "11",
      "latitude": "11"
    }; //for windows it is not supported then please use the default
  }

  @override
  Future<bool> doWeHaveLocationPermission() async {
    return false; //so we can return default.
  }
}
