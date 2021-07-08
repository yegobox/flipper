// import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
// import 'dart:typed_data';
import 'package:flipper_services/FirebaseCrashlyticService.dart';
import 'package:flipper_services/abstractions/analytic.dart';
import 'package:flipper_services/abstractions/printer.dart';
import 'package:flipper_services/blue_thooth_service.dart';
import 'package:flipper_services/firebase_analytics_service.dart';
import 'package:flipper_services/force_data_service.dart';
import 'package:flipper_services/mobile_upload.dart';
import 'package:flipper_services/pdf_api.dart';
import 'package:flipper_services/pdf_invoice_api.dart';
import 'package:flipper_services/product_service.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_services/remote_config_service.dart';
import 'package:flipper_services/report_service.dart';
import 'package:flipper_services/setting_service.dart';
import 'package:flipper_services/share_implementation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
// import 'package:flutter_luban/flutter_luban.dart';
import 'package:injectable/injectable.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:flipper_models/login.dart';
import 'package:flipper/routes.router.dart';
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
import 'dynamic_link_service.dart';
import 'firestore_api.dart';
import 'flipper_firebase_auth.dart';
import 'http_api.dart';
import 'keypad_service.dart';
import 'local_notification_service.dart';
import 'local_storage.dart';
import 'location_service.dart';
import 'package:universal_platform/universal_platform.dart';
// import 'package:couchbase_lite_dart/couchbase_lite_dart.dart';

import 'objectbox_api.dart';

// final Database db = Database("db");
// final dynamic db = {}; //fake db it is not going to be used on web anyway!
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
  Analytic get analyticService {
    late Analytic analyticService;
    if (UniversalPlatform.isAndroid) {
      analyticService = FirebaseAnalyticsService();
    } else {
      analyticService = UnSupportedAnalyticPlatform();
    }
    return analyticService;
  }

  @lazySingleton
  Api get apiService {
    late Api apiService;
    if (UniversalPlatform.isWindows ||
        UniversalPlatform.isAndroid ||
        UniversalPlatform.isMacOS) {
      // apiService = LiteApi(database: db); //lite app

      apiService = ObjectBoxApi(); //pro app
      // apiService = HttpApi(); //lite app
    } else {
      apiService = HttpApi();
    }
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

  // @lazySingleton
  // LoginViewModel get lView;

  @lazySingleton
  LoginStandard get flipperFire {
    LoginStandard service;
    switch (platform) {
      case "windows":
        service = WindowsFirebaseAuthenticationImplementation();
        break;
      default:
        service =
            FlipperFirebaseAuthenticationService(); //works on mobile and other device except windows
    }
    return service;
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
  ProductService get productService;

  @lazySingleton
  KeyPadService get keypadService;

  @lazySingleton
  SettingsService get settings;

  @lazySingleton
  ReportService get report;

  @lazySingleton
  PdfInvoiceApi get pdfInvoice;

  @lazySingleton
  PdfApi get pdfApi;

  @lazySingleton
  ForceDataEntryService get forcedataEntry;
}

class WindowsBlueToothPrinterService implements Printer {
  @override
  Future<bool> connect({required String mac}) async {
    // TODO: implement connect
    // throw UnimplementedError();
    return false;
  }

  @override
  Future<List?> getBluetooths() async {
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

class WindowsFirebaseAuthenticationImplementation implements LoginStandard {
  @override
  Future<bool> createAccountWithPhone(
      {required String phone, required BuildContext context}) async {
    // implement custom SMS provider to send OTP
    //  ProxyService.box.write(key: 'verificationId', value: 'mock');
    ProxyService.box.write(key: 'userPhone', value: phone);
    return true; //fake login
  }

  @override
  signInWithApple(
      {required String appleClientId, required String appleRedirectUri}) {
    //fake the login for now
  }

  @override
  signInWithGoogle() {
    // TODO: implement signInWithGoogle
    throw UnimplementedError();
  }

  @override
  confirmOtpForWeb({required String otp}) {
    // TODO: implement confirmOtpForWeb
    throw UnimplementedError();
  }

  @override
  Future<void> verifyWithOtp() async {
    String? phone = ProxyService.box.read(key: 'userPhone');
    // String otp = ProxyService.box.read(key: 'otp');
    Login login = await ProxyService.api.login(phone: phone!);

    ///call api to sync! start by syncing
    ///so that we cover the case when a user synced and deleted app
    ///and come again in this case the API will have sync!
    await ProxyService.api
        .authenticateWithOfflineDb(userId: login.id.toString());

    //then go startup logic
    ProxyService.nav.navigateTo(Routes.startUpView);
    ProxyService.box.write(key: 'userId', value: login.id.toString());
  }
}
