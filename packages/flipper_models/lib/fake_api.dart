import 'dart:convert';

import 'package:flipper_services/proxy.dart';

import 'data.loads/jcounter.dart';
import 'isar_api.dart';
import 'isar_models.dart';
import 'package:http/http.dart' as http;

class FakeApi extends IsarAPI implements IsarApiInterface {
  @override
  Future<List<JTenant>> signup({required Map business}) async {
    // Simulating a successful API response
    final http.Response response = http.Response(
        '[{"messageId": 1, "name": "Tenant 1", "businessId": 1642645, "nfcEnabled": true, "email": "tenant1@example.com", "phoneNumber": "${business['phoneNumber']}", "permissions":[{"messageId": 205, "name":"admin"}], "branches":[{"messageId": 232,"active": true,"channels": null,"description": "desc","name": "Test001","businessId": 1642645,"longitude": "0","latitude": "0","table": "branches","createdAt": "2/22/2021","updatedAt": null,"isDefault": true,"tenants": [],"default": true}], "businesses":[{"messageId": 1642645,"name": "Test001","currency": null,"categoryId": null,"latitude": "293.98","longitude": "-344.49","userId": "1651165831880765","typeId": null,"timeZone": null,"channels": null,"table": null,"country": "Rwanda","businessUrl": null,"hexColor": null,"imageUrl": null,"type": "business","referredBy": "Richie","createdAt": "2/22/2021","updatedAt": null,"metadata": null,"role": null,"lastSeen": 0,"firstName": null,"lastName": null,"reported": null,"phoneNumber": "+250783054873","deviceToken": null,"chatUid": null,"backUpEnabled": false,"subscriptionPlan": null,"nextBillingDate": null,"previousBillingDate": null,"isLastSubscriptionPaymentSucceeded": false,"backupFileId": null,"email": null,"lastDbBackup": null,"fullName": "Richie","referralCode": null,"authId": null,"tinNumber": 12222,"dvcSrlNo": "warvsdcoriongatetest","bhfId": "00","adrs": null,"taxEnabled": false,"isDefault": true,"default": true,"lastSubscriptionPaymentSucceeded": false}]}]',
        200);

    if (response.statusCode == 200) {
      for (JTenant tenant in jListTenantFromJson(response.body)) {
        JTenant jTenant = tenant;
        ITenant iTenant = ITenant(
            id: jTenant.id,
            name: jTenant.name,
            businessId: jTenant.businessId,
            nfcEnabled: jTenant.nfcEnabled,
            email: jTenant.email,
            phoneNumber: jTenant.phoneNumber);

        // Simulating a successful write transaction to a local database
        await isar.writeTxn(() async {
          return isar.business.putAll(jTenant.businesses);
        });
        await isar.writeTxn(() async {
          return await isar.branchs.putAll(jTenant.branches);
        });
        await isar.writeTxn(() async {
          return isar.permissions.putAll(jTenant.permissions);
        });
        await isar.writeTxn(() async {
          return isar.iTenants.put(iTenant);
        });
      }
      return jListTenantFromJson(response.body);
    } else {
      // Simulating an internal server error
      throw InternalServerError(term: "internal server error");
    }
  }

  /// because when fake API is used we want to always start from signup
  /// when there is no business we will always get a business not found exception
  @override
  Future<Business> getOnlineBusiness({required String userId}) async {
    throw BusinessNotFoundException(term: "Business not found");
  }

