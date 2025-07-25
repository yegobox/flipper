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
import 'package:flipper_routing/app.router.dart';
import 'package:flipper_services/app_service.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/proxy.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart' as foundation;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supabase_models/brick/repository.dart';
import 'package:flipper_services/locator.dart' as loc;
import 'package:stacked_services/stacked_services.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

mixin AuthMixin implements AuthInterface {
  String get apihub;
  Repository get repository;
  bool get offlineLogin;
  set offlineLogin(bool value);

  // Handle the login completion flow (redirect after login)
  @override
  Future<void> completeLogin(Pin thePin) async {
    try {
      // Get the current Firebase user's UID
      final currentUser = FirebaseAuth.instance.currentUser;
      final uid = currentUser?.uid;

      // If we have a valid UID from Firebase but the PIN doesn't have it,
      // update the PIN with the UID to prevent duplicates
      if (uid != null && thePin.uid != uid) {
        print("Updating PIN with Firebase UID: $uid");
        thePin.uid = uid;
        thePin.tokenUid = uid; // Also update tokenUid to ensure consistency
      }

      // Save the PIN with the updated UID
      await ProxyService.strategy.savePin(pin: thePin);
      await loc.getIt<AppService>().appInit();
      final defaultApp = ProxyService.box.getDefaultApp();

      if (defaultApp == "2") {
        final routerService = locator<RouterService>();
        routerService.navigateTo(SocialHomeViewRoute());
      } else {
        locator<RouterService>().navigateTo(FlipperAppRoute());
      }
    } catch (e) {
      print(e); // Log or handle error during login completion
      rethrow;
    }
  }

  /// Centralized error handling for login errors
  /// Returns a tuple with (errorMessage, shouldNavigateToLoginChoices, isPinError)
  /// UI-specific handling should be done by the caller
  @override
  Future<Map<String, dynamic>> handleLoginError(dynamic e, StackTrace s,
      {String? responseChannel}) async {
    String errorMessage = '';
    bool shouldNavigateToLoginChoices = false;
    bool isPinError = false;
    bool shouldCaptureException = true;

    if (e is BusinessNotFoundException) {
      errorMessage = e.errMsg();
    } else if (e is PinError) {
      errorMessage = e.errMsg();
      isPinError = true;
      shouldCaptureException = false;
    } else if (e is LoginChoicesException) {
      if (responseChannel != null) {
        try {
          // await ProxyService.event.publish(loginDetails: {
          //   'channel': responseChannel,
          //   'status':
          //       'choices_needed', // Special status for business/branch selection
          //   'message': 'Please select a business and branch',
          // });
        } catch (responseError) {
          talker.error('Failed to send login response: $responseError');
        }
      }
      errorMessage = e.errMsg();
      shouldNavigateToLoginChoices = true;
      shouldCaptureException = false;

      // Handle navigation directly here
      try {
        locator<RouterService>().navigateTo(LoginChoicesRoute());
      } catch (navError) {
        talker.error('Failed to navigate to login choices: $navError');
      }
    } else {
      errorMessage = e.toString();
    }

    // Log the error
    talker.error('Login error: $errorMessage');
    talker.error(s);

    // Send error status back to the mobile device if response channel is provided
    // This is used for QR code login to notify the mobile device of login failure
    if (responseChannel != null) {
      try {
        // await ProxyService.event.publish(loginDetails: {
        //   'channel': responseChannel,
        //   'status': 'failure',
        //   'message': errorMessage.isEmpty ? 'Login failed' : errorMessage,
        // });
        talker
            .debug("Sent login failure response to channel: $responseChannel");
      } catch (responseError) {
        talker.error('Failed to send login response: $responseError');
      }
    }

    // Capture exception for non-expected errors
    if (shouldCaptureException) {
      try {
        await Sentry.captureException(e, stackTrace: s);
      } catch (sentryError) {
        talker.error('Failed to capture exception with Sentry: $sentryError');
      }
    }

    return {
      'errorMessage': errorMessage,
      'shouldNavigateToLoginChoices': shouldNavigateToLoginChoices,
      'isPinError': isPinError
    };
  }

  @override
  Future<bool> logOut();

  // Required methods that should be provided by other mixins
  @override
  Future<List<Business>> businesses(
      {int? userId, bool fetchOnline = false, bool active = false});

  @override
  Future<bool> firebaseLogin({String? token}) async {
    int? userId = ProxyService.box.getUserId();
    if (userId == null) return false;

    // Get the existing PIN for this user ID
    final pinLocal = await ProxyService.strategy
        .getPinLocal(userId: userId, alwaysHydrate: true);

    try {
      token ??= pinLocal?.tokenUid;

      if (token != null) {
        await FirebaseAuth.instance.signInWithCustomToken(token);

        // If we have a successful login, make sure to update the tokenUid in the PIN
        // This ensures we keep the PIN record updated with the latest token
        if (pinLocal != null && pinLocal.tokenUid != token) {
          talker.debug("Updating PIN with new token for userId: $userId");
          ProxyService.strategy.updatePin(
              userId: userId,
              phoneNumber: pinLocal.phoneNumber,
              tokenUid: token);
        }

        return true;
      }
      return FirebaseAuth.instance.currentUser != null;
    } catch (e) {
      talker.error("Firebase login error: $e");

      // Only attempt to get a new token if we have PIN information
      if (pinLocal != null && pinLocal.phoneNumber != null) {
        try {
          final http.Response response = await sendLoginRequest(
            pinLocal.phoneNumber!,
            ProxyService.http,
            apihub,
            uid: pinLocal.uid ?? "",
          );

          if (response.statusCode == 200 && response.body.isNotEmpty) {
            final IUser user = IUser.fromJson(json.decode(response.body));

            // Update the existing PIN with the new token
            ProxyService.strategy.updatePin(
                userId: user.id!,
                phoneNumber: pinLocal.phoneNumber,
                tokenUid: user.uid);
          }
        } catch (requestError) {
          talker.error("Error getting new token: $requestError");
        }
      }

      return false;
    }
  }

  @override
  Future<bool> hasActiveSubscription({
    required String businessId,
    required HttpClientInterface flipperHttpClient,
    required bool fetchRemote,
  }) async {
    // if (isTestEnvironment()) return true;
    final Plan? plan =
        await ProxyService.strategy.getPaymentPlan(businessId: businessId);

    if (plan == null) {
      throw NoPaymentPlanFound(
          "No payment plan found for businessId: $businessId");
    }

    final isPaymentCompletedLocally = plan.paymentCompletedByUser ?? false;

    // Avoid unnecessary sync if payment is already marked as complete
    if (!isPaymentCompletedLocally) {
      final isPaymentComplete = await ProxyService.httpApi.isPaymentComplete(
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
    final id = (await ProxyService.strategy.activeBusiness())?.id ?? "";
    await hasActiveSubscription(
        businessId: id,
        flipperHttpClient: ProxyService.http,
        fetchRemote: fetchRemote);
  }

  Future<IUser> _authenticateUser(
      String phoneNumber, Pin pin, HttpClientInterface flipperHttpClient,
      {bool forceOffline = false,
      bool freshUser = false,
      required bool isInSignUpProgress}) async {
    List<Business> businessesE = await businesses(userId: pin.userId!);
    List<Branch> branchesE = await branches(businessId: pin.businessId!);

    final bool shouldEnableOfflineLogin = forceOffline ||
        (businessesE.isNotEmpty &&
            branchesE.isNotEmpty &&
            !(await ProxyService.status.isInternetAvailable()));

    talker.debug("Offline login decision factors:");
    talker.debug("- forceOffline: $forceOffline");
    talker.debug("- businessesE not empty: ${businessesE.isNotEmpty}");
    talker.debug("- branchesE not empty: ${branchesE.isNotEmpty}");
    talker.debug("- kDebugMode: ${foundation.kDebugMode}");
    talker.debug(
        "- Internet available: ${await ProxyService.status.isInternetAvailable()}");
    talker.debug("Final shouldEnableOfflineLogin: $shouldEnableOfflineLogin");

    if (shouldEnableOfflineLogin) {
      offlineLogin = true;
      final offlineUser =
          _createOfflineUser(phoneNumber, pin, businessesE, branchesE);
      if (offlineUser.id == null) {
        talker.error('Created offline user has null ID');
        throw Exception('Failed to create offline user: User ID is null');
      }
      return offlineUser;
    }

    // Check if we already have a valid Firebase user and token
    final currentUser = FirebaseAuth.instance.currentUser;
    final existingToken = await ProxyService.box.getBearerToken();
    final existingUserId = ProxyService.box.getUserId();

    // If we have a valid token and the user ID matches the pin's user ID,
    // we can skip the sendLoginRequest call
    if (currentUser != null &&
        existingToken != null &&
        existingUserId != null &&
        existingUserId.toString() == pin.userId.toString() &&
        !isInSignUpProgress) {
      talker.debug("Using existing Firebase authentication");

      // Create a user object from existing data
      final user = IUser(
        token: ProxyService.box.getBearerToken(),
        id: existingUserId,
        uid: currentUser.uid,
        phoneNumber: phoneNumber,
        tenants: [ITenant(name: pin.ownerName ?? 'Default Tenant')],
      );

      return user;
    }

    // Otherwise, proceed with normal authentication flow
    talker.debug("Performing full authentication flow");
    final http.Response response =
        await sendLoginRequest(phoneNumber, flipperHttpClient, apihub);

    if (response.statusCode == 200 && response.body.isNotEmpty) {
      // Parse the user from the response
      final IUser user = IUser.fromJson(json.decode(response.body));

      // Make PIN patching non-blocking for the login flow
      try {
        await _patchPin(user.id!, flipperHttpClient, apihub,
            ownerName: user.tenants.first.name!);
      } catch (e) {
        // Log the error but don't block login
        talker.warning("Failed to patch PIN, but continuing login: $e");
        // This ensures offline login still works even if PIN patching fails
      }

      ProxyService.box.writeInt(key: 'userId', value: user.id!);

      // Only perform Firebase login if not already logged in
      if (currentUser == null || currentUser.uid != user.uid) {
        await firebaseLogin(token: user.uid);
      }

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
      required bool isInSignUpProgress,
      bool freshUser = false,
      required HttpClientInterface flipperHttpClient,
      IUser? existingUser}) async {
    final flipperWatch? w =
        foundation.kDebugMode ? flipperWatch("callLoginApi") : null;
    w?.start();
    final String phoneNumber = _formatPhoneNumber(userPhone);

    // Use existing user data if provided, otherwise make the API call
    print('Before _authenticateUser');
    final IUser user = existingUser ??
        await _authenticateUser(phoneNumber, pin, flipperHttpClient,
            freshUser: freshUser, isInSignUpProgress: isInSignUpProgress);
    print('After _authenticateUser');

    await configureSystem(userPhone, user, offlineLogin: offlineLogin);
    print('After configureSystem');
    await ProxyService.box.writeBool(key: 'authComplete', value: true);
    print('After setting authComplete');

    if (stopAfterConfigure) return user;
    if (!skipDefaultAppSetup) {
      // Ensure business and branch IDs are set in storage
      // This is critical for when a user logs in again
      if (pin.businessId != null) {
        talker.debug("Setting businessId to ${pin.businessId}");
        await ProxyService.box
            .writeInt(key: 'businessId', value: pin.businessId!);

        // Also set business preferences
        try {
          final businesses = await this.businesses(userId: pin.userId!);
          Business? selectedBusiness;

          // Find the matching business or use the first one if none matches
          for (final business in businesses) {
            // Compare serverId with pin.businessId, handling both string and int types
            if (business.serverId.toString() == pin.businessId.toString()) {
              selectedBusiness = business;
              break;
            }
          }

          // If no match found, use the first business if available
          if (selectedBusiness == null && businesses.isNotEmpty) {
            selectedBusiness = businesses.first;
          }

          if (selectedBusiness != null) {
            talker.debug(
                "Setting business preferences for ${selectedBusiness.name}");
            await ProxyService.box.writeString(
                key: 'bhfId', value: (await ProxyService.box.bhfId()) ?? "00");

            // Get existing tin value if available
            final existingTin = ProxyService.box.readInt(key: 'tin');

            // Only update tin if selectedBusiness.tinNumber is not null or there's no existing value
            if (selectedBusiness.tinNumber != null || existingTin == null) {
              await ProxyService.box.writeInt(
                  key: 'tin',
                  value: selectedBusiness.tinNumber ?? existingTin ?? 0);
              talker.debug(
                  'Setting tin to ${selectedBusiness.tinNumber ?? existingTin ?? 0} (from ${selectedBusiness.tinNumber != null ? 'business' : 'existing value'})');
            } else {
              talker.debug('Preserving existing tin value: $existingTin');
            }

            await ProxyService.box.writeString(
                key: 'encryptionKey',
                value: selectedBusiness.encryptionKey ?? "");

            // Mark the business as active and default
            await ProxyService.strategy.updateBusiness(
              businessId: selectedBusiness.serverId,
              active: true,
              isDefault: true,
            );
          }

          // Only throw LoginChoicesException if there are multiple businesses
          // This ensures the login_choices.dart screen is shown only when necessary
          if (businesses.length > 1) {
            // Store a flag to indicate we're coming from login
            await ProxyService.box.writeBool(key: 'from_login', value: true);
            throw LoginChoicesException(term: 'business');
          } else if (businesses.length == 1) {
            // If there's only one business, check if there are multiple branches
            final branches =
                await this.branches(businessId: selectedBusiness!.serverId);

            // Only go to login_choices if there are multiple branches
            if (branches.length > 1) {
              await ProxyService.box.writeBool(key: 'from_login', value: true);
              throw LoginChoicesException(term: 'Business');
            }

            // If there's only one branch, set it as active and default
            if (branches.length == 1) {
              final branch = branches.first;
              await ProxyService.strategy.updateBranch(
                branchId: branch.serverId!,
                active: true,
                isDefault: true,
              );

              // Update branch ID in storage
              await ProxyService.box
                  .writeInt(key: 'branchId', value: branch.serverId!);
              await ProxyService.box
                  .writeString(key: 'branchIdString', value: branch.id);

              // No need to throw exception - continue with login flow
              talker
                  .debug("Single business and branch - skipping login_choices");
            }
          }
        } catch (e) {
          if (e is LoginChoicesException) {
            // Re-throw this specific exception to ensure proper navigation
            rethrow;
          }
          talker.error("Error setting business preferences: $e");
        }
      }

      // Handle the case where pin already has a branchId (for backward compatibility)
      if (pin.branchId != null && pin.businessId != null) {
        talker.debug("Setting branchId to ${pin.branchId}");
        await ProxyService.box.writeInt(key: 'branchId', value: pin.branchId!);

        try {
          // Get the branch ID string if available
          final branches = await this.branches(businessId: pin.businessId!);
          Branch? selectedBranch;

          // Find the matching branch or use the first one if none matches
          for (final branch in branches) {
            // Compare serverId with pin.branchId, handling both string and int types
            if (branch.serverId.toString() == pin.branchId.toString()) {
              selectedBranch = branch;
              break;
            }
          }

          // If no match found, use the first branch if available
          if (selectedBranch == null && branches.isNotEmpty) {
            selectedBranch = branches.first;
          }

          if (selectedBranch != null) {
            talker.debug("Setting branchIdString to ${selectedBranch.id}");
            await ProxyService.box
                .writeString(key: 'branchIdString', value: selectedBranch.id);

            // Set the branch as active and default
            await ProxyService.strategy.updateBranch(
              branchId: selectedBranch.serverId!,
              active: true,
              isDefault: true,
            );
          }
        } catch (e) {
          talker.error("Error setting branch ID string: $e");
        }
      }
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

  @override
  Future<http.Response> sendLoginRequest(
      String phoneNumber, HttpClientInterface flipperHttpClient, String apihub,
      {String? uid}) async {
    uid = uid ?? FirebaseAuth.instance.currentUser?.uid;

    // Get the phone number associated with the current session
    final existingPhoneNumber = ProxyService.box.getUserPhone();
    // get userId of the user that is trying to log in
    final savedLocalPinForThis = await ProxyService.strategy
        .getPinLocal(phoneNumber: phoneNumber, alwaysHydrate: false);
    uid ??= savedLocalPinForThis?.uid;
    final tenants = await ProxyService.strategy
        .getTenant(pin: savedLocalPinForThis?.userId ?? 0);

    // Check if we have sufficient local data to skip the API call
    if (savedLocalPinForThis != null &&
        existingPhoneNumber == phoneNumber &&
        tenants != null) {
      final businesses = await ProxyService.strategy
          .businesses(userId: savedLocalPinForThis.userId!);
      final branches = await ProxyService.strategy
          .branches(businessId: tenants.businessId ?? 0);

      if (businesses.isNotEmpty && branches.isNotEmpty) {
        talker.debug(
            "Using existing token and user ID, skipping duplicate sendLoginRequest");

        // Build a proper response structure with the fetched data
        Map<String, dynamic> responseData = {
          'id': savedLocalPinForThis.userId,
          'token': savedLocalPinForThis.tokenUid,
          'uid': uid,
          'phoneNumber': phoneNumber,
          'channels': [savedLocalPinForThis.userId.toString()],
          'pin': savedLocalPinForThis.userId,
          'tenants': []
        };

        Map<String, dynamic> tenantData = {
          'id': tenants.id,
          'name': tenants.name,
          'phoneNumber': phoneNumber,
          'businessId': tenants.businessId,
          'userId': savedLocalPinForThis.userId,
          'pin': savedLocalPinForThis.userId,
          'type': tenants.type,
          'default': tenants.isDefault,
          'businesses': _convertBusinesses(businesses)
              .map((e) => e.toJson())
              .toList(), // Convert IBusiness to map
          'branches': _convertBranches(branches)
              .map((e) => e.toJson())
              .toList(), // Convert IBranch to map
        };

        responseData['tenants'] = [tenantData];

        return http.Response(
          jsonEncode(responseData),
          200,
        );
      }
    }

    // If local data is not sufficient, proceed with the actual API call
    try {
      talker.debug("Sending login request to API for phone: $phoneNumber");
      // Only add '+' prefix if it's a phone number (not email) and doesn't start with '+'
      if (!phoneNumber.startsWith('+') && !phoneNumber.contains('@')) {
        phoneNumber = '+$phoneNumber';
      }
      final response = await flipperHttpClient.post(
        Uri.parse(apihub + '/v2/api/user'),
        body: jsonEncode(<String, String?>{
          'phoneNumber': phoneNumber,
          // TODO: fix this on api level so it works, currently not accepting uuid.
          // if (uid != null && uid.isNotEmpty) 'uid': uid
        }),
      );

      // Check for 401 Unauthorized response
      if (response.statusCode == 401) {
        talker.error("Authentication failed with 401 error: ${response.body}");
        throw SessionException(term: "session expired");
      }

      // Check for error response
      if (response.statusCode != 200) {
        talker.error(
            "Authentication failed with status code ${response.statusCode}: ${response.body}");
        throw Exception(
            "Authentication failed with status code ${response.statusCode}");
      }
      //

      // Validate response body
      if (response.body.isEmpty) {
        talker.error("Empty response body from login request");
        throw Exception("Empty response from server");
      }

      final responseBody = jsonDecode(response.body);

      // Check if this is an error response
      if (responseBody.containsKey('details') &&
          responseBody['details'] is String &&
          responseBody['details'].toString().startsWith('Error id')) {
        talker.error(
            "Error response from login request: ${responseBody['details']}");
        throw Exception("Server error: ${responseBody['details']}");
      }

      talker.warning("sendLoginRequest:UserId:${responseBody['id']}");
      talker.warning("sendLoginRequest:token:${responseBody['token']}");

      talker.warning("$responseBody");
      // Handle userId which could now be a string or int
      if (responseBody['id'] is String) {
        // Store the original string ID for reference
        ProxyService.box
            .writeString(key: 'userIdString', value: responseBody['id']);
        // Convert string ID to integer for backward compatibility
        final int userId = int.tryParse(responseBody['id']) ?? 0;
        ProxyService.box.writeInt(key: 'userId', value: userId);
      } else if (responseBody['id'] != null) {
        ProxyService.box.writeInt(key: 'userId', value: responseBody['id']);
      } else {
        talker.error("Missing ID in response: ${responseBody}");
        throw Exception("Missing user ID in server response");
      }

      // Process businesses and branches if they're in the response
      if (responseBody['tenants'] != null &&
          responseBody['tenants'] is List &&
          responseBody['tenants'].isNotEmpty) {
        final tenant = responseBody['tenants'][0];

        // Store the businessId if available
        if (tenant['businessId'] != null) {
          final businessId = tenant['businessId'];
          talker.debug("Setting businessId from API response: $businessId");
          ProxyService.box.writeString(
              key: 'businessIdString', value: businessId.toString());
        }

        // Save businesses locally
        if (tenant['businesses'] != null && tenant['businesses'] is List) {
          for (var businessData in tenant['businesses']) {
            final iBusiness = IBusiness.fromJson(businessData);
            // Convert IBusiness to Business (from supabase_models)
            final business = Business(
              phoneNumber: businessData['phoneNumber'] as String? ??
                  iBusiness.phoneNumber ??
                  '',
              id: iBusiness.id,
              serverId: iBusiness.serverId,
              name: iBusiness.name,
              currency: iBusiness.currency,
              categoryId: iBusiness.categoryId,
              latitude: iBusiness.latitude,
              longitude: iBusiness.longitude,
              userId: iBusiness.userId,
              timeZone: iBusiness.timeZone,
              country: iBusiness.country,
              businessUrl: iBusiness.businessUrl,
              hexColor: iBusiness.hexColor,
              imageUrl: iBusiness.imageUrl,
              type: iBusiness.type,
              createdAt: iBusiness.createdAt,
              metadata: iBusiness.metadata,
              role: iBusiness.role,
              lastSeen: iBusiness.lastSeen,
              firstName: iBusiness.firstName,
              lastName: iBusiness.lastName,
              deviceToken: iBusiness.deviceToken,
              chatUid: iBusiness.chatUid,
              backUpEnabled: iBusiness.backUpEnabled,
              subscriptionPlan: iBusiness.subscriptionPlan,
              nextBillingDate: iBusiness.nextBillingDate,
              previousBillingDate: iBusiness.previousBillingDate,
              isLastSubscriptionPaymentSucceeded:
                  iBusiness.isLastSubscriptionPaymentSucceeded,
              backupFileId: iBusiness.backupFileId,
              email: iBusiness.email,
              lastDbBackup: iBusiness.lastDbBackup,
              fullName: iBusiness.fullName,
              tinNumber: iBusiness.tinNumber,
              dvcSrlNo: iBusiness.dvcSrlNo,
              bhfId: iBusiness.bhfId,
              adrs: iBusiness.adrs,
              taxEnabled: iBusiness.taxEnabled,
              isDefault: iBusiness.isDefault,
              businessTypeId: iBusiness.businessTypeId,
              encryptionKey: iBusiness.encryptionKey,
            );
            await repository.upsert<Business>(business);
            talker.debug("Saved business locally: ${business.name}");
          }
        }

        // Save branches locally
        if (tenant['branches'] != null && tenant['branches'] is List) {
          for (var branchData in tenant['branches']) {
            final iBranch = IBranch.fromJson(branchData);
            // Convert IBranch to Branch (from supabase_models)
            final branch = Branch(
              id: iBranch.id,
              serverId: iBranch.serverId,
              active: iBranch.active,
              description: iBranch.description,
              name: iBranch.name,
              businessId: iBranch.businessId,
              longitude: iBranch.longitude,
              latitude: iBranch.latitude,
              location: iBranch.location,
              isDefault: iBranch.isDefault,
            );
            await repository.upsert<Branch>(branch);
            talker.debug("Saved branch locally: ${branch.name}");
          }
        }
      }

      ProxyService.box.writeString(key: 'userPhone', value: phoneNumber);
      await ProxyService.box
          .writeString(key: 'bearerToken', value: responseBody['token']);
      return response;
    } catch (e, s) {
      // If it's already a SessionException, rethrow it
      if (e is SessionException) {
        rethrow;
      }
      talker.error("Error in sendLoginRequest:  $s");
      // Log the error and rethrow
      talker.error("Error in sendLoginRequest: $e");
      throw e;
    }
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
        if (FirebaseAuth.instance.currentUser != null)
          'uid': FirebaseAuth.instance.currentUser!.uid,
      }),
    );
  }

  List<IBranch> _convertBranches(List<Branch> branches) {
    return branches.map((e) {
      // Store the string ID for reference if needed
      // The id field is non-nullable, so we don't need to check for null
      if (e.serverId != null) {
        ProxyService.box
            .writeString(key: 'branch_${e.serverId}_uuid', value: e.id);
      }

      return IBranch(
          // For id, we need to use serverId for backward compatibility
          // since IBranch.id expects an int
          id: e.id,
          name: e.name,
          businessId: e.businessId,
          longitude: e.longitude,
          latitude: e.latitude,
          location: e.location,
          active: e.active,
          isDefault: false);
    }).toList();
  }

  List<IBusiness> _convertBusinesses(List<Business> businesses) {
    return businesses.map((e) {
      // Store the string ID for reference if needed
      // The id field is non-nullable, so we don't need to check for null
      ProxyService.box
          .writeString(key: 'business_${e.serverId}_uuid', value: e.id);

      return IBusiness(
        phoneNumber: e.phoneNumber,
        id: e.id,
        serverId: e.serverId,
        name: e.name ?? '',
        userId: e.userId?.toString() ?? '',
        currency: e.currency ?? 'RWF',
        categoryId: e.categoryId ?? 0,
        latitude: e.latitude ?? '0', // string
        longitude: e.longitude ?? '0', // string
        timeZone: e.timeZone ?? '',
        email: e.email ?? '',
        fullName: e.fullName ?? '',
        tinNumber: e.tinNumber ?? 0, // int
        bhfId: e.bhfId ?? '00',
        dvcSrlNo: e.dvcSrlNo ?? '',
        adrs: e.adrs ?? '',
        taxEnabled: e.taxEnabled ?? false,
        isDefault: e.isDefault ?? false,
        businessTypeId: e.businessTypeId ?? 0,
        encryptionKey: e.encryptionKey ?? '',
      );
    }).toList();
  }

  IUser _createOfflineUser(String phoneNumber, Pin pin,
      List<Business> businesses, List<Branch> branches) {
    // For businessId, convert to int if it's a string for backward compatibility

    return IUser(
      token: ProxyService.box.getBearerToken() ?? "",
      uid: pin.uid,
      phoneNumber: pin.phoneNumber!,
      id: pin.userId!,
      tenants: [
        ITenant(
            name: pin.ownerName == null ? "DEFAULT" : pin.ownerName!,
            phoneNumber: phoneNumber,
            permissions: [],
            branches: _convertBranches(branches),
            businesses: _convertBusinesses(businesses),
            businessId: pin.businessId,
            nfcEnabled: false,
            userId: pin.userId)
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

  /// Authenticates with Supabase using branch ID as email
  @override
  Future<void> supabaseAuth() async {
    try {
      // Get branch ID for email construction
      final branchId = ProxyService.box.getBranchId();
      if (branchId == null) {
        talker.warning(
            'Cannot authenticate with Supabase: No branch ID available');
        return;
      }

      final email = '$branchId@flipper.rw';
      talker.debug('Supabase email: $email');

      // Check if we already have a valid session
      final currentSession = Supabase.instance.client.auth.currentSession;
      final currentUser = Supabase.instance.client.auth.currentUser;

      // Check if the session is still valid (not expired)
      final bool hasValidSession = currentSession != null &&
          currentUser != null &&
          currentUser.email == email &&
          _isSessionValid(currentSession);

      if (hasValidSession) {
        talker.debug(
            'Supabase session is still valid, skipping re-authentication');
        return;
      }

      talker.debug('No valid Supabase session found, authenticating...');

      // Determine if we need to sign up or sign in
      if (currentUser == null) {
        // Try to sign up first
        try {
          final session = Supabase.instance.client.auth.currentSession;
          if (session != null) {
            // User is already logged in.  Handle this situation.
            talker.debug("User is already logged in.  Sign out first.");
            await Supabase.instance.client.auth
                .signOut(); // Sign out if necessary
          }

          // First attempt to sign up the user
          talker.debug('Attempting to sign up user with email: $email');
          await Supabase.instance.client.auth.signUp(
            email: email,
            password: email,
          );
          talker.debug('Supabase user created successfully, now signing in');

          // After sign up, attempt to sign in
          await _attemptSignIn(email);
        } catch (signUpError) {
          // If sign up fails (likely because user already exists), try sign in directly
          talker.debug('Sign up failed, attempting sign in: $signUpError');
          await _attemptSignIn(email);
        }
      } else {
        // User exists but session is invalid, just sign in
        await _attemptSignIn(email);
      }
    } catch (e) {
      talker.error('Supabase authentication error: $e');
    }
  }

  /// Attempts to sign in with the given email
  Future<void> _attemptSignIn(String email) async {
    try {
      AuthResponse auth =
          await Supabase.instance.client.auth.signInWithPassword(
        email: email,
        password: email,
      );

      _saveSessionData(auth);
      talker.debug('Supabase sign in successful');
    } catch (signInError) {
      talker.error('Supabase sign in failed: $signInError');
      // Do not rethrow here. Supabase auth is optional and should not
      // block the login process, especially in offline scenarios.
    }
  }

  /// Saves session data to local storage
  void _saveSessionData(AuthResponse auth) {
    final expiresAt = auth.session?.expiresAt ?? 0;
    final refreshToken = auth.session?.refreshToken ?? "";

    ProxyService.box.writeString(key: 'refreshToken', value: refreshToken);
    ProxyService.box.writeInt(key: 'expiresAt', value: expiresAt);

    // Also store the access token for potential use elsewhere
    final accessToken = auth.session?.accessToken ?? "";
    ProxyService.box
        .writeString(key: 'supabaseAccessToken', value: accessToken);
  }

  /// Checks if a session is still valid
  bool _isSessionValid(Session session) {
    // Get current time in seconds since epoch
    final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;

    // Add a buffer of 5 minutes (300 seconds) to refresh before actual expiration
    const expirationBuffer = 300;

    // Session is valid if it's not expired (with buffer)
    // Handle null expiresAt safely
    final expiresAt = session.expiresAt ?? 0;
    return expiresAt > (now + expirationBuffer);
  }
}
