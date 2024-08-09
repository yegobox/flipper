import 'dart:convert';

import 'package:flipper_models/LocalRealmAPI.dart';
import 'package:flipper_models/flipper_http_client.dart';
import 'package:flipper_models/helperModels/iuser.dart';

class LocalRealmApiMocked extends LocalRealmApi {
  Future<IUser> login(
      {required String userPhone,
      required bool skipDefaultAppSetup,
      bool stopAfterConfigure = false,
      required HttpClientInterface flipperHttpClient}) async {
    String phoneNumber = userPhone;

    await initializeRealms();

    if (!isEmail(userPhone) && !phoneNumber.startsWith('+')) {
      phoneNumber = '+' + phoneNumber;
    }

    final response =
        await sendLoginRequest(phoneNumber, flipperHttpClient, apihub);

    if (response.statusCode == 200 && response.body.isNotEmpty) {
      final IUser user = IUser.fromJson(json.decode(response.body));

      await configureApp(userPhone, user);
      await configureLocal(useInMemory: false);

      if (stopAfterConfigure) return user;

      if (!skipDefaultAppSetup) {
        await setDefaultApp(user, localRealm: localRealm);
      }

      await updateLocalRealm(user, localRealm: localRealm);

      return user;
    } else {
      await handleLoginError(response);
    }
    throw Exception("Error");
  }
}