  @override
  Future<IUser> login({required String userPhone}) async {
    final jsonResponse = {
      "messageId": 1651165831880765,
      "phoneNumber": "+250783054874",
      "token": "Bearer ",
      "tenants": [
        {
          "messageId": 49,
          "name": "Richard",
          "phoneNumber": "+250783054874",
          "email": "nyiringabohubert@gmail.com",
          "permissions": [
            {"messageId": 49, "name": "admin"}
          ],
          "branches": [
            {
              "messageId": 76,
              "active": true,
              "channels": null,
              "description": "desc",
              "name": "Richard",
              "businessId": 1642645,
              "longitude": "0",
              "latitude": "0",
              "table": "branches",
              "createdAt": "2021-10-05T19:28:08.612022",
              "updatedAt": null,
              "isDefault": false,
              "default": false
            }
          ],
          "businesses": [
            {
              "messageId": 1642645,
              "name": "FakeBusiness",
              "currency": "USD",
              "categoryId": null,
              "latitude": "1",
              "longitude": "1",
              "userId": "1651165831880765",
              "typeId": null,
              "timeZone": null,
              "channels": null,
              "table": null,
              "country": "United States",
              "businessUrl": null,
              "hexColor": null,
              "imageUrl": null,
              "type": "Business",
              "referredBy": "Organic",
              "createdAt": "2022-03-30T00:00:00.000Z",
              "updatedAt": null,
              "metadata": null,
              "role": null,
              "lastSeen": 0,
              "firstName": null,
              "lastName": null,
              "reported": "true",
              "phoneNumber": "+1234567890",
              "deviceToken": null,
              "chatUid": null,
              "backUpEnabled": false,
              "subscriptionPlan": null,
              "nextBillingDate": null,
              "previousBillingDate": null,
              "isLastSubscriptionPaymentSucceeded": false,
              "backupFileId": null,
              "email": "fake@business.com",
              "lastDbBackup": null,
              "fullName": "Fake Business",
              "referralCode": null,
              "authId": null,
              "tinNumber": 123456,
              "dvcSrlNo": null,
              "bhfId": null,
              "adrs": null,
              "taxEnabled": false,
              "isDefault": true,
              "default": true,
              "businessTypeId": 1,
              "lastSubscriptionPaymentSucceeded": false
            }
          ],
          "businessId": 0,
          "nfcEnabled": false
        }
      ],
      "channels": ["1651165831880765"]
    };
    final response = http.Response(jsonEncode(jsonResponse), 200);
    if (response.statusCode == 200) {
      await ProxyService.box.write(
        key: 'bearerToken',
        value: IUser.fromRawJson(response.body).token,
      );
      await ProxyService.box.write(
        key: 'defaultApp',
        value: IUser.fromRawJson(response.body)
            .tenants
            .first
            .businesses
            .first
            .businessTypeId,
      );
      await ProxyService.box.write(
        key: 'userId',
        value: IUser.fromRawJson(response.body).id,
      );
      await ProxyService.box.write(
        key: 'userPhone',
        value: "+250783054874",
      );
      if (IUser.fromRawJson(response.body).tenants.isEmpty) {
        throw TenantNotFoundException(term: "No tenant added to the user");
      }
      await isar.writeTxn(() async {
        return isar.business
            .putAll(IUser.fromRawJson(response.body).tenants.first.businesses);
      });
      await isar.writeTxn(() async {
        return isar.branchs
            .putAll(IUser.fromRawJson(response.body).tenants.first.branches);
      });

      return IUser.fromRawJson(response.body);
    } else if (response.statusCode == 401) {
      throw SessionException(term: "session expired");
    } else if (response.statusCode == 500) {
      throw ErrorReadingFromYBServer(term: "Not found");
    } else {
      throw Exception('403 Error');
    }
  }

  @override
  Future<List<ITenant>> tenantsFromOnline({required int businessId}) async {
    // Create a fake response JSON
    final responseJson = [
      {
        "messageId": 1,
        "name": "FakeTenant",
        "phoneNumber": "+1234567890",
        "email": "fake@tenant.com",
        "permissions": [
          {"messageId": 1, "name": "admin"}
        ],
        "branches": [
          {
            "messageId": 232,
            "active": true,
            "channels": null,
            "description": "Fake branch",
            "name": "FakeBranch",
            "businessId": 1642636,
            "longitude": "0",
            "latitude": "0",
            "table": "branches",
            "createdAt": "2022-03-30T00:00:00.000Z",
            "updatedAt": null,
            "isDefault": true,
            "default": true
          }
        ],
        "businesses": [
          {
            "messageId": 1642636,
            "name": "FakeBusiness",
            "currency": "USD",
            "categoryId": null,
            "latitude": "1",
            "longitude": "1",
            "userId": "1651165831880765",
            "typeId": null,
            "timeZone": null,
            "channels": null,
            "table": null,
            "country": "United States",
            "businessUrl": null,
            "hexColor": null,
            "imageUrl": null,
            "type": "Business",
            "referredBy": "Organic",
            "createdAt": "2022-03-30T00:00:00.000Z",
            "updatedAt": null,
            "metadata": null,
            "role": null,
            "lastSeen": 0,
            "firstName": null,
            "lastName": null,
            "reported": "true",
            "phoneNumber": "+1234567890",
            "deviceToken": null,
            "chatUid": null,
            "backUpEnabled": false,
            "subscriptionPlan": null,
            "nextBillingDate": null,
            "previousBillingDate": null,
            "isLastSubscriptionPaymentSucceeded": false,
            "backupFileId": null,
            "email": "fake@business.com",
            "lastDbBackup": null,
            "fullName": "Fake Business",
            "referralCode": null,
            "authId": null,
            "tinNumber": 123456,
            "dvcSrlNo": null,
            "bhfId": null,
            "adrs": null,
            "taxEnabled": false,
            "isDefault": true,
            "default": true,
            "lastSubscriptionPaymentSucceeded": false
          }
        ],
        "businessId": 1,
        "nfcEnabled": false
      }
    ];
    final response = http.Response(jsonEncode(responseJson), 200);
    if (response.statusCode == 200) {
      for (JTenant tenant in jListTenantFromJson(response.body)) {
        JTenant jTenant = tenant;
        ITenant iTenant = ITenant(
            id: jTenant.id,
            name: jTenant.name,
            businessId: jTenant.businessId,
            nfcEnabled: jTenant.nfcEnabled,
            email: jTenant.email,
            phoneNumber: jTenant.phoneNumber);

        isar.writeTxn(() async {
          await isar.business.putAll(jTenant.businesses);
          await isar.branchs.putAll(jTenant.branches);
          await isar.permissions.putAll(jTenant.permissions);
        });
        isar.writeTxn(() async {
          await isar.iTenants.put(iTenant);
        });
      }
      return await isar.iTenants
          .filter()
          .businessIdEqualTo(businessId)
          .findAll();
    }
    throw InternalServerException(term: "we got unexpected response");
  }

