// import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
// import 'dart:typed_data';
import 'package:flipper_services/FirebaseCrashlyticService.dart';
import 'package:flipper_routing/routes.logger.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flipper_services/abstractions/analytic.dart';
import 'package:flipper_services/abstractions/printer.dart';
import 'package:flipper_services/abstractions/sync.dart';
import 'package:flipper_services/abstractions/system_time.dart';
import 'package:flipper_services/billing_service.dart';
import 'package:flipper_services/blue_thooth_service.dart';
import 'package:flipper_services/firebase_analytics_service.dart';
import 'package:flipper_services/force_data_service.dart';
import 'package:flipper_services/in_app_review.dart';
import 'package:flipper_services/language_service.dart';
import 'package:flipper_services/login_service.dart';
// import 'package:flipper_services/login_service.dart';
import 'package:flipper_services/mobile_upload.dart';
// import 'package:flipper_services/pdf_api.dart';
import 'package:flipper_services/product_service.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_services/analytic_service.dart';
import 'package:flipper_services/remote_config_service.dart';
import 'package:flipper_services/cron_service.dart';
import 'package:flipper_services/setting_service.dart';
import 'package:flipper_services/share_implementation.dart';
import 'package:flipper_services/sync_api.dart';
import 'package:flipper_services/system_time_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
// import 'package:flutter_luban/flutter_luban.dart';
import 'package:injectable/injectable.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:flipper_models/models/models.dart';
import 'package:flipper_routing/routes.router.dart';
// import 'LiteApi.dart';
// import 'package:file_picker/file_picker.dart';
import 'abstractions/api.dart';
import 'abstractions/dynamic_link.dart';
import 'abstractions/location.dart';
import 'abstractions/platform.dart';
import 'abstractions/remote.dart';
import 'abstractions/share.dart';
import 'abstractions/storage.dart';
import 'abstractions/upload.dart';
import 'app_service.dart';
import 'country_service.dart';
import 'dynamic_link_service.dart';
import 'firestore_api.dart';
import 'keypad_service.dart';
import 'local_notification_service.dart';
import 'local_storage.dart';
import 'location_service.dart';
import 'package:universal_platform/universal_platform.dart';
// import 'package:couchbase_lite_dart/couchbase_lite_dart.dart';

// import 'package:flipper_models/models/models.dart';

final isWindows = UniversalPlatform.isWindows;

// UniversalPlatform.platform;

enum ApiProvider {
  Fake,
  Rest,
  Lite,
}
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
    if (UniversalPlatform.isAndroid ||
        UniversalPlatform.isWeb ||
        UniversalPlatform.isMacOS) {
      remote = RemoteConfigService();
    } else {
      remote = RemoteConfigWindows();
    }
    return remote;
  }

  @lazySingleton
  Firestore get firestore {
    late Firestore firestore;
    if (UniversalPlatform.isIOS ||
        UniversalPlatform.isAndroid ||
        UniversalPlatform.isMacOS) {
      firestore = FirestoreApi();
    } else {
      firestore = UnSupportedFirestoreApi();
    }
    return firestore;
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

  ///TODOcheck if code from LanguageService can work fully on windows
  @lazySingleton
  LanguageService get languageService;

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
  Api get apiService {
    late Api apiService;
    apiService = ObjectBoxApi();
    return apiService;
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

  @lazySingleton
  SyncApiInterface get syncApi {
    SyncApiInterface syncApi;
    switch (platform) {
      case "windows":
        syncApi = SyncApi();
        break;
      default:
        syncApi = SyncApi();
    }
    return syncApi;
  }

  @lazySingleton
  NavigationService get nav;
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
  LoginService get loginService;

  @lazySingleton
  AnalyticService get analytic;

  @lazySingleton
  ProductService get productService;

  @lazySingleton
  KeyPadService get keypadService;

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

