import 'dart:developer';

import 'package:flipper_models/isar_models.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:flipper_services/app_service.dart';
import 'package:flipper_services/locator.dart' as loc;
import 'package:flipper_services/proxy.dart';

import 'package:stacked_services/stacked_services.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

class LoginViewModel extends FlipperBaseModel {
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
    setIsprocessing(value: true);

    Pin? pin = await ProxyService.isar.getPin(pin: pinCode);
    setIsprocessing(value: false);
    if (pin != null) {
      ProxyService.box.writeInt(key: 'businessId', value: pin.businessId);
      ProxyService.box.writeInt(key: 'branchId', value: pin.branchId);
      ProxyService.box.writeString(key: 'userId', value: pin.userId);
      ProxyService.box.writeString(key: 'userPhone', value: pin.phoneNumber);
      ProxyService.box.writeBool(key: 'isAnonymous', value: true);
      await ProxyService.isar.login(
        skipDefaultAppSetup: false,
        userPhone: pin.phoneNumber,
      );
      try {
        await FirebaseAuth.instance.signOut();
        await FirebaseAuth.instance.signInAnonymously();
        log('getting instance');
        final auth = FirebaseAuth.instance;

        if (auth.currentUser != null) {
          if (ProxyService.box.getDefaultApp() == "2") {
            _routerService.navigateTo(SocialHomeViewRoute());
          } else {
            openDrawer();
          }
        }
      } catch (e) {
        // log(s.toString());
        if (ProxyService.box.getDefaultApp() == "2") {
          _routerService.navigateTo(SocialHomeViewRoute());
        } else {
          openDrawer();
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