  @override
  Future<void> loadCounterFromOnline({required int businessId}) async {
    final responseJson = [
      {
        "messageId": 11,
        "businessId": 1642645,
        "branchId": 232,
        "receiptType": "NS",
        "totRcptNo": 0,
        "curRcptNo": 0
      },
      {
        "messageId": 12,
        "businessId": 1642645,
        "branchId": 232,
        "receiptType": "TS",
        "totRcptNo": 0,
        "curRcptNo": 0
      },
      {
        "messageId": 13,
        "businessId": 1642645,
        "branchId": 232,
        "receiptType": "NR",
        "totRcptNo": 0,
        "curRcptNo": 0
      },
      {
        "messageId": 14,
        "businessId": 1642645,
        "branchId": 232,
        "receiptType": "CS",
        "totRcptNo": 0,
        "curRcptNo": 0
      },
      {
        "messageId": 15,
        "businessId": 1642645,
        "branchId": 232,
        "receiptType": "PS",
        "totRcptNo": 0,
        "curRcptNo": 0
      }
    ];
    final response = http.Response(jsonEncode(responseJson), 200);
    if (response.statusCode == 200) {
      List<JCounter> counters = jCounterFromJson(response.body);
      for (JCounter jCounter in counters) {
        await isar.writeTxn(() async {
          return isar.counters.put(Counter()
            ..branchId = jCounter.branchId
            ..businessId = jCounter.businessId
            ..receiptType = jCounter.receiptType
            ..id = jCounter.id
            ..backed = true
            ..totRcptNo = jCounter.totRcptNo
            ..curRcptNo = jCounter.curRcptNo);
        });
      }
    } else {
      throw InternalServerError(term: "Error loading the counters");
    }
  }

  @override
  Future<T?> update<T>({required T data}) async {
    // int branchId = ProxyService.box.getBranchId()!;
    if (data is Product) {
      Product product = data;

      await isar.writeTxn(() async {
        return await isar.products.put(product);
      });
    }
    if (data is Variant) {
      Variant variant = data;
      await isar.writeTxn(() async {
        return await isar.variants.put(variant);
      });
    }
    if (data is Stock) {
      Stock stock = data;
      await isar.writeTxn(() async {
        return await isar.stocks.put(stock);
      });
    }
    if (data is Order) {
      final order = data;
      await isar.writeTxn(() async {
        return await isar.orders.put(order);
      });
    }
    if (data is Category) {
      final order = data;
      await isar.writeTxn(() async {
        return await isar.categorys.put(order);
      });
    }
    if (data is IUnit) {
      final unit = data;
      await isar.writeTxn(() async {
        return await isar.iUnits.put(unit);
      });
    }
    if (data is PColor) {
      final color = data;
      await isar.writeTxn(() async {
        return await isar.pColors.put(color);
      });
    }
    if (data is OrderItem) {
      await isar.writeTxn(() async {
        return await isar.orderItems.put(data);
      });
    }
    if (data is Ebm) {
      final ebm = data;
      await isar.writeTxn(() async {
        ProxyService.box.write(key: "serverUrl", value: ebm.taxServerUrl);
        Business? business =
            await isar.business.where().userIdEqualTo(ebm.userId).findFirst();
        business
          ?..dvcSrlNo = ebm.dvcSrlNo
          ..tinNumber = ebm.tinNumber
          ..bhfId = ebm.bhfId
          ..taxServerUrl = ebm.taxServerUrl
          ..taxEnabled = true;
        return await isar.business.put(business!);
      });
    }
    if (data is Token) {
      final token = data;
      await isar.writeTxn(() async {
        Token? ttoken =
            await isar.tokens.where().userIdEqualTo(token.userId).findFirst();
        if (ttoken == null) {
          ttoken = Token()
            ..token = token.token
            ..userId = token.userId
            ..type = token.type;
          return await isar.tokens.put(ttoken);
        } else {
          ttoken
            ..token = token.token
            ..userId = token.userId
            ..type = token.type;
          return await isar.tokens.put(ttoken);
        }
      });
    }
    if (data is Business) {
      final business = data;
      await isar.writeTxn(() async {
        return await isar.business.put(business);
      });
    }
    if (data is Branch) {
      isar.writeTxn(() async {
        return await isar.branchs.put(data);
      });
    }
    if (data is Counter) {
      await isar.writeTxn(() async {
        return isar.counters.put(data..backed = false);
      });
    }
    if (data is Branch) {
      isar.writeTxn(() async {
        return await isar.branchs.put(data);
      });
    }
    if (data is Drawers) {
      final drawer = data;
      await isar.writeTxn(() async {
        return await isar.drawers.put(drawer);
      });
    }
    if (data is ITenant) {
      return null;
    }
    return null;
  }

