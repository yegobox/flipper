import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/helperModels/pin.dart';
import 'package:flipper_mfa/flipper_mfa.dart';
import 'package:flipper_services/proxy.dart';

class MfaProvider {
  const MfaProvider();

  /// Validate a TOTP code for the given user and, if valid, complete login
  Future<bool> validateTotpThenLogin({
    required IPin pin,
    required String code,
  }) async {
    final bool isValid = await MfaService().verifyTotpForUser(
      userId: int.parse(pin.userId),
      code: code,
    );

    if (!isValid) return false;

    await ProxyService.strategy.login(
      userPhone: pin.phoneNumber,
      isInSignUpProgress: false,
      skipDefaultAppSetup: false,
      pin: Pin(
        userId: int.parse(pin.userId),
        pin: pin.pin,
        businessId: pin.businessId,
        branchId: pin.branchId,
        ownerName: pin.ownerName ?? '',
        phoneNumber: pin.phoneNumber,
      ),
      flipperHttpClient: ProxyService.http,
    );
    return true;
  }

  /// Request SMS OTP for a given PIN string
  Future<Map<String, dynamic>> requestSmsOtp(
      {required String pinString}) async {
    return await ProxyService.strategy.requestOtp(pinString);
  }

  /// Verify SMS OTP and complete login
  Future<void> verifySmsOtpThenLogin({
    required IPin pin,
    required String otp,
  }) async {
    await ProxyService.strategy.verifyOtpAndLogin(otp, pin: pin);
  }
}
