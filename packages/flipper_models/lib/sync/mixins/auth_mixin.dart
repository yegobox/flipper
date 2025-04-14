import 'dart:convert';
import 'package:flipper_models/helperModels/branch.dart';
import 'package:flipper_models/helperModels/business.dart';
import 'package:flipper_models/helperModels/flipperWatch.dart';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_models/helperModels/tenant.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/sync/interfaces/auth_interface.dart';
import 'package:flipper_models/helperModels/iuser.dart';
import 'package:flipper_models/helperModels/social_token.dart';
import 'package:flipper_models/flipper_http_client.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/proxy.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:flutter/foundation.dart' as foundation;
import 'package:supabase_models/brick/repository.dart';

mixin AuthMixin implements AuthInterface {
  String get apihub;
  Repository get repository;
  bool get offlineLogin;
  set offlineLogin(bool value);

  @override
  Future<bool> logOut();

  // Required methods that should be provided by other mixins
  @override
  Future<List<Business>> businesses({required int userId});

  @override
  Future<bool> firebaseLogin({String? token}) async {
    int? userId = ProxyService.box.getUserId();
    if (userId == null) return false;
    final pinLocal = await ProxyService.strategy.getPinLocal(userId: userId);
    try {
      token ??= pinLocal?.tokenUid;

      if (token != null) {
        await FirebaseAuth.instance.signInWithCustomToken(token);
        return true;
      }
      return FirebaseAuth.instance.currentUser != null;
    } catch (e) {
      final http.Response response =
          await ProxyService.strategy.sendLoginRequest(
        pinLocal!.phoneNumber!,
        ProxyService.http,
        apihub,
        uid: pinLocal.uid ?? "",
      );
      if (response.statusCode == 200 && response.body.isNotEmpty) {
        final IUser user = IUser.fromJson(json.decode(response.body));
        ProxyService.strategy.updatePin(
          userId: user.id!,
          phoneNumber: pinLocal.phoneNumber,
          tokenUid: user.uid,
        );
      }
      return false;
    }
  }

  @override
  Future<bool> hasActiveSubscription({
    required int businessId,
    required HttpClientInterface flipperHttpClient,
    required bool fetchRemote,
  }) async {
    // if (isTestEnvironment()) return true;
    final Plan? plan = await ProxyService.strategy
        .getPaymentPlan(businessId: businessId, fetchRemote: fetchRemote);

    if (plan == null) {
      throw NoPaymentPlanFound(
          "No payment plan found for businessId: $businessId");
    }

    final isPaymentCompletedLocally = plan.paymentCompletedByUser ?? false;

    // Avoid unnecessary sync if payment is already marked as complete
    if (!isPaymentCompletedLocally) {
      final isPaymentComplete = await ProxyService.realmHttp.isPaymentComplete(
        flipperHttpClient: flipperHttpClient,
        businessId: businessId,
      );

      // Update the plan's state or handle syncing logic here if necessary
      if (!isPaymentComplete) {
        throw FailedPaymentException(PAYMENT_REACTIVATION_REQUIRED);
      }
    }

    return true;
  }

  Future<void> _hasActiveSubscription({bool fetchRemote = false}) async {
    await hasActiveSubscription(
        businessId: ProxyService.box.getBusinessId()!,
        flipperHttpClient: ProxyService.http,
        fetchRemote: fetchRemote);
  }

  Future<IUser> _authenticateUser(String phoneNumber, Pin pin,
      HttpClientInterface flipperHttpClient) async {
    List<Business> businessesE = await businesses(userId: pin.userId!);
    List<Branch> branchesE = await branches(businessId: pin.businessId!);

    final bool shouldEnableOfflineLogin = businessesE.isNotEmpty &&
        branchesE.isNotEmpty &&
        !foundation.kDebugMode &&
        !(await ProxyService.status.isInternetAvailable());

    if (shouldEnableOfflineLogin) {
      offlineLogin = true;
      return _createOfflineUser(phoneNumber, pin, businessesE, branchesE);
    }

    final http.Response response =
        await sendLoginRequest(phoneNumber, flipperHttpClient, apihub);

    if (response.statusCode == 200 && response.body.isNotEmpty) {
      /// path the user pin, with
      final IUser user = IUser.fromJson(json.decode(response.body));
      await _patchPin(user.id!, flipperHttpClient, apihub,
          ownerName: user.tenants.first.name);
      ProxyService.box.writeInt(key: 'userId', value: user.id!);
      await ProxyService.strategy.firebaseLogin(token: user.uid);
      return user;
    } else {
      await _handleLoginError(response);
      throw Exception("Error during login");
    }
  }

  @override
  Future<IUser> login(
      {required String userPhone,
      required bool skipDefaultAppSetup,
      bool stopAfterConfigure = false,
      required Pin pin,
      required HttpClientInterface flipperHttpClient,
      IUser? existingUser}) async {
    final flipperWatch? w =
        foundation.kDebugMode ? flipperWatch("callLoginApi") : null;
    w?.start();
    final String phoneNumber = _formatPhoneNumber(userPhone);
    
    // Use existing user data if provided, otherwise make the API call
    final IUser user = existingUser ?? 
        await _authenticateUser(phoneNumber, pin, flipperHttpClient);
        
    await configureSystem(userPhone, user, offlineLogin: offlineLogin);
    await ProxyService.box.writeBool(key: 'authComplete', value: true);
    if (stopAfterConfigure) return user;
    if (!skipDefaultAppSetup) {
      await setDefaultApp(user);
    }
    ProxyService.box.writeBool(key: 'pinLogin', value: false);
    w?.log("user logged in");
    try {
      _hasActiveSubscription();
    } catch (e) {
      rethrow;
    }
    return user;
  }

  String _formatPhoneNumber(String phoneNumber) {
    // Add phone number formatting logic here
    return phoneNumber;
  }

  Future<void> configureSystem(String userPhone, IUser user,
      {required bool offlineLogin}) async {
    // Add system configuration logic here
    await ProxyService.box.writeInt(key: 'userId', value: user.id!);
    await ProxyService.box.writeString(key: 'userPhone', value: userPhone);

    if (!offlineLogin) {
      // Perform online-specific configuration
      await firebaseLogin();
    }
  }

  Future<void> setDefaultApp(IUser user) async {
    // Add default app setup logic here
  }

  @override
  Future<http.Response> sendLoginRequest(
      String phoneNumber, HttpClientInterface flipperHttpClient, String apihub,
      {String? uid}) async {
    uid = uid ?? firebase.FirebaseAuth.instance.currentUser?.uid;
    final response = await flipperHttpClient.post(
      Uri.parse(apihub + '/v2/api/user'),
      body:
          jsonEncode(<String, String?>{'phoneNumber': phoneNumber, 'uid': uid}),
    );
    final responseBody = jsonDecode(response.body);
    talker.warning("sendLoginRequest:UserId:${responseBody['id']}");
    talker.warning("sendLoginRequest:token:${responseBody['token']}");
    ProxyService.box.writeInt(key: 'userId', value: responseBody['id']);
    ProxyService.box.writeString(key: 'userPhone', value: phoneNumber);
    await ProxyService.box
        .writeString(key: 'bearerToken', value: responseBody['token']);
    return response;
  }

  Future<void> _handleLoginError(http.Response response) async {
    if (response.statusCode == 401) {
      throw SessionException(term: "session expired");
    } else if (response.statusCode == 500) {
      throw PinError(term: "Not found");
    } else {
      throw UnknownError(term: response.statusCode.toString());
    }
  }

  Future<http.Response> _patchPin(
      int pin, HttpClientInterface flipperHttpClient, String apihub,
      {required String ownerName}) async {
    return await flipperHttpClient.patch(
      Uri.parse(apihub + '/v2/api/pin/${pin}'),
      body: jsonEncode(<String, String?>{
        'ownerName': ownerName,
        'tokenUid': firebase.FirebaseAuth.instance.currentUser?.uid
      }),
    );
  }

  List<IBranch> _convertBranches(List<Branch> branches) {
    return branches
        .map((e) => IBranch(
            id: e.serverId,
            name: e.name,
            businessId: e.businessId,
            longitude: e.longitude,
            latitude: e.latitude,
            location: e.location,
            active: e.active,
            isDefault: false))
        .toList();
  }

  List<IBusiness> _convertBusinesses(List<Business> businesses) {
    return businesses
        .map((e) => IBusiness(
            id: e.serverId,
            name: e.name,
            userId: e.userId.toString(),
            isDefault: false))
        .toList();
  }

  IUser _createOfflineUser(String phoneNumber, Pin pin,
      List<Business> businesses, List<Branch> branches) {
    return IUser(
      token: pin.tokenUid!,
      uid: pin.tokenUid,
      channels: [],
      phoneNumber: pin.phoneNumber!,
      id: pin.userId!,
      tenants: [
        ITenant(
            name: pin.ownerName == null ? "DEFAULT" : pin.ownerName!,
            phoneNumber: phoneNumber,
            permissions: [],
            branches: _convertBranches(branches),
            businesses: _convertBusinesses(businesses),
            businessId: 0,
            nfcEnabled: false,
            userId: pin.userId!,
            isDefault: false)
      ],
    );
  }

  @override
  Future<SocialToken?> loginOnSocial({
    String? phoneNumberOrEmail,
    String? password,
  }) async {
    // Add social login logic here
    return null;
  }
}
