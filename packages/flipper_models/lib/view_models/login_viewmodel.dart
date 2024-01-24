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
    try {
      setIsprocessing(value: true);

      Pin? pin = await ProxyService.isar.getPin(pin: pinCode);

      // Update local storage values
      ProxyService.box.writeInt(key: 'businessId', value: pin!.businessId);
      ProxyService.box.writeInt(key: 'branchId', value: pin.branchId);
      ProxyService.box.writeString(key: 'userId', value: pin.userId);
      ProxyService.box.writeString(key: 'userPhone', value: pin.phoneNumber);
      ProxyService.box.writeBool(key: 'isAnonymous', value: true);

      // Perform user login
      await ProxyService.isar.login(
        skipDefaultAppSetup: false,
        userPhone: pin.phoneNumber,
      );

      // Clear and re-sign in with Firebase anonymously
      await FirebaseAuth.instance.signOut();
      await FirebaseAuth.instance.signInAnonymously();

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
      throw error;
    }
  }

  void setIsprocessing({required bool value}) {
    _isProceeding = value;
    notifyListeners();
  }
}
