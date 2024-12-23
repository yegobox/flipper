import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_models/realm_model_export.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:flipper_services/Miscellaneous.dart';
import 'package:flipper_services/proxy.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flipper_services/locator.dart' as loc;

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

      final defaultApp = ProxyService.box.getDefaultApp();
      await appService.appInit();
      if (defaultApp == "2") {
        final _routerService = locator<RouterService>();
        _routerService.navigateTo(SocialHomeViewRoute());
      } else {
        locator<RouterService>().navigateTo(FlipperAppRoute());
      }
    } catch (e, s) {
      talker.error(e, s);
      rethrow;
    }
  }
}
