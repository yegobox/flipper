import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/services/internet_connection_service.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:flipper_services/Miscellaneous.dart';
import 'package:flipper_services/proxy.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:flipper_services/locator.dart' as loc;
import 'dart:convert';

import 'package:flipper_models/helperModels/iuser.dart';
import 'package:flipper_models/secrets.dart';
import 'package:flipper_services/app_service.dart';
import 'package:supabase_models/brick/models/user.model.dart';
import 'dart:async';

import 'package:talker_flutter/talker_flutter.dart';
import 'package:stacked/stacked.dart';

mixin TokenLogin {
  Future<void> tokenLogin(String token) async {
    try {
      await ProxyService.strategy.firebaseLogin(token: token);
    } catch (e) {
      talker.error(e);
      rethrow;
    }
  }
}

class LoginViewModel extends FlipperBaseModel
    with TokenLogin, CoreMiscellaneous {
  final appService = loc.getIt<AppService>();
  LoginViewModel();

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
  final talker = TalkerFlutter.init();
  get isProcessing => _isProceeding;

  Future<void> completeLoginProcess(Pin userPin, {IUser? user}) async {
    talker.info(
        '[completeLoginProcess] Starting with pin: ${userPin.userId}, user: ${user?.uid}');
    try {
      await ProxyService.box
          .writeInt(key: "userId", value: int.parse(userPin.userId.toString()));
      talker.info('[completeLoginProcess] userId written to box');

      await ProxyService.strategy.login(
        userPhone: userPin.phoneNumber!,
        skipDefaultAppSetup: false,
        pin: userPin,
        existingUser: user,
        flipperHttpClient: ProxyService.http,
      );
      talker.info('[completeLoginProcess] strategy.login finished');

      await ProxyService.box.writeBool(key: 'authComplete', value: true);
      talker.info('[completeLoginProcess] authComplete written to box');

      // Always call completeLogin to navigate
      await completeLogin(userPin);
      talker.info(
          '[completeLoginProcess] completeLogin called, navigation should occur');
    } catch (e, s) {
      talker.error('[completeLoginProcess] Login process failed', e, s);
      rethrow;
    }
  }

  Future<void> completeLogin(Pin thePin) async {
    talker.info('[completeLogin] Saving pin and initializing app');
    try {
      await ProxyService.strategy.savePin(pin: thePin);
      await appService.appInit();
      talker.info(
          '[completeLogin] Pin saved, appInit done, navigating to StartUpViewRoute');
      locator<RouterService>().navigateTo(StartUpViewRoute());
    } catch (e, s) {
      talker.error('[completeLogin] Error during navigation', e, s);
      rethrow;
    }
  }

  /// Process user login and retrieve PIN information
  Future<Map<String, dynamic>> processUserLogin(
      {required firebase.User user}) async {
    print('🔵 processUserLogin START with user: ${user.uid}');
    talker.info('[processUserLogin] Starting with user: ${user.uid}');
    try {
      // Step 1: Get user from database
      print(
          '🔵 STEP 1: Calling ProxyService.strategy.authUser with uuid: ${user.uid}');
      talker.info('[processUserLogin] Calling authUser with uuid: ${user.uid}');
      final User? myuser = await ProxyService.strategy
          .authUser(uuid: user.uid)
          .timeout(Duration(seconds: 10), onTimeout: () {
        print('🔴 TIMEOUT: authUser call timed out after 10 seconds');
        talker.error(
            '[processUserLogin] authUser call timed out after 10 seconds');
        throw TimeoutException('authUser call timed out');
      });

      print(
          '🔵 STEP 1 COMPLETE: authUser result: ${myuser != null ? "User found with key: ${myuser.key}" : "User not found"}');
      talker.info(
          '[processUserLogin] authUser result: ${myuser != null ? "User found" : "User not found"}');

      // Step 2: Determine key for login request
      String key = '';
      if (myuser == null) {
        // fallback to old habit
        key = user.phoneNumber ?? user.email!;
        print('🔵 STEP 2: Using fallback key: $key');
        talker.info('[processUserLogin] Using fallback key: $key');
      } else {
        key = myuser.key!;
        print('🔵 STEP 2: Using user key: $key');
        talker.info('[processUserLogin] Using user key: $key');
      }

      // Step 3: Send login request
      print('🔵 STEP 3: Sending login request with key: $key');
      talker.info('[processUserLogin] Sending login request with key: $key');
      final response = await ProxyService.strategy
          .sendLoginRequest(key, ProxyService.http, AppSecrets.apihubProd)
          .timeout(Duration(seconds: 15), onTimeout: () {
        print('🔴 TIMEOUT: sendLoginRequest timed out after 15 seconds');
        talker.error(
            '[processUserLogin] sendLoginRequest timed out after 15 seconds');
        throw TimeoutException('sendLoginRequest timed out');
      });

      print('🔵 STEP 3 COMPLETE: Login request response received');
      talker.info('[processUserLogin] Login request response received');

      // Step 4: Parse response and check for tenants
      print('🔵 STEP 4: Parsing response and checking tenants');
      talker.info('[processUserLogin] Parsing response and checking tenants');
      final userJson = json.decode(response.body);
      final tenants = userJson['tenants'] as List<dynamic>?;
      final tenant = tenants != null && tenants.isNotEmpty ? tenants[0] : null;
      print('🔵 STEP 4 COMPLETE: Tenants found: ${tenants?.length ?? 0}');
      talker.info('[processUserLogin] Tenants found: ${tenants?.length ?? 0}');

      // Step 5: Ensure admin access if needed
      print('🔵 STEP 5: Checking admin access');
      talker.info('[processUserLogin] Checking admin access');
      if (tenant != null) {
        try {
          // Add timeout to prevent blocking the flow indefinitely
          await ensureAdminAccessIfNeeded(tenant: tenant, talker: talker)
              .timeout(Duration(seconds: 5), onTimeout: () {
            print(
                '🟠 WARNING: ensureAdminAccessIfNeeded timed out after 5 seconds');
            talker.warning(
                '[processUserLogin] ensureAdminAccessIfNeeded timed out after 5 seconds');
            // Return null or appropriate value to continue the flow
            return null;
          });
          print('🔵 STEP 5 COMPLETE: Admin access check completed');
          talker.info('[processUserLogin] Admin access check completed');
        } catch (e) {
          // Log error but continue the flow
          print('🟠 WARNING: Error in ensureAdminAccessIfNeeded: $e');
          talker.error(
              '[processUserLogin] Error in ensureAdminAccessIfNeeded: $e');
        }
      } else {
        print('🟠 WARNING: No tenants found for user during login');
        talker
            .info('[processUserLogin] No tenants found for user during login');
      }

      // Step 6: Create user object
      print('🔵 STEP 6: Creating IUser object from response');
      talker.info('[processUserLogin] Creating IUser object from response');
      final iUser = IUser.fromJson(json.decode(response.body));
      print('🔵 STEP 6 COMPLETE: IUser created with id: ${iUser.id}');
      talker.info('[processUserLogin] IUser created with id: ${iUser.id}');

      // Step 7: Get PIN information
      print('🔵 STEP 7: Getting PIN information for user id: ${iUser.id}');
      talker.info(
          '[processUserLogin] Getting PIN information for user id: ${iUser.id}');
      final pin = await ProxyService.strategy
          .getPin(
              pinString: iUser.id.toString(),
              flipperHttpClient: ProxyService.http)
          .timeout(Duration(seconds: 10), onTimeout: () {
        print('🔴 TIMEOUT: getPin call timed out after 10 seconds');
        talker
            .error('[processUserLogin] getPin call timed out after 10 seconds');
        throw TimeoutException('getPin call timed out');
      });

      if (pin == null) {
        print('🔴 ERROR: PIN is null');
        talker.error('[processUserLogin] PIN is null');
        throw Exception('PIN is null');
      }

      print('🔵 STEP 7 COMPLETE: PIN retrieved successfully');
      talker.info('[processUserLogin] PIN retrieved successfully');

      // Step 8: Return final result
      print('🔵 STEP 8: Returning final result');
      talker.info('[processUserLogin] Returning final result');
      final result = {
        'pin': Pin(
            userId: int.parse(pin.userId),
            pin: pin.pin,
            branchId: pin.branchId,
            businessId: pin.businessId,
            ownerName: pin.ownerName,
            tokenUid: iUser.uid,
            uid: user.uid,
            phoneNumber: iUser.phoneNumber),
        'user': iUser
      };
      print('🔵 processUserLogin COMPLETED SUCCESSFULLY');
      talker.info('[processUserLogin] Completed successfully');
      return result;
    } catch (e, s) {
      print('🔴 ERROR in processUserLogin: $e');
      talker.error('[processUserLogin] Error: $e');
      talker.error(s);
      rethrow;
    }
  }

  /// Shared admin access logic for both login flows
  static Future<void> ensureAdminAccessIfNeeded({
    required dynamic tenant,
    required dynamic talker,
  }) async {
    final List permissions =
        tenant != null ? (tenant['permissions'] ?? []) : [];
    final bool isAdmin = permissions
        .any((perm) => (perm['name']?.toLowerCase() ?? '') == 'admin');
    final _internetConnectionService = InternetConnectionService();
    final bool isOnline =
        await _internetConnectionService.checkInternetConnectionRequirement();
    if (isAdmin && isOnline) {
      final userId = tenant['userId'].toString();
      final branchId =
          tenant['branches'] != null && tenant['branches'].isNotEmpty
              ? tenant['branches'][0]['id'].toString()
              : null;
      final businessId = tenant['businessId'].toString();
      if (branchId != null) {
        await StartupViewModel.ensureAdminAccessForUser(
          userId: userId,
          branchId: branchId,
          businessId: businessId,
          talker: talker,
        );
      } else {
        talker.error('Missing IDs for admin access assignment');
      }
    }
  }

  /// Handle login-related errors
  void handleLoginError(Object e, StackTrace s) {
    talker.error(e, s);

    if (e is LoginChoicesException) {
      talker.error('LoginChoicesException');
      _navigateWithTransition(LoginChoicesRoute());
      return;
    } else if (e is NeedSignUpException || e is BusinessNotFoundException) {
      talker.error('NeedSignUpException or BusinessNotFoundException');
      _navigateWithTransition(SignUpViewRoute(countryNm: "Rwanda"));
      return;
    } else if (e is NoPaymentPlanFound) {
      talker.error('NoPaymentPlanFound');
      _navigateWithTransition(PaymentPlanUIRoute());
      return;
    }
    throw e;
  }
  
  /// Navigate to a route with a smooth transition
  void _navigateWithTransition(PageRouteInfo<dynamic> route) {
    // Use the router service to navigate with a smoother transition
    // The actual transition is controlled by the router configuration
    locator<RouterService>().navigateTo(route);
  }
}
