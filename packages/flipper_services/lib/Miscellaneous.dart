import 'dart:developer';
import 'dart:io';

import 'package:flipper_models/helperModels/random.dart';
import 'package:flipper_services/proxy.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:supabase_models/supabase_models.dart';

mixin CoreMiscellaneous {
  Future<bool> isServerUp() async {
    final url = await ProxyService.box.getServerUrl() ?? "https://example.com";
    final response = await http.get(Uri.parse(url));
    return response.statusCode == 404;
  }

  Future<Directory> getSupportDir() async {
    Directory appSupportDir;
    if (Platform.isAndroid) {
      // Try to get external storage, fall back to internal if not available
      appSupportDir = await getApplicationCacheDirectory();
    } else {
      appSupportDir = await getApplicationSupportDirectory();
    }
    return appSupportDir;
  }

  Future<bool> logOut() async {
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
          'uid': (await FirebaseAuth.instance.currentUser?.getIdToken()) ?? "",
          'deviceVersion': Platform.operatingSystemVersion,
          'linkingCode': randomNumber().toString()
        });
      }

      // but for shared preference we can just clear them all
      /// We do not clear all variable, this is because even on logout
      /// a user log in back and there is values such as tinNumber,bhfId,URI that we will still need to re-use
      /// therefore why the bellow line is commented out.

      // await FirebaseAuth.instance.signOut();

      /// refreshing the user token will invalidate any session
      await FirebaseAuth.instance.signOut();

      ProxyService.strategy.whoAmI();

      await ProxyService.strategy.amplifyLogout();

      /// calling close on logout inroduced error where another attempt to login will fail since
      /// the instance of realm is instantiated at app start level.
      // resetDependencies(dispose: true);
      /// wait to sync data for this eod
      // await ProxyService.strategy.realm!.syncSession.waitForUpload();

      /// get all business and unset default
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
      ProxyService.box.remove(key: 'userId');
      ProxyService.box.remove(key: 'getIsTokenRegistered');
      ProxyService.box.remove(key: 'defaultApp');
      return Future.value(true);
    } catch (e, s) {
      log(e.toString());
      log(s.toString());
      rethrow;
    }
  }

  /// Ensures that the Realm database is initialized and ready to use.
}
