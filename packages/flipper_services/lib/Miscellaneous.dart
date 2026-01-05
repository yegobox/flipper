import 'dart:developer';
import 'dart:io';

import 'package:flipper_models/helperModels/random.dart';
import 'package:flipper_services/proxy.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flipper_web/core/utils/ditto_singleton.dart';
import 'package:flipper_models/sync/mixins/auth_mixin.dart';
import 'package:flutter/foundation.dart';
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
      // set authComplete to false
      ProxyService.box.writeBool(key: 'authComplete', value: false);
      if (ProxyService.box.getUserId() != null &&
          ProxyService.box.getBusinessId() != null &&
          kReleaseMode) {
        ProxyService.event.publish(loginDetails: {
          'channel': "${ProxyService.box.getUserId()!}-logout",
          'userId': ProxyService.box.getUserId(),
          'businessId': ProxyService.box.getBusinessId(),
          'branchId': ProxyService.box.getBranchId(),
          'phone': ProxyService.box.getUserPhone(),
          'defaultApp': ProxyService.box.getDefaultApp(),
          'deviceName': Platform.operatingSystem,
          'uid': isTestEnvironment == true
              ? ""
              : (await FirebaseAuth.instance.currentUser?.getIdToken()) ?? "",
          'deviceVersion': await getDeviceVersionStatic(),
          'linkingCode': randomNumber().toString()
        });

        // Mark existing Ditto events for this user as logged out
        if (DittoService.instance.isReady()) {
          try {
            await DittoService.instance.dittoInstance!.store.execute(
              "UPDATE events SET loggedOut = true WHERE userId = :userId",
              arguments: {"userId": ProxyService.box.getUserId()},
            );
            await DittoSingleton.instance.logout();
            // Reset Ditto initialization state so it can be reinitialized for the next user
            AuthMixin.resetDittoInitializationStatic();
            print(
                '✅ Marked Ditto events as logged out for user ${ProxyService.box.getUserId()}');
          } catch (e) {
            print('Error updating Ditto events on logout: $e');
          }
        }
      }

      // Sign out from Firebase
      if (!const bool.fromEnvironment('FLUTTER_TEST_ENV',
          defaultValue: false)) {
        await FirebaseAuth.instance.signOut();
      }

      // Perform additional logout operations
      ProxyService.strategy.whoAmI();
      await ProxyService.strategy.amplifyLogout();
      await Supabase.instance.client.auth.signOut();
      ProxyService.box.remove(key: 'getDefaultApp');

      // Unset default for all businesses and branches
      final userId = ProxyService.box.getUserId();
      final businessId = ProxyService.box.getBusinessId();
      final branchId = ProxyService.box.getBranchId();

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
            List<Business> businesses =
                await ProxyService.strategy.businesses(userId: userId);
            for (Business business in businesses) {
              if (business.id != businessId) {
                await ProxyService.strategy.updateBusiness(
                  businessId: business.id,
                  isDefault: false,
                );
              }
            }
            List<Branch> branches =
                await ProxyService.strategy.branches(businessId: businessId);
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

      // Remove user-specific data
      ProxyService.box.remove(key: 'userId');
      ProxyService.box.remove(key: 'getIsTokenRegistered');
      ProxyService.box.remove(key: 'defaultApp');

      // Also remove business and branch IDs to ensure clean state for next login
      ProxyService.box.remove(key: 'businessId');
      ProxyService.box.remove(key: 'branchId');
      ProxyService.box.remove(key: 'branchIdString');

      return true;
    } catch (e, s) {
      log(e.toString());
      log(s.toString());
      rethrow;
    }
  }

  /// Ensures that the Realm database is initialized and ready to use.
}
