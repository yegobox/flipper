import 'package:flipper_models/helperModels/pin.dart';
import 'package:flipper_models/realm_model_export.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:flipper_services/Miscellaneous.dart';
import 'package:flipper_services/locator.dart';
import 'package:flipper_services/proxy.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flipper_services/locator.dart' as loc;

import 'package:flipper_services/app_service.dart';
import 'dart:async';

import 'package:talker_flutter/talker_flutter.dart';

mixin TokenLogin {
  Future<void> tokenLogin(String token) async {
    await FirebaseAuth.instance.signInWithCustomToken(token);
  }
}

class LoginViewModel extends FlipperBaseModel
    with TokenLogin, CoreMiscellaneous {
  final appService = loc.getIt<AppService>();
  LoginViewModel();

  bool loginStart = false;
  bool otpStart = false;

  String? phoneNumber;
  void setPhoneNumber({required String phone}) {
    phoneNumber = phone;
  }

  String dialCode = '+250';
  void setCountryIso({dynamic iso}) {
    dialCode = (iso != null ? iso.dialCode : '+250')!;
  }

  void setOtp({required String ot}) {
    otpStart = true;
    notifyListeners();
    ProxyService.box.writeString(key: 'otp', value: ot);
  }

  bool _isProceeding = false;
  final talker = TalkerFlutter.init();
  get isProcessing => _isProceeding;
  Future<void> desktopLogin({required String pinCode}) async {
    ProxyService.box.remove(key: 'authComplete');
    logOut();
    try {
      setIsprocessing(value: true);
      if (ProxyService.realm.realm == null) {
        await ProxyService.realm.configure(
            useInMemoryDb: false,
            localRealm: ProxyService.local.localRealm,
            businessId: ProxyService.box.getBusinessId(),
            encryptionKey: ProxyService.box.encryptionKey(),
            branchId: ProxyService.box.getBranchId(),
            userId: ProxyService.box.getUserId());
      }

      IPin? pin = await ProxyService.realm.getPin(pin: pinCode);
      if (pin == null) {
        throw PinError(term: "Not found");
      }

      ProxyService.box.writeBool(key: 'isAnonymous', value: true);
      talker.info("${pin.toJson().toString()}");

      // Sign out from Firebase before attempting to log in
      await FirebaseAuth.instance.signOut();

      // Perform user login with ProxyService
      await ProxyService.local.login(
        skipDefaultAppSetup: false,
        userPhone: pin.phoneNumber,
      );
      await appService.appInit();

      // Get the UID after login
      String uid = ProxyService.box.uid();
      talker.info("tokenLogin:${uid}");

      // Attempt to sign in with the custom token
      try {
        await tokenLogin(uid);
      } catch (tokenError) {
        talker.error("Error during token login: $tokenError");
        // Handle token login failure (e.g., retry or alternative auth method)
      }

      // Check if a logged-in Firebase user exists
      final auth = FirebaseAuth.instance;
      if (auth.currentUser != null) {
        final defaultApp = ProxyService.box.getDefaultApp();
        await appService.appInit();
        if (defaultApp == "2") {
          if (!areDependenciesInitialized) {
            await initDependencies();
          }
          final _routerService = locator<RouterService>();
          _routerService.navigateTo(SocialHomeViewRoute());
        } else if (ProxyService.realm.isDrawerOpen(
            cashierId: ProxyService.box.getUserId()!,
            branchId: ProxyService.box.getBranchId()!)) {
          ProxyService.forceDateEntry.dataBootstrapper();
          if (ProxyService.box.getDefaultApp() == 2) {
            locator<RouterService>().navigateTo(SocialHomeViewRoute());
          } else {
            /// the appInit() trigger the auth flow before navigating to the app
            locator<RouterService>().navigateTo(FlipperAppRoute());
          }
        } else {
          openDrawer();
        }
      } else {
        await FirebaseAuth.instance.signOut();
        throw UnknownError(term: "Failed to authenticate with Firebase");
      }
    } on LoginChoicesException {
      locator<RouterService>().navigateTo(LoginChoicesRoute());
    } catch (error, s) {
      talker.error("Login error: $error");
      talker.error("Login trace: $s");
      talker.info(s);
      setIsprocessing(value: false);
      await Sentry.captureException(error, stackTrace: s);
      rethrow;
    } finally {
      setIsprocessing(value: false);
    }
  }

  void setIsprocessing({required bool value}) {
    _isProceeding = value;
    notifyListeners();
  }
}
