import 'package:country_code_picker/country_code.dart';
import 'package:flipper/routes.locator.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:flipper_services/abstractions/platform.dart';
import 'package:universal_platform/universal_platform.dart';

final isWindows = UniversalPlatform.isWindows;

class LoginViewModel extends FormViewModel {
  LoginViewModel();
  final fb = locator<LoginStandard>();
  Future<bool> login({required BuildContext context}) async {
    ProxyService.box.write(key: 'userPhone', value: dialCode + phoneNumber!);
    return await fb.createAccountWithPhone(
        phone: dialCode + phoneNumber!, context: context);
  }

  void navigateBack() => ProxyService.nav.back();

  String? phoneNumber;
  void setPhoneNumber({required String phone}) {
    phoneNumber = phone;
  }

  String dialCode = '+250';
  void setCountryIso({CountryCode? iso}) {
    dialCode = (iso != null ? iso.dialCode : '+250')!;
  }

  void setOtp({required String ot}) {
    ProxyService.box.write(key: 'otp', value: ot);
  }

  @override
  void setFormStatus() {}
}
