import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:flipper_services/Miscellaneous.dart';
import 'package:flipper_services/proxy.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flipper_services/locator.dart' as loc;
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:flipper_models/helperModels/iuser.dart';
import 'package:flipper_models/secrets.dart';
import 'package:flipper_services/app_service.dart';
import 'dart:async';

import 'package:talker_flutter/talker_flutter.dart';

mixin TokenLogin {
  Future<void> tokenLogin(String token) async {
    final credential = await FirebaseAuth.instance.signInWithCustomToken(token);
    talker.warning("credentials: $credential");
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

  Future<void> completeLogin(Pin thePin) async {
    try {
      await ProxyService.strategy.savePin(pin: thePin);
      await appService.appInit();

      // Attempt to sign in with the custom token
      locator<RouterService>().navigateTo(StartUpViewRoute());
      // final defaultApp = ProxyService.box.getDefaultApp();
      // await appService.appInit();
      // if (defaultApp == "2") {
      //   final _routerService = locator<RouterService>();
      //   _routerService.navigateTo(SocialHomeViewRoute());
      // } else {
      //   locator<RouterService>().navigateTo(FlipperAppRoute());
      // }
    } catch (e, s) {
      talker.error(e, s);
      rethrow;
    }
  }

  /// Process user login and retrieve PIN information
  Future<Pin> processUserLogin(firebase.User user) async {
    final key = user.phoneNumber ?? user.email!;

    // Get user information
    final response = await ProxyService.strategy
        .sendLoginRequest(key, ProxyService.http, AppSecrets.apihubProd);
    final iUser = IUser.fromJson(json.decode(response.body));

    // Get PIN information
    final pin = await ProxyService.strategy.getPin(
        pinString: iUser.id.toString(), flipperHttpClient: ProxyService.http);

    return Pin(
        userId: int.parse(pin!.userId),
        pin: pin.pin,
        branchId: pin.branchId,
        businessId: pin.businessId,
        ownerName: pin.ownerName,
        tokenUid: iUser.uid,
        uid: user.uid,
        phoneNumber: iUser.phoneNumber);
  }

  /// Complete the login process with the retrieved PIN
  Future<void> completeLoginProcess(Pin userPin, LoginViewModel model) async {
    await ProxyService.box
        .writeInt(key: "userId", value: int.parse(userPin.userId.toString()));

    await ProxyService.strategy.login(
        userPhone: userPin.phoneNumber!,
        skipDefaultAppSetup: false,
        pin: userPin,
        flipperHttpClient: ProxyService.http);

    await ProxyService.box.writeBool(key: 'authComplete', value: true);
    completeLogin(userPin);
  }

  /// Handle login-related errors
  void handleLoginError(Object e, StackTrace s) {
    talker.error(e, s);

    if (e is NeedSignUpException || e is BusinessNotFoundException) {
      locator<RouterService>().navigateTo(SignUpViewRoute(countryNm: "Rwanda"));
    } else if (e is NoPaymentPlanFound) {
      locator<RouterService>().navigateTo(PaymentPlanUIRoute());
      return;
    }
    throw e;
  }
}
