import 'dart:developer';
import 'dart:io';

import 'package:flipper_models/LocalRealm.dart';
import 'package:flipper_models/helperModels/random.dart';
import 'package:flipper_models/realm/schemas.dart';
import 'package:flipper_services/proxy.dart';
import 'package:firebase_auth/firebase_auth.dart';

mixin CoreMiscellaneous {
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
      ProxyService.box.remove(key: 'userId');
      ProxyService.box.remove(key: 'getIsTokenRegistered');
      ProxyService.box.remove(key: 'bearerToken');
      ProxyService.box.remove(key: 'branchId');
      ProxyService.box.remove(key: 'userPhone');
      ProxyService.box.remove(key: 'UToken');
      ProxyService.box.remove(key: 'businessId');
      ProxyService.box.remove(key: 'defaultApp');

      // but for shared preference we can just clear them all
      /// We do not clear all variable, this is because even on logout
      /// a user log in back and there is values such as tinNumber,bhfId,URI that we will still need to re-use
      /// therefore why the bellow line is commented out.

      await FirebaseAuth.instance.signOut();

      /// refreshing the user token will invalidate any session
      await FirebaseAuth.instance.currentUser?.getIdToken(true);

      await ProxyService.realm.amplifyLogout();

      /// calling close on logout inroduced error where another attempt to login will fail since
      /// the instance of realm is instantiated at app start level.
      // resetDependencies(dispose: true);
      /// wait to sync data for this eod
      // await ProxyService.realm.realm!.syncSession.waitForUpload();

      /// get all business and unset default
      if (ProxyService.local.localRealm != null &&
          ProxyService.box.getBranchId() != null) {
        List<Business> businesses = ProxyService.local.businesses();
        for (Business business in businesses) {
          ProxyService.local.localRealm!.write(() {
            business.isDefault = false;
            business.active = false;
          });
        }
        List<Branch> branches = ProxyService.local.branches();
        for (Branch branch in branches) {
          ProxyService.local.localRealm!.write(() {
            branch.isDefault = false;
            branch.active = false;
          });
        }
      }
      ProxyService.realm.close();
      ProxyService.realm.realm = null;
      ProxyService.local.localRealm = null;
      ProxyService.local.clearData(data: ClearData.Branch);
      ProxyService.local.clearData(data: ClearData.Business);
      return Future.value(true);
    } catch (e, s) {
      log(e.toString());
      log(s.toString());
      rethrow;
    }
  }
}
