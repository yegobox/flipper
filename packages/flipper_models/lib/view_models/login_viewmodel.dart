import 'package:flipper_models/helperModels/pin.dart';
import 'package:flipper_models/realm_model_export.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:flipper_services/Miscellaneous.dart';
import 'package:flipper_services/proxy.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:realm/realm.dart';
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

      IPin? pin = await ProxyService.local
          .getPin(pinString: pinCode, flipperHttpClient: ProxyService.http);
      if (pin == null) {
        throw PinError(term: "Not found");
      }

      ProxyService.box.writeBool(key: 'isAnonymous', value: true);

      // Sign out from Firebase before attempting to log in
      // await FirebaseAuth.instance.signOut();
      final thePin = Pin(ObjectId(),
          userId: pin.userId,
          pin: pin.pin,
          branchId: pin.branchId,
          businessId: pin.businessId,
          ownerName: pin.ownerName,
          tokenUid: pin.tokenUid,
          phoneNumber: pin.phoneNumber);
      // Perform user login with ProxyService
      await ProxyService.local.login(
        pin: thePin,
        flipperHttpClient: ProxyService.http,
        skipDefaultAppSetup: false,
        userPhone: pin.phoneNumber,
      );

      ///save or update the pin, we might get the pin from remote then we need to update the local or create new one
      await ProxyService.local.savePin(pin: thePin);
      await appService.appInit();

      // Get the UID after login
      String uid = ProxyService.box.uid();

      // Attempt to sign in with the custom token
      try {
        await tokenLogin(uid);
      } catch (tokenError) {
        talker.error("Error during token login: $tokenError");
        // Handle token login failure (e.g., retry or alternative auth method)
      }
      final defaultApp = ProxyService.box.getDefaultApp();
      await appService.appInit();
      if (defaultApp == "2") {
        final _routerService = locator<RouterService>();
        _routerService.navigateTo(SocialHomeViewRoute());
      } else {
        locator<RouterService>().navigateTo(FlipperAppRoute());
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
