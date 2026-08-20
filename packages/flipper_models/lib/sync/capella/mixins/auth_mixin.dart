import 'package:flipper_services/proxy.dart';
import 'dart:async';

import 'package:flipper_models/helperModels/pin.dart';
import 'package:flipper_models/sync/interfaces/auth_interface.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/helperModels/iuser.dart';
import 'package:flipper_models/helperModels/social_token.dart';
import 'package:flipper_models/flipper_http_client.dart';
import 'package:http/http.dart' as http;
import 'package:supabase_models/brick/repository.dart';
import 'package:talker/talker.dart';

mixin CapellaAuthMixin implements AuthInterface {
  Repository get repository;
  Talker get talker;
  String get apihub;

  bool _offlineLogin = false;
  bool get offlineLogin => _offlineLogin;
  set offlineLogin(bool value) => _offlineLogin = value;

  // TODO(ditto-migration): port `businesses` to Ditto.
  @override
  Future<List<Business>> businesses(
      {String? userId, bool fetchOnline = false, bool active = false}) async {
    return ProxyService.legacyStrategy.businesses(userId: userId, fetchOnline: fetchOnline, active: active);
  }

  // TODO(ditto-migration): port `completeLogin` to Ditto.
  @override
  Future<void> completeLogin(Pin thePin) {
    return ProxyService.legacyStrategy.completeLogin(thePin);
  }

  // TODO(ditto-migration): port `firebaseLogin` to Ditto.
  @override
  Future<bool> firebaseLogin({String? token}) async {
    return ProxyService.legacyStrategy.firebaseLogin(token: token);
  }

  // TODO(ditto-migration): port `login` to Ditto.
  @override
  Future<IUser> login({
    required String userPhone,
    required bool skipDefaultAppSetup,
    IUser? existingUser,
    required bool isInSignUpProgress,
    bool stopAfterConfigure = false,
    required Pin pin,
    bool forceOffline = false,
    required HttpClientInterface flipperHttpClient,
  }) async {
    return ProxyService.legacyStrategy.login(userPhone: userPhone, skipDefaultAppSetup: skipDefaultAppSetup, existingUser: existingUser, isInSignUpProgress: isInSignUpProgress, stopAfterConfigure: stopAfterConfigure, pin: pin, forceOffline: forceOffline, flipperHttpClient: flipperHttpClient);
  }

  // TODO(ditto-migration): port `sendLoginRequest` to Ditto.
  @override
  Future<http.Response> sendLoginRequest(
    String phoneNumber,
    HttpClientInterface flipperHttpClient,
    String apihub, {
    String? uid,
    String? expectedPinUserId,
    String? pinLookupPhone,
    bool refreshUserAccessOnly = false,
  }) async {
    return ProxyService.legacyStrategy.sendLoginRequest(phoneNumber, flipperHttpClient, apihub, uid: uid, expectedPinUserId: expectedPinUserId, pinLookupPhone: pinLookupPhone, refreshUserAccessOnly: refreshUserAccessOnly);
  }

  // TODO(ditto-migration): port `configureSystem` to Ditto.
  @override
  Future<void> configureSystem(String userPhone, IUser user,
      {required bool offlineLogin}) async {
    return ProxyService.legacyStrategy.configureSystem(userPhone, user, offlineLogin: offlineLogin);
  }

  // TODO(ditto-migration): port `loginOnSocial` to Ditto.
  @override
  Future<SocialToken?> loginOnSocial({
    String? phoneNumberOrEmail,
    String? password,
  }) async {
    return ProxyService.legacyStrategy.loginOnSocial(phoneNumberOrEmail: phoneNumberOrEmail, password: password);
  }

  // TODO(ditto-migration): port `hasActiveSubscription` to Ditto.
  @override
  Future<bool> hasActiveSubscription(
      {required String businessId,
      required HttpClientInterface flipperHttpClient,
      required bool fetchRemote}) async {
    return ProxyService.legacyStrategy.hasActiveSubscription(businessId: businessId, flipperHttpClient: flipperHttpClient, fetchRemote: fetchRemote);
  }

  // TODO(ditto-migration): port `handleLoginError` to Ditto.
  @override
  Future<Map<String, dynamic>> handleLoginError(dynamic e, StackTrace s,
      {String? responseChannel}) {
    return ProxyService.legacyStrategy.handleLoginError(e, s, responseChannel: responseChannel);
  }

  @override
  Future<void> supabaseAuth() {
    throw UnimplementedError(
        'supabaseAuth needs to be implemented for Capella');
  }

  // TODO(ditto-migration): port `requestOtp` to Ditto.
  @override
  Future<Map<String, dynamic>> requestOtp(String pin) {
    return ProxyService.legacyStrategy.requestOtp(pin);
  }

  // TODO(ditto-migration): port `verifyOtpAndLogin` to Ditto.
  @override
  Future<IUser> verifyOtpAndLogin(String otp, {IPin? pin}) {
    return ProxyService.legacyStrategy.verifyOtpAndLogin(otp, pin: pin);
  }
}
