import 'dart:io';

import 'package:flipper_models/helperModels/random.dart';
import 'package:flipper_services/proxy.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';

mixin CoreMiscellaneous {
  Future<bool> logOut() async {
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
    ProxyService.realm.close();
    ProxyService.realm.realm = null;
    return Future.value(true);
  }
}

mixin Miscellaneous<T extends ConsumerStatefulWidget>
    on ConsumerState<T>, CoreMiscellaneous {
  // Your mixin implementation here
}
