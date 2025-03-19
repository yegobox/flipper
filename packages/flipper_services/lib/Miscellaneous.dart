import 'dart:developer';
import 'dart:io';

import 'package:flipper_models/helperModels/random.dart';
import 'package:flipper_services/proxy.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:supabase_models/supabase_models.dart';

// Define the interface
abstract class CoreMiscellaneousInterface {
  Future<bool> isServerUp();
  Future<Directory> getSupportDir();
  Future<bool> logOut();
  bool isTestEnvironment();
}

// Implement the interface in a mixin
mixin CoreMiscellaneous implements CoreMiscellaneousInterface {
  @override
  Future<bool> isServerUp() async {
    try {
      final url =
          await ProxyService.box.getServerUrl() ?? "https://example.com";
      final response = await http.get(Uri.parse(url));
      return response.statusCode ==
          200; // changed from 404 because 200 is typical for a server being up
    } catch (e) {
      // Handle network errors or other issues
      print("Error checking server status: $e");
      return false; // Assume server is down on error
    }
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

  // Non-static logout method
  static Future<bool> logoutStatic() async {
    return await _performLogout();
  }

  // Private helper method to reuse logout logic
  static Future<bool> _performLogout() async {
    final isTestEnvironment =
        const bool.fromEnvironment('FLUTTER_TEST_ENV') == true;
    try {
      ProxyService.box.remove(key: 'authComplete');
      if (ProxyService.box.getUserId() != null &&
          ProxyService.box.getBusinessId() != null) {
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
          'deviceVersion': Platform.operatingSystemVersion,
          'linkingCode': randomNumber().toString()
        });
      }

      // Sign out from Firebase
      if (!const bool.fromEnvironment('FLUTTER_TEST_ENV',
          defaultValue: false)) {
        await FirebaseAuth.instance.signOut();
      }

      // Perform additional logout operations
      ProxyService.strategy.whoAmI();
      await ProxyService.strategy.amplifyLogout();

      // Unset default for all businesses and branches
      if (ProxyService.box.getBranchId() != null) {
        List<Business> businesses = await ProxyService.strategy
            .businesses(userId: ProxyService.box.getUserId() ?? 0);
        for (Business business in businesses) {
          ProxyService.strategy.updateBusiness(
            businessId: business.serverId,
            active: false,
            isDefault: false,
          );
        }
        List<Branch> branches = await ProxyService.strategy
            .branches(businessId: ProxyService.box.getBusinessId() ?? 0);
        for (Branch branch in branches) {
          ProxyService.strategy.updateBranch(
            branchId: branch.serverId!,
            active: false,
            isDefault: false,
          );
        }
      }

      // Remove user-specific data
      ProxyService.box.remove(key: 'userId');
      ProxyService.box.remove(key: 'getIsTokenRegistered');
      ProxyService.box.remove(key: 'defaultApp');

      return true;
    } catch (e, s) {
      log(e.toString());
      log(s.toString());
      rethrow;
    }
  }

  /// Ensures that the Realm database is initialized and ready to use.
}
