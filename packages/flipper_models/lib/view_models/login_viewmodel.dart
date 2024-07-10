import 'dart:developer';

import 'package:flipper_models/helperModels/pin.dart';
import 'package:flipper_models/realm_model_export.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:flipper_services/locator.dart';
import 'package:flipper_services/proxy.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

import 'package:talker_flutter/talker_flutter.dart';

mixin TokenLogin {
  Future<void> tokenLogin(String token) async {
    await FirebaseAuth.instance.signInWithCustomToken(token);
  }
}

class LoginViewModel extends FlipperBaseModel with TokenLogin {
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
    ProxyService.realm.logOut();
    try {
      setIsprocessing(value: true);
      if (ProxyService.realm.realm == null) {
        await ProxyService.realm.configure(useInMemoryDb: false);
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

      // Get the UID after login
      String uid = ProxyService.box.uid();
      log(uid, name: 'tokenLogin');

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
        if (defaultApp == "2") {
          if (!areDependenciesInitialized) {
            await initDependencies();
          }
          final _routerService = locator<RouterService>();
          _routerService.navigateTo(SocialHomeViewRoute());
        } else {
          openDrawer();
        }
      } else {
        await FirebaseAuth.instance.signOut();
        throw Exception("Failed to authenticate with Firebase");
      }
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
