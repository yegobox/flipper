import 'dart:developer';

import 'package:flipper_models/isar_models.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:flipper_services/app_service.dart';
import 'package:flipper_services/locator.dart' as loc;
import 'package:flipper_services/proxy.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

mixin TokenLogin {
  Future<void> tokenLogin(String token) async {
    await FirebaseAuth.instance.signInWithCustomToken(token);
  }
}

class LoginViewModel extends FlipperBaseModel with TokenLogin {
  LoginViewModel();
  final appService = loc.getIt<AppService>();
  final _routerService = locator<RouterService>();
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

  get isProcessing => _isProceeding;
  Future<void> desktopLogin({
    required String pinCode,
  }) async {
    try {
      setIsprocessing(value: true);
      log("${pinCode}", name: "YUUUU");
      Pin? pin = await ProxyService.isar.getPin(pin: pinCode);

      ProxyService.box.writeBool(key: 'isAnonymous', value: true);
      log("${pin?.toJson().toString()}", name: "YUUUU");
      // Perform user login
      await ProxyService.isar.login(
        skipDefaultAppSetup: false,
        userPhone: pin!.phoneNumber,
      );

      // Clear and re-sign in with Firebase anonymously
      await FirebaseAuth.instance.signOut();

      log(ProxyService.box.uid(), name: 'tokenLogin');
      await tokenLogin(ProxyService.box.uid());

      // Check if a logged-in Firebase user exists
      final auth = FirebaseAuth.instance;
      if (auth.currentUser != null) {
        // Navigate based on the default app setting
        final defaultApp = ProxyService.box.getDefaultApp();
        if (defaultApp == "2") {
          _routerService.navigateTo(SocialHomeViewRoute());
        } else {
          openDrawer();
        }
      }
    } catch (error) {
      setIsprocessing(value: false);
      Sentry.captureException(error, stackTrace: StackTrace.current);
      throw error;
    }
  }

  void setIsprocessing({required bool value}) {
    _isProceeding = value;
    notifyListeners();
  }
}
