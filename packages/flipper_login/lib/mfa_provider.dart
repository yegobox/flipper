import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/helperModels/pin.dart';
import 'package:flipper_mfa/flipper_mfa.dart';
import 'package:flipper_services/proxy.dart';

class MfaProvider {
  const MfaProvider();

  /// True when this device has a cached TOTP secret for [userId] (or [pin]).
  Future<bool> hasLocalSecret(String userId, {int? pin}) async =>
      (await LocalMfaSecretCache.read(userId, pin: pin)) != null;

  /// Probe Supabase MFA store. Connectivity checkers often lie on web.
  Future<bool> canReachMfaStore(String userId) =>
      MfaService().canReachMfaStore(userId);

  /// Whether we should ask for an authenticator code (remote and/or local).
  Future<bool> canPromptTotp(String userId, {int? pin}) async {
    if (await hasLocalSecret(userId, pin: pin)) return true;
    return canReachMfaStore(userId);
  }

  /// Best-effort: cache the MFA secret on this device if it isn't already,
  /// so the authenticator check needs no network. No-op once cached.
  Future<bool> prefetchSecret({required String userId, int? pin}) =>
      MfaService().prefetchAndCacheSecret(userId: userId, pin: pin);

  /// Validate a TOTP code for the given user and, if valid, complete login.
  ///
  /// The code is verified on device against the cached secret (see
  /// [MfaService.verifyTotpForUser]); the server only supplies the secret
  /// the first time. [forceOffline] only affects the login session.
  Future<TotpVerifyOutcome> validateTotpThenLogin({
    required IPin pin,
    required String code,
    bool forceOffline = false,
  }) async {
    final String? userId = pin.userId;
    if (userId == null || userId.trim().isEmpty) {
      return TotpVerifyOutcome.unavailable;
    }

    final outcome = await MfaService().verifyTotpForUser(
      userId: userId.trim(),
      code: code,
      pin: pin.pin,
      // Verified on device; remote is used only to obtain a missing/stale
      // secret, so a connectivity "offline" must not block that.
      localOnly: false,
    );

    if (outcome != TotpVerifyOutcome.valid) {
      return outcome;
    }

    // After TOTP succeeds, prefer offline session when requested OR when the
    // connectivity checker is wrong and apihub is unreachable.
    try {
      await ProxyService.strategy.login(
        userPhone: pin.phoneNumber,
        isInSignUpProgress: false,
        skipDefaultAppSetup: false,
        forceOffline: forceOffline,
        pin: Pin(
          userId: userId.trim(),
          pin: pin.pin,
          businessId: pin.businessId,
          branchId: pin.branchId,
          ownerName: pin.ownerName ?? '',
          phoneNumber: pin.phoneNumber,
          tokenUid: pin.tokenUid,
        ),
        flipperHttpClient: ProxyService.http,
      );
    } catch (e) {
      if (forceOffline) rethrow;
      final text = e.toString().toLowerCase();
      final network = text.contains('failed host lookup') ||
          text.contains('failed to connect') ||
          text.contains('socketexception') ||
          text.contains('network is unreachable');
      if (!network) rethrow;
      await ProxyService.strategy.login(
        userPhone: pin.phoneNumber,
        isInSignUpProgress: false,
        skipDefaultAppSetup: false,
        forceOffline: true,
        pin: Pin(
          userId: userId.trim(),
          pin: pin.pin,
          businessId: pin.businessId,
          branchId: pin.branchId,
          ownerName: pin.ownerName ?? '',
          phoneNumber: pin.phoneNumber,
          tokenUid: pin.tokenUid,
        ),
        flipperHttpClient: ProxyService.http,
      );
    }
    return TotpVerifyOutcome.valid;
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
