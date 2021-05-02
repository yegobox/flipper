// import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'dart:io';
import 'package:flipper_services/mobile_upload.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_services/share_implementation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
// import 'package:image_picker_platform_interface/src/types/picked_file/unsupported.dart';
import 'package:injectable/injectable.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:flipper_models/models/login.dart';
import 'package:flipper/routes.router.dart';
import 'LiteApi.dart';
import 'abstractions/api.dart';
import 'abstractions/dynamic_link.dart';
import 'abstractions/location.dart';
import 'abstractions/platform.dart';
import 'abstractions/share.dart';
import 'abstractions/storage.dart';
import 'abstractions/upload.dart';
import 'app_service.dart';
import 'dynamic_link_service.dart';
import 'flipper_firebase_auth.dart';
import 'package:couchbase_lite_dart/couchbase_lite_dart.dart';
import 'http_api.dart';
import 'local_storage.dart';
import 'location_service.dart';
import 'package:universal_platform/universal_platform.dart';

import 'product_service.dart';

final Database db = Database("main_01");
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
      upload = UnsupportedPlatformUpload();
    }
    return upload;
  }

  @lazySingleton
  Shareble get share {
    Shareble share;
    if (UniversalPlatform.isAndroid || UniversalPlatform.isIOS) {
      share = ShareImplementation();
    } else {
      share = UnSupportedShare();
    }
    return share;
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
  Api get apiService {
    Api apiService;
    if (UniversalPlatform.isWindows ||
        // UniversalPlatform.isAndroid ||
        UniversalPlatform.isMacOS) {
      apiService = LiteApi(database: db);
    } else {
      apiService = HttpApi();
    }
    return apiService;
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
}

class UnsupportedPlatformUpload implements UploadT {
  @override
  Future browsePictureFromGallery({required String productId}) async {
    print('no supported on this platform');
  }

  @override
  Future handleImage({required File image, required String productId}) async {
    print('no supported on this platform');
  }

  @override
  Future<bool> isInternetAvailable() async {
    print('no supported on this platform');
    return false;
  }

  @override
  Future takePicture({required String productId}) async {
    print('no supported on this platform');
  }

  @override
  Future upload(
      {required String storagePath,
      required String fileName,
      required String productId}) async {
    print('no supported on this platform');
  }
}

class UnSupportedShare implements Shareble {
  @override
  void share(String shareble) {
    // TODO: implement share
  }
}

class UnSupportedDynamicLink implements DynamicLink {
  @override
  Future<dynamic> createDynamicLink() async {
    return null; //a reson to not return UnimplementedError when a function could be called during widget rendering!
  }

  @override
  Future handleDynamicLink() {
    // TODO: implement handleDynamicLink
    throw UnimplementedError();
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
