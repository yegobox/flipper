import 'package:flipper_models/isar/pin.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:flipper_services/app_service.dart';
import 'package:flipper_services/locator.dart' as loc;
import 'package:flipper_services/proxy.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

class LoginViewModel extends FormViewModel {
  LoginViewModel();
  final appService = loc.locator<AppService>();
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
    ProxyService.box.write(key: 'otp', value: ot);
  }

  @override
  void setFormStatus() {}
  bool _isProceeding = false;

  get isProcessing => _isProceeding;
  Future<void> desktopLogin({
    required String pinCode,
    required BuildContext context,
  }) async {
    setIsprocessing(value: true);
    Pin? pin = await ProxyService.isar.getPin(pin: pinCode);
    if (pin != null) {
      ProxyService.box.write(key: 'businessId', value: pin.businessId);
      ProxyService.box.write(key: 'branchId', value: pin.branchId);
      ProxyService.box.write(key: 'userId', value: pin.userId);
      ProxyService.box.write(key: 'userPhone', value: pin.phoneNumber);
      ProxyService.box.write(key: 'isAnonymous', value: true);
      await ProxyService.isar.login(
        skipDefaultAppSetup: false,
        userPhone: pin.phoneNumber,
      );
      await FirebaseAuth.instance.signInAnonymously();
      final auth = FirebaseAuth.instance;
      if (auth.currentUser != null) {
        if (ProxyService.box.getDefaultApp() == 2) {
          _routerService.navigateTo(SocialHomeViewRoute());
        } else {
          _routerService.navigateTo(DrawerScreenRoute(open: "open"));
        }
      }
    } else {
      setIsprocessing(value: false);
      // show stacked snackbar
      throw 'Invalid pin';
    }
  }

  void setIsprocessing({required bool value}) {
    _isProceeding = value;
    notifyListeners();
  }
}