  @override
  Future<List<BusinessType>> businessTypes() async {
    final responseJson = [
      {"messageId": 1, "typeName": "Supplier"},
      {"messageId": 2, "typeName": "Customer Support"},
      {"messageId": 3, "typeName": "Retailer"},
      {"messageId": 4, "typeName": "Agent"}
    ];
    Future.delayed(Duration(seconds: 5));
    final response = http.Response(jsonEncode(responseJson), 200);
    if (response.statusCode == 200) {
      return BusinessType.fromJsonList(jsonEncode(responseJson));
    }
    return BusinessType.fromJsonList(jsonEncode(responseJson));
  }

  @override
  Stream<List<Conversation>> conversations({String? messageId}) async* {
    // https://randomuser.me/api/portraits/men/3.jpg
    final responseJson = [
      {
        "messageId": "1",
        "name": "Charlie",
        "body": "Hey, whats up?",
        "avatar": "assets/a.png",
        "source": "assets/whatsapp.png",
        "toNumber": "250783054874",
        "fromNumber": "250788360058",
        "createdAt": "11/3/2024"
      },
      {
        "messageId": "2",
        "name": "Bob",
        "body": "Hello, nice to meet you.",
        "avatar": "assets/b.png",
        "source": "assets/instagram.png",
        "toNumber": "250788360058",
        "fromNumber": "250783054874",
        "createdAt": "11/3/2024"
      },
      {
        "messageId": "3",
        "name": "Alice",
        "body": "Hi, how are you?",
        "avatar": "assets/c.png",
        "source": "assets/whatsapp.png",
        "toNumber": "250783054874",
        "fromNumber": "250788360058",
        "createdAt": "11/3/2024"
      },
    ];
    if (messageId != null) {
      // build avatar given the conversationId
      String? avatar;
      String? source;
      String? message;
      if (messageId == "1") {
        avatar = "assets/a.png";
        source = "assets/whatsapp.png";
        message = "Hey, whats up?";
      }
      if (messageId == "2") {
        avatar = "assets/b.png";
        source = "assets/instagram.png";
        message = "Hello, nice to meet you.";
      }
      if (messageId == "3") {
        avatar = "assets/c.png";
        source = "assets/whatsapp.png";
        message = "Hi, how are you?";
      }
      final json = [
        {
          "messageId": messageId,
          "name": "Bob",
          "body": message,
          "avatar": avatar,
          "source": source,
          "toNumber": "250788360058",
          "fromNumber": "250783054874",
          "createdAt": "11/3/2024"
        },
        {
          "messageId": messageId,
          "name": "Bob",
          "body": message,
          "avatar": avatar,
          "source": source,
          "toNumber": "250783054874",
          "fromNumber": "250788360058",
          "createdAt": "11/3/2024"
        },
      ];
      final response = http.Response(jsonEncode(json), 200);
      if (response.statusCode == 200) {
        yield Conversation.fromJsonList(jsonEncode(json));
      } else {
        throw Exception();
      }
    } else {
      final response = http.Response(jsonEncode(responseJson), 200);
      if (response.statusCode == 200) {
        yield Conversation.fromJsonList(jsonEncode(responseJson));
      } else {
        throw Exception();
      }
    }
  }

  @override
  Future<Conversation> sendMessage({String? conversationId}) {
    // TODO: implement sendMessage
    throw UnimplementedError();
  }
}
