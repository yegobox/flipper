import 'package:flipper_services/proxy.dart';
import 'package:stacked/stacked.dart';
import 'package:universal_platform/universal_platform.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flipper_routing/routes.logger.dart';

final isWindows = UniversalPlatform.isWindows;

class LoginViewModel extends FormViewModel {
  LoginViewModel();
  final log = getLogger('LoginViewModel');

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
}
