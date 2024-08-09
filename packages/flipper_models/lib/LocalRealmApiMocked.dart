import 'dart:convert';

import 'package:flipper_models/LocalRealmAPI.dart';
import 'package:flipper_models/flipper_http_client.dart';
import 'package:flipper_models/helperModels/iuser.dart';
import 'package:http/http.dart' as http;

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

  @override
  Future<http.Response> sendLoginRequest(String phoneNumber,
      HttpClientInterface flipperHttpClient, String apihub) async {
    return http.Response(
        '{"id": 92273, "phoneNumber": "+250783054002", "token": "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUoGka_EZf", "tenants": [{"id": 6, "name": "User001", "phoneNumber": "+250783054002", "email": null, "imageUrl": null, "permissions": [{"id": 6, "name": "cashier", "userId": 92273}, {"id": 7, "name": "cashier", "userId": 92273}, {"id": 8, "name": "cashier", "userId": 92273}, {"id": 9, "name": "cashier", "userId": 92273}, {"id": 10, "name": "agent", "userId": 92273}], "branches": [{"id": 1, "active": true, "description": "desc", "name": "YHOO", "businessId": 1, "longitude": "0", "latitude": "0", "createdAt": "2024-05-28T07:17:44.073026", "updatedAt": null, "location": null, "isDefault": true, "default": true}], "businesses": [{"id": 1, "name": "YHOO", "currency": "RWF", "categoryId": null, "latitude": "1.1", "longitude": "1.1", "userId": "73268", "timeZone": null, "channels": null, "country": "Rwanda", "businessUrl": null, "hexColor": null, "imageUrl": null, "type": "Business", "referredBy": "Organic", "createdAt": "2024-05-28T07:17:44.073026", "updatedAt": null, "metadata": null, "role": null, "lastSeen": 0, "firstName": null, "lastName": null, "reported": null, "phoneNumber": "+250783054874", "deviceToken": null, "chatUid": null, "backUpEnabled": false, "subscriptionPlan": null, "nextBillingDate": null, "previousBillingDate": null, "isLastSubscriptionPaymentSucceeded": false, "backupFileId": null, "email": null, "lastDbBackup": null, "fullName": "LTD", "referralCode": null, "authId": null, "tinNumber": 999909695, "dvcSrlNo": null, "bhfId": null, "adrs": null, "taxEnabled": false, "isDefault": true, "businessTypeId": 1, "encryptionKey": "201,178,243,98,204,144,173,221,228,137,140,119,15,179,30,93,96,158,227,191,156,138,125,173,216,150,47,67,101,5,75,119,89,250,97,120,146,65,207,127,4,63,194,129,172,227,93,230,253,240,169,127,41,220,150,209,133,119,147,44,113,123,11,114", "default": true, "validCurrency": true, "lastSubscriptionPaymentSucceeded": false}], "businessId": 1, "nfcEnabled": false, "userId": 92273, "pin": 0, "isDefault": false}], "channels": ["92273"], "editId": false, "email": null, "name": null, "isExternal": false, "ownership": "YEGOBOX", "externalLinkId": null, "groupId": 0, "pin": 92273, "uid": null, "external": false}',
        200);
  }

  @override
  Future<String> dbPath({required String path, int? folder}) async {
    return Future.value("null");
  }
}
