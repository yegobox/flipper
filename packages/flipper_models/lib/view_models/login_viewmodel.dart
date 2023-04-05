import 'package:flipper_models/isar/pin.dart';
import 'package:flipper_models/view_models/gate.dart';
import 'package:flipper_services/app_service.dart';
import 'package:flipper_services/locator.dart';
import 'package:flipper_services/proxy.dart';
import 'package:stacked/stacked.dart';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginViewModel extends FormViewModel {
  LoginViewModel();
  final appService = locator<AppService>();

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

  /// this method log-in user using anonmous login
  /// and it is used when logging on desktop app,
  /// the mobile will send the phone number wanting to login and a signal to the desktop app to log-in
  /// then the desktop sill log-in the user using anonmous login
  Future<void> scanToLogin({required String phoneNumber}) async {
    /// when logging on desktop app, the mobile will send the phone number wanting to login and a signal to the desktop app to log-in

    // await pullEvent?.acknowledge();

    /// once we get the user credential we can get the user
    // ProxyService.auth.confirmOtp();
  }

  @override
  void setFormStatus() {}
  bool _isProceeding = false;

  get isProcessing => _isProceeding;
  Future<void> desktopLogin({
    required String pinCode,
    required BuildContext context,
  }) async {
    _isProceeding = true;
    notifyListeners();
    Pin? pin = await ProxyService.isarApi.getPin(pin: pinCode);
    if (pin != null) {
      ProxyService.box.write(key: 'businessId', value: pin.businessId);
      ProxyService.box.write(key: 'branchId', value: pin.branchId);
      ProxyService.box.write(key: 'userId', value: pin.userId);
      ProxyService.box.write(key: 'userPhone', value: pin.phoneNumber);
      ProxyService.box.write(key: 'isAnonymous', value: true);
      await ProxyService.isarApi.login(
        userPhone: pin.phoneNumber,
      );
      // await appService.appInit();
      await FirebaseAuth.instance.signInAnonymously();
      final auth = FirebaseAuth.instance;
      if (auth.currentUser != null) {
        LoginInfo().isLoggedIn = true;
        // we are logged in but there is a chance that this number is a tenant
        // that is given access to this business's branch
        // TODOtenant's is not useful when sync is not supported.
        LoginInfo().redirecting = false;

        notifyListeners();
        //TODOSubmit this data in Device model to know which device is logged in
        //I will work on this when sync on isar is complete I don't want to use firestoreanymore!
        // final deviceInfoPlugin = DeviceInfoPlugin();
      }
    } else {
      _isProceeding = false;
      notifyListeners();
    }
  }

  void setIsprocessing({required bool value}) {
    _isProceeding = value;
    notifyListeners();
  }
}
