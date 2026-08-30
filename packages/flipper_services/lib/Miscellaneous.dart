import 'dart:developer';
import 'dart:io';

import 'package:flipper_models/helperModels/random.dart';
import 'package:flipper_models/helperModels/sale_device_id.dart';
import 'package:flipper_models/helpers/agent_session_helper.dart';
import 'package:flipper_services/proxy.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flipper_web/core/utils/ditto_singleton.dart';
import 'package:flipper_models/services/payment_verification_service.dart';
import 'package:flipper_models/sync/mixins/auth_mixin.dart';
import 'package:flutter/foundation.dart' hide Category;
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supabase_models/supabase_models.dart';
import 'package:flipper_web/services/ditto_service.dart';
import 'package:device_info_plus/device_info_plus.dart';

// Define the interface
abstract class CoreMiscellaneousInterface {
  Future<bool> isServerUp();
  Future<Directory> getSupportDir();
  Future<bool> logOut();
  bool isTestEnvironment();
  Future<String> getDeviceVersion();
}

// Implement the interface in a mixin
mixin CoreMiscellaneous implements CoreMiscellaneousInterface {
  @override
  Future<bool> isServerUp() async {
    try {
      final url =
          await ProxyService.box.getServerUrl() ?? "https://turbo.yegobox.com/";
      final response = await http.get(Uri.parse(url));
      return response.statusCode ==
          200; // changed from 404 because 200 is typical for a server being up
    } catch (e) {
      // Handle network errors or other issues
      print("Error checking server status: $e");
      return false; // Assume server is down on error
    }
  }

  /// Validates if userId is set in ProxyService.box
  /// Returns true if userId exists and is valid, false otherwise
  bool isUserIdSet() {
    final userId = ProxyService.box.getUserId();
    return userId != null && userId.isNotEmpty;
  }

  /// Validates if userId is set and calls the onInvalid callback if not
  /// Returns true if userId is valid, false if it's invalid regardless of whether onInvalid was provided
  bool validateUserId({void Function()? onInvalid}) {
    if (!isUserIdSet()) {
      if (onInvalid != null) {
        onInvalid();
      }
      return false;
    }
    return true;
  }

  @override
  Future<Directory> getSupportDir() async {
    Directory appSupportDir;
    if (Platform.isAndroid) {
      // Try to get external storage, fall back to internal if not available
      appSupportDir = await getExternalStorageDirectory() ??
          await getApplicationCacheDirectory();
    } else if (kIsWeb) {
      //Web platforms don't need to declare a support directory
      appSupportDir = await getApplicationDocumentsDirectory();
    } else {
      appSupportDir = await getApplicationSupportDirectory();
    }
    return appSupportDir;
  }

  @override
  Future<bool> logOut() async {
    return await _performLogout();
  }

  @override
  bool isTestEnvironment() {
    return const bool.fromEnvironment('FLUTTER_TEST_ENV') == true;
  }

  @override
  Future<String> getDeviceVersion() async {
    return await getDeviceVersionStatic();
  }

  static Future<String> getDeviceVersionStatic() async {
    final deviceInfo = DeviceInfoPlugin();
    String version = Platform.version;
    try {
      if (Platform.isAndroid) {
        final androidInfo = await deviceInfo.androidInfo;
        version = androidInfo.version.release;
      } else if (Platform.isIOS) {
        final iosInfo = await deviceInfo.iosInfo;
        version = iosInfo.systemVersion;
      } else if (Platform.isMacOS) {
        final macOsInfo = await deviceInfo.macOsInfo;
        version =
            '${macOsInfo.majorVersion}.${macOsInfo.minorVersion}.${macOsInfo.patchVersion}';
      } else if (Platform.isWindows) {
        final windowsInfo = await deviceInfo.windowsInfo;
        version =
            '${windowsInfo.majorVersion}.${windowsInfo.minorVersion}.${windowsInfo.buildNumber}';
      } else if (Platform.isLinux) {
        final linuxInfo = await deviceInfo.linuxInfo;
        version = linuxInfo.versionId ?? Platform.version;
      }
    } catch (e) {
      // talker is not available here easily as it's a mixin, using print or log
      log('Error getting device info: $e');
    }
    return version;
  }

  // Non-static logout method
  static Future<bool> logoutStatic() async {
    return await _performLogout();
  }

  // Private helper method to reuse logout logic
  static Future<bool> _performLogout() async {
    final isTestEnvironment =
        const bool.fromEnvironment('FLUTTER_TEST_ENV') == true;
    try {
      // Capture the session identity up front: everything below either tears the
      // session down or clears it, so re-reading the box mid-flight is unsafe.
      final userId = ProxyService.box.getUserId();
      final businessId = ProxyService.box.getBusinessId();
      final branchId = ProxyService.box.getBranchId();

      ProxyService.event.unsubscribeLoginEvent();
      ProxyService.event.resetLoginStatus();

      // Stop background payment verification. The singleton's timer outlives
      // the session otherwise, so it keeps polling — and navigating — for a
      // user who has signed out. StartupViewModel restarts it on next login.
      final paymentVerification = PaymentVerificationService();
      paymentVerification.stopPeriodicVerification();
      await paymentVerification.stopRealtimeVerification();

      await resetSaleDeviceIdCache();
      await setCommissionOnlySession(false);
      // set authComplete to false
      await ProxyService.box.writeBool(key: 'authComplete', value: false);

      // Everything up to clearSessionKeys() is best-effort remote bookkeeping
      // that can hang on a bad network. It is time-bounded so the local session
      // is always cleared — a logout that stalls here and never wipes prefs is
      // what let a "logged out" user re-enter the app on relaunch.
      Future<void> announceAndReleaseSession() async {
        if (userId != null && businessId != null && kReleaseMode) {
          ProxyService.event.publish(
            loginDetails: {
              'channel': "$userId-logout",
              'userId': userId,
              'businessId': businessId,
              'branchId': branchId,
              'phone': ProxyService.box.getUserPhone(),
              'defaultApp': ProxyService.box.getDefaultApp(),
              'deviceName': Platform.operatingSystem,
              'uid': isTestEnvironment == true
                  ? ""
                  : (await FirebaseAuth.instance.currentUser?.getIdToken()) ??
                        "",
              'deviceVersion': await getDeviceVersionStatic(),
              'linkingCode': randomNumber().toString(),
            },
          );
        }

        // Mark existing Ditto events for this user as logged out. This runs in
        // every build mode — gating it on kReleaseMode left debug builds with a
        // live Ditto identity for the previous user after signing out.
        if (userId != null && DittoService.instance.isReady()) {
          try {
            await DittoService.instance.dittoInstance!.store.execute(
              "UPDATE events SET loggedOut = true WHERE userId = :userId",
              arguments: {"userId": userId},
            );
            print('✅ Marked Ditto events as logged out for user $userId');
          } catch (e) {
            print('Error updating Ditto events on logout: $e');
          }
        }

        // Perform additional logout operations
        ProxyService.strategy.whoAmI();

        // Unset default for all businesses and branches

        // First, explicitly set the current active business and branch to inactive
        if (businessId != null) {
          try {
            // Set current active business to inactive and not default
            await ProxyService.strategy.updateBusiness(
              businessId: businessId,
              isDefault: false,
            );

            // Set current active branch to inactive and not default
            if (branchId != null) {
              await ProxyService.strategy.updateBranch(
                branchId: branchId,
                isDefault: false,
              );
            }

            // Now update all other businesses and branches to be safe
            if (userId != null) {
              List<Business> businesses = await ProxyService.strategy
                  .businesses(userId: userId);
              for (Business business in businesses) {
                if (business.id != businessId) {
                  await ProxyService.strategy.updateBusiness(
                    businessId: business.id,
                    isDefault: false,
                  );
                }
              }
              List<Branch> branches = await ProxyService.strategy.branches(
                businessId: businessId,
              );
              for (Branch branch in branches) {
                if (branch.id != branchId) {
                  await ProxyService.strategy.updateBranch(
                    branchId: branch.id,
                    isDefault: false,
                  );
                }
              }
            }
          } catch (e) {
            // Log error but continue with logout process
            print('Error updating business/branch status during logout: $e');
          }
        }
      }

      // The bookkeeping future keeps running past the timeout, so its errors
      // are swallowed *inside* it: an error raised after `.timeout()` has
      // already given up has no one left to catch it and would surface as an
      // unhandled async error long after logout returned.
      final bookkeeping = () async {
        try {
          await announceAndReleaseSession();
        } catch (e) {
          print('Logout bookkeeping failed, session cleared anyway: $e');
        }
      }();
      try {
        await bookkeeping.timeout(const Duration(seconds: 15));
      } catch (e) {
        print('Logout bookkeeping did not finish, clearing session anyway: $e');
      }

      // Drop every session-scoped preference in one durable step, while the
      // Ditto store is still open so the Ditto-backed prefs copy is wiped too.
      //
      // Removing individual keys here used to miss `userIdString`, which
      // `getUserId()` reads *before* `userId` — so the app still saw a signed-in
      // user on the next launch and walked straight into the dashboard.
      await ProxyService.box.clearSessionKeys();

      // Tear down Ditto only after prefs are wiped: DittoSingleton.logout()
      // stops sync, and resetDittoInitialization lets the next user re-init.
      if (DittoService.instance.isReady()) {
        try {
          await DittoSingleton.instance.logout();
        } catch (e) {
          print('Error during Ditto logout: $e');
        } finally {
          // Must run even when logout throws: leaving the init flag set locks
          // the next user out of re-initialising Ditto.
          AuthMixin.resetDittoInitializationStatic();
        }
      }

      // Remote sign-out is best-effort: local session prefs are already gone, so
      // a network failure here must not report logout as failed (and must not
      // leave the caller believing the user is still signed in).
      try {
        if (!const bool.fromEnvironment(
          'FLUTTER_TEST_ENV',
          defaultValue: false,
        )) {
          await FirebaseAuth.instance.signOut();
        }
        await ProxyService.strategy.amplifyLogout();
        await Supabase.instance.client.auth.signOut();
      } catch (e) {
        print('Error during remote sign-out (session already cleared): $e');
      }

      return true;
    } catch (e, s) {
      log(e.toString());
      log(s.toString());
      rethrow;
    }
  }

  /// Ensures that the Realm database is initialized and ready to use.
}
